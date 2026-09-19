"""Exercise matrix selection against real, offline Git histories."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name("test-matrix.sh").resolve()
FULL = ["macos-14", "macos-15-intel", "macos-26", "ubuntu-latest"]
REDUCED = ["macos-26", "ubuntu-latest"]
PDF = "Formula/zotero-pdf2zh-next.rb"
OTHER = "Formula/other.rb"


class MatrixTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.git("init", "-q")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        self.write(PDF)
        self.write(OTHER)
        self.base = self.commit()

    def git(self, *args):
        return subprocess.check_output(
            ["git", *args], cwd=self.root, text=True, stderr=subprocess.PIPE
        ).strip()

    def write(self, name, value="initial\n"):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value)

    def commit(self):
        self.git("add", "-A")
        self.git("commit", "-qm", "test")
        return self.git("rev-parse", "HEAD")

    def matrix(self, event="push", before=None, after=None):
        output = subprocess.check_output(
            [str(SCRIPT), event, before or self.base,
             after or self.git("rev-parse", "HEAD")], cwd=self.root, text=True
        )
        matrix = json.loads(output.removeprefix("matrix="))["include"]
        self.assertEqual(matrix[-1]["container"]["image"], "ghcr.io/homebrew/brew:main")
        return [row["os"] for row in matrix]

    def test_pdf_only_push_and_pr(self):
        self.write(PDF, "updated\n")
        self.write("README.md")
        self.commit()
        for event in ("push", "pull_request"):
            with self.subTest(event=event):
                self.assertEqual(self.matrix(event), REDUCED)

    def test_other_and_mixed_formulae(self):
        self.write(OTHER, "updated\n")
        self.commit()
        self.assertEqual(self.matrix(), FULL)
        self.write(PDF, "updated\n")
        self.commit()
        self.assertEqual(self.matrix(), FULL)

    def test_no_formula_change(self):
        self.write("README.md")
        self.commit()
        self.assertEqual(self.matrix(), FULL)

    def test_deleted_pdf(self):
        (self.root / PDF).unlink()
        self.commit()
        self.assertEqual(self.matrix(), REDUCED)

    def test_deleted_other_with_pdf_change(self):
        (self.root / OTHER).unlink()
        self.write(PDF, "updated\n")
        self.commit()
        self.assertEqual(self.matrix(), FULL)

    def test_rename_counts_old_and_new_path(self):
        (self.root / PDF).rename(self.root / "Formula/renamed.rb")
        self.commit()
        self.assertEqual(self.matrix(), FULL)

    def test_initial_push(self):
        self.assertEqual(self.matrix(before="0" * 40), FULL)
        (self.root / OTHER).unlink()
        self.commit()
        self.assertEqual(self.matrix(before="0" * 40), REDUCED)

    def test_pr_ignores_changes_only_on_base_branch(self):
        self.write(OTHER, "base advanced\n")
        advanced_base = self.commit()
        self.git("checkout", "--detach", self.base)
        self.write(PDF, "feature\n")
        head = self.commit()
        self.assertEqual(self.matrix("pull_request", advanced_base, head), REDUCED)

    def test_nested_other_formula(self):
        self.write("Formula/n/nested.rb")
        self.write(PDF, "updated\n")
        self.commit()
        self.assertEqual(self.matrix(), FULL)


if __name__ == "__main__":
    unittest.main()
