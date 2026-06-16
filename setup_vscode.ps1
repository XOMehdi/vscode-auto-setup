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

# --- VS Code extensions to install ---
$extensions = @(
    @{ Name = "PDF Viewer"; Id = "tomoki1207.pdf" }
    @{ Name = "Markdown Preview Enhanced"; Id = "shd101wyy.markdown-preview-enhanced" }
    @{ Name = "Code Runner"; Id = "formulahendry.code-runner" }
    @{ Name = "C/C++ Extension Pack"; Id = "ms-vscode.cpptools-extension-pack" }
    @{ Name = "Python"; Id = "ms-python.python" }
    @{ Name = "Jupyter"; Id = "ms-toolsai.jupyter" }
    @{ Name = "Autopep8"; Id = "ms-python.autopep8" }
    @{ Name = "Flutter"; Id = "dart-code.flutter" }
    @{ Name = "PHP Intelephense"; Id = "bmewburn.vscode-intelephense-client" }
)

# --- Track overall progress ---
# Extensions + Load Settings + Apply Settings + Save Settings
$totalTasks = $extensions.Count + 3
$currentTask = 0

# --- Install extensions ---
Write-Host "Installing VS Code extensions..."
Write-Host ""

$extensionNumber = 0

foreach ($ext in $extensions) {

    $extensionNumber++
    $currentTask++

    $percent = [math]::Floor(($currentTask / $totalTasks) * 100)

    Write-Progress `
        -Activity "VS Code Auto Setup" `
        -Status "Installing extension $extensionNumber/$($extensions.Count): $($ext.Name)" `
        -PercentComplete $percent

    Write-Host "[$extensionNumber/$($extensions.Count)] Installing $($ext.Name)..."

    code --install-extension $ext.Id --force | Out-Null
}

Write-Host ""
Write-Host "Extensions installed.`n"

# --- Path to VS Code user settings.json ---
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# --- Ensure settings file exists ---
if (!(Test-Path $settingsPath)) {
    '{}' | Out-File -Encoding UTF8 -FilePath $settingsPath
}

# --- Progress: Load settings ---
$currentTask++

Write-Progress `
    -Activity "VS Code Auto Setup" `
    -Status "Loading existing VS Code settings..." `
    -PercentComplete ([math]::Floor(($currentTask / $totalTasks) * 100))

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

# --- Progress: Apply settings ---
$currentTask++

Write-Progress `
    -Activity "VS Code Auto Setup" `
    -Status "Applying configuration settings..." `
    -PercentComplete ([math]::Floor(($currentTask / $totalTasks) * 100))

# --- Apply user configuration settings ---
$settings["files.autoSave"] = "afterDelay"
$settings["editor.formatOnSave"] = $true

# Code Runner
$settings["code-runner.runInTerminal"] = $true
$settings["code-runner.clearPreviousOutput"] = $true
$settings["code-runner.saveFileBeforeRun"] = $true

# Terminal
$settings["terminal.integrated.defaultProfile.windows"] = "Command Prompt"

# --- Progress: Save settings ---
$currentTask++

Write-Progress `
    -Activity "VS Code Auto Setup" `
    -Status "Saving configuration..." `
    -PercentComplete ([math]::Floor(($currentTask / $totalTasks) * 100))

# --- Save updated settings ---
$settings |
    ConvertTo-Json -Depth 10 |
    Out-File -Encoding UTF8 -FilePath $settingsPath

# --- Finish progress display ---
Write-Progress `
    -Activity "VS Code Auto Setup" `
    -Completed

Write-Host "`nVS Code configuration completed successfully."
Write-Host "Restart Visual Studio Code to apply all changes."
Write-Host "------------------------------------------------`n"
