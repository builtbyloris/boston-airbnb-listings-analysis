# Verified Insights

All figures below are calculated from `data/processed/boston_airbnb_cleaned.csv`. The cleaned file contains the same **3,585 listings** as the raw file; no observations were removed.

## 1. Listing mix

- Entire home/apt: **2,127 listings (59.3%)**
- Private room: **1,378 (38.4%)**
- Shared room: **80 (2.2%)**

Median nightly prices are **$199**, **$80** and **$60** respectively.

## 2. Neighbourhood concentration

The five neighbourhoods with the largest listing counts are:

| Neighbourhood | Listings | Median price |
|---|---:|---:|
| Jamaica Plain | 343 | $100 |
| South End | 326 | $180 |
| Back Bay | 302 | $209 |
| Fenway | 290 | $191 |
| Dorchester | 269 | $72 |


Among neighbourhoods with at least 20 listings, the three highest median nightly prices are **South Boston Waterfront ($245)**, **Downtown ($225)** and **Chinatown ($219)**.

## 3. Host status

Only **11.4%** of listings are attached to hosts marked as superhosts in this snapshot.

Rated superhost listings average **97.08/100** compared with **91.06/100** for other rated listings. Superhost listings also average **44.9 reviews** versus **15.7** for non-superhost listings.

This is an association in the snapshot, not evidence that superhost status causes higher ratings or review volume.

## 4. Instant booking

Instant-bookable listings represent **16.6%** of the dataset. Their median nightly price is **$125**, compared with **$150** for listings without instant booking.

Again, this is a descriptive comparison; other listing characteristics may explain the difference.

## 5. Host concentration

There are **2,181 unique hosts** for 3,585 listings. **81.1%** of hosts have exactly one listing in this snapshot, while listings belonging to hosts with more than one listing account for **50.7%** of all listings.

The largest host identifier in the snapshot is associated with **136 listings**.

## 6. Review coverage

`review_scores_rating` is available for **2,772 of 3,585 listings (77.3%)**. Therefore, rating-based averages exclude listings with missing ratings rather than imputing values.

## Interpretation limits

- The project describes a **September 2016 snapshot**, not today's market.
- `availability_365` should not be interpreted as occupancy.
- Price differences between segments do not establish causality.
- Missing review scores are left missing.
- High prices are retained because the data does not prove they are errors.
