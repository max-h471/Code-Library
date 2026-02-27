Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, @{name='ProcessName'; expression={(Get-Process -Id $_.Owningprocess).ProcessName}} | ft
