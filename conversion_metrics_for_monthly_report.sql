SELECT 
	t1.*,
    t2.booked_deals booked_deals,
    t2.activated_deals activated_deals,
    t2.total_booked_revenue total_booked_revenue,
    t2.total_activated_revenue total_activated_revenue
FROM(
-- Get Case Review Info (opps)
SELECT
    Process_Tracking_For_Formula__c mrm, 
    sfu.title position,
    sfo.Lead_Source__c funnel_type,
    COUNT(DISTINCT IF(Case_Review_Set__c IS NOT NULL, sfo.id, NULL)) total_crs,
    COUNT(DISTINCT IF(Case_Review_Completed__c IS NOT NULL, sfo.id, NULL)) total_crc
FROM sfopportunity sfo
JOIN sfusers sfu
	ON sfo.CreatedById = sfu.id
WHERE 
sfu.title IN ('MRM1','MRM2','MRM3','NMRM','SMRM1','SMRM2','SMRM3','SMRM4','SMRM5')
AND sfu.isactive = '1'
GROUP BY mrm, funnel_type) as t1
LEFT JOIN 
-- Get Deals Info
(SELECT
    Process_Tracking_For_Formula__c mrm, 
    sfu.title position,
    sfo.Lead_Source__c funnel_type,
    COUNT(DISTINCT IF((Order_Date__c IS NOT NULL) , sfd.id, NULL)) booked_deals,
    COUNT(DISTINCT IF(First_Installment_processed_on__c IS NOT NULL, sfd.id, NULL)) activated_deals,
    CONCAT('$', ' ', SUM(Membership_Fee_After_Discount__c)) total_booked_revenue,
    CONCAT('$', ' ', SUM(IF(First_Installment_processed_on__c IS NOT NULL, Membership_Fee_After_Discount__c, NULL))) AS total_activated_revenue
FROM sfopportunity sfo
JOIN sfusers sfu
    ON sfo.CreatedById = sfu.id
JOIN sfdeal sfd
    ON sfo.id = sfd.Opportunity__c
WHERE 
sfu.title IN ('MRM1','MRM2','MRM3','NMRM','SMRM1','SMRM2','SMRM3','SMRM4','SMRM5')
AND
sfd.Membership_Type__c NOT IN ("Wait List","Waitlist","Expired Waitlist") 
AND
sfd.Sales_Team__c <> "Special Ops"
AND sfu.isactive = '1'
GROUP BY mrm, funnel_type) AS t2
ON t2.mrm = t1.mrm AND t1.position = t2.position AND t1.funnel_type = t2.funnel_type
ORDER BY t1.mrm ASC, t1.funnel_type ASC
