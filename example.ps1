. ".\main.ps1"
$Bookmarks = Get-Content ".\favorite*" | ConvertFrom-NETSCAPEBookmarkFile1

Write-Host ($Bookmarks | ConvertTo-Json -Dept 5)

<#
  Expected Output
  
  [
    {
        "title":  "Bookmarks",
        "doctype":  "NETSCAPE-Bookmark-file-1",
        "meta":  {
                     "CONTENT":  "text/html; charset=UTF-8",
                     "HTTP-EQUIV":  "Content-Type"
                 },
        "children":  [
                         {
                             "type":  "folder",
                             "parent":  {
                                            "title":  "Bookmarks",
                                            "doctype":  "NETSCAPE-Bookmark-file-1",
                                            "meta":  {
                                                         "CONTENT":  "text/html; charset=UTF-8",
                                                         "HTTP-EQUIV":  "Content-Type"
                                                     },
                                            "children":  [
                                                             "System.Collections.Hashtable"
                                                         ]
                                        },
                             "PERSONAL_TOOLBAR_FOLDER":  "true",
                             "name":  "Favorites bar",
                             "children":  [
                                              {
                                                  "type":  "link",
                                                  "parent":  "System.Collections.Hashtable",
                                                  "ICON":  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAAVUlEQVQoz2NgIAIoMOxn+I8FngfKgMF5hgao0v8oGhuAGtGE/zMIoCj5j66gAcMaLAbjNYEyBfeBEJUkVQFNHbmfoR6rdD0wEqCRdR5rZO2HRRZeAADPlESKcyDMagAAAABJRU5ErkJggg==",
                                                  "name":  "New tab",
                                                  "ADD_DATE":  "1644147455",
                                                  "HREF":  "edge://newtab/"
                                              },
                                              {
                                                  "type":  "link",
                                                  "parent":  "System.Collections.Hashtable",
                                                  "ICON":  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACIklEQVQ4jYWSS0iUURTHf/fe8RvHooE2VlT2FNqUGWmNEYUR9lhEEVJhUIsoXOQuap1Rq6KHNQt3LaPAIOxhlNTChUwLMU3NR1CklUzg6xvPd1ro2KhTHjjcA/e8/uf/hzmmqsUiEheRLhHxp/2TiDxQ1aK5+ZmFeSJSrwuYiMRVNZKuMxnFz51zu9T3GX/6iPGmRqS/F5WAUMEawuUVRI5UYjwPEWl2zlUYY8YMgIjUW2vPBkPfSV6uYbKvJ+uW3rZSojfuABAEQdw5d96oajHQqr7P8IUqpL8X43lEjp3EK4mBtfgt75l4+4po7U3cytWZPbcyjUlTidv642ipDu7foX7bh2zgs92jDhHpUlWdbNmuEw15OvqweqE7ZjboCAEFADrSjs1LkRM7NAt3+bWRebfYudFx9XguwFqbwePs9z/mT/6NLdAHMBpex28W0/C1Y1Zy05VFM75nUwiAZVGT/v5sgdcA3UurOPUrxvXOFhJD7fOmdn4LeNc5NbpkfWimv5mWZ8KXFKdfXqInOYBnc6gsPEjZ8mKssbQOtvEkMczYl0oK8z3un4lgppbYkhZS3Fp7bnD0Jxeba+lODmTFviFcxq29NeRHDUEQ1DnnqtNSjohIo3Nutx+keNz9gmf9zfQkB0ChYMkK9q2KcaLwMJFQGFV9Y4w5YIwZzyBBI2lRLcD9PVXN/SdFqlokInUi0iEiE9P+UUTuqurmufl/AKTzsFGmvUNUAAAAAElFTkSuQmCC",
                                                  "name":  "Google",
                                                  "ADD_DATE":  "1644240016",
                                                  "HREF":  "https://www.google.com/"
                                              },
                                              {
                                                  "type":  "link",
                                                  "parent":  "System.Collections.Hashtable",
                                                  "ICON":  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACrElEQVQ4jW2SzWucVRTGf+fe9847SW2n+WioIdZkJkzGWLMsQvBjpRv1H1BcqSB166aUbgQXLkpEEGnF7ty5Edw0orULtS5DjNOZ5qvEKkMzEUuS6bz33tPFvCNj6LM653LO8/A85wpHUJmbW0QKbwMvAU8BCHpXkZshhK+2mmu3BudloC5UagsfI7wvIsOooqoKID2gqvuqfLFeX7kAdPsEBmZdea74beLcKxoj+R4iPf7BXozBZ9n1jdudN+BOZgEtV5/8pJAW3/JZ90ZU/UiF0yAnVbWpUVvAMLASo7+oUYuFQvrqiRFT2NttLctUtXouleIN62whZNm19dur7wLFiZmzpdbmahvQyWr15L2Dg312dg5n5s5+6lzhvPfZQ59lLyapce+IkSGNkSjaASzQaW2udvrh3Gs07ud2LUqmMVhrzLA4+55RNS+IqsYYO91u+AwIvVz+F3C/DkEffh5i3FdFwSwaEaYUBKT950Z9Ox+MgA4QaL+/22xuCWzl708bwGkv6mMj5XLxiPJRCJOTRYXx3pw6A9wRVRUjpZIZej5Xso+xkAB65lhp0YhM5H9k3ajqrxgD8MAm5sp0tVrLczhqwZ+ZfXbeJckSoGJEUH42MYQvUZXgw5Kq3nRu+I/KMwvLM9X5c/3tqXLtuUpt4WuXyC+CzANRo4audq/Yf9r3d0pjp0atTT7M/OGbxpg9VE5nofPNv+32HsDQ+MgTqXVXRSRV5dAmNo3eL2036tekf7JKbeEngbEY/QcKDzYba7/9Z2B6ulhJj2+LkQljLD5k1zfq8XVY8yY/WVivr7wcNf5oE/e9Mcmt0dnZE/398TR1COMi4n3wlzfqq6/BWheIdiCouLfb+u742KllVP/+q+l/gHYAONgdkdHRxIbgL202fr+aiwLwCG7VPT6fvRxuAAAAAElFTkSuQmCC",
                                                  "name":  "GitHub - GrinsteadDev/ConvertFrom-NETSCAPEBookmarkFile1: PowerShell cmdlet designed to convert a Netscape bookmark file into a hashtable",
                                                  "ADD_DATE":  "1644240060",
                                                  "HREF":  "https://github.com/GrinsteadDev/ConvertFrom-NETSCAPEBookmarkFile1"
                                              },
                                              {
                                                  "type":  "link",
                                                  "parent":  "System.Collections.Hashtable",
                                                  "ICON":  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABW0lEQVQ4jYXTP09VQRAF8N+7PAE1SKOxx8QYDY0kSqD0k0iMH8RAYaIFjQnRjoSvoISCxsKEEgkUr7GwMLFAnihEeFjcs2aD/JlkcnfnnJmdM7uX/20WS9jBfnw7scdn8P/ZMF4l4SQ+iJf9z3CG68QGI1itiJf5anKaUuR1gHXM4RP6+IzNrDfwFB/CfVmSH+EXjvA2sVHcxhV0cRNXgy2Gu4+pLp5V4AGG8j2oZH5HJ9iffK/hOe2EB/iNu9VcOlWBTrWfyDAHkagfTV8zmMusSeIA/SY64Xq0d85JLJ2MamcChw166WAc01kPnSGhG2wWtxLvwbu0s4cvuHdBB/exheMUe6M69QWWs17TXm+xSazgR/Aj7OJOISymiweYx/sa1E6+vMLy1OcL2ETzR+2VPjl1Ou3gvlVFVrT/Q1OTutFUSDcqbCwd9rGQA8+1mbRXv4mRxB6eJv8FDSlmBhh52UMAAAAASUVORK5CYII=",
                                                  "name":  "GitHub Documentation",
                                                  "ADD_DATE":  "1644240113",
                                                  "HREF":  "https://docs.github.com/en"
                                              },
                                              {
                                                  "type":  "folder",
                                                  "parent":  "System.Collections.Hashtable",
                                                  "name":  "Misc",
                                                  "children":  "System.Collections.Hashtable",
                                                  "ADD_DATE":  "1644240257",
                                                  "LAST_MODIFIED":  "1644240333"
                                              }
                                          ],
                             "ADD_DATE":  "1598280918",
                             "LAST_MODIFIED":  "1644240306"
                         }
                     ]
    },
    {
        "children":  [

                     ]
    }
]

#>
