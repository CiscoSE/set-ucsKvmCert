<#
.NOTES
Copyright (c) 2019 Cisco and/or its affiliates.
This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.0 (the "License"). You may obtain a copy of the
License at
               https://developer.cisco.com/docs/licenses
All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.

.SYNOPSIS
Example script for loading certificates into UCS for KMS

.PARAMETER UCSIP
The IP address of the cluster IP of the Fabric Interconnects

.PARAMETER Filter
A serial number or array of serial numbers (seperated by commas) use to limit the scope of the machines that will recieve the certificate referenced.
The same certificate and priviate key will be sent to all systems specified in the filter. Specify a period to send the certificate to all servers
in the UCS domain.

.PARAMETER RSAKeyPath
Path to the RSA Key. Eliptic curve is not supported. This must be an RSA key. 

.PARAMETER Base64CertPath
Path to the Base 64 encoded signed certificate returned from the CA.

.EXAMPLE

DeployCertificateToAll.ps1 -UCSIP 172.16.1.10 -Filter FCH00000001,FCH00000002 -RSAKeyPath .\keygen\SomeRSAPrivate.key -Base64CertPath .\keygen\SomeBase64Cert.cer

Deploys the same certificate and private key to two serial numbers.

.EXAMPLE
 DeployCertificateToAll.ps1 -UCSIP 172.16.1.10 -Filter . -RSAKeyPath .\keygen\SomeRSAPrivate.key -Base64CertPath .\keygen\SomeBase64Cert.cer

Deploys the same certificate to all servers in the UCS Domain.

#>
[cmdletbinding()]
param(
    [parameter(mandatory=$true)][string]$UCSIP,
    [parameter(mandatory=$true)][array]$Filter,
    [parameter(mandatory=$true)][string]$RSAKeyPath,
    [parameter(mandatory=$true)][string]$Base64CertPath
)



if (test-path $RSAKeyPath){
    $RSAKey = get-content -Path $RSAKeyPath -raw
}
else {
    Write-Host "Cannot find the key file required for this process"
    exit
}

if (test-path $Base64CertPath){
    $Base64Cert = get-content -Path $Base64CertPath -raw
}
else{
    Write-Host "Cannot find the Certificte file required for this process"
    exit
}

#Make sure we don't run this accidently against the wrong domain.

if ($DefaultUcs){
    #Already connected, looking to see if this is the right one already
    if ($DefaultUcs.Name -match $UCSIP){
        Write-Host "Already connected to the correct UCS"
    }
    else{
        disconnect-ucs
    }
}
else
{
    connect-ucs -name $UCSIP
}

$ListOfServers = Get-UcsServer | ?{$_.serial -in $Filter} 


if ($ListOfServers.count -gt 99){
    write-Host "This script can only assign a certificate to 100 servers"
    exit
}

$ListOfServers |
        %{
        write-host "Updating $($_.serial)"
        write-verbose "Writting DN:`t$($_.dn)/mgmt"
        $CertificateBody = @"
<configConfMos
cookie='$($DefaultUcs.Cookie)'
inHierarchical='false'>
    <inConfigs>
<pair key='$($_.dn)/mgmt'>
    <mgmtController
    dn='$($_.dn)/mgmt'

    status='created,modified'

    sacl='addchild,del,mod'>
        <mgmtKvmCertificate
        certificate='$($Base64Cert)'
        descr=''
        key='$($RSAKey)'
        name=''
        policyOwner='local'

        rn='cert'


        sacl='addchild,del,mod'>
        </mgmtKvmCertificate>
    </mgmtController>
</pair>
    </inConfigs>
</configConfMos>

"@
        write-verbose "$($CertificateBody)"
        $URI = 'https://' + $UCSIP+'/nuova'
        write-verbose $URI
        $Result = Invoke-WebRequest -Uri $URI -body $CertificateBody -Method Post
        write-verbose $Result
        }