#requires -version 2
<#
.SYNOPSIS
  Excute SQL scripts in current folder.
.DESCRIPTION
  Excute SQL scripts in current folder.
.PARAMETER N/A
.INPUTS
  None (Connection String Hardcoded)
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Fred James
  Creation Date:  27/12/2019
  Purpose/Change: Initial script development
  
.EXAMPLE
  N/A
#>

function Rename-Script-File ($sourceFile, $targetFile)
{
	If ((Test-Path $targetFile) -and (Test-Path $sourceFile))
	{
		Remove-Item $targetFile
	}
    If (Test-Path $sourceFile)
    {
	    Rename-Item $sourceFile $targetFile
    }
}

function Execute-Query($query)
{
    $connectionString = "Data Source=DBSPARK62.sparkdata.co.uk\SQL2017STD;Initial Catalog=TR_BPMS;Persist Security Info=True;uid=daysj;password=huQKzm8A"
    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $connection)
    Try{
        $result = $command.ExecuteNonQuery()
        Write-Host "Query executed successfully! | $result"
    }
    Catch{
        Write-Host "Unable to execute query:"
        Write-Host $query
        $_.Exception
    }
    $connection.Close()
}

Clear
$query = ""
dir *.sql | Foreach-Object  {
    Write-Host $_.FullName
    $contents = Get-Content $_.FullName
    $query = ""
    $contents | % {
        $line = $_
        if($line -eq "GO") 
        {
            Execute-Query($query)
            $query = ""
        }
        else
        {
            $query = $query + " " + $line
        }
    }
    if($query -ne "")
    {
        Execute-Query($query)
        $query = ""
    }

}

Read-Host -Prompt "Press Enter to exit"