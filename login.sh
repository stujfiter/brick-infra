#!/bin/bash

usage()
{
    echo "usage: login.sh [[-i certificate] [-s stackname] | [-h]]"
}

stackname=
certificate=

while [ "$1" != "" ]; do
    case $1 in
        -s | --stack-name )     shift
                                stackname=$1
                                ;;
        -i | --certificate )    shift
                                certificate=$1
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
fi

if [ -z "$certificate" ]; then
  usage
  exit 1
fi

instanceId=$(aws cloudformation describe-stack-resources --stack-name ${stackname} | jq -r '.StackResources[] | .PhysicalResourceId')
publicDnsName=$(aws ec2 describe-instances --instance-ids $instanceId | jq -r '.Reservations[] | .Instances[] | .PublicDnsName')
ssh -o "StrictHostKeyChecking=no" -i $certificate ubuntu@$publicDnsName