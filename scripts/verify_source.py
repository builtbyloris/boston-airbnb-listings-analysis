#!/usr/bin/env python3
"""Fail if the raw Kaggle snapshot differs from the documented source file."""
import hashlib
from pathlib import Path

RAW = Path(__file__).resolve().parents[1] / "data" / "raw" / "listings.csv"
EXPECTED_SHA256 = "9c2fa5db20b0d1018cb558750aeb276599ea877e1e0c1ae315766a032d78881f"

def verify_source(path: Path = RAW) -> str:
    if not path.is_file():
        raise FileNotFoundError(f"Missing raw dataset: {path}")
    digest = hashlib.file_digest(path.open("rb"), "sha256").hexdigest()
    if digest != EXPECTED_SHA256:
        raise ValueError(
            f"Source checksum mismatch ({digest}); obtain the documented 2016 snapshot"
        )
    return digest

if __name__ == "__main__":
    print("Verified raw SHA-256:", verify_source())
