unit UAllColours;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm2 = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses UHivePal;

{$R *.dfm}

procedure TForm2.FormPaint(Sender: TObject);
var
  ht, wd, b, g, r, gr: integer;
  col: word;
begin
ht := 24;
wd := 10;
for b := 0 to 7 do
  begin
  for g := 0 to 7 do
    begin
    for r := 0 to 7 do
      begin
      col := (r*2) + (g*$20) + (b*$200);
      gr := r + (g*8);
      Form2.Canvas.Pen.Color := MdToPal(col);
      Form2.Canvas.Brush.Color := Form2.Canvas.Pen.Color;
      Form2.Canvas.Rectangle(gr*wd, b*ht, (gr*wd)+wd, (b*ht)+ht);
      end;
    end;
  end;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ht, wd: integer;
  col: word;
begin
if Assigned(Form1.myFile) then
  begin
  ht := Form2.Height div 9;
  wd := Form2.Width div 64;
  col := ((Y div ht)*$200) + ((X div (wd*8))*$20) + (((X div wd) and 7)*2);
  Form1.Parray[Form1.Pindex] := col;
  Form1.DoMenu;
  Form1.DoPickers;
  Form1.edValue.Text := IntToHex(Form1.Parray[Form1.Pindex], 4);
  Form2.Close;
  end
else Form2.Close;
end;

end.
