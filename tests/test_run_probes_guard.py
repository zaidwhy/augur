"""run_probes.ps1 must never overwrite an archived transcript by accident.

The committed probes-*.md files are the unedited evidence behind the Zenodo deposit; the
script refuses an existing -OutFile (unless -Force) before it calls any model.
"""

from __future__ import annotations

import shutil
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
PWSH = shutil.which("pwsh") or shutil.which("powershell")

pytestmark = pytest.mark.skipif(PWSH is None, reason="PowerShell not installed")


def test_existing_outfile_is_refused_and_left_untouched(tmp_path):
    out = tmp_path / "probes-archived.md"
    out.write_text("archived evidence\n", encoding="utf-8")
    result = subprocess.run(
        [PWSH, "-NoProfile", "-NonInteractive", "-File", str(ROOT / "run_probes.ps1"),
         "-Model", "no-such-model", "-OutFile", str(out)],
        capture_output=True, text=True, timeout=120, check=False,
    )
    assert result.returncode != 0
    assert "already exists" in (result.stdout + result.stderr)
    assert out.read_text(encoding="utf-8") == "archived evidence\n"
