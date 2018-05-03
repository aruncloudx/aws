resource "aws_emr_cluster" "cluster" {
  name           = "${var.name}"
  release_label  = "${var.release_label}"
  applications   = "${var.applications}"
  configurations = "${var.configurations}"

  termination_protection = false
  keep_job_flow_alive_when_no_steps = true


   ec2_attributes {
    key_name                          = "${var.key_name}"
    subnet_id                         = "${var.subnet_id}"
    emr_managed_master_security_group = "${aws_security_group.emr_master.id}"
    emr_managed_slave_security_group  = "${aws_security_group.emr_slave.id}"
    instance_profile                  = "${aws_iam_instance_profile.emr_ec2_instance_profile.arn}"
  }
  
instance_group {
      instance_role = "CORE"
      instance_type = "c4.large"
      instance_count = "1"
      ebs_config {
        size = "40"
        type = "gp2"
        volumes_per_instance = 1
      }
      bid_price = "0.30"
      autoscaling_policy = <<EOF
{
"Constraints": {
  "MinCapacity": 1,
  "MaxCapacity": 2
},
"Rules": [
  {
    "Name": "ScaleOutMemoryPercentage",
    "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
    "Action": {
      "SimpleScalingPolicyConfiguration": {
        "AdjustmentType": "CHANGE_IN_CAPACITY",
        "ScalingAdjustment": 1,
        "CoolDown": 300
      }
    },
    "Trigger": {
      "CloudWatchAlarmDefinition": {
        "ComparisonOperator": "LESS_THAN",
        "EvaluationPeriods": 1,
        "MetricName": "YARNMemoryAvailablePercentage",
        "Namespace": "AWS/ElasticMapReduce",
        "Period": 300,
        "Statistic": "AVERAGE",
        "Threshold": 15.0,
        "Unit": "PERCENT"
      }
    }
  }
]
}
EOF
}
  ebs_root_volume_size     = 50

  master_instance_type = "m3.xlarge"

}
