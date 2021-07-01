{{ 
  config(
    materialized='table',
    sort='start_tstamp',
    dist='domain_userid'
  ) 
}}


select
  a.*

from {{ var('snowplow__sessions_table') }} a
inner join {{ ref('snowplow_web_users_userids_this_run') }} b
on a.domain_userid = b.domain_userid

where a.start_tstamp >= (select lower_limit from {{ ref('snowplow_web_users_limits') }})
and   a.start_tstamp <= (select upper_limit from {{ ref('snowplow_web_users_limits') }})
