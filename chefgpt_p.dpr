program chefgpt_p;

uses
  Vcl.Forms,
  chefgpt_u in 'chefgpt_u.pas' {fmChefGPT},
  ProfileSetup_u in 'ProfileSetup_u.pas' {fmProfileSetup},
  dmMainDatabase_u in 'dmMainDatabase_u.pas' {dmMainDatabase: TDataModule},
  Loading_u in 'Loading_u.pas' {fmLoading},
  CreateNewIngrdient_u in 'CreateNewIngrdient_u.pas' {fmCreateNewIngredient},
  PromptGenerationWizard_u in 'PromptGenerationWizard_u.pas' {fmPromptWizard};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmChefGPT, fmChefGPT);
  Application.CreateForm(TfmProfileSetup, fmProfileSetup);
  Application.CreateForm(TdmMainDatabase, dmMainDatabase);
  Application.CreateForm(TfmLoading, fmLoading);
  Application.CreateForm(TfmCreateNewIngredient, fmCreateNewIngredient);
  Application.CreateForm(TfmPromptWizard, fmPromptWizard);
  Application.Run;
end.
