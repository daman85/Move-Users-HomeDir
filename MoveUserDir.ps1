


$NewShare = "\\lihs-fs03\users$"

$ADusers = Get-ADuser -Filter * -SearchBase "OU=Central Administration,DC=lihs,DC=local" -Properties sAMAccountName | Select sAMAccountName

foreach($user in $ADusers){
  $HomeDir = Get-ADuser -Iden -SearchBase "OU=Central Administration,DC=lihs,DC=local" -Properties homeDirectory | Select homeDirectory
  $HomeDrive =  Get-ADuser -Iden -SearchBase "OU=Central Administration,DC=lihs,DC=local" -Properties homeDrive | Select homeDrive

  if($HomeDir -ne $null){
    robocopy $HomeDir ($NewShare + "\" + $User) /E /ZB /DCOPY:T /COPYALL /R:1 /W:1 /V /TEE /MIR /SEC /LOG:UserFolderMove.txt
    if ($lastexitcode -eq 0){
    
        Set-ADUser -Identity $user -HomeDirectory ($NewShare + "\" + $User) -HomeDrive $HomeDrive

    }
    else{

        write-host $user  "Robocopy failed with exit code:" $lastexitcode
    }
  }
}


