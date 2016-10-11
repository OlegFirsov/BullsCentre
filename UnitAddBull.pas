unit UnitAddBull;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, System.RegularExpressions;

type
  TFormAddBull = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbRegion: TComboBox;
    cbRajon: TComboBox;
    cbHoz: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtNickname: TEdit;
    edtInvnum: TEdit;
    cbLine: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    meDateBirthday: TMaskEdit;
    cbCountry: TComboBox;
    btnSave: TButton;
    Label9: TLabel;
    cbCategoryF: TComboBox;
    Label10: TLabel;
    edtInvnumF: TEdit;
    Label11: TLabel;
    edtNicknameF: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtNicknameM: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    edtInvnumM: TEdit;
    Label17: TLabel;
    edtNumMaxLactM: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    edtUdoyM: TEdit;
    edtRichM: TEdit;
    edtBelokM: TEdit;
    Label21: TLabel;
    cbCategoryGF: TComboBox;
    Label22: TLabel;
    edtInvnumGF: TEdit;
    Label23: TLabel;
    edtNicknameGF: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    cbPoroda: TComboBox;
    btnGoKat: TButton;
    Label26: TLabel;
    cbStatus: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure cbRegionSelect(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtRichMKeyPress(Sender: TObject; var Key: Char);
    procedure edtUdoyMKeyPress(Sender: TObject; var Key: Char);
    procedure edtUdoyMExit(Sender: TObject);
    procedure edtRichMExit(Sender: TObject);
    procedure cbRajonSelect(Sender: TObject);
    procedure cbHozSelect(Sender: TObject);
    procedure cbLineSelect(Sender: TObject);
    procedure cbCategoryFSelect(Sender: TObject);
    procedure cbCategoryGFSelect(Sender: TObject);
    procedure cbCountrySelect(Sender: TObject);
    procedure cbPorodaSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CleanControls();
    procedure CleanAllControls();
    procedure meDateBirthdayExit(Sender: TObject);
    procedure btnGoKatClick(Sender: TObject);
  private
    { Private declarations }
    procedure CMDialogKey(var Msg:TWMKey);message CM_DIALOGKEY;
    function BoollIsUniq(): Boolean;
  public
    { Public declarations }
  end;



var
  FormAddBull: TFormAddBull;

implementation

{$R *.dfm}

uses UnitDB, UnitMain, UnitVariables, UnitAddKatForBull, UnitListCategory;

procedure TFormAddBull.CMDialogKey(var Msg:TWMKey);//переход между ячейками по Enter или Tab
begin
  if not (ActiveControl is TButton) then
  if Msg.Charcode = 13 then
  Msg.Charcode := 9;
  inherited;
end;

//очистить контролы ввода, остаются регион, район, организация и порода
procedure TFormAddBull.CleanControls();
var
  i: Integer;
begin
    for i := 0 to FormAddBull.ComponentCount - 1 do
    begin
      if (FormAddBull.Components[i] is TComboBox) and ((FormAddBull.Components[i] as TComboBox).Tag = 0) then
        (FormAddBull.Components[i] as TComboBox).ItemIndex := -1;
      if (FormAddBull.Components[i] is TEdit) then
        (FormAddBull.Components[i] as TEdit).Text := '';
      if (FormAddBull.Components[i] is TMaskEdit) then
        (FormAddBull.Components[i] as TMaskEdit).Text := '  .  .    ';
    end;
end;

//очистить все контролы ввода
procedure TFormAddBull.CleanAllControls();
var
  i: Integer;
begin
    for i := 0 to FormAddBull.ComponentCount - 1 do
    begin
      if (FormAddBull.Components[i] is TComboBox) then
        (FormAddBull.Components[i] as TComboBox).ItemIndex := -1;
      if (FormAddBull.Components[i] is TEdit) then
        (FormAddBull.Components[i] as TEdit).Text := '';
      if (FormAddBull.Components[i] is TMaskEdit) then
        (FormAddBull.Components[i] as TMaskEdit).Text := '  .  .    ';
    end;
end;

//сохранить быка
procedure TFormAddBull.btnGoKatClick(Sender: TObject);
begin
  if idBull <> '' then
  begin
    //окрываем форму для добавления категории для этого быка
    if not Assigned(FormAddKat) then
      FormAddKat := TFormAddKat.Create(Application);
    FormAddKat.ShowModal;
    isEditCategory := False;
  end
  else
    Application.MessageBox('А какой бык?', 'Информация', MB_OK);
end;

procedure TFormAddBull.btnSaveClick(Sender: TObject);
var
  i: integer;
  testEmptyEnter: boolean;
//  temp: String;
begin
  //проверить - заполнены ли все поля кроме кличек всех предков
  testEmptyEnter := false;
  for i := 0 to FormAddBull.ComponentCount - 1 do
    begin
      if (FormAddBull.Components[i] is TComboBox) then
        if Trim((FormAddBull.Components[i] as TComboBox).Text) = ''   then
          begin
            testEmptyEnter := true;
            break;
          end;
      if (FormAddBull.Components[i] is TEdit) then
        if Trim((FormAddBull.Components[i] as TEdit).Text) = ''   then
          begin
          //кличка у отца,матери,деда может быть пустой
          if (FormAddBull.Components[i] as TEdit).Tag <> 100  then
            begin
              testEmptyEnter := true;
              break;
            end;
          end;
      if (FormAddBull.Components[i] is TMaskEdit) then
        if (FormAddBull.Components[i] as TMaskEdit).Text = '  .  .    '   then
          testEmptyEnter := true;
    end;
    if (testEmptyEnter = true) then
    begin
      Application.MessageBox('Не все поля заполнены!', 'Информация', MB_OK);
      exit;
    end;

//если это редактирование - обновляем существующий и выходим из процедуры
if isEditBull then
begin
with dataMdl do
  begin
    if TBull.UpdateBull(DataMdl.ADOQuerySprav,idBull,cbStatus.text,kodregion,kodrajon,kodhoz,Trim(edtNickname.Text),Trim(edtInvnum.Text),kodpor,kodline,gr,meDateBirthday.Text,
      kodcountry,Trim(edtNicknameF.Text),Trim(edtInvnumF.Text),kodkatf,Trim(edtNicknameM.Text),
      Trim(edtInvnumM.Text),Trim(edtNumMaxLactM.Text),Trim(edtUdoyM.Text),
      Trim(edtRichM.Text),Trim(edtBelokM.Text),Trim(edtNicknameGF.Text),Trim(edtInvnumGF.Text),
      kodkatgf)>0 then
      begin
        Application.MessageBox('Запись отредактирована!', 'Информация', MB_OK);
        FormMain.ShowCouters();
        //окрываем форму для добавления категории для этого быка
        //if not Assigned(FormAddKat) then
        //  FormAddKat := TFormAddKat.Create(Application);
        //FormAddKat.ShowModal;
      end
      else
      Application.MessageBox('Запись НЕ была отредактирована!', 'Информация', MB_OK);
  end;
  exit;
end;

if BoollIsUniq() then
begin
//Сохраняем
    if TBull.InsertBull(DataMdl.ADOQuerySprav,cbStatus.Text,kodregion,kodrajon,kodhoz,
      Trim(edtNickname.Text),Trim(edtInvnum.Text),kodpor,kodline,gr,meDateBirthday.Text,
      kodcountry,Trim(edtNicknameF.Text),Trim(edtInvnumF.Text),kodkatf,Trim(edtNicknameM.Text),
      Trim(edtInvnumM.Text),Trim(edtNumMaxLactM.Text),Trim(edtUdoyM.Text),
      Trim(edtRichM.Text),Trim(edtBelokM.Text),Trim(edtNicknameGF.Text),Trim(edtInvnumGF.Text),kodkatgf) > 0 then
      begin
        FormMain.ShowCouters();
        Application.MessageBox('Запись добавлена!', 'Информация', MB_OK);
        //находим значение счетчика idBull
        DataMdl.ADOQuerySprav.Close;
        DataMdl.ADOQuerySprav.SQL.Clear;
        DataMdl.ADOQuerySprav.SQL.Add('SELECT @@identity as idBull');
        DataMdl.ADOQuerySprav.Open;
        idBull := DataMdl.ADOQuerySprav.FieldByName('idBull').AsString;
        //окрываем форму для добавления категории для этого быка
        //if not Assigned(FormAddKat) then
        // FormAddKat := TFormAddKat.Create(Application);
        //FormAddKat.ShowModal;
      end
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
  //end;
end
//Обновляем существующий
else
if Application.MessageBox('Такой бык уже существует.Вы действительно хотите обновить данные?', 'Изменить данные?', MB_YESNO or MB_ICONWARNING) = IDYES then
begin
{with dataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('UPDATE  bull SET kodr=' + kodregion +',kodrn=' + kodrajon + ',kodh=' + kodhoz
        + ',klihkab="' + Trim(edtNickname.Text) + '",inb="'+ Trim(edtInvnum.Text) + '",porb=' + kodpor
        + ',linb=' + kodline + ',grb=' + gr + ',drb="' + meDateBirthday.Text + '",mrb='+ kodcountry
        + ',klihkafb="' + Trim(edtNicknameF.Text) + '",infb="' + Trim(edtInvnumF.Text) + '",kodkatfb='
        + kodkatf + ',klihkamb="' + Trim(edtNicknameM.Text) + '",inmb="' + Trim(edtInvnumM.Text)
        + '",nummaxlactmb="'+ Trim(edtNumMaxLactM.Text) + '",udmb="' + Trim(edtUdoyM.Text) + '",richmb="'
        + Trim(edtRichM.Text) + '",belokmb="'+ Trim(edtBelokM.Text) + '",klihkagfb="'
        + Trim(edtNicknameGF.Text) + '",inngfb="' + Trim(edtInvnumGF.Text) + '",kodkatgfb='
        + kodkatgf + ' WHERE id=' + idBull);
//        + kodkatgf + ' WHERE inb="' + Trim(edtInvnum.Text) +'" and drb=#'
//        +  StringReplace(meDateBirthday.Text,'.','/',[rfReplaceAll]) + '#');
    ADOQuerySprav.ExecSQL;
    if ADOQuerySprav.RowsAffected > 0 then
      begin
        Application.MessageBox('Запись обновлена!', 'Информация', MB_OK);
        //окрываем форму для добавления категории для этого быка
        //if not Assigned(FormAddKat) then
        //  FormAddKat := TFormAddKat.Create(Application);
        //FormAddKat.ShowModal;
      end
      else
      Application.MessageBox('Запись не была обновлена!', 'Информация', MB_OK);
  end;}
      if TBull.UpdateBull(DataMdl.ADOQuerySprav,idBull,cbStatus.Text,kodregion,kodrajon,kodhoz,Trim(edtNickname.Text),
        Trim(edtInvnum.Text),kodpor,kodline,gr,meDateBirthday.Text,kodcountry,Trim(edtNicknameF.Text),
        Trim(edtInvnumF.Text),kodkatf,Trim(edtNicknameM.Text),Trim(edtInvnumM.Text),
        Trim(edtNumMaxLactM.Text),Trim(edtUdoyM.Text),Trim(edtRichM.Text),Trim(edtBelokM.Text),
        Trim(edtNicknameGF.Text),Trim(edtInvnumGF.Text),kodkatgf) > 0 then
      begin
        Application.MessageBox('Запись обновлена!', 'Информация', MB_OK);
        //окрываем форму для добавления категории для этого быка
        //if not Assigned(FormAddKat) then
        //  FormAddKat := TFormAddKat.Create(Application);
        //FormAddKat.ShowModal;
      end
      else
      Application.MessageBox('Запись НЕ была обновлена!', 'Информация', MB_OK);

end;

end;

//проверка быка на уникальность
function TFormAddBull.BoollIsUniq(): Boolean;
begin
Result := True;
if (Trim(edtInvnum.Text) <> '') and (meDateBirthday.Text <> '  .  .    ') then
begin
 with DataMdl do
 begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT id FROM bull WHERE inb="' + Trim(edtInvnum.Text) +'" and drb="'
      + meDateBirthday.Text + '"');
      //+  StringReplace(meDateBirthday.Text,'.','/',[rfReplaceAll]) + '#');
    ADOQuerySprav.Open;
    if ADOQuerySprav.RecordCount > 0 then
      begin
        idBull := ADOQuerySprav.FieldByName('id').AsString;
        Result := False;
      end;
 end;
end;
end;

procedure TFormAddBull.cbRegionSelect(Sender: TObject);
var
  region: string;
begin
  region := cbRegion.Text;//заполнение Кода районов
  if region<>'' then
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('select im,kodr from kodra where kodr=(select kod from spobl where im='+''''+region+''')' + ' ORDER BY im');
    ADOQuerySprav.Open;
    ADOQuerySprav.First;
    cbRajon.Clear;
    cbHoz.Clear;
    while not ADOQuerySprav.Eof do
      begin
      cbRajon.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
      ADOQuerySprav.Next;
      end;
  end;

end;


procedure TFormAddBull.cbRajonSelect(Sender: TObject);
begin
with FormAddBull,DataMdl do
  begin
  region := cbRegion.Text;
  rajon := cbRajon.Text;
  if rajon<>'' then
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT kodxoz.im,kodxoz.kodr,kodxoz.kodraj FROM (spobl INNER JOIN kodra ON spobl.kod = kodra.kodr) '+
                          'INNER JOIN kodxoz ON (kodra.kodr = kodxoz.kodr) AND (kodra.kodraj = kodxoz.kodraj)'+
                          ' WHERE spobl.im='+''''+region+''''+' AND kodra.im='+''''+rajon+'''' + 'ORDER BY kodxoz.im');

    ADOQuerySprav.Open;

    //для insert в bull
    kodregion := ADOQuerySprav.FieldByName('kodr').AsString;
    kodrajon := ADOQuerySprav.FieldByName('kodraj').AsString;

    ADOQuerySprav.First;
    cbHoz.Clear;
    while not ADOQuerySprav.Eof do
      begin
      cbHoz.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
      ADOQuerySprav.Next;
      end;
  end;
  end;
end;

procedure TFormAddBull.cbHozSelect(Sender: TObject);
begin
  hoz := cbHoz.Text;
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('select kodx from kodxoz where kodr=' + kodregion + ' and kodraj=' +
      kodrajon + ' and im='+''''+ hoz +'''');
    ADOQuerySprav.Open;
    //для insert в bull
    kodhoz := ADOQuerySprav.FieldByName('kodx').AsString;
  end;
end;

procedure TFormAddBull.cbCategoryFSelect(Sender: TObject);
var
  category: String;
begin
  category := cbCategoryF.Text;
  //для insert в bull
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('select kat from category where val='+''''+ category +'''');
    ADOQuerySprav.Open;
    //для insert father в bull
    kodkatf := ADOQuerySprav.FieldByName('kat').AsString;
  end;
end;

procedure TFormAddBull.cbCategoryGFSelect(Sender: TObject);
var
  category: String;
begin
  category := cbCategoryGF.Text;
  //для insert в bull
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('select kat from category where val='+''''+ category +'''');
    ADOQuerySprav.Open;
    //для insert grandfather в bull
    kodkatgf := ADOQuerySprav.FieldByName('kat').AsString;
  end;
end;


procedure TFormAddBull.cbCountrySelect(Sender: TObject);
var
  country: String;
begin
country := cbCountry.Text;
with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT kodr FROM kodst WHERE im='+''''+ country +'''');
    ADOQuerySprav.Open;
    //для insert в bull
    kodcountry := ADOQuerySprav.FieldByName('kodr').AsString;
  end;
end;


procedure TFormAddBull.cbLineSelect(Sender: TObject);
var
  line: String;
begin
  line := cbLine.Text;
  //для insert в bull
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('select kod,gr from sklin where im='+''''+ line +'''');
    ADOQuerySprav.Open;
    //для insert в bull
    kodline := ADOQuerySprav.FieldByName('kod').AsString;
    gr := ADOQuerySprav.FieldByName('gr').AsString;
  end;
end;

procedure TFormAddBull.cbPorodaSelect(Sender: TObject);
var
  poroda,grLine: String;
begin
  poroda := cbPoroda.Text;
  //для insert в bull
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT kod,gr FROM sppor WHERE im='+''''+ poroda +'''');
    ADOQuerySprav.Open;
    //для insert в bull
    kodpor := ADOQuerySprav.FieldByName('kod').AsString;
    grLine := ADOQuerySprav.FieldByName('gr').AsString;
    //в зависимости от породы заполняем линии
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    if grLine <> '' then
      ADOQuerySprav.SQL.Add('SELECT DISTINCT im FROM sklin WHERE gr=' + grLine + ' ORDER BY im')
    else
      ADOQuerySprav.SQL.Add('SELECT DISTINCT im FROM sklin ORDER BY im');
    ADOQuerySprav.Open;
    ADOQuerySprav.First;
    cbLine.Clear;
    while not ADOQuerySprav.Eof do
      begin
      cbLine.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
      ADOQuerySprav.Next;
      end;

  end;
end;

procedure TFormAddBull.edtRichMExit(Sender: TObject);
var
  val: single;
begin
  if not TryStrToFloat((Sender as TEdit).Text, val) then
    raise EArgumentException.Create('Это не число. Повторите ввод.');
end;

procedure TFormAddBull.edtRichMKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '.' then
    Key := ',';
  if ((Key<'0') or (Key>'9')) and (Key<>#8) and (Key<>'-') and (Key<>',') then
    Key := #0;
end;

procedure TFormAddBull.edtUdoyMExit(Sender: TObject);
var
  val: Integer;
begin
  if not TryStrToInt(edtUdoyM.Text, val) then
    raise EArgumentException.Create('Это не число. Повторите ввод.');
end;

procedure TFormAddBull.edtUdoyMKeyPress(Sender: TObject; var Key: Char);
begin
  //#8 BACKSPACE       #9 DELETE
  if ((Key<'0') or (Key>'9') or (Length(edtUdoyM.Text)>4))  and (Key<>#8) and (Key<>'-') then
    Key := #0;
end;

//возвращаемся на главную форму
procedure TFormAddBull.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormMain.ShowDBGrid();
  //if isEditCategory then
  //  FormListCategory.ShowDBGridCategory();
end;

procedure TFormAddBull.FormShow(Sender: TObject);
begin
with DataMdl do
begin
//заполняем комбобоксы выбора
//region
ADOQuerySprav.Close;
ADOQuerySprav.SQL.Clear;
ADOQuerySprav.SQL.Add('SELECT * FROM spobl ORDER BY im');
ADOQuerySprav.Open;
ADOQuerySprav.First;
cbRegion.Clear;
while not ADOQuerySprav.Eof do
  begin
  cbRegion.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
  ADOQuerySprav.Next;
  end;
//страны
ADOQuerySprav.Close;
ADOQuerySprav.SQL.Clear;
ADOQuerySprav.SQL.Add('SELECT DISTINCT im FROM kodst ORDER BY im');
ADOQuerySprav.Open;
ADOQuerySprav.First;
cbCountry.Clear;
while not ADOQuerySprav.Eof do
  begin
  cbCountry.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
  ADOQuerySprav.Next;
  end;
//породы
ADOQuerySprav.Close;
ADOQuerySprav.SQL.Clear;
ADOQuerySprav.SQL.Add('SELECT DISTINCT im FROM sppor ORDER BY im');
ADOQuerySprav.Open;
ADOQuerySprav.First;
cbPoroda.Clear;
while not ADOQuerySprav.Eof do
  begin
  cbPoroda.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
  ADOQuerySprav.Next;
  end;

//категории быков-отцов, быков-дедов
ADOQuerySprav.Close;
ADOQuerySprav.SQL.Clear;
ADOQuerySprav.SQL.Add('SELECT DISTINCT val FROM category ORDER BY val');
ADOQuerySprav.Open;
ADOQuerySprav.First;
cbCategoryF.Clear;
cbCategoryGF.Clear;
while not ADOQuerySprav.Eof do
  begin
  cbCategoryF.Items.Add(ADOQuerySprav.FieldByName('val').AsString);
  cbCategoryGF.Items.Add(ADOQuerySprav.FieldByName('val').AsString);
  ADOQuerySprav.Next;
  end;

//редактирование быка - заполняем поля на форме
if isEditBull then
  begin
    ADOQueryEdit.Close;
    ADOQueryEdit.SQL.Clear;
   {ADOQuerySprav.SQL.Add('SELECT kodr,kodrn,kodh,klihkab,inb,porb,linb,grb,drb,mrb,'
        + 'klihkafb,infb,kodkatfb,klihkamb,inmb,nummaxlactmb,udmb,richmb,belokmb,klihkagfb,inngfb,kodkatgfb'
        + ' FROM bull WHERE id=' + idBull);}
    ADOQueryEdit.SQL.Add('SELECT bull.status, bull.klihkab, bull.inb, bull.drb, bull.mrb, bull.klihkafb, bull.infb,'
      +' bull.kodkatfb, bull.klihkamb, bull.inmb, bull.nummaxlactmb, bull.udmb, bull.richmb, bull.belokmb,'
      +' bull.klihkagfb, bull.inngfb, bull.kodkatgfb, spobl.im, kodra.im, kodxoz.im, sppor.IM, sklin.IM, '
      +'kodst.IM, category.val, category.val, category_1.val FROM ((kodst INNER JOIN (sklin '
      +'INNER JOIN (sppor INNER JOIN (kodxoz INNER JOIN (kodra INNER JOIN (spobl INNER JOIN bull '
      +'ON spobl.kod = bull.kodr) ON (kodra.kodraj = bull.kodrn) AND (kodra.kodr = spobl.kod)) '
      +'ON (kodxoz.kodx = bull.kodh) AND (kodxoz.kodraj = kodra.kodraj) AND (kodxoz.kodr = kodra.kodr))'
      +' ON sppor.KOD = bull.porb) ON (sklin.GR = bull.grb) AND (sklin.KOD = bull.linb)) '
      +'ON kodst.KODR = bull.mrb) INNER JOIN category ON bull.kodkatfb = category.kat) '
      +'INNER JOIN category AS category_1 ON bull.kodkatgfb = category_1.kat WHERE bull.id=' + idBull);
    ADOQueryEdit.Open;

    cbStatus.ItemIndex := cbStatus.Items.IndexOf(ADOQueryEdit.FieldByName('status').AsString);

    cbRegion.ItemIndex := cbRegion.Items.IndexOf(ADOQueryEdit.FieldByName('spobl.im').AsString);//регион
    FormAddBull.cbRegionSelect(cbRegion);//генер.событие
    cbRajon.ItemIndex := cbRajon.Items.IndexOf(ADOQueryEdit .FieldByName('kodra.im').AsString);//район
    FormAddBull.cbRajonSelect(cbRajon);//генер.событие
    cbHoz.ItemIndex := cbHoz.Items.IndexOf(ADOQueryEdit.FieldByName('kodxoz.im').AsString);//район
    FormAddBull.cbHozSelect(cbHoz);//генер.событие
    edtNickname.Text := ADOQueryEdit.FieldByName('klihkab').AsString;//кличка быка
    edtInvnum.Text := ADOQueryEdit.FieldByName('inb').AsString;//инв.ном. быка
    cbPoroda.ItemIndex := cbPoroda.Items.IndexOf(ADOQueryEdit.FieldByName('sppor.im').AsString);//порода быка
    FormAddBull.cbPorodaSelect(cbPoroda);//генер.событие
    cbLine.ItemIndex := cbLine.Items.IndexOf(ADOQueryEdit.FieldByName('sklin.im').AsString);//линия быка
    FormAddBull.cbLineSelect(cbLine);//генер.событие/
    meDateBirthday.Text := ADOQueryEdit.FieldByName('drb').AsString;//Дата рожд.
    cbCountry.ItemIndex := cbCountry.Items.IndexOf(ADOQueryEdit.FieldByName('kodst.im').AsString);//страна
    FormAddBull.cbCountrySelect(cbCountry);//генер.событие/
    edtNicknameF.Text := ADOQueryEdit.FieldByName('klihkafb').AsString;//кличка отца
    edtInvnumF.Text := ADOQueryEdit.FieldByName('infb').AsString;//инв.ном. отца
    cbCategoryF.ItemIndex := cbCategoryF.Items.IndexOf(ADOQueryEdit.FieldByName('category.val').AsString);//категория отца
    FormAddBull.cbCategoryFSelect(cbCategoryF);//генер.событие
    edtNicknameM.Text := ADOQueryEdit.FieldByName('klihkamb').AsString;//кличка матери
    edtInvnumM.Text := ADOQueryEdit.FieldByName('inmb').AsString;//инв.ном. матери
    edtNumMaxLactM.Text := ADOQueryEdit.FieldByName('nummaxlactmb').AsString;//ном.наив.лакт. матери
    edtUdoyM.Text := ADOQueryEdit.FieldByName('udmb').AsString;//удой матери
    edtRichM.Text := ADOQueryEdit.FieldByName('richmb').AsString;//жир
    edtBelokM.Text := ADOQueryEdit.FieldByName('belokmb').AsString;//белок
    edtNicknameGF.Text := ADOQueryEdit.FieldByName('klihkagfb').AsString;//кличка деда
    edtInvnumGF.Text := ADOQueryEdit.FieldByName('inngfb').AsString;//инв.ном. деда
    cbCategoryGF.ItemIndex := cbCategoryGF.Items.IndexOf(ADOQueryEdit.FieldByName('category_1.val').AsString);//категория отца
    FormAddBull.cbCategoryGFSelect(cbCategoryGF);//генер.событие
  end
  else
    //чистим ВСЕ контролы
  CleanAllControls();

end;
end;

procedure TFormAddBull.meDateBirthdayExit(Sender: TObject);
var
  tmp: String;
begin
  tmp := StringReplace(meDateBirthday.EditText,'_','0',[rfReplaceAll]);
  meDateBirthday.Text := tmp;
end;

end.
