function New-JBMasMedia {
    <#
    .SYNOPSIS
        Post a status media through the rest api 
    .DESCRIPTION
        Post a status media to the MastodonInstance
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
        [parameter(Mandatory=$True,Position=1)]
        [System.IO.FileInfo[]]$ImagePath,
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
        $Media = @()
    }
    
    process {
        foreach ($I in $ImagePath){
            $Media = Send-JBMasMedia -File $ImagePath
        }
        
        
        $body = @{
            media_ids = @($($Media.Id))
        }
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
        $json = $body | ConvertTo-Json -Depth 5

        
        Invoke-JBMastodonAPI -rest_path $Rest_Path -Method Post -Body $json
    }
    
    end {

    }
}