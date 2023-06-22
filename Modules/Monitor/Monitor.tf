resource "azurerm_monitor_action_group" "ActionGroup" {
  name                = "actiongroup-bak-${var.generalvars.client}"
  resource_group_name = var.resourcegroup_name
  short_name          = "agrbak"

  dynamic "email_receiver" {
    for_each = var.email_alerts
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email_address
    }
  }

  dynamic "sms_receiver" {
    for_each = var.sms_alerts
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }
}

locals {
  alert_map = {
    0 = {
      prefix      = "Limit"
      multiplier  = 1
      description = ""
    },
    1 = {
      prefix      = "Limit_50"
      multiplier  = 1.5
      description = "150% of "
    }
    2 = {
      prefix      = "Limit_75"
      multiplier  = 1.75
      description = "175% of "
    }
    3 = {
      name            = "Availability"
      fulldescription = "Action will be triggered when the availability is under 90%"
      window_size     = "PT1H"
      frequency       = "PT5M"
      metric_name     = "Availability"
      operator        = "LessThan"
      aggregation     = "Average"
      threshold       = 90
      prefix          = ""
      multiplier      = 0
      description     = ""
    }
    4 = {
      name            = "Transactions"
      fulldescription = "Action will be triggered when there are more than 50 errros in 5 minutes"
      window_size     = "PT1H"
      frequency       = "PT5M"
      metric_name     = "Transactions"
      operator        = "GreaterThan"
      aggregation     = "Total"
      threshold       = 50
      prefix          = ""
      multiplier      = 0
      description     = ""
  } }
}
resource "azurerm_monitor_metric_alert" "MetricAlert" {
  for_each            = local.alert_map
  name                = lookup(each.value, "name", "UsedCapacity-${each.value.prefix}-Backup-alert-${var.storageaccount[var.metric_alerts.storage_account_id].name}")
  resource_group_name = var.resourcegroup_name
  scopes              = [var.storageaccount[var.metric_alerts.storage_account_id].id]
  description         = lookup(each.value, "fulldescription", "Action will be triggered when UsedCapacity count is greater than ${each.value.description}${var.metric_alerts.description_amount}")
  window_size         = lookup(each.value, "window_size", var.metric_alerts.window_size)
  frequency           = lookup(each.value, "frequency", var.metric_alerts.frequency)

  severity = var.metric_alerts.severity
  enabled  = true

  criteria {
    metric_namespace       = "Microsoft.Storage/storageAccounts"
    metric_name            = lookup(each.value, "metric_name", "UsedCapacity")
    aggregation            = lookup(each.value, "aggregation", "Average")
    operator               = lookup(each.value, "operator", "GreaterThan")
    threshold              = lookup(each.value, "threshold", var.metric_alerts.threshold)
    skip_metric_validation = false
  }

  action {
    action_group_id = azurerm_monitor_action_group.ActionGroup.id
  }
}


data "azurerm_subscription" "current" {}

resource "azurerm_portal_dashboard" "my-board" {
  name                = "dashboard-${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
  resource_group_name = var.resourcegroup_name
  location            = var.generalvars.location_long

  dashboard_properties = <<DASH
{

    "lenses": {
      "0": {
        "order": 0,
        "parts": {
          "0": {
            "position": {
              "x": 0,
              "y": 0,
              "colSpan": 5,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "resourceMetadata": {
                            "id": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
                          },
                          "name": "UsedCapacity",
                          "aggregationType": 4,
                          "namespace": "microsoft.storage/storageaccounts",
                          "metricVisualization": {
                            "displayName": "Used capacity"
                          }
                        }
                      ],
                      "title": "Avg Used capacity for ${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}",
                      "titleKind": 1,
                      "visualization": {
                        "chartType": 2,
                        "legendVisualization": {
                          "isVisible": true,
                          "position": 2,
                          "hideSubtitle": false
                        },
                        "axisVisualization": {
                          "x": {
                            "isVisible": true,
                            "axisType": 2
                          },
                          "y": {
                            "isVisible": true,
                            "axisType": 1
                          }
                        },
                        "disablePinning": true
                      }
                    }
                  }
                }
              }
            }
          },
          "1": {
            "position": {
              "x": 5,
              "y": 0,
              "colSpan": 5,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "resourceMetadata": {
                            "id": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
                          },
                          "name": "Availability",
                          "aggregationType": 4,
                          "namespace": "microsoft.storage/storageaccounts",
                          "metricVisualization": {
                            "displayName": "Availability"
                          }
                        }
                      ],
                      "title": "Avg Availability for ${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}",
                      "titleKind": 1,
                      "visualization": {
                        "chartType": 2,
                        "legendVisualization": {
                          "isVisible": true,
                          "position": 2,
                          "hideSubtitle": false
                        },
                        "axisVisualization": {
                          "x": {
                            "isVisible": true,
                            "axisType": 2
                          },
                          "y": {
                            "isVisible": true,
                            "axisType": 1
                          }
                        },
                        "disablePinning": true
                      }
                    }
                  }
                }
              }
            }
          },
          "2": {
            "position": {
              "x": 10,
              "y": 0,
              "colSpan": 2,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [],
              "type": "Extension/HubsExtension/PartType/ClockPart",
              "settings": {
                "content": {
                  "timezoneId": "Romance Standard Time",
                  "timeFormat": "h:mma",
                  "version": 1
                }
              }
            }
          },
          "3": {
            "position": {
              "x": 0,
              "y": 3,
              "colSpan": 5,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "resourceMetadata": {
                            "id": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
                          },
                          "name": "SuccessE2ELatency",
                          "aggregationType": 4,
                          "namespace": "microsoft.storage/storageaccounts",
                          "metricVisualization": {
                            "displayName": "Success E2E Latency"
                          }
                        },
                        {
                          "resourceMetadata": {
                            "id": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
                          },
                          "name": "SuccessServerLatency",
                          "aggregationType": 4,
                          "namespace": "microsoft.storage/storageaccounts",
                          "metricVisualization": {
                            "displayName": "Success Server Latency"
                          }
                        }
                      ],
                      "title": "Avg Success E2E Latency and Avg Success Server Latency for ${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}",
                      "titleKind": 1,
                      "visualization": {
                        "chartType": 2,
                        "legendVisualization": {
                          "isVisible": true,
                          "position": 2,
                          "hideSubtitle": false
                        },
                        "axisVisualization": {
                          "x": {
                            "isVisible": true,
                            "axisType": 2
                          },
                          "y": {
                            "isVisible": true,
                            "axisType": 1
                          }
                        },
                        "disablePinning": true
                      }
                    }
                  }
                }
              }
            }
          },
          "4": {
            "position": {
              "x": 5,
              "y": 3,
              "colSpan": 5,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "resourceMetadata": {
                            "id": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
                          },
                          "name": "Transactions",
                          "aggregationType": 1,
                          "namespace": "microsoft.storage/storageaccounts",
                          "metricVisualization": {
                            "displayName": "Transactions"
                          }
                        }
                      ],
                      "title": "Sum Transactions for ${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"} by Response type where Response type ≠ 'Success'",
                      "titleKind": 1,
                      "visualization": {
                        "chartType": 2,
                        "legendVisualization": {
                          "isVisible": true,
                          "position": 2,
                          "hideSubtitle": false
                        },
                        "axisVisualization": {
                          "x": {
                            "isVisible": true,
                            "axisType": 2
                          },
                          "y": {
                            "isVisible": true,
                            "axisType": 1
                          }
                        },
                        "disablePinning": true
                      },
                      "filterCollection": {
                        "filters": [
                          {
                            "key": "ResponseType",
                            "operator": 1,
                            "values": [
                              "Success"
                            ]
                          }
                        ]
                      },
                      "grouping": {
                        "dimension": "ResponseType",
                        "sort": 2,
                        "top": 10
                      }
                    }
                  }
                }
              },
              "filters": {
                "ResponseType": {
                  "model": {
                    "operator": "notEquals",
                    "values": [
                      "Success"
                    ]
                  }
                }
              }
            }
          }
        }
      }
    },
    "metadata": {
      "model": {
        "timeRange": {
          "value": {
            "relative": {
              "duration": 24,
              "timeUnit": 1
            }
          },
          "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        },
        "filterLocale": {
          "value": "en-us"
        },
        "filters": {
          "value": {
            "MsPortalFx_TimeRange": {
              "model": {
                "format": "utc",
                "granularity": "auto",
                "relative": "24h"
              },
              "displayCache": {
                "name": "UTC Time",
                "value": "Past 24 hours"
              },
              "filteredPartIds": [
                "StartboardPart-MonitorChartPart-d6522581-262e-4dc5-8b8d-2ed86a210d89",
                "StartboardPart-MonitorChartPart-d6522581-262e-4dc5-8b8d-2ed86a210e96",
                "StartboardPart-MonitorChartPart-d6522581-262e-4dc5-8b8d-2ed86a210ea9",
                "StartboardPart-MonitorChartPart-d6522581-262e-4dc5-8b8d-2ed86a210eb5"
              ]
            }
          }
        }
      }
    },
  "name": "dashboard-${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}",
  "type": "Microsoft.Portal/dashboards",
  "location": "INSERT LOCATION",
  "tags": {
    "hidden-title": "dashboard-${"bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"}"
  },
  "apiVersion": "2015-08-01-preview"
}
DASH
}
