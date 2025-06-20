CREATE TABLE fltbl_yelp_users AS
SELECT 
    user:user_id::STRING AS user_id,
    user:name::STRING AS name,
    user:review_count::INTEGER AS review_count,
    user:yelping_since::DATE AS yelping_since
FROM yelp_review