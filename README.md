# UCS KVM X509 Certificate Deployment
This script deploys X509 Certificates based on RSA keys to the CIMC of each blade or rack mount server in a UCS Domain.

## Requirements
The following requirements must be completed to use this script:

- PowerShell 5 or later on Windows
- PowerTool Installed (Not working with PowerShell Core)
- RSA Key generated with openssl

>	openssl genrsa -out ./keygen/KVM.key 4096

- Certificate signed by a CA using the RSA Key generated above
-- Create a file with the CA properties. Subject alternate name must include every IP address that the certificate will be used for. An example cnf file is provided in the keygen directory named kvm.cnf.
-- you can create a csr using the following example with openssl:
>	openssl req -new -key ./keygen/KVM.key -nodes -out ./keygen/KVM.csr


