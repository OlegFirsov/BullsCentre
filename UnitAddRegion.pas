unit UnitAddRegion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormAddRegion = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    edtCodeRegion: TEdit;
    edtNameRegion: TEdit;
    SpeedButton1: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    Label2: TLabel;
    edtGKPG: TEdit;
    Label4: TLabel;
    cbOkrug: TComboBox;
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddRegion: TFormAddRegion;

implementation

uses UnitDB, UnitAddRajon, UnitVariables, UnitSprav, UnitMain;

{$R *.dfm}

procedure TFormAddRegion.SpdBtnCancelClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to FormAddRegion.ComponentCount-1 do
  if (FormAddRegion.Components[i] is TEdit) then
    (FormAddRegion.Components[i] as TEdit).Text := '';
FormAddRegion.cbOkrug.Text := '';
end;

procedure TFormAddRegion.SpeedButton1Click(Sender: TObject);
begin
//codeObl := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
//codeRaj := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
if ((edtCodeRegion.Text<>'') and (edtGKPG.Text<>'') and (edtNameRegion.Text<>'') and (cbOkrug.Text<>'')) then
begin
with DataMdl.ADOQueryOpt do
  begin
  Close;
  Sql.Clear;
  Sql.Add('SELECT kod FROM kokr WHERE im='+''''+cbOkrug.Text+'''');
  Open;
  kodokrug := FieldByName('kod').AsString;
  end;

case FormAddRegion.Tag of
1: begin//Add new
if (not isUniqueCode('spobl','kod','',FormAddRegion.edtCodeRegion.Text)) then
  begin
  FormAddRegion.edtCodeRegion.SetFocus;
  Application.MessageBox('Код Региона должен быть уникальным!', 'Информация', MB_OK);
  Exit;
  end;

  DataMdl.ADOQueryOpt.Close;
  DataMdl.ADOQueryOpt.SQL.Clear;//from spobl
  DataMdl.ADOQueryOpt.SQL.Add('INSERT INTO spobl (kod,kodb,im,okrug) VALUES ('+edtCodeRegion.Text+','+''''+
    edtGKPG.Text+''''+','+''''+edtNameRegion.Text+''''+','+kodokrug+')');
  DataMdl.ADOQueryOpt.ExecSQL;
  if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись добавлена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была добавлена!', 'Информация', MB_OK);
   end;
2: begin//edit
   DataMdl.ADOQueryOpt.Close;
   DataMdl.ADOQueryOpt.SQL.Clear;//from spobl
   DataMdl.ADOQueryOpt.SQL.Add('UPDATE spobl SET kodb='+''''+edtGKPG.Text+''''+
   ',im='+''''+edtNameRegion.Text+''''+',okrug='+kodokrug+' WHERE kod='+edtCodeRegion.Text);
   DataMdl.ADOQueryOpt.ExecSQL;
   if DataMdl.ADOQueryOpt.RowsAffected > 0 then
      Application.MessageBox('Запись изменена!', 'Информация', MB_OK)
      else
      Application.MessageBox('Запись НЕ была изменена!', 'Информация', MB_OK);


   end;
end;
end
else
Application.MessageBox('Код, Буквенный код марки ГКПЖ,наименование Региона и Округ являются обязательными для ввода!', 'Информация', MB_OK);


end;

procedure TFormAddRegion.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
FormAddRegion.edtCodeRegion.Enabled := True;
edtCodeRegion.Text := '';
edtGKPG.Text := '';
edtNameRegion.Text := '';

FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.kodb, spobl.im, kokr.im '+
 'FROM spobl INNER JOIN kokr ON spobl.okrug = kokr.kod ORDER BY spobl.im');
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel:='Код региона';
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayWidth:=24;
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayLabel:='Буквенный код марки ГКПЖ';
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayWidth:=64;
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayLabel:='Регион (Республика, Край, Область)';
DataMdl.ADOQuerySprav.FieldByName('kokr.im').DisplayWidth:=40;
DataMdl.ADOQuerySprav.FieldByName('kokr.im').DisplayLabel:='Федеральный округ';
//FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
FormSprav.Tag:=1;
FormSprav.lblSearch.Caption:='Укажите нужный Вам РЕГИОН';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('spobl.im').AsString);
       ADOQuerySprav.Next;
       end;
     end;
{
FormSprav.SpdBtnSearch.Visible:=True;
FormSprav.cbSearch.Visible:=True;
FormSprav.lblSearch.Visible:=True;
FormSprav.SpdBtnAdd.Visible:=True;
FormSprav.SpdBtnEdit.Visible:=True;
FormSprav.SpdBtnDelete.Visible:=True;
FormSprav.SpdBtnSave.Visible:=False;
FormSprav.SpdBtnCancel.Visible:=False;
}

end;

end.
