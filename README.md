# Boston Airbnb Listings Analysis

A reproducible Data Analytics project based on the **Boston Airbnb Open Data** listings snapshot.

The project focuses on pricing, listing mix, neighbourhoods, availability, reviews and host/listing characteristics. It is intentionally designed as a portfolio-ready Junior Data Analyst project using **Python, Pandas, NumPy and SQL** without unnecessary complexity.

## Dataset

- **Kaggle dataset:** Boston Airbnb Open Data — https://www.kaggle.com/datasets/airbnb/boston
- **Acknowledged source on Kaggle:** Airbnb Inside / Inside Airbnb
- **File used:** `listings.csv`
- **Snapshot:** all records have `last_scraped = 2016-09-07`
- **Raw shape:** 3,585 rows × 95 columns
- **Cleaned shape:** 3,585 rows × 43 columns
- **Rows removed:** **0**
- **Kaggle license:** **CC0: Public Domain** for this dataset version, as shown on the Kaggle dataset card
- **Raw SHA-256:** `9c2fa5db20b0d1018cb558750aeb276599ea877e1e0c1ae315766a032d78881f`

> The dataset is historical. Findings describe this 2016 snapshot and should not be presented as the current Boston Airbnb market.

## Distribution, privacy and licensing

- **Source:** [Boston Airbnb Open Data (Kaggle)](https://www.kaggle.com/datasets/airbnb/boston).
- **Dataset-card license:** [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/), as stated for the referenced Kaggle version.
- **Snapshot:** 2016-09-07. No claim is made about the current rental market.
- **Raw and cleaned listing-level files:** used locally for the analysis and **not tracked in the current Git tree**.
- **Public artifact:** [data/public/boston_airbnb_aggregated.csv](data/public/boston_airbnb_aggregated.csv), aggregated by neighbourhood and room type, with groups of fewer than 10 listings excluded. It has no listing or host identifiers, no addresses, and no coordinates.
- **Privacy:** aggregation and suppression reduce exposure but do not guarantee anonymity. CC0 does not replace a privacy or third-party-rights assessment.
- **Historical copies:** earlier Git commits contain the raw and cleaned CSVs. Removing them from the current tree **does not delete repository history or third-party copies**. No history rewrite is performed here.
- **Code license:** no open-source license has been selected for the original analysis code. The dataset's CC0 designation does not license that code.

The aggregated CSV is a separate **distribution artifact**, not an alternative source of truth for the existing analysis or dashboard. The databyloris production deployment and Supabase contents are managed separately and are not changed by commits to this repository.

## Business objective

Use one cleaned source-of-truth dataset to answer practical questions about:

1. How listings are distributed across room types and neighbourhoods.
2. How nightly price differs across room types, neighbourhoods and property types.
3. How listing capacity relates descriptively to price.
4. How availability differs across listing segments.
5. How review scores and review volume vary across segments.
6. How superhost and instant-bookable listings compare descriptively.
7. Which cancellation policies are most common and how their prices differ.
8. How concentrated listings are among hosts.

No causal claims are made. `availability_365` is treated as reported availability, **not** as an occupancy rate.

## Repository structure

```text
boston-airbnb-listings-analysis/
├── data/
│   ├── public/
│   │   ├── README.md
│   │   └── boston_airbnb_aggregated.csv
│   ├── raw/                  # downloaded locally, not tracked
│   └── processed/            # generated locally, not tracked
├── scripts/
│   ├── build_public_dataset.py
│   └── verify_source.py
├── tests/
│   └── test_project.py
├── notebooks/
│   ├── 01_data_audit.ipynb
│   ├── 02_data_cleaning.ipynb
│   └── 03_eda_analysis.ipynb
├── sql/
│   ├── analysis_queries.sql
│   └── run_queries.py
├── reports/
│   ├── data_dictionary.md
│   ├── data_quality.md
│   ├── dashboard_design.md
│   └── insights.md
├── .gitignore
├── README.md
└── requirements.txt
```

## Cleaning strategy

The raw file is preserved unchanged **locally** in `data/raw/` and is excluded from the current Git tree.

No rows are deleted and no missing values are imputed. The processed dataset keeps 43 analysis-relevant columns and applies only deterministic type conversions:

- `price` → `price_usd`
- `cleaning_fee` → `cleaning_fee_usd`
- `extra_people` → `extra_people_usd`
- `host_response_rate` → `host_response_rate_pct`
- `host_acceptance_rate` → `host_acceptance_rate_pct`
- `t/f` values in selected boolean fields → `True/False`

Currency symbols, commas and percent signs are removed only to create numeric fields. Every non-null value in these converted source columns parses successfully. Missing values remain missing.

The following raw columns are completely empty and are intentionally excluded from the cleaned dataset: `neighbourhood_group_cleansed`, `has_availability`, `license`, `jurisdiction_names`.

## Core KPIs

| KPI | Value |
|---|---:|
| Total listings | 3,585 |
| Median nightly price | $150.00 |
| Average nightly price | $173.93 |
| Average review rating | 91.92/100 |
| Rated listings | 2,772 |
| Average availability | 179.35 days/year |
| Total reviews | 68,275 |

## Verified highlights

- **Entire home/apt** represents 59.3% of listings and has a median price of **$199**, versus **$80** for private rooms and **$60** for shared rooms.
- The five neighbourhoods with the most listings are **Jamaica Plain, South End, Back Bay, Fenway, Dorchester**.
- Among neighbourhoods with at least 20 listings, the highest median prices are **South Boston Waterfront ($245)**, **Downtown ($225)** and **Chinatown ($219)**.
- Superhost listings are 11.4% of the snapshot. Rated superhost listings average **97.08/100** versus **91.06/100** for non-superhost listings. This is descriptive and does not establish causality.
- Instant-bookable listings are 16.6% of the snapshot and have a median price of **$125**, compared with **$150** for non-instant-bookable listings.

See [`reports/insights.md`](reports/insights.md) for the full interpretation and limitations.

## SQL analysis

`sql/analysis_queries.sql` contains 15 business-oriented queries using joins-free single-table analytics, CTEs, aggregations, CASE expressions and window functions.

Run all SQL queries against the cleaned CSV with:

```bash
python sql/run_queries.py
```

The script loads the cleaned dataset into an in-memory SQLite database and executes every query sequentially.

## Reproduce the project

Create and activate a virtual environment, then install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Before running notebooks, obtain the **same historical version** of \`listings.csv\` from [Kaggle](https://www.kaggle.com/datasets/airbnb/boston), and save it to \`data/raw/listings.csv\`. For example, with the authenticated [Kaggle CLI](https://github.com/Kaggle/kaggle-api):

\`\`\`bash
python -m pip install kaggle
kaggle datasets download airbnb/boston -f listings.csv -p data/raw --unzip
python scripts/verify_source.py
\`\`\`

The source verifier requires the documented SHA-256; a different download may represent a different version and must not silently replace it.

Run the notebooks in order:

1. \`notebooks/01_data_audit.ipynb\`
2. \`notebooks/02_data_cleaning.ipynb\`
3. \`notebooks/03_eda_analysis.ipynb\`

The cleaning notebook recreates \`data/processed/boston_airbnb_cleaned.csv\` from the untouched raw file.

To rebuild the distributable summary and run checks:

\`\`\`bash
python scripts/build_public_dataset.py
python -m unittest discover -s tests -v
python sql/run_queries.py
\`\`\`

Checks requiring the local raw or cleaned CSV are skipped when those private local files are not present. This is not a substitute for running the full analytical verification locally.

## Dashboard-ready fields

The cleaned CSV remains the analysis source used to prepare the existing databyloris dashboard, but is no longer tracked in this repository. Recommended filters are:

- `room_type` — 3 values
- `cancellation_policy` — 4 values
- `property_type` — 13 non-null values
- `neighbourhood_cleansed` — 25 values

The existing dashboard's data and permissions are maintained separately in Supabase. The aggregated CSV in `data/public/` is not automatically used by the deployed dashboard.

## Limitations

- Historical snapshot from September 2016.
- Review scores are missing for 813 listings, so rating statistics use available ratings only.
- `availability_365` does not directly measure occupancy or demand.
- Extreme prices are retained because the dataset alone does not establish that they are errors.
- Comparisons between groups are descriptive; they do not demonstrate causes.

## Attribution

Dataset card: **Boston Airbnb Open Data**, published on Kaggle by Airbnb and collaborator(s). Kaggle acknowledges the Airbnb Inside initiative as the source and lists this dataset version under **CC0: Public Domain**.
