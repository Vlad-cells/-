$ErrorActionPreference = "Continue"
$outDir = "C:\Users\Admin\RecipeManager\Assets\Images"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$ua = "RecipeManagerCoursework/1.0 (educational; local desktop app)"

function Get-SlugFile([string]$nameEn) {
  $slug = ($nameEn.ToLower() -replace "[^a-z0-9]+", "-").Trim("-")
  return Join-Path $outDir ($slug + ".jpg")
}

function Save-FromUrl([string]$url, [string]$path) {
  try {
    Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing -TimeoutSec 40 -Headers @{ "User-Agent" = $ua }
    $len = (Get-Item $path).Length
    if ($len -lt 4000) { Remove-Item $path -Force -ErrorAction SilentlyContinue; return $false }
    return $true
  } catch {
    return $false
  }
}

function Save-FromCommons([string]$query, [string]$path) {
  $api = "https://commons.wikimedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=" +
    [uri]::EscapeDataString($query) +
    "&gsrnamespace=6&gsrlimit=8&prop=imageinfo&iiprop=url&iiurlwidth=1000"
  try {
    $resp = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = $ua } -TimeoutSec 40
    if (-not $resp.query.pages) { return $false }
    foreach ($page in $resp.query.pages.PSObject.Properties.Value) {
      $thumb = $page.imageinfo[0].thumburl
      if (-not $thumb) { $thumb = $page.imageinfo[0].url }
      if ($thumb -and (Save-FromUrl $thumb $path)) { return $true }
    }
  } catch { }
  return $false
}

$overrides = @{
  "Buckwheat with mushrooms" = @(
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Buckwheat_kasha_with_fried_mushrooms.jpg/960px-Buckwheat_kasha_with_fried_mushrooms.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grechnevaya_kasha.jpg/960px-Grechnevaya_kasha.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/4/41/Buckwheat_kasha.jpg"
  )
  "Chicken pilaf" = @(
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Uzbek_palov.jpg/960px-Uzbek_palov.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Plov.jpg/960px-Plov.jpg"
  )
  "Banana oatmeal" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Oatmeal_with_banana.jpg/960px-Oatmeal_with_banana.jpg")
  "Ukrainian borscht" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Borscht_served.jpg/960px-Borscht_served.jpg")
  "Shakshuka" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Shakshuka_with_feta.jpg/960px-Shakshuka_with_feta.jpg")
  "Pizza margherita" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Eq_it-na_pizza-margherita_sep2005_sml.jpg/960px-Eq_it-na_pizza-margherita_sep2005_sml.jpg")
  "Homemade burger" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/RedDot_Burger.jpg/960px-RedDot_Burger.jpg")
  "Pasta carbonara" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Espaguetis_carbonara.jpg/960px-Espaguetis_carbonara.jpg")
  "Greek salad" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Greek_salad_01.jpg/960px-Greek_salad_01.jpg")
  "Mushroom risotto" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Risotto_ai_funghi.JPG/960px-Risotto_ai_funghi.JPG")
  "Lasagna" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Lasagne_-_stonesoup.jpg/960px-Lasagne_-_stonesoup.jpg")
  "Pad thai" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Phat_Thai_kung_Chang_Khien_street_stall.jpg/960px-Phat_Thai_kung_Chang_Khien_street_stall.jpg")
  "Avocado toast" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Avocado_toast.jpeg/960px-Avocado_toast.jpeg")
  "Guacamole" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Guacamole-dip.jpg/960px-Guacamole-dip.jpg")
  "Hummus with vegetables" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Hummus_from_The_Nile.jpg/960px-Hummus_from_The_Nile.jpg")
  "Steak with grilled veg" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Beef_fillet_steak_with_peppercorn_sauce.jpg/960px-Beef_fillet_steak_with_peppercorn_sauce.jpg")
  "Garlic shrimp" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Garlic_shrimp.jpg/960px-Garlic_shrimp.jpg")
  "Berry pancakes" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Blueberry_pancakes_%281%29.jpg/960px-Blueberry_pancakes_%281%29.jpg")
  "French toast" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/French_Toast.jpg/960px-French_Toast.jpg")
  "Chicken caesar salad" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Caesar_salad.jpeg/960px-Caesar_salad.jpeg")
  "Sushi bowl" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Sushi_platter.jpg/960px-Sushi_platter.jpg")
  "Adjarian khachapuri" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Adjarian_Khachapuri.jpg/960px-Adjarian_Khachapuri.jpg")
  "Ratatouille" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Ratatouille_01.jpg/960px-Ratatouille_01.jpg")
  "Tom yum" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Tom_yum_kung.jpg/960px-Tom_yum_kung.jpg")
  "Miso soup" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Miso_Soup.jpg/960px-Miso_Soup.jpg")
  "Egg ramen" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Shoyu_Ramen.jpg/960px-Shoyu_Ramen.jpg")
  "Tikka masala" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Chicken_tikka_masala.jpg/960px-Chicken_tikka_masala.jpg")
  "Chicken curry" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Chicken_curry_in_Cochin.jpg/960px-Chicken_curry_in_Cochin.jpg")
  "Caprese" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Caprese.jpg/960px-Caprese.jpg")
  "Gazpacho" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Gazpacho.jpg/960px-Gazpacho.jpg")
  "Popcorn" = @("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Popcorn_Time.jpg/960px-Popcorn_Time.jpg")
}

$names = @(
  "Banana oatmeal","Cheese tomato omelette","Berry pancakes","Syrnyky with sour cream","Avocado toast",
  "Shakshuka","French toast","Yogurt granola bowl","Millet pumpkin porridge","Lazy dumplings",
  "Smoothie bowl","Spinach fried eggs","Banosh with bryndza","Apple fritters","Milk rice pudding",
  "Spanish potato omelette","Buckwheat milk porridge","Honey hotcakes","Salmon sandwich","Cottage cheese bake",
  "Ukrainian borscht","Chicken rice broccoli","Lentil soup","Chicken caesar salad","Pasta carbonara",
  "Greek salad","Chicken pilaf","Potato dumplings","Cabbage rolls","Miso soup",
  "Mushroom risotto","Chicken noodle soup","Ukrainian beans","Okroshka","Egg ramen",
  "Chicken quesadilla","Vegetable couscous","Tom yum","Chicken paella","Beef stroganoff",
  "Tomato gnocchi","Sushi bowl","Fresh cabbage shchi","Kharcho soup","Chicken teriyaki",
  "Lagman","Gazpacho","Pad thai","Kimchi stew","Salmon with potatoes",
  "Steak with grilled veg","Chicken Kyiv","Moussaka","Lasagna","Pizza margherita",
  "Homemade burger","Trout in foil","Ratatouille","Stuffed peppers","Baked mackerel",
  "Pasta bolognese","Chicken curry","Tikka masala","Adjarian khachapuri","Lula kebab",
  "Garlic shrimp","Vegetable stew","Duck with apples","Lamb with chickpeas","Baked potato salmon",
  "Chebureki","Roast turkey","Salt-baked sea bream","Zucchini fritters","Pork with prunes",
  "Buckwheat with mushrooms","Banana yogurt","Apple yogurt honey","Hummus with vegetables","Tomato bruschetta",
  "Guacamole","Chia pudding","Energy balls","Salmon canapes","Fruit salad",
  "Mango smoothie","Peanut butter toast","Cucumbers and hummus","Homemade cocoa","Honey nuts",
  "Cheese plate","Herb popcorn","Caprese","Tiramisu cup","Cheese nachos",
  "Olives and cheese","Berry parfait","Vinegret salad","Herring under a fur coat","Field kulish"
)

$ok = 0; $fail = @()
foreach ($name in $names) {
  $path = Get-SlugFile $name
  $saved = $false
  if ($overrides.ContainsKey($name)) {
    foreach ($u in $overrides[$name]) {
      if (Save-FromUrl $u $path) { $saved = $true; break }
    }
  }
  if (-not $saved) { $saved = Save-FromCommons ($name + " food dish") $path }
  if (-not $saved) { $saved = Save-FromCommons $name $path }
  if ($saved) { $ok++; Write-Output "OK $name" } else { $fail += $name; Write-Output "FAIL $name" }
}
Write-Output "DONE ok=$ok fail=$($fail.Count)"
$fail | ForEach-Object { Write-Output "MISSING $_" }
