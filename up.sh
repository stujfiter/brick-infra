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

imageid=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.??-amd64-server-????????' 'Name=state,Values=available' \
  --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)

aws cloudformation create-stack \
  --stack-name ${stackname} \
  --template-body file://ec2.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=PostgresPwd,ParameterValue=${dbpassword} \
               ParameterKey=AuthCode,ParameterValue=${authcode} \
               ParameterKey=ImageId,ParameterValue=${imageid} \
               ParameterKey=StackName,ParameterValue=${stackname}

aws cloudformation wait stack-create-complete --stack-name ${stackname}
