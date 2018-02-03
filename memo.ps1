$scriptDir = $PSScriptRoot
$memoDir = "$env:UserProfile\Desktop"

# タイトルを取得
$title = Read-Host "Title: "

# 現在日時と時間を取得
$timeStamp = Get-Date -Format "yyyyMMdd-HHmm"
$timeDate = Get-Date -Format "yyyy/MM/dd"
$timeStart = Get-Date -Format "HH:mm"

# テンプレートからコピーして新規ファイルを作成
# テンプレートファイルが UTF8 なので、開く時も、書き出す時も "-Encoding" オプションで UTF8 を指定する必要がある。
$data = Get-Content $scriptDir\template\template_meeting.md -Encoding UTF8
$data = $data | ForEach-Object { $_ -replace "%Title%","$title" }           # タイトルを置き換え
$data = $data | ForEach-Object { $_ -replace "%Date%","$timeDate" }         # 日付を置き換え
$data = $data | ForEach-Object { $_ -replace "%Start_Time%","$timeStart" }  # 開始時間を置き換え
# ファイル名を定義
$fileDir = "$timeStamp" + "_" + "$title"
New-Item $memoDir\$fileDir -ItemType Directory > $null

$fileName = "$timeStamp" + "_" + "$title" + ".md"
$fullPath = "$memoDir\$fileDir\$fileName"
$data | Out-File "$fullPath" -Encoding utf8

# テキストエディタを起動
Start-Process -FilePath 'C:\Program Files (x86)\Hidemaru\Hidemaru.exe' -ArgumentList $fullPath -Wait

# テキストエディタが終了したら、完了時間を置き換える。
$timeEnd = Get-Date -Format "HH:mm"
$data = Get-Content $fullPath -Encoding UTF8
$data = $data | ForEach-Object { $_ -replace "%End_Time%","$timeEnd" }  # 完了時間を置き換え
$data | Out-File "$fullPath" -Encoding utf8