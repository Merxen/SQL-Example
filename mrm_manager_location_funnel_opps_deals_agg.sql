select 
	emp_name,
    emp_id,
    position,
	manager_name,
    location,
    active,
    source_funnel,
	count(cr_set) as `total_cr_set`,
	count(cr_comp) as `total_cr_comp`,
	count(deal_confirm) as `total_deals`,
	sum(deal_revenue) as `total_revenue`

from
	(
	select
		sfo.Process_Tracking_For_Formula__c as `mrm_name`,
		sfo.Case_Review_Set__c as `cr_set`,
		sfo.Case_Review_Completed__c as `cr_comp`,
		sfo.Lead_Source__c as `source_funnel`, 
		sfo.CreatedById as `join`,
		sfd.First_Installment_processed_on__c as `deal_confirm`,
		sfd.Membership_Fee_After_Discount__c as `deal_revenue`,
		sfd.Membership_Length__c as `term_length`

		from sfopportunity as sfo
		left join sfdeal as sfd
			on sfo.id = sfd.Opportunity__c
			
		where
		sfo.CreatedDate between "2024-1-1" and "2025-12-31"
        and
        sfo.Lead_Source__c not in ('RENEWAL','UPGRADE','EARLY RENEWAL')
		) as t1
inner join
	(
	select
		sfu1.id 'emp_id', 
		sfu1.name 'emp_name',
        sfu1.title as `position`,
        sfu1.isactive `active`,
        sfu1.X1st_Office__c `location`,
		sfu1.managerid 'manager id from emp table',
		sfu2.id 'manager id', 
		sfu2.name 'manager_name'
		from sfusers sfu1
		inner join sfusers sfu2
			on sfu1.managerid = sfu2.id
		) as t2
	on t1.join = t2.emp_id
group by source_funnel, emp_name, manager_name
order by emp_name asc