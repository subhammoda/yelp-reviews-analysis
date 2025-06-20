CREATE TABLE fltbl_yelp_reviews AS
SELECT 
    reviews:business_id::STRING AS business_id,
    reviews:date::DATE AS review_date,
    reviews:user_id::STRING AS user_id,
    reviews:stars::NUMBER AS review_stars,
    reviews:text::STRING AS review_text,
    analyze_sentiments(review_text) AS sentiment
FROM yelp_review