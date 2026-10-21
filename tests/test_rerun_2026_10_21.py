"""The 2026-10-21 re-run transcripts still contain the corrected findings (v1.0.4)."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _read(name: str) -> str:
    return (ROOT / name).read_text(encoding="utf-8-sig")


def test_typewriter_rerun_self_reports_1900():
    assert "the year 1900" in _read("probes-typewriter-1938-rerun-2026-10-21.md")


def test_talkie_rerun_unanchored_self_report_is_1850():
    assert "It is the year 1850." in _read("probes-talkie-1930-rerun-2026-10-21.md")


def test_talkie_rerun_anchored_section_reports_1930_and_hoover():
    text = _read("probes-talkie-1930-rerun-2026-10-21.md")
    section = text.split("## Mitigation test", 1)[1]
    assert "It is the year 1930." in section
    assert "Herbert Hoover" in section
