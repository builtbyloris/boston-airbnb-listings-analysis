# Data Quality Report

## Integrity summary

| Check | Result |
|---|---:|
| Raw rows | 3,585 |
| Raw columns | 95 |
| Cleaned rows | 3,585 |
| Cleaned columns | 43 |
| Rows removed | **0** |
| Duplicate rows in raw | 0 |
| Duplicate listing IDs | 0 |
| Raw SHA-256 | `9c2fa5db20b0d1018cb558750aeb276599ea877e1e0c1ae315766a032d78881f` |

The raw file is copied unchanged to `data/raw/listings.csv` and the cleaning workflow never overwrites it.

## Missing values relevant to analysis

| Field | Missing | Missing % |
|---|---:|---:|
| `review_scores_rating` | 813 | 22.7% |
| `cleaning_fee` | 1107 | 30.9% |
| `host_response_rate` | 471 | 13.1% |
| `property_type` | 3 | 0.1% |
| `bathrooms` | 14 | 0.4% |
| `bedrooms` | 10 | 0.3% |
| `beds` | 9 | 0.3% |

No nulls are imputed because the source does not provide a defensible replacement value.

## Completely empty raw columns

`neighbourhood_group_cleansed`, `has_availability`, `license`, `jurisdiction_names`

These fields are excluded from the cleaned dataset because they contain no information in this snapshot.

## Deterministic conversions

All non-null source values successfully parse in the following conversions:

- `price` → numeric `price_usd`
- `cleaning_fee` → numeric `cleaning_fee_usd`
- `extra_people` → numeric `extra_people_usd`
- `host_response_rate` → numeric `host_response_rate_pct`
- `host_acceptance_rate` → numeric `host_acceptance_rate_pct`
- `host_is_superhost`, `host_identity_verified`, `instant_bookable` → booleans

## Extreme values

Nightly price ranges from **$10** to **$4,000**. There are **10** listings above $1,000 per night.

These rows are retained. The dataset provides no reliable evidence that the values are data-entry errors, so deleting them would be arbitrary.
