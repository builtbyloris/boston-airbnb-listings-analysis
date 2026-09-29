# Dashboard Design Proposal

This document defines the analytical design only. The actual databyloris `DashboardConfig` belongs to the later import step.

## Source of truth

`data/processed/boston_airbnb_cleaned.csv` — **3,585 rows**, identical row count to the raw dataset.

## KPI cards

| ID | Label | Calculation |
|---|---|---|
| `total-listings` | Total Listings | Count of `id` |
| `median-price` | Median Nightly Price | Median of `price_usd` |
| `avg-rating` | Average Rating | Mean of non-null `review_scores_rating` |
| `avg-availability` | Avg. Annual Availability | Mean of `availability_365` |

Unfiltered reference values are 3,585, $150, 91.92/100 and 179.35 days.

## Filters

| ID | Field | Cardinality |
|---|---|---:|
| `room-type` | `room_type` | 3 |
| `cancellation-policy` | `cancellation_policy` | 4 |
| `property-type` | `property_type` | 13 |
| `neighbourhood` | `neighbourhood_cleansed` | 25 |

All filters should use actual available values only and retain a default `Tutti / All` state.

## Visualizations

1. `listings-by-room-type` — donut or bar, count of listings by `room_type`.
2. `median-price-by-neighbourhood` — bar chart, median `price_usd` by `neighbourhood_cleansed`.
3. `price-by-capacity` — bar/line chart, median `price_usd` by `accommodates`.
4. `rating-by-room-type` — bar chart, mean non-null `review_scores_rating` by `room_type`.

## Ranking

`neighbourhood-price-ranking`: rank neighbourhoods by median nightly price. For the default unfiltered narrative, use a minimum-volume rule of at least 20 listings to avoid highlighting tiny groups; if databyloris cannot express that rule generically, rank all neighbourhoods and display listing count alongside price rather than silently dropping groups.

## Data interpretation

The dashboard must state that the dataset is historical (2016) and that availability is not occupancy. Rating calculations ignore missing ratings rather than replacing them.
