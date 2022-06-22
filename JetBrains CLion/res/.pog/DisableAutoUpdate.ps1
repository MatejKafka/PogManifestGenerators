param(
		[Parameter(Mandatory)]
	$File
)

$d = [XML](Get-Content -Raw $File)
$c = $d.application.component
$options = $c.option
$prop = $options | ? {$_.name -eq "CHECK_NEEDED"}
if ($null -eq $prop) {
	$prop = $d.CreateElement("option")
	$null = $prop.Attributes.Append($d.CreateAttribute("name"))
	$null = $prop.Attributes.Append($d.CreateAttribute("value"))
	$prop.name = "CHECK_NEEDED"
	$null = $c.AppendChild($prop)
}
if ($prop.value -eq "false") {return $false}
$prop.value = "false"
$null = $d.Save($File)
return $true