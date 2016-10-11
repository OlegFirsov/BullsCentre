unit UnitAddCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFormCategory = class(TForm)
    SpdBtnCancel: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtNameCat: TEdit;
    Label3: TLabel;
    edtCodeCat: TEdit;
    Label1: TLabel;
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtCodeCatKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCategory: TFormCategory;

implementation

{$R *.dfm}

uses UnitSprav, UnitDB;

procedure TFormCategory.edtCodeCatKeyPress(Sender: TObject; var Key: Char);
begin
//if not (Key In ['0'..'9',#8,#9]) then
if not CharInSet(Key,['0'..'9',#8,#9]) then
 Key:=#0;
end;

procedure TFormCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormSprav.OpenSprCat();
end;

procedure TFormCategory.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormCategory.ComponentCount-1 do
  if (FormCategory.Components[i] is TEdit) then
    (FormCategory.Components[i] as TEdit).Text := '';
end;

procedure TFormCategory.SpeedButton1Click(Sender: TObject);
begin
if ((edtCodeCat.Text<>'') and (edtNameCat.Text<>'')) then
begin
case FormCategory.Tag of
1: begin//Add new
if (not isUniqueCode('category','kat','',FormCategory.edtCodeCat.Text)) then
  begin
  FormCategory.edtCodeCat.SetFocus;
  Application.MessageBox('Код Категории должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from kodst
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO category (kat,val) VALUES ('+edtCodeCat.Text+','+
    ''''+edtNameCat.Text+''''+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from category
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE category SET val='+''''+edtNameCat.Text+''''+' WHERE kat='+edtCodeCat.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);

   end;
end;
end;
end;

end.
