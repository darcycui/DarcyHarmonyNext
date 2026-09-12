# Copy source files from login to library_login
$src = "C:\Users\DarcyCH\Documents\Harmony\DarcyHarmonyNext\login"
$dst = "C:\Users\DarcyCH\Documents\Harmony\DarcyHarmonyNext\library_login"

$files = @(
    "src\main\ets\abilitystage\LoginAbilityStage.ets",
    "src\main\ets\http\Urls.ets",
    "src\main\ets\pages\dh\repository\ServerDHExchangeRepository.ets",
    "src\main\ets\pages\dh\usecase\ServerDHExchangeUseCase.ets",
    "src\main\ets\pages\login\LoginIndex.ets",
    "src\main\ets\pages\login\intent\LoginIntent.ets",
    "src\main\ets\pages\login\reducer\LoginReducer.ets",
    "src\main\ets\pages\login\repository\LoginRepository.ets",
    "src\main\ets\pages\login\state\LoginState.ets",
    "src\main\ets\pages\login\usecase\LoginUseCase.ets",
    "src\main\ets\pages\login\viewmodel\LoginViewModelV2.ets",
    "src\main\ets\pages\register\RegisterPage.ets",
    "src\main\ets\pages\register\intent\RegisterIntent.ets",
    "src\main\ets\pages\register\reducer\RegisterReducer.ets",
    "src\main\ets\pages\register\repository\RegisterRepository.ets",
    "src\main\ets\pages\register\state\RegisterState.ets",
    "src\main\ets\pages\register\usecase\RegisterUseCase.ets",
    "src\main\ets\pages\register\viewmodel\RegisterViewModelV2.ets",
    "src\main\ets\utils\AppInfo.ets"
)

foreach ($file in $files) {
    $srcFile = Join-Path $src $file
    $dstFile = Join-Path $dst $file
    Copy-Item -Path $srcFile -Destination $dstFile -Force
    Write-Output "Copied: $file"
}

# Copy resource files
$resFiles = @(
    "src\main\resources\base\element\string.json",
    "src\main\resources\base\element\color.json",
    "src\main\resources\base\media\background.png",
    "src\main\resources\base\media\foreground.png",
    "src\main\resources\base\media\layered_image.json",
    "src\main\resources\base\media\startIcon.png",
    "src\main\resources\base\profile\main_pages.json",
    "src\main\resources\en_US\element\string.json",
    "src\main\resources\zh_CN\element\string.json"
)

foreach ($file in $resFiles) {
    $srcFile = Join-Path $src $file
    $dstFile = Join-Path $dst $file
    if (Test-Path $srcFile) {
        Copy-Item -Path $srcFile -Destination $dstFile -Force
        Write-Output "Copied: $file"
    } else {
        Write-Output "Skipped (not found): $file"
    }
}
