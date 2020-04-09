# UCS KVM X509 Certificate Deployment
This script deploys X509 Certificates based on RSA keys to the CIMC of each blade or rack mount server in a UCS Domain.

## Requirements
The following requirements must be completed to use this script:

- PowerShell 5 or later on Windows
- PowerTool Installed (Not working with PowerShell Core)
- RSA Key generated with openssl

	openssl genrsa -out ./FEDLAB-Core-KVM.key 4096


 
