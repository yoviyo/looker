view: user_order_facts {
  derived_table: {
    sql: SELECT
        user_id,
        count(distinct order_id) as lifetime_order_count,
        sum(sale_price) as lifetime_value,
        min(created_at) as first_order,
        max(created_at) as last_order
      FROM "PUBLIC"."ORDER_ITEMS"
      group by 1
       ;;
    #datagroup_trigger: yovchev_project_default_datagroup
    #sql_trigger_value: select max(id) from order_items ;;
    persist_for: "1 hour"
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}."LIFETIME_ORDER_COUNT" ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}."LIFETIME_VALUE" ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [date, month]
    sql: ${TABLE}."FIRST_ORDER" ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [date, month]
    sql: ${TABLE}."LAST_ORDER" ;;
  }

  measure: average_user_lifetime_value {
    type: average
    sql: ${lifetime_value} ;;
  }

  measure: average_lifetime_order_count {
    type: average
    sql: ${lifetime_order_count} ;;
    }
}
