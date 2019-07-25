#!/bin/bash

usage()
{
    echo "usage: login.sh [[-s stackname ] | [-h]]"
}

stackname=

while [ "$1" != "" ]; do
    case $1 in
        -s | --stack-name )     shift
                                stackname=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ -z "$stackname" ]; then
  usage
  exit 1
else
  instanceId=$(aws cloudformation describe-stack-resources --stack-name ${stackname} | jq -r '.StackResources[] | .PhysicalResourceId')
  publicDnsName=$(aws ec2 describe-instances --instance-ids $instanceId | jq -r '.Reservations[] | .Instances[] | .PublicDnsName')
  echo $publicDnsName
fi
