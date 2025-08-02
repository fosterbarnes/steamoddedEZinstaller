# Set the title of the PowerShell window
$Host.UI.RawUI.WindowTitle = "Steamodded EZ Installer"

# Set console window size
$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(120, 41)
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(120, 1000)

# Set background color, get console size, and clear the console with background color
[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
$width = [System.Console]::WindowWidth
$height = [System.Console]::WindowHeight
for ($i = 0; $i -lt $height; $i++) {
    Write-Host (" " * $width) # Write a line of spaces to cover the entire width
}

# Define variables
$lovelyReleaseUrl = "https://api.github.com/repos/ethangreen-dev/lovely-injector/releases/latest"
$tempDirectory = "$env:TEMP\balaTemp"
$lovelyTemp = "$tempDirectory\lovelyTemp"
$lovelyDLL = "$lovelyTemp\version.dll"
$lovelyReleaseRequest = Invoke-RestMethod -Uri $lovelyReleaseUrl -Headers $headers
$steamoddedURL = "https://github.com/Steamopollys/Steamodded/archive/refs/heads/main.zip"
$modsDirectory = Join-Path -Path $env:APPDATA -ChildPath "Balatro\Mods"
$headers = @{
    "User-Agent" = "PowerShell"
}
$zipNameMac1 = ""
$zipNameMac2 = ""
$zipNameWin = ""
$counter = 1
$7zipURL = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
$7zipInstallerPath = Join-Path $env:TEMP (Split-Path $7zipURL -Leaf)
$7ZipPath = "C:\Program Files\7-Zip\7z.exe"
$7ZipInstalled = Test-Path $7ZipPath


# Function to convert bytes to megabytes
function Convert-BytesToMB {
    param (
        [int]$bytes
    )
    return [math]::Round($bytes / 1MB, 2)
}

# Function to download a file with progress reporting
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Download-FileWithProgress {
    param (
        [string]$url,
        [string]$outputPath,
        [string]$fileDescription  # New parameter for file description
    )

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)

    # Get the file size
    $fileInfo = Get-Item -Path $outputPath
    $bytesWritten = $fileInfo.Length
    $mbWritten = Convert-BytesToMB -bytes $bytesWritten

    # Output a customized download complete message
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Download complete: $fileDescription - $mbWritten MB"
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}

# Function to automatically find Balatro install path using Steam registry
function Find-BalatroInstallPath {
    Write-Host "`nSearching for Balatro installation..."
    
    # Method 1: Check common Steam locations first
    $commonPaths = @(
        "C:\Program Files (x86)\Steam\steamapps\common\Balatro",
        "C:\Program Files\Steam\steamapps\common\Balatro"
    )
    
         foreach ($path in $commonPaths) {
         if (Test-Path $path) {
             [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
             Write-Host "Found Balatro at: $path"
             [System.Console]::ForegroundColor = [System.ConsoleColor]::White
             return $path
         }
     }
    
    # Method 2: Query Steam registry and search all library locations
    Write-Host "Checking Steam registry for additional library locations..."
    
    # Try to get Steam install path from registry
    $steamPath = $null
    try {
        $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath" -ErrorAction Stop).InstallPath
    } catch {
        try {
            $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Valve\Steam" -Name "InstallPath" -ErrorAction Stop).InstallPath
        } catch {
            Write-Host "Could not find Steam installation in registry."
            return $null
        }
    }
    
    if (-not $steamPath -or -not (Test-Path $steamPath)) {
        Write-Host "Steam installation not found or invalid path."
        return $null
    }
    
         # Check the main Steam library first
     $mainLibraryPath = "$steamPath\steamapps\common\Balatro"
           if (Test-Path $mainLibraryPath) {
          [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
          Write-Host "Found Balatro at: $mainLibraryPath"
          [System.Console]::ForegroundColor = [System.ConsoleColor]::White
          return $mainLibraryPath
      }
    
    # Parse libraryfolders.vdf to find additional Steam libraries
    $libraryFoldersPath = Join-Path $steamPath "steamapps\libraryfolders.vdf"
    if (Test-Path $libraryFoldersPath) {
        try {
            $libraryFoldersContent = Get-Content $libraryFoldersPath -Raw
            $libraryPaths = @()
            
            # Extract library paths from libraryfolders.vdf
            $lines = $libraryFoldersContent -split "`n"
            foreach ($line in $lines) {
                if ($line -match '"path"\s+"([^"]+)"') {
                    $libraryPath = $matches[1]
                    # Normalize the path by replacing double backslashes with single backslashes
                    $libraryPath = $libraryPath -replace '\\\\', '\'
                    $libraryPaths += $libraryPath
                }
            }
            
                         # Search for Balatro in each library
                           foreach ($libraryPath in $libraryPaths) {
                  $balatroPath = "$libraryPath\steamapps\common\Balatro"
                  if (Test-Path $balatroPath) {
                      [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
                      Write-Host "Found Balatro at: $balatroPath"
                      [System.Console]::ForegroundColor = [System.ConsoleColor]::White
                      return $balatroPath
                  }
              }
        } catch {
            Write-Host "Error parsing Steam library folders file."
        }
    }
    
    Write-Host "Balatro installation not found in any Steam library."
    return $null
}


Write-Host "                                 (######.                     "
Write-Host "                             */((///////((*                   "
Write-Host "                           ,#//////////////#*                 "
Write-Host "                         #///////////(#     ,#                "
Write-Host "                       *#////////////(#     ,#                "
Write-Host "                      //(/////////////(#(//,.                 "
Write-Host "          .........  .((///////////////(,. .........          "
Write-Host "       (##*********###//////////////////(##*********(##       "
Write-Host "      #**************/////////////////////*************#*     "
Write-Host "    /#***************/////////////////////**************/#    "
Write-Host "   #/******(#******////////////////////////******/#*******#,  "
Write-Host "   #/***/#    (#/*///////////////////////////*##    /(****#,  "
Write-Host " .**,.****    (#/*/////*,,,.       ,,,,//////*##    ,***,.**, "
Write-Host " ,#     ,#    (#(/////                  */////##    /(     /( "
Write-Host "   #,  (/    #/////********,       ********/////#*   .#   #,  "
Write-Host "             #////..,* *## .*    ,, ### ,,  .///#*            "
Write-Host "             ,((//... .....        .....    ./((,.            "
Write-Host "             ./(,....       ,    ..           ((.             "
Write-Host "             #,....//////            ,/////     #*            "
Write-Host "              (#*.. .////////////////////*    ##              "
Write-Host "                ..(.. ////*,       *////.  /*.                "
Write-Host "                  /*,. ,*////////////**   ,/,                 "
Write-Host "              (####......  .//////*       .######*            "
Write-Host "       (##(((((((((,,,....          ....,,,,,,(((((,(##       "
Write-Host "   #(((((((*,,,,,,,.  ,,,((((,,, ,*((*,,,,,,,,  ,,,,/(((/,#,  "
Write-Host " ,#((((///,,,,,,,..,**((((/*,,,,,..,//((/*,,,,,,,,..,,,//((#( "
Write-Host "#(((((,,,,,,,,. ,,,((((((,,,,,,,,,, ,,,((((,,,,,,,,,..,,,,(((#"
Write-Host "#((((((((/,,,.,,,,(((((*,///(((((//*,,,*/(((/,,,,,,,*/((((///#"
Write-Host "#((((((((((*.,,,/(((((,/(((((((((((((/,,/(((((,,,,*((((((((**("
Write-Host " ,#(((((###, #((((((/,(((((((####(((((((**((((((#* ###((((#,  "
Write-Host "#(////#      #((((((((((((#/      .#((((((((((((#*     #####( "
Write-Host ".*((((.      #(((((((((((#,.       .##((((((((((#*     .*##*. "
Write-Host "             /((((((((((/            ,/(((((((((/,            "
Write-Host "             #####((##                  /##((///#*            "
Write-Host "             #######/                     #/////#*            "

# Try auto-detection first
$balatroPath = Find-BalatroInstallPath

if ($balatroPath) {
    $useAutoDetected = Read-Host "`nUse this automatically detected location? (Y/N)"
    if ($useAutoDetected -eq "N" -or $useAutoDetected -eq "n") {
        $balatroPath = ""
    }
}

# If auto-detection failed or user declined, ask for manual input
if (-not $balatroPath) {
    Write-Host "`n(Open steam, right click Balatro. Select Manage > Browse local files. Copy & paste this path) `n`nEnter your Balatro install location:"
    $balatroPath = Read-Host
    
    # Validate the path
    if (-not (Test-Path $balatroPath)) {
        [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
        Write-Host "Error: The specified path does not exist. Please check the path and try again."
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
        Pause
        Exit
    }
} 

# Create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null
New-Item -Path $lovelyTemp -ItemType Directory *> $null

# Check if 7zip is installed
Write-Host "`nChecking if 7-Zip is installed..."
if (-not $7ZipInstalled) {
    # Install 7-Zip
    Write-Host "`n7-Zip is not installed. Installing 7-Zip..."
    Invoke-WebRequest -Uri $7zipURL -OutFile $7zipInstallerPath
    Start-Process -FilePath $7zipInstallerPath -ArgumentList "/S" -Verb RunAs -Wait
    Remove-Item $7zipInstallerPath

    # Verify installation after running installer
    $7ZipInstalled = Test-Path $7ZipPath
    if ($7ZipInstalled) {
        [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
        Write-Host "7-Zip installed! Continuing..."
        [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    }
    else {
        Write-Host "7-Zip installation failed. Try again or install manually."
        Pause
        exit
    }
}
else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "7-Zip is already installed. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
}

# Download lovely
Write-Host "`nDownloading Lovely..."
foreach ($asset in $lovelyReleaseRequest.assets) {
    $downloadUrl = $asset.browser_download_url
    $filename = $asset.name
    $destinationPath = Join-Path -Path $tempDirectory -ChildPath $filename

    # Download release assets
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Store filenames in variables
    switch ($counter) {
        1 { $zipNameMac1 = $filename }
        2 { $zipNameMac2 = $filename }
        3 { $zipNameWin = $filename }
    }
    $counter++
}

# Confirm lovely downloads correctly
if (Test-Path -Path "$tempDirectory\$zipNameWin") {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Download complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Lovely did not download correctly. Try again or install manually."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Unzip lovely
Write-Host "`nUnzipping Lovely..."
#[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\$zipNameWin", "$lovelyTemp")
& "$7ZipPath" x "$tempDirectory\$zipNameWin" -o"$lovelyTemp" -y *> $null

# Confirm lovely unzips correctly
if (Test-Path -Path "$lovelyTemp\version.dll") {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "File did not unzip correctly. Try again or install manually."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Copy lovely to balatro folder
Write-Host "`nInstalling Lovely..."
Copy-Item -Path $lovelyDLL -Destination "$balatroPath" -Force

# Confirm lovely copies correctly
$versionDllPath = Join-Path -Path "$balatroPath" -ChildPath "version.dll"
if (Test-Path -Path $versionDllPath) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Lovely injector installed. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Lovely did not install correctly. Exiting script."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Clean up
Remove-Item -Path $tempDirectory -Recurse -Force

# Create temp directory
New-Item -Path $tempDirectory -ItemType Directory *> $null

# Download steamodded
Write-Host "`nDownloading Steamodded..."
Download-FileWithProgress -url $steamoddedURL -outputPath "$tempDirectory\Steamodded-main.zip" -fileDescription "Steamodded-main.zip"

# Unzip and delete steamodded .zip
Write-Host "`nUnzipping Steamodded..."
#[System.IO.Compression.ZipFile]::ExtractToDirectory("$tempDirectory\Steamodded-main.zip", "$tempDirectory\Steamodded-main")
& "$7ZipPath" x "$tempDirectory\Steamodded-main.zip" -o"$tempDirectory\Steamodded-main" -y *> $null

# Confirm steamodded unzips correctly
if (Test-Path -Path "$tempDirectory\Steamodded-main\Steamodded-main\README.md") {
    # Double nested folder structure (GitHub archive)
    Rename-Item -Path "$tempDirectory\Steamodded-main\Steamodded-main" -NewName "$tempDirectory\Steamodded-main\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\smods-main\README.md") {
    # smods-main folder structure (actual GitHub structure)
    Rename-Item -Path "$tempDirectory\Steamodded-main\smods-main" -NewName "$tempDirectory\Steamodded-main\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\README.md") {
    # Single folder structure (direct download)
    Rename-Item -Path "$tempDirectory\Steamodded-main" -NewName "$tempDirectory\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} elseif (Test-Path -Path "$tempDirectory\Steamodded-main\Steamodded\README.md") {
    # Already correctly named structure
    Rename-Item -Path "$tempDirectory\Steamodded-main\Steamodded" -NewName "$tempDirectory\Steamodded" -Force
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Unzip complete. Continuing..."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "File did not unzip correctly. Try again or install manually."
    Write-Host "Expected README.md file not found in any expected location."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Pause
    Exit
}

# Create mods folder
Write-Host "`nCreating mods folder..."
if (-Not (Test-Path -Path $modsDirectory)) {
    New-Item -Path $modsDirectory -ItemType Directory -Force *> $null
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Mods folder created at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Mods directory already exists at $modsDirectory."
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Remove-Item -Path "$modsDirectory\Steamodded" -Recurse -Force *> $null
    Remove-Item -Path "$modsDirectory\Steamodded-main" -Recurse -Force *> $null
}

# Install steamodded
Write-Host "`nInstalling Steamodded..."
Copy-Item -Path "$tempDirectory\Steamodded-main\Steamodded" -Destination $modsDirectory -Recurse -Force
Remove-Item -Path $tempDirectory -Recurse -Force

# Define the path for the Steamodded directory
$steamoddedDirectory = Join-Path -Path $modsDirectory -ChildPath "Steamodded"

# Confirm steamodded was installed correctly
if (Test-Path -Path $steamoddedDirectory) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Steamodded installed!"
    [System.Console]::ForegroundColor = [System.ConsoleColor]::White
    Write-Host "`nPlace your mods into %AppData%/Balatro/Mods and launch the game. Have fun!"
    Write-Host "`nPress any key to open mods folder..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Start-Process "explorer.exe" -ArgumentList $modsDirectory
    Exit
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "`nSteamodded did not install correctly. Exiting script."
    Start-Sleep
    Exit
}