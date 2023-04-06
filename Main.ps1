{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 HelveticaNeue;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab560
\pard\pardeftab560\slleading20\partightenfactor0

\f0\fs26 \cf0 $deviceName = "HID-compliant mouse"\
\
# Change Power Option\
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0\
\
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0\
\
powercfg -change -monitor-timeout-ac 0\
\
# Download the Parsec installer\
$downloadUrl = "https://builds.parsecgaming.com/package/parsec-windows.exe"\
$downloadPath = "C:\\parsec-windows.exe"\
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath\
\
# Install Parsec silently\
$installArgs = "/S"\
Start-Process -FilePath $downloadPath -ArgumentList $installArgs -Wait\
\
# Ask for user confirmation\
$confirmation = Read-Host "This script will remove the device $deviceName. Are you sure you want to proceed? (Y/N)"\
if ($confirmation -ne "Y" -and $confirmation -ne "y") \{\
    Write-Output "Operation cancelled."\
    exit\
\}\
\
# Remove the device\
$device = Get-PnpDevice -FriendlyName $deviceName\
if ($device) \{\
    Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false\
    Uninstall-PnpDevice -InstanceId $device.InstanceId -Confirm:$false\
    Write-Output "Device $deviceName has been removed."\
\} else \{\
    Write-Output "Device $deviceName not found."\
\}\
\
# Prompt the user to close the window\
Write-Host "Press any key to close this window..."\
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}