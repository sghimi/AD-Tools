Import-Module ActiveDirectory

function GeneratePassword{
    $pass = Invoke-RestMethod https://www.dinopass.com/password/strong
    Write-Host "`nPassword: $pass `nCopied to Clipboard `n"
    $pass | Set-Clipboard

}

function Get-ADUserDetails {
    $userID = Read-Host 'Enter the username'
    Get-ADUser $userID  -Properties "EmployeeID", Description, Department,telephoneNumber, otherMobile |
        Select-Object -Property EmployeeID, Name, @{Name = "Username"; Expression = {$_.sAMAccountName}}, Description, Department,telephoneNumber,otherMobile
    Get-ADPrincipalGroupMembership $userID |
        Get-ADGroup -Properties Description |
        Select-Object -Property @{Name = "Group Name"; Expression = {$_.Name}}, Description | Format-Table
}


function Get-ADGroupMembers {
    $groupID = Read-Host 'Enter the Group name'
    Get-ADGroupMember -Identity $groupID |
        Select-Object -Property Name, DistinguishedName | Format-Table
}

#function Get-ADComputerDetails {
#    $tagID = Read-Host 'Enter the tagID'
#    Get-ADComputer -Identity $tagID -Properties *
#}

do {
    Write-Host "Select an option: `n"
    Write-Host "[1] User Details"
    Write-Host "[2] Generate Password"
    Write-Host "[2] List of Users in group `n"
    $selectedFunction = Read-Host "Enter the number: "

    switch ($selectedFunction) {
        1 { Get-ADUserDetails }
        2 { GeneratePassword }
        3 { Get-ADGroupMembers }
        default { Write-Host "Invalid selection. Please enter 1, 2, 3, or 4." }
    }

    $returnToMenu = Read-Host "Return to Menu (Y/N) `n"
} while ($selectedFunction -notin 1..4 -or $returnToMenu -eq 'Y')
