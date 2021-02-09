view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  # ----- CUSTOM MADE ------

  dimension_group: shipping_time {
    label: "Shipping times"
    type: duration
    intervals: [
      hour,
      day,
      week
  ]
  sql_start: ${created_raw} ;;
  sql_end: ${shipped_raw} ;;
  }

  dimension: long_shipping_time {
    description: "Yes means the order took over 7 days to ship"
    type: yesno
    sql: ${days_shipping_time} > 7 ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name:  usd
  }

  # ----- CUSTOM MADE END ------

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    label: "Number of order items"
    type: count
    drill_fields: [order_detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
  set: order_detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      orders.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
