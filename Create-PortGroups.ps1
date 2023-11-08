[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Prompt for vSphere server, username, and password
$server = Read-Host "Enter vSphere server address (e.g., vcenter.example.com, esxi hostname or IP)"
$username = Read-Host "Enter your vSphere username (e.g., user@vsphere.local)"
$password = Read-Host -AsSecureString -Prompt "Enter your vSphere password"

# Convert the secure string to a plaintext password (only if needed)
#$passwordText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Use the retrieved credentials for PowerCLI
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password
Connect-VIServer -Server $server -Credential $credential

# List all virtual switches in your vCenter environment
$switches = Get-VirtualSwitch

# Display the list of virtual switches with numbers
Write-Host "Available Virtual Switches:"
for ($i = 0; $i -lt $switches.Count; $i++) {
    Write-Host "$($i + 1): $($switches[$i].Name)"
}

# Prompt the user to select a virtual switch by number
$selectedSwitchNumber = Read-Host "Enter the number of the virtual switch you want to select"

# Check if the selected number is valid
if ($selectedSwitchNumber -ge 1 -and $selectedSwitchNumber -le $switches.Count) {
    # Get the selected virtual switch by number
    $selectedSwitch = $switches[$selectedSwitchNumber - 1]
    
    # Display information about the selected virtual switch
    Write-Host "Selected Virtual Switch Info:"
    $selectedSwitch | Format-Table -AutoSize
} else {
    Write-Host "Invalid selection. Please enter a valid number."
}


# Create a file dialog to pick a CSV file or provide a path
$csvFilePath = Read-Host "Enter the path to a CSV file or press Enter to use the file dialog"
    
    if ([string]::IsNullOrEmpty($csvFilePath)) {
        # Open a file dialog to select a CSV file
        $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $fileDialog.Filter = "CSV Files (*.csv)|*.csv"
        $fileDialog.Title = "Select a CSV File"
        $fileDialog.Multiselect = $false
        
        if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $csvFilePath = $fileDialog.FileName
            Write-Host "Selected CSV File: $csvFilePath"
        } else {
            Write-Host "No CSV file selected."
        }
        }

 # Process the selected CSV file path
    if (Test-Path $csvFilePath -PathType Leaf) {
        # You can read the CSV file with a semicolon delimiter
        $csvData = Import-Csv -Path $csvFilePath -Delimiter ";"

        foreach ($item in $csvData) { 
	        $portgroup = $item.portgroup
            $vlan  = $item.vlan
            #Get-VirtualPortGroup -Name $portgroup | Remove-VirtualPortGroup -confirm:$false
            Get-VirtualSwitch -Name $selectedSwitch | New-VirtualPortGroup -Name $portgroup -VLanId $vlan

            $total = $csvData | Measure-Object | Select-Object -expand count
            
            
    }
    write-Host "All $total Portgroups have been created!!"

    } else {
        Write-Host "CSV file not found at the specified path: $csvFilePath"
    }

disconnect-viserver * -confirm:$false
