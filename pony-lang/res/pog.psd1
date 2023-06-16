@{
	Name = "pony-lang"
	Architecture = "x64"
	Version = "{{VERSION}}"

	Install = @{
		Url = {"https://dl.cloudsmith.io/public/ponylang/releases/raw/versions/$($this.Version)/ponyc-x86-64-pc-windows-msvc.zip"}
		Hash = "{{HASH}}"
	}

	Enable = {
		Export-Command "ponyc" "./app/bin/ponyc.exe"
	}
}