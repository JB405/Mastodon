function Remove-JBMasStatus {
    <#
    .SYNOPSIS
        Delete a status form the rest api endpoint 
    .DESCRIPTION
        Delete a status that this api token has access to 
    .Parameter ID
        The ID of the status 
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section 
    .NOTES
        
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,Position=1)]
        [string]$ID,
        [int]$APIVersion = 1
        
    )
    
    begin {
        $Rest_Path= "/api/v$($APIVersion)/statuses/$($ID)"
      }
    
    process {
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Delete -Body $json
    }
    
    end {

    }
}