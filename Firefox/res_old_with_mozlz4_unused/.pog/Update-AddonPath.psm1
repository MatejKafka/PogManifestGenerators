Set-StrictMode -Version Latest


function Has-Property {
	param($object, $name)
	return $object.PSobject.Properties.Name -contains $name
}

function _Update-Subkey {
	param(
			[Parameter(Mandatory)]
		$Subkey,
			[Parameter(Mandatory)]
			[string]
		$TargetPath
	)
	
	Write-Host "---"
	Write-Host $Subkey.path
	Write-Host $TargetPath
	if ($Subkey.path.Replace("/", "\") -eq $TargetPath) {
		return $false
	}
	
	$origPath = $Subkey.path.Replace("\", "/")
	$Subkey.path = $TargetPath
	
	$TargetPath = $TargetPath.Replace("\", "/")
	
	$Subkey.addons.PSObject.Properties | % {
		$new = $_.Value.rootURI.Replace($origPath.Replace("\", "/"), $TargetPath.Replace("\", "/"))
		if ($new -eq $_.Value.rootURI) {
			# didn't match the previous path
			Write-Host $new
			Write-Host $_.Value.rootURI
			Write-Host $origPath
			Write-Host $TargetPath
			throw "Could not update addon path for '$($_.Name)'."
		}
		$_.Value.rootURI = $new
	}	
	
	return $true
}


$addons = @{
	'app-profile' = "data\extensions"
	'app-system-defaults' = "app\browser\features"
	'app-system-addons' = "app\browser\features"
}

function Update-AddonPath {
	param(
			[Parameter(Mandatory=$true)]
			[string]
		$AddonStartupFile
	)
	
	if (-not (Test-Path -PathType Leaf $AddonStartupFile)) {
		return
	}
	
	$root = & $PSScriptRoot"\mozlz4.exe" $AddonStartupFile | ConvertFrom-Json
	
	$root | Write-Host
	$root.PSObject.Properties | Write-Host
	
	$changed = $false
	$root.PSObject.Properties | % {
		if (-not (Has-Property $_.Value "path")) {
			return
		}
		if (-not $addons.ContainsKey($_.Name)) {
			throw "Unknown Firefox addon type: $($_.Name)"
		}
		# expect we already know all keys with 'path', otherwise this will correctly throw error,
		#  as something unexpected changed
		$res = _Update-Subkey $_.Value (Resolve-Path ($PsScriptRoot + "\..\" + $addons[$_.Name]))
		$changed = $changed -or $res
	}
	
	if (-not $changed) {
		Write-Verbose "Addon paths are already correct."
	} else {
		# by default, PowerShell cuts of objects deeper than 2 layer for legacy reasons, which is why we explicitly specify depth
		$root | ConvertTo-Json -Compress -Depth 64 | & $PsScriptRoot"\mozlz4.exe" --compress - $AddonStartupFile
		Write-Information "Updated addon paths."
	}
}


Export-ModuleMember -Function Update-AddonPath