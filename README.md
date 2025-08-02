# steamoddedEZinstaller
Easy window installer for steamodded alpha (https://github.com/Steamopollys/Steamodded) for use with Balatro mods. this script automatically grabs the latest version of Lovely injector & Steamodded, so it should always be up to date.

if Steamodded and/or Lovely injector are already installed, this script will update them to the latest version(s)

# How to Install
## Windows Easy Mode:
1. Download and run [STMDinstaller.exe](https://raw.githubusercontent.com/fosterbarnes/steamoddedEZinstaller/main/STMDinstaller.exe)
2. Press enter

## Windows Slightly Less Easy Mode:
1. Open Windows Powershell or Powershell 7 as administrator
2. Copy the following then paste by right clicking the Powershell window
   ```
   iex (irm https://is.gd/steamodEZinstaller)
   ```
3. Press enter
4. Wait for script to run and complete. That's it!

## Linux (debian/ubuntu/steamOS):

1. Paste one of the following commands into your terminal and run:

```bash
bash <(curl -s https://raw.githubusercontent.com/fosterbarnes/steamoddedEZinstaller/main/STMDinstaller.sh)
```
```bash
wget -qO- https://raw.githubusercontent.com/fosterbarnes/steamoddedEZinstaller/main/STMDinstaller.sh | bash
```
2. Open Steam. Right-click balatro and select "Properties"
3. Paste the following in the "Launch Options" field
```
WINEDLLOVERRIDES="version=n,b" %command%
```
