object fmLoading: TfmLoading
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 100
  ClientWidth = 215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlBevel: TPanel
    Left = 0
    Top = 0
    Width = 215
    Height = 100
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 27
    ExplicitTop = 64
    ExplicitWidth = 185
    ExplicitHeight = 41
    object pnlLoading: TPanel
      Left = 1
      Top = 1
      Width = 213
      Height = 69
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Loading...'
      Color = 4267268
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -23
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleName = 'Windows'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 212
      ExplicitHeight = 92
    end
    object pnlSub: TPanel
      Left = 1
      Top = 70
      Width = 213
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Please Wait a While'
      Color = 4267268
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      StyleName = 'Windows'
      ExplicitLeft = 0
      ExplicitTop = 92
      ExplicitWidth = 212
    end
  end
end
