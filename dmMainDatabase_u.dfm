object dmMainDatabase: TdmMainDatabase
  OnCreate = DataModuleCreate
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object conMainDatabase: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Janko Skool\Gr. ' +
      '11\Kw. 3\IT\ChefGPT\Database\MainDatabase.mdb;Mode=ReadWrite;Per' +
      'sist Security Info=False;'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 136
    Top = 320
  end
  object tblSavedRecipes: TADOTable
    Connection = conMainDatabase
    CursorType = ctStatic
    TableName = 'SavedRecipes'
    Left = 264
    Top = 224
  end
  object dsSavedRecipes: TDataSource
    DataSet = tblSavedRecipes
    Left = 384
    Top = 224
  end
  object dsProfile: TDataSource
    DataSet = tblProfile
    Left = 384
    Top = 312
  end
  object tblProfile: TADOTable
    Connection = conMainDatabase
    TableName = 'Profile'
    Left = 264
    Top = 312
  end
  object dsIngredients: TDataSource
    DataSet = tblIngredients
    Left = 384
    Top = 408
  end
  object tblIngredients: TADOTable
    Connection = conMainDatabase
    TableName = 'Ingredients'
    Left = 264
    Top = 408
  end
end
