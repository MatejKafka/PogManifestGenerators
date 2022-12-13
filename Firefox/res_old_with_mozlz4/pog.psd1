@{
	Name = "Firefox"
	Architecture = "x64"
	Version = "{{VERSION}}"
	
	Install = @{
		# the installer is .exe, but actually it's a self-extracting 7zip archive
		Url = {$V = $this.Version; "https://releases.mozilla.org/pub/firefox/releases/${V}/win64/en-US/Firefox Setup ${V}.exe"}
		Hash = "{{HASH}}"
		Subdirectory = "core"
	}
	
	Enable = {
		Write-Warning "Firefox updater and crash reporter write to registry (HKCU\Software\Mozilla\Firefox)."

		Import-Module "./.pog/Update-AddonPath"

		Assert-Directory "./data"
		Assert-Directory "./config"
		Assert-Directory "./cache"

		# there are some cached absolute paths for addons; this corrects them in case the app directory moved since last Enable-Pkg run
		# FIXME: this is broken because of "app-system-addons" key and fails with my install of Firefox
		#Update-AddonPath "./data/addonStartup.json.lz4"

		Set-SymlinkedPath "./data/datareporting" "./cache/datareporting" Directory
		Set-SymlinkedPath "./data/cache2" "./cache/cache2" Directory

		# add symlinks for easier editing
		Set-SymlinkedPath "./config/userChrome.css" "./data/chrome/userChrome.css" File
		Set-SymlinkedPath "./config/userContent.css" "./data/chrome/userContent.css" File
		# TODO: add other user-editable files as symlinks

		Export-Shortcut "Firefox" "./.pog/firefox_wrapper.cmd" -IconPath "./app/firefox.exe"
	}
}

# TODO: disable autoupdate

# TODO: autoconfig?
# possible content of autoconfig (see here: https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig)
# pref("intl.locale.requested", "{{ .Locale }}");
# // Extensions scopes
# lockPref("extensions.enabledScopes", 4);
# lockPref("extensions.autoDisableScopes", 3);
# // Don't show 'know your rights' on first run
# pref("browser.rights.3.shown", true);
# // Don't show WhatsNew on first run after every update
# pref("browser.startup.homepage_override.mstone", "ignore");
