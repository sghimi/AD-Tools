# Ensure the Active Directory module is imported
Import-Module ActiveDirectory

# Prompt for user information
$FirstName = Read-Host "Enter First Name"
$LastName = Read-Host "Enter Last Name"
$FullName = Read-Host "Enter Full Name"
$UserLogin = Read-Host "Enter User Login Name"
$Password = Read-Host "Enter Password" -AsSecureString
$Description = Read-Host "Enter Description"
$Email = Read-Host "Enter Email"
$TelephoneNumber = Read-Host "Enter Telephone Number"
$EmployeeID = Read-Host "Enter Employee ID"
$JobTitle = Read-Host "Enter Job Title"
$Company = Read-Host "Enter Company"

# Construct the User Principal Name (UPN)
$UPN = "$UserLogin@windomain.local"

# Define the Distinguished Name (DN) for the new user
$OU = "OU=mmrusers,DC=windomain,DC=local"

# Create a hashtable for user properties
$userProps = @{
    SamAccountName  = $UserLogin
    Name            = $FullName
    GivenName       = $FirstName
    Surname         = $LastName
    UserPrincipalName = $UPN
    Path            = $OU
    AccountPassword = $Password
    Enabled         = $true
    Description     = $Description
    EmailAddress    = $Email
    OfficePhone     = $TelephoneNumber
    EmployeeID      = $EmployeeID
    Title           = $JobTitle
    Company         = $Company
    PasswordNeverExpires = $true
}

# Create the new user
New-ADUser @userProps

# Disable 'User must change password at next logon'
Set-ADUser $UserLogin -ChangePasswordAtLogon $false

Write-Host "User $FullName has been created successfully in $OU."
