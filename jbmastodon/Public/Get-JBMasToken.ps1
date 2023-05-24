function Get-JBMasToken {
    <#
    .SYNOPSIS
        Add token, Rest_Host to global variable loabl:MastodonToken
    .DESCRIPTION
        Setup enviroment for token, rest_host and creation time in global variable MastodonToken
    .Parameter Rest_Host
        the Mastodon server be default we are using c.im
    .Parameter Credental
        The user name and Access Token from your profile development <Your access token>
    .Parameter Body
        Body used to posting data rest api
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section 
    .NOTES
        
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,HelpMessage="Enter the Credintials for the Mastodon",Position=1)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        [string]$Rest_Host = 'c.im'
    )
    
    begin {
        Write-Verbose "Storing $($Credential.username) Authorization token for Rest Host $($rest_host)."
    }
    
    process {
        $rest_host = $rest_host -replace 'http.*/',''
        Remove-Variable gloabl:MastodonToken -ErrorAction SilentlyContinue
        $Global:MastodonToken = [PSCustomObject]@{
            'Cred' = $Credential
            'DT' = get-date
            'Rest_Host' = $Rest_Host
        }
    }
    
    end {
        Write-Verbose "Token was created at $($MastodonToken.DT) for Rest Host $($MastodonToken.Rest_Host)"
    }
}