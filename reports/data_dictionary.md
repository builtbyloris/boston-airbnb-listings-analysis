# Cleaned Data Dictionary

The processed dataset contains **43 columns** and **3,585 rows**.

| Column | Description |
|---|---|
| `id` | Unique listing identifier. |
| `host_id` | Host identifier. |
| `last_scraped` | Date the listing record was scraped. |
| `host_since` | Host account start date. |
| `host_response_time` | Categorical host response-time band. |
| `host_response_rate_pct` | Host response rate converted to numeric percentage points. |
| `host_acceptance_rate_pct` | Host acceptance rate converted to numeric percentage points. |
| `host_is_superhost` | Whether the host is marked as a superhost. |
| `host_identity_verified` | Whether host identity is marked as verified. |
| `neighbourhood_cleansed` | Standardized Boston neighbourhood. |
| `latitude` | Listing latitude. |
| `longitude` | Listing longitude. |
| `property_type` | Property category. |
| `room_type` | Room/listing type. |
| `accommodates` | Number of guests accommodated. |
| `bathrooms` | Number of bathrooms. |
| `bedrooms` | Number of bedrooms. |
| `beds` | Number of beds. |
| `bed_type` | Bed category. |
| `price_usd` | Nightly price in USD, parsed from source price. |
| `cleaning_fee_usd` | Cleaning fee in USD when reported. |
| `guests_included` | Guests included in listed price. |
| `extra_people_usd` | Extra-person charge in USD. |
| `minimum_nights` | Minimum stay in nights. |
| `maximum_nights` | Maximum stay in nights. |
| `availability_30` | Available days in the next 30 days. |
| `availability_60` | Available days in the next 60 days. |
| `availability_90` | Available days in the next 90 days. |
| `availability_365` | Available days in the next 365 days. |
| `number_of_reviews` | Total reviews recorded. |
| `first_review` | Date of first review when available. |
| `last_review` | Date of latest review when available. |
| `review_scores_rating` | Overall review score, generally out of 100. |
| `review_scores_accuracy` | Accuracy review score. |
| `review_scores_cleanliness` | Cleanliness review score. |
| `review_scores_checkin` | Check-in review score. |
| `review_scores_communication` | Communication review score. |
| `review_scores_location` | Location review score. |
| `review_scores_value` | Value review score. |
| `instant_bookable` | Whether the listing is instant bookable. |
| `cancellation_policy` | Cancellation policy category. |
| `calculated_host_listings_count` | Calculated number of listings associated with the host. |
| `reviews_per_month` | Average reviews per month when available. |
