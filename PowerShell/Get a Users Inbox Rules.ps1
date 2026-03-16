Get-InboxRule -Mailbox foo@bar.com -Verbose | Select-Object Name, Enabled, Priority, From, SubjectContainsWords, Movetofolder, forwardto, deletemessage | Out-GridView
