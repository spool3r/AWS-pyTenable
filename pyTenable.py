#!/usr/bin/env python3

########################################
# List of Variables for script         #
########################################

script_path = /path/to/folder
scan_id = 1       # Scan ID number

########################################
# Import the Tennable SC library
########################################

from tenable.sc import TenableSC

########################################
# Import the logging module and set it #
# to debug mode for increase logging.  #
# You can comment this out once it is  #
# verified working.                    #
########################################

import logging
logging.basicConfig(level=logging.DEBUG)

########################################
# Open the file created by awsDownload #
########################################

open_file = "{}/logs/tenableIPsFinal.txt".format(script_path)
text_file = open(open_file, 'r')
lines = text_file.read()

########################################
# Login to Tenable.sc
########################################

sc = TenableSC('server.domain.tld')
sc.login('username', 'passwords')

########################################
# Updated the scan targets in scan     #
########################################
# Change Scan Targets
sc.scans.edit(scan_id, targets = [lines])

########################################
# Close the text file                  #
########################################

text_file.close()

########################################
# Start the scan of the AWS IPs        #
########################################

running = sc.scans.launch(scan_id)
print('The Scan Result ID is {}'.format(running['scanResult']['id']))

########################################
# Close connection to Tennable.sc      #
########################################
# Logout from Tenable.sc
sc.logout()
