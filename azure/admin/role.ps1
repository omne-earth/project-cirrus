$signInName = "shree@actionproject.net"
$roleDefinitionName = "Data Operator for Managed Disks"
$scope = "/subscriptions/74ca6a50-70c2-4cad-81b8-ba7d3f12104f"
New-AzRoleAssignment -SignInName $signInName `
    -RoleDefinitionName $roleDefinitionName `
    -Scope $scope
