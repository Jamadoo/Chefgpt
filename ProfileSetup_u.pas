unit ProfileSetup_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, System.Generics.Collections, dmMainDatabase_u,
  System.IOUtils, System.JSON, PromptGenerationWizard_u;

type
  TfmProfileSetup = class(TForm)
    pcSetupMenu: TPageControl;
    tsWelcome: TTabSheet;
    tsDislikedFoods: TTabSheet;
    tsAllergies: TTabSheet;
    lblWelcome: TLabel;
    lblWelcomeCaption: TLabel;
    btnStart: TImage;
    imgBackground: TImage;
    tsGoal: TTabSheet;
    imgGoalBng: TImage;
    redtGoalInput: TRichEdit;
    btnStartGoal: TImage;
    btnNextPageGoal: TImage;
    btnBackGoal: TImage;
    lblGoalTitle: TLabel;
    imgGoalExample: TImage;
    imgGoalWhitebng: TImage;
    tsLikedFoods: TTabSheet;
    btnBackLF: TImage;
    lblLFTitle: TLabel;
    imgLikedFoodsExample: TImage;
    redtLikedFoodsInput: TRichEdit;
    imgLFWhiteBng: TImage;
    imgLFBng: TImage;
    btnStartLF: TImage;
    btnNextPageLF: TImage;
    imgDFWhiteBng: TImage;
    imgDFBng: TImage;
    imgDFStart: TImage;
    btnNextPageDF: TImage;
    btnBackDF: TImage;
    lblTitleDF: TLabel;
    imgDislikedFoodsExample: TImage;
    redtDislikedFoodsInput: TRichEdit;
    btnBackAllergies: TImage;
    lblAllergiesTitle: TLabel;
    btnAllergiesExample: TImage;
    redtAllergiesInput: TRichEdit;
    Image3: TImage;
    imgAllergiesBng: TImage;
    btnAllergiesStart: TImage;
    btnFinishSetup: TImage;
    procedure pcSetupMenuDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnNextPage(Sender: TObject);
    procedure imgFinishSetupClick(Sender: TObject);
    procedure ShowExample(Sender: TObject);
    function CheckAndStoreInput(redtActiveInput : TRichEdit ; sInputName : string ; iMinChars : integer ; bStepBack: boolean) : boolean;
    procedure btnStartWizard(Sender: TObject);
    procedure btnSaveSingleField(Sender : TObject);
  private
    dcProfileInputs : TDictionary<string, string>;
    arrExamples: array of string;
    const
      iMinGoal = 40;
      iMinFoods = 30;
      iMinAllergies = 0;
  public
    sProjectFolder : string;
    bStartFromTop : boolean;
  end;

var
  fmProfileSetup: TfmProfileSetup;

implementation
// Uses Here to aviod cross refrence
uses chefgpt_u;

{$R *.dfm}

/// Custom Functions
function TfmProfileSetup.CheckAndStoreInput(redtActiveInput : TRichEdit ; sInputName : string ; iMinChars : integer ; bStepBack: boolean) : boolean;
begin
  // Check Input Length
  if redtActiveInput.Lines.Text.Length < iMinChars then
  begin
    // Step Back
    if bStepBack then
      pcSetupMenu.ActivePageIndex := pcSetupMenu.ActivePageIndex - 1;
    // Show Error
    var sError := 'The Minimal Character Count For This Feild Is ' + iMinChars.ToString() + ' Characters.'
                   + #10 + 'Please Go Into More Detail In Your Input.';
    MessageDlg(sError, mtError, [mbOK], 0);
    // Exit
    Result := false;
    exit;
  end;
  // Save Input To Dictionary
  dcProfileInputs.AddOrSetValue(sInputName, redtActiveInput.Lines.Text);
  Result := true;
end;

/// Events
// Buttons
procedure TfmProfileSetup.btnNextPage(Sender: TObject);
var
  iButtonTag : integer;
  redtActiveInput : TRichEdit;
begin
  // Change Active Page
  iButtonTag := (Sender as TImage).Tag;
  pcSetupMenu.ActivePageIndex := iButtonTag;
  // Check If NextPage Button
  if iButtonTag < pcSetupMenu.ActivePageIndex then
    exit;
  // Save To Var According To Tag (iButtonTag-1 to get current page)
  case iButtonTag-1 of
    1: CheckAndStoreInput(redtGoalInput, 'Goal', iMinGoal, true);
    2: CheckAndStoreInput(redtLikedFoodsInput, 'LikedFoods', iMinFoods, true);
    3: CheckAndStoreInput(redtDislikedFoodsInput, 'DislikedFoods', iMinFoods, true);
  end;
end;

procedure TfmProfileSetup.imgFinishSetupClick(Sender: TObject);
begin
  // Check Input
  if not CheckAndStoreInput(redtAllergiesInput, 'Allergies', iMinAllergies, false) then
    exit;
  // Save To Database
  with dmMainDatabase do
  begin
    // Setup Table
    tblProfile.Open;
    if tblProfile.RecordCount = 0 then
      tblProfile.Insert
    else
    begin
      tblProfile.First;
      tblProfile.Edit;
    end;
    // Loop Through Dictionary
    try
      for var Input in dcProfileInputs do
      begin
        tblProfile[Input.Key] := Input.Value;
      end;
      // Save Table
      tblProfile.Post;
    except
      MessageDlg('An Error Occurred While Saving Your Profile Data. Please Try Again', TMsgDlgType.mtError, [mbOk], 0);
      tblProfile.Cancel;
      tblProfile.Close;
      exit;
    end;
    tblProfile.Close;
  end;
  // Close Modal
  fmChefGPT.Show;
  fmProfileSetup.Hide;
  // Pos Form
  fmChefGPT.Top := fmProfileSetup.Top;
  fmChefGPT.Left := fmProfileSetup.Left;
end;

procedure TfmProfileSetup.ShowExample(Sender: TObject);
var
  iTag : integer;
begin
  iTag := (Sender as TImage).Tag;
  MessageDlg(arrExamples[iTag], TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
end;

procedure TfmProfileSetup.btnSaveSingleField(Sender: TObject);
var
  redtActive : TRichEdit;
  iMinChars : integer;
  sFieldName : string;
begin
  // Get input and output values
  case (Sender as TImage).Tag of
    2:
    begin
      redtActive := redtGoalInput;
      sFieldName := 'Goal';
      iMinChars := iMinGoal;
    end;
    3:
    begin
      redtActive := redtLikedFoodsInput;
      sFieldName := 'LikedFoods';
      iMinChars := iMinFoods;
    end;
    4:
    begin
      redtActive := redtDislikedFoodsInput;
      sFieldName := 'DislikedFoods';
      iMinChars := iMinFoods;
    end;
    5:
    begin
      redtActive := redtAllergiesInput;
      sFieldName := 'Allergies';
      iMinChars := iMinAllergies;
    end;
    else
    begin
      redtActive := redtGoalInput;
      sFieldName := 'Goal';
      iMinChars := iMinGoal;
    end;
  end;
  // Validate Input
  if redtActive.Lines.Text.Length < iMinChars then
  begin
    var sError := 'The Minimal Character Count For This Feild Is ' + iMinChars.ToString() + ' Characters.'
                   + #10 + 'Please Go Into More Detail In Your Input.';
    MessageDlg(sError, mtError, [mbOK], 0);
    exit;
  end;
  // Work With Database
  with dmMainDatabase do
  begin
    tblProfile.Open;
    // Validate Record
    if tblProfile.RecordCount <= 0 then
    begin
      MessageDlg('Profile Record Does Not Exsist. Please Complete The First Setup Before Trying To Edit The Feilds',
        TMsgDlgType.mtError, [mbOK], 0);
      tblProfile.Close;
      Exit;
    end;
    // Save Record
    try
      tblProfile.First;
      tblProfile.Edit;
      tblProfile[sFieldName] := redtActive.Lines.Text;
    except
      MessageDlg('An Error Occurred While Saving Your Profile Data. Please Try Again', TMsgDlgType.mtError, [mbOk], 0);
      tblProfile.Cancel;
      tblProfile.Close;
      exit;
    end;
  end;
  // Close Form
  fmChefGPT.RefreshSettingsText();
  FreeAndNil(Self);
end;

procedure TfmProfileSetup.btnStartWizard(Sender: TObject);
var
  JSONString, sObjectName : string;
  redtOutput : TRichEdit;
  jsonJSONObject : TJSONObject;
begin
  // Set JSON Object
  JSONString := TFile.ReadAllText(sProjectFolder + '\StoredValues.json');
  jsonJSONObject := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  // Get Sender Info
  case (Sender as TImage).Tag of
    1 : begin
      sObjectName := 'FitnessGoalWizard';
      redtOutput := redtGoalInput;
    end;
    2 : begin
      sObjectName := 'LikedFoodsWizard';
      redtOutput := redtLikedFoodsInput;
    end;
    3 : begin
      sObjectName := 'DislikedFoodsWizard';
      redtOutput := redtDislikedFoodsInput;
    end;
    4 : begin
      sObjectName := 'AllergiesWizard';
      redtOutput := redtAllergiesInput;
    end;
    else
    begin
      sObjectName := 'FitnessGoalWizard';
      redtOutput := redtGoalInput;
    end;
  end;
  // Get Questions
  fmPromptWizard.jsonQuestions := jsonJSONObject.GetValue<TJsonObject>(sObjectName);
  // Set Output
  fmPromptWizard.redtOutput := redtOutput;
  fmPromptWizard.sImagesPath := sProjectFolder + '\Images\';
  // Show Form
  fmPromptWizard.pcPages.ActivePageIndex := 0;
  fmChefGPT.ShowAndCenterForm(Self, fmPromptWizard);
end;

// Reset Form
procedure TfmProfileSetup.FormShow(Sender: TObject);
var
  JSONString: string;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  i: Integer;
begin
  /// Load Examples
  sProjectFolder := fmChefGPT.sProjectFolder;
  JSONString := TFile.ReadAllText(sProjectFolder + '\StoredValues.json');
  // Parse the JSON
  JSONValue := TJSONObject.ParseJSONValue(JSONString);
  // Access the "Examples" array
  JSONArray := JSONValue.GetValue<TJSONArray>('Examples');
  // Set the size of the array
  SetLength(arrExamples, JSONArray.Count);
  // Load values into the Delphi array
  for i := 0 to JSONArray.Count - 1 do
  begin
    arrExamples[i] := JSONArray.Items[i].Value;
  end;
  JSONValue.Free; // Free the JSONValue
  // Create Dictionary
  dcProfileInputs := TDictionary<string, string>.Create;
  // Reset Setup Menu
  if bStartFromTop then
  begin
    pcSetupMenu.ActivePageIndex := 0;
    redtGoalInput.Lines.Clear;
    redtLikedFoodsInput.Lines.Clear;
    redtDislikedFoodsInput.Lines.Clear;
    redtAllergiesInput.Lines.Clear;
  end;
end;

// Remove PageControl Border
procedure TfmProfileSetup.pcSetupMenuDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  PageControl: TPageControl;
begin
  PageControl := Control as TPageControl;
  // Remove the border by setting Pen.Style to psClear
  PageControl.Canvas.Pen.Style := psClear;
  Control.Canvas.FillRect(Rect);
end;

end.
