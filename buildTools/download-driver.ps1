# constants
$version = "v.2.30"
$downloadUrlBase = "https://github.com/operasoftware/operachromiumdriver/releases/download"

$drivers = @(
    [ordered]@{
        platform = "win32";
        fileName = "operadriver.exe";
    }
    ,
    [ordered]@{
        platform = "win64";
        fileName = "operadriver.exe";
    }
    ,
    [ordered]@{
        platform = "mac64";
        fileName = "operadriver";
    }
    ,
    [ordered]@{
        platform = "linux64";
        fileName = "operadriver";
    }
)

# move current folder to where contains this .ps1 script file.
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
pushd $scriptDir
cd ..
$currentPath = Convert-Path "."
$downloadsBaseDir = Join-Path $currentPath "downloads"

$drivers | % {
    $driver = $_
    $platform = $driver.platform

    $downloadDir = Join-Path $downloadsBaseDir $driver.platform
    if (-not (Test-Path $downloadDir -PathType Container)) {
        mkdir $downloadDir > $null
    }

    $driverName = $driver.fileName
    $driverPath = Join-Path $downloadDir $driverName

    Write-Host $driverPath;


    # download driver .zip file if not exists.
    $zipName = "operadriver_$platform.$version.zip"
    $zipPath = Join-Path $downloadDir $zipName
    if (-not (Test-Path $zipPath)) {
        $downloadUrl = "$downloadUrlBase/$version/operadriver_$platform.zip"
        (New-Object Net.WebClient).Downloadfile($downloadurl, $zipPath)
        if (Test-Path $driverPath) {
            del $driverPath 
        }
    }
    Write-Host $zipPath
    # Decompress .zip file to extract driver file.
    if (-not (Test-Path $driverPath)) {
        $shell = New-Object -com Shell.Application
        $zipFile = $shell.NameSpace($zipPath)

        $zipFile.Items() | `
            foreach {
                Write-Host $_.Path
                $shell.NameSpace($_).Items() | `
                where {(Split-Path $_.Path -Leaf) -eq $driverName} | `
                foreach {
                    Write-Host $_.Path
                    $extractTo = $shell.NameSpace($downloadDir)
                    $extractTo.copyhere($_.Path)
                }
        }
        sleep(2)
    }
}