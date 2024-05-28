PUT  file://C:/<path>/mock_data/run_one/d_customer/d_customer_one.csv @%d_customer_raw;
PUT file://C:<path>\mock_data\run_two\d_customer\d_customer_two.csv @%d_customer_raw;

-- create stream on d_customer_landing
create or replace stream d_customer_landing_stream on table d_customer_landing;

-- task to truncate d_customer_raw, one day
create or replace task truncate_d_customer_raw
warehouse=compute_wh
schedule='1 minute' 
as
truncate table d_customer_raw;

-- task to get data from csv to d_customer_raw
create or replace task csv_to_d_customer_raw
warehouse=compute_wh
after truncate_d_customer_raw
as
copy into d_customer_raw
from @%d_customer_raw
file_format=(type=CSV, skip_header=1);

-- task to merge data from d_customer_raw to d_customer_landing (scd1)
create or replace task raw_to_d_customer_landing
warehouse=compute_wh
after csv_to_d_customer_raw
as
merge into d_customer_landing landing
using (select * from d_customer_raw) raw
on landing.customer_id = raw.customer_id
when matched and (landing.customer_name!=raw.customer_name or landing.state!=raw.state or landing.is_active!=raw.is_active)
then
update set 
landing.customer_name=raw.customer_name,
landing.state=raw.state,
landing.is_active=raw.is_active
when not matched
then
insert(customer_id,customer_name,state,is_active) values(raw.customer_id,raw.customer_name,raw.state,raw.is_active);

-- task to load data from d_customer_landing to stage_table using streams (scd2)
create or replace task d_customer_landing_to_staging
warehouse=compute_wh
after raw_to_d_customer_landing
when
system$stream_has_data('d_customer_landing_stream')
as
merge into d_customer_staging staging
using (select * from d_customer_landing_stream) strm
on staging.customer_id = strm.customer_id
and staging.customer_name=strm.customer_name
and staging.state=strm.state
and staging.is_active = strm.is_active
when matched and (strm.metadata$action='DELETE')
then
update set 
customer_name=strm.customer_name,
state= strm.state,
is_active = 0
when not matched and (strm.metadata$action='INSERT') and strm.is_active=1
then
insert(customer_id,customer_name,state,is_active)
values (strm.customer_id,strm.customer_name,strm.state,strm.is_active);

-- task to remove all the files from stage
Create or replace task d_customer_stage_file_remove
warehouse=compute_wh
after raw_to_d_customer_landing
as
remove @%d_customer_raw     