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
