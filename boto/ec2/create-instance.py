import boto3
print("Started...")
print("...Creating EC2 instance...")
client = boto3.resource('ec2', region_name = 'us-west-2')

instances = client.create_instances(


    ImageId = 'ami-0b5f073b',
    MinCount = 1,
    MaxCount = 2,
    InstanceType = 't2.micro',
    KeyName = 'cloud',
    )


for instance in instances:
    instance.create_tags(
          Tags=[
              {
                  'Key': 'Owner',
                  'Value': 'arun'
              },
          ]
      )
