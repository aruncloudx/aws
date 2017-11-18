import boto3

__author__ = 'arun'

client = boto3.client(
    'ec2',
    region_name='us-west-2',
)

response = client.create_volume(
    AvailabilityZone='us-west-2c',
    Encrypted=False,
    Size=10,
    VolumeType='gp2',


 )

print(response)
