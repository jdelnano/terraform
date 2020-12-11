#######
# dns #
#######
module joechem_io_dns {
  source = "./dns"

  domain  = "joechem.io"
  records = var.joechem_io_domain_info
}
module joechem_org_dns {
  source = "./dns"

  domain  = "joechem.org"
  records = var.joechem_org_domain_info
}

#########
# email #
#########
resource aws_ses_email_identity email {
  email = var.email
}
module prod-joechem-ses {
  source = "./email"

  domain       = var.prod_domain
  route53_zone = var.prod_domain
}
module staging-joechem-ses {
  source = "./email"

  domain       = var.staging_domain
  route53_zone = var.prod_domain
}

module billing-alarm {
  source = "./alarms"

  alarm_name          = "BillingAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600
  statistic           = "Maximum"
  # monthly bill
  threshold           = "30"
  alarm_description   = "Billing alarm"
  alarm_actions       = ["arn:aws:sns:us-east-1:${data.aws_caller_identity.current.id}:NotifyMe"]
  datapoints_to_alarm = 1
  dimensions = {
    "Currency" = "USD"
  }
}

module billing-alert {
  source = "./sns"

  name            = "NotifyMe"
  account_id      = data.aws_caller_identity.current.id
  protocol        = "email"
  endpoint        = var.email
  delivery_policy = <<EOF
 {
   "http": {
     "defaultHealthyRetryPolicy": {
       "minDelayTarget": 20,
       "maxDelayTarget": 20,
       "numRetries": 3,
       "numMaxDelayRetries": 0,
       "numNoDelayRetries": 0,
       "numMinDelayRetries": 0,
       "backoffFunction": "linear"
     },
     "disableSubscriptionOverrides": false,
     "defaultThrottlePolicy": {
       "maxReceivesPerSecond": 1
     }
   }
 }
 EOF
}
