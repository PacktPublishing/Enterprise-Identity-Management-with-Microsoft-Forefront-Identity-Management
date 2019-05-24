#Request SSL SAN certificate for FIM server
#Names used are
#FIM Portal: fim.company.com
#FIM PW Reset : pwreset.company.com
#FIM PW Registration : pwreg.company.com
$CertificateTemplate = "CompanyWebServer"

Get-Certificate -Template $CertificateTemplate -SubjectName "CN=fim.company.com,O=ECA" -DnsName fim.company.com,pwreg.company.com,pwreset.company.com -CertStoreLocation cert:\LocalMachine\My