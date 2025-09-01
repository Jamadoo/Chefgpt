unit chefgpt_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
   Vcl.ComCtrls, Vcl.WinXPanels, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, ProfileSetup_u,
   dmMainDatabase_u, TypInfo, Rtti, RichEdit, System.IOUtils, Generics.Collections,
   OpenAI, OpenAI.Chat, OpenAI.Utils.Base64, System.JSON, RegularExpressions, Data.DB, Loading_u,
   System.DateUtils, CreateNewIngrdient_u, PromptGenerationWizard_u, OpenAI.API.Params;

type
  TfmChefGPT = class(TForm)
    lblTitle: TLabel;
    lblInstructions: TLabel;
    pcMainScreens: TPageControl;
    tsSavedRecipes: TTabSheet;
    tsGenorateNew: TTabSheet;
    tsIngredients: TTabSheet;
    btnTab1: TPanel;
    btnTab2: TPanel;
    btnTab3: TPanel;
    TabImage1: TImage;
    TabImage2: TImage;
    TabImage3: TImage;
    spSideButtons: TStackPanel;
    pnlBackground2: TPanel;
    imgChefHat: TImage;
    pnlBackground3: TPanel;
    btnSendToGPT: TImage;
    imgEditBackDrop: TImage;
    redtMealDescription: TRichEdit;
    imgBackground: TImage;
    imgImage: TImage;
    pnlRecipeTemp: TPanel;
    lblRecipeTitle: TLabel;
    imgShowRecipeButton: TImage;
    lblDescription: TLabel;
    sbGrid: TScrollBox;
    lbSavedIngredients: TListBox;
    lbRegonizedIngredients: TListBox;
    lblImportTitle: TLabel;
    imgImportImage: TImage;
    imgAddIngredient: TImage;
    imgDeleteIng: TImage;
    imgEditIng: TImage;
    imgInputIngredient: TImage;
    tsRecipe: TTabSheet;
    pnlBackgroundMethod: TPanel;
    pcSidePanel: TPageControl;
    lblRecipeName: TLabel;
    imgSaveIcon: TImage;
    edtBackIcon: TImage;
    shIngredients: TTabSheet;
    pnlBackgroundIng: TPanel;
    tsGoal: TTabSheet;
    tsMarcos: TTabSheet;
    pnlBackgroundGoal: TPanel;
    pngBackgroundMacro: TPanel;
    StackPanel1: TStackPanel;
    btnMacros: TPanel;
    Image2: TImage;
    btnGoal: TPanel;
    Image3: TImage;
    btnListIng: TPanel;
    Image4: TImage;
    btnTab4: TPanel;
    TabImage4: TImage;
    spSettingsBackground: TShape;
    pblDevider: TPanel;
    tsSettings: TTabSheet;
    pnlSettingsBackground: TPanel;
    edtSettingFitnessGoal: TRichEdit;
    edtSettingsLF: TRichEdit;
    edtSettingsDL: TRichEdit;
    edtSettingsAl: TRichEdit;
    btnEditFG: TImage;
    btnEditLF: TImage;
    btnEditDF: TImage;
    btnEditAl: TImage;
    redtMethod : TRichEdit;
    redtGoal : TRichEdit;
    redtMacros : TRichEdit;
    redtListIngredients : TRichEdit;
    tmrToggelForms: TTimer;
    pnlSavePopup: TPanel;
    imgRecipeImage: TImage;
    pnlSave: TPanel;
    pnlClose: TPanel;
    edtRecipeName: TEdit;
    imgShowMoreOptions: TImage;
    pnlExtraOptions: TPanel;
    imgDelete: TImage;
    imgToggleLockRecipe: TImage;
    pnlOnlyFridge: TPanel;
    chkOnlyFridge: TImage;
    btnStartMealDesc: TImage;
    imgSettingsBackdrop: TImage;
    imgGoalBorder: TImage;
    imgLikedFoodsBorder: TImage;
    imgDislikedFoodsBorder: TImage;
    imgAllergiesBorder: TImage;
    procedure btnTab1Click(Sender: TObject);
    procedure btnTab2Click(Sender: TObject);
    procedure btnTab3Click(Sender: TObject);
    procedure pcMainScreensDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure btnGoalClick(Sender: TObject);
    procedure btnListIngClick(Sender: TObject);
    procedure btnMacrosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTab4Click(Sender: TObject);
    procedure tsSavedRecipesShow(Sender: TObject);
    procedure btnSendToGPTClick(Sender: TObject);
    procedure edtBackIconClick(Sender: TObject);
    procedure tmrToggelFormsTimer(Sender: TObject);
    procedure imgSaveIconClick(Sender: TObject);
    procedure imgRecipeImageClick(Sender: TObject);
    procedure pnlCloseClick(Sender: TObject);
    procedure pnlSaveClick(Sender: TObject);
    procedure LoadRecipeButtonClick(Sender: TObject);
    procedure imgShowMoreOptionsMouseEnter(Sender: TObject);
    procedure pnlExtraOptionsMouseLeave(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure imgToggleLockRecipeClick(Sender: TObject);
    procedure ToggleFieldLocks(bFieldLocks : boolean ; sImageName : string);
    procedure chkOnlyFridgeClick(Sender: TObject);
    procedure imgInputIngredientClick(Sender: TObject);
    procedure imgDeleteIngClick(Sender: TObject);
    procedure imgEditIngClick(Sender: TObject);
    procedure imgImportImageClick(Sender: TObject);
    procedure imgAddIngredientClick(Sender: TObject);
    procedure btnStartMealDescClick(Sender: TObject);
    procedure btnEditSettings(Sender : TObject);

    procedure RefreshSavedIngredients();
    procedure ShowAndCenterForm(fmOriginal, fmToShow : TForm);
    procedure RefreshSettingsText();

    function AskGPT(sPrompt, sImagePath : string) : string ;
  private
    lblNoRecipes : TLabel;
    sImagesFolder : string;
    bRecipeLocked : boolean;
    bPresetExtraIng : boolean;
    // Save Recipe / Upload Image
    sUploadedImagePath, sDefaultImage, sCurrentRecipeName : string;
    // Functions
    function CloneControl(ctrOriginalControl: TControl; winNewParent: TWinControl): TControl;
    // Procedures
    procedure CloneChildren(winOrigin : TWinControl ; winParent : TWinControl);
    procedure LoadRecipeScreen(sName, sMethod, sIngredients, sGoal, sMacros : string ; bFixNeeded : boolean);
    // Consts
    const
      // GUI Tabs: MS - MainScreen ; SS - SideSection
      clMSScelectedColor = $00F7B58D;
      clMSUnselectedColor = $00F28440;
      clSSSelectedColor = $00F29054;
      clSSUnselectedColor = $00B04A0C;
      // Hardcode Password To Keep 'Secure'
      sLockPassword = 'SecurePass123';
  public
    sProjectFolder : string;
  end;

var
  fmChefGPT: TfmChefGPT;

implementation

{$R *.dfm}

/// Custom Functions/Procedures
function TfmChefGPT.CloneControl(ctrOriginalControl: TControl; winNewParent: TWinControl): TControl;
var
  rcnContext: TRttiContext;
  rtSourceType: TRttiType;
  ctrNewControl: TControl;
  rpProp: TRttiProperty;
begin
  // Create a new instance of the control's class
  ctrNewControl := TControlClass(ctrOriginalControl.ClassType).Create(self);
  // Set the parent of the new control
  // Set Parent Before Copying Over Props, or delphi steals 5 hours of your day
  // trying to figure out why it scales a already scaled control...
  ctrNewControl.Parent := winNewParent;
  // Copy published properties
  rcnContext := TRttiContext.Create;
  try
    rtSourceType := rcnContext.GetType(ctrOriginalControl.ClassType);
    for rpProp in rtSourceType.GetProperties do
    begin
      // mvPublished = editable through rtti. Prop can be writeable but not
      // writeable through rtti.
      if rpProp.IsWritable and rpProp.IsReadable and (rpProp.Visibility = mvPublished) then
      begin
        if (rpProp.Name <> 'Name') and (rpProp.Name <> 'Parent') then
        begin
          try
            rpProp.SetValue(ctrNewControl, rpProp.GetValue(ctrOriginalControl));
          except
            // Handle exceptions for properties that cannot be copied (do nothing :D)
          end;
        end;
      end;
    end;
  finally
    rcnContext.Free;
  end;
  Result := ctrNewControl;
end;

function TfmChefGPT.AskGPT(sPrompt, sImagePath : string) : string ;
var
  OpenAiClient : IOpenAI;
  JSONString, sHost, sUser, sPass : string;
  iPort : integer;
  JSONObject, jsonSettings : TJsonObject;
begin
  try
    // OpenAI API Key, shhhhhhh!!
    OpenAiClient := TOpenAI.Create('...');

    // Check For Proxy
    iPort := 0;
    JsonString := TFile.ReadAllText(sProjectFolder + '\StoredValues.json');
    JSONObject := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
    jsonSettings := JSONObject.GetValue<TJsonObject>('ProxySettings');
    sHost := jsonSettings.GetValue<string>('Host');
    sUser := jsonSettings.GetValue<string>('Username');
    sPass := jsonSettings.GetValue<string>('Password');
    Int32.TryParse(jsonSettings.GetValue<string>('Port'), iPort);
    if (sHost <> '') and (iPort > 0) then
      if (sUser <> '') and (sPass <> '') then
        OpenAiClient.API.ProxySettings := OpenAiClient.API.ProxySettings.Create(sHost, iPort, sUser, sPass)
      else
        OpenAiClient.API.ProxySettings := OpenAiClient.API.ProxySettings.Create(sHost, iPort);

    // Get Response
    var Chat := OpenAiClient.Chat.Create(
      procedure(Params: TChatParams)
        begin
          var Content: TArray<TMessageContent>;
          Content := Content + [TMessageContent.CreateText(sPrompt)];
          if (sImagePath <> '') and (FileExists(sImagePath)) then
            Content := Content + [TMessageContent.CreateImage(FileToBase64(sImagePath))];

          Params.Messages([TChatMessageBuild.User(Content)]);
          Params.MaxTokens(2048);
          Params.Model('gpt-4o');
        end);
    Result := Chat.Choices[0].Message.Content;
  except
    MessageDlg('An Error Orrcurred While Contacting OpenAI.'+
      ' Please Ensure You Have a Working Internet Connection'+
        'If You Have Any Proxies Running, Please Add It CORRECTLY Inside The "StoredValues" JSON File.', TMsgDlgType.mtError, [mbOK], 0);
    Result := '';
    exit;
  end;
end;

function FixRTFText(sRTFString : string ; redDisplay : TRichEdit) : string;
var
  regexPattern, sFinalString : string;
  i : integer;
begin
  // Fix Incorrect Formatting From GPT
  sRTFString := sRTFString.Trim();
  sRTFString := sRTFString.Replace('?', '');
  sRTFString := sRTFString.Replace('''', '\''27');
  sRTFString := sRTFString.Replace('\intbl', ''); // incorrect tables causes text not to be rendered
  // Add Non-breaking spaces using Regex (what?? delphi has regex???)
  // i cant get regex to work with a 'all commands' type. So we'll just manually input them
  regexPattern := '\\(b0|b|i0|i|ul|ulnone|strike|strike0|sub|sub0|super|super0|'+
    'scaps|scaps0|caps|caps0|v|v0|bullet|shad|outl|ulw|uld|uldb|ulth)\s';
  sRTFString := TRegEx.Replace(sRTFString, regexPattern, '\\$1\~');

  // Add Closing }, gpt tends to forget
  if (sRTFString[sRTFString.Length] <> '}') and (sRTFString[1] = '{') then
  begin
    // Check For { missing a } - Not doing this because gpt is beyond stupid sometimes
    //iLastClosing := sRTFString.LastIndexOf('}');
    //iLastOpening := sRTFString.LastIndexOf('{');
    //if iLastOpening > iLastClosing then
      sRTFString := sRTFString + '}';
  end;

  // Replace Delphi Linebreak with RTF Linebreak And Fix '-'
  for i := 1 to sRTFString.Length do
  begin
    if sRTFString[i] <> #$A then
    begin
      if (sRTFString[i] = '-') and ((i = 1) or (sRTFString[i - 1] <> '\')) then
        // Replace '-'
        sFinalString := sFinalString + '\''2D'
      else
        sFinalString := sFinalString + sRTFString[i];
    end
    else if copy(sRTFString, i-5, 5) <> '\line' then
      // Replace Linebreak
      sFinalString := sFinalString + '\line';
  end;

  Result := sFinalString;
end;

function ExtractRawRTF(redtCurrent : TRichEdit) : string;
var
  Stream: TMemoryStream;
  RTFStringStream: TStringStream;
  RTFText : string;
begin
  Stream := TMemoryStream.Create;
  try
    // Save the RichEdit content as RTF into the memory stream
    redtCurrent.Lines.SaveToStream(Stream);

    // Move stream position to the beginning
    Stream.Position := 0;

    // Convert the memory stream to a string stream to extract RTF content
    RTFStringStream := TStringStream.Create;
    try
      RTFStringStream.CopyFrom(Stream, Stream.Size);
      RTFText := RTFStringStream.DataString;  // RTF content in a string
    finally
      RTFStringStream.Free;
    end;
  finally
    Stream.Free;
  end;

  Result := RTFText;
end;

procedure FitTextInLabel(sText : string ; lblLabel : TLabel);
var
  bpBitmap : TBitmap;
  sTempText, sEllipsText : string;
  rcTextRect : TRect;
  iMaxW, iMaxH : integer;
begin
  //..... EllipsisPosition is a property inside a label......man.....wtf

  // Create Bitmap, for rendering text
  bpBitmap :=  TBitmap.Create();
  try
    // Vars
    sTempText := sText;
    iMaxW := lblLabel.Width;
    iMaxH := lblLabel.Height;
    rcTextRect := TRect.Create(0, 0, iMaxW, 0);
    // Setup Bitmap Canvas
    bpBitmap.Canvas.Font.Assign(lblLabel.Font);
    // Check WordWrap / Multi Line
    // (i really dont know why only checking height does not work, lots of hours gone)
    if lblLabel.WordWrap then
    begin
      // Draw Text
      DrawText(bpBitMap.Canvas.Handle, PChar(sTempText), Length(sTempText), rcTextRect, DT_CALCRECT or DT_WORDBREAK or DT_EDITCONTROL);
      // Remove Last Char, Draw And See If Height < iMaxHeight
      while rcTextRect.Height > iMaxH do
      begin
          if Length(sTempText) = 0 then Break;
          Delete(sTempText, Length(sTempText), 1);

          sEllipsText := sTempText + '...';
          DrawText(bpBitMap.Canvas.Handle, PChar(sEllipsText), Length(sEllipsText), rcTextRect, DT_CALCRECT or DT_WORDBREAK or DT_EDITCONTROL);
      end;
    end
    else
    begin
      // Check Horizontal / Width
      while (sTempText.Length > 0) and (bpBitmap.Canvas.TextWidth(sTempText + '...') > iMaxW) do
      begin
        Delete(sTempText, Length(sTempText), 1);
      end;
    end;

    // Add Ellips If Shortened
    if (sTempText <> sText) and (sTempText.Length > 0) then
      sTempText := sTempText + '...';

    // Set Caption
    lblLabel.Caption := sTempText;
  finally
    bpBitmap.Free;
  end;
end;

procedure StreamRTFText(redDisplay : TRichEdit ; sRTFString : string ; bFixNeeded : boolean);
var
  ssStringStream: TStringStream;
  sFinalString, regexPattern, sHalfPointFontSize : string;
begin
  // .Clear removes all formatting
  redDisplay.Lines.Text := '';
  redDisplay.PlainText := false;
  redDisplay.Lines.BeginUpdate();

  // Fix Any Font Size Changes (also to account for scalling)
  regexPattern := '\\fs[0-9]+';
  sHalfPointFontSize := (redDisplay.Font.Size * 2).ToString();
  sRTFString := TRegEx.Replace(sRTFString, regexPattern, '\\fs'+sHalfPointFontSize);

  // Fix NEW GENORATED Text. To avoid fixing, fixed text
  // Otherwise it will lead to unexpected line breaks and broken commands
  if bFixNeeded then
    sFinalString := FixRTFText(sRTFString, redDisplay)
  else
    sFinalString := sRTFString;

  // Load Into Richedit With The Formatting
  ssStringStream := TStringStream.Create(sFinalString);
  try
    redDisplay.Lines.LoadFromStream(ssStringStream);
  finally
    ssStringStream.Free;
  end;

  redDisplay.Lines.EndUpdate();
end;

procedure TfmChefGPT.LoadRecipeScreen(sName, sMethod, sIngredients, sGoal, sMacros : string ; bFixNeeded : boolean);
var
  sRegexPattern, sModifiedName : string;
begin
  // Load Inside RichEdits
  StreamRTFText(redtMethod, sMethod, bFixNeeded);
  StreamRTFText(redtGoal, sGoal, bFixNeeded);
  StreamRTFText(redtListIngredients, sIngredients, bFixNeeded);
  StreamRTFText(redtMacros, sMacros, bFixNeeded);

  /// Modify And Display Name
  // Remove any RTF tags inside name
  sRegexPattern := '\{[^\s\}]+[\s\}]';
  sModifiedName := sName;
  var bIsMatch := TRegEx.IsMatch(sModifiedName, sRegexPattern);
  if bIsMatch then
  begin
    // Replace Starting Tags
    sModifiedName := TRegEx.Replace(sModifiedName, sRegexPattern, '');
    // Remove End }
    sModifiedName := sModifiedName.Replace('}', '');
  end;
  // Remove Any RTF Commands
  sRegexPattern := '\\[^\s]+';
  sModifiedName := TRegEx.Replace(sModifiedName, sRegexPattern, '');
  sModifiedName := sModifiedName.Trim();
  // Display Name
  FitTextInLabel(sModifiedName, lblRecipeName);

  // Relock Fields
  bRecipeLocked := true;
  ToggleFieldLocks(true, 'LockIcon.png');
  // Show Forum
  pcMainScreens.ActivePageIndex := 3;
  spSideButtons.Visible := false;
  // Store Info
  sCurrentRecipeName := sModifiedName;
end;

procedure TfmChefGPT.CloneChildren(winOrigin : TWinControl ; winParent : TWinControl);
var
  i : integer;
  ctrCurrentControl, ctrClonedControl : TControl;
begin

  for i := 0 to winOrigin.ControlCount - 1 do
  begin
    ctrCurrentControl := winOrigin.Controls[i];
    ctrClonedControl := CloneControl(ctrCurrentControl, winParent);

    // Add Control's Children Aswell
    if (ctrCurrentControl is TWinControl)
    and ((ctrCurrentControl as TWinControl).ControlCount > 0) then
      CloneChildren(ctrCurrentControl as TWinControl, ctrClonedControl as TWinControl);
  end;
end;

procedure TfmChefGPT.ToggleFieldLocks(bFieldLocks : boolean ; sImageName : string);
var
  sFilePath : string;
begin
  sFilePath := sProjectFolder + '\Images\' + sImageName;
  if FileExists(sFilePath) then
    imgToggleLockRecipe.Picture.LoadFromFile(sFilePath);

  redtMethod.ReadOnly := bFieldLocks;
  redtGoal.ReadOnly := bFieldLocks;
  redtMacros.ReadOnly := bFieldLocks;
  redtListIngredients.ReadOnly := bFieldLocks;
end;

procedure TfmChefGPT.RefreshSavedIngredients();
begin
  // Clear List
  lbSavedIngredients.Items.Clear;
  // Loop through table and Add To List
  with dmMainDatabase do
  begin
    tblIngredients.Open();
    tblIngredients.First();

    if tblIngredients.RecordCount <= 0 then
    begin
      lbSavedIngredients.Items.Add('No Saved Recipes');
      imgEditIng.Enabled := false;
      imgDeleteIng.Enabled := false;
      tblIngredients.Close();
      exit;
    end;
    imgEditIng.Enabled := true;
    imgDeleteIng.Enabled := true;

    while not tblIngredients.Eof do
    begin
      lbSavedIngredients.Items.Add(tblIngredients['Ingredient']);
      tblIngredients.Next();
    end;

    tblIngredients.Close();
  end;
end;

procedure TfmChefGPT.ShowAndCenterForm(fmOriginal, fmToShow : TForm);
begin
  fmToShow.Top := fmOriginal.Top + Round(fmOriginal.Height / 2) - Round(fmToShow.Height / 2);
  fmToShow.Left := fmOriginal.Left + Round(fmOriginal.Width / 2) - Round(fmToShow.Width / 2);
  fmToShow.Show();
  Application.ProcessMessages;
end;

procedure TfmChefGPT.RefreshSettingsText();
begin
  with dmMainDatabase do
  begin
    tblProfile.Open;
    // Validate
    if tblProfile.RecordCount <= 0 then
    begin
      MessageDlg('No Profile Record Saved. Please Restart Your App And Complete The Profile Setup',
        TMsgDlgType.mtError, [mbOK], 0);
      exit;
    end;
    // Load
    tblProfile.First;
    edtSettingFitnessGoal.Text := tblProfile['Goal'];
    edtSettingsLF.Text := tblProfile['LikedFoods'];
    edtSettingsDL.Text := tblProfile['DislikedFoods'];
    edtSettingsAl.Text := tblProfile['Allergies'];
  end;
end;

/// Startup
procedure TfmChefGPT.FormShow(Sender: TObject);
var
  sExePath : string;
begin
  // Get Project Path (running in debug mode, of course)
  sExePath := ExtractFilePath(ParamStr(0));
  sProjectFolder := sExePath.Substring(0, sExePath.Length-13);
  sImagesFolder := sProjectFolder + '\UploadedImages\';
  sDefaultImage := sImagesFolder + 'DefaultImage.png';
  bRecipeLocked := true;
  bPresetExtraIng := false;
  // Reset MainScreen Page Control
  pcMainScreens.ActivePageIndex := 0;
  btnTab1.Color := clMSScelectedColor;
  // Set Refernce Vars
  ProfileSetup_u.fmProfileSetup.bStartFromTop := true;
  // Check For Profile Record
  with dmMainDatabase do
  begin
    tblProfile.Open;

    if tblProfile.RecordCount = 0 then
      tmrToggelForms.Enabled := true
    else
      tsSavedRecipesShow(Sender);

    tblProfile.Close;
  end;
end;

procedure TfmChefGPT.pcMainScreensDrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var
  pcPageControl: TPageControl;
begin
  pcPageControl := Control as TPageControl;
  // Remove PageControl Border
  pcPageControl.Canvas.Pen.Style := psClear;
  Control.Canvas.FillRect(Rect);
end;

/// Events
procedure TfmChefGPT.tmrToggelFormsTimer(Sender: TObject);
begin
  tmrToggelForms.Enabled := false;
  // Show Form
  fmChefGPT.Hide();
  ShowAndCenterForm(Self, fmProfileSetup);
end;

procedure TfmChefGPT.tsSavedRecipesShow(Sender: TObject);
var
  iTop, iLeft, i, iSpacingX, iSpacingY: integer;
  pnlClonedTemp : TPanel;
  ctrClonedChild, ctrOriginalChild, ctrCurrControl : TControl;
  imgImageButton : TImage;
  sImagePath, sMethod, sRegexPattern : string;
  bIsMatch : boolean;
begin
  /// Refresh Saved Recipes
  // Use Table
  with dmMainDatabase do
  begin
    ShowAndCenterForm(Self, fmLoading);
    // Loop Through And Delete All Old Panels
    for i := sbGrid.ControlCount - 1 downto 0 do
    begin
      ctrCurrControl := sbGrid.Controls[i];
      if (ctrCurrControl <> nil) and (ctrCurrControl.Name <> pnlRecipeTemp.Name) and (ctrCurrControl.ClassName = 'TPanel') then
      begin
        FreeAndNil(ctrCurrControl);
      end;
    end;

    tblSavedRecipes.Open;
    tblSavedRecipes.First;
    // Check Atleast One
    if tblSavedRecipes.RecordCount > 0 then
    begin
      // Register Classes For Cloning
      RegisterClasses([TPanel, TLabel, TImage]);
      // Check Label
      if lblNoRecipes <> nil then
        FreeAndNil(lblNoRecipes);
      /// Show Recipes
      // Set Default Values (and adapt to scaling)
      iTop := pnlRecipeTemp.Top;
      iLeft := pnlRecipeTemp.Left;
      iSpacingX := Round(25 * Self.ScaleFactor); // Horizontal Spacing
      iSpacingY := Round(15 * Self.ScaleFactor); // Vertical Spacing
      while not tblSavedRecipes.Eof do
      begin
        // Clone Panel
        pnlClonedTemp := TPanel(CloneControl(pnlRecipeTemp, sbGrid));
        pnlClonedTemp.Visible := true;
        // Loop Throug Cloned Panel
        for i := 0 to pnlRecipeTemp.ControlCount - 1 do
        begin
          // Clone Control
          ctrOriginalChild := pnlRecipeTemp.Controls[i];
          ctrClonedChild := CloneControl(ctrOriginalChild, pnlClonedTemp);
          // Check Tag
          // 1 = Title ; 2 = Desc ; 3 = Image ;
          case ctrClonedChild.Tag of
            1: FitTextInLabel(tblSavedRecipes['RecipeName'], TLabel(ctrClonedChild));
            2: Begin
              sMethod := tblSavedRecipes['Method'];
              // Remove ant RTF tags inside Method
              sRegexPattern := '\{[^\r\n]*';
              bIsMatch := TRegEx.IsMatch(sMethod, sRegexPattern);
              if bIsMatch then
              begin
                // Remove End }
                sMethod.Replace('}', '');
                // Replace Starting Commands
                sMethod := TRegEx.Replace(sMethod, sRegexPattern, '');
              end;
              // Replace All /line with Linebreaks
              sMethod := sMethod.Replace('\line', #$A);
              // Remove Any RTF Commands
              sRegexPattern := '\\[^\s]+';
              sMethod := TRegEx.Replace(sMethod, sRegexPattern, '');
              sMethod := sMethod.Trim();
              // Show Method / Desc
              FitTextInLabel(sMethod, TLabel(ctrClonedChild));
            end;
            3: Begin
              // Get Image Path
              sImagePath := sImagesFolder + tblSavedRecipes['CoverImg'];
              // Check Image And Load
              if FileExists(sImagePath) then
                TImage(ctrClonedChild).Picture.LoadFromFile(sImagePath)
              else if FileExists(sDefaultImage) then
                TImage(ctrClonedChild).Picture.LoadFromFile(sDefaultImage);
            end;
            4: Begin
              // Read Recipe Button
              imgImageButton := TImage(ctrClonedChild);
              imgImageButton.Enabled := true;
              imgImageButton.OnClick := LoadRecipeButtonClick;
            end;
          end;

          // Clone Children If TWinControl
          if ctrClonedChild is TWinControl then
            CloneChildren(ctrOriginalChild as TWinControl, ctrClonedChild as TWinControl)
        end;
        // Get Pos
        if iLeft + pnlClonedTemp.Width > fmChefGPT.ClientWidth then
        begin
          iLeft := pnlRecipeTemp.Left;
          iTop := iTop + pnlClonedTemp.Height + iSpacingY;
        end;
        // Set Pos
        pnlClonedTemp.Left := iLeft;
        pnlClonedTemp.Top := iTop;
        // Adjust Left
        iLeft := iLeft + pnlClonedTemp.Width + iSpacingX;
        // Provide Record Index Inside Tag
        pnlClonedTemp.Tag := StrToInt(tblSavedRecipes['ID']);
        // yea no, i think you can geuss what happens here
        tblSavedRecipes.Next;
      end;
    end
    else
    begin
      // Check Showing Label
      if lblNoRecipes = nil then
      begin
        // Create New Label
        lblNoRecipes := TLabel.Create(self);
        with lblNoRecipes do
        begin
          Parent := sbGrid;
          Font.Name := 'Arial Rounded MT';
          Font.Size := 14;
          Font.Color := clWhite;
          Alignment := taCenter;
          AlignWithMargins := true;
          Margins.Top := 60;
          AutoSize := false;
          Caption := 'No Saved Recipes :(';
          lblNoRecipes.Name := 'lblNoRecipes';
          Align := alTop;
        end;
      end;
    end;

    tblSavedRecipes.Close;
    fmLoading.Hide();
  end;
end;

procedure TfmChefGPT.btnSendToGPTClick(Sender: TObject);
var
  sFinalPrompt, sStoredIngredients, sTagStart, sTagEnd, sDataValue,
    sReponse, sExtractedString : string;

  dcData, dcTaggedOutput : TDictionary<string, string>;

  JSONString: string;
  JSONObject: TJSONObject;

  bFormatError : boolean;

  iMinLength, iTagStart, iTagEnd, iErrorDetect, iNameEnd,
    iRetryCount, iMaxRetry : integer;

  // Local Procedure, woaaah
  procedure ResetButton();
  begin
    btnSendToGPT.Enabled := true;
    btnSendToGPT.Picture.LoadFromFile(sProjectFolder + '\Images\SendToGPT.png');
  end;

const
  sErrorTag = '[ERROR]';
begin
  // Disable And Change Button
  btnSendToGPT.Enabled := false;
  btnSendToGPT.Picture.LoadFromFile(sProjectFolder + '\Images\GenoratingNewIcon.png');
  btnSendToGPT.Update;
  // Validate MealDesc (magic number :D)
  dcData := TDictionary<string, string>.Create();
  dcData.Add('MealDescription', redtMealDescription.Lines.Text);
  iMinLength := 30;
  if Length(dcData['MealDescription']) < iMinLength then
  begin
    MessageDlg('Prompt To Short. Please give more details on the meal you want.'
      + 'Minimun Characters of ' + iMinLength.ToString() + '.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    ResetButton();
    exit;
  end;
  // Get Data
  with dmMainDatabase do
  begin
    tblProfile.Open;
    tblProfile.First;

    dcData.Add('Goal', tblProfile['Goal']);
    dcData.Add('LikedFoods', tblProfile['LikedFoods']);
    dcData.Add('DislikedFoods', tblProfile['DislikedFoods']);
    dcData.Add('Allergies', tblProfile['Allergies']);

    tblProfile.Close;

    tblIngredients.Open;
    tblIngredients.First;

    // Check Atleast 5 Ingredients
    if (tblIngredients.RecordCount < 5) and (not bPresetExtraIng) then
    begin
      MessageDlg('You Need To Have Atleast 5 Ingredients Saved / Stored *OR* Have "Use Extra Ingredients" Enabled To Genorate a Recipe'
      + #$A + 'You Cant Create Food From NOTHING.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      tblIngredients.Close;
      ResetButton();
      exit;
    end;

    sStoredIngredients := '';
    while not tblIngredients.Eof do
    begin
      sStoredIngredients := sStoredIngredients + tblIngredients['Ingredient'] + #$D#$A;
      tblIngredients.Next;
    end;
    dcData.Add('PossibleIngredients', sStoredIngredients);

    tblIngredients.Close;
  end;
  // Get Prompt Base
  JSONString := TFile.ReadAllText(sProjectFolder + '/StoredValues.json');
  JSONObject := (TJSONObject.ParseJSONValue(JSONString)) as TJSONObject;
  sFinalPrompt := JSONObject.GetValue<string>('sRecipePrompt');
  // Create Prompt
  for var DataTag in dcData do
  begin
    sTagStart := '<' + DataTag.Key + '>';
    stagEnd := '</' + DataTag.Key + '>';
    sDataValue := Trim(DataTag.Value);
    sFinalPrompt := sFinalPrompt + #$A + sTagStart + #$A + sDataValue +
      #$A + stagEnd;
  end;
  // Load Presets
  if bPresetExtraIng then
  begin
    sFinalPrompt := sFinalPrompt + #$A + JSONObject.GetValue<string>('sPresetExtraIng');;
  end;
  // Free JSONObject after useage
  JSONObject.Free;
  // Show Loading Form
  ShowAndCenterForm(Self, fmLoading);
  // Get Reponse
  sReponse := AskGPT(sFinalPrompt, '');
  if sReponse = '' then
  begin
    fmLoading.Hide();
    ResetButton();
    exit;
  end;
  //sReponse := TFile.ReadAllText(sProjectFolder + '\output.txt', TEncoding.ANSI);
  // Save For Debugging
  var txtFile : TextFile;
  AssignFile(txtFile, sProjectFolder + '\output.txt');
  Rewrite(txtFile);
  Writeln(txtFile, sReponse);
  CloseFile(txtFile);
  /// Seporate Tags
  // Register Tags
  dcTaggedOutput := TDictionary<string, string>.Create();
  dcTaggedOutput.Add('Method','');
  dcTaggedOutput.Add('Ingredients','');
  dcTaggedOutput.Add('Goal','');
  dcTaggedOutput.Add('Macros','');
  dcTaggedOutput.Add('Name','');
  // Extract Tags
  iMaxRetry := 3;
  iRetryCount := 0;
  repeat
    Inc(iRetryCount);
    bFormatError := false;
    // Check For Error
    iErrorDetect := Pos(sErrorTag, sReponse);
    if iErrorDetect <> 0 then
    begin
      MessageDlg(Copy(sReponse, iErrorDetect + sErrorTag.Length + 1), TMsgDlgType.mtError, [mbOk], 0);
      ResetButton();
      fmLoading.Hide();
      exit;
    end;
    // Extract Data
    for var OutputTag in dcTaggedOutput do
    begin
      sTagStart := '<' + OutputTag.Key + '>';
      sTagEnd := '</' + OutputTag.Key + '>';
      iTagStart := Pos(sTagStart, sReponse);
      iTagEnd := Pos(sTagEnd, sReponse);

      // If Incorrect Format, Get New Response and Retry Extraction
      if (iTagStart = 0) or (iTagEnd = 0) then
      begin
        sReponse := AskGPT(sFinalPrompt, '');
        if sReponse = '' then
        begin
          fmLoading.Hide();
          ResetButton();
          exit;
        end;;
        bFormatError := true;
        // Break Out Of FOR Loop. Retry Inside REPEAT Loop.
        break;
      end;

      iTagStart := iTagStart + sTagStart.Length;
      sExtractedString := Copy(sReponse, iTagStart , iTagEnd - iTagStart);

      // Trim Output and save to dictionary
      dcTaggedOutput.AddOrSetValue(OutputTag.Key, sExtractedString.Trim())
    end;
  until (not bFormatError) or (iRetryCount > iMaxRetry);
  fmLoading.Hide();
  // Check If Retry Limit Reached
  if iRetryCount > iMaxRetry then
  begin
    MessageDlg('ChatGPT Is Unable To Provide a Reponse In The Correct Format.'+#$A+
      'Please Try Again Later.', TMsgDlgType.mtError, [mbOk], 0);
    ResetButton();
    exit;
  end;
  // Display Data
  LoadRecipeScreen(dcTaggedOutput['Name'], dcTaggedOutput['Method'], dcTaggedOutput['Ingredients'], dcTaggedOutput['Goal'],
    dcTaggedOutput['Macros'], true);
  // Reset Button
  ResetButton();
end;

procedure TfmChefGPT.edtBackIconClick(Sender: TObject);
begin
  // Reset MainScreen Page Control
  pcMainScreens.ActivePageIndex := 0;
  btnTab1Click(Sender);
  spSideButtons.Visible := true;
end;

procedure TfmChefGPT.LoadRecipeButtonClick(Sender: TObject);
var
  iRecordIndex : integer;
begin
  iRecordIndex := (Sender as TImage).Parent.Tag;
  // Get Data
  with dmMainDatabase do
  begin
    tblSavedRecipes.Open;
    if tblSavedRecipes.Locate('ID', IRecordIndex, []) then
    begin
      LoadRecipeScreen(tblSavedRecipes['RecipeName'], tblSavedRecipes['Method'],
        tblSavedRecipes['Ingredients'], tblSavedRecipes['Goal'], tblSavedRecipes['Macros'], false);
    end
    else
    begin
      MessageDlg('We Could Not Load This Recipe, Please Restart Your Program.', TMsgDlgType.mtError, [mbOK], 0);
      exit;
    end;
  end;
end;

procedure TfmChefGPT.chkOnlyFridgeClick(Sender: TObject);
begin
  bPresetExtraIng := not bPresetExtraIng;
  if bPresetExtraIng then
    chkOnlyFridge.Picture.LoadFromFile(sProjectFolder + '\Images\chkPresetIngredients.png')
  else
    chkOnlyFridge.Picture.LoadFromFile(sProjectFolder + '\Images\PresetIngredients.png');
end;

procedure TfmChefGPT.btnEditSettings(Sender: TObject);
var
  redtActive : TRichEdit;
  imgNextButton, imgBackButton : TImage;
  fmClone : TfmProfileSetup;
  sFieldName : string;
begin
  // Clone Form
  fmClone := TfmProfileSetup.Create(Self);
  fmClone.bStartFromTop := false;
  // Get Button Info
  case (Sender as TImage).Tag of
    0:
    begin
     redtActive := fmClone.redtGoalInput;
     imgNextButton := fmClone.btnNextPageGoal;
     imgBackButton := fmClone.btnBackGoal;
     sFieldName := 'Goal';
    end;
    1:
    begin
     redtActive := fmClone.redtLikedFoodsInput;
     imgNextButton := fmClone.btnNextPageLF;
     imgBackButton := fmClone.btnBackLF;
     sFieldName := 'LikedFoods';
    end;
    2:
    begin
     redtActive := fmClone.redtDislikedFoodsInput;
     imgNextButton := fmClone.btnNextPageDF;
     imgBackButton := fmClone.btnBackDF;
     sFieldName := 'DislikedFoods';
    end;
    3:
    begin
     redtActive := fmClone.redtAllergiesInput;
     imgNextButton := fmClone.btnFinishSetup;
     imgBackButton := fmClone.btnBackAllergies;
     sFieldName := 'Allergies';
    end;
    else
    begin
     redtActive := fmClone.redtGoalInput;
     imgNextButton := fmClone.btnNextPageGoal;
     imgBackButton := fmClone.btnBackGoal;
     sFieldName := 'Goal';
    end;
  end;
  // Remove Back Button
  FreeAndNil(imgBackButton);
  // Modify NextPage Button
  imgNextButton.Picture.LoadFromFile(sProjectFolder + '\Images\btnSaveSetting.png');
  imgNextButton.OnClick := fmClone.btnSaveSingleField;
  // Load Data Into RichEdit
  with dmMainDatabase do
  begin
    tblProfile.Open;
    if tblProfile.RecordCount <= 0 then
    begin
      MessageDlg('Profile Record Does Not Exsist. Please Complete The First Setup Before Trying To Edit The Feilds',
        TMsgDlgType.mtError, [mbOK], 0);

      FreeAndNil(fmClone);
      tblProfile.Close;
      Exit;
    end;
    // Load
    redtActive.Lines.Text := tblProfile[sFieldName];
    tblProfile.Close;
  end;
  // Navigate To Page
  fmClone.pcSetupMenu.ActivePageIndex := imgNextButton.Tag - 1;
  // ShowAndCenterForm
  ShowAndCenterForm(Self, fmClone);
end;

// Extra Option Events
procedure TfmChefGPT.imgShowMoreOptionsMouseEnter(Sender: TObject);
var
  i : integer;
  winParent : TWinControl;
  imgButton : TImage;
begin
  imgButton := (Sender as TImage);
  winParent := imgButton.Parent;
  // Find ExtraOptions Panel
  for i := 0 to winParent.ControlCount - 1 do
  begin
    if (winParent.Controls[i].Tag = 5) and (winParent.Controls[i] is TPanel) then
    begin
      winParent.Controls[i].Visible := true;
      imgButton.Visible := false;
      Exit; // Exit as soon as the control is found
    end;
  end;
end;

procedure TfmChefGPT.pnlExtraOptionsMouseLeave(Sender: TObject);
var
  i : integer;
  winPanel : TWinControl;
  winParent : TWinControl;
begin
  winPanel := (Sender as TPanel);
  winParent := winPanel.Parent;
  // Find ExtraOptions Panel
  for i := 0 to winParent.ControlCount - 1 do
  begin
    if (winParent.Controls[i].Tag = 5) and (winParent.Controls[i] is TImage) then
    begin
      winParent.Controls[i].Visible := true;
      winPanel.Visible := false;
      Exit; // Exit as soon as the control is found
    end;
  end;
end;

procedure TfmChefGPT.imgDeleteClick(Sender: TObject);
var
  iReponse : integer;
  winParent : TWinControl;
begin
  // Show Confirm Message
  iReponse := MessageDlg('Are You Are You Want To DELETE This Recipe?'+#$A+
    'It Will Be Lost FOREVER!', TMsgDlgType.mtWarning, [mbNo, mbYes], 0);

  if iReponse = mrYes then
  begin
    winParent := (Sender as TControl).Parent.Parent;

    with dmMainDatabase do
    begin
      tblSavedRecipes.Open;
      if tblSavedRecipes.Locate('ID', winParent.Tag, []) then
      begin
        tblSavedRecipes.Delete;
        tsSavedRecipesShow(Sender);
      end
      else
        MessageDlg('An Internal Error Occured.'+#$A+'Please Restart Your Program.'+#$A+'Code: 2', TMsgDlgType.mtError, [mbOk], 0);
      tblSavedRecipes.Close;
    end;
  end
end;

// Edit Saved Ingredients
procedure TfmChefGPT.imgDeleteIngClick(Sender: TObject);
var
  iReponse : integer;
  sSelectedIng : string;
begin
  // Check Selected
  if lbSavedIngredients.ItemIndex = -1 then
  begin
    MessageDlg('Please Select Which Ingredient To Delete', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Show Conformation
  iReponse := MessageDlg('Do You Want To Delete This Ingredient?'+#$A+
    'It Will Be Lost FOREVER', TMsgDlgType.mtConfirmation, [mbNo, mbYes], 0);
  // Delete
  if iReponse = mrYes then
  begin
    with dmMainDatabase do
    begin
      tblIngredients.Open;
      sSelectedIng := lbSavedIngredients.Items[lbSavedIngredients.ItemIndex];

      if tblIngredients.Locate('Ingredient', sSelectedIng, [loCaseInsensitive]) then
        tblIngredients.Delete()
      else
        MessageDlg('We Could Not Find The Selected Ingredient In Our Database'+#$A+
          'Please Refresh This List.', TMsgDlgType.mtError, [mbOk], 0);

      tblIngredients.Close;
    end;
  end;
  // Refresh
  RefreshSavedIngredients();
end;

procedure TfmChefGPT.imgEditIngClick(Sender: TObject);
var
  sCurrentIng, sName, sMessurement, sAmount : string;
  iNameEnd, iAmountStart, iAmountEnd : integer;
  fmEditIng : TfmCreateNewIngredient;
begin
  // Check Selected
  if lbSavedIngredients.ItemIndex = -1 then
  begin
    MessageDlg('Please Select Which Ingredient To Edit', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Select Current Record
  sCurrentIng := lbSavedIngredients.Items[lbSavedIngredients.ItemIndex];
  // Create Form
  fmEditIng := TfmCreateNewIngredient.Create(Self);
  // Get Messurement Info
  iNameEnd := sCurrentIng.IndexOf(';') - 1;
  if iNameEnd > 0 then
  begin
    iAmountStart := iNameEnd + 4;
    iAmountEnd := sCurrentIng.IndexOf(' ', iAmountStart);
    // Extract Info
    sName := Copy(sCurrentIng, 0, iNameEnd);
    sAmount := Copy(sCurrentIng, iAmountStart, iAmountEnd - iAmountStart + 1);
    sMessurement := Copy(sCurrentIng, iAmountEnd+2);
    // Edit
    fmEditIng.spnAmount.Value := StrToInt(sAmount);
    case sMessurement[1] of
      'P' : fmEditIng.rgbMassurement.ItemIndex := 0;
      'm' : fmEditIng.rgbMassurement.ItemIndex := 1;
      'g' : fmEditIng.rgbMassurement.ItemIndex := 2;
    end;
    fmEditIng.rgbMassurementClick(Sender);
  end
  else
  begin
    fmEditIng.chkNoMessurement.Checked := true;
    sName := sCurrentIng;
  end;
  // General Edits
  fmEditIng.Caption := 'Edit Ingredient';
  fmEditIng.edtName.Text := sName;
  // Vars
  fmEditIng.bOverride := true;
  fmEditIng.sOriginalName := sCurrentIng;
  // Show
  ShowAndCenterForm(Self, fmEditIng);
end;

procedure TfmChefGPT.imgInputIngredientClick(Sender: TObject);
begin
  ShowAndCenterForm(Self, fmCreateNewIngredient);
  fmCreateNewIngredient.bOverride := false;
end;

procedure TfmChefGPT.imgImportImageClick(Sender: TObject);
var
  sImagePath, sPrompt, sJSONString, sReponse, sModifiedIngredient, sIngredient : string;
  JSONObject : TJSONObject;
  odOpenDialog : TOpenDialog;
  iRetryCount, iMaxRetry : integer;

  // Local Function
  function CheckForErrorReponse(sReponse : string) : boolean;
  var
    iErrorDetect : integer;
  const
    sErrorTag = '[ERROR]';
  begin
    iErrorDetect := Pos(sErrorTag, sReponse);
    if iErrorDetect <> 0 then
    begin
      MessageDlg(Copy(sReponse, iErrorDetect + sErrorTag.Length + 1), TMsgDlgType.mtError, [mbOk], 0);
      fmLoading.Hide();
      Result := true;
      exit;
    end;
    Result := false;
  end;
begin
  // Select Image
  odOpenDialog := TOpenDialog.Create(nil);
  try
    odOpenDialog.Filter := 'Image Files|*.jpg;*.jpeg;*.png*';
    odOpenDialog.Title := 'Select an Image';
    // Show the dialog and check if the user selected a file
    if odOpenDialog.Execute then
    begin
      // Get the selected file path
      sImagePath := odOpenDialog.FileName;
    end
    else
      exit;
  finally
    odOpenDialog.Free;
  end;
  // Validate Path
  if not FileExists(sImagePath) then
  begin
    MessageDlg('We''re Unable To Find The Selected Image. Please Try Again With a Diffrent Image',
      TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Get Prompt
  sJSONString := TFile.ReadAllText(sProjectFolder + '\StoredValues.json');
  JSONObject := TJSONObject.ParseJSONValue(sJSONString) as TJSONObject;
  sPrompt := JSONObject.GetValue<string>('sImagePrompt');
  JSONObject.Free;
  // Show loading
  ShowAndCenterForm(Self, fmLoading);
  // Send To Gpt
  sReponse := AskGPT(sPrompt, sImagePath);
  if sReponse = '' then
  begin
    fmLoading.Hide();
    exit;
  end;
  // Check For Error
  if CheckForErrorReponse(sReponse) then
    exit;
  // Split, Use 'var' to automaticly create a array the right length.
  var arrIngredients := sReponse.Split([#$A]);
  iMaxRetry := 3;
  iRetryCount := 0;
  while (Length(arrIngredients) <= 0) and (iRetryCount <= iMaxRetry) do
  begin
    inc(iRetryCount);
    // Check For Error
    if CheckForErrorReponse(sReponse) then
      exit;

    // Retry
    sReponse := AskGPT(sPrompt, sImagePath);
    arrIngredients := sReponse.Split([#$A]);
  end;
  // Check If Retry Limit Reached
  if iRetryCount > iMaxRetry then
  begin
    MessageDlg('ChatGPT Is Unable To Provide a Reponse In The Correct Format.'+#$A+
      'Please Try Again Later.', TMsgDlgType.mtError, [mbOk], 0);
    fmLoading.Hide();
    exit;
  end;
  // List In Listbox
  lbRegonizedIngredients.Items.Clear;
  for sIngredient in arrIngredients do
  begin
    sModifiedIngredient := sIngredient;
    if sModifiedIngredient.Length > 1 then
    begin
      if (sModifiedIngredient[1] = '-') or (sModifiedIngredient[1] = '•') then
        Delete(sModifiedIngredient, 1, 1);
      sModifiedIngredient := sModifiedIngredient.Trim();

      lbRegonizedIngredients.Items.Add(sModifiedIngredient);
    end;
  end;
  // Close Loading
  fmLoading.Hide();
end;

procedure TfmChefGPT.imgAddIngredientClick(Sender: TObject);
var
  sSelectedIngredient : string;
  iItemIndex : integer;
begin
  // Check Selected
  if lbRegonizedIngredients.ItemIndex = -1 then
  begin
    MessageDlg('Please Select Which Ingredient To Save', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Get Ingredient
  iItemIndex := lbRegonizedIngredients.ItemIndex;
  sSelectedIngredient := lbRegonizedIngredients.Items[iItemIndex];
  // Check Ingredient
  if sSelectedIngredient = '' then
  begin
    MessageDlg('Please Scan In a Image To Display Recognised Ingredients', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Save To Database
  with dmMainDatabase do
  begin
    tblIngredients.Open;
    try
      tblIngredients.Append;
      tblIngredients['Ingredient'] := sSelectedIngredient;
      tblIngredients.Post;
    except
      MessageDlg('We Were Unable To Add The Ingredient To The Database'+#$A+
        'Please Ensure The Database Is Not In Use Somewhere Else', TMsgDlgType.mtError, [mbOk], 0);
      tblIngredients.Cancel;
    end;
    tblIngredients.Close;
  end;
  // Remove From List
  lbRegonizedIngredients.Items.Delete(iItemIndex);
  // Refresh
  RefreshSavedIngredients();
end;

// Save Recipes
procedure TfmChefGPT.imgRecipeImageClick(Sender: TObject);
var
  odOpenDialog : TOpenDialog;
begin
  odOpenDialog := TOpenDialog.Create(nil);
  try
    odOpenDialog.Filter := 'Image Files|*.bmp;*.jpg;*.jpeg;*.png*';
    odOpenDialog.Title := 'Select an Image';
    // Show the dialog and check if the user selected a file
    if odOpenDialog.Execute then
    begin
      // Get the selected file path
      sUploadedImagePath := odOpenDialog.FileName;
      // Load the selected image into the TImage component
      imgRecipeImage.Picture.LoadFromFile(sUploadedImagePath);
    end;
  finally
    odOpenDialog.Free;
  end;
end;

procedure TfmChefGPT.pnlCloseClick(Sender: TObject);
begin
  pnlSavePopup.Visible := false;
end;

procedure TfmChefGPT.pnlSaveClick(Sender: TObject);
var
  sImageDescPath, sImageNameNoExt, sImageExt, sName, sPrevImage : string;
  iCounter, iResponse : integer;
  bOverride : boolean;
begin
  bOverride := false;
  // Check Name Input
  sName := edtRecipeName.Text;
  if sName = '' then
  begin
    MessageDlg('Please Enter a Name For Your Recipe', TMsgDlgType.mtError, [mbOk], 0);
    exit;
  end;
  // Check If Not Exsisting Name
  with dmMainDatabase do
  begin
    tblSavedRecipes.Open;
    // This will also select the record to override if overriden is selected.
    if (tblSavedRecipes.RecordCount > 0) and (tblSavedRecipes.Locate('RecipeName', sName, [loCaseInsensitive])) then
    begin
      iResponse := MessageDlg('Name Already In Use. Do you want to OVERRIDE it?', TMsgDlgType.mtConfirmation, [mbNo, mbYes], 0);
      if (iResponse = mrNo) or (iResponse = mrNone) then
      begin
        MessageDlg('Recipe Has NOT Been Saved', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
        tblSavedRecipes.Close;
        exit;
      end;
      bOverride := true;
    end;
  end;
  // Check Recipe Data Is Stored
  if sCurrentRecipeName = '' then
  begin
    MessageDlg('An Internal Error Occured. Recipe Not Stored In Memory.'+#$A+'Please Restart Your Program', TMsgDlgType.mtError, [mbOk], 0);
    dmMainDatabase.tblSavedRecipes.Close;
    exit;
  end;
  // Select Defualt Image (and check exsist)
  if sUploadedImagePath = '' then
  begin
    sUploadedImagePath := sDefaultImage;
    if not FileExists(sUploadedImagePath) then
    begin
      MessageDlg('Default Image Cannot Be Loaded. Please Select a Image For Your Recipe', TMsgDlgType.mtError, [mbOk], 0);
      dmMainDatabase.tblSavedRecipes.Close;
      exit;
    end;
  end;
  // Ensure Select File Exsists
  if not FileExists(sUploadedImagePath) then
  begin
    MessageDlg('Image Cannot Be Loaded. Please Use a Different Image In *Png, Jpeg or Bmp Format*', TMsgDlgType.mtError, [mbOk], 0);
    dmMainDatabase.tblSavedRecipes.Close;
    exit;
  end;
  // Copy Over Uploaded Image (dont copy default image) (and avoid Name collition)
  if not (sUploadedImagePath = sDefaultImage) then
  begin
    sImageDescPath := sImagesFolder + TPath.GetFileName(sUploadedImagePath);
    sImageNameNoExt := TPath.GetFileNameWithoutExtension(sUploadedImagePath);
    sImageExt := TPath.GetExtension(sUploadedImagePath);
    iCounter := 1;
    while TFile.Exists(sImageDescPath) do
    begin
      // If a file exists, modify the file name by appending a counter
      sImageDescPath := TPath.Combine(sImagesFolder,
        sImageNameNoExt + iCounter.ToString() + sImageExt);
      Inc(iCounter);
    end;
    try
      TFile.Copy(sUploadedImagePath, sImageDescPath);
    except
      MessageDlg('An Error Accored While Copying Over The Selected Image'+#$A+
        'Please Try a Diffrent Image.', TMsgDlgType.mtError, [mbOk], 0);
      dmMainDatabase.tblSavedRecipes.Close;
      exit;
    end;
  end;
  // Delete Old Image, If Overriding
  if bOverride then
  begin
    with dmMainDatabase do
    begin
      sPrevImage := TPath.Combine(sImagesFolder, dmMainDatabase.tblSavedRecipes['CoverImg']);
    end;
    if FileExists(sPrevImage) then
    begin
      try
        DeleteFile(sPrevImage);
      except
        iResponse := MessageDlg('An Error Occured While Deleting The Old Cover Image.'+#$A+
          'Please Ensure The Image File Is Not Being Used In Another Program'+#$A+
            'DO YOU WANT TO CONTINUE WITHOUT DELETING THE OLD IMAGE?'+#$A+
              'YES - Save Current Recipe Without Deleting Old CoverImg'+#$A+
                'NO - Cancel This Save Oporation', TMsgDlgType.mtError, [mbNo, mbYes], 0);
        if (iResponse = mrNo) or (iResponse = mrNone) then
        begin
          MessageDlg('Recipe Has NOT Been Saved', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
          dmMainDatabase.tblSavedRecipes.Close;
          exit;
        end;
      end;
    end;
  end;
  // Save To Table
  with dmMainDatabase do
  begin
    if bOverride then
      tblSavedRecipes.Edit()
    else
      tblSavedRecipes.Append();
    try
      tblSavedRecipes['RecipeName'] := sName;
      tblSavedRecipes['CoverImg'] := TPath.GetFileName(sImageDescPath);
      tblSavedRecipes['Method'] := ExtractRawRTF(redtMethod);
      tblSavedRecipes['Ingredients'] := ExtractRawRTF(redtListIngredients);
      tblSavedRecipes['Goal'] := ExtractRawRTF(redtGoal);
      tblSavedRecipes['Macros'] := ExtractRawRTF(redtMacros);
      tblSavedRecipes.Post;
    except
      // If there is an error, cancel the append operation
      tblSavedRecipes.Cancel;
      MessageDlg('an Error Occurred While Saving Your Recipe. Please Try Again', TMsgDlgType.mtError, [mbOk], 0);
      tblSavedRecipes.Close;
      exit;
    end;
    tblSavedRecipes.Close;
  end;
  // Display Message
  MessageDlg('Your Recipe Has Been Saved!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  pnlSavePopup.Visible := false;
end;

procedure TfmChefGPT.imgSaveIconClick(Sender: TObject);
begin
  // Load GUI
  edtRecipeName.Text := sCurrentRecipeName;
  imgRecipeImage.Picture.LoadFromFile(sProjectFolder + '\Images\UploadImage.png');
  sUploadedImagePath := '';
  pnlSavePopup.Visible := true;
  edtRecipeName.SetFocus;
end;

// Prompt Gen Wizard
procedure TfmChefGPT.btnStartMealDescClick(Sender: TObject);
var
  JSONString : string;
  jsonJSONObject, jsonGenorateWizard : TJSONObject;
begin
  // Get JSON Object
  JSONString := TFile.ReadAllText(sProjectFolder + '\StoredValues.json');
  jsonJSONObject := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  fmPromptWizard.jsonQuestions := jsonJSONObject.GetValue<TJsonObject>('GenorateWizard');
  // Set Output
  fmPromptWizard.redtOutput := redtMealDescription;
  fmPromptWizard.sImagesPath := sProjectFolder + '\Images\';
  // Show Form
  fmPromptWizard.pcPages.ActivePageIndex := 0;
  ShowAndCenterForm(Self, fmPromptWizard);
end;

// Richedit Edits FOR ADMIN (verskooning vir 2 users)
procedure TfmChefGPT.imgToggleLockRecipeClick(Sender: TObject);
var
  iReponse : integer;
  sInputPass : string;
begin
  if bRecipeLocked then
  begin
    iReponse := MessageDlg('You Need To Be An Admin To Edit The Recipe Feilds.'+#$A+
      'Press OK To Continue To Enter The Password', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0);
    if iReponse = mrOk then
    begin
      sInputPass := Inputbox('Enter The Admin Password', 'Please Enter The Admin Password', '');
      if sInputPass.ToLower() = sLockPassword.ToLower() then
      begin
        ToggleFieldLocks(false, 'UnlockIcon.png');
      end
      else
        MessageDlg('Incorrect Password!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    end;
  end
  else
    ToggleFieldLocks(true, 'LockIcon.png');

  bRecipeLocked := not bRecipeLocked;
end;

/// TabSwitches
// MainScreen
procedure TfmChefGPT.btnTab1Click(Sender: TObject);
begin
  pcMainScreens.ActivePageIndex := 0; // Switch to first tab
  btnTab1.Color := clMSScelectedColor;
  btnTab2.Color := clMSUnselectedColor;
  btnTab3.Color := clMSUnselectedColor;
  spSettingsBackground.Brush.Color := clMSUnselectedColor;
  tsSavedRecipesShow(Sender);
end;
procedure TfmChefGPT.btnTab2Click(Sender: TObject);
begin
  pcMainScreens.ActivePageIndex := 1; // Switch to second tab
  btnTab1.Color := clMSUnselectedColor;
  btnTab2.Color := clMSScelectedColor;
  btnTab3.Color := clMSUnselectedColor;
  spSettingsBackground.Brush.Color := clMSUnselectedColor;
end;
procedure TfmChefGPT.btnTab3Click(Sender: TObject);
begin
  pcMainScreens.ActivePageIndex := 2; // Switch to third tab
  btnTab1.Color := clMSUnselectedColor;
  btnTab2.Color := clMSUnselectedColor;
  btnTab3.Color := clMSScelectedColor;
  spSettingsBackground.Brush.Color := clMSUnselectedColor;

  RefreshSavedIngredients();
end;
procedure TfmChefGPT.btnTab4Click(Sender: TObject);
begin
  pcMainScreens.ActivePageIndex := 4; // Switch to third tab
  btnTab1.Color := clMSUnselectedColor;
  btnTab2.Color := clMSUnselectedColor;
  btnTab3.Color := clMSUnselectedColor;
  spSettingsBackground.Brush.Color := clMSScelectedColor;

  RefreshSettingsText();
end;

// Subscreen
procedure TfmChefGPT.btnGoalClick(Sender: TObject);
begin
  pcSidePanel.ActivePageIndex := 1; // Switch to first tab
  btnGoal.Color := clSSSelectedColor;
  btnListIng.Color := clSSUnselectedColor;
  btnMacros.Color := clSSUnselectedColor;
end;
procedure TfmChefGPT.btnListIngClick(Sender: TObject);
begin
  pcSidePanel.ActivePageIndex := 0; // Switch to Second tab
  btnGoal.Color := clSSUnselectedColor;
  btnListIng.Color := clSSSelectedColor;
  btnMacros.Color := clSSUnselectedColor;
end;
procedure TfmChefGPT.btnMacrosClick(Sender: TObject);
begin
  pcSidePanel.ActivePageIndex := 2; // Switch to Third tab
  btnGoal.Color := clSSUnselectedColor;
  btnListIng.Color := clSSUnselectedColor;
  btnMacros.Color := clSSSelectedColor;
end;

end.

