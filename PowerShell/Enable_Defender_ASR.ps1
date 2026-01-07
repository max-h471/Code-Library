# Enable all Group Policy Microsoft Defender Attack Surface Reduction (ASR) Rules in BLOCK Mode

# Block abuse of exploited vulnerable signed drivers
Set-MpPreference -AttackSurfaceReductionRules_Ids 56a863a9-875e-4185-98a7-b882c64b5ce5 -AttackSurfaceReductionRules_Actions enabled
# Block Adobe Reader from creating child processes	
Set-MpPreference -AttackSurfaceReductionRules_Ids 7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c -AttackSurfaceReductionRules_Actions enabled
# Block all Office applications from creating child processes	
Set-MpPreference -AttackSurfaceReductionRules_Ids d4f940ab-401b-4efc-aadc-ad5f3c50688a -AttackSurfaceReductionRules_Actions enabled
# Block credential stealing from the Windows local security authority subsystem (lsass.exe)	
Set-MpPreference -AttackSurfaceReductionRules_Ids 9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2 -AttackSurfaceReductionRules_Actions enabled
#Block executable content from email client and webmail	
Set-MpPreference -AttackSurfaceReductionRules_Ids be9ba2d9-53ea-4cdc-84e5-9b1eeee46550 -AttackSurfaceReductionRules_Actions enabled
#Block executable files from running unless they meet a prevalence, age, or trusted list criterion	
Set-MpPreference -AttackSurfaceReductionRules_Ids 01443614-cd74-433a-b99e-2ecdc07bfc25 -AttackSurfaceReductionRules_Actions enabled
# Block execution of potentially obfuscated scripts	
Set-MpPreference -AttackSurfaceReductionRules_Ids 5beb7efe-fd9a-4556-801d-275e5ffc04cc -AttackSurfaceReductionRules_Actions enabled
# Block JavaScript or VBScript from launching downloaded executable content	
Set-MpPreference -AttackSurfaceReductionRules_Ids d3e037e1-3eb8-44c8-a917-57927947596d -AttackSurfaceReductionRules_Actions enabled
# Block Office applications from creating executable content	
Set-MpPreference -AttackSurfaceReductionRules_Ids 3b576869-a4ec-4529-8536-b80a7769e899 -AttackSurfaceReductionRules_Actions enabled
# Block Office applications from injecting code into other processes	
Set-MpPreference -AttackSurfaceReductionRules_Ids 75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84 -AttackSurfaceReductionRules_Actions enabled
# Block Office communication application from creating child processes	
Set-MpPreference -AttackSurfaceReductionRules_Ids 26190899-1602-49e8-8b27-eb1d0a1ce869 -AttackSurfaceReductionRules_Actions enabled
# Block persistence through WMI event subscription
Set-MpPreference -AttackSurfaceReductionRules_Ids e6db77e5-3df2-4cf1-b95a-636979351e5b -AttackSurfaceReductionRules_Actions enabled
# Block process creations originating from PSExec and WMI commands	
Set-MpPreference -AttackSurfaceReductionRules_Ids d1e49aac-8f56-4280-b9ba-993a6d77406c -AttackSurfaceReductionRules_Actions audit
# Block rebooting machine in Safe Mode (preview)	
Set-MpPreference -AttackSurfaceReductionRules_Ids 33ddedf1-c6e0-47cb-833e-de6133960387 -AttackSurfaceReductionRules_Actions enabled
# Block untrusted and unsigned processes that run from USB
Set-MpPreference -AttackSurfaceReductionRules_Ids b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4 -AttackSurfaceReductionRules_Actions audit
# Block use of copied or impersonated system tools (preview)	
Set-MpPreference -AttackSurfaceReductionRules_Ids c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb -AttackSurfaceReductionRules_Actions audit
# Block Webshell creation for Servers	
Set-MpPreference -AttackSurfaceReductionRules_Ids a8f5898e-1dc8-49a9-9878-85004b8a61e6 -AttackSurfaceReductionRules_Actions enabled
# Block Win32 API calls from Office macros	
Set-MpPreference -AttackSurfaceReductionRules_Ids 92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b -AttackSurfaceReductionRules_Actions enabled
# Use advanced protection against ransomware	
Set-MpPreference -AttackSurfaceReductionRules_Ids c1db55ab-c21a-4637-bb3f-a12568109d35 -AttackSurfaceReductionRules_Actions enabled
