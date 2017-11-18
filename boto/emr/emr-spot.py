import boto3

__author__ = 'arun'

connection = boto3.client(
    'emr',
    region_name='us-west-2',
)

cluster_id = connection.run_job_flow(
    Name='arun_emr_spot_job_with_boto3',
    LogUri='s3://aws-logs-902498075213-us-west-2',
    ReleaseLabel='emr-5.8.0',
    Instances={
        'InstanceFleets': [
         {
        "Name": "Masterfleet",
        "InstanceFleetType": "MASTER",
        "TargetSpotCapacity": 1,
        "LaunchSpecifications": {
            "SpotSpecification": {
                "TimeoutDurationMinutes": 5,
                "BlockDurationMinutes": 120,
                "TimeoutAction": "SWITCH_TO_ON_DEMAND"
            }
        },
        "InstanceTypeConfigs": [
            {
                "InstanceType": "m4.xlarge",
                "BidPriceAsPercentageOfOnDemandPrice": 75
            }
        ]
    },
    {
        "Name": "Corefleet",
        "InstanceFleetType": "CORE",
        "TargetSpotCapacity": 1,
        "LaunchSpecifications": {
            "SpotSpecification": {
                "TimeoutDurationMinutes": 5,
                "BlockDurationMinutes": 120,
                "TimeoutAction": "SWITCH_TO_ON_DEMAND"
            }
        },
        "InstanceTypeConfigs": [
            {
                "InstanceType": "m4.xlarge",
                "BidPriceAsPercentageOfOnDemandPrice": 75
            }
        ]
    },
    {
        "Name": "Taskfleet",
        "InstanceFleetType": "TASK",
        "TargetSpotCapacity": 1,
        "LaunchSpecifications": {
            "SpotSpecification": {
                "TimeoutDurationMinutes": 5,
                "BlockDurationMinutes": 120,
                "TimeoutAction": "SWITCH_TO_ON_DEMAND"
            }
        },
        "InstanceTypeConfigs": [
            {
                "InstanceType": "r3.xlarge",
                "BidPriceAsPercentageOfOnDemandPrice": 75
            }
        ]
    }
        ],
        'Ec2KeyName': 'demo',
        'KeepJobFlowAliveWhenNoSteps': True,
        'TerminationProtected': False,
        'Ec2SubnetId': 'subnet-d31accb6',
    },
    Steps=[],
    VisibleToAllUsers=True,
    JobFlowRole='EMR_EC2_DefaultRole',
    ServiceRole='EMR_DefaultRole',
    Tags=[
        {
            'Key': 'Owner',
            'Value': 'arun',
        },
        {
            'Key': 'Env',
            'Value': 'Dev',
        },
    ],
)

print (cluster_id['JobFlowId'])
