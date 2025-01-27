<#	
	.NOTES
	===========================================================================
	 Created with: 	PowerShellGUI
	 Created on:   	24/01/2020 10:10 AM
	 Created by:   	Kiren James
	 Organization: 	Atom Inc
	 Filename:     	network-drive-add.ps1
	===========================================================================
	.DESCRIPTION
		A script to select and add network drives on windows domain clients
#>
# Accounts network drive list
$networkDrives =  @(
	('<List-Item-Name-1>', '<Share-Path-1>', '<Drive-Letter-1>'),
	('<List-Item-Name-2>', '<Share-Path-2>', '<Drive-Letter-2>')
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Connect Network Drives'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,30)
$label.Text = 'Please select the drives to connect (Use Ctrl key for multiple selection):'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,50)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'MultiExtended'

for ($i = 0; $i -lt $networkDrives.Count; $i++) {
	[void] $listBox.Items.Add($networkDrives[$i][0])
}

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
	Write-Output "Adding Network Drives..."
	for ( $i = 0; $i -lt $listBox.SelectedItems.Count; $i++ ) {
		switch($listBox.SelectedItems[$i])
		{
			$listBox.SelectedItems[$i] {
				$networkDrives[$i][0]
				[void](New-PSDrive –Name $networkDrives[$i][2] –PSProvider FileSystem –Root $networkDrives[$i][1] –Persist);
				"Done"
				break
			};		
		}
	}
}
cmd /c Pause