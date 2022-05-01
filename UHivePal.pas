unit UHivePal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, UAllColours, UBrowse;

type
  TForm1 = class(TForm)
    PalBars: TPaintBox;
    PalMenu: TPaintBox;
    PalPick1: TShape;
    PalPick2: TShape;
    PalPick3: TShape;
    btnLoad: TButton;
    btnGet: TButton;
    edOffset: TLabeledEdit;
    edLenH: TEdit;
    edLenD: TEdit;
    lblLen: TLabel;
    dlgOpen: TOpenDialog;
    edValue: TEdit;
    shpColour: TShape;
    btnSave: TButton;
    lstOffset: TListBox;
    lstOff1: TListBox;
    lstOff2: TListBox;
    btnBrowse: TButton;
    procedure PalBarsPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PalMenuPaint(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure PalMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PalBarsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edLenHKeyPress(Sender: TObject; var Key: Char);
    procedure edLenHChange(Sender: TObject);
    procedure edOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstOffsetClick(Sender: TObject);
    procedure shpColourMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnBrowseClick(Sender: TObject);
    procedure PalMenuDblClick(Sender: TObject);
    procedure edValueKeyPress(Sender: TObject; var Key: Char);
    procedure edValueChange(Sender: TObject);
    procedure edValueClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoBars;
    procedure CleanPal;
    function Serial(): string;
  public
    Parray: array[0..63] of word;   //palette array - 64 colours
    Carray: array[0..15] of word;   //copy buffer - 16 colours
    Pindex: integer;                //current selected palette entry index number
    myFile: TFileStream;            //ROM file
    { Public declarations }
    procedure DoMenu;
    procedure DoPickers; 
  end;

var
  Form1: TForm1;
  palsize: integer;             //size of palette (in colours)
  progdir: string;              //location of EXE

  function MdToPal(col: word): integer;
  function HexToInt(hexstr: string): integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
progdir := ExtractFilePath(ParamStr(0));
CleanPal;
DoBars;
PalPick1.Height := PalBars.Height div 3;  //draw colour bar selectors
PalPick2.Height := PalPick1.Height;
PalPick3.Height := PalPick1.Height;
PalPick1.Width := PalBars.Width div 8;
PalPick2.Width := PalPick1.Width;
PalPick3.Width := PalPick1.Width;
PalPick1.Top := PalBars.Top;
PalPick2.Top := PalPick1.Top + (PalBars.Height div 3);
PalPick3.Top := PalPick2.Top + (PalBars.Height div 3);
PalPick1.Left := PalBars.Left;
PalPick2.Left := PalBars.Left;
PalPick3.Left := PalBars.Left;
Pindex := 0;
end;

procedure TForm1.PalBarsPaint(Sender: TObject);
begin
DoBars;
end;

procedure TForm1.DoBars;    //draw colour bars
var kount, ht, wd: integer;
begin
wd := PalBars.Width div 8;
ht := PalBars.Height div 3;
for kount := 0 to 7 do
  begin
  PalBars.Canvas.Pen.Color := $20 * kount; //red
  PalBars.Canvas.Brush.Color := PalBars.Canvas.Pen.Color;
  PalBars.Canvas.Rectangle(kount*wd, 0, (kount*wd)+wd, ht);
  end;
for kount := 0 to 7 do
  begin
  PalBars.Canvas.Pen.Color := $2000 * kount; //green
  PalBars.Canvas.Brush.Color := PalBars.Canvas.Pen.Color;
  PalBars.Canvas.Rectangle(kount*wd, ht, (kount*wd)+wd, ht*2);
  end;
for kount := 0 to 7 do
  begin
  PalBars.Canvas.Pen.Color := $200000 * kount; //blue
  PalBars.Canvas.Brush.Color := PalBars.Canvas.Pen.Color;
  PalBars.Canvas.Rectangle(kount*wd, ht*2, (kount*wd)+wd, ht*3);
  end;
end;

procedure TForm1.PalMenuPaint(Sender: TObject);
begin
DoMenu;
end;

procedure TForm1.DoMenu;    //draw palette menu
var yk, xk, wd, ht: integer;
begin
wd := PalMenu.Width div 16;
ht := PalMenu.Height div 4;
PalMenu.Canvas.Brush.Color := Form1.Color;
PalMenu.Canvas.FillRect(PalMenu.ClientRect);
for yk := 0 to 3 do
  begin
  for xk := 0 to 15 do
    begin
    if Parray[xk+(yk*16)] = $FFFF then PalMenu.Canvas.Pen.Color := Form1.Color
    else PalMenu.Canvas.Pen.Color := MdToPal(Parray[xk+(yk*16)]);
    PalMenu.Canvas.Brush.Color := PalMenu.Canvas.Pen.Color;
    PalMenu.Canvas.Rectangle(xk*wd, yk*ht, (xk*wd)+wd, (yk*ht)+ht);
    end;
  end;
PalMenu.Canvas.Pen.Color := clWhite;
PalMenu.Canvas.Pen.Width := 2;
PalMenu.Canvas.Brush.Style := bsClear;
PalMenu.Canvas.Rectangle((Pindex and $F)*wd, (Pindex shr 4)*ht, ((Pindex and $F)*wd)+wd, ((Pindex shr 4)*ht)+ht);
end;

function MdToPal(col: word): integer;
var b, g, r: byte;
begin
b := hi(col);
b := b shl 4;
g := lo(col) and $F0;
r := lo(col) and $F;
r := r shl 4;
Result := r + (g*$100) + (b*$10000);
end;

procedure TForm1.btnLoadClick(Sender: TObject);
var
  s: string;
  posn: integer;
  myList: textfile;
begin
if dlgOpen.Execute then
  begin
  CleanPal;
  Pindex := 0;
  DoMenu;
  lstOffset.Clear;
  lstOff1.Clear;
  lstOff2.Clear;
  edOffset.Text := '0';
  FreeAndNil(myFile);
  myFile := TFileStream.Create(dlgOpen.FileName,
      fmOpenReadWrite or fmShareExclusive);
  if Serial() <> '' then
    begin
    AssignFile(myList, progdir+'Data\'+Serial());
    Reset(myList);
    while not eof(myList) do
      begin
      ReadLn(myList, s);
      posn := pos('|', s);
      if posn > 0 then lstOff1.Items.Add(copy(s, 1, posn-1));
      delete(s, 1, posn);
      posn := pos('|', s);
      if posn > 0 then lstOff2.Items.Add(copy(s, 1, posn-1));
      delete(s, 1, posn);
      lstOffset.Items.Add(s);
      end;
    CloseFile(myList);
    end;
  end;
end;

function TForm1.Serial(): string;
var
  kount, b: byte;
  ser, s, ser2: string;
  myRoms: textfile;
  posn: integer;
begin
Result := '';
ser := '';
if Assigned(myFile) and (myFile.Size > $200) then
  try
  myFile.Position := $180;
  for kount := 1 to $E do
    begin
    myFile.ReadBuffer(b, 1);
    ser := ser + IntToHex(b, 2);
    end;
  AssignFile(myRoms, progdir+'Data\ROMs.def');  //open ROM defs file
  Reset(myRoms);
  while not eof(myRoms) do
    begin
    ReadLn(myRoms, s);                      //read line from file
    posn := pos('|', s);
    if posn > 0 then
      begin
      ser2 := copy(s, 1, posn-1);           //get serial string
      if ser = ser2 then                    //compare string to ROM serial
        begin
        delete(s, 1, posn);
        Result := s;                        //set pal script file
        end;
      end;
    end;
  finally
  CloseFile(myRoms);
  end;
if Result = 'Sonic1J.Pal' then              //check if S1 Japan
  begin
  myFile.Position := $16F;
  myFile.ReadBuffer(b, 1);
  if b = $32 then Result := 'Sonic2b.Pal';  //change if ROM is S2Beta
  end;
end;

procedure TForm1.btnGetClick(Sender: TObject);
var
  kount: integer;
  b1, b2: byte;
begin
if Assigned(myFile) then
  begin
  Pindex := 0;
  if edLenD.Text = '' then palsize := 0
  else if edLenD.Text = '0' then palsize := 0
  else palsize := StrToInt(edLenD.Text) - 1;
  if myFile.Size >= HexToInt(edOffset.Text) + ((palsize+1)*2) then
    begin
    CleanPal;
    myFile.Position := HexToInt(edOffset.Text);
    for kount := 0 to palsize do
      begin
      myFile.Read(b1, 1);   //read palette entry from file
      myFile.Read(b2, 1);
      Parray[kount] := (b1*$100) + b2;
      end;
    DoMenu;
    DoPickers;
    end
  else MessageDlg('Invalid address or palette length!', mtError, [mbOK], 0);
  end;
end;

procedure TForm1.DoPickers;
var b, g, r: byte;
begin
b := hi(Parray[Pindex]);
g := lo(Parray[Pindex]) shr 4;
r := lo(Parray[Pindex]) and $F;
PalPick3.Left := PalBars.Left + ((PalBars.Width div 8)*(b div 2));
PalPick2.Left := PalBars.Left + ((PalBars.Width div 8)*(g div 2));
PalPick1.Left := PalBars.Left + ((PalBars.Width div 8)*(r div 2));
shpColour.Brush.Color := MdToPal(Parray[Pindex]);
end;

function HexToInt(hexstr: string): integer;
begin
if hexstr = '' then Result := 0
else Result := StrToInt('$'+hexstr);  //convert hex string to integer
end;

procedure TForm1.CleanPal;
var kount: integer;
begin
for kount := 0 to 63 do
  Parray[kount] := $FFFF;   //empty palette array
end;

procedure TForm1.PalMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pclick, wd, ht, kount: integer;
begin
if Button = mbLeft then         //left click - normal palette select
  begin
  wd := PalMenu.Width div 16;
  ht := PalMenu.Height div 4;
  pclick := (X div wd) + ((Y div ht) * 16);
  if (pclick <= palsize) and (palsize <> 0) then
    begin
    Pindex := pclick;
    DoPickers;
    edValue.Text := IntToHex(Parray[Pindex], 4);
    DoMenu;
    end;
  end
else if Button = mbRight then   //right click - copy palette
  begin
  wd := PalMenu.Width div 16;
  ht := PalMenu.Height div 4;
  pclick := (X div wd) + ((Y div ht) * 16);
  if (pclick <= palsize) and (palsize <> 0) and (pclick >= Pindex)
    and ((pclick-Pindex) < 16) then
    begin
    for kount := 0 to 15 do
      begin
      Carray[kount] := $FFFF;   //clear copy buffer
      end;
    for kount := 0 to (pclick-Pindex) do
      begin
      Carray[kount] := Parray[Pindex+kount];    //copy selection to buffer
      end;
    for kount := 0 to 15 do
      begin
      if Carray[kount] = $FFFF then Form1.Canvas.Pen.Color := Form1.Color
      else Form1.Canvas.Pen.Color := MdToPal(Carray[kount]);
      Form1.Canvas.Brush.Color := Form1.Canvas.Pen.Color;
      Form1.Canvas.Rectangle(kount*7, 0, (kount*7)+7, 7);
      end;
    end;
  end;
end;

procedure TForm1.PalBarsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var wd, ht: integer;
begin
wd := PalBars.Width div 8;
ht := PalBars.Height div 3;
if (Y div ht = 0) and (Parray[Pindex] <> $FFFF) then
  begin
  Parray[Pindex] := Parray[Pindex] and $0FF0;
  Parray[Pindex] := Parray[Pindex] + ((X div wd)*2);
  PalPick1.Left := PalBars.Left + ((X div wd)*wd);
  edValue.Text := IntToHex(Parray[Pindex], 4);
  shpColour.Brush.Color := MdToPal(Parray[Pindex]);
  end
else if (Y div ht = 1) and (Parray[Pindex] <> $FFFF) then
  begin
  Parray[Pindex] := Parray[Pindex] and $0F0F;
  Parray[Pindex] := Parray[Pindex] + ((X div wd)*$20);
  PalPick2.Left := PalBars.Left + ((X div wd)*wd);
  edValue.Text := IntToHex(Parray[Pindex], 4);
  shpColour.Brush.Color := MdToPal(Parray[Pindex]);
  end
else if (Y div ht = 2) and (Parray[Pindex] <> $FFFF) then
  begin
  Parray[Pindex] := Parray[Pindex] and $00FF;
  Parray[Pindex] := Parray[Pindex] + ((X div wd)*$200);
  PalPick3.Left := PalBars.Left + ((X div wd)*wd);
  edValue.Text := IntToHex(Parray[Pindex], 4);
  shpColour.Brush.Color := MdToPal(Parray[Pindex]);
  end;
DoMenu;
end;

procedure TForm1.edLenHKeyPress(Sender: TObject; var Key: Char);
begin
case key of
  '0'..'9', 'a'..'f', 'A'..'F', #8: ;   //allow hex nums & backspace
else key := #0;                         //else do nothing
end;
end;

procedure TForm1.edLenHChange(Sender: TObject);
var mylen: integer;
begin
if HexToInt(edLenH.Text) > $40 then edLenH.Text := '40';
mylen := HexToInt(edLenH.Text);
edLenD.Text := IntToStr(mylen);
end;

procedure TForm1.edOffsetKeyPress(Sender: TObject; var Key: Char);
begin
case key of
  '0'..'9', 'a'..'f', 'A'..'F', #8: ;   //allow hex nums & backspace
else key := #0;                         //else do nothing
end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
var kount, b1, b2: integer;
begin
if Assigned(myFile) then
  try
  myFile.Position := HexToInt(edOffset.Text);
  for kount := 0 to palsize do
    begin
    b1 := hi(Parray[kount]);
    b2 := lo(Parray[kount]);
    myFile.Write(b1, 1);
    myFile.Write(b2, 1);
    end;
  finally
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FreeAndNil(myFile);
end;

procedure TForm1.lstOffsetClick(Sender: TObject);
var
  lin, kount: integer;
  b1, b2, b, g, r: byte;
begin
lin := lstOffset.ItemIndex;
edOffset.Text := lstOff1.Items[lin];
edLenH.Text := lstOff2.Items[lin];
Pindex := 0;
if edLenD.Text = '' then palsize := 0
else if edLenD.Text = '0' then palsize := 0
else palsize := StrToInt(edLenD.Text) - 1;
CleanPal;
myFile.Position := HexToInt(edOffset.Text);
for kount := 0 to palsize do
  begin
  myFile.Read(b1, 1);   //read palette entry from file
  myFile.Read(b2, 1);
  Parray[kount] := (b1*$100) + b2;
  end;
DoMenu;
b := hi(Parray[Pindex]);
g := lo(Parray[Pindex]) shr 4;
r := lo(Parray[Pindex]) and $F;
PalPick3.Left := PalBars.Left + ((PalBars.Width div 8)*(b div 2));
PalPick2.Left := PalBars.Left + ((PalBars.Width div 8)*(g div 2));
PalPick1.Left := PalBars.Left + ((PalBars.Width div 8)*(r div 2));
edValue.Text := IntToHex(Parray[Pindex], 4);
shpColour.Brush.Color := MdToPal(Parray[Pindex]);
DoMenu;
end;

procedure TForm1.shpColourMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Form2.ShowModal;
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var newfrm: TfrmBrowse;
begin
if Assigned(myFile) then
  begin
  newfrm := TfrmBrowse.Create(self);
  newfrm.ShowModal;
  end;
end;

procedure TForm1.PalMenuDblClick(Sender: TObject);
var kount1, kount2: integer;
begin
kount1 := 0;
kount2 := Pindex;
while (Carray[kount1] <> $FFFF) and (Parray[kount2] <> $FFFF)
  and (kount1 < 16) and (kount2 < 64) do
  begin
  Parray[kount2] := Carray[kount1];
  inc(kount1);
  inc(kount2);
  DoMenu;
  end;
end;

procedure TForm1.edValueKeyPress(Sender: TObject; var Key: Char);
begin
case key of
  '0', '2', '4', '6', '8',
  'a', 'c', 'e', 'A', 'C', 'E', #8: ;   //allow hex nums & backspace
else key := #0;                         //else do nothing
end;
Parray[Pindex] := HexToInt(edValue.Text);
DoMenu;
DoPickers;
end;

procedure TForm1.edValueChange(Sender: TObject);
begin
if Length(edValue.Text) = 3 then edValue.Text := ('0'+edValue.Text);
end;

procedure TForm1.edValueClick(Sender: TObject);
begin
edValue.Text := '';
end;

end.
