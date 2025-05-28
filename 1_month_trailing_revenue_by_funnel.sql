SELECT
DATE_FORMAT(sfd.First_Installment_processed_on__c, "%Y-%m") deal_date,
sfd.Lead_Source__c funnel,
CONCAT("$", ' ', SUM(sfd.Membership_Fee_After_Discount__c)) total_revenue,
SUM(sfd.Membership_Fee_After_Discount__c) - LAG(SUM(sfd.Membership_Fee_After_Discount__c), 1) 
	OVER (PARTITION BY sfd.Lead_Source__c 
			ORDER BY DATE_FORMAT(sfd.First_Installment_processed_on__c, "%Y-%m" AND sfd.Lead_Source__c)) prior_month_revnue_delta
FROM sfdeal sfd
WHERE 
sfd.First_Installment_processed_on__c BETWEEN "2024-01-01" AND "2025-12-31"
GROUP BY
deal_date, funnel
ORDER BY 
funnel ASC, deal_date ASC