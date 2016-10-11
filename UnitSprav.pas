unit UnitSprav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, VCl.Dialogs, VCl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.StdCtrls, Data.DB, ActiveX, ComObj, System.UITypes,
  System.StrUtils;

type
  TFormSprav = class(TForm)
    DBGridSprav: TDBGrid;
    DBNavigatorSprav: TDBNavigator;
    Panel1: TPanel;
    SpdBtnPrint: TSpeedButton;
    SpdBtnSearch: TSpeedButton;
    cbSearch: TComboBox;
    lblSearch: TLabel;
    SpdBtnAdd: TSpeedButton;
    SpdBtnEdit: TSpeedButton;
    SpdBtnDelete: TSpeedButton;
    procedure SpdBtnPrintClick(Sender: TObject);
    procedure SpdBtnSearchClick(Sender: TObject);
    procedure DBGridSpravDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SpdBtnAddClick(Sender: TObject);
    procedure SpdBtnSaveClick(Sender: TObject);
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpdBtnDeleteClick(Sender: TObject);
    procedure SpdBtnEditClick(Sender: TObject);
    procedure DBGridSpravKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OpenSprPorod();
    procedure OpenSprCat();
    procedure OpenSprLinia();
    procedure OpenStr();
   // procedure OpenKatBool();
    procedure OpenRajon();
    procedure OpenXoz();
    procedure OpenOkrug();
    procedure cbSearchSelect(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
function MaxCode(tblName,fldName,whereStr: String): Integer;
function isUniqueCode(tblName,fldName,WhereStr,NewCode: String): Boolean;

var
  FormSprav: TFormSprav;

implementation

uses UnitDB, UnitVariables, UnitAddRegion, UnitAddRajon, UnitAddNewOrg,
   UnitMain, UnitAddCategory, UnitAddPor, UnitAddLinia,
  UnitAddStr, UnitOkrug;

//var
//MsExcel,Sheets,ArrayData,Cell1,Cell2,Range : Variant;

{$R *.dfm}

function MaxCode(tblName,fldName,whereStr: String): Integer;
begin
with DataMdl.ADOQueryEdit do
  begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT max('+fldName+') as maxcode'+' FROM '+tblName+whereStr);
  Open;
  Result := FieldByName('maxcode').AsInteger;
  end;
end;

function isUniqueCode(tblName,fldName,WhereStr,NewCode: String): Boolean;
begin
Result := False;
with DataMdl.ADOQueryEdit do
  begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT '+fldName+' FROM '+tblName+' WHERE '+WhereStr+fldName+'='+NewCode);
  Open;
  if RecordCount = 0 then
    Result := True;
  end;

end;

procedure TFormSprav.OpenSprPorod();
begin
FormSprav.Caption:='Работа со справочниками. Кодификатор Породы КРС.';
FormMain.OpenMenuSprav('select * from sppor order by kod');
DataMdl.ADOQuerySprav.FieldByName('gr').DisplayWidth := 5;
DataMdl.ADOQuerySprav.FieldByName('gr').DisplayLabel := 'Гр.родст.пород';
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth := 7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel := 'Код породы';
DataMdl.ADOQuerySprav.FieldByName('im').DisplayWidth := 44;
DataMdl.ADOQuerySprav.FieldByName('im').DisplayLabel := 'Порода КРС';
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayWidth := 5;
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayLabel := 'Код';
DataMdl.ADOQuerySprav.FieldByName('is_breed').DisplayWidth := 7;
DataMdl.ADOQuerySprav.FieldByName('is_breed').DisplayLabel := 'Родонач.породы';
DataMdl.ADOQuerySprav.FieldByName('breed').DisplayWidth := 7;
DataMdl.ADOQuerySprav.FieldByName('breed').DisplayLabel := 'Код родонач.породы';
DataMdl.ADOQuerySprav.FieldByName('dir_prod').DisplayWidth := 7;
DataMdl.ADOQuerySprav.FieldByName('dir_prod').DisplayLabel := '???????????';

FormSprav.Tag := 5;
FormSprav.lblSearch.Caption:='Укажите нужную Вам ПОРОДУ';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
       ADOQuerySprav.Next;
       end;
     end;
FormSprav.SpdBtnAdd.Visible:=True;
FormSprav.SpdBtnEdit.Visible:=True;
FormSprav.SpdBtnDelete.Visible:=True;
end;

procedure TFormSprav.OpenRajon();
begin
FormSprav.Caption:='Работа со справочниками. Кодификатор РАЙОНОВ';
FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.im, kodra.kodraj, kodra.im '+
              'FROM spobl LEFT JOIN kodra ON spobl.kod = kodra.kodr ORDER BY kodr,kodraj');
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel:='Код региона';
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayWidth:=38;
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayLabel:='Регион (Республика, Край, Область)';
DataMdl.ADOQuerySprav.FieldByName('kodraj').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kodraj').DisplayLabel:='Код района';
DataMdl.ADOQuerySprav.FieldByName('kodra.im').DisplayWidth:=38;
DataMdl.ADOQuerySprav.FieldByName('kodra.im').DisplayLabel:='Наименование района';

FormSprav.Tag:=2;
FormSprav.lblSearch.Caption:='Укажите нужный Вам Регион';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       if FormSprav.cbSearch.Items.IndexOf(ADOQuerySprav.FieldByName('spobl.im').AsString) = -1 then
         FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('spobl.im').AsString);
       ADOQuerySprav.Next;
       end;
     end;
FormSprav.SpdBtnAdd.Visible:=True;
FormSprav.SpdBtnEdit.Visible:=True;
FormSprav.SpdBtnDelete.Visible:=True;
end;

procedure TFormSprav.OpenXoz();
begin
FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.im, kodra.kodraj, kodra.im, kodxoz.kodx, kodxoz.im '+
              'FROM (spobl LEFT JOIN kodra ON spobl.kod = kodra.kodr) LEFT JOIN kodxoz ON '+
              '(kodra.kodr = kodxoz.kodr) AND (kodra.kodraj = kodxoz.kodraj) ORDER BY spobl.kod, kodra.kodraj,kodxoz.kodx');
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


if not Assigned(FormSprav) then begin
    FormSprav := TFormSprav.Create(Application);
    FormSprav.Show;
  end
  else
  FormSprav.Show;

FormSprav.Tag:=3;
FormSprav.lblSearch.Caption:='Укажите нужный Вам Регион';
   with DataMdl.ADOQueryCategory do
     begin
     Close;
     Sql.Clear;
     Sql.Add('SELECT kod,im FROM spobl ORDER BY im');
     Open;
     First;
     FormSprav.cbSearch.Clear;
     while not Eof do
       begin
       if FormSprav.cbSearch.Items.IndexOf(FieldByName('im').AsString) = -1 then
       FormSprav.cbSearch.Items.Add(FieldByName('im').AsString);
       //tempStr := ADOQuerySprav.FieldByName('kodra.im').AsString;
       Next;
       end;
     end;
FormSprav.SpdBtnAdd.Visible:=False;
FormSprav.SpdBtnEdit.Visible:=False;
FormSprav.SpdBtnDelete.Visible:=False;
end;

procedure TFormSprav.OpenSprCat;
begin
  FormSprav.Caption:='Работа со справочниками. Кодификатор Категорий.';
  FormMain.OpenMenuSprav('select kat,val from category order by kat');
  DataMdl.ADOQuerySprav.FieldByName('kat').DisplayWidth := 7;
  DataMdl.ADOQuerySprav.FieldByName('kat').DisplayLabel := 'Код категории';
  DataMdl.ADOQuerySprav.FieldByName('val').DisplayWidth := 64;
  DataMdl.ADOQuerySprav.FieldByName('val').DisplayLabel := 'Категория';
  //FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
  FormSprav.Tag := 4;
  FormSprav.lblSearch.Caption:='Укажите нужную Категорию';
     with DataMdl do
       begin
       ADOQuerySprav.First;
       FormSprav.cbSearch.Clear;
       while not ADOQuerySprav.Eof do
         begin
         FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('val').AsString);
         ADOQuerySprav.Next;
         end;
       end;
  FormSprav.SpdBtnSearch.Visible:=True;
  FormSprav.cbSearch.Visible:=True;
  FormSprav.lblSearch.Visible:=True;
  FormSprav.SpdBtnAdd.Visible:=True;
  FormSprav.SpdBtnEdit.Visible:=True;
  FormSprav.SpdBtnDelete.Visible:=True;
end;

procedure TFormSprav.OpenSprLinia();
begin
FormSprav.Caption:='Работа со справочниками. Кодификатор Линий КРС.';
FormMain.OpenMenuSprav('select * from sklin order by gr,kod');
DataMdl.ADOQuerySprav.FieldByName('gr').DisplayWidth := 10;
DataMdl.ADOQuerySprav.FieldByName('gr').DisplayLabel := 'Гр.родст.пород';
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth := 4;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel := 'Код';
DataMdl.ADOQuerySprav.FieldByName('im').DisplayWidth := 34;
DataMdl.ADOQuerySprav.FieldByName('im').DisplayLabel := 'Кличка и ном.родоначальника линии';
DataMdl.ADOQuerySprav.FieldByName('gkp').DisplayWidth := 10;
DataMdl.ADOQuerySprav.FieldByName('gkp').DisplayLabel := 'Марка и ном.ГКПЖ род.линии';
//FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
FormSprav.Tag := 6;
FormSprav.lblSearch.Caption:='Укажите нужную Вам КЛИЧКУ';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
       ADOQuerySprav.Next;
       end;
     end;
end;

procedure TFormSprav.OpenStr();
begin
FormSprav.Caption:='Работа со справочниками. Кодификатор СТРАН';
FormMain.OpenMenuSprav('select * from kodst order by kodr');
DataMdl.ADOQuerySprav.FieldByName('kodr').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kodr').DisplayLabel:='Код';
DataMdl.ADOQuerySprav.FieldByName('im').DisplayWidth:=64;
DataMdl.ADOQuerySprav.FieldByName('im').DisplayLabel:='Страна';
//FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
FormSprav.Tag := 8;
FormSprav.lblSearch.Caption:='Укажите нужную Вам СТРАНУ';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
       ADOQuerySprav.Next;
       end;
     end;

end;


procedure TFormSprav.OpenOkrug();
begin
FormSprav.Caption:='Работа со справочниками. Кодификатор Федеральных округов';
FormMain.OpenMenuSprav('SELECT * FROM kokr order by kod');
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel:='Код';
DataMdl.ADOQuerySprav.FieldByName('im').DisplayWidth:=64;
DataMdl.ADOQuerySprav.FieldByName('im').DisplayLabel:='Федеральный округ';
//FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
FormSprav.Tag := 10;
FormSprav.lblSearch.Caption:='Укажите нужный ОКРУГ';
   with DataMdl do
     begin
     ADOQuerySprav.First;
     FormSprav.cbSearch.Clear;
     while not ADOQuerySprav.Eof do
       begin
       FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
       ADOQuerySprav.Next;
       end;
     end;

end;


procedure TFormSprav.SpdBtnPrintClick(Sender: TObject);
var
i,PosSpace: Integer;
sIm1,sIm2{,is_breed}: String;
begin
try//открываем Excel и создаем раб.книгу
MsExcel := CreateOleObject('Excel.Application');
//кол-во листов в новой книге
MsExcel.SheetsInNewWorkbook := 1;//
//добавляем раб.книгу
MsExcel.WorkBooks.Add;
//в переменную "загоняем" текущий лист
Sheets := MsExcel.Workbooks[1].Sheets[1];
Except
ShowMessage('Не могу открыть Excel!');
Exit;
MsExcel.Quit;
MsExcel:=Unassigned;

end;//try-except

MsExcel.Visible := False;

case FormSprav.Tag of
1: //DataMdl.RvProject1.ExecuteReport('spobl');
   begin
   Sheets.Cells[2,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,3].Value := 'СПИСОК КОДИФИКАТОРОВ РЕГИОНОВ';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код региона';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,4];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Букв.код марки ГКПЖ';

   Cell1 := Sheets.Cells[4,5];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,8];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,5].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,5].Value := 'Регион (Республика, Край, Область)';
   Cell1 := Sheets.Cells[4,9];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,12];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,9].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,9].Value := 'Федеральный округ';

   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kod').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('kodb').AsString;
       Sheets.Cells[i+4,5].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,5].Value := ADOQuerySprav.FieldByName('spobl.im').AsString;
       Sheets.Cells[i+4,9].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,9].Value := ADOQuerySprav.FieldByName('kokr.im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
   end;
2: //DataMdl.RvProject1.ExecuteReport('kodra');
begin
   Sheets.Cells[2,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,4].Value := 'СПИСОК КОДИФИКАТОРОВ РАЙОНОВ';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код региона';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,5];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Регион(Республика,Край,Обл.)';

   Cell1 := Sheets.Cells[4,6];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,6].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,6].Value := 'Код рай.';

   Cell1 := Sheets.Cells[4,7];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,9];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,7].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,7].Value := 'Наименование района';


   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kod').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('spobl.im').AsString;
       Sheets.Cells[i+4,6].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,6].Value := ADOQuerySprav.FieldByName('kodraj').AsString;
       Sheets.Cells[i+4,7].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,7].Value := ADOQuerySprav.FieldByName('kodra.im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
end;   

3: //DataMdl.RvProject1.ExecuteReport('kodxoz');
begin
   Sheets.Cells[2,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,4].Value := 'СПИСОК КОДИФИКАТОРОВ ОРГАНИЗАЦИЙ';
   {
   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код региона';
   }
   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,3];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Регион(Республика,Край,Обл.)';
{
   Cell1 := Sheets.Cells[4,6];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,6].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,6].Value := 'Код рай.';
 }
   Cell1 := Sheets.Cells[4,4];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,4].Value := 'Наименование района';

   Cell1 := Sheets.Cells[4,7];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,7];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,7].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,7].Value := 'Код орг-ии';

   Cell1 := Sheets.Cells[4,8];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,10];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,8].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,8].Value := 'Наименование организации';


   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       {
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kodr').AsString;
       }
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('spobl.im').AsString;
       {
       Sheets.Cells[i+4,6].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,6].Value := ADOQuerySprav.FieldByName('kodraj').AsString;
       }
       Sheets.Cells[i+4,4].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,4].Value := ADOQuerySprav.FieldByName('kodra.im').AsString;
       Sheets.Cells[i+4,7].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,7].Value := ADOQuerySprav.FieldByName('kodx').AsString;
       Sheets.Cells[i+4,8].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,8].Value := ADOQuerySprav.FieldByName('kodxoz.im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;
  MsExcel.Visible := True;
end;


4: //DataMdl.RvProject1.ExecuteReport('kodkx');
begin
   Sheets.Cells[2,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК КАТЕГОРИЙ';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,1];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код';
   Cell1 := Sheets.Cells[4,2];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   //MsExcel.Selection.WrapText := true;
   Sheets.Cells[4,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,2].Value := 'Категория';

   Cell1 := Sheets.Cells[4,7];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,7];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
 {
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,7].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,7].Value := 'Код2';
  }
   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kat').AsString;
       Sheets.Cells[i+4,2].Select;
       MsExcel.Selection.Font.Size := 9;
{
       Cell1 := Sheets.Cells[4,2];
       Cell2 := Sheets.Cells[4,6];
       Range := Sheets.Range[Cell1, Cell2];
       Range.Select;
       Range.MergeCells := True;
       Range.WrapText := True;
}
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       if Length(ADOQuerySprav.FieldByName('val').AsString)<=45 then
         Sheets.Cells[i+4,2].Value := ADOQuerySprav.FieldByName('val').AsString
       else
       begin
       PosSpace := PosEx(' ',ADOQuerySprav.FieldByName('val').AsString,45);
       if PosSpace>0 then
         begin
         sIm1:=Copy(ADOQuerySprav.FieldByName('val').AsString,1,PosSpace);
         Sheets.Cells[i+4,2].Value := sIm1;
         sIm2:=Copy(ADOQuerySprav.FieldByName('val').AsString,PosSpace+1,50);
         Sheets.Cells[i+5,2].Value := sIm2;
         inc(i);
         end
         else
         Sheets.Cells[i+4,2].Value := ADOQuerySprav.FieldByName('val').AsString;
       end;

       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;
  MsExcel.Visible := True;
end;

5: //DataMdl.RvProject1.ExecuteReport('sppor');
   begin
   Sheets.Cells[2,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,4].Value := 'СПИСОК КОДИФИКАТОРОВ ПОРОД КРС';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Range := Sheets.Range[Cell1, Cell1];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Гр.родст.пород';

   Cell1 := Sheets.Cells[4,2];//Рисуем бордюр
   Range := Sheets.Range[Cell1, Cell1];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,2].Value := 'Код';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,5];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Порода КРС';

   Cell1 := Sheets.Cells[4,6];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,7];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,6].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,6].Value := 'Родонач-ник породы';

   Cell1 := Sheets.Cells[4,8];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,9];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,8].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,8].Value := 'Код родонач.породы';

   Cell1 := Sheets.Cells[4,10];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,11];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,10].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,10].Value := '????????';


   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('gr').AsString;
       Sheets.Cells[i+4,2].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,2].Value := ADOQuerySprav.FieldByName('kod').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('im').AsString;
       Sheets.Cells[i+4,6].Select;
       MsExcel.Selection.Font.Size := 9;
       if ADOQuerySprav.FieldByName('is_breed').AsString = 'True' then
       Sheets.Cells[i+4,6].Value := 'Да';
       if ADOQuerySprav.FieldByName('is_breed').AsString = 'False' then
       Sheets.Cells[i+4,6].Value := 'Нет';
       Sheets.Cells[i+4,8].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,8].Value := ADOQuerySprav.FieldByName('breed').AsString;
       Sheets.Cells[i+4,10].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,10].Value := ADOQuerySprav.FieldByName('dir_prod').AsString;

       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
   end;
6: //DataMdl.RvProject1.ExecuteReport('sklin');
   begin
   Sheets.Cells[2,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК КОДИФИКАТОРОВ ЛИНИЙ КРС';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[5,1];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Гр.родст. пород';

   Cell1 := Sheets.Cells[4,2];//Рисуем бордюр
   Cell2 := Sheets.Cells[5,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.VerticalAlignment := xlJustify;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,2].Value := 'Код                      ';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[5,5];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;

   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Кличка и ном. родоначальника линии';
 {
   Range.MergeCells := True;
   Sheets.Cells[5,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[5,5].Value := '';
  }

   Cell1 := Sheets.Cells[4,6];//Рисуем бордюр
   Cell2 := Sheets.Cells[5,7];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,6].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,6].Value := 'Марка и ном.ГКПЖ род. линии';



   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+5,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+5,1].Value := ADOQuerySprav.FieldByName('gr').AsString;
       Sheets.Cells[i+5,2].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+5,2].Value := ADOQuerySprav.FieldByName('kod').AsString;
       Sheets.Cells[i+5,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+5,3].Value := ADOQuerySprav.FieldByName('im').AsString;
       Sheets.Cells[i+5,6].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+5,6].Value := ADOQuerySprav.FieldByName('gkp').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
   end;


7: //DataMdl.RvProject1.ExecuteReport('kodup');
   begin
   Sheets.Cells[2,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК КОДИФИКАТОРОВ Улучшающих пород';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,1];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
//   Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код';

   Cell1 := Sheets.Cells[4,2];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,3];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.VerticalAlignment := xlJustify;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,2].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,2].Value := 'Улучшающая порода';

   Cell1 := Sheets.Cells[4,4];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,4];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   //Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;

   Sheets.Cells[4,4].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,4].Value := 'Код';
 {
   Range.MergeCells := True;
   Sheets.Cells[5,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[5,5].Value := '';
  }

   Cell1 := Sheets.Cells[4,5];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   //Range.WrapText := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,5].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,5].Value := 'Улучшаемая порода';



   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kodr').AsString;
       Sheets.Cells[i+4,2].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,2].Value := ADOQuerySprav.FieldByName('sppor.IM').AsString;
       Sheets.Cells[i+4,4].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,4].Value := ADOQuerySprav.FieldByName('kodu').AsString;
       Sheets.Cells[i+4,5].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,5].Value := ADOQuerySprav.FieldByName('sppor_1.IM').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
   end;

8: //DataMdl.RvProject1.ExecuteReport('kodst');
   begin
   Sheets.Cells[2,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК КОДИФИКАТОРОВ СТРАН';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,5];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Страна';

   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kodr').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
   end;


9: //DataMdl.RvProject1.ExecuteReport('kodkb');
   begin
   Sheets.Cells[2,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК КОДИФИКАТОРОВ БЫКОВ';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,5];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Категория быка';

   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kodr').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
 end;

10: //DataMdl.RvProject1.ExecuteReport('kokr');
   begin
   Sheets.Cells[2,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[2,2].Value := 'СПИСОК ФЕДЕРАЛЬНЫХ ОКРУГОВ';

   Cell1 := Sheets.Cells[4,1];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,2];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,1].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,1].Value := 'Код';

   Cell1 := Sheets.Cells[4,3];//Рисуем бордюр
   Cell2 := Sheets.Cells[4,6];
   Range := Sheets.Range[Cell1, Cell2];
   Range.MergeCells := True;
   Range.Select;
   MsExcel.Selection.Borders.LineStyle := xlContinuous;
   MsExcel.Selection.Borders.Weight := xlThin;
   Sheets.Cells[4,3].Select;
   MsExcel.Selection.Font.Size := 9;
   Sheets.Cells[4,3].Value := 'Федеральный округ';

   with DataMdl do
     begin
     Screen.Cursor := crHourGlass;
     i := 1;
     ADOQuerySprav.First;
     ADOQuerySprav.DisableControls;
     while not ADOQuerySprav.Eof do
       begin
       Sheets.Cells[i+4,1].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,1].Value := ADOQuerySprav.FieldByName('kod').AsString;
       Sheets.Cells[i+4,3].Select;
       MsExcel.Selection.Font.Size := 9;
       Sheets.Cells[i+4,3].Value := ADOQuerySprav.FieldByName('im').AsString;
       ADOQuerySprav.Next;
       inc(i);
       end;
     ADOQuerySprav.EnableControls;
     Screen.Cursor := crDefault;
     end;


   MsExcel.Visible := True;
 end;


end;

end;

procedure TFormSprav.SpdBtnSearchClick(Sender: TObject);
begin
if cbSearch.Text<>'' then
begin
case FormSprav.Tag of
1: DataMdl.ADOQuerySprav.Locate('spobl.im',Trim(cbSearch.Text),[loCaseInsensitive]);
2: DataMdl.ADOQuerySprav.Locate('spobl.im',Trim(cbSearch.Text),[loCaseInsensitive]);
3://организации
  //DataMdl.ADOQuerySprav.Locate('spobl.im',Trim(cbSearch.Text),[loCaseInsensitive]);
begin
FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.im, kodra.kodraj, kodra.im, kodxoz.kodx, kodxoz.im '+
              'FROM (spobl LEFT JOIN kodra ON spobl.kod = kodra.kodr) LEFT JOIN kodxoz ON '+
              '(kodra.kodr = kodxoz.kodr) AND (kodra.kodraj = kodxoz.kodraj)'+
              ' WHERE spobl.im='+''''+cbSearch.Text+''''+' ORDER BY spobl.kod, kodra.kodraj,kodxoz.kodx');
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
end;

4: DataMdl.ADOQuerySprav.Locate('val',Trim(cbSearch.Text),[loCaseInsensitive]);
5: DataMdl.ADOQuerySprav.Locate('im',Trim(cbSearch.Text),[loCaseInsensitive]);
6: DataMdl.ADOQuerySprav.Locate('im',Trim(cbSearch.Text),[loCaseInsensitive]);
7:  begin
    with DataMdl.ADOQueryOpt do
      begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT kod FROM sppor WHERE im='+''''+Trim(cbSearch.Text)+'''');
      Open;
      end;
    DataMdl.ADOQuerySprav.Locate('kodr',DataMdl.ADOQueryOpt.FieldByName('kod').AsString,[loCaseInsensitive]);
    end;
8: DataMdl.ADOQuerySprav.Locate('im',Trim(cbSearch.Text),[loCaseInsensitive]);
9: DataMdl.ADOQuerySprav.Locate('im',Trim(cbSearch.Text),[loCaseInsensitive]);
10: DataMdl.ADOQuerySprav.Locate('im',Trim(cbSearch.Text),[loCaseInsensitive]);

end;
end
else
Application.MessageBox('Ничего не выбрано.', 'Информация', MB_OK);
end;

procedure TFormSprav.DBGridSpravDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
with DBGridSprav.Canvas do
begin
if (gdSelected in State) then
  begin
  Brush.Color := clBlue;
  Font.Color := clWhite;
  FillRect(Rect);
  TextOut(Rect.Left,Rect.Top,Column.Field.Text);
  end
else
DBGridSprav.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TFormSprav.SpdBtnAddClick(Sender: TObject);
begin
FormSprav.DBGridSprav.SetFocus;
FormSprav.DBGridSprav.ReadOnly := False;
case FormSprav.Tag of
1: begin//регионы
   if not Assigned(FormAddRegion) then
     FormAddRegion := TFormAddRegion.Create(Application);
     FormAddRegion.Tag := 1;//Add new
     FormAddRegion.edtNameRegion.Text := '';
     FormAddRegion.edtCodeRegion.Text := IntToStr(MaxCode('spobl','kod','')+1);

     with FormAddRegion,DataMdl.ADOQueryOpt do
     begin
     Close;
     Sql.Clear;
     Sql.Add('SELECT * FROM kokr ORDER by im');
     Open;
     First;
     cbOkrug.Clear;
     while not Eof do
       begin
       cbOkrug.Items.Add(FieldByName('im').AsString);
       Next;
       end;
     end;

     FormAddRegion.ShowModal;
   end;
2: begin//районы
     if not Assigned(FormAddNewRajon) then
       FormAddNewRajon := TFormAddNewRajon.Create(Application);
     FormAddNewRajon.Tag := 1;//Add new
     FormAddNewRajon.lblRegion.Caption := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
     FormAddNewRajon.edtCodeRajon.Enabled := True;
     FormAddNewRajon.edtCodeRajon.Text := IntToStr(MaxCode('kodra','kodraj',' WHERE kodr='+DataMdl.ADOQuerySprav.FieldByName('kod').AsString)+1);
     FormAddNewRajon.edtNameRajon.Text := '';

     FormAddNewRajon.ShowModal;
   end;
3: begin//хозяйства
     if Trim(DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString)<>'' then
     begin
     if not Assigned(FormAddNewOrg) then
       FormAddNewOrg := TFormAddNewOrg.Create(Application);
     FormAddNewOrg.Tag := 1;//Add new
     FormAddNewOrg.edtCodeOrg.Enabled := True;
     FormAddNewOrg.lblRegion.Caption := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
    //FormAddNewOrg.lblRajon.Caption := DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString;
     region := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
     rajon := DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString;
     hoz := DataMdl.ADOQuerySprav.FieldByName('kodxoz.im').AsString;
     kodregion := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     kodrajon := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
     kodhoz := DataMdl.ADOQuerySprav.FieldByName('kodx').AsString;
     if region<>'' then
     begin
     DataMdl.ADOQueryTables.Close;
     DataMdl.ADOQueryTables.SQL.Clear;
     DataMdl.ADOQueryTables.SQL.Add('select im from kodra where kodr=(select kod from spobl where im='+''''+region+''''+')'+' ORDER BY im');
     DataMdl.ADOQueryTables.Open;
     DataMdl.ADOQueryTables.First;
     FormAddNewOrg.cbRajon.Clear;
     while not DataMdl.ADOQueryTables.Eof do
       begin
       FormAddNewOrg.cbRajon.Items.Add(DataMdl.ADOQueryTables.FieldByName('im').AsString);
       DataMdl.ADOQueryTables.Next;
       end;
      FormAddNewOrg.cbRajon.Text := FormAddNewOrg.cbRajon.Items.Strings[FormAddNewOrg.cbRajon.Items.IndexOf(rajon)];
     end;


     FormAddNewOrg.edtCodeOrg.Text := IntToStr(MaxCode('kodxoz','kodx',' WHERE kodr='+DataMdl.ADOQuerySprav.FieldByName('kod').AsString+
          ' AND kodraj='+DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString)+1);
     FormAddNewOrg.cbXozName.Text := '';

     FormAddNewOrg.ShowModal;
     end
     else
       Application.MessageBox('Сначала нужно добавить Район в справочник районов для этого Региона, а потом добавлять хозяйства.', 'Информация', MB_OK);
   end;
4: begin//категории
     if not Assigned(FormCategory) then
       FormCategory := TFormCategory.Create(Application);
     FormCategory.Tag := 1;//Add new
     FormCategory.edtCodeCat.Text := IntToStr(MaxCode('category','kat','')+1);
     FormCategory.edtNameCat.Text := '';

     FormCategory.ShowModal;
   end;
5: begin//породы
     if not Assigned(FormAddPor) then
       FormAddPor := TFormAddPor.Create(Application);
     FormAddPor.Tag := 1;//Add new

     FormAddPor.edtCodePor.Text := IntToStr(MaxCode('sppor','kod','')+1);
     FormAddPor.edtCodePor.Enabled := True;
     FormAddPor.edtGr.Text := '';
     FormAddPor.edtNamePor.Text := '';
     FormAddPor.cbKodb.Text := '';
     FormAddPor.cbIsBreed.Text := '';
     FormAddPor.edtBreed.Text := '';
     FormAddPor.edtDirProd.Text := '';

     FormAddPor.ShowModal;
     //FormAddPor.edtGr.SetFocus;
   end;
6: begin//линии
     if not Assigned(FormAddLinia) then
       FormAddLinia := TFormAddLinia.Create(Application);
     FormAddLinia.Tag := 1;//Add new

     //FormAddLinia.edtCodePor.Text := IntToStr(MaxCode('sppor','kod','')+1);
     FormAddLinia.edtGr.Enabled := True;
     FormAddLinia.edtCodeLinia.Enabled := True;
     FormAddLinia.edtGr.Text := '';
     FormAddLinia.edtCodeLinia.Text := '';
     FormAddLinia.edtNameLinia.Text := '';
     FormAddLinia.edtGKPG.Text := '';
     FormAddLinia.ShowModal;

   end;
{7: begin//улучшающие породы
     if not Assigned(FormAddBetPor) then
       FormAddBetPor := TFormAddBetPor.Create(Application);
     FormAddBetPor.Tag := 1;//Add new
with DataMdl,FormAddBetPor do
begin
     ADOQueryDop.Close;
     ADOQueryDop.SQL.Clear;
     ADOQueryDop.SQL.Add('SELECT im FROM sppor ORDER BY im');
     ADOQueryDop.Open;
     ADOQueryDop.First;
     cbKodr.Clear;
     cbKodu.Clear;
     while not ADOQueryDop.Eof do
     begin
     cbKodr.Items.Add(ADOQueryDop.FieldByName('im').AsString);
     cbKodu.Items.Add(ADOQueryDop.FieldByName('im').AsString);
     ADOQueryDop.Next;
     end;
end;
     FormAddBetPor.cbKodr.Text := '';
     FormAddBetPor.cbKodu.Text := '';
     FormAddBetPor.ShowModal;
   end;}
8: begin//страна
     if not Assigned(FormAddStr) then
       FormAddStr := TFormAddStr.Create(Application);
     FormAddStr.Tag := 1;//Add new
     FormAddStr.edtCodeStr.Enabled := True;
     FormAddStr.edtCodeStr.Text := '';
     FormAddStr.edtNameStr.Text := '';
     FormAddStr.ShowModal;

   end;
{9: begin//кат.быков
     if not Assigned(FormAddBool) then
       FormAddBool := TFormAddBool.Create(Application);
     FormAddBool.Tag := 1;//Add new
     FormAddBool.edtCodeKatBool.Enabled := True;
     FormAddBool.edtCodeKatBool.Text := '';
     FormAddBool.edtNameKatBool.Text := '';
     FormAddBool.ShowModal;
   end;}
10: begin//округа
     if not Assigned(FormOkrug) then
       FormOkrug := TFormOkrug.Create(Application);
     FormOkrug.Tag := 1;//Add new
     FormOkrug.edtCodeOkrug.Enabled := True;
     FormOkrug.edtCodeOkrug.Text := '';
     FormOkrug.edtNameOkrug.Text := '';
     FormOkrug.ShowModal;

   end;

end;




{
if not Assigned(FormAdd) then begin
    FormAdd  :=  TFormAdd.Create(Application);
    FormAdd.Show;
  end;
FormAdd.Show;
case FormSprav.Tag of
1: begin;
   with FormAdd do
     begin
     Label1.Caption := 'Кодификатор РЕГИОНОВ (РЕСПУБЛИКА, КРАЙ, ОБЛАСТЬ)';
     Label2.Caption := 'Код региона';
     Label3.Caption := 'Буквенный код марки ГКПЖ';
     Label4.Caption := 'Регион (Республика, Край, Область)';
     end;
   end;
2: DataMdl.RvProject1.ExecuteReport('kodra');
3: DataMdl.RvProject1.ExecuteReport('kodxoz');
4: DataMdl.RvProject1.ExecuteReport('kodkx');
5: DataMdl.RvProject1.ExecuteReport('sppor');
6: DataMdl.RvProject1.ExecuteReport('sklin');
7: DataMdl.RvProject1.ExecuteReport('kodup');
8: DataMdl.RvProject1.ExecuteReport('kodst');
9: DataMdl.RvProject1.ExecuteReport('kodkb');
end;
}
end;

procedure TFormSprav.SpdBtnSaveClick(Sender: TObject);
begin
//SpdBtnSave.Visible := False;
//SpdBtnCancel.Visible := False;
DataMdl.ADOQuerySprav.Post;
end;

procedure TFormSprav.SpdBtnCancelClick(Sender: TObject);
begin
//SpdBtnSave.Visible := False;
//SpdBtnCancel.Visible := False;
DataMdl.ADOQuerySprav.Cancel;
end;

procedure TFormSprav.SpdBtnDeleteClick(Sender: TObject);
var
keyField,keyField2: String;
begin
with DataMdl.ADOQuerySprav do begin
  if RecordCount = 0 then
    Exit;
  if MessageDlg('Удалить запись?', mtConfirmation,[mbYes, mbNo], 0)=mrYes then
    begin
    //if not Active then Open;
    DisableControls;
    //Delete;
    //ConnectionString := ConnectionStr;

    case FormSprav.Tag of
    1: begin//регион
       keyField := FieldbyName('kod').AsString;
       //проверяем есть ли в справочнике районов, районы
       //из этого региона, если есть удалять регион нельзя
       Close;
       SQL.Clear;
       SQL.Add('SELECT * FROM kodra WHERE kodr='+keyField);
       Open;
       if RecordCount=0 then
       begin

       Close;
       SQL.Clear;
       SQL.Add('delete from spobl where kod='+keyField);
       ExecSQL;

       Close;
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
       end
       else
       begin
       Application.MessageBox('Удаление Региона невозможно. Необходимо предварительно удалить все районы этого региона из справочника районов.', 'Информация', MB_OK);
       Close;
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
       FormSprav.Tag:=1;
       FormSprav.lblSearch.Caption:='Укажите нужный Вам РЕГИОН';
       end;
       end;
    2: begin//район
       keyField := FieldbyName('kodraj').AsString;
       kodregion := FieldbyName('kod').AsString;

       //проверяем есть ли в справочнике организаций, организации
       //из этого района, если есть удалять район нельзя
       Close;
       SQL.Clear;
       SQL.Add('SELECT * FROM kodxoz WHERE kodr='+kodregion+
               ' AND kodraj='+keyField);
       Open;
       if RecordCount=0 then
       begin

       Close;
       SQL.Clear;
       SQL.Add('delete from kodra where kodr='+kodregion+' AND kodraj='+keyField);
       ExecSQL;
       Close;

       FormSprav.OpenRajon;
       end
       else
       begin
       Application.MessageBox('Удаление Района невозможно. Необходимо предварительно удалить все организации этого района из справочника организаций.', 'Информация', MB_OK);
       FormSprav.OpenRajon;

       end;

       end;
    3: begin//организации
       keyField := FieldbyName('kodx').AsString;
       kodrajon := FieldbyName('kodraj').AsString;
       kodregion := FieldbyName('kod').AsString;

       Close;
       SQL.Clear;
       SQL.Add('delete from kodxoz where kodr='+kodregion+' AND kodraj='+kodrajon+' AND kodx='+keyField);
       ExecSQL;
FormMain.OpenMenuSprav('SELECT spobl.kod, spobl.im, kodra.kodraj, kodra.im, kodxoz.kodx, kodxoz.im '+
              'FROM (spobl LEFT JOIN kodra ON spobl.kod = kodra.kodr) LEFT JOIN kodxoz ON '+
              '(kodra.kodr = kodxoz.kodr) AND (kodra.kodraj = kodxoz.kodraj)'+
              ' WHERE spobl.kod='+kodregion+' ORDER BY spobl.kod, kodra.kodraj,kodxoz.kodx');
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


       //FormSprav.OpenXoz();
       end;
    4: begin//категории
       keyField := FieldbyName('kat').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from category where kat='+keyField);
       ExecSQL;


       FormMain.OpenMenuSprav('select * from category order by kat');
       DataMdl.ADOQuerySprav.FieldByName('kat').DisplayWidth := 7;
       DataMdl.ADOQuerySprav.FieldByName('kat').DisplayLabel := 'Код категории';
       DataMdl.ADOQuerySprav.FieldByName('val').DisplayWidth := 64;
       DataMdl.ADOQuerySprav.FieldByName('val').DisplayLabel := 'Категория';
       FormSprav.Tag := 4;
       FormSprav.lblSearch.Caption:='Укажите нужную Категорию';
       with DataMdl do
         begin
         ADOQuerySprav.First;
         FormSprav.cbSearch.Clear;
         while not ADOQuerySprav.Eof do
           begin
           FormSprav.cbSearch.Items.Add(ADOQuerySprav.FieldByName('val').AsString);
           ADOQuerySprav.Next;
           end;
         end;
      end;
    5: begin//poroda
       keyField := FieldbyName('kod').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from sppor where kod='+keyField);
       ExecSQL;

       FormSprav.OpenSprPorod();
       end;
    6: begin//linia
       keyField := FieldbyName('gr').AsString;
       keyField2 := FieldbyName('kod').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from sklin where gr='+keyField+' AND kod='+keyField2);
       ExecSQL;

       FormSprav.OpenSprLinia();
       end;
{    7: begin//улучшающие породы
       keyField := FieldbyName('kodr').AsString;
       keyField2 := FieldbyName('kodu').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from kodup where kodr='+keyField+' AND kodu='+keyField2);
       ExecSQL;

       FormSprav.OpenBetPor();
       end;}
    8: begin//страны
       keyField := FieldbyName('kodr').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from kodst where kodr='+keyField);
       ExecSQL;

       FormSprav.OpenStr();
       end;
{    9: begin//кат.быков
       keyField := FieldbyName('kodr').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from kodkb where kodr='+keyField);
       ExecSQL;

       FormSprav.OpenKatBool();
       end;}
    10: begin//округ
       keyField := FieldbyName('kod').AsString;
       Close;
       SQL.Clear;
       SQL.Add('delete from kokr where kod='+keyField);
       ExecSQL;

       FormSprav.OpenOkrug();
       end;




    end;//case
    EnableControls;
  end;//if
end;//with
end;

procedure TFormSprav.SpdBtnEditClick(Sender: TObject);
//var
//keyField: String;
begin;
//SpdBtnSave.Visible := True;
//SpdBtnCancel.Visible := True;
FormSprav.DBGridSprav.ReadOnly := False;
FormSprav.DBGridSprav.Options := FormSprav.DBGridSprav.Options+[dgEditing];
case FormSprav.Tag of
1: begin//region
   if not Assigned(FormAddRegion) then
     FormAddRegion := TFormAddRegion.Create(Application);
     FormAddRegion.Tag := 2;//edit
     FormAddRegion.edtCodeRegion.Enabled := False;
     FormAddRegion.edtCodeRegion.Text := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     FormAddRegion.edtGKPG.Text := DataMdl.ADOQuerySprav.FieldByName('kodb').AsString;
     FormAddRegion.edtNameRegion.Text := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
     with FormAddRegion,DataMdl.ADOQueryOpt do
     begin
     Close;
     Sql.Clear;
     Sql.Add('SELECT * FROM kokr ORDER by im');
     Open;
     First;
     cbOkrug.Clear;
     while not Eof do
       begin
       cbOkrug.Items.Add(FieldByName('im').AsString);
       Next;
       end;
     end;
     FormAddRegion.cbOkrug.Text := FormAddRegion.cbOkrug.Items.Strings[FormAddRegion.cbOkrug.Items.IndexOf(DataMdl.ADOQuerySprav.FieldByName('kokr.im').AsString)];

     FormAddRegion.ShowModal;
   end;
2: begin;//rajon
   if not Assigned(FormAddNewRajon) then
     FormAddNewRajon := TFormAddNewRajon.Create(Application);
   FormAddNewRajon.Tag := 2;//Edit
     FormAddNewRajon.edtCodeRajon.Enabled := True;
   FormAddNewRajon.lblRegion.Caption := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
   FormAddNewRajon.edtCodeRajon.Text := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
   FormAddNewRajon.edtNameRajon.Text := DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString;
   FormAddNewRajon.ShowModal;
   end;
3: begin;//xoz
     if Trim(DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString)<>'' then
     begin
     if not Assigned(FormAddNewOrg) then
       FormAddNewOrg := TFormAddNewOrg.Create(Application);
     FormAddNewOrg.Tag := 2;//Edit
     FormAddNewOrg.lblRegion.Caption := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
     //FormAddNewOrg.lblRajon.Caption := DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString;

     region := DataMdl.ADOQuerySprav.FieldByName('spobl.im').AsString;
     rajon := DataMdl.ADOQuerySprav.FieldByName('kodra.im').AsString;
     hoz := DataMdl.ADOQuerySprav.FieldByName('kodxoz.im').AsString;
     kodregion := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     kodrajon := DataMdl.ADOQuerySprav.FieldByName('kodraj').AsString;
     kodhoz := DataMdl.ADOQuerySprav.FieldByName('kodx').AsString;
     //заполняем районы
     if region<>'' then
     begin
     DataMdl.ADOQueryTables.Close;
     DataMdl.ADOQueryTables.SQL.Clear;
     DataMdl.ADOQueryTables.SQL.Add('select im from kodra where kodr=(select kod from spobl where im='+''''+region+''''+')'+' ORDER BY im');
     DataMdl.ADOQueryTables.Open;
     DataMdl.ADOQueryTables.First;
     FormAddNewOrg.cbRajon.Clear;
     while not DataMdl.ADOQueryTables.Eof do
       begin
       FormAddNewOrg.cbRajon.Items.Add(DataMdl.ADOQueryTables.FieldByName('im').AsString);
       DataMdl.ADOQueryTables.Next;
       end;
      FormAddNewOrg.cbRajon.Text := FormAddNewOrg.cbRajon.Items.Strings[FormAddNewOrg.cbRajon.Items.IndexOf(rajon)];
     end;
     //заполняем хозяйства для района
    if rajon<>'' then
     begin
     DataMdl.ADOQueryTables.Close;
     DataMdl.ADOQueryTables.SQL.Clear;
     DataMdl.ADOQueryTables.SQL.Add('SELECT im FROM kodxoz WHERE kodr='+kodregion+' AND kodraj='
     +kodrajon+' ORDER BY im');
     DataMdl.ADOQueryTables.Open;
     DataMdl.ADOQueryTables.First;
     FormAddNewOrg.cbXozName.Clear;
     while not DataMdl.ADOQueryTables.Eof do
       begin
       FormAddNewOrg.cbXozName.Items.Add(DataMdl.ADOQueryTables.FieldByName('im').AsString);
       DataMdl.ADOQueryTables.Next;
       end;
      FormAddNewOrg.cbXozName.Text := FormAddNewOrg.cbXozName.Items.Strings[FormAddNewOrg.cbXozName.Items.IndexOf(hoz)];
     end;


     FormAddNewOrg.edtCodeOrg.Enabled := False;
     FormAddNewOrg.edtCodeOrg.Text := kodhoz;
     FormAddNewOrg.cbXozName.Text := hoz;
     //FormAddNewOrg.edtNameOrg.Text := DataMdl.ADOQuerySprav.FieldByName('kodxoz.im').AsString;

     FormAddNewOrg.ShowModal;
     end
     else
       Application.MessageBox('Сначала нужно добавить Район в справочник районов для этого Региона, а потом добавлять хозяйства.', 'Информация', MB_OK);
   end;
4: begin//kat
     if not Assigned(FormCategory) then
       FormCategory := TFormCategory.Create(Application);
     FormCategory.Tag := 2;//edit
     FormCategory.edtCodeCat.Enabled := False;
     FormCategory.edtCodeCat.Text := DataMdl.ADOQuerySprav.FieldByName('kat').AsString;
     FormCategory.edtNameCat.Text := DataMdl.ADOQuerySprav.FieldByName('val').AsString;

     FormCategory.ShowModal;

   end;
5: begin//poroda
     if not Assigned(FormAddPor) then
       FormAddPor := TFormAddPor.Create(Application);
     FormAddPor.Tag := 2;//edit
     FormAddPor.edtCodePor.Enabled := False;
     FormAddPor.edtGr.Text := DataMdl.ADOQuerySprav.FieldByName('gr').AsString;
     FormAddPor.edtCodePor.Text := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     FormAddPor.edtNamePor.Text := DataMdl.ADOQuerySprav.FieldByName('im').AsString;
     if Trim(DataMdl.ADOQuerySprav.FieldByName('kodb').AsString) =  'v' then
     FormAddPor.cbKodb.Text := FormAddPor.cbKodb.Items.Strings[1]
     else
     FormAddPor.cbKodb.Text := FormAddPor.cbKodb.Items.Strings[0];
     if Trim(DataMdl.ADOQuerySprav.FieldByName('is_breed').AsString) = 'True' then
       FormAddPor.cbIsBreed.Text := FormAddPor.cbIsBreed.Items.Strings[0];
     if Trim(DataMdl.ADOQuerySprav.FieldByName('is_breed').AsString) = 'False' then
       FormAddPor.cbIsBreed.Text := FormAddPor.cbIsBreed.Items.Strings[1];
     FormAddPor.edtBreed.Text := DataMdl.ADOQuerySprav.FieldByName('breed').AsString;
     FormAddPor.edtDirProd.Text := DataMdl.ADOQuerySprav.FieldByName('dir_prod').AsString;

     FormAddPor.ShowModal;
    end;
6: begin//linia
     if not Assigned(FormAddLinia) then
       FormAddLinia := TFormAddLinia.Create(Application);
     FormAddLinia.Tag := 2;//edit
     FormAddLinia.edtGr.Enabled := False;
     FormAddLinia.edtCodeLinia.Enabled := False;

     FormAddLinia.edtGr.Text := DataMdl.ADOQuerySprav.FieldByName('gr').AsString;
     FormAddLinia.edtCodeLinia.Text := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     FormAddLinia.edtNameLinia.Text := DataMdl.ADOQuerySprav.FieldByName('im').AsString;
     FormAddLinia.edtGKPG.Text := DataMdl.ADOQuerySprav.FieldByName('gkp').AsString;

     FormAddLinia.ShowModal;

   end;
{7: begin//улучшающая порода kodup
     if not Assigned(FormAddBetPor) then
       FormAddBetPor := TFormAddBetPor.Create(Application);
     FormAddBetPor.Tag := 2;//edit
with DataMdl,FormAddBetPor do
begin
     ADOQueryDop.Close;
     ADOQueryDop.SQL.Clear;
     ADOQueryDop.SQL.Add('SELECT im FROM sppor ORDER BY im');
     ADOQueryDop.Open;
     ADOQueryDop.First;
     cbKodr.Clear;
     cbKodu.Clear;
     while not ADOQueryDop.Eof do
     begin
     cbKodr.Items.Add(ADOQueryDop.FieldByName('im').AsString);
     cbKodu.Items.Add(ADOQueryDop.FieldByName('im').AsString);
     ADOQueryDop.Next;
     end;
end;
     FormAddBetPor.cbKodr.Text := DataMdl.ADOQuerySprav.FieldByName('sppor.im').AsString;
     FormAddBetPor.cbKodu.Text := DataMdl.ADOQuerySprav.FieldByName('sppor_1.im').AsString;

     FormAddBetPor.ShowModal;

   end;}
8: begin//страна
     if not Assigned(FormAddStr) then
       FormAddStr := TFormAddStr.Create(Application);
     FormAddStr.Tag := 2;//edit
     FormAddStr.edtCodeStr.Enabled := False;

     FormAddStr.edtCodeStr.Text := DataMdl.ADOQuerySprav.FieldByName('kodr').AsString;
     FormAddStr.edtNameStr.Text := DataMdl.ADOQuerySprav.FieldByName('im').AsString;

     FormAddStr.ShowModal;

   end;
{9: begin//кат.быка
     if not Assigned(FormAddBool) then
       FormAddBool := TFormAddBool.Create(Application);
     FormAddBool.Tag := 2;//edit
     FormAddBool.edtCodeKatBool.Enabled := False;

     FormAddBool.edtCodeKatBool.Text := DataMdl.ADOQuerySprav.FieldByName('kodr').AsString;
     FormAddBool.edtNameKatBool.Text := DataMdl.ADOQuerySprav.FieldByName('im').AsString;

     FormAddBool.ShowModal;

   end;}
10: begin//округ
     if not Assigned(FormOkrug) then
       FormOkrug := TFormOkrug.Create(Application);
     FormOkrug.Tag := 2;//edit
     FormOkrug.edtCodeOkrug.Enabled := False;

     FormOkrug.edtCodeOkrug.Text := DataMdl.ADOQuerySprav.FieldByName('kod').AsString;
     FormOkrug.edtNameOkrug.Text := DataMdl.ADOQuerySprav.FieldByName('im').AsString;

     FormOkrug.ShowModal;

   end;


end;
end;


procedure TFormSprav.DBGridSpravKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = vk_Return then
  key := Vk_tab;
end;

procedure TFormSprav.cbSearchSelect(Sender: TObject);
begin
  FormSprav.SpdBtnAdd.Visible:=True;
  FormSprav.SpdBtnEdit.Visible:=True;
  FormSprav.SpdBtnDelete.Visible:=True;
end;

end.
