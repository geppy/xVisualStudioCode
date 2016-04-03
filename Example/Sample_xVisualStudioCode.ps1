Configuration Sample_xVisualStudioCode {
  Import-DscResource -Module xVisualStudioCode;
  
  geppy_xVisualStudioCode VisualStudioCode {
    UserSettings = @{
      'editor.insertSpaces' = $True;
      'editor.tabSize' = 2;
      'files.autoSave' = 'onFocusChange';
      'files.eol' = "`n";
    };
    MatchSource = $False;
  }
}
