$file = 'C:\temp\export1.csv'

Connect-MSGraph -AdminConsent

forEach($Device in Get-IntuneManageddevice){

$Body = @"
{ "select": [
        "SettingName",
        "SettingStatus",
        "ErrorCode",
        "SettingInstanceId",
        "SettingInstancePath"
    ],
    "filter": "(PolicyId eq 'c6cb029a-e9cc-4416-90da-245b7af6a4d4') and (DeviceId eq '$($Device.id)') and (UserId eq '$($Device.userId)')",
    "orderBy": []
}
"@

forEach($value in (Invoke-MSGraphRequest -HttpMethod POST -Url "https://graph.microsoft.com/beta/deviceManagement/reports/microsoft.graph.getConfigurationSettingNonComplianceReport" -Content $Body).values)
{
    $output = [PSCustomObject]@{
        DeviceId = $Device.id
        UserId = $Device.userId
        ErrorCode = $value[0] 
        SettingInstanceId = $value[1]
        SettingInstancePath = $value[2]
        SettingName = $value[3]
        SettingStatus = $value[4]

    }

    $output | Select-object DeviceId, UserId, ErrorCode, SettingInstanceId, SettingInstancePath,SettingName,SettingStatus | Export-Csv -Path $file -NoTypeInformation -Append
    
}

}