unit UnitAddLinia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormAddLinia = class(TForm)
    Label2: TLabel;
    edtGr: TEdit;
    Label1: TLabel;
    edtCodeLinia: TEdit;
    Label3: TLabel;
    edtNameLinia: TEdit;
    edtGKPG: TEdit;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    procedure edtGrKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodeLiniaKeyPress(Sender: TObject; var Key: Char);
    procedure edtGrExit(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddLinia: TFormAddLinia;

implementation

{$R *.dfm}

uses
UnitSprav, UnitDB;

procedure TFormAddLinia.edtGrKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddLinia.edtCodeLiniaKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormAddLinia.edtGrExit(Sender: TObject);
begin
FormAddLinia.edtCodeLinia.Text := IntToStr(MaxCode('sklin','kod',' WHERE gr='+FormAddLinia.edtGr.Text)+1);
end;

procedure TFormAddLinia.SpeedButton1Click(Sender: TObject);
begin
if ((edtGr.Text<>'') and (edtCodeLinia.Text<>'') and (edtNameLinia.Text<>'')) then
begin
case FormAddLinia.Tag of
1: begin//Add new
if (not isUniqueCode('sklin','kod','gr',FormAddLinia.edtGr.Text)) then
  begin
  FormAddLinia.edtCodeLinia.SetFocus;
  Application.MessageBox('Код линии в группе должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from sklin
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO sklin (gr,kod,im,gkp) VALUES ('+edtGr.Text+','+
    edtCodeLinia.Text+','+''''+edtNameLinia.Text+''''+','+''''+edtGKPG.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from sklin
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE sklin SET im='+''''+edtNameLinia.Text+''''+
   ',gkp='+''''+edtGKPG.Text+''''+' WHERE gr='+edtGr.Text+' AND kod='+edtCodeLinia.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);


   end;
end;

end
else
Application.MessageBox('Группа,код и кличка являются обязательными для ввода!', 'Информация', MB_OK);

end;

procedure TFormAddLinia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
FormSprav.OpenSprLinia;
end;

end.
