#! /bin/bash

aws ec2 describe-instances | jq -r '.Reservations[] | .Instances[]| select(has("Tags") and .State.Name == "running") | .PublicIpAddress'

