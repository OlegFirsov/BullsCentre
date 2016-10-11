unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ImgList, System.Actions,
  Vcl.ActnList, JRO_TLB, Vcl.OleServer, Vcl.ExtCtrls, System.UITypes;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    tbExcel: TToolBar;
    Bulls: TMenuItem;
    AddBull: TMenuItem;
    DBGridBull: TDBGrid;
    btnEditBull: TButton;
    btnCategory: TButton;
    btnDelete: TButton;
    N1: TMenuItem;
    Excel1: TMenuItem;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    cbYear: TComboBox;
    Label1: TLabel;
    btnOn: TButton;
    btnOff: TButton;
    Label2: TLabel;
    edtKlihka: TEdit;
    Label3: TLabel;
    edtInvNum: TEdit;
    cbCategory: TComboBox;
    Label4: TLabel;
    StatusBar1: TStatusBar;
    tbtnAddBull: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    ToolButton1: TToolButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    N13: TMenuItem;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    N14: TMenuItem;
    Action12: TAction;
    Action13: TAction;
    Label5: TLabel;
    cbPoroda: TComboBox;
    Label6: TLabel;
    cbHoz: TComboBox;
    N15: TMenuItem;
    N16: TMenuItem;
    Action14: TAction;
    N17: TMenuItem;
    Action15: TAction;
    N18: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Label7: TLabel;
    cbStatus: TComboBox;
    procedure AddBullClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditBullClick(Sender: TObject);
    procedure btnCategoryClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Excel1Click(Sender: TObject);
    procedure btnOnClick(Sender: TObject);
    procedure btnOffClick(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure Action15Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowDBGrid();
    procedure OpenMenuSprav(SQL: String);
    procedure ShowCouters();
  end;

function GetModName(): string;
function CreateNameForOutFile(): String;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses UnitVariables, UnitDB, UnitAddBull, UnitLogin, UnitListCategory, UnitImportFromExcel,
  UnitSprav, UnitAbout, UnitExchange;

procedure CreateFolder(Dir: string);
begin
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);
end;

function GetModName(): string;
var
  fName: string;
  nsize: cardinal;
begin
  nsize := 128;
  SetLength(fName, nsize);
  SetLength(fName,
    GetModuleFileName(
    hinstance,
    pchar(fName),
    nsize));
  Result := fName;
end;

function CreateNameForOutFile(): String;
begin
Result:='bull'+FormatDateTime('ddmmyyhhmm',Now)+'.xml';
end;

//����������� ������
procedure TFormMain.Action10Execute(Sender: TObject);
begin
  FormSprav.OpenSprPorod();
end;


procedure TFormMain.Action11Execute(Sender: TObject);
begin
  FormSprav.OpenSprLinia();
end;

//����������� ������
procedure TFormMain.Action12Execute(Sender: TObject);
begin
  FormSprav.OpenStr();
end;

//����������� ������
procedure TFormMain.Action13Execute(Sender: TObject);
begin
  FormSprav.OpenOkrug();
end;

//������� ������
procedure TFormMain.Action14Execute(Sender: TObject);
begin
  isSend := False;
  if not Assigned(FormExchange) then
    FormExchange := TFormExchange.Create(Application);
  FormExchange.ShowModal;
end;

//��������� ������
procedure TFormMain.Action15Execute(Sender: TObject);
begin
  isSend := True;
  if not Assigned(FormExchange) then
    FormExchange := TFormExchange.Create(Application);
  FormExchange.ShowModal;
end;

procedure TFormMain.Action3Execute(Sender: TObject);
//������� ����� ��
var
nFile: String;
begin
nFile:=FormatDateTime('ddmmyyhhmm',Now);
if CopyFile(PWideChar(FullPathToProg+'bulls.mdb'),PWideChar(FullPathToProg+'arch\'+
            'bulls'+nFile+'.mdb'),False) then
  Application.MessageBox(PWideChar('������� ����� ��   '+FullPathToProg+'arch\'+
            'bulls'+nFile+'.mdb'), '����������', MB_OK)
  else
  Application.MessageBox('�� ������� ������� ����� ��, �������� �� ������, ���������� � ���������� ��� ���!', '����������', MB_OK);
end;

//������������ �� ������ ��
procedure TFormMain.Action4Execute(Sender: TObject);
begin
OpenDialog1.InitialDir := FullPathToProg+'arch\';
OpenDialog1.Filter := 'access (*.mdb)|*.mdb';
if OpenDialog1.Execute then
  begin
  if MessageDlg('�� ������������� ������ �������������� �� '+OpenDialog1.FileName+'?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
    if CopyFile(PWideChar(OpenDialog1.FileName),PWideChar(FullPathToProg+'bulls.mdb'),False) then
      Application.MessageBox(PWideChar('�� ������� ������������� �� �����.'), '����������', MB_OK)
    else
    Application.MessageBox('�� ������� ������������ ��, �������� �� ������, ���������� � ���������� ��� ���!', '����������', MB_OK);
    end;
  end;

end;

//����� ��
procedure TFormMain.Action5Execute(Sender: TObject);
const
  a =  '00324';
var
JE: TJetEngine;
sDBFile,sTempFile,sArchFile: String;
bAllOK: Boolean;
sProvider: String;
b: ShortString;
begin
b := transform(a);
sProvider := 'Provider=Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Database Password='+ b + ';Data Source=';
with DataMdl do
  begin
  if ADOQueryBull.Active then ADOQueryBull.Close;
  if ADOQueryEdit.Active then ADOQueryEdit.Close;
  if ADOQuerySprav.Active then ADOQuerySprav.Close;
  if ADOQueryCategory.Active then ADOQueryCategory.Close;
  if ADOQueryOpt.Active then ADOQueryOpt.Close;
  if ADOQueryTables.Active then ADOQueryTables.Close;
  if ADOQuerySprSost.Active then ADOQueryTables.Close;
  if ADOConnection1.Connected then ADOConnection1.Close;
  end;

bAllOK:=True;
sDBFile := FullPathToProg+'bulls.mdb';
sTempFile := FullPathToProg+'tempbulls.mdb';
if FileExists(sTempFile) then DeleteFile(sTempFile);
if not FileExists(sDBFile) then
  begin
  ShowMessage('���� ���� ������ "'+sDBFile+'" �� ������!!!');
  exit;
  end;
Screen.Cursor := crHourGlass;
try
  JE:=TJetEngine.Create(Self);
  JE.AutoConnect := False;
  JE.ConnectKind := ckRunningOrNew;
  try
  JE.CompactDatabase(sProvider+sDBFile,sProvider+sTempFile);
  except
  on E: Exception do
    begin
    bAllOK:=False;
    Application.MessageBox(PWideChar('���� �� ����� ���� �����.������� �� ��������� � ���������� '+
               '��� ���.'),PWideChar('����������'),MB_ICONINFORMATION);
    end;
  end;
  JE.Free;

except
on E: Exception do
  begin
  bAllOK:=False;
  ShowMessage('������.������� �� ��������� � ���������� ��� ���.');
  end;
end;
Screen.Cursor:=crDefault;
if bAllOK then
  begin
  try
  sArchFile:=FullPathToProg+'arch\'+'bulls'+FormatDateTime('ddmmyyhhnnss',now)+'.mdb';
  if RenameFile(sDBFile,sArchFile) then
    begin
    ShowMessage('���� ���� ������ �� �������� ��� ������� � �����:  '+sArchFile);
    if RenameFile(sTempFile,sDBFile) then
      ShowMessage('���� ���� ������ bulls.mdb ��� ������� ����.');;
    end
    else
    ShowMessage('�� ������� ����� ��. ������� �� ��������� � ���������� ��� ���.');
  except
  end;
  end;
  DataMdl.ConnectToDB();
  ShowDBGrid();
end;

//����������� �������
procedure TFormMain.Action6Execute(Sender: TObject);
begin
FormSprav.Caption:='������ �� �������������. ����������� �������� (����������, ����, �������)';
//OpenMenuSprav('select * from spobl order by kod');
OpenMenuSprav('SELECT spobl.kod, spobl.kodb, spobl.im, kokr.im '+
 'FROM spobl INNER JOIN kokr ON spobl.okrug = kokr.kod ORDER BY spobl.im');
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayWidth:=7;
DataMdl.ADOQuerySprav.FieldByName('kod').DisplayLabel:='��� �������';
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayWidth:=24;
DataMdl.ADOQuerySprav.FieldByName('kodb').DisplayLabel:='��������� ��� ����� ����';
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayWidth:=64;
DataMdl.ADOQuerySprav.FieldByName('spobl.im').DisplayLabel:='������ (����������, ����, �������)';
DataMdl.ADOQuerySprav.FieldByName('kokr.im').DisplayWidth:=40;
DataMdl.ADOQuerySprav.FieldByName('kokr.im').DisplayLabel:='����������� �����';
//FormSprav.DBNavigatorSprav.VisibleButtons:=[nbFirst,nbPrior,nbNext,nbLast];
FormSprav.Tag:=1;
FormSprav.lblSearch.Caption:='������� ������ ��� ������';
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
FormSprav.SpdBtnSearch.Visible:=True;
FormSprav.cbSearch.Visible:=True;
FormSprav.lblSearch.Visible:=True;
FormSprav.SpdBtnAdd.Visible:=True;
FormSprav.SpdBtnEdit.Visible:=True;
FormSprav.SpdBtnDelete.Visible:=True;

end;

//����������� ������
procedure TFormMain.Action7Execute(Sender: TObject);
begin
  FormSprav.OpenRajon();
end;

//����������� ���������
procedure TFormMain.Action8Execute(Sender: TObject);
begin
  FormSprav.OpenXoz();
end;

//���������
procedure TFormMain.Action9Execute(Sender: TObject);
begin
//FormSprav.SpdBtnSave.Visible:=False;
//FormSprav.SpdBtnCancel.Visible:=False;
  FormSprav.OpenSprCat();
end;

procedure TFormMain.AddBullClick(Sender: TObject);
begin
  isEditBull := False;
  isEditCategory := False;
  if not Assigned(FormAddBull) then
    FormAddBull := TFormAddBull.Create(Application);
  FormAddBull.ShowModal;

end;

//�����������(���������) ��������� ���������� ����
procedure TFormMain.btnCategoryClick(Sender: TObject);
begin
  //������ idBull
  idBull :=  dbGridBull.Fields[0].AsString;
  isEditCategory := True;
  if not Assigned(FormListCategory) then
    FormListCategory := TFormListCategory.Create(Application);
  FormListCategory.ShowModal;
  //
end;

procedure TFormMain.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('������� ���� ' + dbGridBull.Fields[1].AsString + '  ' + ' ���.� ' +
    dbGridBull.Fields[2].AsString + ' �� ����� ��� �������?', mtConfirmation,[mbOK, mbCancel], 0)=mrOK then
    with DataMdl do
    begin
      idBull :=  dbGridBull.Fields[0].AsString;
      ADOQuerySprav.Close;
      ADOQuerySprav.SQL.Clear;
      ADOQuerySprav.SQL.Add('DELETE FROM  bull WHERE id=' + idBull);
    ADOQuerySprav.ExecSQL;
    if ADOQuerySprav.RowsAffected > 0 then
      begin
        Application.MessageBox('������ �������!', '����������', MB_OK);
        ShowCouters();
        ShowDBGrid()
      end
      else
      Application.MessageBox('������ �� ���� �������!', '����������', MB_OK);
    end;

end;

procedure TFormMain.btnEditBullClick(Sender: TObject);
begin
  //������ idBull
  idBull :=  dbGridBull.Fields[0].AsString;
  isEditBull := True;//����������� ����
  if not Assigned(FormAddBull) then
    FormAddBull := TFormAddBull.Create(Application);
  FormAddBull.ShowModal;
end;

//��������� ������
procedure TFormMain.btnOffClick(Sender: TObject);
begin
  ShowCouters();
  ShowDBGrid();
  //������� ���� �������
  cbYear.ItemIndex := -1;
  cbPoroda.ItemIndex := -1;
  cbCategory.ItemIndex := -1;
  cbStatus.ItemIndex := -1;
  edtKlihka.Text := '';
  edtInvNum.Text := '';
end;

//�������� ������
procedure TFormMain.btnOnClick(Sender: TObject);
var
  cnt: Integer;
  separator: String;
begin
  cnt := 0;
  if Trim(cbYear.Text) <> '' then inc(cnt);
  if Trim(edtKlihka.Text) <> '' then inc(cnt);
  if Trim(edtInvNum.Text) <> '' then inc(cnt);
  if Trim(cbPoroda.Text) <> '' then inc(cnt);
  if Trim(cbCategory.Text) <> '' then inc(cnt);
  if Trim(cbHoz.Text) <> '' then inc(cnt);
  if Trim(cbStatus.Text) <> '' then inc(cnt);
  
  if cnt = 0 then
    begin
      ShowMessage('�� ������ ������');
      exit;
    end;
   with DataMdl.ADOQueryCategory do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT bull.id, bull.status as ������, bull.klihkab AS ������, bull.inb AS [��� �����], bull.drb'
      +' AS [���� ��������], sklin.IM AS �����, lineage.yearreport AS [��� ������], category.val'
      +' AS ���������,  sppor_1.IM AS [������ ����],sppor.IM AS [������ ������], kodxoz.im as'
      +' [���������], lineage.sper AS [����� ������,��� ���] FROM kodxoz INNER JOIN'
      +' (kodra INNER JOIN (spobl INNER JOIN ((sppor RIGHT JOIN (sklin INNER JOIN(category RIGHT JOIN'
      +' (bull LEFT JOIN lineage ON bull.id = lineage.idbull) ON category.kat = lineage.kodkat)'
      +' ON (sklin.GR = bull.grb) AND (sklin.KOD = bull.linb)) ON sppor.KOD = lineage.pordaughter)'
      +' INNER JOIN sppor AS sppor_1 ON bull.porb = sppor_1.KOD) ON spobl.kod = bull.kodr) '
      +'ON (kodra.kodr = spobl.kod) AND (kodra.kodraj = bull.kodrn)) ON (kodxoz.kodr = spobl.kod)'
      +' AND (kodxoz.kodraj = kodra.kodraj) AND (kodxoz.kodx = bull.kodh) WHERE');
      if Trim(cbYear.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' yearreport="' + Trim(cbYear.Text) + '"' + separator);
      end;
      if Trim(edtKlihka.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' bull.klihkab LIKE "' + Trim(edtKlihka.Text) + '%"' + separator);
      end;
      if Trim(edtInvNum.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' bull.inb LIKE "' + Trim(edtInvNum.Text) + '%"' + separator);
      end;
      if Trim(cbPoroda.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' sppor_1.IM=`' + Trim(cbPoroda.Text) + '`' + separator);
      end;
      if Trim(cbCategory.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' category.val="' + Trim(cbCategory.Text) + '"' + separator);
      end;
      if Trim(cbHoz.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' kodxoz.im=' + chr(39) + Trim(cbHoz.Text) + chr(39) + separator);
      end;
      if Trim(cbStatus.Text) <> '' then
      begin
        dec(cnt);
        if cnt > 0 then
          separator := ' AND '
        else
          separator := ' ';
        Sql.Add(' bull.status="' + Trim(cbStatus.Text) + '"' + separator);
      end;

      Sql.Add('ORDER BY  bull.klihkab ASC,lineage.yearreport DESC');
      Open;
      StatusBar1.Panels[1].Text := ' ����� ������� ' + IntToStr(RecordCount) + ' �������';
    end;
    DataMdl.DataSourceBull.DataSet := DataMdl.ADOQueryCategory;
    DBGridBull.DataSource := DataMdl.DataSourceBull;
    DBGridBull.Columns[0].Visible := False;
    DBGridBull.Columns[1].Width := 60;
    DBGridBull.Columns[2].Width := 110;
    DBGridBull.Columns[3].Width := 60;
    DBGridBull.Columns[4].Width := 100;
    DBGridBull.Columns[5].Width := 160;
    DBGridBull.Columns[6].Width := 80;
    DBGridBull.Columns[7].Width := 70;
    DBGridBull.Columns[8].Width := 110;
end;

//������ ��������� �� ����� excel
procedure TFormMain.Excel1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := '';
  OpenDialog1.Filter := 'Excel (*.xls)|*.xls';
  if OpenDialog1.Execute then
  begin
    fPath := OpenDialog1.FileName;
    if not Assigned(FormImportFromExcel) then
      FormImportFromExcel := TFormImportFromExcel.Create(Application);
    FormImportFromExcel.ShowModal;
  end;
end;


procedure TFormMain.FormResize(Sender: TObject);
begin
  DBGridBull.Width := FormMain.Width - 15;
  DBGridBull.Height := FormMain.Height - 200;
  GroupBox1.Top := FormMain.Height - 165;
  BtnCategory.Top := FormMain.Height - 160;
  BtnDelete.Top := FormMain.Height - 132;
  BtnEditBull.Top := FormMain.Height - 103;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FullPathToProg := ExtractFilePath(GetModName());
  InFolder:=FullPathToProg+'\in';
  CreateFolder(InFolder);
  CreateFolder(InFolder + '\arch');
  OutFolder:=FullPathToProg+'\out';
  CreateFolder(OutFolder);
  CreateFolder(OutFolder + '\arch');
  ArchFolder := FullPathToProg+'\arch';
  CreateFolder(ArchFolder);

{ DocFolder:=FullPathToProg+'\doc';
  CreateFolder(DocFolder);}


  //���������� dbGridBull
  DBGridBull.Options := DBGridBull.Options - [dgEditing];//������ ������ ����
  DBGridBull.Options := DBGridBull.Options + [dgRowSElect];//� ����� �������. ��� ������
  ShowDBGrid();
  with DataMdl.ADOQuerySprav do
  begin
    //��������� ���������
    Close;
    SQL.Clear;
    SQL.Add('SELECT DISTINCT val FROM category ORDER BY val');
    Open;
    First;
    cbCategory.Clear;
  while not Eof do
    begin
      cbCategory.Items.Add(FieldByName('val').AsString);
      Next;
   end;
   //��������� ������
    SQL.Clear;
    SQL.Add('SELECT DISTINCT im FROM sppor ORDER BY im');
    Open;
    First;
    cbPoroda.Clear;
     while not Eof do
    begin
      cbPoroda.Items.Add(FieldByName('im').AsString);
      Next;
   end;
   //��������� ���������
    SQL.Clear;
    SQL.Add('SELECT DISTINCT im FROM kodxoz ORDER BY im');
    Open;
    First;
    cbHoz.Clear;
     while not Eof do
    begin
      cbHoz.Items.Add(FieldByName('im').AsString);
      Next;
   end;
  end;
  ShowCouters();
end;

//� ���������
procedure TFormMain.N15Click(Sender: TObject);
begin
  if not Assigned(AboutBox) then
    AboutBox := TAboutBox.Create(Application);
  AboutBox.ShowModal;
end;

procedure TFormMain.N16Click(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ShowDBGrid();
begin
//���������� dbGridBull
with DataMdl do
  begin
    ADOQueryBull.Close;
    ADOQueryBull.SQL.Clear;
    ADOQueryBull.SQL.Add('SELECT bull.id, bull.status as ������, bull.klihkab AS ������, bull.inb AS [��� �����], bull.drb'
      +' AS [���� ��������], sklin.IM AS �����, lineage.yearreport AS [��� ������], category.val'
      +' AS ���������,  sppor_1.IM AS [������ ����],sppor.IM AS [������ ������], kodxoz.im as'
      +' [���������], lineage.sper AS [����� ������,��� ���] FROM kodxoz INNER JOIN'
      +' (kodra INNER JOIN (spobl INNER JOIN ((sppor RIGHT JOIN (sklin INNER JOIN(category RIGHT JOIN'
      +' (bull LEFT JOIN lineage ON bull.id = lineage.idbull) ON category.kat = lineage.kodkat)'
      +' ON (sklin.GR = bull.grb) AND (sklin.KOD = bull.linb)) ON sppor.KOD = lineage.pordaughter)'
      +' INNER JOIN sppor AS sppor_1 ON bull.porb = sppor_1.KOD) ON spobl.kod = bull.kodr) '
      +'ON (kodra.kodr = spobl.kod) AND (kodra.kodraj = bull.kodrn)) ON (kodxoz.kodr = spobl.kod)'
      +' AND (kodxoz.kodraj = kodra.kodraj) AND (kodxoz.kodx = bull.kodh) ORDER BY bull.klihkab,'
      +' lineage.yearreport DESC');
      //, lineage.sper as [������� ������,��� ���]
//      +' (sklin INNER JOIN (bull INNER JOIN lineage '
//      +'ON bull.id = lineage.idbull) ON (bull.grb = sklin.GR) AND (sklin.KOD = bull.linb)) '
//      +'INNER JOIN category ON lineage.kodkat = category.kat');
    ADOQueryBull.Open;
    //StatusBar1.Panels[1].Text := ' ����� ������� ' + IntToStr(ADOQueryBull.re RecordCount) + ' �������';
    DataSourceBull.DataSet := ADOQueryBull;
    DBGridBull.DataSource := DataSourceBull;
    DBGridBull.Columns[0].Visible := False;
    DBGridBull.Columns[1].Width := 60;
    DBGridBull.Columns[2].Width := 110;
    DBGridBull.Columns[3].Width := 60;
    DBGridBull.Columns[4].Width := 100;
    DBGridBull.Columns[5].Width := 160;
    DBGridBull.Columns[6].Width := 80;
    DBGridBull.Columns[7].Width := 70;
    DBGridBull.Columns[8].Width := 110;
    DBGridBull.Columns[9].Width := 110;
    DBGridBull.Columns[10].Width := 120;
  end;

end;

procedure TFormMain.OpenMenuSprav(SQL: String);
begin
if not Assigned(FormSprav) then begin
    FormSprav := TFormSprav.Create(Application);
    FormSprav.Show;
  end;
with FormSprav do
  begin;
  Show;
  //SpdBtnSave.Visible:=False;
  //SpdBtnCancel.Visible:=False;
  DBGridSprav.ReadOnly:=True;
  end;
with DataMdl do
  begin
  //ADOQuerySprav.ConnectionString:=ConnectionStr;
  ADOQuerySprav.Close;
  ADOQuerySprav.SQL.Clear;
  ADOQuerySprav.SQL.Add(SQL);
  ADOQuerySprav.Open;
  DataSourceSprav.DataSet:=AdoQuerySprav;
  FormSprav.DbGridSprav.DataSource:=DataSourceSprav;
  FormSprav.DBNavigatorSprav.DataSource:=DataSourceSprav;
  end;
end;

//������� � statusbar ���������� ����� � ������
procedure TFormMain.ShowCouters;
begin
  StatusBar1.Panels[1].Text := ' �����: ' + IntToStr(DataMdl.CounterBulls(DataMdl.ADOQuerySprSost))
    + '  ������: ' + IntToStr(DataMdl.CounterLineages(DataMdl.ADOQuerySprSost));
end;

end.
