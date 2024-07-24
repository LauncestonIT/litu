function Invoke-WPFInstall {
    <#

    .SYNOPSIS
        Installs the selected programs using winget, if one or more of the selected programs are already installed on the system, winget will try and perform an upgrade if there's a newer version to install.

    #>

    if($sync.ProcessRunning){
        $msg = "[Invoke-WPFInstall] An Install process is currently running."
        [System.Windows.MessageBox]::Show($msg, "Winutil", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $PackagesToInstall = (Get-WinUtilCheckBoxes)["Install"]
    Write-Host $PackagesToInstall
    if ($PackagesToInstall.Count -eq 0) {
        $WarningMsg = "Please select the program(s) to install or upgrade"
        [System.Windows.MessageBox]::Show($WarningMsg, $AppTitle, [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    Invoke-WPFRunspace -ArgumentList $PackagesToInstall -DebugPreference $DebugPreference -ScriptBlock {
        param($PackagesToInstall, $DebugPreference)
        $packagesWinget= {
            $packagesWinget = [System.Collections.Generic.List`1[System.Object]]::new()
            foreach ($package in $PackagesToInstall) {
                    $packagesWinget.add($package)
                    Write-Host "Queueing $($package.winget) for Winget install"
                }
            }
            return $packagesWinget
        }.Invoke($PackagesToInstall)

        try{
            $sync.ProcessRunning = $true
            $errorPackages = @()
            if($packagesWinget.Count -gt 0){
                Install-WinUtilWinget
                $errorPackages += Install-WinUtilProgramWinget -ProgramsToInstall $packagesWinget
            }
            Write-Host "==========================================="
            Write-Host "--      Installs have finished          ---"
            Write-Host "==========================================="
        }
        Catch {
            Write-Host "==========================================="
            Write-Host "Error: $_"
            Write-Host "==========================================="
        }
        Start-Sleep -Seconds 5
        $sync.ProcessRunning = $False
    }
