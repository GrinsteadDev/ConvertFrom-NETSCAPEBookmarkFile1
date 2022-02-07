. ".\main.ps1"
$Bookmarks = Get-Content ".\favorite*" | ConvertFrom-NETSCAPEBookmarkFile1

Write-Host $Bookmarks | ConvertTo-Json
