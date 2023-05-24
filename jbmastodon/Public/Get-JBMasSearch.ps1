function Get-JBMasSearch {
    <#
    .SYNOPSIS
        Query the rest api serach end points 
    .DESCRIPTION
        Setup enviroment for token, rest_host and creation time in global variable MastodonToken
    .Parameter Search
        String of data you want to search for 
    .Parameter Type
        Specify weather to search for only accounts, hashtags, or statuses 
    .Parameter APIVersion
        What version of the API to use default is 2
    .Parameter Limit
        Maximum number of results to return, per type. Defaults to 20 results per category. Max 40 results per category.
    .Parameter OffSet
        Skip the first n results
    .Parameter Account_ID
        If provided, will only return statuses authored by this account.
    .Parameter Min_ID
        Return results immediately newer than this ID
    .Parameter Max_ID
        Return results older than this ID
    .Parameter Resolve
         Attempt WebFinger lookup? Defaults to false
    .Parameter Resolve
        Filter out unreviewed tags? Defaults to false. Use true when trying to find trending tags
    .Parameter Following
        Only include accounts that the user is following? Defaults to false
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section 
    .NOTES
        
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,HelpMessage="Enter the Data you are searching for",Position=1)]
        [String]$Search,
        [ValidateSet('accounts','hashtags','statuses')]
        [String]$Type,
        [int]$APIVersion = 2,
        [ValidateRange(1, 40)]
        [int]$Limit,
        [int]$OffSet,
        [String]$Account_ID,
        [string]$Min_ID,
        [string]$Max_ID,
        [switch]$Resolve,
        [switch]$Following,
        [switch]$UnReviewed
    )
    
    begin {
        
        $Rest_Path= "api/v$($APIVersion)/search?q=$($Search)"
        
        if($Type){ $Rest_Path = "$($Rest_Path)&type=$($Type)"}
        if($Limit){ $Rest_Path = "$($Rest_Path)&limit=$($Limit)" }
        if($OffSet){ $Rest_Path = "$($Rest_Path)&offset=$($OffSet)" }
        if($Account_ID){ $Rest_Path = "$($Rest_Path)&account_id=$($Account_ID)" }
        if($Min_ID){ $Rest_Path = "$($Rest_Path)&min_id=$($Min_ID)" }
        if($Max_ID){ $Rest_Path = "$($Rest_Path)&max_id=$($Max_ID)" }
        if($Resolve){ $Rest_Path = "$($Rest_Path)&Resolve=1" }
        if($Following){ $Rest_Path = "$($Rest_Path)&Following=1" }
        if($UnReviewed){ $Rest_Path = "$($Rest_Path)&exclude_unreviewed=1" }
        
    }
    
    process {
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Get 
    }
    
    end {
        
    }
}