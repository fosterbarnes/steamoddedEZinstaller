#!/bin/bash

# Step 1: Create a temporary directory
temp_dir="/tmp/balaTemp"
mkdir -p "$temp_dir" || { echo "Failed to create temp directory"; exit 1; }

# Step 2: Get the latest release download URL for lovely injector
echo "Fetching the latest release URL..."
latest_release=$(curl -s https://api.github.com/repos/ethangreen-dev/lovely-injector/releases/latest)
asset_url=$(echo "$latest_release" | grep "browser_download_url" | grep "lovely-x86_64-pc-windows-msvc.zip" | cut -d '"' -f 4)

# Check if the URL was found
if [[ -z "$asset_url" ]]; then
    echo "Failed to retrieve the download URL."
    exit 1
fi

# Download the lovely injector asset
echo "Downloading lovely-x86_64-pc-windows-msvc.zip..."
curl -L "$asset_url" -o "$temp_dir/lovely-x86_64-pc-windows-msvc.zip" || { echo "Download failed"; exit 1; }

# Step 3: Unzip the asset
echo "Unzipping lovely-x86_64-pc-windows-msvc.zip..."
unzip "$temp_dir/lovely-x86_64-pc-windows-msvc.zip" -d "$temp_dir" || { echo "Failed to unzip"; exit 1; }

# Verify version.dll exists after extraction
if [[ ! -f "$temp_dir/version.dll" ]]; then
    echo "version.dll not found after extraction."
    exit 1
fi

# Step 4: Locate the Steam directory
# Define possible Steam directories
steam_dirs=(
    "$HOME/.steam/steam"
    "$HOME/.local/share/Steam"
    "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
)

steam_apps_dir=""

# Find the correct Steam directory
for dir in "${steam_dirs[@]}"; do
    if [[ -d "$dir/steamapps" ]]; then
        steam_apps_dir="$dir/steamapps"
        break
    fi
done

# Verify we found the Steam apps directory
if [[ -z "$steam_apps_dir" ]]; then
    echo "Steam installation directory not found."
    exit 1
fi

# Step 5: Copy version.dll to the Balatro directory
balatro_dir="$steam_apps_dir/common/Balatro"
mkdir -p "$balatro_dir" || { echo "Failed to create Balatro directory"; exit 1; }
cp "$temp_dir/version.dll" "$balatro_dir" || { echo "Failed to copy version.dll"; exit 1; }

# Step 6: Download Steamodded ZIP
steamodded_url="https://github.com/Steamopollys/Steamodded/archive/refs/heads/main.zip"
echo "Downloading Steamodded main.zip..."
curl -L "$steamodded_url" -o "$temp_dir/Steamodded-main.zip" || { echo "Download failed"; exit 1; }

# Step 7: Unzip the Steamodded file
echo "Unzipping Steamodded-main.zip..."
unzip "$temp_dir/Steamodded-main.zip" -d "$temp_dir" || { echo "Failed to unzip Steamodded"; exit 1; }

# Step 8: Create Mods directory for Balatro
compatdata_dir="$steam_apps_dir/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro"
mods_dir="$compatdata_dir/Mods"
mkdir -p "$mods_dir" || { echo "Failed to create Mods directory"; exit 1; }

# Step 9: Copy unzipped Steamodded folder to Mods directory
cp -r "$temp_dir/Steamodded-main" "$mods_dir/Steamodded" || { echo "Failed to copy Steamodded folder"; exit 1; }

# Cleanup
rm -rf "$temp_dir"
echo "Script completed successfully. Lovely injector and Steamodded have been installed."