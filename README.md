# UCS KVM X509 Certificate Deployment
This script deploys X509 Certificates based on RSA keys to the CIMC of each blade or rack mount server in a UCS Domain.

## Requirements
The following requirements must be completed to use this script:

- PowerShell 5 or later on Windows
- PowerTool Installed (Not working with PowerShell Core)
- RSA Key generated with openssl

>	openssl genrsa -out ./keygen/KVM.key 4096

- Certificate signed by a CA using the RSA Key generated above
 - Create a file with the CA properties. Subject alternate name must include every IP address that the certificate will be used for. An example cnf file is provided in the keygen directory named kvm.cnf.
 - you can create a csr using the following example with openssl:
>	openssl req -new -key ./keygen/KVM.key -nodes -out ./keygen/KVM.csr
 - The result should be a signed certificate from the CA in **base64** encoding

**Caution: Like all changes, you should test this script on a single lab system before deploying to production systems. The examples below show how to run this script against a single system, or an array of systems. It is possible run this script against all servers in a UCS domain, but that has not been tested and is not recommended without completing your own testing and validation.**

**Note: Subject alternates maybe limited to 100 subject alteranate names per certificate.**

## Running the script
This powershell script requires the following aurguments:

>	-UCSIP		This can be the ip or DNS name of the cluster ip of UCS Manager
>	-Filter		An array of serial numbers for the servers you want to install certificates on
>	-RSAKeyPath	The location of the RSA generated key
>	-Base64CertPath	The location of the signed **Base64** certificate associated with the RSA key

The following is an example for deploying the key and certificate to single server:

>	.\DeployCertificateToAll.ps1 -UCSIP 1.1.2.1 -Filter FCH00000001 -RSAKeyPath .\keygen\KVM.key -Base64CertPath ./keygen/KVM.cer

