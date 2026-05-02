param(
    [string]$ZoteroPath = "C:\Users\mengde\Zotero",
    [switch]$Detailed,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

Write-Output "Zotero library audit"
Write-Output ("path: {0}" -f $ZoteroPath)

if (-not (Test-Path -LiteralPath $ZoteroPath)) {
    $message = "Zotero path not found."
    if ($Strict) { throw $message }
    Write-Output $message
    return
}

$dbPath = Join-Path $ZoteroPath "zotero.sqlite"
if (-not (Test-Path -LiteralPath $dbPath)) {
    $message = "zotero.sqlite not found."
    if ($Strict) { throw $message }
    Write-Output $message
    return
}

$dbItem = Get-Item -LiteralPath $dbPath
Write-Output ("database bytes: {0}" -f $dbItem.Length)
Write-Output ("database modified: {0}" -f $dbItem.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"))

$env:ZOTERO_DB_PATH = $dbPath
$env:ZOTERO_DETAILED = if ($Detailed) { "1" } else { "0" }

@'
import os
import sqlite3

db_path = os.environ["ZOTERO_DB_PATH"]
detailed = os.environ.get("ZOTERO_DETAILED") == "1"
uri = "file:" + db_path.replace("\\", "/") + "?mode=ro"

queries = [
    ("items", "select count(*) from items where itemID not in (select itemID from deletedItems)"),
    ("collections", "select count(*) from collections"),
    ("attachments", "select count(*) from itemAttachments"),
    ("creators", "select count(*) from creators"),
    ("tags", "select count(*) from tags"),
]

with sqlite3.connect(uri, uri=True) as conn:
    cur = conn.cursor()
    for label, sql in queries:
        try:
            value = cur.execute(sql).fetchone()[0]
            print(f"- {label}: {value}")
        except sqlite3.Error as exc:
            print(f"- {label}: unavailable ({exc})")

    if detailed:
        print("")
        print("Collections")
        try:
            rows = cur.execute(
                "select collectionName from collections order by collectionName limit 50"
            ).fetchall()
            for (name,) in rows:
                print(f"- {name}")
        except sqlite3.Error as exc:
            print(f"- unavailable ({exc})")
'@ | python -

if ($LASTEXITCODE -ne 0) {
    throw "Zotero SQLite read-only audit failed."
}

$betterBibtex = Join-Path $ZoteroPath "better-bibtex"
Write-Output ("better-bibtex directory exists: {0}" -f (Test-Path -LiteralPath $betterBibtex))
Write-Output "Zotero library audit completed."
