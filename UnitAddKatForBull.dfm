object FormAddKat: TFormAddKat
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
  ClientHeight = 377
  ClientWidth = 671
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 144
    Width = 21
    Height = 16
    Caption = #1043#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 224
    Top = 144
    Width = 60
    Height = 16
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblHoz: TLabel
    Left = 40
    Top = 8
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblKlichka: TLabel
    Left = 40
    Top = 48
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLine: TLabel
    Left = 40
    Top = 94
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblDrb: TLabel
    Left = 280
    Top = 94
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblInvNum: TLabel
    Left = 164
    Top = 50
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 40
    Top = 216
    Width = 133
    Height = 16
    Caption = #1047#1072#1087#1072#1089' '#1089#1077#1084#1077#1085#1080', '#1090#1099#1089'.'#1076#1086#1079
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 224
    Top = 216
    Width = 134
    Height = 16
    Caption = #1062#1077#1085#1072' '#1086#1076#1085#1086#1081' '#1076#1086#1079#1099', '#1088#1091#1073'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 448
    Top = 144
    Width = 89
    Height = 16
    Caption = #1055#1086#1088#1086#1076#1072' '#1076#1086#1095#1077#1088#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object cbCategory: TComboBox
    Left = 224
    Top = 166
    Width = 185
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnSelect = cbCategorySelect
  end
  object cbYear: TComboBox
    Left = 40
    Top = 166
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      '2010'
      '2011'
      '2012'
      '2013'
      '2014'
      '2015'
      '2016'
      '2017'
      '2018'
      '2019'
      '2020'
      '2021'
      '2022'
      '2023'
      '2024'
      '2025'
      '2026'
      '2027'
      '2028'
      '2029'
      '2030')
  end
  object btnSave: TButton
    Left = 321
    Top = 312
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object edtSperm: TEdit
    Left = 40
    Top = 238
    Width = 145
    Height = 21
    TabOrder = 3
    OnExit = edtSpermExit
    OnKeyPress = edtSpermKeyPress
  end
  object edtCena: TEdit
    Left = 224
    Top = 238
    Width = 185
    Height = 21
    TabOrder = 4
    OnExit = edtSpermExit
    OnKeyPress = edtSpermKeyPress
  end
  object cbPorDaughter: TComboBox
    Left = 448
    Top = 166
    Width = 185
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnSelect = cbPorDaughterSelect
  end
end
