# Mastodon PowerShell Module

## Overview
PWSH wrapper for working with Mastodon API.

## Getting Started

**Generate User Token API**
- Login to your mastodon account
- Click on Preferences
- Click on Development
- Click New applicaion
- Type in a name for the Applicaiohn e.g. pwsh
- Scroll to the bottom and click submit
- Click on the applicaion name you just created
- Copy Your Access Token. keep in a safe place

**Creating the token and endpoint for the PWSH Module cmdlets**
The Module uses a vairable with the API Token, Rest_host and DateTime the variable was created for use with other cmdlets 

- Create or load a credential with e.g. ahead of time and pass it to Get-JBMasToken, or you can provide it within the Get-JBMasToken cmdlet. the password should be the User Access Token.
- set the Mastodon instance and credential with Get-JBMasToken for the pwsh session.
```
PS C:\> $cred = Get-Credential <UserName>
PowerShell credential request
Enter your credentials.
Password for user user: *******************************************
PS C:\> Get-JBMasToken -Rest_Host mstdn.plus -Credential $cred
```

*Get-JBMasTrend cmdlet *
```
PS C:\> Get-JBMasTrend -Limit 1 |Format-List
name      : silentsunday
url       : https://mstdn.plus/tags/silentsunday
history   : {@{day=1684713600; accounts=28; uses=28}, @{day=1684627200; accounts=283; uses=334}, @{day=1684540800;
            accounts=3; uses=3}, @{day=1684454400; accounts=2; uses=2}…}
following : False
```
