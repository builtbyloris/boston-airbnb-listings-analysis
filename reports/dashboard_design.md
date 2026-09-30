# Dashboard Design

This document reflects the implemented public dashboard for **Boston Airbnb Listings Analysis** in databyloris.

## Source of truth

`data/processed/boston_airbnb_cleaned.csv` — **3,585 rows × 43 columns**.

The same cleaned dataset is used for the analytical project and the public dashboard. No reduced-row public subset is created.

All price fields used by the dashboard are expressed in **USD**.

## KPI cards

| ID | Label | Field | Aggregation | Unfiltered reference |
|---|---|---|---|---:|
| `total-listings` | Total listings | `id` | Count | 3,585 |
| `avg-price` | Average nightly price (USD) | `price_usd` | Average | $173.93 |
| `avg-rating` | Average rating | `review_scores_rating` | Average, non-null values only | 91.92/100 |
| `avg-availability` | Avg. annual availability | `availability_365` | Average | 179.35 days |

The analytical repository also reports median price where useful. The public dashboard uses **average price** because the current generic databyloris aggregation engine supports average but not median.

## Filters

| ID | Label | Field | Cardinality | Selection |
|---|---|---|---:|---|
| `neighbourhood` | Neighbourhood | `neighbourhood_cleansed` | 25 | Single |
| `room-type` | Room type | `room_type` | 3 | Single |
| `property-type` | Property type | `property_type` | 13 non-null values | Single |
| `cancellation-policy` | Cancellation policy | `cancellation_policy` | 4 | Single |

All filters use values that actually exist in the dataset and retain a default `Tutti / All` state. No synthetic categories are introduced for null values.

## Visualizations

1. `listings-by-room-type`
   - Type: donut
   - Dimension: `room_type`
   - Metric: `id`
   - Aggregation: count
   - Sort: value descending
   - Purpose: show listing composition by room type.

2. `avg-price-by-neighbourhood`
   - Type: bar
   - Dimension: `neighbourhood_cleansed`
   - Metric: `price_usd`
   - Aggregation: average
   - Sort: value descending
   - Limit: 10
   - Unit: USD
   - Purpose: compare the ten neighbourhoods with the highest average nightly price in the current filtered view.

3. `avg-price-by-capacity`
   - Type: bar
   - Dimension: `accommodates`
   - Metric: `price_usd`
   - Aggregation: average
   - Sort: category ascending
   - Unit: USD
   - Purpose: describe how average nightly price changes with listing capacity.

4. `avg-rating-by-room-type`
   - Type: bar
   - Dimension: `room_type`
   - Metric: `review_scores_rating`
   - Aggregation: average of non-null values
   - Sort: value descending
   - Purpose: compare available review ratings across room types.

## Ranking

`neighbourhood-listings-ranking`

- Title: Neighbourhoods with the most listings
- Dimension: `neighbourhood_cleansed`
- Dimension label: Neighbourhood
- Metric: `id`
- Metric label: Listings
- Aggregation: count
- Direction: descending
- Limit: 10

The ranking is count-based and therefore does not require a hidden minimum-volume rule.

## Data interpretation

- The dataset is a **September 2016 historical snapshot** and must not be presented as the current Boston Airbnb market.
- `availability_365` represents reported availability, not occupancy.
- Rating calculations ignore missing `review_scores_rating` values rather than replacing them with zero.
- Price comparisons are descriptive and do not establish causality.
- Dashboard price values are USD. If the UI formatter cannot select a currency code, use numeric formatting and state `USD` explicitly in the label/title rather than displaying an incorrect currency symbol.
