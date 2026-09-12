# Create directories for library_login module
$base = "C:\Users\DarcyCH\Documents\Harmony\DarcyHarmonyNext\library_login"
$dirs = @(
    "src\main\ets\abilitystage",
    "src\main\ets\http",
    "src\main\ets\pages\dh\repository",
    "src\main\ets\pages\dh\usecase",
    "src\main\ets\pages\login\intent",
    "src\main\ets\pages\login\reducer",
    "src\main\ets\pages\login\repository",
    "src\main\ets\pages\login\state",
    "src\main\ets\pages\login\usecase",
    "src\main\ets\pages\login\viewmodel",
    "src\main\ets\pages\register\intent",
    "src\main\ets\pages\register\reducer",
    "src\main\ets\pages\register\repository",
    "src\main\ets\pages\register\state",
    "src\main\ets\pages\register\usecase",
    "src\main\ets\pages\register\viewmodel",
    "src\main\ets\utils",
    "src\main\resources\base\element",
    "src\main\resources\base\media",
    "src\main\resources\base\profile",
    "src\main\resources\en_US\element",
    "src\main\resources\zh_CN\element",
    "src\ohosTest\ets\test"
)

foreach ($dir in $dirs) {
    $path = Join-Path $base $dir
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Write-Output "Created: $path"
}
