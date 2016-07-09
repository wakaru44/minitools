#!/bin/bash

 aws  ec2 describe-instances  --query 'Reservations[*].Instances[*].[InstanceId,PublicDnsName,KeyName]'  --output json 

