#!/bin/bash

########################################
# List of Variables for script         #
########################################

scriptPath=/path/to/folder

########################################
# List of your AWS Environments        #
########################################

environment=(
123456789012
234567890123
345678901234
)

########################################
# List of the AWS Regions you might be #
# in.  Better to verify more as to     #
# help find any shadow IT.             #
########################################

region=(
us-east-2
us-east-1
us-west-1
us-west-2
ap-south-1
ap-northeast-2
ap-southeast-1
ap-southeast-2
ap-northeast-1
ca-central-1
eu-central-1
eu-west-1
eu-west-2
eu-west-3
eu-north-1
sa-east-1
)

########################################
# Verify the subdirectories exist.  If #
# they do, clear all old files.  If    #
# not, create the directories.         #
########################################

if [ -d "$scriptPath/logs" ]
then
    rm -f $scriptPath/logs/*
else
    mkdir $scriptPath/logs
fi

if [ -d "$scriptPath/.temp" ]
then
    rm -f $scriptPath/.temp/*
else
    mkdir $scriptPath/.temp
fi

########################################
# Loop through the regions and         #
# environments. For the ELBs, pull out #
# the DNS Name. For EC2s, get the      #
# description.                         #
########################################

for i in "${region[@]}"
   do
      echo "Working on Region $i"
      for z in "${environment[@]}"
      do
         echo "Region: $i | Environment: $z"
         aws elb describe-load-balancers --profile $z --region $i | grep "DNSName" | cut -d ':' -f2 | cut -d '"' -f2 >> $scriptPath/.temp/elbdiscribe.txt
         aws elbv2 describe-load-balancers --profile $z --region $i | grep "DNSName" | cut -d ':' -f2 | cut -d '"' -f2 >> $scriptPath/.temp/elbdiscribe.txt

         aws ec2 describe-instances --profile $z --region $i >> $scriptPath/.temp/ec2discribe.json
      done
   done

########################################
# Remove duplicates from the ELB list  #
########################################

sort $scriptPath/.temp/elbdiscribe.txt | uniq >> $scriptPath/.temp/elbdiscribe-clean.txt
sed -i '/^$/d' $scriptPath/.temp/elbdiscribe-clean.txt

########################################
# Get IPs for DNS Names.  The sed line #
# contains a line to remove the 10.*   #
# internal IP range.  If you have more #
# internal ranges, duplicate the line. #
########################################

while read line;
   do
      dig @8.8.8.8 +short $line >> $scriptPath/.temp/digELB.txt
      sed '/^10./d' $scriptPath/.temp/digELB.txt >> $scriptPath/.temp/digELB-clean.txt
   done < $scriptPath/.temp/elbdiscribe-clean.txt

########################################
# Remove duplicates from the EC2 list  #
########################################

cat $scriptPath/.temp/ec2discribe.json | grep "PublicDnsName" | cut -d ':' -f2 | cut -d '"' -f2 >> $scriptPath/.temp/ec2_dns.txt
sort $scriptPath/.temp/ec2_dns.txt | uniq >> $scriptPath/.temp/ec2_dns-clean.txt
sed -i '/^$/d' $scriptPath/.temp/ec2_dns-clean.txt

########################################
# Get IPs for DNS Names.  The sed line #
# contains a line to remove the 10.*   #
# internal IP range.  If you have more #
# internal ranges, duplicate the line. #
########################################

while read line;
   do
      dig @8.8.8.8 +short $line >> $scriptPath/.temp/digEC2.txt
      sed '/^10./d' $scriptPath/.temp/digEC2.txt >> $scriptPath/.temp/digEC2-clean.txt
   done < $scriptPath/.temp/ec2_dns-clean.txt

########################################
# Build a list of Public IP address    #
# from the EC2 description.            #
########################################

cat $scriptPath/.temp/ec2discribe.json | grep "PublicIp" | cut -d ':' -f2 | cut -d '"' -f2 >> $scriptPath/.temp/ec2_ip.txt
cat $scriptPath/.temp/ec2_ip.txt >>$scriptPath/.temp/tenableIPs.txt

########################################
# Clean up, dedup and combine the      #
# list now that we have the IPs from   #
# DNS and from the EC2 list.           #
########################################

sort $scriptPath/.temp/digELB-clean.txt | uniq >> $scriptPath/.temp/tenableIPs.txt
sort $scriptPath/.temp/digEC2-clean.txt | uniq >> $scriptPath/.temp/tenableIPs.txt
sort $scriptPath/.temp/tenableIPs.txt | uniq >>$scriptPath/logs/tenableIPs.txt

########################################
# Build the list in to a CSV list      #
########################################

while read list;
  do
    iplist=$list","$iplist
  done < $scriptPath/logs/tenableIPs.txt

########################################
# Write out the CSV list               #
########################################

echo $iplist > $scriptPath/logs/tenableIPsFinal.txt
sed -i '$ s/.$//' $scriptPath/logs/tenableIPsFinal.txt

########################################
# Launch the pyTennable script         #
########################################

python3 $scriptPath/pyTenable.py
