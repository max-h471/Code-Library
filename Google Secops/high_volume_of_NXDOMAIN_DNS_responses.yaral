rule high_volume_of_NXDOMAIN_DNS_Responses {
/* A high volume of NXDOMAIN responses from the DNS server for an endpoints queries can indicate malware may have been installed and is attempting to reach out
to a command and control (C2) server(s). NXDOMAIN responses will occur due to the use of Fast Flux DNS/DGA due to a rotating domain infrastructure on the attacker side.
*/
  meta:
    author = "max-h471"
    description = "Detects a high volume of NXDOMAIN responses from the Infoblox DNS server for a single hosts DNS query requests, which may indicate Fast Flux DNS behavior"
    severity = "Medium"
    mitre_attack_tactic = "Dynamic Resolution"
    mitre_attack_technique = "Domain Generation Algorithms"
    mitre_attack_url = "https://attack.mitre.org/techniques/T1568/"
  events:
    $e.metadata.log_type = "INFOBLOX_DNS"
    $e.metadata.event_type = "NETWORK_DNS"
    // Track NXDOMAIN queries from a single host
    (
        $e.metadata.product_event_type = /\[DNS Response\] - DNS Response IN (.*) NXDOMAIN/ or 
        $e.security_result.action_details = "NXDOMAIN"
    )
    $e.principal.asset.ip = $src_host
    $e.network.dns.questions.name = $domain
    
    // tune out DNS servers themselves, we want host IPs
    (
        $e.principal.asset.ip != "DNS IP 1" and $e.principal.asset.ip != "DNS IP 2" and $e.principal.asset.ip != "DNS IP 3" // and so on
    )

  match:
    // alert logic will match the source host queries over a 10 minute period
    $domain over 10m

  outcome:
    $nxdomain_count_ = array_distinct($src_host)

  condition:
    // 50 NXDOMAIN query responses over a 10 minute period from a single host
    #src_host >= 100
 }
