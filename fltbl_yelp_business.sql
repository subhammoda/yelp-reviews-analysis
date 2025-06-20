CREATE TABLE fltbl_yelp_business AS
SELECT 
    business:business_id::STRING AS business_id,
    business:categories::STRING AS categories,
    business:city::STRING AS city,
    business:state::STRING AS state,
    business:review_count::INTERGER AS review_count,
    business:name::STRING AS name,
    business:stars::NUMBER AS stars
FROM yelp_business