unit UnitListCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFormListCategory = class(TForm)
    lblDrb: TLabel;
    lblHoz: TLabel;
    lblInvNum: TLabel;
    lblKlichka: TLabel;
    lblLine: TLabel;
    DBGridCategory: TDBGrid;
    btnEdit: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowDBGridCategory();
  end;

var
  FormListCategory: TFormListCategory;

implementation

{$R *.dfm}

uses UnitDB, UnitVariables, UnitAddKatForBull, UnitMain;

//���������� ����� ���������
procedure TFormListCategory.btnAddClick(Sender: TObject);
begin
  isEditCategory := False;
  if not Assigned(FormAddKat) then
    FormAddKat := TFormAddKat.Create(Application);
  FormAddKat.ShowModal;
end;

//�������� ���������
procedure TFormListCategory.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('������� ��������� ' + dbGridCategory.Fields[1].AsString + '  ' + ' ��� ' +
    dbGridCategory.Fields[4].AsString + '  ' + dbGridCategory.Fields[5].AsString, mtConfirmation,[mbOK, mbCancel], 0)=mrOK then
  with DataMdl.ADOQueryBull do
    begin
      idLineage :=  dbGridCategory.Fields[0].AsString;
      Close;
      Sql.Clear;
      Sql.Add('DELETE FROM  lineage WHERE id=' + idLineage);
      ExecSQL;
    if RowsAffected > 0 then
      begin
        FormMain.ShowCouters();
        Application.MessageBox('������ �������!', '����������', MB_OK);
        ShowDBGridCategory();
      end
      else
      Application.MessageBox('������ �� ���� �������!', '����������', MB_OK);
    end;
end;

//�������������� ���������
procedure TFormListCategory.btnEditClick(Sender: TObject);
begin
  isEditCategory := True;
  idLineage := dbGridCategory.Fields[0].AsString;
  yearreport := dbGridCategory.Fields[1].AsString;
  sper := dbGridCategory.Fields[2].AsString;
  cena := dbGridCategory.Fields[3].AsString;
  category := dbGridCategory.Fields[4].AsString;
  poroda := dbGridCategory.Fields[5].AsString;
  kodkat := dbGridCategory.Fields[6].AsString;
  kodpor := dbGridCategory.Fields[7].AsString;
  if not Assigned(FormAddKat) then
    FormAddKat := TFormAddKat.Create(Application);
  FormAddKat.ShowModal;
end;

procedure TFormListCategory.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //��������� ������� �����
  FormMain.ShowDBGrid();
end;

procedure TFormListCategory.FormShow(Sender: TObject);
begin
//��������� label-� �� idBull
with DataMdl do
begin
  TBull.SelectBull(DataMdl.ADOQueryEdit,idBull);
  lblHoz.Caption := ADOQueryEdit.FieldByName('spobl.im').AsString + '  ' +
                    ADOQueryEdit.FieldByName('kodra.im').AsString + '  ' +
                    ADOQueryEdit.FieldByName('kodxoz.im').AsString;
  lblKlichka.Caption := ADOQueryEdit.FieldByName('klihkab').AsString;
  lblInvNum.Caption := ADOQueryEdit.FieldByName('inb').AsString;
  lblLine.Caption := ADOQueryEdit.FieldByName('sklin.IM').AsString;
  lblDrb.Caption := ADOQueryEDit.FieldByName('drb').AsString;
DBGridCategory.Options := DBGridCategory.Options - [dgEditing];//������ ������ ����
DBGridCategory.Options := DBGridCategory.Options + [dgRowSelect];//� ����� �������. ��� ������
ShowDBGridCategory();
end;
end;

procedure TFormListCategory.ShowDBGridCategory();
begin
//���������� dbGridBull
with DataMdl do
  begin
    ADOQueryCategory.Close;
    ADOQueryCategory.SQL.Clear;
    ADOQueryCategory.SQL.Add('SELECT lineage.id, lineage.yearreport as [���], lineage.sper '
      +' as [����,��� ���], lineage.cena as [���� ����� ����,���], '
      +'category.val as [���������], sppor.im as [������ ������], sppor.KOD, category.kat '
      +'FROM sppor RIGHT JOIN (lineage INNER JOIN category ON lineage.kodkat = category.kat) '
      +'ON sppor.KOD = lineage.pordaughter WHERE lineage.idbull=' + idBull
      + ' ORDER BY lineage.yearreport DESC');
    ADOQueryCategory.Open;
    DataSourceCategory.DataSet := ADOQueryCategory;
    DBGridCategory.DataSource := DataSourceCategory;
    DBGridCategory.Columns[0].Visible := False;
    DBGridCategory.Columns[3].Width := 120;
    DBGridCategory.Columns[4].Width := 80;
    DBGridCategory.Columns[6].Visible := False;
    DBGridCategory.Columns[7].Visible := False;
  end;
end;

end.
