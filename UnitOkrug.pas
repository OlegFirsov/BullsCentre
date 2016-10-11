unit UnitOkrug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormOkrug = class(TForm)
    Label1: TLabel;
    edtCodeOkrug: TEdit;
    Label3: TLabel;
    edtNameOkrug: TEdit;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOkrug: TFormOkrug;

implementation

uses UnitSprav, UnitDB;

{$R *.dfm}

procedure TFormOkrug.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormOkrug.ComponentCount-1 do
  if (FormOkrug.Components[i] is TEdit) then
    (FormOkrug.Components[i] as TEdit).Text := '';
end;

procedure TFormOkrug.SpeedButton1Click(Sender: TObject);
begin
if ((edtCodeOkrug.Text<>'') and (edtNameOkrug.Text<>'')) then
begin
case FormOkrug.Tag of
1: begin//Add new
if (not isUniqueCode('kokr','kod','',FormOkrug.edtCodeOkrug.Text)) then
  begin
  FormOkrug.edtCodeOkrug.SetFocus;
  Application.MessageBox('Код Округа должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from kodst
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO kokr (kod,im) VALUES ('+edtCodeOkrug.Text+','+
    ''''+edtNameOkrug.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from kokr
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE kokr SET im='+''''+edtNameOkrug.Text+''''+' WHERE kod='+edtCodeOkrug.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);

   end;
end;

end
else
Application.MessageBox('Код и Федеральный округ являются обязательными для ввода!', 'Информация', MB_OK);
end;

procedure TFormOkrug.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FormSprav.OpenOkrug();
end;

end.
