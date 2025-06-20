CREATE TABLE fltbl_yelp_users AS
SELECT 
    tip:text::STRING AS text,
    tip:date::DATE AS date,
    tip:business_id::STRING AS business_id,
    tip:user_id::STRING AS user_id,
    tip:compliment_count::INTEGER AS compliment_count
FROM yelp_review