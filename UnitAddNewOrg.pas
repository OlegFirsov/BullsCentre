unit UnitAddNewOrg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormAddNewOrg = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    Label2: TLabel;
    lblRegion: TLabel;
    edtCodeOrg: TEdit;
    Label4: TLabel;
    cbRajon: TComboBox;
    cbXozName: TComboBox;
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCodeOrgKeyPress(Sender: TObject; var Key: Char);
    procedure cbXozNameSelect(Sender: TObject);
    procedure cbRajonSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddNewOrg: TFormAddNewOrg;

implementation

uses UnitDB, UnitSprav, UnitVariables, UnitMain;

{$R *.dfm}

procedure TFormAddNewOrg.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormAddNewOrg.ComponentCount-1 do
  if (FormAddNewOrg.Components[i] is TEdit) then
    (FormAddNewOrg.Components[i] as TEdit).Text := '';
cbXozName.Text := '';

end;

procedure TFormAddNewOrg.SpeedButton1Click(Sender: TObject);
begin
kodregion := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
DataMdl.ADOQueryTables.Close;
DataMdl.ADOQueryTables.SQL.Clear;
DataMdl.ADOQueryTables.SQL.Add('SELECT kodraj FROM kodra WHERE kodr='+kodregion+' AND im='+''''+cbRajon.Text+''''+' ORDER BY im');;
DataMdl.ADOQueryTables.Open;
kodrajon := DataMdl.ADOQueryTables.FieldByName('kodraj').AsString;
//codeRaj := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
if ((cbRajon.Text<>'') AND (edtCodeOrg.Text<>'') AND (cbXozName.Text<>'')) then
begin

case FormAddNewOrg.Tag of
1: begin//Add new
if (not isUniqueCode('kodxoz','kodx',' kodr='+kodregion+' AND kodraj='+kodrajon+' AND ',FormAddNewOrg.edtCodeOrg.Text)) then
  begin
  FormAddNewOrg.edtCodeOrg.SetFocus;
  Application.MessageBox('Код хозяйства должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from kodxoz
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO kodxoz (kodr,kodraj,kodx,im) VALUES ('+kodregion+','+kodrajon+','+
    edtCodeOrg.Text+','+''''+cbXozName.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from kodxoz
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE kodxoz SET im='+''''+cbXozName.Text+''''+' WHERE kodr='+kodregion+
   ' AND kodraj='+kodrajon+' AND kodx='+edtCodeOrg.Text);

   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);


   end;
end;
end
else
  Application.MessageBox('Район, Код и наименование Хозяйства являются обязательными для ввода!', 'Информация', MB_OK);

//обновить выбор хозяйств
rajon := cbRajon.Text;
DataMdl.ADOQueryTables.Close;
DataMdl.ADOQueryTables.SQL.Clear;
DataMdl.ADOQueryTables.SQL.Add('SELECT kodraj FROM kodra WHERE kodr='+kodregion+' AND im='+''''+rajon+'''');
DataMdl.ADOQueryTables.Open;
kodrajon := DataMdl.ADOQueryTables.FieldByName('kodraj').AsString;
//заполняем хозяйства для района
if rajon<>'' then
begin
 DataMdl.ADOQueryTables.Close;
 DataMdl.ADOQueryTables.SQL.Clear;
 DataMdl.ADOQueryTables.SQL.Add('SELECT kodxoz.im FROM kodxoz INNER JOIN kodra ON (kodxoz.kodr = kodra.kodr)'+
            ' AND (kodxoz.kodraj = kodra.kodraj) WHERE kodxoz.kodr='+kodregion+' AND kodra.im='+''''+rajon+''''+
            ' ORDER BY kodxoz.im');
 DataMdl.ADOQueryTables.Open;
 DataMdl.ADOQueryTables.First;
 FormAddNewOrg.cbXozName.Clear;
 while not DataMdl.ADOQueryTables.Eof do
   begin
   FormAddNewOrg.cbXozName.Items.Add(DataMdl.ADOQueryTables.FieldByName('im').AsString);
   DataMdl.ADOQueryTables.Next;
   end;
   end;


end;

procedure TFormAddNewOrg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//FormSprav.OpenXoz();
FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.im, kodra.kodraj, kodra.im, kodxoz.kodx, kodxoz.im '+
              'FROM (spobl LEFT JOIN kodra ON spobl.kod = kodra.kodr) LEFT JOIN kodxoz ON '+
              '(kodra.kodr = kodxoz.kodr) AND (kodra.kodraj = kodxoz.kodraj)'+
              ' WHERE spobl.im='+''''+FormAddNewOrg.lblRegion.Caption+''''+' ORDER BY spobl.kod, kodra.kodraj,kodxoz.kodx');
FormSprav.Caption:='Работа со справочниками. Кодификатор ОРГАНИЗАЦИЙ';
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel:='Код региона';
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayWidth:=25;
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayLabel:='Регион (Республика, Край, Область)';
DataMdl.ADOQuerySprav.FieldByName('kodraj').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kodraj').DisplayLabel:='Код района';
DataMdl.ADOQuerySprav.FieldByName('kodra.im').DisplayWidth:=25;
DataMdl.ADOQuerySprav.FieldByName('kodra.im').DisplayLabel:='Наименование района';
DataMdl.ADOQuerySprav.FieldByName('kodx').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kodx').DisplayLabel:='Код организации';
DataMdl.ADOQuerySprav.FieldByName('kodxoz.im').DisplayWidth:=25;
DataMdl.ADOQuerySprav.FieldByName('kodxoz.im').DisplayLabel:='Наименование организации';
FormSprav.SpdBtnAdd.Enabled := True;
FormSprav.SpdBtnEdit.Enabled := True;
FormSprav.SpdBtnDelete.Enabled := True;
FormSprav.DBGridSprav.SetFocus;
end;

procedure TFormAddNewOrg.edtCodeOrgKeyPress(Sender: TObject;
  var Key: Char);
begin
//If Not (Key In ['0'..'9',#8,#9]) then
  if not CharInSet(Key,['0'..'9',#8,#9]) then
    Key:=#0;
end;

procedure TFormAddNewOrg.cbXozNameSelect(Sender: TObject);
begin

with DataMdl.ADOQuerySprSost do
  begin
  Close;
  Sql.Clear;
  Sql.Add('SELECT kodx FROM kodxoz WHERE kodr='+kodregion+' AND kodraj='+kodrajon+
           ' AND im='+''''+cbXozName.Text+''''+' ORDER BY im');
  Open;
  end;
kodhoz := DataMdl.ADOQuerySprSost.FieldByName('kodx').AsString;
edtCodeOrg.Text := kodhoz;
end;

procedure TFormAddNewOrg.cbRajonSelect(Sender: TObject);
begin
rajon := cbRajon.Text;
DataMdl.ADOQueryTables.Close;
DataMdl.ADOQueryTables.SQL.Clear;
DataMdl.ADOQueryTables.SQL.Add('SELECT kodraj FROM kodra WHERE kodr='+kodregion+' AND im='+''''+rajon+'''');
DataMdl.ADOQueryTables.Open;
kodrajon := DataMdl.ADOQueryTables.FieldByName('kodraj').AsString;
//заполняем хозяйства для района
if rajon<>'' then
begin
 DataMdl.ADOQueryTables.Close;
 DataMdl.ADOQueryTables.SQL.Clear;
 DataMdl.ADOQueryTables.SQL.Add('SELECT kodxoz.im FROM kodxoz INNER JOIN kodra ON (kodxoz.kodr = kodra.kodr)'+
            ' AND (kodxoz.kodraj = kodra.kodraj) WHERE kodxoz.kodr='+kodregion+' AND kodra.im='+''''+rajon+''''+
            ' ORDER BY kodxoz.im');
 DataMdl.ADOQueryTables.Open;
 DataMdl.ADOQueryTables.First;
 FormAddNewOrg.cbXozName.Clear;
 while not DataMdl.ADOQueryTables.Eof do
   begin
   FormAddNewOrg.cbXozName.Items.Add(DataMdl.ADOQueryTables.FieldByName('im').AsString);
   DataMdl.ADOQueryTables.Next;
   end;
   end;
end;

end.
