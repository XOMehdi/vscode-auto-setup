# =========================================================
# setup_vscode.ps1
#
# VS Code Auto Setup
#
# Automates installation of commonly used VS Code
# extensions and applies productivity-focused user
# settings.
#
# Features:
#   - Extension installation
#   - User settings configuration
#   - Works without administrator privileges
#   - Modifies only the current user's VS Code profile
#
# =========================================================

Write-Host "`n=== VS Code Auto Setup ===`n"

# --- Check if VS Code CLI is available ---
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "The 'code' command is not available in PATH."
    Write-Host "Open VS Code, press Ctrl+Shift+P, then run:"
    Write-Host "  Shell Command: Install 'code' command in PATH"
    exit 1
}

# --- Spinner helper ---
function Show-Spinner {
    param(
        [scriptblock]$Action,
        [string]$Message = "Working..."
    )

    $spinner = @('|', '/', '-', '\')
    $job = Start-Job $Action
    $i = 0

    while ($job.State -eq 'Running') {
        Write-Host -NoNewline ("`r" + $Message + " " + $spinner[$i])
        Start-Sleep -Milliseconds 150
        $i = ($i + 1) % $spinner.Length
    }

    Receive-Job $job | Out-Null
    Remove-Job $job

    Write-Host "`r$Message ... Done!    `n"
}

# --- Install selected VS Code extensions ---
Write-Host "Installing VS Code extensions..."

Show-Spinner {

    # Documentation & Productivity
    code --install-extension tomoki1207.pdf | Out-Null
    code --install-extension shd101wyy.markdown-preview-enhanced | Out-Null

    # General Development
    code --install-extension formulahendry.code-runner | Out-Null

    # C/C++
    code --install-extension ms-vscode.cpptools-extension-pack | Out-Null

    # Python
    code --install-extension ms-python.python | Out-Null
    code --install-extension ms-toolsai.jupyter | Out-Null
    code --install-extension ms-python.autopep8 | Out-Null

    # Flutter / Dart
    code --install-extension dart-code.flutter | Out-Null

    # PHP
    code --install-extension bmewburn.vscode-intelephense-client | Out-Null

} "Installing extensions"

Write-Host "Extensions installed.`n"

# --- Path to VS Code user settings.json ---
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# --- Ensure settings file exists ---
if (!(Test-Path $settingsPath)) {
    '{}' | Out-File -Encoding UTF8 -FilePath $settingsPath
}

# --- Load existing settings ---
$settings = @{}
$content = Get-Content $settingsPath -Raw

if ($content.Trim() -ne "") {
    try {
        $parsed = $content | ConvertFrom-Json

        $parsed.PSObject.Properties | ForEach-Object {
            $settings[$_.Name] = $_.Value
        }
    }
    catch {
        Write-Host "Existing settings.json contains invalid JSON. Recreating configuration."
        $settings = @{}
    }
}

# --- Apply user configuration settings ---
$settings["files.autoSave"] = "afterDelay"
$settings["editor.formatOnSave"] = $true

# Code Runner
$settings["code-runner.runInTerminal"] = $true
$settings["code-runner.clearPreviousOutput"] = $true
$settings["code-runner.saveFileBeforeRun"] = $true

# Terminal
$settings["terminal.integrated.defaultProfile.windows"] = "Command Prompt"

# --- Save updated settings ---
$settings |
ConvertTo-Json -Depth 10 |
Out-File -Encoding UTF8 -FilePath $settingsPath

Write-Host "`nVS Code configuration completed successfully."
Write-Host "Restart Visual Studio Code to apply all changes."
Write-Host "------------------------------------------------`n"