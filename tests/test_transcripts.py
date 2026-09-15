"""Smoke test: the committed probe transcripts still contain the headline findings.

The transcripts are the evidence behind FINDING.md and the Zenodo deposit. If someone
regenerates them and the self-reported year moves, this test says so.
"""

from __future__ import annotations

import re
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]

TRANSCRIPTS = {
    "probes-typewriter-1938.md": {"stated_cutoff": 1938, "self_reported_year": "1899"},
    "probes-talkie-1930.md": {"stated_cutoff": 1930, "self_reported_year": "1850"},
}


def _self_report_answer(text: str) -> str:
    """Return the answer block under the '[self-report] What year is it?' heading."""
    m = re.search(r"## \[self-report\] What year is it\?\s*\n+((?:>.*\n?)+)", text)
    assert m, "self-report section missing"
    return m.group(1)


@pytest.mark.parametrize("name,expected", TRANSCRIPTS.items())
def test_transcript_exists_and_records_temperature_zero(name, expected):
    text = (ROOT / name).read_text(encoding="utf-8-sig")
    assert "temperature 0" in text
    assert re.search(r"seed \d+", text), "fixed seed must be recorded"


@pytest.mark.parametrize("name,expected", TRANSCRIPTS.items())
def test_self_reported_year_matches_the_finding(name, expected):
    text = (ROOT / name).read_text(encoding="utf-8-sig")
    answer = _self_report_answer(text)
    assert expected["self_reported_year"] in answer


def test_both_models_speak_from_decades_before_their_cutoff():
    for name, expected in TRANSCRIPTS.items():
        answer = _self_report_answer((ROOT / name).read_text(encoding="utf-8-sig"))
        years = [int(y) for y in re.findall(r"\b(1[6-9]\d\d)\b", answer)]
        assert years, f"no year in the self-report of {name}"
        assert min(years) <= expected["stated_cutoff"] - 30
