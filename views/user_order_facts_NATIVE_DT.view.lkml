view: user_order_facts_native_dt {
  derived_table: {
    #Step 1: Pick an explore from your model
    explore_source: order_items {
      #Step 2: Pick fields from that explore. (These can be dimensions or measures.)
      column: user_id {field: order_items.user_id}
      column: lifetime_number_of_orders {field: order_items.order_count}
      column: lifetime_customer_value {field: order_items.total_revenue}
    }
  }
  # Step 3: Define the view's fields as with a normal derived table.
  # Note that what was a measure in the source explore can now be defined as a dimension!
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: lifetime_number_of_orders {
    type: number
    sql: ${TABLE}.lifetime_number_of_orders ;;
  }
  dimension: lifetime_customer_value {
    type: number
    sql: ${TABLE}.lifetime_customer_value ;;
  }
}

#Note how the `derived_table` parameter has changed. Rather than using a `sql` parameter to manually define a query, an NDT uses the `explore_source` parameter to define the explore that should be used to generate the query. You can basically imagine this step as Looker creating a big WITH statement using the fields chosen, and the tables and joins defined in the source explore.

#From there we proceed as normal to define the view's dimensions and measures. So, we can dimensionalize a measure by including the measure as one of the `column`s, then defining a dimension to pull that data. The above NDT is demonstrating this by bringing in two measures (order_items.order_count and order_items.total_revenue) and then using a dimension to surface them to the view.
