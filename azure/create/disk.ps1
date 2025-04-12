
$project = "project-cirrus"
$distro = "fedora41"

$resourceGroupName = "$project-rg"
$vhdPath = "./vm/$distro/$distro.vhd"
$diskName = "$project-vhd"
# https://learn.microsoft.com/en-us/rest/api/storagerp/srp_sku_types
# $diskSku = "UltraSSD_LRS"
$location = "westus"
$diskOsType = "linux"
$numberOfUploaderThreads = 8

# Optional parameters
# $Zone = <desired-zone>
# $sku=<desired-SKU>
# -DataAccessAuthMode 'AzureActiveDirectory'
# -DiskHyperVGeneration = V1 or V2. This applies only to OS disks.

# Add-AzVhd
#    [-ResourceGroupName] <String>
#    [-LocalFilePath] <FileInfo>
#    -DiskName <String>
#    [-Location] <String>
#    [-DiskSku <String>]
#    [-DiskZone <String[]>]
#    [-DiskHyperVGeneration <String>]
#    [-DiskOsType <OperatingSystemTypes>]
#    [[-NumberOfUploaderThreads] <Int32>]
#    [-DataAccessAuthMode <String>]
#    [-AsJob]
#    [-DefaultProfile <IAzureContextContainer>]
#    [<CommonParameters>]

# To use $Zone or #sku, add -Zone or -DiskSKU parameters to the command
Add-AzVhd `
    -ResourceGroupName $resourceGroupName `
    -LocalFilePath $vhdPath `
    -DiskName $diskName `
    -Location $location `
    -DiskOsType $diskOsType `
    -NumberOfUploaderThreads $numberOfUploaderThreads
