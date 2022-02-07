Add-Type -AssemblyName System.Text.RegularExpressions

function ConvertFrom-NETSCAPEBookmarkFile1 {
    param(
        [parameter(
            ValueFromPipeline = $true
        )] [string] $line = '',
        [parameter(
            ValueFromPipeline = $false
        )] [string] $path = ''
    )
    begin
    {
        [string] $h = '<!DOCTYPE NETSCAPE-Bookmark-file-1>'
        [string] $t = '(?<=(<[t|T][i|I][t|T][l|L][e|E]>)).*(?=(<\/[t|T][i|I][t|T][l|L][e|E]>))'
        [string] $m = '(?<=(<[m|M][e|E][t|T][a|A]>?))[^>]*'
        [string] $folEd = '<\/[d|D][l|L]>\s*<[p|P]>'
        #group 1 is TagName, group 2 is Attribute Data, group 3 is innerText + preciding '>'
        [string] $tag = '(?<=<)([a-z|A-Z|0-9|\-|_]*(?=\s|>))([^>]*)([^<]*)(?=[\s|\S]*<\/\1>)|<\/DL>'
        [string] $vals = '\\"|"(?:\\"|[^"])*"'
        [string] $keys = '(?<=\s)[a-z|A-Z|0-9|\-|_]*\s?(?==\s?(\\"|"(?:\\"|[^"])*"))'
        [hashtable] $out = @{ children = [System.Collections.ArrayList]@() }
        [object] $currObj = $out
        [System.Text.RegularExpressions.Regex] $tagRgx = [System.Text.RegularExpressions.Regex]::new($tag)
        [System.Text.RegularExpressions.Regex] $keyRgx = [System.Text.RegularExpressions.Regex]::new($keys)
        [System.Text.RegularExpressions.Regex] $valRgx = [System.Text.RegularExpressions.Regex]::new($vals)
        [string] $data = ''
        [bool] $mat = $false
    }
    process
    {
        if($path -ne '') { return (Get-Content -Path $path | ConvertFrom-BOOKMARKFILE1) }
        if([bool]($line -match $h)) {
            $out.Add('doctype', 'NETSCAPE-Bookmark-file-1')
        }
        if([bool]($line -match $t)) {
            $out.Add('title', $Matches[0])
        }
        if([bool]($line -match $m)) {
            $tagData = $Matches[0]
            [System.Text.RegularExpressions.MatchCollection] $keysCol = $keyRgx.Matches($tagData)
            [System.Text.RegularExpressions.MatchCollection] $valsCol = $valRgx.Matches($tagData)
            $out.Add('meta', [hashtable]@{})
            for ($i = 0; $i -lt $keysCol.Count; $i++) {
                $out.meta.Add($keysCol[$i].Value, $valsCol[$i].Value.Substring(1, ($valsCol[$i].Value.Length - 2)))
            }
        }
        [System.Text.RegularExpressions.MatchCollection] $tagCol = $tagRgx.Matches($line)
        for ($i = 0; $i -lt $tagCol.Count; $i++){
            [System.Text.RegularExpressions.MatchCollection] $keysCol = $keyRgx.Matches($tagCol[$i].Groups[2])
            [System.Text.RegularExpressions.MatchCollection] $valsCol = $valRgx.Matches($tagCol[$i].Groups[2])
            switch($tagCol[$i].Groups[1].Value) {
                'H3' {
                    $idx = $currObj.children.Add(
                        [hashtable]@{
                            children = [System.Collections.ArrayList]@()
                            parent = $currObj
                            name = $tagCol[$i].Groups[3].Value.Substring(1)
                            type = 'folder'
                        }
                    )
                    $currObj = $currObj.children[$idx]
                    for ($ii = 0; $ii -lt $keysCol.Count; $ii++) {
                        $currObj.Add($keysCol[$ii].Value, $valsCol[$ii].Value.Substring(1, ($valsCol[$ii].Value.Length - 2)))
                    }
                }
                'A' {
                    $idx = $currObj.children.Add(
                        [hashtable]@{
                            parent = $currObj
                            name = $tagCol[$i].Groups[3].Value.Substring(1)
                            type = 'link'
                        }
                    )
                    for ($ii = 0; $ii -lt $keysCol.Count; $ii++) {
                        $currObj.children[$idx].Add(
                            $keysCol[$ii].Value,
                            $valsCol[$ii].Value.Substring(1, ($valsCol[$ii].Value.Length - 2))
                        )
                    }
                }
                '' {
                    $currObj = $currObj.parent
                }
            }
        }
    }
    end
    {
        return $out
    }
}
