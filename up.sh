#! /bin/bash

usage()
{
    echo "usage: up.sh [[-s stackname ] | [-h]]"
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
  aws cloudformation create-stack --stack-name ${stackname} --template-body file://ec2.yaml
fi
