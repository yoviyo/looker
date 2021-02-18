view: customer_orders {
  derived_table: {
    sql:
    SELECT
    customer_id,
    COUNT(*) AS lifetime_orders
    FROM orders ;;
    datagroup_trigger: 8am_trigger
  }
}
