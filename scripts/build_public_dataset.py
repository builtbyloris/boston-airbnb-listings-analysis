#!/usr/bin/env python3
"""Create a coarse public summary without publishing listing/host identifiers."""
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "data" / "processed" / "boston_airbnb_cleaned.csv"
OUTPUT = ROOT / "data" / "public" / "boston_airbnb_aggregated.csv"
MIN_GROUP_SIZE = 10

def build_public_dataset(source: Path = SOURCE, output: Path = OUTPUT) -> pd.DataFrame:
    if not source.is_file():
        raise FileNotFoundError(
            f"{source} not found; reproduce the cleaned dataset from the historical Kaggle source first"
        )

    frame = pd.read_csv(source, low_memory=False)
    fields = {"neighbourhood_cleansed", "room_type", "price_usd", "availability_365"}
    missing = fields - set(frame.columns)
    if missing:
        raise ValueError(f"Cleaned data lacks required columns: {sorted(missing)}")

    public = (
        frame.groupby(["neighbourhood_cleansed", "room_type"], dropna=False)
        .agg(
            listings=("price_usd", "size"),
            avg_price_usd=("price_usd", "mean"),
            median_price_usd=("price_usd", "median"),
            avg_availability_365=("availability_365", "mean"),
        )
        .reset_index()
    )
    public = public.loc[public["listings"] >= MIN_GROUP_SIZE].copy()
    public = public.sort_values(["neighbourhood_cleansed", "room_type"])
    for field in ("avg_price_usd", "median_price_usd", "avg_availability_365"):
        public[field] = public[field].round(2)

    output.parent.mkdir(parents=True, exist_ok=True)
    public.to_csv(output, index=False, float_format="%.2f")
    return public

if __name__ == "__main__":
    result = build_public_dataset()
    print(f"Public groups: {len(result)}")
    print(f"Listings represented: {result['listings'].sum():,}")
    print(f"Wrote: {OUTPUT}")
