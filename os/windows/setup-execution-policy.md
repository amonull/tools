# Setup Execution Policy
Guide on setting execution policy up to run scripts on windows. I obviously couldnt make this into a script as execution policy didnt allow running scripts to begin with.

# Get Current Execution Policy
```pwsh
Get-ExecutionPolicy
```

# Set Execution Policy To Execute Scripts
```pwsh
Set-ExecutionPolicy -ExecutionPolicy 'Unrestricted' -Scope 'Process'
```

# Reset Execution Policy
If ran [Set-ExecutionPolicy](#set-execution-policy-to-execute-scripts) it should've only changed it for the current pwsh instance
Either run [Set-ExecutionPolicy](#set-execution-policy-to-execute-scripts) with policy gotten from [Get-ExecutionPolicy](#get-current-execution-policy) or run:
```pwsh
Set-ExecutionPolicy -ExecutionPolicy 'Default'
```