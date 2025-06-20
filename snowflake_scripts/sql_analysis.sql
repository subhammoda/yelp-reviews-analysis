-- Number of businesses in each category
WITH get_categories AS (
    SELECT business_id, trim(categories.value) AS category
    FROM fltbl_yelp_business,
    LATERAL split_to_table(categories, ',') AS categories
)
SELECT category, COUNT(*) AS no_of_business
FROM get_categories
GROUP BY category
ORDER BY COUNT(*) DESC

-- Find top 10 users who have reviewed most businesses in restaurants category
SELECT r.user_id, COUNT(DISTINCT r.business_id) as no_of_reviews
FROM fltbl_yelp_business b
INNER JOIN fltbl_yelp_reviews r
ON r.business_id = b.business_id
WHERE b.categories ILIKE "%restaurant%"
GROUP BY r.user_id
ORDER BY COUNT(DISTINCT r.business_id) DESC
LIMIT 10

-- Find the most popular business category based on number of reviews
WITH get_categories AS (
    SELECT business_id, trim(categories.value) AS category
    FROM fltbl_yelp_business,
    LATERAL split_to_table(categories, ',') AS categories
)
SELECT c.category, COUNT(r.business_id) AS no_of_reviews
FROM get_categories c
INNER JOIN fltbl_yelp_reviews r
ON c.business_id = r.business_id
GROUP BY c.category
ORDER BY COUNT(r.business_id) DESC

-- 3 most recent reviews of each business
WITH latest_3_reviews AS (
    SELECT business_id, review_text,
        ROW_NUMBER()OVER(PARTITION BY business_id ORDER BY review_date DESC) AS rn
    FROM fltbl_yelp_reviews
)
SELECT business_id, review_text
FROM latest_3_reviews
WHERE rn < 4

-- Find the month with most number of reviews in the year 2021
SELECT MONTH(review_date) as review_month, COUNT(*) as no_of_reviews
FROM fltbl_yelp_reviews
WHERE YEAR(review_date) = 2021
GROUP BY 1
ORDER BY 2 DESC

-- Find the percentage of 5 star reviews for each business
SELECT business_id, COUNT(CASE WHEN review_stars = 5 THEN 1 ELSE NULL END) AS star_review,
    CASE WHEN star_review > 0 THEN star_review*100/COUNT(*) ELSE 0 END AS review_percent
FROM fltbl_yelp_reviews
GROUP BY r.business_id
ORDER BY 2 DESC

-- Find top 5 most reviewed businesses in each city
WITH reviews_per_business AS (
    SELECT b.city, r.business_id, COUNT(*) as no_of_reviews
    FROM fltbl_yelp_reviews r
    INNER JOIN fltbl_yelp_business b
    GROUP BY b.city, r.business_id
)
SELECT *
FROM reviews_per_business
QUAIFY ROW_NUMBER()OVER(PARTITION BY b.city ORDER BY no_of_reviews DESC) < 6

-- Find average rating of business with at least 100 Reviews
SELECT business_id, AVG(review_stars) AS avg_review
FROM fltbl_yelp_reviews
GROUP BY r.business_id
HAVING COUNT(*) >= 100

-- List top 10 users who have written most reviews
SELECT user_id, COUNT(*) AS total_user_reviews
FROM fltbl_yelp_reviews
GROUP BY user_id
ORDER BY 2 DESC
LIMIT 10

-- List the top 10 business with highest positive sentiment reviews
SELECT business_id, COUNT(*) AS highest_positive_sentiment
FROM fltbl_yelp_reviews
WHERE sentiment = 'Positive'
GROUP BY 1
ORDER BY 2 DESC