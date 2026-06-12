with refund_summary as (
	select order_id,
			sum(amount) as refund
	from ecom.refunds
	where lower(status) = 'succeeded'
	group by 1
), daily_metrics as (  


select date_trunc('day',o.created_at) order_date,
		sum(case when lower(status) in ('paid', 'shipped','packed', 'delivered') then total else 0 end  ) as revenue,
		sum(case when lower(status) in ('paid', 'shipped','packed', 'delivered') then 1 else 0 end ) as orders, 
		round(sum(case when lower(status) in ('paid', 'shipped','packed', 'delivered') then total else 0 end  )/sum(case when lower(status) in ('paid', 'shipped','packed', 'delivered') then 1 else 0 end ),2) as  aov,
		round(sum(case when lower(status) = 'paid' then 1 else 0 end)*100.0/count (*) ,2) as paid_order_rate,
		round(sum(case when lower(status) = 'cancelled' then 1 else 0 end) *100.0 / count (*) ,2) as cancelled_order_rate,
		sum(coalesce(r.refund,0)) as refund
		 
		
from ecom.orders o
left join refund_summary r 
on o.order_id = r.order_id
group by date_trunc('day',created_at)
)
select order_date,
		revenue,
		orders,
		aov,
		paid_order_rate,
		cancelled_order_rate,
		refund,
		round((revenue- lag(revenue) over (order by order_date )) * 100.0 /nullif(lag(revenue) over (order by order_date ),0),2) as revenue_vs_yesterday_pct,
		round((revenue- lag(revenue,7) over (order by order_date )) * 100.0 /nullif(lag(revenue,7) over (order by order_date ),0),2) as revenue_vs_last_weekday_pct

	from daily_metrics
		

