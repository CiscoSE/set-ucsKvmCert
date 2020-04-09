# UCS KVM X509 Certificate Deployment
This script deploys X509 Certificates based on RSA keys to the CIMC of each blade or rack mount server in a UCS Domain.

## Requirements
The following requirements must be completed to use this script:

- PowerShell 5 or later on Windows
- PowerTool Installed (Not working with PowerShell Core)
- RSA Key generated with openssl

>	openssl genrsa -out ./FEDLAB-Core-KVM.key 4096

- Certificate signed by a CA using the RSA Key generated above
-- Create a file with the CA properties. Subject alternate name must include ever
```
[req]
default_bits = 384
prompt = no
default_md = sha384
req_extensions = v3_req
distinguished_name = dn

[ dn ]
C=<Your Country>
ST=<Your State>
L=<Your Locality / City>
O=<Your Organization>
OU=<What ever helps you>
emailAddress=<responsible@email.whatever>
CN = fully.qualified.dns.name

[ v3_req ]
subjectAltName = @alt_name
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[alt_name]
IP.1 = 1.1.1.1
IP.2 = 1.1.1.2
IP.3 = 1.1.1.3

```
 
