function Get-JBMasAccount {
    <#
    .SYNOPSIS
        Query rest api account end point 
    .DESCRIPTION
        Setup enviroment for token, rest_host and creation time in global variable MastodonToken
    .Parameter ID
        The ID of the account to interrogate 
    .Parameter Type
        get accounts statuses,followers,following, or featured_tags
    .Parameter APIVersion
        What version of the API to use default is 2
    .Parameter Limit
        Maximum number of results to return, per type. Defaults to 20 results per category. Max 40 results per category.
    .Parameter OffSet
        Skip the first n results
    .Parameter Min_ID
        Return results immediately newer than this ID
    .Parameter Max_ID
        Return results older than this ID
    .Parameter Noreplies
        Filter out statuses in reply to a different account
    .Parameter NoReblogs
        Filter out boosts from the response.
    .Parameter Media
        Filter out statuses without attachments
    .Parameter Pinned
        Filter for pinned statuses only.
    .Parameter Tagged
        Filter for statuses using a specific hashtag
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section 
    .NOTES
        
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,HelpMessage="Enter the Account ID",Position=1)]
        [String]$ID,
        [ValidateSet('statuses','followers','following','featured_tags')]
        [String]$Type, 
        [int]$APIVersion = 1,
        [ValidateRange(1, 40)]
        [int]$Limit,
        [string]$Min_ID,
        [string]$Max_ID,
        [switch]$Noreplies,
        [switch]$NoReblogs,
        [switch]$Media,
        [switch]$Pinned,
        [string]$Tagged
    )
    
    begin {
        
        $Rest_Path= "api/v$($APIVersion)/accounts/$($ID)"
        if ($Type){ $Rest_Path = "$($Rest_Path)/$($Type)"}
        if ($Type -eq 'statuses'){
            if($Noreplies){ 
                if ($Rest_Path -contains '?'){ $Rest_Path = "$($Rest_Path)&exclude_replies=1" } else { $Rest_Path = "$($Rest_Path)?exclude_replies=1" }
            }
            if($NoReblogs){ 
                if ($Rest_Path -contains '?'){ $Rest_Path = "$($Rest_Path)&exclude_reblogs=1" } else { $Rest_Path = "$($Rest_Path)?exclude_reblogs=1" }
            }
            if($Pinned){ 
                if ($Rest_Path -contains '?'){$Rest_Path = "$($Rest_Path)&pinned=1" } else {$Rest_Path = "$($Rest_Path)?pinned=1" }
            }
            if($Tagged){ 
                if ($Rest_Path -contains '?'){$Rest_Path = "$($Rest_Path)&tagged=$($Tagged)"  } else {$Rest_Path = "$($Rest_Path)?tagged=$($Tagged)"  }
            }
        }
        if($Limit){ 
            if ($Rest_Path -contains '?'){ $Rest_Path = "$($Rest_Path)&limit=$($Limit)" } else {$Rest_Path = "$($Rest_Path)?limit=$($Limit)" } 
        }
        if($Min_ID){
            if ($Rest_Path -contains '?'){ $Rest_Path = "$($Rest_Path)&min_id=$($Min_ID)" } else { $Rest_Path = "$($Rest_Path)?min_id=$($Min_ID)" }
        }
        if($Max_ID){ 
            if ($Rest_Path -contains '?'){ $Rest_Path = "$($Rest_Path)&max_id=$($Max_ID)" } else { $Rest_Path = "$($Rest_Path)?max_id=$($Max_ID)" }
        }
        
    }
    
    process {
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Get 
    }
    
    end {
        
    }
}