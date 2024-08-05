function Convert-QuserValue
{
        $Users = query user
        $Users = $Users | ForEach-Object {(($_.trim() -replace ">" -replace "(?m)^([A-Za-z0-9]{3,})\s+(\d{1,2}\s+\w+)", '$1  none  $2' -replace "\s{2,}", "," -replace "none", $null))
         } | ConvertFrom-Csv
         foreach ($User in $Users)
         {
		if($Users.ID -eq 'Disc')
           	{	
            		[PSCustomObject]@{  			
			        	ComputerName = $Name
             			Username = $User.Username
             			SessionState = $User.ID
             			SessionType = $($User.SESSIONNAME -Replace '#', '' -Replace "[0-9]+", "")
        		    	IdleTime =  $User.STATE
            			ID = $User.SESSIONNAME
             			LogonTime =$User.'IDLE TIME'}	
           	}
            	else
            	{
                  	[PSCustomObject]@{
                        	ComputerName = $Name
                        	Username = $User.USERNAME
                        	SessionState = $User.STATE
                       		SessionType = $($User.SESSIONNAME -Replace '#', '' -Replace "[0-9]+", "")
                       		IdleTime = $User.'IDLE TIME'
                      		ID = $User.ID
                     		LogonTime =$User.'Logon Time'}
              	}
         }        
 } 
Convert-QuserValue | Where-Object {($_.SessionState -eq ‘Disc’ -and $_.IdleTime -like "*:*" -and $_.IdleTime -gt "1:00" -and $_.Username -notlike "Administrator") } | ForEach-Object {
       rwinsta $_.ID
       write-host $_.Username " logout." -ForegroundColor Red
}
