SET ConfigurePowerCFGMonitorTimeoutAC=VALUE
SET ConfigurePowerCFGStandbyTimeoutAC=VALUE
SET ConfigurePowerCFGMonitorTimeoutDC=VALUE
SET ConfigurePowerCFGStandbyTimeoutDC=VALUE

%COMSPEC% /c powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
If not "%ConfigurePowerCFGMonitorTimeoutAC%"=="" ( %COMSPEC% /c powercfg -change -monitor-timeout-ac %ConfigurePowerCFGMonitorTimeoutAC% )
If not "%ConfigurePowerCFGStandbyTimeoutAC%"=="" ( %COMSPEC% /c powercfg -change -standby-timeout-ac %ConfigurePowerCFGStandbyTimeoutAC% )
If not "%ConfigurePowerCFGMonitorTimeoutDC%"=="" ( %COMSPEC% /c powercfg -change -monitor-timeout-dc %ConfigurePowerCFGMonitorTimeoutDC% )
If not "%ConfigurePowerCFGStandbyTimeoutDC%"=="" ( %COMSPEC% /c powercfg -change -standby-timeout-dc %ConfigurePowerCFGStandbyTimeoutDC% )