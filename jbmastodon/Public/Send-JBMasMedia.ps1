function Send-JBMasMedia {
     <#
    .SYNOPSIS
        Post encode media to Mastodon API
    .DESCRIPTION
       upload media file to a Mastodon instance from a post API Call
    .Parameter File
        File location on system to upload
    .Example
        PS>  Send-JBMasMedia -File 'c:\temp\coolimage.png'
    .NOTES
        the file encoing code was pulled from
        https://blog.ironmansoftware.com/mastodon-powershell (Adam Driscoll)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True,Position=0)]
        [System.IO.FileInfo]$File
    )

    if (!$MAstodonToken.Rest_Host){
        Write-Error "No token / rest_host defined."
        return
    }
    if (!(Test-Path $File)){
        Write-Error "$($File.FullName) was not found"
        return
    }

    $FileBytes = [System.IO.File]::ReadAllBytes($File.FullName);
    $FileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes);
    $Boundary = [System.Guid]::NewGuid().ToString();
    $LF = "`r`n";
    $BodyLines = ( "--$($Boundary)","Content-Disposition: form-data; name=`"file`"; filename=`"$($File.Name)`";",
    "Content-Type: application/octet-stream$($LF)",$($FileEnc),"--$($Boundary)--$($LF)") -join $LF

    $ContentType = "multipart/form-data; boundary=`"$($Boundary)`""
    [uri]$uri = "https://$($MAstodonToken.Rest_Host)/api/v1/media"

    $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Headers.Add('Authorization', "Bearer $($MastodonToken.cred.GetNetworkCredential().password)")

    $Media = Invoke-RestMethod -Uri $uri -Method Post -ContentType $ContentType -Body $BodyLines -Headers $Headers

    return $Media
}
