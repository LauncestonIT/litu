function Invoke-WPFInstallComet {

    <#

    .SYNOPSIS
        Installs Comet Backup.

    .PARAMETER Button
    #>
    Write-Host "Starting install of Comet Backup..."
    Add-Type -AssemblyName System.Windows.Forms
    
    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = ''
    $form.Size = New-Object System.Drawing.Size(500,150)
    $form.StartPosition = 'CenterScreen'

    # Create a label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = 'Please enter your Comet Backup server URL (eg. https://comet.example.com):'
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10,20)
    $form.Controls.Add($label)

    # Create a textbox
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Size = New-Object System.Drawing.Size(260,20)
    $textbox.Location = New-Object System.Drawing.Point(10,50)
    $form.Controls.Add($textbox)

    # Create a button
    $button = New-Object System.Windows.Forms.Button
    $button.Text = 'OK'
    $button.Location = New-Object System.Drawing.Point(100,80)
    $button.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $form.Controls.Add($button)

    # Show the form
    $form.Topmost = $true
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog()

    # Get the user input
    $cometURL = $textbox.Text

    $url = "$cometURL/dl/1"
    $zipPath = "$env:TEMP\comet.zip"
    $extractPath = "$env:TEMP\comet"
    # Download the zip file
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    # Extract the zip file
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
    }
    Expand-Archive -Path $zipPath -DestinationPath $extractPath
    # Verify the necessary files are extracted
    $installExe = Join-Path -Path $extractPath -ChildPath "install.exe"
    $installDat = Join-Path -Path $extractPath -ChildPath "install.dat"
    
    if (-Not (Test-Path $installExe) -Or -Not (Test-Path $installDat)) {
        throw "Installation files are missing."
    } else {
        # Start the installer with silent install flag
        Write-Host "Silently running installer in lobby mode..."
        Set-Location -Path $extractPath
        Start-Process -FilePath $installExe -ArgumentList "/S /LOBBY /dat=$installDat" -Wait
        Set-Location $env:USERPROFILE
    }
}