# AWS-pyTenable
Using AWS CLI to create a dynamic list of external IPs to scan via Tenable.sc.  These two script will download the ELB and EC2 instance details to be able to scan the current AWS machines and Load Balancers from an external Tenable scanner via Tenable.sc.
---
---
## Script Requirements:
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
  - [AWS CLI Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
- [PyTenable](https://pytenable.readthedocs.io/en/stable/)
- Python 3
- ash
---
---
## Required Updates to files
### awsDownloader.sh
Update the path to the location of the script
```
scriptPath = /path/to/folder
```
---
Update to the named AWS profiles
```
environment=(
123456789012
234567890123
345678901234
)
```
---
Remove any region you won't be in.  It is better to leave the list to the full list as to help find any shadow IT.
```
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
```


---


### pyTenable.py
Update the path to the location of the script
```
script_path = /path/to/folder
```
---
Update to the Scan ID for your scan.  If you go to your scan, you can look at the URL of the Active Scan and the number after edit would be the Scan ID (https://server.domain.tld/#scans/edit/1).
```
scan_id = 1
```
---
Update to the Tenable.sc server path.  This could be a fully qualified domain name or IP address.
```
sc = TenableSC('server.domain.tld')
```
---
Update to your username and password for Tenable.sc.  More information about the authentication can be found at (https://pytenable.readthedocs.io/en/stable/sc.html).
```
sc.login('username', 'passwords')
```
---
