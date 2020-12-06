variable alarm_name { type = string }
variable comparison_operator { type = string }
variable evaluation_periods { type = string }
variable metric_name { type = string }
variable namespace { type = string }
variable period { type = number }
variable statistic { type = string }
variable threshold { type = string }
variable alarm_description { type = string }
variable alarm_actions { type = list }
variable dimensions { type = map }
variable datapoints_to_alarm { type = number }

resource aws_cloudwatch_metric_alarm alarm {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description
  alarm_actions       = var.alarm_actions
  dimensions          = var.dimensions
  datapoints_to_alarm = var.datapoints_to_alarm
  #insufficient_data_actions = []
}
