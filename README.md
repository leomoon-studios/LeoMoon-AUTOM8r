# LeoMoon AUTOM8r

LeoMoon AUTOM8r is a profile-based Windows configuration and automation tool built using [AutoIt](https://www.autoitscript.com/site/autoit/downloads/). We designed this tool to create identical Windows setups and images without relying on dependencies like `Active Directory`, `WinRM`, or `OpenSSH`. With AUTOM8r, you can apply various system configurations, install and uninstall applications, and run custom scripts based on settings defined in an INI file.

## Features

- Apply system configurations and modifications
- Install and uninstall applications silently
- Manage environment variables
- Pin applications to the taskbar
- Run custom scripts during different stages of setup
- Network-based installation support

## Prerequisites

- Windows 10 or later
- AutoIt installed (for development purposes)
- Administrative privileges for execution
- Network location to host the files

## Categories of Automation

### 1. Copy Required Files

Copies the necessary files from the specified network location to the local machine. This includes setup files and any additional resources needed for the configuration.

### 2. Configure Environment Variables

Defines and adds environment variables as specified in the `AUTOM8r.ini` file. This ensures that the necessary paths and variables are set up correctly for the system and applications.

### 3. Run Init-Mods (Initial Modification Scripts)

Executes initial modification scripts defined in the `[init-mods]` section of the INI file. These scripts run before the application installation and can perform tasks like setting system configurations, changing PC names, or disabling UAC.

### 4. Install Fonts

The font installation process involves installing fonts located in `fonts\common` on all hosts and installing fonts located in `fonts\hostname` on individual hosts if the directory exists. Below is a detailed explanation and an improved version of the script provided for installing fonts on Windows.

- **Common Fonts**: The fonts in the `fonts\common` directory will be installed on all hosts.
- **Host-specific Fonts**: The fonts in the `fonts\hostname` directory will be installed only on the host with the corresponding name. If the `hostname` directory does not exist, only the common fonts will be installed.

### 5. Install Programs and Program Post Scripts

Installs applications silently using the commands defined in the `[install-apps]` section. Post-installation scripts can also be specified to run additional configuration tasks for each installed program.

### 6. Uninstall Programs

Uninstalls unwanted applications as specified in the `[uninstall-apps]` section. It works by identifying the application name and executing the uninstallation commands.

### 7. Cleanup Startup Registry

Removes specified keys from the startup registry to prevent unwanted programs from running at startup. This is defined in the `[startup-reg-delete]` section and checks common startup paths for the keys to be removed.

### 8. Run Post-Mods

Executes post-modification scripts defined in the `[post-mods]` section of the INI file. These scripts run after application installation to apply further system configurations and tweaks.

### 9. Run Specific Apps at the End (Optional)

Runs specific applications after all configurations and installations are complete. This is defined in the `[run-apps]` section and is useful for launching applications for further configuration.

### 10. Cleanup

Performs cleanup tasks such as removing temporary files, reversing temporary configurations, and finalizing the setup process. This ensures that the system is left in a clean state after automation.

## Getting Started

### Setup

- **Network Location**:
   - Ensure the necessary files and folders are available at a network location accessible by the target machines.
   - Example: `\\example.local\public\AUTOM8r`

That looks good! Here's a slightly refined version for clarity:

### Directory Structure

- **Root Directory**:
   - `AUTOM8r.exe` - The compiled AutoIt script.
   - `AUTOM8r.ini` - Configuration file.
   - `modules` - Directory containing all the required files and scripts.

- **Modules Directory**:
   - `init-mods` - Folder containing initial modification scripts.
   - `post-mods` - Folder containing post-modification scripts.
   - `install-apps` - Folder containing application setup files and post-install scripts.
     - Application setup files should be named in the format `appnameSetup.(exe|msi|iso)`.
     - Post-install scripts should be named in the format `appnamePost.bat`.
   - `tools` - Folder containing tools used by AUTOM8r.

### Execute the Program

- Copy `AUTOM8R.exe` and `AUTOM8r.ini` profile to the target computer.
- Run `AUTOM8r.exe` with administrative privileges on the target machine.

## Configuration

Copy the `AUTOM8r.ini` file and create a profile for each type of computer you want to automate. Define your setup parameters within each profile. In the INI file, `1` means the item will be executed, run, or installed, and `0` means it will be skipped.

### Scripts bundled with AUTOM8r

These are the current scripts bundled with AUTOM8r. Users can extend it and add their own scripts by modifying the `AUTOM8r.ini` file and placing the corresponding script files in the appropriate directories.

#### List of `init-mods` Scripts (Initial Modification)

- Change PC Name.bat
- Disable UAC.bat
- Enable RDP.bat
- Enable Dark Theme.bat
- Enable Small Icons.bat
- Show Hidden Files.bat
- Change User Folder.bat
- Configure Date Time Format.bat
- Change Background To Mid Gray.bat
- Enable WSL.bat
- Enable Classic Context Menu.bat
- Enable Old Start And Taskbar.bat
- Show File Extensions.bat
- Disable Data Collection.bat
- Disable New App Notification.bat
- Disable Automatic Driver Update.bat
- Disable Recent.bat
- Disable Notification Center.bat
- Disable Cortana.bat
- Disable Hypervisor.bat
- Disable People Band.bat
- Disable Windows Ink.bat
- Disable Pen Flicks.bat
- Disable Tablet Mode.bat
- Disable Auto Recovery.bat
- Disable AutoPlay.bat
- Disable Program Compatibility Assistant Service.bat
- Disable Windows Search Service.bat
- Disable Windows Suggestions.bat
- Disable ThumbsDB.bat
- Disable Remote Assistance.bat
- Disable Storage Sense.bat
- Disable Auto Sign-on.bat
- Show All Tray Icons.bat
- Hide Task View Button.bat
- Hide Taskbar Keyboard Button.bat
- Cleanup Sound Devices.bat
- Remove Microsoft Quick Assist.bat
- Remove OneDrive.bat
- Add Additional Clocks.bat
- Add CMD To Right Click.bat
- Add Control Panel To Right Click.bat
- Add Network Connections To Right Click.bat
- Add Programs And Features To Right Click.bat
- Fix Network Drives Not Showing.bat
- Fix Downloads Folder Listing.bat
- Fix Icon Spacing.bat
- Configure PowerCFG.bat

#### List of Post Application Scripts

- gitPost.bat
- potplayerPost.bat
- pythonPost.bat
- vscodePost.bat

#### List of `post-mods` Scripts (Post Modification)

- Cleanup.bat

#### Targeting Specific Windows Version for `init-mods` and `post-mods` Scripts

When writing batch scripts for `init-mods` and `post-mods`, you may need to target specific Windows version. Here is an example of how to do this:
```cmd
wmic os get name | find "Windows 10 " > nul && (echo Windows 10 & GOTO :WIN_10)
wmic os get name | find "Windows 11 " > nul && (echo Windows 11 & GOTO :WIN_11)

exit /b

:WIN_10
@REM Tasks for Windows 10
exit /b

:WIN_11
@REM Tasks for Windows 11
exit /b
```

### Adding New Applications

To add a new application to the configuration, you need to create a new section in the INI file. Below are the steps and guidelines for creating this section, including how to handle silent switches and ISO installations.

#### Example Section for a Standard Application
Here is a template for adding a standard application:

```ini
[appname]
display-name = Application Name
partial-search = 1
silent-switches = --silent
win-wait = disabled
click-element = disabled
process-close = disabled
run-close = disabled
post-setup = 0
```

- **appname**: Replace `appname` with the actual name of the application.
- **display-name**: The name that will be displayed in the application list. This in combination with `partial-search` is used to determine whether the application is already installed or not.
- **partial-search**: Set to `1` if partial matching should be used when searching for the application.
- **silent-switches**: The command-line switches used to perform a silent installation.
- **win-wait**: If you need to wait for a specific window to appear during the installation, provide the full path to the executable file that triggers the window. For example: `win-wait = C:\Path\To\Executable.exe`. Set to `disabled` to disable this feature.
- **click-element**: If you need to click a specific UI element during the installation, provide the details of the element to click. For example: `click-element = button:install`. Set to `disabled` to disable this feature.
- **process-close**: If you need to close a specific process after installation, provide the full path to the process executable. For example: `process-close = C:\Path\To\Process.exe`. Set to `disabled` to disable this feature.
- **run-close**: If you need to run then close the installed program to generate config files, provide the full path to the executable. For example: `run-close = C:\Program Files\appname\appname.exe`. Set to `disabled` to disable this feature.
- **post-setup**: Set to `1` will execute a post script named `appnamePost.bat`. Ensure that `appnamePost.bat` exists in the `install-apps` folder.

#### Character Replacement in Silent Switches

Due to INI file format limitations, certain characters in the silent switches must be replaced:
- Replace the equal sign (`=`) with `|EQUAL|`.
- Replace the comma (`,`) with `|COMMA|`.

These replacements are necessary to prevent the INI parser from misinterpreting the configuration.

**Example:**

Original silent switch:
```
--silent=value1,value2
```

Modified for INI file:
```
silent-switches = --silent|EQUAL|value1|COMMA|value2
```

#### Example Section for an ISO Installation

For applications that are installed from an ISO file, an additional `setup-file` key is required to specify the path to the setup file within the ISO.

```ini
[adobe-photoshop]
setup-file = Adobe 2024\Set-up.exe
display-name = Adobe Photoshop
partial-search = 1
silent-switches = --silent|EQUAL|1
win-wait = disabled
click-element = disabled
process-close = disabled
run-close = disabled
post-setup = 1
```

- **appname**: Replace `appname` with the actual name of the application.
- **setup-file**: The relative path to the setup file within the ISO. This can be an `.exe`, `.msi`, or `.bat` file.
- **display-name**: The name that will be displayed in the application list.
- **partial-search**: Set to `1` if partial matching should be used when searching for the application. This in combination with `partial-search` is used to determine whether the application is already installed or not.
- **silent-switches**: The command-line switches used to perform a silent installation. Replace `=` with `|EQUAL|` and `,` with `|COMMA|` as described above.
- **win-wait**: If you need to wait for a specific window to appear during the installation, provide the full path to the executable file that triggers the window. For example: `win-wait = C:\Path\To\Executable.exe`. Set to `disabled` to disable this feature.
- **click-element**: If you need to click a specific UI element during the installation, provide the details of the element to click. For example: `click-element = button:install`. Set to `disabled` to disable this feature.
- **process-close**: If you need to close a specific process after installation, provide the full path to the process executable. For example: `process-close = C:\Path\To\Process.exe`. Set to `disabled` to disable this feature.
- **run-close**: If you need to run then close the installed program to generate config files, provide the full path to the executable. For example: `run-close = C:\Program Files\appname\appname.exe`. Set to `disabled` to disable this feature.
- **post-setup**: Set to `1` will execute a post script named `appnamePost.bat`. Ensure that `appnamePost.bat` exists in the `install-apps` folder.

### Unattended Windows Deployment

To automate the execution of `AUTOM8r` during an unattended Windows deployment, add the following commands to the `FirstLogonCommands` section of your `unattend.xml`:

```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <Description>Enable SMB Guest Access</Description>
        <Order>1</Order>
        <CommandLine>reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v AllowInsecureGuestAuth /t REG_DWORD /d 1 /f</CommandLine>
    </SynchronousCommand>
    <SynchronousCommand wcm:action="add">
        <Order>2</Order>
        <Description>Download AUTOM8r.exe</Description>
        <CommandLine>powershell -Command "$ProgressPreference = 'SilentlyContinue'; Copy-Item -Path '\\lmbts.local\public\AUTOM8r\AUTOM8r.exe' -Destination 'C:\Windows\Temp\AUTOM8r.exe'"</CommandLine>
    </SynchronousCommand>
    <SynchronousCommand wcm:action="add">
        <Order>3</Order>
        <Description>Download AUTOM8r.ini</Description>
        <CommandLine>powershell -Command "$ProgressPreference = 'SilentlyContinue'; Copy-Item -Path '\\lmbts.local\public\AUTOM8r\AUTOM8r.ini' -Destination 'C:\Windows\Temp\AUTOM8r.ini'"</CommandLine>
    </SynchronousCommand>
    <SynchronousCommand wcm:action="add">
        <Order>4</Order>
        <Description>Run AUTOM8r</Description>
        <CommandLine>powershell -Command "Start-Process -FilePath 'C:\Windows\Temp\AUTOM8r.exe' -ArgumentList '-q' -Verb RunAs"</CommandLine>
    </SynchronousCommand>
</FirstLogonCommands>
```

This ensures that `AUTOM8r` and its configuration file are downloaded and executed during the first logon, automating the entire setup process with administrative privileges.

## Contributing

1. **Fork the Repository**:
   - Fork the project repository to your GitHub account.

2. **Make Changes**:
   - Implement your changes and test thoroughly.

3. **Submit a Pull Request**:
   - Submit a pull request with a detailed description of your changes.

## License

LeoMoon AUTOM8r is freeware and open source. Feel free to modify and distribute it under the terms of the [GPLv3 License](LICENSE).
