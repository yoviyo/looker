# If necessary, uncomment the line below to include explore_source.

# include: "yovchev_project.model.lkml"
explore: user_facts {}
view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: order_id { field: order_items.order_id }
      column: created_time { field: order_items.created_time }
      column: total_sale_price { field: order_items.total_sale_price }

      derived_column: order_sequence_number {
        sql: rank() over (partition by user_id order by created_time asc) ;;
      }

      derived_column: order_rank_by_sale_price {
        sql: rank() over (partition by user_id order by total_sale_price desc) ;;
      }

      derived_column: user_order_count {
        sql: count(user_id) over (partition by user_id) ;;
      }
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: order_id {
    type: number
  }
  dimension: created_time {
    type: date_time
  }
  dimension: total_sale_price {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: order_sequence_number {
    type: number
  }
  dimension: order_rank_by_sale_price {
    type: number
  }
  dimension: user_order_count {
    type: number
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: average_order_price {
    type: number
    value_format_name: usd
    sql: sum(${total_sale_price})/NULLIF(${count_users},0) ;;
  }
}
