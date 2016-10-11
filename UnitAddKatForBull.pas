unit UnitAddKatForBull;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormAddKat = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cbCategory: TComboBox;
    cbYear: TComboBox;
    lblHoz: TLabel;
    lblKlichka: TLabel;
    lblLine: TLabel;
    lblDrb: TLabel;
    lblInvNum: TLabel;
    btnSave: TButton;
    Label3: TLabel;
    Label4: TLabel;
    edtSperm: TEdit;
    edtCena: TEdit;
    Label5: TLabel;
    cbPorDaughter: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbCategorySelect(Sender: TObject);
    procedure edtSpermExit(Sender: TObject);
    procedure edtSpermKeyPress(Sender: TObject; var Key: Char);
    procedure cbPorDaughterSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure CMDialogKey(var Msg:TWMKey);message CM_DIALOGKEY;
  public
    { Public declarations }
  end;

var
  FormAddKat: TFormAddKat;

implementation

{$R *.dfm}

uses UnitVariables, UnitDB, UnitAddBull, UnitListCategory, UnitMain;

var
  kodPorDaughter: String;

procedure TFormAddKat.CMDialogKey(var Msg:TWMKey);//������� ����� �������� �� Enter ��� Tab
begin
  if not (ActiveControl is TButton) then
  if Msg.Charcode = 13 then
  Msg.Charcode := 9;
  inherited;
end;

//��������� ��������� � ��. ���� ��� ������ ������
procedure TFormAddKat.btnSaveClick(Sender: TObject);
begin
   if (cbYear.Text <> '') and (cbCategory.Text <> '') and (cbPorDaughter.Text <> '')
    and (Trim(edtSperm.Text) <> '')
    {and (Trim(edtCena.Text) <> '')} then
    begin
    with DataMdl do
    begin
    if Trim(edtSperm.Text) = '' then
      edtSperm.Text := '0';
    if Trim(edtCena.Text) = '' then
      edtCena.Text := '0';

    //�������������� ������������, ������ � FormListCategory
    if isEditCategory then
      begin
        //������ ��������� � ������ ������, ���������� ��� ����� ������� ������
        FormAddKat.cbCategorySelect(cbCategory);
        FormAddKat.cbPorDaughterSelect(cbPorDaughter);
        ADOQuerySprav.Close;
        ADOQuerySprav.SQL.Clear;
        ADOQuerySprav.SQL.Add('UPDATE lineage SET yearreport="' + cbYear.Text
                  + '",sper="'  + Trim(edtSperm.Text) + '",cena="' + Trim(edtCena.Text)
                  + '",kodkat='+ kodkat + ',pordaughter=' + kodPorDaughter + ' WHERE id=' + idLineage);
        ADOQuerySprav.ExecSQL;
      if ADOQuerySprav.RowsAffected > 0 then
        Application.MessageBox('������ ���������������!', '����������', MB_OK)
      else
        Application.MessageBox('������ �� ���� ���������������!', '����������', MB_OK);

        exit;
      end;

    //��������� ��� ����� ������ ��� �������������� ������������
    //idbull+yearreport+pordaughter  -  �.�. ����������
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT id FROM lineage WHERE idbull=' + idBull
      + ' AND yearreport="' + cbYear.Text + '" AND pordaughter=' + kodPorDaughter);
    ADOQuerySprav.Open;
    idLineage :=  ADOQuerySprav.FieldByName('id').AsString;
    if ADOQuerySprav.RecordCount > 0 then
    begin//��������������
      ADOQuerySprav.Close;
      ADOQuerySprav.SQL.Clear;
      ADOQuerySprav.SQL.Add('UPDATE lineage SET yearreport="' + cbYear.Text
                + '",sper="'  + Trim(edtSperm.Text) + '",cena="' + Trim(edtCena.Text)
                + '",kodkat='+ kodkat + ',pordaughter=' + kodPorDaughter + ' WHERE id=' + idLineage);
      ADOQuerySprav.ExecSQL;
    if ADOQuerySprav.RowsAffected > 0 then
      Application.MessageBox('������ ��������!', '����������', MB_OK)
    else
      Application.MessageBox('������ �� ���� ��������!', '����������', MB_OK);

    end
    else//�����
    begin
      ADOQuerySprav.Close;
      ADOQuerySprav.SQL.Clear;
      ADOQuerySprav.SQL.Add('INSERT INTO lineage(yearreport,idbull,sper,cena,kodkat,pordaughter) '
                + 'VALUES("' + cbYear.Text + '",' + idBull + ',"' + Trim(edtSperm.Text) + '","'
                + Trim(edtCena.Text) + '",' + kodkat + ',' + kodPorDaughter + ')');
      ADOQuerySprav.ExecSQL;
    if ADOQuerySprav.RowsAffected > 0 then
      begin
        FormMain.ShowCouters();
        Application.MessageBox('������ ���������!', '����������', MB_OK);
      end
    else
      Application.MessageBox('������ �� ���� ���������!', '����������', MB_OK);
    end;
    end;

    end
    else
      Application.MessageBox('�� ��� ���� ���������!', '����������', MB_OK);
end;

procedure TFormAddKat.cbCategorySelect(Sender: TObject);
var
  category: String;
begin
  category := cbCategory.Text;
  //��� insert � category
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT kat FROM category WHERE val='+''''+ category +'''');
    ADOQuerySprav.Open;
    kodkat := ADOQuerySprav.FieldByName('kat').AsString;
  end;
  //��->�� � ������ �������� ������ ������, ���� ��� ������
  if category = '��' then
    begin
      cbPorDaughter.ItemIndex := cbPorDaughter.Items.IndexOf('��');
      FormAddKat.cbPorDaughterSelect(cbPorDaughter);
      cbPorDaughter.Enabled := False;
    end
    else
      cbPorDaughter.Enabled := True;
end;

procedure TFormAddKat.cbPorDaughterSelect(Sender: TObject);
var
  poroda: String;
begin
  poroda := cbPorDaughter.Text;
  //��� insert � bull
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT kod FROM sppor WHERE im='+''''+ poroda +'''');
    ADOQuerySprav.Open;
    //��� insert � bull
    kodPorDaughter := ADOQuerySprav.FieldByName('kod').AsString;
  end;

end;

procedure TFormAddKat.edtSpermExit(Sender: TObject);
var
  val: single;
begin
//���� ���� ���-�� �������
if Trim((Sender as TEdit).Text) <> '' then
  if not TryStrToFloat((Sender as TEdit).Text, val) then
    raise EArgumentException.Create('��� �� �����. ��������� ����.');
end;

procedure TFormAddKat.edtSpermKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '.' then
    Key := ',';
  if ((Key<'0') or (Key>'9')) and (Key<>#8) and (Key<>'-') and (Key<>',') then
    Key := #0;
end;

//������� �������� �� ����� � ������
procedure TFormAddKat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if not isEditCategory then
    begin
      //idBull := '';
      FormAddBull.CleanControls();
      FormListCategory.ShowDBGridCategory();
    end
  else
  begin
    FormAddBull.CleanControls();
  //��������� �����
  //if isEditCategory then
  //FormListCategory.ShowDBGridCategory();
  end;
end;

procedure TFormAddKat.FormShow(Sender: TObject);
begin
cbPorDaughter.Enabled := True;
with DataMdl do
begin
//��������� label-� �� idBull
  TBull.SelectBull(DataMdl.ADOQuerySprav,idBull);
  lblHoz.Caption := ADOQuerySprav.FieldByName('spobl.im').AsString + '  ' +
                    ADOQuerySprav.FieldByName('kodra.im').AsString + '  ' +
                    ADOQuerySprav.FieldByName('kodxoz.im').AsString;
  lblKlichka.Caption := ADOQuerySprav.FieldByName('klihkab').AsString;
  lblInvNum.Caption := ADOQuerySprav.FieldByName('inb').AsString;
  lblLine.Caption := ADOQuerySprav.FieldByName('sklin.IM').AsString;
  lblDrb.Caption := ADOQuerySprav.FieldByName('drb').AsString;
  //��������� ������ ��������� �����
  ADOQuerySprav.Close;
  ADOQuerySprav.SQL.Clear;
  ADOQuerySprav.SQL.Add('SELECT DISTINCT val FROM category ORDER BY val');
  ADOQuerySprav.Open;
  ADOQuerySprav.First;
  cbCategory.Clear;
  while not ADOQuerySprav.Eof do
    begin
      cbCategory.Items.Add(ADOQuerySprav.FieldByName('val').AsString);
      ADOQuerySprav.Next;
   end;
   //������
  ADOQuerySprav.Close;
  ADOQuerySprav.SQL.Clear;
  ADOQuerySprav.SQL.Add('SELECT DISTINCT im FROM sppor ORDER BY im');
  ADOQuerySprav.Open;
  ADOQuerySprav.First;
  cbPorDaughter.Clear;
  while not ADOQuerySprav.Eof do
    begin
    cbPorDaughter.Items.Add(ADOQuerySprav.FieldByName('im').AsString);
    ADOQuerySprav.Next;
    end;

    if isEditCategory then
      begin
        FormAddKat.Caption := '������������� ���������';
        cbYear.ItemIndex := cbYear.Items.IndexOf(yearreport);
        cbCategory.ItemIndex := cbCategory.Items.IndexOf(category);
        //���������� select
        //FormAddKat.cbCategorySelect(cbCategory);
        cbPorDaughter.ItemIndex := cbPorDaughter.Items.IndexOf(poroda);
        edtSperm.Text := sper;
        edtCena.Text := cena;
      end
    else
      begin
        FormAddKat.Caption := '�������� ���������';
        //�������� ���������� ������
        cbYear.ItemIndex := -1;
        cbCategory.ItemIndex := -1;
        cbPorDaughter.Text := '';
        edtSperm.Text := '';
        edtCena.Text := '';
      end;
end;
end;

end.
