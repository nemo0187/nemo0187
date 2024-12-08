# Define the path where you want to append the results
$outputPath = "C:\users\public\Videos\Results.txt"

# Enumerate local shares, excluding default ones like ADMIN$, C$, etc.
$shares = Get-SmbShare | Where-Object { $_.Name -notin @('ADMIN$', 'C$', 'IPC$', 'print$', 'netlogon','Users') }

# Loop through each share
foreach ($share in $shares) {
    $sharePath = "\\localhost\$($share.Name)"

    # List files inside the share
    try {
        $files = Get-ChildItem -Path $sharePath

        # Loop through each file in the share
        foreach ($file in $files) {
            # Read the file content and append to Results.txt
            try {
                $file.FullName | Out-File -FilePath $outputPath -Append
		Get-Content -Path $file.FullName | Out-File -FilePath $outputPath -Append
                Write-Host "Appended content from $($file.FullName) to $outputPath"
            } catch {
                Write-Warning "Could not read file: $($file.FullName). Error: $_"
            }
        }
    } catch {
        Write-Warning "Could not access share: $sharePath. Error: $_"
    }
}

Write-Host "Finished appending content to $outputPath"
