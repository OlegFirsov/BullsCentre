unit UnitAddPor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormAddPor = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    edtCodePor: TEdit;
    edtNamePor: TEdit;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    Label2: TLabel;
    edtGr: TEdit;
    Label4: TLabel;
    cbKodb: TComboBox;
    Label5: TLabel;
    cbIsBreed: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    edtDirProd: TEdit;
    edtBreed: TEdit;
    procedure edtBreedKeyPress(Sender: TObject; var Key: Char);
    procedure edtDirProdKeyPress(Sender: TObject; var Key: Char);
    procedure edtGrKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodePorKeyPress(Sender: TObject; var Key: Char);
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddPor: TFormAddPor;

implementation

uses UnitDB, UnitSprav, {UnitAddKatXoz,} UnitMain;

{$R *.dfm}

procedure TFormAddPor.edtBreedKeyPress(Sender: TObject; var Key: Char);
begin
//If Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddPor.edtDirProdKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddPor.edtGrKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddPor.edtCodePorKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddPor.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormAddPor.ComponentCount-1 do
  if (FormAddPor.Components[i] is TEdit) then
    (FormAddPor.Components[i] as TEdit).Text := '';
cbKodb.Text := '';
cbIsBreed.Text := '';
end;

procedure TFormAddPor.SpeedButton1Click(Sender: TObject);
var
is_breed: String;
begin
if ((edtGr.Text<>'') and (edtCodePor.Text<>'') and (edtNamePor.Text<>'') and
    (cbIsBreed.Text<>'') and (edtBreed.Text<>'') and (edtDirProd.Text<>'')) then
begin
if cbIsBreed.Text = 'Да' then
  is_breed := 'True';
if cbIsBreed.Text = 'Нет' then
  is_breed := 'False';
if cbKodb.Text = '' then
  cbKodb.Text := ' ';
case FormAddPor.Tag of
1: begin//Add new
if (not isUniqueCode('sppor','kod','',FormAddPor.edtCodePor.Text)) then
  begin
  FormAddPor.edtCodePor.SetFocus;
  Application.MessageBox('Код породы должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from sppor
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO sppor (gr,kod,im,kodb,is_breed,breed,dir_prod) VALUES ('+edtGr.Text+','+
    edtCodePor.Text+','+''''+edtNamePor.Text+''''+','+''''+cbKodb.Text+''''+','+is_breed+
    ','+edtBreed.Text+','+edtDirProd.Text+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from sppor
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE sppor SET gr='+edtGr.Text+',kod='+edtCodePor.Text+',im='+''''+edtNamePor.Text+''''+
   ',kodb='+''''+cbKodb.Text+''''+',is_breed='+is_breed+',breed='+edtBreed.Text+
   ',dir_prod='+edtDirProd.Text+' WHERE kod='+edtCodePor.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);


   end;
end;

end
else
Application.MessageBox('Все поля являются обязательными для ввода!', 'Информация', MB_OK);

end;

procedure TFormAddPor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormSprav.OpenSprPorod();
end;

end.
