WITH 
-- subquery to pull the dialpad calls of an MRM
call_history as (
	SELECT
		OwnerId owner_id,
		Dialpad__ActivityDate__c created_date,
		Dialpad__CallDurationInSeconds__c call_duration_sec
	FROM dialpad.call_log
	WHERE
		Dialpad__ActivityDate__c between "2025-01-01" and "2025-12-31"
		AND Dialpad__CallType__c = "outbound"
	ORDER BY created_date ASC),

-- subquery to pull the MRM name, position, and team
sf_users as (
	SELECT DISTINCT name, 
	id,
    title as position,
    Current_Team__c as sales_team
	FROM salesforce.sfusers 
	WHERE isactive = 1),

-- subquery to pull the manager of the MRM
sf_users_manager as (
	SELECT
		sfu1.id 'emp_id', 
		sfu1.name 'emp_name', 
		sfu1.managerid 'manager id from emp table',
		sfu2.id 'manager id', 
		sfu2.name 'manager_name'
		FROM salesforce.sfusers sfu1
		INNER JOIN salesforce.sfusers sfu2
			ON sfu1.managerid = sfu2.id),
            
-- subquery to pull opps and deal related data for MRM
sf_opps_deals as (
	SELECT DISTINCT
		sfo.Process_Tracking_For_Formula__c as `mrm_name`,
        sfo.CreatedById as `id`,
		DATE_FORMAT(sfo.CreatedDate, "%Y-%m-%d") as `c_date`,
		COUNT(sfo.Case_Review_Set__c) as `cr_set`,
		COUNT(sfo.Case_Review_Completed__c) as `cr_comp`,
		COUNT(sfd.First_Installment_processed_on__c) as `deal_count`,
		SUM(sfd.Membership_Fee_After_Discount__c) as `deal_revenue`
		FROM salesforce.sfopportunity as sfo
		LEFT JOIN salesforce.sfdeal as sfd
			ON sfo.id = sfd.Opportunity__c
			
		WHERE
		sfo.CreatedDate between "2025-01-01" and "2025-12-31"
        AND
        sfo.Lead_Source__c not in ('RENEWAL','UPGRADE','EARLY RENEWAL')
        GROUP BY mrm_name, c_date
        ORDER BY mrm_name ASC, c_date ASC
        )

-- main query to return aggregated performance data by created date and MRM
SELECT 
	DATE_FORMAT(created_date, "%Y-%m-%d") as created_date,
	name, 
	COUNT(owner_id) as call_count,  
	ROUND(AVG(call_duration_sec),0) as avg_call_length_secs,
    cr_set,
    cr_comp,
    deal_count,
    deal_revenue,
	position,
    sales_team,
    manager_name,
	COUNT(DISTINCT created_date) as days_in_data
FROM call_history
INNER JOIN sf_users
	ON call_history.owner_id = sf_users.id
INNER JOIN sf_users_manager
	ON sf_users.id = sf_users_manager.emp_id
LEFT JOIN sf_opps_deals
	ON call_history.owner_id = sf_opps_deals.id
    AND call_history.created_date = sf_opps_deals.c_date
WHERE position <> "KAM"
AND sales_team NOT IN ('Team KAM', 'Special Ops', 'KAM', 'Intake', 'Collections', 'Member Services', 'Renewals')
GROUP BY name, created_date, owner_id
ORDER BY name ASC, created_date ASC
;