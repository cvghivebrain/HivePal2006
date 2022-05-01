object Form1: TForm1
  Left = 196
  Top = 115
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HivePal Beta by Hivebrain'
  ClientHeight = 312
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000000200000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000FF0FF0770CC000000000000000000000FF0FF0770CC000000000000000
    00000000000000000000000000000000000000CC0880770FF000000000000000
    000000CC0880770FF00000000000000000000000000000000000000000000000
    000000FF0550880FF000000000000000000000FF0550880FF000000000000000
    00000000000000000000000000000000000000770770FF055000000000000000
    000000770770FF05500000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8003FFFF8003FFFF80
    03FFFF8003FFFF8003FFFF8003FFFF8003FFFF8003FFFF8003FFFF8003FFFF80
    03FFFF8003FFFF8003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000010004000000
    0000800000000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    000000000000000000000000000000FF0FF0770CC00000FF0FF0770CC0000000
    00000000000000CC0880770FF00000CC0880770FF000000000000000000000FF
    0550880FF00000FF0550880FF000000000000000000000770770FF0550000077
    0770FF05500000000000000000000000000000000000FFFF0000FFFF00008003
    0000800300008003000080030000800300008003000080030000800300008003
    000080030000800300008003000080030000FFFF0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PalBars: TPaintBox
    Left = 8
    Top = 152
    Width = 241
    Height = 105
    Cursor = crHandPoint
    OnMouseDown = PalBarsMouseDown
    OnPaint = PalBarsPaint
  end
  object PalMenu: TPaintBox
    Left = 8
    Top = 8
    Width = 321
    Height = 137
    OnDblClick = PalMenuDblClick
    OnMouseDown = PalMenuMouseDown
    OnPaint = PalMenuPaint
  end
  object PalPick1: TShape
    Left = 16
    Top = 160
    Width = 41
    Height = 41
    Brush.Style = bsClear
    Pen.Color = clLime
    Pen.Width = 2
  end
  object PalPick2: TShape
    Left = 64
    Top = 160
    Width = 41
    Height = 41
    Brush.Style = bsClear
    Pen.Color = 33023
    Pen.Width = 2
  end
  object PalPick3: TShape
    Left = 112
    Top = 160
    Width = 41
    Height = 41
    Brush.Style = bsClear
    Pen.Color = clYellow
    Pen.Width = 2
  end
  object lblLen: TLabel
    Left = 8
    Top = 264
    Width = 82
    Height = 13
    Caption = 'Length (hex/dec)'
  end
  object shpColour: TShape
    Left = 256
    Top = 152
    Width = 73
    Height = 105
    Cursor = crHandPoint
    Brush.Color = clBlack
    OnMouseDown = shpColourMouseDown
  end
  object btnLoad: TButton
    Left = 240
    Top = 264
    Width = 81
    Height = 41
    Caption = 'Load ROM'
    TabOrder = 0
    OnClick = btnLoadClick
  end
  object btnGet: TButton
    Left = 328
    Top = 264
    Width = 81
    Height = 41
    Caption = 'Get Palette From ROM'
    TabOrder = 1
    WordWrap = True
    OnClick = btnGetClick
  end
  object edOffset: TLabeledEdit
    Left = 112
    Top = 280
    Width = 113
    Height = 24
    EditLabel.Width = 64
    EditLabel.Height = 13
    EditLabel.Caption = 'Address (hex)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    MaxLength = 6
    ParentFont = False
    TabOrder = 2
    Text = '0'
    OnKeyPress = edOffsetKeyPress
  end
  object edLenH: TEdit
    Left = 8
    Top = 280
    Width = 41
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    MaxLength = 2
    ParentFont = False
    TabOrder = 3
    Text = '10'
    OnChange = edLenHChange
    OnKeyPress = edLenHKeyPress
  end
  object edLenD: TEdit
    Left = 56
    Top = 280
    Width = 41
    Height = 24
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    MaxLength = 2
    ParentFont = False
    TabOrder = 4
    Text = '16'
  end
  object edValue: TEdit
    Left = 264
    Top = 224
    Width = 57
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    MaxLength = 4
    ParentFont = False
    TabOrder = 5
    Text = '0000'
    OnChange = edValueChange
    OnClick = edValueClick
    OnKeyPress = edValueKeyPress
  end
  object btnSave: TButton
    Left = 416
    Top = 264
    Width = 81
    Height = 41
    Caption = 'Save Palette To ROM'
    TabOrder = 6
    WordWrap = True
    OnClick = btnSaveClick
  end
  object lstOffset: TListBox
    Left = 336
    Top = 8
    Width = 241
    Height = 249
    ItemHeight = 13
    TabOrder = 7
    OnClick = lstOffsetClick
  end
  object lstOff1: TListBox
    Left = 360
    Top = 48
    Width = 73
    Height = 113
    ItemHeight = 13
    TabOrder = 8
    Visible = False
  end
  object lstOff2: TListBox
    Left = 440
    Top = 48
    Width = 73
    Height = 113
    ItemHeight = 13
    TabOrder = 9
    Visible = False
  end
  object btnBrowse: TButton
    Left = 504
    Top = 264
    Width = 73
    Height = 41
    Caption = 'Browse For Palettes'
    TabOrder = 10
    WordWrap = True
    OnClick = btnBrowseClick
  end
  object dlgOpen: TOpenDialog
    Filter = 'Mega Drive ROMs (*.bin)|*.bin'
    Left = 160
    Top = 160
  end
end
