# Boston Airbnb — aggregated public data

Source: [Boston Airbnb Open Data on Kaggle](https://www.kaggle.com/datasets/airbnb/boston), dataset card license **CC0 1.0**, historical snapshot **2016-09-07**.

This file is generated from the locally cleaned 3,585-listing analytical dataset using \`python scripts/build_public_dataset.py\`.

The CSV reports summary statistics by **neighbourhood × room type**. Groups with fewer than **10 listings** are omitted. It includes listing counts, average/median nightly prices (USD) and mean reported availability (days/year).

No listing IDs, host IDs, names, addresses, coordinates, reviews or individual records are included. Group suppression reduces exposure but **does not guarantee anonymity**.

Because small groups are excluded, the sum of counts in the public file is **less than or equal to 3,585**; it should not be treated as the complete dashboard input or as current Boston rental market data. The existing databyloris dashboard uses its independently managed dataset in Supabase.
