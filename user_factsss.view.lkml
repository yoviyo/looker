view: user_factsss {
  derived_table: {
    sql: SELECT
        users."ID"  AS "users.id",
        order_items."ORDER_ID"  AS "order_items.order_id",
        TO_CHAR(DATE_TRUNC('second', CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(order_items."CREATED_AT"  AS TIMESTAMP_NTZ))), 'YYYY-MM-DD HH24:MI:SS') AS "order_items.created_time",
        COALESCE(SUM((order_items."SALE_PRICE") ), 0) AS "order_items.total_sale_price"
      FROM "PUBLIC"."ORDER_ITEMS"
           AS order_items
      LEFT JOIN "PUBLIC"."USERS"
           AS users ON (order_items."USER_ID") = (users."ID")

      GROUP BY 1,2,DATE_TRUNC('second', CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(order_items."CREATED_AT"  AS TIMESTAMP_NTZ)))
      ORDER BY 1
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}."users.id" ;;
  }

  dimension: order_items_order_id {
    type: number
    sql: ${TABLE}."order_items.order_id" ;;
  }

  dimension: order_items_created_time {
    type: string
    sql: ${TABLE}."order_items.created_time" ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}."order_items.total_sale_price" ;;
  }

  set: detail {
    fields: [users_id, order_items_order_id, order_items_created_time, order_items_total_sale_price]
  }
}
