@{
	Name = "lz4"
	Architecture = "x64"
	Version = "{{VERSION}}"

	Install = @{
		Url = "{{URL}}"
		Hash = "{{HASH}}"
	}

	Enable = {
		Export-Command "lz4" "./app/lz4.exe"
	}
}