# Define paths for Bloxstrap installation, modification, and logs
$installPath = "C:\Users\qiuja\Downloads\bloxstrap-multi-instance-integration-main\bloxstrap-multi-instance-integration-main"
$mutexKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$multiInstancePSPath = "C:\Users\qiuja\AppData\Local\Bloxstrap\Multi-instance.ps1"
$configFilePath = "C:\Users\qiuja\AppData\Local\Bloxstrap\config.json"

# Function to handle installation
function Install-Bloxstrap {
    Write-Host "Installing Bloxstrap Multi-instance integration..."

    # Create the multi-instance script file
    if (-Not (Test-Path $multiInstancePSPath)) {
        Copy-Item "$installPath\Multi-instance.ps1" -Destination $multiInstancePSPath -Force
        Write-Host "Multi-instance.ps1 file installed."
    } else {
        Write-Host "Multi-instance.ps1 file already exists."
    }

    # Create the configuration file if it doesn't exist
    if (-Not (Test-Path $configFilePath)) {
        New-Item -Path $configFilePath -ItemType File -Force
        Write-Host "Configuration file installed."
    } else {
        Write-Host "Configuration file already exists."
    }

    # Add Bloxstrap to startup registry
    try {
        Set-ItemProperty -Path $mutexKey -Name "Bloxstrap" -Value "$multiInstancePSPath" -Force
        Write-Host "Added Bloxstrap to registry for auto-launch."
    } catch {
        Write-Host "Error adding Bloxstrap to the registry: $_"
    }

    Write-Host "Installation complete."
}

# Function to handle uninstallation
function Uninstall-Bloxstrap {
    Write-Host "Uninstalling Bloxstrap Multi-instance integration..."

    # Remove the multi-instance script file
    if (Test-Path $multiInstancePSPath) {
        Remove-Item $multiInstancePSPath -Force
        Write-Host "Removed Multi-instance.ps1 file."
    } else {
        Write-Host "File Multi-instance.ps1 not found for removal."
    }

    # Remove the configuration file if it exists
    if (Test-Path $configFilePath) {
        Remove-Item $configFilePath -Force
        Write-Host "Removed configuration file."
    }

    # Remove registry entry for auto-launching Bloxstrap
    if (Test-Path $mutexKey) {
        try {
            # Check if Bloxstrap entry exists in the registry
            $bloxstrapEntry = Get-ItemProperty -Path $mutexKey -Name "Bloxstrap" -ErrorAction SilentlyContinue
            if ($bloxstrapEntry) {
                Remove-ItemProperty -Path $mutexKey -Name "Bloxstrap"
                Write-Host "Removed auto-launch entry from the registry."
            } else {
                Write-Host "Registry entry for Bloxstrap not found."
            }
        } catch {
            Write-Host "Error accessing registry: $_"
        }
    } else {
        Write-Host "Registry path does not exist."
    }

    # Optional: Check for running Bloxstrap processes and stop them (if necessary)
    $bloxstrapProcesses = Get-Process -Name "Bloxstrap" -ErrorAction SilentlyContinue
    if ($bloxstrapProcesses) {
        Write-Host "Stopping any running Bloxstrap processes to ensure clean uninstallation."
        Stop-Process -Name "Bloxstrap" -Force
    }

    Write-Host "Uninstallation complete."
}

# Validate input (install or uninstall)
if ($args[0] -eq 'install') {
    Install-Bloxstrap
} elseif ($args[0] -eq 'uninstall') {
    Uninstall-Bloxstrap
} else {
    Write-Host "Invalid argument. Use 'install' or 'uninstall'."
}

