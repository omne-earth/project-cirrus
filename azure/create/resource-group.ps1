$project = "project-cirrus"
$name = "$project-rg"
$location = "westus"

New-AzResourceGroup `
    -Name $name `
    -Location $location
