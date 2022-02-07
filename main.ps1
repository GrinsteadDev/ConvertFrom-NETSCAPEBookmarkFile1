Add-Type -AssemblyName System.Text.RegularExpressions

function ConvertFrom-NETSCAPEBookmarkFile1 {
    [CmdletBinding()]
    param(
        [parameter(
            ValueFromPipeline = $true
        )] [string] $input = '',
        [parameter(
            ValueFromPipeline = $false
        )] [string] $path = ''
    )

    begin
    {
        [string] $h = '<!DOCTYPE NETSCAPE-Bookmark-file-1>'
        [string] $t = '(?<=(<[t|T][i|I][t|T][l|L][e|E]>)).*(?=(<\/[t|T][i|I][t|T][l|L][e|E]>))'
        [string] $m = '(?<=(<[m|M][e|E][t|T][a|A]>?))[^>]*'
        #group 1 is TagName, group 2 is Attribute Data, group 3 is innerText + preciding '>'
        [string] $tag = '(?<=<)([a-z|A-Z|0-9|\-|_]*(?=\s|>))([^>]*)([^<]*)(?=[\s|\S]*<\/\1>)|<\/DL>'
        [string] $vals = '\\"|"(?:\\"|[^"])*"'
        [string] $keys = '(?<=\s)[a-z|A-Z|0-9|\-|_]*\s?(?==\s?(\\"|"(?:\\"|[^"])*"))'
        [hashtable] $out = @{ children = [System.Collections.ArrayList]@() }
        [object] $currObj = $out
        [System.Text.RegularExpressions.Regex] $tagRgx = [System.Text.RegularExpressions.Regex]::new($tag)
        [System.Text.RegularExpressions.Regex] $keyRgx = [System.Text.RegularExpressions.Regex]::new($keys)
        [System.Text.RegularExpressions.Regex] $valRgx = [System.Text.RegularExpressions.Regex]::new($vals)
    }

    process
    {
        if($path -ne '') { return (Get-Content -Path $path | ConvertFrom-BOOKMARKFILE1) }
        if([bool]($input -match $h)) {
            $out.Add('doctype', 'NETSCAPE-Bookmark-file-1')
        }
        if([bool]($input -match $t)) {
            $out.Add('title', $Matches[0])
        }
        if([bool]($input -match $m)) {
            $tagData = $Matches[0]
            [System.Text.RegularExpressions.MatchCollection] $keysCol = $keyRgx.Matches($tagData)
            [System.Text.RegularExpressions.MatchCollection] $valsCol = $valRgx.Matches($tagData)
            $out.Add('meta', [hashtable]@{})
            for ($i = 0; $i -lt $keysCol.Count; $i++) {
                $out.meta.Add($keysCol[$i].Value, $valsCol[$i].Value.Substring(1, ($valsCol[$i].Value.Length - 2)))
            }
        }
        [System.Text.RegularExpressions.MatchCollection] $tagCol = $tagRgx.Matches($input)
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
<#
.SYNOPSIS
Converts a Netscape Bookmarks file into a hashtable. Optimized for line by 
line read.

.DESCRIPTION
The ConvertFrom-NETSCAPEBookmarkFile1 function converts a provided 
Netscape bookmarks file, such as those used by Google Chrome and Edge, 
into a hashtable. Structured as thus:
    @{
        title='<title>'
        doctype='NETSCAPE-Bookmark-file-1'
        meta=System.Collections.Hashtable
        children=System.Collections.ArrayList
    }
Each child is a hashtable representing one of two structures: folder and 
link. Their HashMaps are as follows:
    @{
        type='folder'
        parent=System.Collections.Hashtable
        children=System.Collections.ArrayList
        name='<name>'
        Any additional attributes defined in the Bookmarks document are added 
        as <key>='<value>'
    }
    @{
        type='link'
        parent=System.Collections.Hashtable
        name='<name>'
        Any additional attributes defined in the Bookmarks document are added 
        as <key>='<value>'
    }

.PARAMETER input
String value for parseing

.PARAMETER path
Specifies the path leading to a bookmarks*.htm(l) file

.INPUTS
System.String representing either the entire file contents or a single 
line of data

.OUTPUTS
System.Collections.Hashtable

.EXAMPLE
PS> Get-Content .\bookmarks*.html | ConvertFrom-NETSCAPEBookmarkFile1

.EXAMPLE
PS> ConvertFrom-NETSCAPEBookmarkFile1 -path .\bookmarks*.html
#>
}
