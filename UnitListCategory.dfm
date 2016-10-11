object FormListCategory: TFormListCategory
  Left = 0
  Top = 0
  Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080
  ClientHeight = 385
  ClientWidth = 675
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
  object lblInvNum: TLabel
    Left = 164
    Top = 50
    Width = 3
    Height = 13
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
  object DBGridCategory: TDBGrid
    Left = 8
    Top = 116
    Width = 659
    Height = 205
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnEdit: TButton
    Left = 8
    Top = 327
    Width = 105
    Height = 25
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '
    TabOrder = 1
    OnClick = btnEditClick
  end
  object btnAdd: TButton
    Left = 119
    Top = 327
    Width = 90
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 215
    Top = 327
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1077#1085#1080#1077
    TabOrder = 3
    OnClick = btnDeleteClick
  end
end
