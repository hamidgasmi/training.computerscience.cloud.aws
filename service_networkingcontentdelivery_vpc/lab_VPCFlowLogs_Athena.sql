--1. Create the Athena Table
CREATE EXTERNAL TABLE IF NOT EXISTS default.vpc_flow_logs (
  version int,
  account string,
  interfaceid string,
  sourceaddress string,
  destinationaddress string,
  sourceport int,
  destinationport int,
  protocol int,
  numpackets int,
  numbytes bigint,
  starttime int,
  endtime int,
  action string,
  logstatus string
)  
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
LOCATION 's3://vpc-flow-logs-286339738813-hdg/AWSLogs/286339738813/vpcflowlogs/us-east-1/'
TBLPROPERTIES ("skip.header.line.count"="1");

--2. Create Partitions to Be Able to Read the Data
ALTER TABLE default.vpc_flow_logs
ADD PARTITION (dt='2020-01-05')
location 's3://vpc-flow-logs-286339738813-hdg/AWSLogs/286339738813/vpcflowlogs/us-east-1/2020/01/05';

--3. Analyze VPC Flow Logs Data in Athena
SELECT day_of_week(from_iso8601_timestamp(dt)) AS
  day,
  dt,
  interfaceid,
  sourceaddress,
  destinationport,
  action,
  protocol
FROM vpc_flow_logs
WHERE action = 'REJECT' AND protocol = 6
order by sourceaddress
LIMIT 100;