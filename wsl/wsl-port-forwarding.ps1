# Place this file in C:\Users\<USERNAME>\.wsl-port-forwarding.ps1
Start-Transcript -Path "C:\Logs\Bridge-WslPorts.log" -Append
$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "Ports: $ports" -ForegroundColor Green
}

else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=3000 listenaddress=0.0.0.0";
Invoke-Expression "netsh interface portproxy add v4tov4 listenport=3000 listenaddress=0.0.0.0 connectport=3000 connectaddress=$wslAddress";

Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=5173 listenaddress=0.0.0.0";
Invoke-Expression "netsh interface portproxy add v4tov4 listenport=5173 listenaddress=0.0.0.0 connectport=5173 connectaddress=$wslAddress";

Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=8000 listenaddress=0.0.0.0";
Invoke-Expression "netsh interface portproxy add v4tov4 listenport=8000 listenaddress=0.0.0.0 connectport=8000 connectaddress=$wslAddress";

# Remove old Firewall rule and create new one
Invoke-Expression "Remove-NetFirewallRule -DisplayName 'WSL Port Forwarding'";
Invoke-Expression "New-NetFirewallRule -DisplayName 'WSL Port Forwarding' -Direction Outbound -Action Allow -Protocol TCP -LocalPort 3000,5173,8000";
Invoke-Expression "New-NetFirewallRule -DisplayName 'WSL Port Forwarding' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3000,5173,8000";

# Run the following commands to create a job which automatically forwards ports on system logon
# $u = "stude"
# $a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"C:\Users\$u\.wsl-port-forwarding.ps1`" -WindowStyle Hidden -ExecutionPolicy Bypass"
# $t = New-ScheduledTaskTrigger -AtLogon
# $s = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
# $p = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
# Register-ScheduledTask -TaskName "WSL2PortsBridge" -Action $a -Trigger $t -Settings $s -Principal $p
