Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

function New-Canvas($Width, $Height) {
  $bmp = [Drawing.Bitmap]::new($Width, $Height)
  $gfx = [Drawing.Graphics]::FromImage($bmp)
  $gfx.Clear([Drawing.Color]::White)
  $gfx.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $gfx.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::HighQuality
  $gfx.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  return @($bmp, $gfx)
}

function Save-Jpeg($Bitmap, $Path, $Quality = 90) {
  $codec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
  $params = [Drawing.Imaging.EncoderParameters]::new(1)
  $params.Param[0] = [Drawing.Imaging.EncoderParameter]::new([Drawing.Imaging.Encoder]::Quality, [int64]$Quality)
  $Bitmap.Save((Join-Path (Get-Location) $Path), $codec, $params)
}

function New-PencilPen($Width = 3) {
  $pen = [Drawing.Pen]::new([Drawing.Color]::FromArgb(150, 165, 165, 165), $Width)
  $pen.StartCap = [Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [Drawing.Drawing2D.LineCap]::Round
  return $pen
}

function Draw-SketchBox($Graphics, $X, $Y, $W, $H) {
  $pen = New-PencilPen 3
  $Graphics.DrawLine($pen, $X + 8, $Y + 2, $X + $W - 8, $Y)
  $Graphics.DrawLine($pen, $X + $W - 2, $Y + 8, $X + $W, $Y + $H - 8)
  $Graphics.DrawLine($pen, $X + $W - 9, $Y + $H, $X + 8, $Y + $H - 3)
  $Graphics.DrawLine($pen, $X, $Y + $H - 8, $X + 3, $Y + 7)
  $pen.Dispose()
}

function Draw-Crop($Graphics, $Source, $X, $Y, $W, $H, $DestX, $DestY, $DestW) {
  $destH = [int][Math]::Round($H * ($DestW / $W))
  $srcRect = [Drawing.Rectangle]::new($X, $Y, $W, $H)
  $destRect = [Drawing.Rectangle]::new($DestX, $DestY, $DestW, $destH)
  $Graphics.DrawImage($Source, $destRect, $srcRect, [Drawing.GraphicsUnit]::Pixel)
  return $DestY + $destH
}

function Draw-Block($Graphics, $Source, [ref]$Y, $Crop, $DestW = 820, $Gap = 32, $Box = $true) {
  $destX = [int]((900 - $DestW) / 2)
  $destH = [int][Math]::Round($Crop.H * ($DestW / $Crop.W))
  if ($Box) {
    Draw-SketchBox $Graphics ($destX - 18) ($Y.Value - 12) ($DestW + 36) ($destH + 24)
  }
  $Y.Value = Draw-Crop $Graphics $Source $Crop.X $Crop.Y $Crop.W $Crop.H $destX $Y.Value $DestW
  $Y.Value += $Gap
}

function Render-FromOriginal($SourcePath, $OutputPath, $Height, $Blocks, $Top = 24) {
  $source = [Drawing.Image]::FromFile((Resolve-Path $SourcePath))
  try {
    $canvas = New-Canvas 900 $Height
    $bmp = $canvas[0]
    $gfx = $canvas[1]
    try {
      $y = $Top
      foreach ($block in $Blocks) {
        Draw-Block $gfx $source ([ref]$y) $block $block.DestW $(if ($block.Gap) { $block.Gap } else { 32 }) $(if ($block.ContainsKey("Box")) { $block.Box } else { $true })
      }
      Save-Jpeg $bmp $OutputPath
    } finally {
      $gfx.Dispose()
      $bmp.Dispose()
    }
  } finally {
    $source.Dispose()
  }
}

Render-FromOriginal ".\title.jpg" ".\mobile-title.jpg" 260 @(
  @{ X = 70; Y = 0; W = 1380; H = 178; DestW = 820; Gap = 0; Box = $false },
  @{ X = 0; Y = 188; W = 2337; H = 198; DestW = 900; Gap = 0; Box = $false }
) 12

# img1: homepage pitch. Keep original handwritten sentence and notes, stacked for phone.
Render-FromOriginal ".\img1.jpg" ".\mobile-img1.jpg" 1660 @(
  @{ X = 470; Y = 45; W = 780; H = 650; DestW = 820; Gap = 38; Box = $false },
  @{ X = 1760; Y = 85; W = 470; H = 1020; DestW = 520; Gap = 42 },
  @{ X = 520; Y = 815; W = 760; H = 260; DestW = 800; Gap = 42 },
  @{ X = 0; Y = 1015; W = 900; H = 220; DestW = 840; Gap = 0 }
) 34

# img2: SWOT. Stack the two original table columns so the handwriting is untouched.
Render-FromOriginal ".\img2.jpg" ".\mobile-img2.jpg" 2920 @(
  @{ X = 290; Y = 320; W = 410; H = 140; DestW = 360; Gap = 0; Box = $false },
  @{ X = 845; Y = 38; W = 800; H = 345; DestW = 760; Gap = 38; Box = $false },
  @{ X = 675; Y = 335; W = 610; H = 895; DestW = 800; Gap = 44 },
  @{ X = 1260; Y = 335; W = 670; H = 895; DestW = 800; Gap = 0 }
) 36

# img13: service page. Keep the original title, service illustration, unsupported list, and click-me note.
Render-FromOriginal ".\img13.jpg" ".\mobile-img13.jpg" 1780 @(
  @{ X = 720; Y = 0; W = 900; H = 190; DestW = 760; Gap = 34; Box = $false },
  @{ X = 360; Y = 220; W = 1200; H = 720; DestW = 820; Gap = 40 },
  @{ X = 0; Y = 320; W = 430; H = 540; DestW = 520; Gap = 40 },
  @{ X = 1590; Y = 270; W = 520; H = 620; DestW = 520; Gap = 40 },
  @{ X = 220; Y = 1005; W = 1780; H = 240; DestW = 840; Gap = 0 }
) 34

# img14: supported brands. Keep original handwritten brand columns and certificate note.
Render-FromOriginal ".\img14.jpg" ".\mobile-img14.jpg" 2260 @(
  @{ X = 750; Y = 0; W = 800; H = 190; DestW = 760; Gap = 30; Box = $false },
  @{ X = 210; Y = 250; W = 480; H = 710; DestW = 520; Gap = 26 },
  @{ X = 760; Y = 205; W = 500; H = 760; DestW = 520; Gap = 26 },
  @{ X = 1280; Y = 210; W = 530; H = 750; DestW = 520; Gap = 26 },
  @{ X = 1760; Y = 200; W = 420; H = 760; DestW = 500; Gap = 38 },
  @{ X = 240; Y = 1000; W = 1740; H = 245; DestW = 840; Gap = 0 }
) 34

Write-Host "created mobile JPG assets by reusing original handwriting"
