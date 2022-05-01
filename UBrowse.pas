unit UBrowse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmBrowse = class(TForm)
    lblOffset1: TLabel;
    lblOffset2: TLabel;
    lblOffset3: TLabel;
    lblOffset4: TLabel;
    lblOffset5: TLabel;
    lblAddress: TLabel;
    edPickOffset: TEdit;
    shpColour: TShape;
    edColour: TEdit;
    lblNotValid: TLabel;
    shpScroller: TShape;
    shpPos: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpScrollerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpScrollerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shpScrollerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Bitmap: TBitmap;
    procedure Plot(X, Y, Color: Integer);
    procedure DrawPic;
    procedure RomToPic;
  public
    { Public declarations }
  end;

var
  frmBrowse: TfrmBrowse;
  RomPos, stepsize: integer;
  w: word;
  scrolldrag: boolean;

implementation

uses UHivePal;

{$R *.dfm}

function ColorToRGBQuad(Color: TColor): TRGBQuad;
asm
// INPUT:  EAX = Color
// OUTPUT: EAX = RGBQuad
  or        eax,eax
  jns       @1
  and       eax,$FF
  push      eax
  call      Windows.GetSysColor  // perform "ColorToRGB"
@1:
  bswap     eax
  mov       al,$FF            // set "Reserved" / Alpha part of RGBQuad to 255
  ror       eax,8
end;


procedure TfrmBrowse.Plot(X, Y, Color: Integer);
var
  Pixel: PRGBQuad;
begin
  // no range checks here to improve speed, so Bitmap should be initialized
  // and X, Y must be valid coordinates
  Pixel := Bitmap.ScanLine[Y];
  Inc(Pixel, X);
  Pixel^ := TRGBQuad(ColorToRGBQuad(Color));
end;


procedure TfrmBrowse.FormCreate(Sender: TObject);
begin
  if (HexToInt(Form1.edOffset.Text) < Form1.myFile.Size) and
    (HexToInt(Form1.edOffset.Text) mod 2 = 0) then
    Form1.myFile.Position := HexToInt(Form1.edOffset.Text)
  else Form1.myFile.Position := 0;
  RomPos := Form1.myFile.Position;
  stepsize := Form1.myFile.Size div $8000;
  // create DIB
  FreeAndNil(Bitmap);
  Bitmap := TBitmap.Create;
  Bitmap.Width := 32;
  Bitmap.Height := 64;
  Bitmap.PixelFormat := pf32bit;

RomToPic;
lblOffset1.Caption := IntToHex(RomPos, 6);
lblOffset2.Caption := IntToHex(RomPos+$400, 6);
lblOffset3.Caption := IntToHex(RomPos+$800, 6);
lblOffset4.Caption := IntToHex(RomPos+$C00, 6);
lblOffset5.Caption := IntToHex(RomPos+$FC0, 6);

Invalidate;
end;


procedure TfrmBrowse.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Bitmap);
end;


procedure TfrmBrowse.FormPaint(Sender: TObject);
begin
DrawPic;
end;

procedure TfrmBrowse.DrawPic;
begin
  StretchBlt(
    Canvas.Handle,
    42,
    10,
    Bitmap.Width * 8,
    Bitmap.Height * 8,
    Bitmap.Canvas.Handle,
    0,
    0,
    Bitmap.Width,
    Bitmap.Height,
    SRCCOPY
  );
end;


procedure TfrmBrowse.RomToPic;
var
  x, y: Integer;
  w: Word;
begin

for y := 0 to Bitmap.Height - 1 do
  begin
  for x := 0 to Bitmap.Width - 1 do
    begin
    Plot(x, y, clBtnFace);
    end;
  end;

for y := 0 to Bitmap.Height - 1 do
  begin
  for x := 0 to Bitmap.Width - 1 do
    begin
    if Form1.myFile.Position < Form1.myFile.Size then
      begin
      Form1.myFile.ReadBuffer(w, SizeOf(w));
      w := Swap(w);
      if (w and $F111 > 0) then Plot(x, y, $FFFFFF)
      else Plot(x, y, MdToPal(w));
      end;
    end;
  end;

end;


procedure TfrmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;


procedure TfrmBrowse.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Form1.myFile.Size > $1000) and (RomPos < Form1.myFile.Size) then
  begin
  case key of
    VK_DOWN:
      begin
      if RomPos < (Form1.myFile.Size-$1000) then
        Form1.myFile.Position := RomPos+$40
      else Form1.myFile.Position := Form1.myFile.Size-$1000;
      end;
    VK_UP:
      begin
      if RomPos < $40 then Form1.myFile.Position := 0
      else Form1.myFile.Position := RomPos-$40;
      end;
    VK_RIGHT:
      begin
      Form1.myFile.Position := RomPos+2;
      end;
    VK_LEFT:
      begin
      if RomPos > 0 then Form1.myFile.Position := RomPos-2;
      end;
    VK_PRIOR:
      begin
      if RomPos < $800 then Form1.myFile.Position := 0
      else Form1.myFile.Position := RomPos-$800;
      end;
    VK_NEXT:
      begin
      if RomPos < (Form1.myFile.Size-$1000) then
        Form1.myFile.Position := RomPos+$800
      else Form1.myFile.Position := Form1.myFile.Size-$1000;
      end;
    VK_HOME:
      begin
      Form1.myFile.Position := 0;
      end;
    VK_END:
      begin
      Form1.myFile.Position := Form1.myFile.Size-$1000;
      end;
    end;
  end
else Form1.myFile.Position := 0;
RomPos := Form1.myFile.Position;
RomToPic;
DrawPic;
lblOffset1.Caption := IntToHex(RomPos, 6);
lblOffset2.Caption := IntToHex(RomPos+$400, 6);
lblOffset3.Caption := IntToHex(RomPos+$800, 6);
lblOffset4.Caption := IntToHex(RomPos+$C00, 6);
lblOffset5.Caption := IntToHex(RomPos+$FC0, 6);
shpPos.Top := (RomPos div (stepsize*$40)) + 10;
end;


procedure TfrmBrowse.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var PickOffset: integer;
begin
if (X>=42) and (X<298) and (Y>=10) and (Y<522) then
  begin
  PickOffset := (((X-42) div 8)*2) + (((Y-10) div 8)*$40);  //get hex address
  edPickOffset.Text := IntToHex(PickOffset+RomPos, 6);      //display address
  Form1.myFile.Position := PickOffset+RomPos;       //jump to address
  Form1.myFile.ReadBuffer(w, SizeOf(w));            //read palette entry
  w := Swap(w);
  Form1.myFile.Position := RomPos;                  //return to previous address
  if (w and $F111 > 0) then
    begin
    shpColour.Brush.Color := clWhite;
    lblNotValid.Visible := true;
    end
  else
    begin
    shpColour.Brush.Color := MdToPal(w);
    lblNotValid.Visible := false;
    end;
  end;
edColour.Text := IntToHex(w, 4);
end;


procedure TfrmBrowse.shpScrollerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (Form1.myFile.Size > $1000) and (RomPos < Form1.myFile.Size) then
  begin
  scrolldrag := true;
  shpPos.Top := Y+10;
  Form1.myFile.Position := Y * stepsize * $40;
  if Form1.myFile.Position > Form1.myFile.Size-$1000 then
    Form1.myFile.Position := Form1.myFile.Size-$1000;
  RomPos := Form1.myFile.Position;
  RomToPic;
  DrawPic;
  lblOffset1.Caption := IntToHex(RomPos, 6);
  lblOffset2.Caption := IntToHex(RomPos+$400, 6);
  lblOffset3.Caption := IntToHex(RomPos+$800, 6);
  lblOffset4.Caption := IntToHex(RomPos+$C00, 6);
  lblOffset5.Caption := IntToHex(RomPos+$FC0, 6);
  end
else Form1.myFile.Position := 0;
end;

procedure TfrmBrowse.shpScrollerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
if (scrolldrag = true) and (X>=0) and (Y>=0) and (X<16) and (Y<512) then
  begin
  shpPos.Top := Y+10;
  Form1.myFile.Position := Y * stepsize * $40;
  if Form1.myFile.Position > Form1.myFile.Size-$1000 then
    Form1.myFile.Position := Form1.myFile.Size-$1000;
  RomPos := Form1.myFile.Position;
  RomToPic;
  DrawPic;
  lblOffset1.Caption := IntToHex(RomPos, 6);
  lblOffset2.Caption := IntToHex(RomPos+$400, 6);
  lblOffset3.Caption := IntToHex(RomPos+$800, 6);
  lblOffset4.Caption := IntToHex(RomPos+$C00, 6);
  lblOffset5.Caption := IntToHex(RomPos+$FC0, 6);
  end;
end;

procedure TfrmBrowse.shpScrollerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
scrolldrag := false;
end;

end.
