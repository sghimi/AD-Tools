# Import the necessary module for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object Windows.Forms.Form
$form.Text = "AD User Details"
$form.Size = New-Object Drawing.Size(400, 300)

# Create labels and textboxes
$label = New-Object Windows.Forms.Label
$label.Text = "Enter username:"
$label.Location = New-Object Drawing.Point(20, 20)
$form.Controls.Add($label)

$textBox = New-Object Windows.Forms.TextBox
$textBox.Location = New-Object Drawing.Point(150, 20)
$form.Controls.Add($textBox)

# Create a button
$button = New-Object Windows.Forms.Button
$button.Text = "Get Details"
$button.Location = New-Object Drawing.Point(150, 60)
$button.Add_Click({
    $userID = $textBox.Text
    Get-ADUser $userID -Properties "EmployeeID", Description, Department |
        Select-Object -Property EmployeeID, Name, @{Name = "Username"; Expression = {$_.sAMAccountName}}, Description, Department |
        Format-Table

    Get-ADPrincipalGroupMembership $userID |
        Get-ADGroup -Properties Description |
        Select-Object -Property Name, Description | Format-Table
})
$form.Controls.Add($button)

# Show the form
$form.ShowDialog()
