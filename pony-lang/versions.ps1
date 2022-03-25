$Url = "https://api.cloudsmith.io/v1/packages/ponylang/releases/?query=filename:ponyc-x86-64-pc-windows-msvc.zip&page_size=1000000000"

Invoke-RestMethod $Url | % {$_} | % {@{
	Version = $_.version
	Hash = $_.checksum_sha256
}}