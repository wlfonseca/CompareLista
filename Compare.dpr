program Compare;

uses
  Vcl.Forms,
  UCompare in 'UCompare.pas' {FrmCompare},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Compare';
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TFrmCompare, FrmCompare);
  Application.Run;
end.
