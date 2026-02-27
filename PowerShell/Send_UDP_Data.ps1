$remoteHost = "0.0.0.0" # Replace with the target IP address or hostname
$remotePort = 4444 # Replace with the target UDP port

try {
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect($remoteHost, $remotePort)

    $message = [System.Text.Encoding]::ASCII.GetBytes("Testing uploading sum data for fun")
    $udpClient.Send($message, $message.Length)

    Write-Host "UDP packet sent to $remoteHost,$remotePort"
    $udpClient.Close()
} catch {
    Write-Host "Failed to send UDP packet: $_"
}
