Connect-MSGraph -AdminConsent

$file = 'C:\temp\temp1.csv'

$Body = @"
{
    "select": [
        "DeviceName",
        "UserPrincipalName",
        "Platform",
        "AppVersion",
        "InstallState",
        "InstallStateDetail",
        "AssignmentFilterIdsExist",
        "LastModifiedDateTime",
        "DeviceId",
        "ErrorCode",
        "UserName",
        "UserId",
        "ApplicationId",
        "AssignmentFilterIdsList",
        "AppInstallState",
        "AppInstallStateDetails",
        "HexErrorCode"
    ],
    "skip": 0,
    "filter": "(ApplicationId eq '082a60ea-0991-46d7-aff3-6d8e8dc037a0')",
    "orderBy": []
}
"@



forEach($value in (Invoke-MSGraphRequest -HttpMethod POST -Url "https://graph.microsoft.com/beta/deviceManagement/reports/getDeviceInstallStatusReport" -Content $Body).values)
{
    $output = [PSCustomObject]@{
       DeviceName = $value[0]
       UserPrincipalName = $value[1]
        Platform = $value[2]
        AppVersion = $value[3]
        InstallState = $value[4]
        InstallStateDetail = $value[5]
        AssignmentFilterIdsExist = $value[6]
        LastModifiedDateTime = $value[7]
        DeviceId= $value[8]
        ErrorCode = $value[9]
        UserName = $value[10]
        UserId = $value[11]
        ApplicationId = $value[12]
        AssignmentFilterIdsList = $value[13]
        AppInstallState = $value[14]
        AppInstallStateDetails = $value[15]
        HexErrorCode = $value[16]
    }

    $output | Select-object DeviceName, UserPrincipalName, Platform, AppVersion, InstallState,InstallStateDetail,AssignmentFilterIdsExist,LastModifiedDateTime, DeviceId, ErrorCode, UserName, UserId, ApplicationId, AssignmentFilterIdsList, AppInstallState, AppInstallStateDetails, HexErrorCode | Export-Csv -Path $file -NoTypeInformation -Append
    
}
exit 1
