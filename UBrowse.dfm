object frmBrowse: TfrmBrowse
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ROM Palette Browser'
  ClientHeight = 531
  ClientWidth = 409
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lblOffset1: TLabel
    Left = 8
    Top = 10
    Width = 30
    Height = 10
    Caption = '000000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object lblOffset2: TLabel
    Left = 8
    Top = 138
    Width = 30
    Height = 10
    Caption = '000000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object lblOffset3: TLabel
    Left = 8
    Top = 266
    Width = 30
    Height = 10
    Caption = '000000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object lblOffset4: TLabel
    Left = 8
    Top = 394
    Width = 30
    Height = 10
    Caption = '000000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object lblOffset5: TLabel
    Left = 8
    Top = 512
    Width = 30
    Height = 10
    Caption = '000000'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object lblAddress: TLabel
    Left = 328
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Address (hex)'
  end
  object shpColour: TShape
    Left = 328
    Top = 56
    Width = 73
    Height = 105
  end
  object lblNotValid: TLabel
    Left = 344
    Top = 64
    Width = 41
    Height = 48
    Alignment = taCenter
    Caption = 'Not a valid palette'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object shpScroller: TShape
    Left = 304
    Top = 10
    Width = 16
    Height = 512
    Pen.Color = cl3DDkShadow
    OnMouseDown = shpScrollerMouseDown
    OnMouseMove = shpScrollerMouseMove
    OnMouseUp = shpScrollerMouseUp
  end
  object shpPos: TShape
    Left = 304
    Top = 10
    Width = 16
    Height = 1
    Pen.Color = clRed
  end
  object edPickOffset: TEdit
    Left = 328
    Top = 24
    Width = 57
    Height = 24
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = '000000'
  end
  object edColour: TEdit
    Left = 336
    Top = 128
    Width = 57
    Height = 24
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = '0000'
  end
end
