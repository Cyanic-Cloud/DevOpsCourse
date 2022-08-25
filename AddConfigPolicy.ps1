function Add-DeviceConfigurationPolicy() {

    # ----- [Initialisations] -----

    # Script parameters.
    param (
        [parameter(Mandatory = $true)]
        [string]$FilePath
    )

    # Set Error Action - Possible choices: Stop, SilentlyContinue
    $ErrorActionPreference = "Stop"



    # ----- [Execution] -----

    # Authenticate to Microsoft Graph.
    #Write-Verbose -Verbose -Message "Connecting to Microsoft Graph..."
    #$AccessToken = Auth-MSGraph

    # Import all Device Configuration policies to Microsoft Graph as JSON.
    Write-Verbose -Verbose -Message "Importing JSON from '$FilePath'..."
    $DeviceConfigurationPolicies = Get-Content -Raw -Path $FilePath


    # URI for creating Device configuration policies.
    $GraphUri = 'https://graph.microsoft.com/Beta/deviceManagement/deviceConfigurations'


    $DeviceConfigurationPolicies = $DeviceConfigurationPolicies | ConvertFrom-Json

    foreach ($Policy in $DeviceConfigurationPolicies) {
        Start-Sleep -Seconds 1
        Write-Verbose -Verbose -Message "Creating '$($Policy.DisplayName)'..."

        try {
            # Create new policies.
            Invoke-MsGraphQuery -AccessToken $AccessToken -GraphMethod 'POST' -GraphUri $GraphUri -GraphBody ($Policy | ConvertTo-Json -Depth 10) | Out-Null
        }
        catch {
            Write-Error -Message $_.Exception.Message -ErrorAction Continue
        }
    }


    Write-Verbose -Verbose -Message "Done!"


}