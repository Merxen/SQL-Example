select
sfopportunity.Name,
date_format(sfopportunity.createddate, "%Y-%m-%d") as date,
sfopportunity.Case_Review_Set__c as crs, 
sfopportunity.Case_Review_Completed__c as crc, 
sfdeal.Order_Date__c as deal_date,
sfdeal.Membership_Fee_After_Discount__c as revenue,
sfopportunity.Lead_Source__c as funnel,
sfopportunity.Lead_Source_Type__c as funnel_type, 
sfguest_account.Guest_Account_Creator__c,
count(sfguest_account.Guest_Account_Created_Date__c) as gas_created_date,
sum(sfguest_account.Total_Logins__c) as total_logins,
sum(sfguest_account.Total_Number_of_Cases_Viewed__c) as total_cases_viewed

from sfaccount
left join sfopportunity
	on sfopportunity.AccountId = sfaccount.id
left join sfguest_account
	on sfguest_account.Opportunity__c = sfopportunity.id
left join sfdeal
	on sfopportunity.id = sfdeal.Opportunity__c
where
sfopportunity.Lead_Source_Type__c IN ("Guest Pass Hot Lead", "Guest Pass Warm Lead")
and 
sfopportunity.createddate between "2024-12-01" and "2025-12-31"

group by sfopportunity.name




