# AWS-pyTenable
Using AWS CLI to create a dynamic list of external IPs to scan via Tenable.sc.  These two script will download the ELB and EC2 instance details to be able to scan the current AWS machines and Load Balancers from an external Tenable scanner via Tenable.sc.

## Script Requirements:
*[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
  *[AWS CLI Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
*[PyTenable](https://pytenable.readthedocs.io/en/stable/)
*Python 3
*Bash

## Required Updates to files
#### awsDownloader.sh
scriptPath = /path/to/folder
-Update the path to the location of the script

#### pyTenable.py
script_path = /path/to/folder
-Update the path to the location of the script

scan_id = 1
-Update to the Scan ID for your scan.  If you go to your scan, you can look at the URL of the Active Scan and the number after edit would be the Scan ID (https://server.domain.tld/#scans/edit/1).

sc = TenableSC('server.domain.tld')
-Update to the Tenable.sc server path.  This could be a fully qualified domain name or IP address.

sc.login('username', 'passwords')
-Update to your username and password for Tenable.sc.  More information about the authentication can be found at (https://pytenable.readthedocs.io/en/stable/sc.html).
