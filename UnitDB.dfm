object DataMdl: TDataMdl
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 331
  Width = 475
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    OnWillConnect = ADOConnection1WillConnect
    Left = 48
    Top = 32
  end
  object ADOQueryBull: TADOQuery
    Parameters = <>
    Left = 160
    Top = 32
  end
  object ADOQuerySprav: TADOQuery
    Parameters = <>
    Left = 256
    Top = 32
  end
  object DataSourceBull: TDataSource
    Left = 152
    Top = 96
  end
  object ADOQueryEdit: TADOQuery
    Parameters = <>
    Left = 344
    Top = 32
  end
  object DataSourceCategory: TDataSource
    Left = 256
    Top = 96
  end
  object ADOQueryCategory: TADOQuery
    Parameters = <>
    Left = 40
    Top = 96
  end
  object DataSourceSprav: TDataSource
    Left = 368
    Top = 96
  end
  object ADOQueryOpt: TADOQuery
    Parameters = <>
    Left = 32
    Top = 160
  end
  object ADOQueryTables: TADOQuery
    Parameters = <>
    Left = 120
    Top = 160
  end
  object ADOQuerySprSost: TADOQuery
    Parameters = <>
    Left = 216
    Top = 160
  end
end
