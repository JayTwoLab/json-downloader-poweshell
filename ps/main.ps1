#################################
#
# JSON File Downloader for Powershell 
#
# https://github.com/JayTwoLab/json-downloader-poweshell
# 
#################################

#
# NOTE: You may set 7zip path for your environment.    
#
# $7ZipPath = "C:\Program Files\7-Zip\7z.exe"
#
$currentLocation = Get-Location
$7ZipPath = $currentLocation.Path + "\" + "7z.exe"

# Function to download a file using a URL
function Download-File {
    param(
        [string]$Url,
        [string]$FilePath
    )

    try {

        # download file from URL
        $webClient = New-Object System.Net.WebClient

        $currentLocation = Get-Location
        $FullFileName = $currentLocation.Path + "\" + $FilePath

        # $webClient.DownloadFile($Url, $FilePath)
        $webClient.DownloadFile($Url, $FullFileName)
        
        # Write-Host "File downloaded successfully to $FilePath"
        Write-Host "File downloaded successfully to $FullFileName "
    }
    catch {
        Write-Host "An error occurred while downloading the file: $_.Exception.Message"
        return $false
    }
    return $true
}

# Function to decompress a file compressed with 7zip
function Extract-7Zip {
    param(
        [string]$sevenZipFile
    )

    if (-not (Test-Path $7ZipPath)) {
        Write-Host "[CRITICAL] 7-Zip is not installed."
        return $false
    }

    # extract file 
    & $7ZipPath x -bso1 -y $sevenZipFile

    return $true 
}


# Function to read a JSON file and download the file
function Download-JsonFile {
    param(
        [string]$DownloadType , 
        [string]$JsonFilePath
    )

    if (-not (Test-Path $JsonFilePath)) {
        Write-Error "JSON file is not exist. : $JsonFilePath"
        return
    }

    try {
        $jsonContent = Get-Content -Path $JsonFilePath -Raw | ConvertFrom-Json
    } catch {
        Write-Error "Failed to load JSON file. : $_"
        return
    }

    # clear firstFilename
    Clear-Variable -Name firstFilename -ErrorAction SilentlyContinue
    
    foreach ($object in $jsonContent.PSObject.Properties) {
        $objURL = $object.Name
        $objFilename = $object.Value
        Write-Output " $objURL : $objFilename "

        if ($null -eq $firstFilename) {
            # Write-Host "empty"
            $firstFilename = $objFilename
        } else {
            # Write-Host "exist"
        }

        # 1) read from objURL 
        # 2) set name to objFilename
        ## Remove-Item $objFilename
        try {
            Remove-Item -Path $objFilename -Force -ErrorAction Stop;
        }
        catch { }

        # Download-File -Url $objURL -FilePath $objFilename
        if ( !(Download-File -Url $objURL -FilePath $objFilename) ) {
            Write-Output "[CRITICAL] Failed to download : $objURL "
            exit  # "Failed to download"
        }
    }

    # 3) extract *.7z.0** to files
    # Extract-7Zip -sevenZipFile ...
    # Write-Host " *** firstFilename : $firstFilename "
    if ($null -eq $firstFilename) {
    } else {
        if ( $DownloadType -eq "7z" ) {
            $currentLocation = Get-Location
            $extractFileName = $currentLocation.Path + "\" + $firstFilename
        
            # extract 7zip file 
            Extract-7Zip -sevenZipFile $extractFileName
        }
    }

}

# main function 

$numberOfArgs = $args.Count
$showHelpPrompt = $false 

if ( $numberOfArgs -eq 2 ) {
    $firstArg = $args[0] # 7z or json
    $secondArg = $args[1] # json filename (such as test.json)

    if ( $firstArg -eq "json" ) {
        # call function (download file(s))
        Download-JsonFile -DownloadType "json" -JsonFilePath $secondArg
        exit 
    }

    if ( $firstArg -eq "7z" ) {
        # call function (download file(s) and extract 7zip file)
        Download-JsonFile -DownloadType "7z" -JsonFilePath $secondArg
        exit 
    }

    $showHelpPrompt = $false
}

if ( ! $showHelpPrompt ) {
    Write-Output " "
    Write-Output "[ json-downloader-poweshell ]"
    Write-Output "  https://github.com/JayTwoLab/json-downloader-poweshell "    
    Write-Output " "    
    Write-Output " [Command Prompt] "
    Write-Output "    powershell -ExecutionPolicy Bypass -File main.ps1 json test.json "     
    Write-Output "    powershell -ExecutionPolicy Bypass -File main.ps1 7z test.json "    
    Write-Output " "    
    Write-Output " [Powershell] Set-ExecutionPolicy Bypass -Scope Process -Force"         
    Write-Output "              .\main.ps1 json .\test.json"    
    Write-Output "              .\main.ps1 7z .\test.json"    
    Write-Output " "
    Write-Output " 'json' only performs the function of downloading files."            
    Write-Output " '7z' even performs the function of releasing the file after downloading it."        
    Write-Output " "    
}

