resource "newrelic_alert_policy" "policy" {

  name = var.policy-name
}

# resource "newrelic_notification_destination" "foo" {
#   name = var.destination.name
#   type = var.destination.type

#   property {
#     key   = var.destination.key
#     value = var.destination.value
#   }
# }
resource "newrelic_notification_channel" "foo" {
  for_each = var.notification
  name           = each.value.name
  type           = each.value.type
  destination_id = each.value.destination_id
  product        = each.value.product

  property {
    key   = each.value.key
    value =each.value.value
  }


}
resource "newrelic_workflow" "workflow" {
  name                  = var.workflow.name
  muting_rules_handling = var.workflow.muting_rules_handling

  issues_filter {
    name = var.workflow.name1
    type = var.workflow.type

    predicate {
      attribute = var.workflow.attribute
      operator  = var.workflow.operator
      values    = [newrelic_alert_policy.policy.id]
    }
  }

  # destination {
  #   channel_id            = newrelic_notification_channel.foo.id
  #   notification_triggers = var.workflow.notification_triggers
  # }
   dynamic "destination" {
    for_each = newrelic_notification_channel.foo
    content {
      channel_id = destination.value.id
    }
}
}