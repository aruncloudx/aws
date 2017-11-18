import boto3

__author__ = 'arun'

connection = boto3.client(
    'emr',
    region_name='us-west-2',
)

cluster_id = connection.run_job_flow(
    Name='arun_emr_job',
    LogUri='s3://aws-logs-902498075213-us-west-2',
    ReleaseLabel='emr-5.8.0',
    Applications=[{ 'Name':'Hadoop'},{'Name':'Hive'},{'Name':'Ganglia'}],
    Instances={
        'InstanceGroups': [
            {
                'Name': "Master nodes",
                'Market': 'ON_DEMAND',
                'InstanceRole': 'MASTER',
                'InstanceType': 'm3.xlarge',
                'InstanceCount': 1,
            },
            {
                'Name': "Master nodes",
                'Market': 'ON_DEMAND',
                'InstanceRole': 'CORE',
                'InstanceType': 'm3.xlarge',
                'InstanceCount': 1,
            },
            {
                'Name': "Slave nodes",
                'Market': 'ON_DEMAND',
                'InstanceRole': 'TASK',
                'InstanceType': 'm3.xlarge',
                'InstanceCount': 1
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
