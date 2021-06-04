
#### List of cable modem IPs ####


# Replacing ssh garbage cypher
$config=@'
Host *
KexAlgorithms +diffie-hellman-group1-sha1
Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc
'@

# Zombie code


# Check if ssh config file exist and replace 
if (Test-Path C:\Users\$env:username\.ssh\config) {
  write-host -ForegroundColor DarkGreen  "config file already exist!"  
  write-host -ForegroundColor DarkGreen  "replacing now ..."  
  Remove-Item "C:\Users\$env:username\.ssh\config"
}
# Else continue
New-Item -Path C:\Users\$env:username\.ssh -Name "config" -ItemType "file" -Value $config
write-host "----------------------------"
write-host -ForegroundColor Green @'
__          __  _                          
\ \        / / | |                         
 \ \  /\  / /__| | ___ ___  _ __ ___   ___ 
  \ \/  \/ / _ \ |/ __/ _ \| '_ ` _ \ / _ \
   \  /\  /  __/ | (_| (_) | | | | | |  __/
    \/  \/ \___|_|\___\___/|_| |_| |_|\___|
                                           
                                           


'@

write-host -ForegroundColor Green @'
          _____                    _____          
         /\    \                  /\    \         
        /::\____\                /::\____\        
       /:::/    /               /:::/    /        
      /:::/    /               /:::/   _/___      
     /:::/    /               /:::/   /\    \     
    /:::/____/               /:::/   /::\____\    
   /::::\    \              /:::/   /:::/    /    
  /::::::\    \   _____    /:::/   /:::/   _/___  
 /:::/\:::\    \ /\    \  /:::/___/:::/   /\    \ 
/:::/  \:::\    /::\____\|:::|   /:::/   /::\____\
\::/    \:::\  /:::/    /|:::|__/:::/   /:::/    /
 \/____/ \:::\/:::/    /  \:::\/:::/   /:::/    / 
          \::::::/    /    \::::::/   /:::/    /  
           \::::/    /      \::::/___/:::/    /   
           /:::/    /        \:::\__/:::/    /    
          /:::/    /          \::::::::/    /     
         /:::/    /            \::::::/    /      
        /:::/    /              \::::/    /       
        \::/    /                \::/____/        
         \/____/                               
                                                  
                                                                                                                                                                  
'@
write-host "----------------------------"
write-host -ForegroundColor Green "Please use responsibly"
# Water Oak multiple IPs 
#$hosts = "10.84.0.106", "10.86.0.14", "10.86.255.41","10.86.255.42"

# Get user input from prompt
#$user = Read-Host -Prompt 'input your user ID'
# Get password input
#$password = Read-Host -Prompt 'input your user password'





$run_again = 1

while ($run_again){
# Test home IPs
$user_res = Read-Host -Prompt "Please enter hosts ( ex >> 10.0.0.89,10.0.0.90 ...) `n"
# Convert $user_res to array 
$hosts = $user_res.split(",")
# Enter mac through prompt
$mac = Read-Host -Prompt "What mac are you looking for? `n"
# Command to run against SSH Session
$command  = Read-Host -Prompt "what command do you want to run on host/s `n"
# remove any other log file in current folder
Remove-Item ".\*.log"
write-host "trying hosts >> "$hosts
for ( $i = 0; $i -lt $hosts.count; $i++ ) {

   <#check conection to host 
   is valid with a ping #>

   write-host "`n `n remoting to host" $hosts[$i]
   # .\ssh_host.ps1 $hosts[$i] $mac
   #New-SSHSession -ComputerName "10.84.0.106" -Credential (Get-Credential)
   New-SSHSession -ComputerName $hosts[$i] -Credential (Get-Credential)
   #Invoke-SSHCommand -Session $i -Command "sh int des"
   write-host "running '$command' command against host" $hosts[$i]
   
   Invoke-SSHCommand -Session $i -Command $command | Out-File ./log$i.log -Verbose 
   Remove-SSHSession -Index $i -Verbose
   Get-Content -Path ./log$i.log
   (Get-SSHJsonKnowHost).RemoveByHost($hosts[$i])
}

   # Get left over sessions and destroy them
   foreach($n in 0..100){
      remove-SSHSession -index $n
   }
   $ans = Read-Host -Prompt "do you want to run again? ( defaults to 'Y')"
   if ($ans -eq "n"){
      $run_again = 0
   }
}