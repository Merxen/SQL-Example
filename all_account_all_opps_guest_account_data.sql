select
sfaccount.name as account_name, 
count(sfopportunity.CreatedDate) as total_opps,
count(distinct sfcontact.id) as total_contacts,
count(sfopportunity.Case_Review_Set__c) as total_crs,
count(sfopportunity.Case_Review_Completed__c) as total_crc, 
-- count(sfdeal.Order_Date__c) as total_booked_deals,
-- count(sfdeal.First_Installment_processed_on__c) as total_activated_deals,
count(sfguest_account.Guest_Account_Created_Date__c) as total_gas_created,
sum(sfguest_account.Total_Logins__c) as total_gas_logins,
sum(sfguest_account.Total_Number_of_Cases_Viewed__c) as total_cases_viewed

from sfaccount
left join sfopportunity
	on sfopportunity.AccountId = sfaccount.id
left join sfguest_account
	on sfopportunity.id = sfguest_account.Opportunity__c
left join sfcontact
	on sfcontact.Accountid = sfaccount.id
    
group by account_name
