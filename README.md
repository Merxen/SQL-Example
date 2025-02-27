# SQL-Example


SELECT 
	*
FROM
	(select
		sfo.Process_Tracking_For_Formula__c as `Sales Rep`,
        dayofweek(sfo.Case_Review_Set__c) as `DoF Index`,
		CASE
			when dayofweek(sfo.Case_Review_Set__c) = 2 then "Monday"
			when dayofweek(sfo.Case_Review_Set__c) = 3 then "Tuesday"
			when dayofweek(sfo.Case_Review_Set__c) = 4 then "Wednesday"
			when dayofweek(sfo.Case_Review_Set__c) = 5 then "Thursday"
			when dayofweek(sfo.Case_Review_Set__c) = 6 then "Friday"
			when dayofweek(sfo.Case_Review_Set__c) = 7 then "Saturday"
			when dayofweek(sfo.Case_Review_Set__c) = 1 then "Sunday"
			else "potato"
		END as `Weekday`, 
		count(sfo.Case_Review_Set__c) as `Total CRs Set`,
		count(sfo.Case_Review_Completed__c) as `Total CRs Completed`, 
		count(sfd.First_Installment_processed_on__c) as `Total Deals`,
		sum(sfd.Membership_Fee_After_Discount__c) as `Total Deal Revenue`
	from sfopportunity as sfo
	left join sfdeal as sfd
		on sfo.id = sfd.Opportunity__c
	right join sfcloser as sfc
		on sfd.Allocation_Manager__c = sfc.id
	where
	sfo.Case_Review_Set__c between "2024-01-01" and "2024-12-31"
	group by
		`Sales Rep`, `DoF Index`, `Weekday`
	) as t_grouped
inner join 
(
	select
	sfo.id `Opp ID`,
	sfd.id `Deal ID`, 
	sfc.id `Closer ID`,
	sfo.Process_Tracking_For_Formula__c as `Sales Rep`, 
	sfc.name as `Allocation Manager`, 
	sfo.StageName as `Stage`, 
	sfo.Case_Review_Set__c as `CR Set Date`,
	sfo.Case_Review_Completed__c as `CR Complete Date`, 
	sfd.First_Installment_processed_on__c as `Deal Confirmation`,
	sfd.Membership_Fee_After_Discount__c as `Deal Revenue`,
	sfd.Lead_Source__c as `Lead Source`,
	sfd.Area_of_Practice_1__c as `Super Category`,
	dayofweek(sfo.Case_Review_Set__c) as `DoF Index`,
	CASE
		when dayofweek(sfo.Case_Review_Set__c) = 2 then "Monday"
		when dayofweek(sfo.Case_Review_Set__c) = 3 then "Tuesday"
		when dayofweek(sfo.Case_Review_Set__c) = 4 then "Wednesday"
		when dayofweek(sfo.Case_Review_Set__c) = 5 then "Thursday"
		when dayofweek(sfo.Case_Review_Set__c) = 6 then "Friday"
		when dayofweek(sfo.Case_Review_Set__c) = 7 then "Saturday"
		when dayofweek(sfo.Case_Review_Set__c) = 1 then "Sunday"
		else "potato"
	END as `Weekday`
	from sfopportunity as sfo
	left join sfdeal as sfd
		on sfo.id = sfd.Opportunity__c
	right join sfcloser as sfc
		on sfd.Allocation_Manager__c = sfc.id
	where
	sfo.Case_Review_Set__c between "2024-01-01" and "2024-12-31"
) AS t_ungrouped

on t_grouped.`Sales Rep`=t_ungrouped.`Sales Rep`
	and t_grouped.`DoF Index`=t_ungrouped.`DoF Index`
    
order by
	t_grouped.`Sales Rep` ASC, t_grouped.`DoF Index` ASC

limit 50;






