"""Portfolio reproducibility and public-data boundary checks."""
from pathlib import Path
import re
import unittest

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "listings.csv"
CLEAN = ROOT / "data" / "processed" / "boston_airbnb_cleaned.csv"
PUBLIC = ROOT / "data" / "public" / "boston_airbnb_aggregated.csv"
MIN_GROUP_SIZE = 10


class PublicArtifactTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.frame = pd.read_csv(PUBLIC)

    def test_allowlisted_fields_only(self):
        self.assertEqual(
            list(self.frame.columns),
            [
                "neighbourhood_cleansed", "room_type", "listings",
                "avg_price_usd", "median_price_usd", "avg_availability_365"
            ],
        )

    def test_group_suppression(self):
        self.assertFalse(self.frame.empty)
        self.assertTrue((self.frame["listings"] >= MIN_GROUP_SIZE).all())

    def test_no_duplicate_groups(self):
        self.assertFalse(
            self.frame.duplicated(["neighbourhood_cleansed", "room_type"]).any()
        )

    def test_no_identifiers_or_coordinates(self):
        prohibited = {"id", "host_id", "latitude", "longitude", "name", "reviewer_id"}
        self.assertTrue(prohibited.isdisjoint(self.frame.columns))

    def test_sql_query_inventory(self):
        sql = (ROOT / "sql" / "analysis_queries.sql").read_text(encoding="utf-8")
        labels = re.findall(r"^-- QUERY: (Q\d{2}_[A-Z0-9_]+)$", sql, re.MULTILINE)
        self.assertEqual(len(labels), 15)
        self.assertEqual(len(set(labels)), 15)


@unittest.skipUnless(CLEAN.is_file(), "Cleaned local dataset not available")
class SourceOfTruthTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.frame = pd.read_csv(CLEAN)

    def test_dimensions_and_listing_uniqueness(self):
        self.assertEqual(self.frame.shape, (3585, 43))
        self.assertEqual(self.frame["id"].nunique(), 3585)

    def test_recorded_kpis(self):
        self.assertAlmostEqual(self.frame["price_usd"].mean(), 173.9258019525802, places=4)
        self.assertEqual(self.frame["price_usd"].median(), 150.0)
        self.assertAlmostEqual(
            self.frame["review_scores_rating"].mean(), 91.91666666666667, places=4
        )
        self.assertEqual(int(self.frame["number_of_reviews"].sum()), 68275)

    def test_public_summary_consistent_with_private_source(self):
        from scripts.build_public_dataset import MIN_GROUP_SIZE, build_public_dataset
        from tempfile import TemporaryDirectory

        with TemporaryDirectory() as tmp:
            generated = build_public_dataset(CLEAN, Path(tmp) / "summary.csv")
            expected = self.frame.groupby(
                ["neighbourhood_cleansed", "room_type"], dropna=False
            ).size()
            self.assertEqual(
                int(generated["listings"].sum()),
                int(expected[expected >= MIN_GROUP_SIZE].sum()),
            )
            # Numeric equality ignores CSV float formatting only.
            published = pd.read_csv(PUBLIC)
            pd.testing.assert_frame_equal(
                generated.reset_index(drop=True), published,
                check_dtype=False, check_exact=False, atol=0.011, rtol=0
            )


@unittest.skipUnless(RAW.is_file(), "Historical raw source not available")
class SourceChecksumTests(unittest.TestCase):
    def test_original_snapshot_hash(self):
        from scripts.verify_source import verify_source
        self.assertEqual(len(verify_source(RAW)), 64)


if __name__ == "__main__":
    unittest.main()
