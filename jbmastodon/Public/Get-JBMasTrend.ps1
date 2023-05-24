function Get-JBMasTrend {
    <#
    .SYNOPSIS
        API endpoint for trends
    .DESCRIPTION
        view items that are currently being used more frequently than usual
    .Parameter Type
        Select status, tags, or links default is tags
    .Parameter APIVersion
        What version of the API to use default is 1
    .Parameter Limit
        Maximum number of results to return, per type. Defaults to 20 results per category. Max 40 results per category.
    .Parameter OffSet
        Skip the first n results
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section
    .NOTES

    #>
    [CmdletBinding()]
    param (
        [ValidateSet('statuses','tags','links')]
        [String]$Type = 'tags',
        [int]$APIVersion = 1,
        [ValidateRange(1, 40)]
        [int]$Limit = 20,
        [int]$OffSet

    )

    begin {

        $Rest_Path= "api/v$($APIVersion)/trends/$($Type)?limit=$($Limit)"

        if($Offset){ $Rest_Path = "$($Rest_Path)&offset=$($Offset)"}


    }

    process {
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Get
    }

    end {

    }
}
