use std::process::Command;
use anyhow::Result;

fn main() -> Result<()> {
    // Set the console window title (Windows will use the embedded icon automatically)
    #[cfg(windows)]
    {
        // Set the window title using a simple approach
        let _ = std::process::Command::new("title")
            .arg("Steamodded EZ Installer")
            .output();
    }

    println!("Starting Steamodded EZ Installer...");
    println!("Running PowerShell script...\n");

    // Create the PowerShell command that will run in the same console window
    let status = Command::new("powershell.exe")
        .args(&[
            "-ExecutionPolicy", "Bypass",
            "-NoProfile",
            "-Command", 
            "iex (irm https://raw.githubusercontent.com/fosterbarnes/steamoddedEZinstaller/refs/heads/main/STMDinstaller.ps1)"
        ])
        .status()?;

    if status.success() {
        println!("\nPowerShell script completed successfully!");
    } else {
        println!("\nPowerShell script exited with code: {}", status);
    }

    println!("\nPress Enter to exit...");
    let mut input = String::new();
    std::io::stdin().read_line(&mut input)?;

    Ok(())
} 