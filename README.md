# VS Code Auto Setup

A simple PowerShell-based automation script for configuring Visual Studio Code with a collection of commonly used extensions and productivity settings.

The script works entirely within the current user's profile and does **not** require administrator privileges.

---

## Features

### Extension Installation

The script automatically installs the following Visual Studio Code extensions:

| Extension | Purpose |
|------------|---------|
| PDF Viewer | View PDF files inside VS Code |
| Markdown Preview Enhanced | Enhanced Markdown preview and export features |
| Code Runner | Quickly execute code files |
| C/C++ Extension Pack | C/C++ development tools |
| Python | Python language support |
| Jupyter | Notebook support |
| Autopep8 | Python code formatting |
| Flutter | Flutter and Dart development |
| PHP Intelephense | PHP language intelligence |

---

### VS Code Configuration

The script updates user settings to:

- Enable Auto Save (`afterDelay`)
- Enable Format on Save
- Use Command Prompt as the default integrated terminal
- Run Code Runner inside the terminal
- Clear previous output before execution
- Save files automatically before execution

Existing settings are preserved whenever possible.

---

## Requirements

- Windows
- Visual Studio Code installed
- Internet connection
- VS Code Command Line Interface (`code`) available in PATH

---

## Installation

1. Download or clone this repository.

2. Close all running VS Code windows.

3. Run:

   ```cmd
   install.cmd
   ```

4. Wait for the script to:
   - Install extensions
   - Update VS Code settings
   - Display completion messages

5. Restart Visual Studio Code.

---

## Troubleshooting

### `'code' command is not available in PATH`

Open VS Code and run:

```text
Ctrl + Shift + P
Shell Command: Install 'code' command in PATH
```

Then restart VS Code and run the setup script again.

### Extension installation fails

- Verify your internet connection.
- Ensure the VS Code Marketplace is reachable.
- Run the setup script again.

### Invalid settings.json

If an existing `settings.json` file contains invalid JSON, the script will reset the configuration file and recreate the required settings.

---

## What Gets Modified?

### User Settings

```text
%APPDATA%\Code\User\settings.json
```

### Extensions Directory

```text
%USERPROFILE%\.vscode\extensions
```

No system-wide changes are made.