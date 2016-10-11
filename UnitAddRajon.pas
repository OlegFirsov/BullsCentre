unit UnitAddRajon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormAddNewRajon = class(TForm)
    Label1: TLabel;
    edtCodeRajon: TEdit;
    Label3: TLabel;
    edtNameRajon: TEdit;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    Label2: TLabel;
    lblRegion: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCodeRajonKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddNewRajon: TFormAddNewRajon;

implementation

uses UnitDB, UnitVariables, UnitSprav;

{$R *.dfm}

procedure TFormAddNewRajon.SpeedButton1Click(Sender: TObject);
begin
kodregion := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
kodrajon := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
if ((edtCodeRajon.Text<>'') and (edtNameRajon.Text<>'')) then
begin

case FormAddNewRajon.Tag of
1: begin//Add new
if (not isUniqueCode('kodra','kodraj',' kodr='+kodregion+' AND ',FormAddNewRajon.edtCodeRajon.Text)) then
  begin
  FormAddNewRajon.edtCodeRajon.SetFocus;
  Application.MessageBox('Код Района должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from kodra
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO kodra (kodr,kodraj,im) VALUES ('+kodregion+','+
    edtCodeRajon.Text+','+''''+edtNameRajon.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from kodra
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE kodra SET im='+''''+edtNameRajon.Text+''''+' WHERE kodr='+kodregion+' AND kodraj='+kodrajon);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);


   end;
end;
end
else
Application.MessageBox('Код и наименование Района являются обязательными для ввода!', 'Информация', MB_OK);


end;

procedure TFormAddNewRajon.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormAddNewRajon.ComponentCount-1 do
  if (FormAddNewRajon.Components[i] is TEdit) then
    (FormAddNewRajon.Components[i] as TEdit).Text := '';
end;

procedure TFormAddNewRajon.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
FormSprav.OpenRajon();
end;

procedure TFormAddNewRajon.edtCodeRajonKeyPress(Sender: TObject;
  var Key: Char);
begin
//If Not (Key In ['0'..'9',#8,#9]) then
  if not CharInSet(Key,['0'..'9',#8,#9]) then
    Key:=#0;
end;

end.
