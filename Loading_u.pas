unit Loading_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfmLoading = class(TForm)
    pnlLoading: TPanel;
    pnlSub: TPanel;
    pnlBevel: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLoading: TfmLoading;

implementation

{$R *.dfm}

end.
