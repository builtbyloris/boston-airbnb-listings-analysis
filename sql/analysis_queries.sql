-- Boston Airbnb Listings Analysis
-- Engine: SQLite-compatible SQL
-- Table expected: boston_airbnb
-- The companion run_queries.py loads the cleaned CSV into this table.

-- QUERY: Q01_OVERALL_KPIS
SELECT
    COUNT(*) AS total_listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(availability_365), 2) AS avg_availability_365,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating,
    SUM(number_of_reviews) AS total_reviews,
    ROUND(100.0 * AVG(CASE WHEN instant_bookable = 1 THEN 1 ELSE 0 END), 2) AS instant_bookable_pct,
    ROUND(100.0 * AVG(CASE WHEN host_is_superhost = 1 THEN 1 ELSE 0 END), 2) AS superhost_listing_pct
FROM boston_airbnb;

-- QUERY: Q02_ROOM_TYPE_DISTRIBUTION
SELECT
    room_type,
    COUNT(*) AS listings,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM boston_airbnb), 2) AS share_pct
FROM boston_airbnb
GROUP BY room_type
ORDER BY listings DESC;

-- QUERY: Q03_ROOM_TYPE_PRICE
WITH ranked AS (
    SELECT
        room_type,
        price_usd,
        ROW_NUMBER() OVER (PARTITION BY room_type ORDER BY price_usd) AS rn,
        COUNT(*) OVER (PARTITION BY room_type) AS n
    FROM boston_airbnb
), medians AS (
    SELECT room_type, AVG(price_usd) AS median_price_usd
    FROM ranked
    WHERE rn IN ((n + 1) / 2, (n + 2) / 2)
    GROUP BY room_type
)
SELECT
    b.room_type,
    COUNT(*) AS listings,
    ROUND(AVG(b.price_usd), 2) AS avg_price_usd,
    ROUND(m.median_price_usd, 2) AS median_price_usd
FROM boston_airbnb b
JOIN medians m ON b.room_type = m.room_type
GROUP BY b.room_type, m.median_price_usd
ORDER BY median_price_usd DESC;

-- QUERY: Q04_TOP_NEIGHBOURHOODS_BY_LISTINGS
SELECT
    neighbourhood_cleansed,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd
FROM boston_airbnb
GROUP BY neighbourhood_cleansed
ORDER BY listings DESC
LIMIT 10;

-- QUERY: Q05_NEIGHBOURHOOD_MEDIAN_PRICE_MIN_20
WITH counts AS (
    SELECT neighbourhood_cleansed, COUNT(*) AS listings
    FROM boston_airbnb
    GROUP BY neighbourhood_cleansed
    HAVING COUNT(*) >= 20
), ranked AS (
    SELECT
        b.neighbourhood_cleansed,
        b.price_usd,
        ROW_NUMBER() OVER (PARTITION BY b.neighbourhood_cleansed ORDER BY b.price_usd) AS rn,
        COUNT(*) OVER (PARTITION BY b.neighbourhood_cleansed) AS n
    FROM boston_airbnb b
    JOIN counts c USING (neighbourhood_cleansed)
), medians AS (
    SELECT neighbourhood_cleansed, AVG(price_usd) AS median_price_usd
    FROM ranked
    WHERE rn IN ((n + 1) / 2, (n + 2) / 2)
    GROUP BY neighbourhood_cleansed
)
SELECT c.neighbourhood_cleansed, c.listings, ROUND(m.median_price_usd, 2) AS median_price_usd
FROM counts c
JOIN medians m USING (neighbourhood_cleansed)
ORDER BY median_price_usd DESC, listings DESC;

-- QUERY: Q06_PROPERTY_TYPE_SUMMARY
SELECT
    COALESCE(property_type, 'Missing') AS property_type,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating
FROM boston_airbnb
GROUP BY COALESCE(property_type, 'Missing')
ORDER BY listings DESC;

-- QUERY: Q07_PRICE_BY_GUEST_CAPACITY
SELECT
    accommodates,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd
FROM boston_airbnb
GROUP BY accommodates
ORDER BY accommodates;

-- QUERY: Q08_SUPERHOST_COMPARISON
SELECT
    CASE WHEN host_is_superhost = 1 THEN 'Superhost' ELSE 'Non-superhost' END AS host_status,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating,
    ROUND(AVG(number_of_reviews), 2) AS avg_reviews,
    ROUND(AVG(availability_365), 2) AS avg_availability_365
FROM boston_airbnb
GROUP BY host_is_superhost
ORDER BY host_is_superhost DESC;

-- QUERY: Q09_INSTANT_BOOKABLE_COMPARISON
SELECT
    CASE WHEN instant_bookable = 1 THEN 'Instant bookable' ELSE 'Not instant bookable' END AS booking_type,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating,
    ROUND(AVG(number_of_reviews), 2) AS avg_reviews
FROM boston_airbnb
GROUP BY instant_bookable
ORDER BY instant_bookable DESC;

-- QUERY: Q10_CANCELLATION_POLICY
SELECT
    cancellation_policy,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating
FROM boston_airbnb
GROUP BY cancellation_policy
ORDER BY listings DESC;

-- QUERY: Q11_AVAILABILITY_BY_ROOM_TYPE
SELECT
    room_type,
    COUNT(*) AS listings,
    ROUND(AVG(availability_30), 2) AS avg_availability_30,
    ROUND(AVG(availability_90), 2) AS avg_availability_90,
    ROUND(AVG(availability_365), 2) AS avg_availability_365
FROM boston_airbnb
GROUP BY room_type
ORDER BY listings DESC;

-- QUERY: Q12_RATINGS_BY_ROOM_TYPE
SELECT
    room_type,
    COUNT(review_scores_rating) AS rated_listings,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating,
    ROUND(AVG(review_scores_cleanliness), 2) AS avg_cleanliness,
    ROUND(AVG(review_scores_location), 2) AS avg_location_score,
    ROUND(AVG(review_scores_value), 2) AS avg_value_score
FROM boston_airbnb
GROUP BY room_type
ORDER BY rated_listings DESC;

-- QUERY: Q13_REVIEW_VOLUME_BUCKETS
WITH bucketed AS (
    SELECT
        CASE
            WHEN number_of_reviews = 0 THEN '0 reviews'
            WHEN number_of_reviews BETWEEN 1 AND 10 THEN '1-10 reviews'
            WHEN number_of_reviews BETWEEN 11 AND 50 THEN '11-50 reviews'
            ELSE '51+ reviews'
        END AS review_bucket,
        CASE
            WHEN number_of_reviews = 0 THEN 1
            WHEN number_of_reviews BETWEEN 1 AND 10 THEN 2
            WHEN number_of_reviews BETWEEN 11 AND 50 THEN 3
            ELSE 4
        END AS bucket_order,
        price_usd,
        review_scores_rating
    FROM boston_airbnb
)
SELECT
    review_bucket,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating
FROM bucketed
GROUP BY review_bucket, bucket_order
ORDER BY bucket_order;

-- QUERY: Q14_TOP_HOSTS_BY_LISTINGS
SELECT
    host_id,
    COUNT(*) AS listings,
    ROUND(AVG(price_usd), 2) AS avg_price_usd,
    ROUND(AVG(review_scores_rating), 2) AS avg_rating
FROM boston_airbnb
GROUP BY host_id
ORDER BY listings DESC
LIMIT 10;

-- QUERY: Q15_PRICE_QUARTILES
WITH price_bands AS (
    SELECT
        id,
        price_usd,
        NTILE(4) OVER (ORDER BY price_usd) AS price_quartile
    FROM boston_airbnb
)
SELECT
    price_quartile,
    COUNT(*) AS listings,
    ROUND(MIN(price_usd), 2) AS min_price_usd,
    ROUND(MAX(price_usd), 2) AS max_price_usd,
    ROUND(AVG(price_usd), 2) AS avg_price_usd
FROM price_bands
GROUP BY price_quartile
ORDER BY price_quartile;
