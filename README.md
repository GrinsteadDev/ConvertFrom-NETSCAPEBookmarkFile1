# ConvertFrom-NETSCAPEBookmarkFile1
PowerShell cmdlet designed to convert a Netscape bookmark file into a hashtable

## Description
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


## Usage

```powershell
. '.\ConvertFrom-NETSCAPEBookmarkFile1.ps1'

$Bookmarks = Get-Content '.\bookmarks*.html' | ConvertFrom-NETSCAPEBookmarkFile1

#Prints All TOP level childen as Name: <name>[tab]Type: <type>
$Bookmarks.children | % { Write-Host "Name: $($_.name)`tType: $($_.type)" }

```

## License
[MIT](https://choosealicense.com/licenses/mit/)
