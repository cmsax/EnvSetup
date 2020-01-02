# Windows 10 Developer Machine Setup

This is the script for me to setup a new dev box. You can modify the scripts to fit your own requirements.

Run Install.ps1 as Administrator. It can help you to:

- Set a New Computer Name
- Disable Sleep on AC Power
- Add 'This PC' Desktop Icon (need refresh desktop)
- Remove "Microsoft Edge" desktop shortcut icon
- Remove a few pre-installed UWP applications
- Install some applications via `choco`

## Prerequisites

- A clean install of Windows 10 Pro v1903 en-us.
- If you are in China: a stable "Internet" connection.

> This script has not been tested on other version of Windows, please be careful if you are using it on other Windows versions.

## How to Use

Download zip here at GitHub [release page](https://github.com/cmsax/EnvSetup/releases).

### Optional

Double click "Add_PS1_Run_as_administrator.reg" to import it to your registry to enable context menu on the powershell files to run as Administrator.
