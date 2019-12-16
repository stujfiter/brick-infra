#! /bin/bash

usage()
{
    echo "usage: up.sh [[-s stackname ] [-p dbpassword] [-a authcode] | [-h]]"
}

stackname=
dbpassword=
authcode=

while [ "$1" != "" ]; do
    case $1 in
        -s | --stackname )     shift
                                stackname=$1
                                ;;
        -p | --dbpassword )     shift
                                dbpassword=$1
                                ;;
        -a | --authcode )       shift
                                authcode=$1
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

if [ -z "$dbpassword" ]; then
  usage
  exit 1
fi

if [ -z "$authcode" ]; then
  usage
  exit 1
fi

aws cloudformation create-stack \
  --stack-name ${stackname} \
  --template-body file://ec2.yaml \
  --parameters ParameterKey=PostgresPwd,ParameterValue=${dbpassword} \
               ParameterKey=AuthCode,ParameterValue=${authcode}
