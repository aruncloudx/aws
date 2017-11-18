import boto3

__author__ = 'arun'

client = boto3.client(
    'elb',
    region_name='us-west-2',
)

response = client.create_load_balancer(
    LoadBalancerName='emr-lb2',
    Listeners=[
        {
            'Protocol': 'HTTP',
            'LoadBalancerPort': 3389,
            'InstanceProtocol': 'HTTP',
            'InstancePort': 8809,
        },
    ],
    Subnets=[
        'subnet-6f8c9829',
    ],
    SecurityGroups=[
        'sg-430d8d26',
    ],
    Scheme='internal',
    Tags=[
        {
            'Key': 'Name',
            'Value': 'emr-elb'
        },
        {
            'Key': 'Owner',
            'Value': 'asiri1'
        },
    ]
)
print(response)
