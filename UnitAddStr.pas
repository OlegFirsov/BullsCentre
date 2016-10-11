unit UnitAddStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormAddStr = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    edtCodeStr: TEdit;
    edtNameStr: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtCodeStrKeyPress(Sender: TObject; var Key: Char);
    procedure SpdBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddStr: TFormAddStr;

implementation

uses UnitSprav, UnitDB;

{$R *.dfm}

procedure TFormAddStr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormSprav.OpenStr();
end;

procedure TFormAddStr.SpeedButton1Click(Sender: TObject);
begin
if ((edtCodeStr.Text<>'') and (edtNameStr.Text<>'')) then
begin
case FormAddStr.Tag of
1: begin//Add new
if (not isUniqueCode('kodst','kodr','',FormAddStr.edtCodeStr.Text)) then
  begin
  FormAddStr.edtCodeStr.SetFocus;
  Application.MessageBox('Код Страны должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from kodst
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO kodst (kodr,im) VALUES ('+edtCodeStr.Text+','+
    ''''+edtNameStr.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from kodst
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE kodst SET im='+''''+edtNameStr.Text+''''+' WHERE kodr='+edtCodeStr.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);

   end;
end;

end
else
Application.MessageBox('Код и наименование Страны являются обязательными для ввода!', 'Информация', MB_OK);
end;


procedure TFormAddStr.edtCodeStrKeyPress(Sender: TObject; var Key: Char);
begin
//if Not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;

end;

procedure TFormAddStr.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormAddStr.ComponentCount-1 do
  if (FormAddStr.Components[i] is TEdit) then
    (FormAddStr.Components[i] as TEdit).Text := '';
end;

end.
