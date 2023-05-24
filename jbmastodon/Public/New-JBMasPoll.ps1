function New-JBMasPoll {
    <#
    .SYNOPSIS
        Post a status poll through the rest api 
    .DESCRIPTION
        Post a status poll to the MastodonInstance
    .Parameter PollOptions
        Array of String. Possible answers to the poll
    .Parameter PollExpiresIn
        Duration that the poll should be open, in seconds default is 5 days (432000 seconds)
    .Parameter PollMultiple
        Allow multiple choices
    .Parameter PollHideTotals
        Hide vote counts until the poll ends
    .Parameter Status
        The text content of the status
    .Parameter ReplyID
        ID of the status being replied to, if status is a reply
    .Parameter Sensitive
        Mark status and attached media as sensitive? Defaults to false
    .Parameter SpoilerText
        Text to be shown as a warning or subject before the actual content. Statuses are generally collapsed behind this field.
    .Parameter Visibility
        Sets the visibility of the posted status to public, unlisted, private, direct
    .Parameter language
        ISO 639 language code for this status
    .Parameter scheduled_at
        Datetime at which to schedule a status. Providing this parameter will cause ScheduledStatus to be returned instead of Status. Must be at least 5 minutes in the future.
    .Example
        PS>  Get-JBMasToken -Rest_Host 'mastodon.social' -Credential JB405
        *Will prompt for password of Credential this will be the Access Token from the mastodon profile in the develoopment section 
    .NOTES
        
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,Position=0)]
        [string[]]$PollOptions,
        [int]$PollExpiresIn = 432000,
        [switch]$PollMultiple,
        [switch]$PollHideTotals,
        [string]$Status,
        [string]$SpoilerText,
        [ValidateSet('public','unlisted','private','direct')]
        [string]$Visibility,
        [string]$ReplyID,
        [bool]$Sensitive,
        [string]$language,
        [datetime]$scheduled_at,
        [int]$APIVersion = 1
        
    )
    
    begin {
        $Rest_Path= "api/v$($APIVersion)/statuses"
        $body = @{
            poll = @{'options' = @($PollOptions)
                'expires_in' = $PollExpiresIn
            }
        }
        if ( $PollMultiple ){ $body.poll.Add('multiple',$True) }
        if ( $PollHideTotals ){ $body.poll.Add('hide_totals',$True) }
        iF ( $Status ){ $body.add('status',"$($Status)") }
        if ( $Visibility ){ $body.Add('visibility',"$($Visibility)") }
        if ( $ReplyID ){ $body.Add('in_reply_to_id',"$($ReplyID)") }
        if ( $Sensitive ){ $body.Add('sensitive',"$True") }
        if ( $SpoilerText ){ $body.Add('spoiler_text',"$($SpoilerText)") }
        if ( $language ){ $body.Add('language',"$($language)") }
        if ( $scheduled_at ){
            if ( $scheduled_at -le (get-date).AddMinutes(-5) ){ $scheduled_at = (get-date).AddSeconds(305)  }
            $body.Add('scheduled_at',($scheduled_at).ToUniversalTime().ToString("o"))
        }
        $json = $body | ConvertTo-Json -Depth 2

    }
    
    process {
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Post -Body $json
    }
    
    end {

    }
}