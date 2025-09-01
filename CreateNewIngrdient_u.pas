unit CreateNewIngrdient_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, System.Threading, dmMainDatabase_u,
  Data.DB;

type
  TfmCreateNewIngredient = class(TForm)
    pnlBackground: TPanel;
    edtName: TEdit;
    rgbMassurement: TRadioGroup;
    btnSaveIngredient: TImage;
    spnAmount: TSpinEdit;
    lblMessurement: TLabel;
    chkNoMessurement: TCheckBox;
    lblNameTitle: TLabel;
    procedure rgbMassurementClick(Sender: TObject);
    procedure btnSaveIngredientClick(Sender: TObject);
  private
    sMessurement,sName, sAmount : string;
  public
    bOverride : boolean;
    sOriginalName : string;
  end;

var
  fmCreateNewIngredient: TfmCreateNewIngredient;

implementation
// Use here to aviod endless referncing
uses Chefgpt_u;

{$R *.dfm}

// Custom Functions
procedure FlashRed(ctrToFlash : TWinControl);
var
  bgColor : TColor;

begin
  bgColor := ctrToFlash.Brush.Color;

  TTask.Run(procedure
  var
    i: Integer;
  begin
    for i := 1 to 6 do  // 3 flashes (on and off)
    begin
      if i mod 2 = 1 then
        ctrToFlash.Brush.Color := clRed
      else
        ctrToFlash.Brush.Color := bgColor;
      // Pause between flashes
      ctrToFlash.Refresh();
      Sleep(100);
    end;
    // Ensure final restoration to original colors
    ctrToFlash.Brush.Color := bgColor;
    ctrToFlash.Refresh();
  end);
end;

// Events
procedure TfmCreateNewIngredient.btnSaveIngredientClick(Sender: TObject);
var
  sIngredient, sName : string;
  iReponse, iAmount : integer;
  bFoundMatch, bNoMessurement : boolean;
begin
  // Validate Name
  sName := edtName.Text;
  if sName = '' then
  begin
    MessageDlg('Please Enter The Name Of The Ingredient', TMsgDlgType.mtError, [mbOK], 0);
    FlashRed(edtName);
    exit;
  end;
  if sName.Contains(';') then
  begin
    MessageDlg(QuotedStr(';') + ' May Not Be Used Inside The Name', TMsgDlgType.mtError, [mbOK], 0);
    FlashRed(edtName);
    exit;
  end;
  // Validate Messurement Select And Amount
  bNoMessurement := chkNoMessurement.Checked;
  if (rgbMassurement.ItemIndex = -1) and (not bNoMessurement) then
  begin
    MessageDlg('Please Enter a Messurement For The Ingredient', TMsgDlgType.mtError, [mbOK], 0);
    FlashRed(rgbMassurement);
    exit;
  end;
  iAmount := spnAmount.Value;
  if (iAmount <= 0) and (not bNoMessurement) then
  begin
    MessageDlg('Please Enter a Valid Amount Of The Ingredient', TMsgDlgType.mtError, [mbOK], 0);
    FlashRed(spnAmount);
    exit;
  end;
  // Create String
  if bNoMessurement then
    sIngredient := sName
  else
    sIngredient := sName + ' ; ' + iAmount.ToString() + ' ' + sMessurement;
  // Save Ingredient
  with dmMainDatabase do
  begin
    tblIngredients.Open;
    // Check Already Exsist
    if bOverride then
      bFoundMatch := tblIngredients.Locate('Ingredient', sOriginalName, [])
    else
      bFoundMatch := tblIngredients.Locate('Ingredient', sName, [loPartialKey]);

    if (bFoundMatch) and (not bOverride) then
    begin
      iReponse := MessageDlg('We Detected A Saved ingredient With The Same Name.'+#$A+
        'If You Already Have This Ingredient Saved, Please Edit The Saved Ingredient Instead'+#$A#$A+
          'DO YOU WANT TO SAVE THIS INGREDIENT ANYWAY?', TMsgDlgType.mtInformation, [mbNo, mbYes], 0);

      if (iReponse = mrNo) or (iReponse = mrNone) then
      begin
        tblIngredients.Close;
        exit;
      end;
    end
    else if (not bFoundMatch) and (bOverride) then
    begin
      MessageDlg('Could Not Find Ingredient To Edit.'+#$A+'Please Refresh The Ingredients Page And Try Again', TMsgDlgType.mtError, [mbOK], 0);
      tblIngredients.Close;
      exit;
    end;

    // Save Ingredient
    try
      if bOverride then
        tblIngredients.Edit
      else
        tblIngredients.Append;
      tblIngredients['Ingredient'] := sIngredient;
      tblIngredients.Post;

      // Pop ups Gets Annoying after a while
      // MessageDlg('Ingredient Has Been Saved', TMsgDlgType.mtInformation, [mbOK], 0);
    except
      MessageDlg('An Error Occured While Saving The Ingredient'+#$A+
        'Please Ensure The Database Is Not Already In Use', TMsgDlgType.mtError, [mbOK], 0);
      tblIngredients.Cancel;
    end;
    tblIngredients.Close;
  end;
  // Refresh List
  fmChefGPT.RefreshSavedIngredients();
  // Close If Editing
  if bOverride then
    FreeAndNil(Self);
end;

procedure TfmCreateNewIngredient.rgbMassurementClick(Sender: TObject);
begin
  case rgbMassurement.ItemIndex of
    0: sMessurement := 'Pieces';
    1: sMessurement := 'ml';
    2: sMessurement := 'g';
  end;
  lblMessurement.Caption := sMessurement;
end;

end.
