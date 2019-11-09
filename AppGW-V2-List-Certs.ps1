
#------------------------------------------------------------------------------   
#   
#    
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT   
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT   
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS   
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR    
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.   
#   
#------------------------------------------------------------------------------  

# This script will list the thumbprint of all the certificates uploaded to the AppGW 
# Date: 10 Nov 2019 12:17 AM IST

$rg = Read-Host "Resource Group name"
$appgwname = Read-Host "Name of the Applciation Gateway"

#Get AppGW Details
$getGW = Get-AzApplicationGateway -ResourceGroupName $rg -Name $appgwname

if ($getgw.sku.Tier.Contains("v2") -ne "True"){Write-host "This script is for AppGW V2 only"; Stop}
Else{

Write-Host "All Trusted Root Certs uploaded for this AppGW (Certs for HTTP Setting)" -ForegroundColor Green
#Get the Setting Certificate details, you have to provide the name of the certificate
$SettingCert = Get-AzApplicationGatewayTrustedRootCertificate -ApplicationGateway $getGW 


if($SettingCert.count -gt 1){
for($i=0; $i -lt $SettingCert.count; $i++){
 
#cmd to convert raw data to thumbprint.
$Settingcertraw = $SettingCert.Data[$i]
$Settingpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Settingpfx.Import([System.Convert]::FromBase64String($Settingcertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

 
#Output - Name and Thumbprint of the Setting certificate
#write-host "Cert Name:'$($SettingCert.name)'  Thumbprint:'$($Settingpfx.thumbprint)'  Subject name:'$($Settingpfx.subject)'"
#write-host "thumbprint  : $($Settingpfx.thumbprint)"
#write-host "Subject name: $($Settingpfx.subject)"

"Cert name: $($SettingCert.name[$i])"
$Settingpfx | FT -Property Thumbprint, Subject, Issuer, Notafter


}
if($SettingCert.count -eq 1){

#cmd to convert raw data to thumbprint.
$Settingcertraw = $SettingCert.Data
$Settingpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Settingpfx.Import([System.Convert]::FromBase64String($Settingcertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Setting certificate
$SettingCert.Name
$Settingpfx 
}
}
}


Write-Host "All SSL Certs uploaded for this AppGW (Certs for Listener)" -ForegroundColor Green

#Get the Listener Certificate details, you have to provide the name of the certificate
$ListenerCert = Get-AzApplicationGatewaySslCertificate -ApplicationGateway $getGW 


if($ListenerCert.count -gt 1){
for($i=0; $i -lt $ListenerCert.count; $i++){
 
#cmd to convert raw data to thumbprint.
$Listenercertraw = $ListenerCert.PublicCertData[$i]
$Listenerpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Listenerpfx.Import([System.Convert]::FromBase64String($Listenercertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Listener certificate
#write-host "Cert Name:'$($ListenerCert.name)'  Thumbprint:'$($Listenerpfx.thumbprint)'  Subject name:'$($Listenerpfx.subject)'"
#write-host "thumbprint  : $Listenerpfx[$i]"
#write-host "Subject name: $($Listenerpfx.subject)"

"Cert name: $($ListenerCert.name[$i])"
$Listenerpfx | FT -Property Thumbprint, Subject, Issuer, Notafter

}
if($ListenerCert.count -eq 1){

#cmd to convert raw data to thumbprint.
$Listenercertraw = $ListenerCert.PublicCertData
$Listenerpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Listenerpfx.Import([System.Convert]::FromBase64String($Listenercertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Listener certificate
$ListenerCert.Name
$Listenerpfx 
}
}


