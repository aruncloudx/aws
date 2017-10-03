import boto3

__author__ = 'arun'

client = boto3.client(
    's3',
    region_name='us-west-2',
)

response = client.create_bucket(
    ACL='private',
    Bucket='cyberhadoopx',
    CreateBucketConfiguration={
        'LocationConstraint': 'us-west-2'
    }
  )
print(response)
