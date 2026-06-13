select coalesce(sc.channel,'direct') as channel ,
		count(distinct st.session_id) as sessions,
		count(distinct case when event_type = 'product_view' then st.session_id end) as product_view_session,
		count(distinct case when event_type = 'add_to_cart' then st.session_id end) as add_to_cart_session,
		count(distinct case when event_type = 'begin_checkout' then st.session_id end) as begin_checkout_session,
		count(distinct case when event_type = 'purchase' then st.session_id end) as purchase_session,
		round(count(distinct case when event_type = 'add_to_cart' then st.session_id end)*1.0 /nullif(count(distinct case when event_type = 'product_view' then st.session_id end),0),2)  as view_cart_rate,
		round(count(distinct case when event_type = 'begin_checkout' then st.session_id end)*1.0 /nullif(count(distinct case when event_type = 'add_to_cart' then st.session_id end),0),2) as cart_checkout_rate,
		round(count(distinct case when event_type = 'purchase' then st.session_id end)*1.0/nullif(count(distinct case when event_type = 'begin_checkout' then st.session_id end),0),2) checkout_purchase_rate,
		round(count(distinct case when event_type = 'purchase' then st.session_id end)*1.0/nullif(count(distinct st.session_id),0),2) as session_purchase_rate

from ecom.sessions st 
left join ecom.session_channels sc
on st.session_id = sc.session_id
 left join ecom.session_events s 
on st.session_id= s.session_id

where st.started_at >= '2026-04-19'


group by sc.channel
order by sessions desc
