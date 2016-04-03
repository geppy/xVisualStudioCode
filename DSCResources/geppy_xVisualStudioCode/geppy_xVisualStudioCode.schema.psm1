Configuration geppy_xVisualStudioCode {
  <#
    .SYNOPSIS
    
    Installs and configures Visual Studio Code.
    
    .PARAMETER MatchSource
    
    If false, the installer will not be redownloaded.
    
    .PARAMETER UserSettings
    
    A [HashTable] of VS Code settings.
    
    If provided, this will be used to populate VS Code's 'settings.json'.
  #>
  Param(
    
    [Boolean]$MatchSource = $True,
    [HashTable]$UserSettings = $Null
  );
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration';
  Import-DscResource -ModuleName 'xPSDesiredStateConfiguration';

  xRemoteFile Downloader
  {
    Uri = 'https://go.microsoft.com/fwlink/?LinkID=623230';
    DestinationPath = "${env:tmp}/geppy_vs_code.exe";
    MatchSource = $MatchSource;
  }

  Package Installer {
    Name = 'Microsoft Visual Studio Code';
    Path = "${env:tmp}/geppy_vs_code.exe";
    ProductId = '';
    Arguments = '/silent';
    DependsOn = '[xRemoteFile]Downloader';
  }
  
  if($UserSettings -ne $Null) {
    File SettingsDirectory {
      Ensure = 'Present';
      Type = 'Directory';
      DestinationPath = "${Env:AppData}\Code";
    }
    
    File UserSettingsDirectory {
      Ensure = 'Present';
      Type = 'Directory';
      DestinationPath = "${Env:AppData}\Code\User";
      DependsOn = '[File]SettingsDirectory';
    }
    
    File UserSettings {
      Ensure = 'Present';
      Type = 'File';
      Contents = $UserSettings | ConvertTo-Json;
      DestinationPath = "${Env:AppData}\Code\User\settings.json";
      Force = $True;
      CheckSum = 'SHA-1';
      DependsOn = '[File]UserSettingsDirectory';
    }
  }
}
