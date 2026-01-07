rule service_account_interactive_logon {

  meta:
    // WORK IN PROGRESS
    author = "max-h471"
    description = "Detects service accounts being used interactively"
    log_type = "WINEVTLOG"
    severity = "Medium"
    playbook = "Identity Alerts"
    mitre_attack_technique = "Compromise Accounts"
    mitre_attack_technique_id = "T1586"
    mitre_attack_url = "https://attack.mitre.org/techniques/T1586/"

  events:
    // Windows logon type 3 (network) and type 5 (service) are expected for a service acount, not capturing these events.
    (
    $e.extensions.auth.auth_details != "3" and
    $e.extensions.auth.auth_details != "5" and 
    $e.extensions.auth.mechanism != "NETWORK" and
    $e.extensions.auth.mechanism != "SERVICE" 
    )
    // Windows logon type 10 (remote interactive) and type 2 (interactive) indicate manual login by a user and are not expected for a service account
    (
    $e.extensions.auth.auth_details = "10" or
    $e.extensions.auth.mechanism = "REMOTE_INTERACTIVE"
    //$e.extensions.auth.auth_details = "2" or
    //$e.extensions.auth.mechanism = "USERNAME_PASSWORD"
    )
  // replace svc_ with your organizations naming scheme for Active Directory Service Accounts, this is a common naming scheme for service accounts
($e.target.user.userid = /^(svc_)/ nocase or $e.additional.fields["TargetUserName"] = /^(svc_)/ nocase)
    // capture successful sign ins, which is windows opcode 4624
    $e.metadata.product_event_type = "4624"

    // don't capture events where source host is the same as target host, as this indicates a local login from the system account, which can be mistaken as interactive, rather from one endpoint to another
    $e.principal.hostname != $e.intermediary.hostname
    $e.principal.ip != $e.src.ip 
    
  outcome:
    $user = $e.target.user.userid
    $auth_type = $e.extensions.auth.auth_details
    $risk_score = 40

  condition:
    $e
}
