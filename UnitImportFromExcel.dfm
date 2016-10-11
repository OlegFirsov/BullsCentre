object FormImportFromExcel: TFormImportFromExcel
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1048#1084#1087#1086#1088#1090' '#1080#1079' Excel'
  ClientHeight = 356
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 81
    Height = 16
    Caption = #1054#1090#1095#1077#1090#1085#1099#1081' '#1075#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnImport: TButton
    Left = 136
    Top = 323
    Width = 75
    Height = 25
    Caption = #1048#1084#1087#1086#1088#1090
    TabOrder = 0
    OnClick = btnImportClick
  end
  object cbYear: TComboBox
    Left = 32
    Top = 30
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 1
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
  object MemoImport: TMemo
    Left = 8
    Top = 57
    Width = 338
    Height = 249
    TabOrder = 2
  end
end
