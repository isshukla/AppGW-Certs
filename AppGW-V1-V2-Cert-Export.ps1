
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


$rg = Read-Host "Resource Group name"
$appgwname = Read-Host "Name of the Applciation Gateway"

Write-Host  "All certs will be exported to $HOME in .CER format, and complete available chain will be provided in output" -ForegroundColor Green

#Get AppGW Details
$getGW = Get-AzApplicationGateway -ResourceGroupName $rg -Name $appgwname

if ($getgw.sku.Tier.Contains("v2") -ne "True"){

######################### V1 part
Write-Host "For V1 GW you can use this Module as well: https://www.powershellgallery.com/packages/AzureRMAppGWCert/1.0.8" -ForegroundColor Green
Write-Host "All Trusted Root Certs uploaded for this AppGW (Certs for HTTP Setting)" -ForegroundColor Green

#Get the Setting Certificate details, you have to provide the name of the certificate
$SettingCert = Get-AzApplicationGatewayAuthenticationCertificate -ApplicationGateway $getGW 


if($SettingCert.count -gt 1){
for($i=0; $i -lt $SettingCert.count; $i++){
 
#cmd to convert raw data to thumbprint.
$Settingcertraw = $SettingCert.Data[$i]
$Settingpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Settingpfx.Import([System.Convert]::FromBase64String($Settingcertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

 
#Output - Name and Thumbprint of the Setting certificate

"Cert name  : $($SettingCert.name[$i])"
$Settingpfx | FL -Property Thumbprint, Subject, Issuer, Notafter 

# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Settingpfx | ForEach-Object {
$certexpo = $Settingpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($SettingCert.Name[$i])+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

}


}}

if($SettingCert.count -eq 1){

#cmd to convert raw data to thumbprint.
$Settingcertraw = $SettingCert.Data
$Settingpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Settingpfx.Import([System.Convert]::FromBase64String($Settingcertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Setting certificate
"Cert name    : $($SettingCert.Name)"
$Settingpfx | FL

# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Settingpfx | ForEach-Object {
$certexpo = $Settingpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($SettingCert.Name)+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

}

}
#########################

}
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
"Cert name  : $($SettingCert.name[$i])"
$Settingpfx | FL -Property Thumbprint, Subject, Issuer, Notafter 

# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Settingpfx | ForEach-Object {

$certexpo = $Settingpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($SettingCert.Name[$i])+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

}
}
}

if($SettingCert.count -eq 1){

#cmd to convert raw data to thumbprint.
$Settingcertraw = $SettingCert.Data
$Settingpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Settingpfx.Import([System.Convert]::FromBase64String($Settingcertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Setting certificate
"Cert name    : $($SettingCert.Name)"
$Settingpfx | FL


# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Settingpfx | ForEach-Object {
$certexpo = $Settingpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($SettingCert.Name)+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

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
"Cert name      :  $($ListenerCert.name[$i])"
$Listenerpfx | FL -Property Thumbprint, Subject, Issuer, Notafter

# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Listenerpfx | ForEach-Object {
$certexpo = $Listenerpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($ListenerCert.name[$i])+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

}
}
}


if($ListenerCert.count -eq 1){

#cmd to convert raw data to thumbprint.
$Listenercertraw = $ListenerCert.PublicCertData
$Listenerpfx= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$Listenerpfx.Import([System.Convert]::FromBase64String($Listenercertraw),$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Output - Name and Thumbprint of the Listener certificate
"Cert name  : $($ListenerCert.Name)"
$Listenerpfx | FL

# Next code section will export the certificates. If you do not want to export certificate, comment these line.
$Listenerpfx | ForEach-Object {
$certexpo = $Listenerpfx.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "")
$outPfxPath = $HOME+'\'+$($ListenerCert.name)+'.cer'
[io.file]::WriteAllBytes($outPfxPath, $certexpo)

}
}

