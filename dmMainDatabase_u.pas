unit dmMainDatabase_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Dialogs,
  Data.FMTBcd, Data.SqlExpr;

type
  TdmMainDatabase = class(TDataModule)
    conMainDatabase: TADOConnection;
    tblSavedRecipes: TADOTable;
    dsSavedRecipes: TDataSource;
    dsProfile: TDataSource;
    tblProfile: TADOTable;
    dsIngredients: TDataSource;
    tblIngredients: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMainDatabase: TdmMainDatabase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmMainDatabase.DataModuleCreate(Sender: TObject);
var
  sDatabasePath, exePath: string;
begin
  // Construct the full path to the database file
  exePath := ExtractFilePath(ParamStr(0));
  sDatabasePath := exePath.Substring(0, exePath.Length-13) + '\Database\MainDatabase.mdb';
  // Set the connection string with the appropriate permissions
  conMainDatabase.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;' +  // Use Jet OLEDB provider for .mdb files
    'Data Source=' + sDatabasePath + ';' +  // Full path to the database
    'Persist Security Info=False;' +        // Don't store sensitive security info
    'Mode=ReadWrite;';                      // Open the database with read and write access
  // Open the connection to the database
  try
    conMainDatabase.Open;
  except
    on E: Exception do
      ShowMessage('Error connecting to the database: ' + E.Message);
  end;
end;

end.
