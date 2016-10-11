program CentreBulls;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDB in 'UnitDB.pas' {DataMdl: TDataModule},
  UnitAddBull in 'UnitAddBull.pas' {FormAddBull},
  UnitVariables in 'UnitVariables.pas',
  UnitAddKatForBull in 'UnitAddKatForBull.pas' {FormAddKat},
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitListCategory in 'UnitListCategory.pas' {FormListCategory},
  UnitImportFromExcel in 'UnitImportFromExcel.pas' {FormImportFromExcel},
  UnitSprav in 'UnitSprav.pas' {FormSprav},
  UnitAddRegion in 'UnitAddRegion.pas' {FormAddRegion},
  UnitAddRajon in 'UnitAddRajon.pas' {FormAddNewRajon},
  UnitAddNewOrg in 'UnitAddNewOrg.pas' {FormAddNewOrg},
  UnitAddPor in 'UnitAddPor.pas' {FormAddPor},
  UnitAddLinia in 'UnitAddLinia.pas' {FormAddLinia},
  UnitAddStr in 'UnitAddStr.pas' {FormAddStr},
  UnitOkrug in 'UnitOkrug.pas' {FormOkrug},
  UnitAddCategory in 'UnitAddCategory.pas' {FormCategory},
  UnitAbout in 'UnitAbout.pas' {AboutBox},
  UnitExchange in 'UnitExchange.pas' {FormExchange};

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TDataMdl, DataMdl);
  Application.CreateForm(TFormListCategory, FormListCategory);
  Application.CreateForm(TFormImportFromExcel, FormImportFromExcel);
  Application.CreateForm(TFormSprav, FormSprav);
  Application.CreateForm(TFormAddRegion, FormAddRegion);
  Application.CreateForm(TFormAddNewRajon, FormAddNewRajon);
  Application.CreateForm(TFormAddNewOrg, FormAddNewOrg);
  Application.CreateForm(TFormAddPor, FormAddPor);
  Application.CreateForm(TFormAddLinia, FormAddLinia);
  Application.CreateForm(TFormAddStr, FormAddStr);
  Application.CreateForm(TFormOkrug, FormOkrug);
  Application.CreateForm(TFormCategory, FormCategory);
  Application.CreateForm(TFormExchange, FormExchange);
  FormLogin := TFormLogin.Create(Application);
  FormLogin.ShowModal;
  if isTest then
  begin
    Application.CreateForm(TFormAddBull, FormAddBull);
    Application.CreateForm(TFormAddKat, FormAddKat);
    Application.Run;
  end;
end.
