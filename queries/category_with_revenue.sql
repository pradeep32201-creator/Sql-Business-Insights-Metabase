with category_sale as (

	select c.category_id,
			c.category_name,
			sum(ot.qty) unit_sold,
			sum(line_total) revenue,
			count(distinct ot.order_id) order_with_category

			from ecom.categories c
			join ecom.products p 
			on  c.category_id = p.category_id
			join ecom.product_variants pv 
			on p.product_id=pv.product_id
			
			join ecom.order_items ot
			on ot.variant_id = pv.variant_id
			join ecom.orders o 
			on o.order_id= ot.order_id

			where lower(o.status) in ('delivered','packed','paid','shipped')

			group by 1,2

	),category_refund as (
			select c.category_id,
					c.category_name,
					count(distinct order_id) as returns

			from ecom.return_items rt  
			join ecom.order_items ot
			on rt.variant_id = ot.variant_id
			join ecom.product_variants pv 
			on rt.variant_id = pv.variant_id
			join ecom.products p
			on pv.product_id=p.product_id
			join ecom.categories c
			on  c.category_id = p.category_id

			group by 1,2


	)
			select cs.category_name as category , 
			order_with_category,
			unit_sold,
			revenue,
			coalesce(returns,0) as returns,
			coalesce(returns,0)*100.0 / nullif(order_with_category,0) as return_rate_pct
			from category_sale cs
			left join category_refund cr
			on cs.category_id = cr.category_id
			order by revenue desc
    
