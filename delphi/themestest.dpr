program themestest;

uses
  Forms,
  umainform in '..\common\umainform.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

