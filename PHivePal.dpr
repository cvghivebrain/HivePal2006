program PHivePal;

uses
  Forms,
  UHivePal in 'UHivePal.pas' {Form1},
  UAllColours in 'UAllColours.pas' {Form2},
  UBrowse in 'UBrowse.pas' {frmBrowse};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
