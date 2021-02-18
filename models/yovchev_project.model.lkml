connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: yovchev_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: yovchev_project_default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  join: user_order_facts {
    type: left_outer
    sql_on:  ${user_order_facts.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users{
  join: order_items {
    type:  left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: user_order_facts_new {
    type:  left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_order_facts_new.user_id} ;;
  }
}

explore: user_order_facts {}

access_grant: yovi_only {

  user_attribute: locale

  allowed_values: [ "en" ]

}
