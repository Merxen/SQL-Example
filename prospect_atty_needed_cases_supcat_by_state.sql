SELECT
    zipdata.zd_state  AS `state`,
    attorney_stats_region_cache.asrc_num_prospects  AS `available_to_prospect`,
    attorney_stats_region_cache.asrc_num_needed_attys  AS `attys_needed`,
    attorney_stats_region_cache.asrc_num_cases  AS `total_cases`,
    category_super.catsup_descr  AS `super_category`
FROM legalmatch.region  AS region
LEFT JOIN legalmatch.attorney_stats_region_cache  AS attorney_stats_region_cache ON region.region_id=attorney_stats_region_cache.asrc_region_id
INNER JOIN legalmatch.category_supper  AS category_super ON region.region_catsup_id=category_super.catsup_id
INNER JOIN legalmatch.region_county_xref  AS region_county_xref ON region.region_id=region_county_xref.rcx_region_id
INNER JOIN legalmatch.lm_county  AS lm_county ON region_county_xref.rcx_county_id  = lm_county.county_id
INNER JOIN legalmatch.lm_county_zip  AS lm_county_zip ON lm_county.county_id=lm_county_zip.cz_county_id
INNER JOIN legalmatch_location.zipdata  AS zipdata ON lm_county_zip.cz_zip=zipdata.zd_zip
GROUP BY
    1,
    2,
    3,
    4,
    5
ORDER BY
    1
LIMIT 500