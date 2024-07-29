function Invoke-TextInput {
    param (
        [string]$LabelText = ''
    )

    <#

    .SYNOPSIS
        Prompts User for input.
    #>
    
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Define custom styles
    $fontFamily = "Aptos"
    $fontSize = 12
    $fontSizeHeader = 14
    $formWidth = 380
    $formHeight = 100
    $backgroundColor = [System.Drawing.ColorTranslator]::FromHtml("#121212")
    $foregroundColor = [System.Drawing.ColorTranslator]::FromHtml("#FFAC1C")
    $buttonBackgroundColor = [System.Drawing.ColorTranslator]::FromHtml("#000019")
    $buttonForegroundColor = [System.Drawing.ColorTranslator]::FromHtml("#cca365")
    $borderColor = [System.Drawing.ColorTranslator]::FromHtml("#555555")

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $FormTitle
    $form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
    $form.StartPosition = 'CenterScreen'
    $form.BackColor = $backgroundColor
    $form.ForeColor = $foregroundColor
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

    # Create a label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $LabelText
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Font = New-Object System.Drawing.Font($fontFamily, $fontSizeHeader)
    $label.BackColor = $backgroundColor
    $label.ForeColor = $foregroundColor
    $form.Controls.Add($label)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

    # Add a paint event to draw the border
    $form.Add_Paint({
        param ($sender, $e)
        $pen = New-Object System.Drawing.Pen($foregroundColor, 2)
        $e.Graphics.DrawRectangle($pen, 0, 0, $form.Width - 1, $form.Height - 1)
        $pen.Dispose()
    })


    # Create a textbox
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Size = New-Object System.Drawing.Size(360, 20)
    $textbox.Location = New-Object System.Drawing.Point(10, 50)
    $textbox.Font = New-Object System.Drawing.Font($fontFamily, $fontSize)
    $textbox.BackColor = $backgroundColor
    $textbox.ForeColor = $foregroundColor
    $textbox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $form.Controls.Add($textbox)
    

    # Create a button
    $button = New-Object System.Windows.Forms.Button
    $button.Text = 'OKie'
    $button.Size = New-Object System.Drawing.Size(100, 25)
    $button.Location = New-Object System.Drawing.Point(150, 100)
    $button.Font = New-Object System.Drawing.Font($fontFamily, $fontSize)
    $button.BackColor = $buttonBackgroundColor
    $button.ForeColor = $buttonForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $buttonBorderColor
    $button.FlatAppearance.BorderSize = 1
    $button.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $form.Controls.Add($button)

    # Set the OK button as the AcceptButton of the form
    $form.AcceptButton = $button

    # Show the form
    $form.Topmost = $true
    $form.Add_Shown({$form.Activate()})
    $null = $form.ShowDialog()
    # Get the user input
    return $textbox.Text
}

$url = Invoke-TextInput -LabelText "Enter Hudu URL"
write-host $url