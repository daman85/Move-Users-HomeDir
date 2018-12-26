$NewShare = "\\lihs-fs03\users$"
$OldShare = "\\lihs-fs01\users$"

$ADusers = Get-ADuser -Filter * -SearchBase "OU=Human Resources,OU=Central Administration,DC=lihs,DC=local" -Properties sAMAccountName | Select sAMAccountName

foreach($user in $ADusers){
  write-host $user.sAMAccountName
  $HomeDir = Get-ADuser -Iden $user.sAMAccountName  -Properties homeDirectory | Select homeDirectory
  $HomeDrive =  Get-ADuser -Iden $user.sAMAccountName -Properties homeDrive | Select homeDrive
  write-host $HomeDir.homeDirectory
  
  $logfilename = "UserFolderMove_" + $user.sAMAccountName + ".txt"
  robocopy $HomeDir.homeDirectory ($NewShare + "\" + $User.sAMAccountName) /E /ZB /DCOPY:T /COPYALL /R:1 /W:1 /TEE  /SEC /LOG:$logfilename
  if (($lastexitcode -eq 0) -or ($lastexitcode -eq 1)){
    
        Set-ADUser -Identity $user.sAMAccountName -HomeDirectory ($NewShare + "\" + $User.sAMAccountName) -HomeDrive $HomeDrive.homeDrive
        $newdriename = $OldShare + "\" + $user.sAMAccountName + "old"
        $olddrivename = $OldShare + "\" + $user.sAMAccountName
        Rename-Item $olddrivename $newdriename
   }
   else{

        write-host $user  "Robocopy failed with exit code:" $lastexitcode
   }
  
}