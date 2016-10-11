unit UnitImportFromExcel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComObj, Vcl.StdCtrls;

type
  TFormImportFromExcel = class(TForm)
    btnImport: TButton;
    Label1: TLabel;
    cbYear: TComboBox;
    MemoImport: TMemo;
    procedure btnImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormImportFromExcel: TFormImportFromExcel;

implementation

{$R *.dfm}

uses UnitVariables, UnitDB, UnitMain;

procedure TFormImportFromExcel.btnImportClick(Sender: TObject);
const
  xlCellTypeLastCell = $0000000B;
var
  XLS,Sheet: Variant;
 // Range: Variant;
  invNum,dateBirth,katBull,kodPorDaug,sperm: Variant;
  invNumS,dateBirthS,katBullS,kodPorDaugS,spermS,tmp: String;
  i,firstRow,lastRow: Integer;
  yearreport: String;
begin
if Trim(cbYear.Text) <> '' then
begin
  yearreport := Trim(cbYear.Text);
  MemoImport.Clear;
  XLS := CreateOleObject('Excel.Application');
  try
    firstRow := 3;
    XLS.Visible := False;
    XLS.WorkBooks.Open(fPath);

    Sheet := XLS.Workbooks[ExtractFileName(fPath)].WorkSheets[1];
    // In order to know the dimension of the WorkSheet, i.e the number of rows
    // and the number of columns, we activate the last non-empty cell of it
    Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
    // Get the value of the last row
    lastRow := XLS.ActiveCell.Row;
    for i := firstRow to lastRow do
      begin//1
        // Retrieve the cell
        //Range := XLS.ActiveWorkBook.WorkSheets[1].Range['C4'];
        invNum := XLS.ActiveWorkBook.WorkSheets[1].Range['C'+IntToStr(i)];
        invNumS := invNum.Value;
        dateBirth := XLS.ActiveWorkBook.WorkSheets[1].Range['E'+IntToStr(i)];
        dateBirthS := dateBirth.Value;
        katBull := XLS.ActiveWorkBook.WorkSheets[1].Range['G'+IntToStr(i)];
        katBullS := katBull.Value;
        kodPorDaug := XLS.ActiveWorkBook.WorkSheets[1].Range['O'+IntToStr(i)];
        kodPorDaugS := kodPorDaug.Value;
        sperm := XLS.ActiveWorkBook.WorkSheets[1].Range['AF'+IntToStr(i)];
        spermS := sperm.Value;
        with DataMdl do
          begin//2
            //узнаем по названию(кириллица!!!) код категории
            ADOQuerySprav.Close;
            ADOQuerySprav.SQL.Clear;
            ADOQuerySprav.SQL.Add('SELECT kat FROM category WHERE val="' + katBullS
              +'" OR valEng="' + katBullS + '"');
            ADOQuerySprav.Open;
            kodkat :=  ADOQuerySprav.FieldByName('kat').AsString;
            if ADOQuerySprav.RecordCount > 0 then
            begin

            //узнаем id быка
            ADOQuerySprav.Close;
            ADOQuerySprav.SQL.Clear;
            ADOQuerySprav.SQL.Add('SELECT id FROM bull WHERE inb="' + invNumS +'" and drb="'
               + dateBirthS + '"');
               //+ StringReplace(dateBirthS,'.','/',[rfReplaceAll]) + '#');

            tmp := ADOQuerySprav.SQL.Text;

            ADOQuerySprav.Open;
            idBull :=  ADOQuerySprav.FieldByName('id').AsString;
            if ADOQuerySprav.RecordCount > 0 then
              begin//3

               //проверяем это новая запись или редактирование существующей
              //idbull+yearreport+pordaughter  -  д.б. уникальная
              ADOQuerySprav.Close;
              ADOQuerySprav.SQL.Clear;
              ADOQuerySprav.SQL.Add('SELECT id FROM lineage WHERE idbull=' + idBull
                + ' AND yearreport="' + cbYear.Text + '" AND pordaughter=' + kodPorDaugS);
              ADOQuerySprav.Open;
              idLineage :=  ADOQuerySprav.FieldByName('id').AsString;
              if ADOQuerySprav.RecordCount > 0 then
              begin//редактирование
                ADOQuerySprav.Close;
                ADOQuerySprav.SQL.Clear;
                ADOQuerySprav.SQL.Add('UPDATE lineage SET yearreport="' + yearreport
                          //+ '",sper="'  + Trim(edtSperm.Text) + '",cena="' + Trim(edtCena.Text)
                          + '",sper="'  + spermS + '",kodkat='+ kodkat + ',pordaughter='
                          + kodPorDaugS + ' WHERE id=' + idLineage);
                ADOQuerySprav.ExecSQL;
              if ADOQuerySprav.RowsAffected > 0 then
                MemoImport.Lines.Add(invNumS + '  ' + dateBirthS + '  ' + katBullS + '  ' + kodPorDaugS
                  + '  ' + spermS + ' импортировано')
              else
                MemoImport.Lines.Add(invNumS + '  ' + dateBirthS + '  ' + katBullS + '  ' + kodPorDaugS
                  + '  ' + spermS + ' не импортировано');

              end
              else//новый
              begin
                ADOQuerySprav.Close;
                ADOQuerySprav.SQL.Clear;
                {ADOQuerySprav.SQL.Add('INSERT INTO lineage(yearreport,idbull,pordaughter,kodkat) '
                          + 'SELECT "' + cbYear.Text + '",' + idBull + ',' + kodPorDaugS + ','
                          + katBullS + ' WHERE val=');}
                ADOQuerySprav.SQL.Add('INSERT INTO lineage(yearreport,idbull,sper,kodkat,pordaughter) '
                          + 'VALUES("' + yearreport + '",' + idBull + ',"' + spermS + '",' + kodkat + ','
                          + kodPorDaugS + ')');
                ADOQuerySprav.ExecSQL;
              if ADOQuerySprav.RowsAffected > 0 then
                MemoImport.Lines.Add(invNumS + '  ' + dateBirthS + '  ' + katBullS + '  ' + kodPorDaugS
                  + '  ' + spermS  + ' импортировано')
              else
                MemoImport.Lines.Add(invNumS + '  ' + dateBirthS + '  ' + katBullS + '  ' + kodPorDaugS
                  + '  ' + spermS  + ' не импортировано');
              end;
              //end;
              //3
              end
            else
              MemoImport.Lines.Add(invNumS + '  ' + dateBirthS + '  ' + katBullS + '  ' + kodPorDaugS + '  ' + spermS);
          end
          else
            MemoImport.Lines.Add('Ошибка при импорте, колонки документа не соответствуют эталону');

          end;
        // Read its content
        //Description := Range.Value;
      end;
    //ShowMessage(Description);  // Displays 'This is an item description'
    //ShowMessage(IntToStr(lastRow));
  finally
    //Range := null;             // Release reference
    Sheet := null;
    XLS.Quit;                  // Close Excel application
    XLS := null;               // Release reference
  end;
end
else
begin
  Application.MessageBox('Нужно выбрать год', 'Информация', MB_OK);
  cbYear.SetFocus;
end;
//заполняем БО для быков без оценки
MemoImport.Lines.Add(' ');
MemoImport.Lines.Add('Заполнено БО для быков всего ' + IntToStr(DataMdl.WithoutCategoryFill(yearreport)));
end;

procedure TFormImportFromExcel.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.ShowDBGrid();
end;

end.
