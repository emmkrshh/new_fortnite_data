SELECT * FROM fraud_insurance_claims LIMIT 10;

PRAGMA table_info(fraud_insurance_claims);

-- Creating separate tables to practice join statements 

create table policy (
    policy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_number INTEGER UNIQUE,
    policy_bind_date VARCHAR(50),
    policy_state VARCHAR(50),
    policy_csl VARCHAR(50),
    policy_deductable INTEGER,
    policy_annual_premium REAL,
    umbrella_limit INTEGER,
    insured_zip INTEGER,
    insured_sex VARCHAR(50),
    insured_education_level VARCHAR(50),
    insured_occupation VARCHAR(50),
    insured_hobbies VARCHAR(50),
    insured_relationship VARCHAR(50),
    months_as_customer INTEGER,
    age INTEGER,
    capital_gains INTEGER,
    capital_loss INTEGER
);

create table incident (
    incident_id INTEGER PRIMARY KEY AUTOINCREMENT,
    incident_date VARCHAR(50),
    incident_type VARCHAR(50),
    collision_type VARCHAR(50),
    incident_severity VARCHAR(50),
    authorities_contacted VARCHAR(50),
    incident_state VARCHAR(50),
    incident_city VARCHAR(50),
    incident_location VARCHAR(50),
    incident_hour_of_the_day INTEGER,
    number_of_vehicles_involved INTEGER,
    property_damage VARCHAR(50),
    bodily_injuries INTEGER,
    witnesses INTEGER,
    police_report_available VARCHAR(50),
    total_claim_amount INTEGER,
    injury_claim INTEGER,
    property_claim INTEGER,
    vehicle_claim INTEGER,
    auto_make VARCHAR(50),
    auto_model VARCHAR(50),
    auto_year INTEGER,
    fraud_reported VARCHAR(50),
    policy_number INTEGER,  -- Foreign key referencing policy table
    FOREIGN KEY (policy_number) REFERENCES policy(policy_number)
);

ALTER TABLE fraud_insurance_claims RENAME COLUMN "capital-gains" TO capital_gains;
ALTER TABLE fraud_insurance_claims RENAME COLUMN "capital-loss" TO capital_loss;

-- Inserting data into tables 
insert into policy (
    policy_number,
    policy_bind_date,
    policy_state,
    policy_csl,
    policy_deductable,
    policy_annual_premium,
    umbrella_limit,
    insured_zip,
    insured_sex,
    insured_education_level,
    insured_occupation,
    insured_hobbies,
    insured_relationship,
    months_as_customer,
    age,
    capital_gains,
    capital_loss
)
select
    policy_number,
    policy_bind_date,
    policy_state,
    policy_csl,
    policy_deductable,
    policy_annual_premium,
    umbrella_limit,
    insured_zip,
    insured_sex,
    insured_education_level,
    insured_occupation,
    insured_hobbies,
    insured_relationship,
    months_as_customer,
    age,
    capital_gains,
    capital_loss
from fraud_insurance_claims;

insert into incident (
    incident_date,
    incident_type,
    collision_type,
    incident_severity,
    authorities_contacted,
    incident_state,
    incident_city,
    incident_location,
    incident_hour_of_the_day,
    number_of_vehicles_involved,
    property_damage,
    bodily_injuries,
    witnesses,
    police_report_available,
    total_claim_amount,
    injury_claim,
    property_claim,
    vehicle_claim,
    auto_make,
    auto_model,
    auto_year,
    fraud_reported,
    policy_number
)
select
    incident_date,
    incident_type,
    collision_type,
    incident_severity,
    authorities_contacted,
    incident_state,
    incident_city,
    incident_location,
    incident_hour_of_the_day,
    number_of_vehicles_involved,
    property_damage,
    bodily_injuries,
    witnesses,
    police_report_available,
    total_claim_amount,
    injury_claim,
    property_claim,
    vehicle_claim,
    auto_make,
    auto_model,
    auto_year,
    fraud_reported,
    policy_number
from fraud_insurance_claims;

-- testing data inserted 
select * from incident limit 10 
select * from policy limit 10

-- Practice Queries 

-- finding the difference between how long the policy holder has been with the company and when the incident occurred 

select 
p.policy_number,
f.incident_date,
p.policy_bind_date, 
JULIANDAY(f.incident_date) - JULIANDAY(p.policy_bind_date) AS days_since_policy_bound
from 
    fraud_insurance_claims f
join 
    policy p ON f.policy_number = p.policy_number
where 
    JULIANDAY(f.incident_date) - JULIANDAY(p.policy_bind_date) > 365
order by 
    days_since_policy_bound DESC;


-- finding the total claim amount for each policy holder within the first year of their policy 

select 
p.policy_number, 
SUM(f.total_claim_amount) as total_claims_in_the_first_year 
from 
fraud_insurance_claims f 
join 
policy p on f.policy_number = p.policy_number 
where 
julianday(f.incident_date) - julianday(p.policy_bind_date) <= 365 
group by 
p.policy_number having 
sum(f.total_claim_amount) > 10000;

-- finding the average claim amount for each month in the year 2015 and joining with policy data 

select 
 strftime('%Y-%m', date(f.incident_date)) as incident_month,
 avg(f.total_claim_amount) as avg_claim_amount,
 count(f.policy_number) as total_claims
from 
    fraud_insurance_claims f
join 
 policy p on f.policy_number = p.policy_number
where 
 date(f.incident_date) between '2015-01-01' and '2015-12-31'
group by 
 incident_month 
order by 
 incident_month;

-- finding the avg time between policy bind date and the incidate date for each state 

select 
    f.incident_state,
    avg(julianday(f.incident_date) - julianday(p.policy_bind_date)) as avg_days_between
from 
    fraud_insurance_claims f
join 
    policy p on f.policy_number = p.policy_number
where 
    f.incident_date is not null 
    and p.policy_bind_date is not null
group by 
    f.incident_state
order by 
    avg_days_between desc;

-- finding total claims for each state, total claim amount for each state, avg claim amount, and the avg numver of days between date and policy bind date for claims >100,000

select 
    f.incident_state,
    count(f.policy_number) as total_claims,
    sum(f.total_claim_amount) as total_claim_amount,
    avg(f.total_claim_amount) as avg_claim_amount,
    avg(
        case 
            when f.total_claim_amount > 100000 then julianday(f.incident_date) - julianday(p.policy_bind_date)
            else null
        end
    ) as avg_days_between_incident_and_policy_bind_for_large_claims
from 
  fraud_insurance_claims f
join 
    policy p on f.policy_number = p.policy_number
where 
  f.incident_date is not null
  and p.policy_bind_date is not null
group by 
  f.incident_state
order by 
  total_claim_amount desc;

-- finding the highest claim amount by state 
select 
    p.policy_state,
    f.policy_number,
    f.total_claim_amount,
    max(f.total_claim_amount) over (partition by p.policy_state) as max_claim_in_state
from 
    fraud_insurance_claims f
join 
    policy p on f.policy_number = p.policy_number;

-- using "like" in place of regex - SQLite (database server) doesnt support regex in queries 
-- finding rows where the insureds occupation is "sales"

select
    policy_number, 
    insured_occupation
from 
    policy
where 
    lower(insured_occupation) like '%sales%';


-- count of policies vs claims by state 

select
  state,
  sum(case when source = 'policy' then 1 else 0 end) as policy_count,
  sum(case when source = 'claim' then 1 else 0 end) as claim_count
from (
  select
    policy_state as state,
    'policy' as source
  from policy
  union all
  select
    incident_state as state,
    'claim' as source
  from fraud_insurance_claims
)
group by state
order by state;

