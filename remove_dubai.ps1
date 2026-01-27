# PowerShell script to remove ALL Dubai/UAE references

$files = @(
    "d:\CateringWeb\lib\data\testimonials_data.dart",
    "d:\CateringWeb\lib\data\office_locations_data.dart", 
    "d:\CateringWeb\lib\data\gallery_data.dart",
    "d:\CateringWeb\lib\screens\home_screen.dart",
    "d:\CateringWeb\lib\screens\about_screen.dart",
    "d:\CateringWeb\lib\screens\contact_screen.dart",
    "d:\CateringWeb\lib\shared\widgets\sections\catering_tiers_section.dart",
    "d:\CateringWeb\lib\widgets\advanced_quote_request_form.dart",
    "d:\CateringWeb\lib\services\config_service.dart",
    "d:\CateringWeb\lib\core\utils\validators.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Replace UAE/Dubai mentions
        $content = $content -replace "Dubai\s*,?\s*UAE", "Pakistan"
        $content = $content -replace "Abu Dhabi\s*,?\s*UAE", "Pakistan"
        $content = $content -replace "Sharjah\s*,?\s*UAE", "Pakistan"
        $content = $content -replace "Dubai", "Pakistan"
        $content = $content -replace "\+971[^\d]*\d+[^\d]*\d+[^\d]*\d+", "+92 305 1340042"
        $content = $content -replace "AED\s*\d+", "Rs 0"
        $content = $content -replace "'AED'", "'PKR'"
        $content = $content -replace '"AED"', '"PKR"'
        $content = $content -replace "dirham", "rupees"
        
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "Updated: $file"
    }
}

Write-Host "Bulk replacement complete!"
