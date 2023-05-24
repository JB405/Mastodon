function Invoke-JBMastodonAPI {
    <#
    .SYNOPSIS
        Invoke rest API Request
    .DESCRIPTION
        Invoke request for Mastodon Instanc
    .Parameter Rest_Path
        tbd
    .Parameter Method
        tbd
    .Parameter Body
        tbd
    .Example
        PS>  Invoke-JBMastodonAPI -rest_path 'api/v1/accounts/verify_credentials'
    
    .NOTES
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, mandatory = $true)]
        [string]$rest_path,
        [ValidateSet('Get','Post','Put','Delete')]
        [String]$Method = 'Get',
        [String]$Body
    )
    
    begin {
        if (!$MastodonToken){
            Write-Verbose "No Token data Calling Get-JBMastoken"
            Get-JBMastoken
        }
        $rest_path= $rest_path -replace 'http.*.com/',''
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add('Authorization', "Bearer $($MastodonToken.cred.GetNetworkCredential().password)")
        $headers.Add('content-type' , 'application/json')
        $headers.Add('Accept' , 'application/json')
        [uri]$URI = "https://$($MastodonToken.Rest_Host)/$($rest_path)"
    }
    
    process {
        Write-Verbose "Calling $($uri.AbsoluteUri)"
        switch ($Method){
            'Post' {$Response = Invoke-RestMethod -Uri $URI -Method $Method -Headers $Headers -Body $Body}
            'Put'  {$Response = Invoke-RestMethod -Uri $URI -Method $Method -Headers $Headers -Body $Body}
            'Delete' {$Response = Invoke-RestMethod -Uri $URI -Method $Method -Headers $Headers -Body $Body}
            default{$Response = Invoke-RestMethod -Uri $URI -Method $Method -Headers $Headers}
           }#Switch
    }
    
    end {
        $Response
    }
}