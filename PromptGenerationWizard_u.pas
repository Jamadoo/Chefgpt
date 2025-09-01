unit PromptGenerationWizard_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Samples.Spin, JSON, Vcl.CheckLst, Math;

type
  TfmPromptWizard = class(TForm)
    pcPages: TPageControl;
    tsStartPage: TTabSheet;
    tsDynamicPage: TTabSheet;
    pnlStartBng: TPanel;
    pblInfoBng: TPanel;
    redtDesc: TRichEdit;
    lblTitle: TLabel;
    btnStartSteps: TImage;
    lblStart: TLabel;
    lblSubTitle: TLabel;
    pnlMainBng: TPanel;
    lblQeustion: TLabel;
    pblQeustionBorder: TPanel;
    rbgInput: TRadioGroup;
    btnNextQuestion: TImage;
    btnPreviousQuestion: TImage;
    pnlSpinEditInput: TPanel;
    lblSpinCaption: TLabel;
    spnInput: TSpinEdit;
    pnlRadiogroupInput: TPanel;
    edtRadioOther: TEdit;
    pnlCheckedInput: TPanel;
    edtCheckedOther: TEdit;
    clbCheckListInput: TCheckListBox;
    gpCheckedBorder: TGroupBox;
    pnlRichEditInput: TPanel;
    lblCaption: TLabel;
    redtInput: TRichEdit;
    procedure btnStartStepsClick(Sender: TObject);
    procedure SwitchQuestion(iQuestionIndex : integer);
    procedure btnNextQuestionClick(Sender: TObject);
    procedure btnPreviousQuestionClick(Sender: TObject);
    procedure AskForSkip();
    procedure NextScreen();
    procedure LoadPreviousData(sPreviousData : string);
  private
    jsonCurrentObject : TJsonObject;
    iCurrentIndex : integer;
    lsOptions : TStringList;
  public
    jsonQuestions : TJSONObject;
    redtOutput : TRichEdit;
    sImagesPath : string;
  end;

var
  fmPromptWizard: TfmPromptWizard;

implementation

{$R *.dfm}

// Custom Procedures
procedure TfmPromptWizard.SwitchQuestion(iQuestionIndex : integer);
var
  arrOptions : TJSONArray;
  sQuestion, sComponent : string;
  i, iItemHeight, iRows, iNewHeight, iTotalItems: integer;
begin
  // Get JSON Object
  jsonCurrentObject := jsonQuestions.GetValue<TJsonObject>(iQuestionIndex.ToString());
  // Set Qeustion
  sQuestion := jsonCurrentObject.GetValue<string>('Question');
  lblQeustion.Caption := sQuestion;
  // Set And Reset Input
  sComponent := jsonCurrentObject.GetValue<string>('Component');
  if sComponent = 'Radiogroup' then
  begin
    // Clear RBG
    rbgInput.Items.Clear;
    // Give Options
    arrOptions := jsonCurrentObject.GetValue<TJSONArray>('Options');
    for i := 0 to arrOptions.Count - 1 do
    begin
      rbgInput.Items.Add(arrOptions.Items[i].Value);
    end;
    rbgInput.Items.Add('Other');
    rbgInput.ItemIndex := -1;
    rbgInput.Columns := Ceil(rbgInput.Items.Count / 3);
    edtRadioOther.Text := '';
    // Only Show RBG
    pnlRadiogroupInput.Visible := true;
    pnlSpinEditInput.Visible := false;
    pnlRichEditInput.Visible := false;
    pnlCheckedInput.Visible := false;
  end
  else if sComponent = 'CheckGroup' then
  begin
    // Clear RBG
    clbCheckListInput.Items.Clear;
    // Begin Update, to aviod scrollbar inconsistenties
    clbCheckListInput.Items.BeginUpdate();
    // Give Options
    arrOptions := jsonCurrentObject.GetValue<TJSONArray>('Options');
    for i := 0 to arrOptions.Count - 1 do
    begin
      clbCheckListInput.Items.Add(arrOptions.Items[i].Value);
    end;
    clbCheckListInput.Items.Add('Other');
    clbCheckListInput.CheckAll(cbUnchecked, true, true);
    edtCheckedOther.Text := '';
    // Calcualte Coloumns
    clbCheckListInput.Columns := Ceil(clbCheckListInput.Items.Count / 3);
    // Only Show RBG
    pnlRadiogroupInput.Visible := false;
    pnlSpinEditInput.Visible := false;
    pnlRichEditInput.Visible := false;
    pnlCheckedInput.Visible := true;
    // Send Update
    clbCheckListInput.Items.EndUpdate();
  end
  else if sComponent = 'SpinEdit' then
  begin
    // Clear SpinEdt
    spnInput.Value := 0;
    // Only Show Spinedt
    pnlRadiogroupInput.Visible := false;
    pnlSpinEditInput.Visible := true;
    pnlRichEditInput.Visible := false;
    pnlCheckedInput.Visible := false;
  end
  else if sComponent = 'Edit' then
  begin
    // Clear SpinEdt
    redtInput.Lines.Clear;
    // Only Show Spinedt
    pnlRadiogroupInput.Visible := false;
    pnlSpinEditInput.Visible := false;
    pnlRichEditInput.Visible := true;
    pnlCheckedInput.Visible := false;
  end;
end;

procedure TfmPromptWizard.AskForSkip();
var
  iReponse : integer;
begin
  iReponse := MessageDlg('Do You Want To Skip This Question?',
    TMsgDlgType.mtError, [mbNo, mbYes], 0);

  if iReponse = mrYes then
  begin
    NextScreen();
  end;
  exit;
end;

procedure TfmPromptWizard.NextScreen();
var
  sCurrentString : string;
begin
  if iCurrentIndex < jsonQuestions.Count then
  begin
    inc(iCurrentIndex);
    SwitchQuestion(iCurrentIndex);
    // Check If Last Question
    if iCurrentIndex = jsonQuestions.Count then
      btnNextQuestion.Picture.LoadFromFile(sImagesPath + 'btnFinishQuestions.png');
  end
  else
  begin
    // Return Output
    redtOutput.Lines.Clear;
    for sCurrentString in lsOptions do
    begin
      redtOutput.Lines.Add(sCurrentString);
    end;
    // Display Message
    MessageDlg('Prompt Has Been Genorated!!', TMsgDlgType.mtInformation, [mbOK], 0);
    // Close
    fmPromptWizard.Hide();
  end;
end;

procedure TfmPromptWizard.LoadPreviousData(sPreviousData : string);
var
  sComponent, sCurrItem, sCurrCopy : string;
  i, iCheckedIndex, iOtherIndex, iConvertedInt, iCurrLength, iTestInt : integer;
  bIntToStr : boolean;
begin
  sComponent := jsonCurrentObject.GetValue<string>('Component');
  // Load Corrosponding Input
  if sComponent = 'Radiogroup' then
  begin
    // Check Listed Value
    for i := 0 to rbgInput.Items.Count-1 do
    begin
      if rbgInput.Items[i] = sPreviousData then
      begin
        rbgInput.ItemIndex := i;
        break;
      end;
    end;
    // Check If Other Is Selected
    iOtherIndex := rbgInput.Items.IndexOf('Other');
    if (rbgInput.ItemIndex < 0) and (iOtherIndex >= 0) then
    begin
      rbgInput.ItemIndex := iOtherIndex;
      edtRadioOther.Text := sPreviousData;
    end;
  end
  else if sComponent = 'CheckGroup' then
  begin
    // Split by ', ' ; Into a array which delphi will decide
    var CheckedOptions := sPreviousData.Split([', ']);
    iOtherIndex := clbCheckListInput.Items.IndexOf('Other');
    for sCurrItem in CheckedOptions do
    begin
      iCheckedIndex := clbCheckListInput.Items.IndexOf(sCurrItem);
      // Check Listed Option
      if iCheckedIndex >= 0 then
      begin
        clbCheckListInput.Checked[iCheckedIndex] := true;
      end
      // Add Other Checked Option
      else if iOtherIndex >= 0 then
      begin
        clbCheckListInput.Checked[iOtherIndex] := true;
        edtCheckedOther.Text := sCurrItem;
      end;
    end;
  end
  else if sComponent = 'SpinEdit' then
  begin
    iConvertedInt := 0;
    iCurrLength := 1;
    bIntToStr := true;
    while bIntToStr do
    begin
      sCurrCopy := Copy(sPreviousData, 0, iCurrLength);
      bIntToStr := TryStrToInt(sCurrCopy, iTestInt);
      if bIntToStr then
      begin
        iConvertedInt := iTestInt;
        inc(iCurrLength);
      end
    end;

    spnInput.Value := iConvertedInt;
  end
  else if sComponent = 'Edit' then
  begin
    redtInput.Lines.Text := sPreviousData;
  end;
end;

// Events
procedure TfmPromptWizard.btnNextQuestionClick(Sender: TObject);
var
  sActiveInput, sInput, sItemString, sPromptString : string;
  iReponse, iAmountChecked, i : integer;
begin
  if iCurrentIndex <= jsonQuestions.Count then
  begin
    /// Save Input
    sInput := '';
    // Get Active Input
    sActiveInput := jsonCurrentObject.GetValue<string>('Component');
    // Get Selection
    if sActiveInput = 'Radiogroup' then
    begin
      // Ask For Skip
      if rbgInput.ItemIndex = -1 then
      begin
        AskForSkip();
        exit;
      end;

      // Set Input
      sInput := rbgInput.Items[rbgInput.ItemIndex];
      if (sInput = 'Other') and (edtRadioOther.Text <> '') then
      begin
        sInput := edtRadioOther.Text;
      end;
    end
    else if sActiveInput = 'CheckGroup' then
    begin
      // Get All Checked Items (Input)
      iAmountChecked := 0;
      for i := 0 to clbCheckListInput.Count - 1 do
      begin
        if clbCheckListInput.Checked[i] then
        begin
          sItemString :=  clbCheckListInput.Items[i];
          if (sItemString = 'Other') and (edtCheckedOther.Text <> '') then
          begin
            sInput := sInput + edtCheckedOther.Text + ', ';
          end
          else
            sInput := sInput + sItemString + ', ';
          inc(iAmountChecked)
        end;
      end;

      // Ask For Skip
      if iAmountChecked <= 0 then
      begin
        AskForSkip();
        exit;
      end;

      // Remove Last ', '
      Delete(sInput, sInput.Length-1, 2)
    end
    else if sActiveInput = 'Edit' then
    begin
      // Ask For Skip
      if redtInput.Lines.Text = '' then
      begin
        AskForSkip();
        exit;
      end;

      // Get Input
      sInput := redtInput.Lines.Text;
    end
    else if sActiveInput = 'SpinEdit' then
    begin
      // Ask For Skip
      if spnInput.Value <= 0 then
      begin
        AskForSkip();
        exit;
      end;

      // Get Input
      sInput := spnInput.Value.ToString;
    end;
    sInput := sInput.Trim();
    sInput := '"' + sInput + '"';
    // Create PromptString
    sPromptString := jsonCurrentObject.GetValue<string>('PromptString');
    sPromptString := sPromptString.Replace('*', sInput);
    // Add To List
    lsOptions.Add(sPromptString);
    // Switch Screen
    NextScreen();
  end;
end;

procedure TfmPromptWizard.btnPreviousQuestionClick(Sender: TObject);
var
  sPromptString, sPrevData, sCurrentOption : string;
  i, iStarIndex : integer;
begin
  if iCurrentIndex > 1 then
  begin
    dec(iCurrentIndex);
    SwitchQuestion(iCurrentIndex);
    btnNextQuestion.Picture.LoadFromFile(sImagesPath + 'BtnNextQuestion.png');

    // Get Option To Remove
    sPromptString := jsonCurrentObject.GetValue<string>('PromptString');
    iStarIndex := Pos('*', sPromptString);
    sPrevData := Copy(sPromptString, 0, iStarIndex);
    sPromptString := Copy(sPromptString, 0, iStarIndex-1);
    // Remove Option and Load Previous Data
    for i := 0 to lsOptions.Count - 1 do
    begin
      sCurrentOption := lsOptions[i];
      if Pos(sPromptString, sCurrentOption) > 0 then
      begin
        // Get Previous Data
        sPrevData := Copy(sCurrentOption, iStarIndex);
        sPrevData := Copy(sPrevData, 2, sPrevData.Length-2);
        LoadPreviousData(sPrevData);
        // Delete Option
        lsOptions.Delete(i);
      end;
    end;
  end;
end;

procedure TfmPromptWizard.btnStartStepsClick(Sender: TObject);
begin
  // Create New List
  lsOptions := TStringList.Create();
  // Load Button
  btnNextQuestion.Picture.LoadFromFile(sImagesPath + 'BtnNextQuestion.png');
  // Start First Question
  iCurrentIndex := 1;
  SwitchQuestion(iCurrentIndex);
  // Show Page
  pcPages.ActivePageIndex := 1;
end;

end.
