unit UnitDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Forms, Winapi.Windows,
  System.Actions, Vcl.ActnList, XMLDoc, XMLIntf;

type
  TDataMdl = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOQueryBull: TADOQuery;
    ADOQuerySprav: TADOQuery;
    DataSourceBull: TDataSource;
    ADOQueryEdit: TADOQuery;
    DataSourceCategory: TDataSource;
    ADOQueryCategory: TADOQuery;
    DataSourceSprav: TDataSource;
    ADOQueryOpt: TADOQuery;
    ADOQueryTables: TADOQuery;
    ADOQuerySprSost: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ADOConnection1WillConnect(Connection: TADOConnection;
      var ConnectionString, UserID, Password: WideString;
      var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
  private
    { Private declarations }
  public
    { Public declarations }
    function WithoutCategoryFill(yearreport:String):Integer;
    procedure ConnectToDB();
    function CounterBulls(ADOQuery: TADOQuery):integer;
    function CounterLineages(ADOQuery: TADOQuery):integer;
  end;

  TBull = class
    private
      Fid: integer;//autoincrement
      Fstatus: string;//статус быка - живой,выбывший
      Fkodr: integer;//код региона
      Fkodrn: integer;//код района
      Fkodh: integer;//код организации
      Fklihkab: string;//КЛИЧКА БЫКА-ПРОИЗВОДИТЕЛЯ
      Finb: string;//ИНВЕНТАРНЫЙ НОМЕР
      Fmarkab: string;//МАРКА И НОМЕР ГПК
      Fporb: integer;//порода быка из sppor
      Flinb: integer;//линия быка из sklin
      Fgrb: integer;//группа быка из sklin для однозначности линии
      Fdrb: string;//дата рождения быка
      Fddb: string;//дата смерти быка
      Fmrb: integer;//страна рождения быка из kodst
      Fklihkafb: string;//кличка отца быка
      Finfb: string;//ИНВЕНТАРНЫЙ НОМЕР отца быка
      Fkodkatfb: integer;//КАТЕГОРИЯ отца быка  из category
      Fklihkamb: string;//кличка матери быка
      Finmb: string;//ИНВЕНТАРНЫЙ НОМЕР матери  быка
      Fnummaxlactmb: string;//номер наивысшей лактации матери быка
      Fudmb: single;//удой, кг  матери быка
      Frichmb: currency;//жир,%   матери быка
      Fbelokmb: currency;//белок,%  матери быка
      Fklihkagfb: string;//кличка деда быка
      Finngfb: string;//ИНВЕНТАРНЫЙ НОМЕР матери  быка
      Fkodkatgfb: integer;//КАТЕГОРИЯ деда быка  из category
    public
      constructor Create(id: integer;status: string;kodr: integer;kodrn: integer;kodh: integer;klihkab: string;inb: string;
        markab: string;porb: integer;linb: integer;grb: integer;drb: string;ddb: string;
        mrb: integer;klihkafb: string;infb: string;kodkatfb: integer;klihkamb: string;
        inmb: string;nummaxlactmb: string;udmb: single;richmb: currency;belokmb: currency;
        klihkagfb: string;inngfb: string;kodkatgfb: integer);
      procedure AddBull(root: IXMLNode; elem: IXMLNode; elch: IXMLNode);
      class function UpdateBull(ADOQuery: TADOQuery;id:string;status:string;kodr:string;kodrn:string;kodh:string;
        klihkab:string;inb:string;porb:string;linb:string;grb:string;drb:string;mrb:string;klihkafb:string;
        infb:string;kodkatfb:string;klihkamb:string;inmb:string;nummaxlactmb:string;udmb:string;
        richmb:string;belokmb:string;klihkagfb:string;inngfb: string;kodkatgfb:string): integer;
      class function InsertBull(ADOQuery: TADOQuery;status:string;kodr:string;kodrn:string;kodh:string;
        klihkab:string;inb:string;porb:string;linb:string;grb:string;drb:string;mrb:string;klihkafb:string;
        infb:string;kodkatfb:string;klihkamb:string;inmb:string;nummaxlactmb:string;udmb:string;
        richmb:string;belokmb:string;klihkagfb:string;inngfb: string;kodkatgfb:string): integer;
      class function BullIsUniq(ADOQuery:TADOQuery;inb:string;drb:string): Boolean;
      class function isBullFromId(ADOQuery:TADOQuery;id:string): Boolean;
      class procedure SelectBull(ADOQuery:TADOQuery;idBull:string);
      property Id: integer read Fid write Fid;
      property Status: string read Fstatus write Fstatus;
      property Kodr: integer read Fkodr write FKodr;
      property Kodrn: integer read Fkodrn write FKodrn;
      property Kodh: integer read Fkodh write FKodh;
      property Klihkab: string read Fklihkab write Fklihkab;
      property Inb: string read Finb write Finb;
      property Markab: string read Fmarkab write Fmarkab;
      property Porb: integer read Fporb write Fporb;
      property Linb: integer read Flinb write Flinb;
      property Grb: integer read Fgrb write Fgrb;
      property Drb: string read Fdrb write Fdrb;
      property Ddb: string read Fddb write Fddb;
      property Mrb: integer read Fmrb write Fmrb;
      property Klihkafb: string read Fklihkafb write Fklihkafb;
      property Infb: string read Finfb write Finfb;
      property Kodkatfb: integer read Fkodkatfb write Fkodkatfb;
      property Klihkamb: string read Fklihkamb write Fklihkamb;
      property Inmb: string read Finmb write Finmb;
      property Nummaxlactmb: string read Fnummaxlactmb write Fnummaxlactmb;
      property Udmb: single read Fudmb write Fudmb;
      property Richmb: currency read Frichmb write Frichmb;
      property Belokmb: currency read Fbelokmb write Fbelokmb;
      property Klihkagfb: string read Fklihkagfb write Fklihkagfb;
      property Inngfb: string read Finngfb write Finngfb;
      property Kodkatgfb: integer read Fkodkatgfb write Fkodkatgfb;
  end;

  TLineage = class
    private
      {Fid: integer;//autoincrement
      Fyearreport: string;//год описи
      Fidbull: integer;//id из таблицы bull
      Fsper: currency;//Запас семени, тыс.доз
      Fcena: currency;//цена одной дозы, руб
      Fkodkat: integer;//категория из category
      Fpordaughter: integer;//порода дочери из sppor}
      Fid: string;//autoincrement
      Fyearreport: string;//год описи
      Fidbull: string;//id из таблицы bull
      Fsper: string;//Запас семени, тыс.доз
      Fcena: string;//цена одной дозы, руб
      Fkodkat: string;//категория из category
      Fpordaughter: string;//порода дочери из sppor}

    public
      //constructor Create(id: integer; Yearreport: string; Idbull: integer; Sper: currency; Cena: currency;
      //  Kodkat: integer; Pordaughter: integer);
      constructor Create(yearreport:string;idbull:string;sper:string;cena:string;
          kodkat:string;pordaughter:string);overload;
      constructor Create(id:string;yearreport:string;idbull:string;sper:string;cena:string;
          kodkat:string;pordaughter:string);overload;
      class function InsertLineage(ADOQuery:TADOQuery;yearreport: string;idbull:string;sper:string;
        cena:string;kodkat:string;pordaughter:string): integer;
      class function UpdateLineage(ADOQuery:TADOQuery;idLineage:string;sper:string;
        cena:string;kodkat:string): integer;
      class function LineageIsUniq(ADOQuery:TADOQuery;yearreport:string;idbull:string;
        pordaughter:string): Boolean;
      procedure AddLineage(root: IXMLNode; elem: IXMLNode; elch: IXMLNode);
      {property Id: integer read Fid write Fid;
      property Yearreport: string read Fyearreport write Fyearreport;
      property Idbull: integer read Fidbull write Fidbull;
      property Sper: currency read Fsper write Fsper;
      property Cena: currency read Fcena write Fcena;
      property Kodkat: integer read Fkodkat write Fkodkat;
      property Pordaughter: integer read Fpordaughter write Fpordaughter;}
      property Id: string read Fid write Fid;
      property Yearreport: string read Fyearreport write Fyearreport;
      property Idbull: string read Fidbull write Fidbull;
      property Sper: string read Fsper write Fsper;
      property Cena: string read Fcena write Fcena;
      property Kodkat: string read Fkodkat write Fkodkat;
      property Pordaughter: string read Fpordaughter write Fpordaughter;
  end;

function transform(s:ShortString): ShortString;

var
  DataMdl: TDataMdl;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses UnitMain, {UnitLogin,} UnitVariables, {DBLogDlg,} Variants, ComObj;

constructor TBull.Create(id: integer;status: string;kodr: integer;kodrn: integer;kodh: integer;klihkab: string;inb: string;
        markab: string;porb: integer;linb: integer;grb: integer;drb: string;ddb: string;
        mrb: integer;klihkafb: string;infb: string;kodkatfb: integer;klihkamb: string;
        inmb: string;nummaxlactmb: string;udmb: single;richmb: currency;belokmb: currency;
        klihkagfb: string;inngfb: string;kodkatgfb: integer);
begin
  Fid := id;
  Fstatus := status;
  Fkodr := kodr;
  Fkodrn := kodrn;
  Fkodh := kodh;
  Fklihkab := klihkab;
  Finb := inb;
  Fmarkab := markab;
  Fporb := porb;
  Flinb := linb;
  Fgrb := grb;
  Fdrb := drb;
  Fddb := ddb;
  Fmrb := mrb;
  Fklihkafb := klihkafb;
  Finfb := infb;
  Fkodkatfb := kodkatfb;
  Fklihkamb := klihkamb;
  Finmb := inmb;
  Fnummaxlactmb := nummaxlactmb;
  Fudmb := udmb;
  Frichmb := richmb;
  Fbelokmb := belokmb;
  Fklihkagfb := klihkagfb;
  Finngfb := inngfb;
  Fkodkatgfb := kodkatgfb;
end;

procedure TBull.AddBull(root: IXMLNode; elem: IXMLNode; elch: IXMLNode);
begin
            elem := root.AddChild('Bull');
            elch := elem.AddChild('id');

            elch := elem.AddChild('status');
            elch.Text := self.Status;

            elch.Text := IntToStr(self.Id);
            elch := elem.AddChild('kodr');
            elch.Text := IntToStr(self.Kodr);
            elch := elem.AddChild('kodrn');
            elch.Text := IntToStr(self.Kodrn);
            elch := elem.AddChild('kodh');
            elch.Text := IntToStr(self.Kodh);
            elch := elem.AddChild('klihkab');
            elch.Text := self.Klihkab;
            elch := elem.AddChild('inb');
            elch.Text := self.Inb;
            elch := elem.AddChild('markab');
            elch.Text := self.Markab;
            elch := elem.AddChild('porb');
            elch.Text := IntToStr(self.Porb);
            elch := elem.AddChild('linb');
            elch.Text := IntToStr(self.Linb);
            elch := elem.AddChild('grb');
            elch.Text := IntToStr(self.Grb);
            elch := elem.AddChild('drb');
            elch.Text := self.Drb;
            elch := elem.AddChild('ddb');
            elch.Text := self.Ddb;
            elch := elem.AddChild('mrb');
            elch.Text := IntToStr(self.Mrb);
            elch := elem.AddChild('klihkafb');
            elch.Text := self.Klihkafb;
            elch := elem.AddChild('infb');
            elch.Text := self.Infb;
            elch := elem.AddChild('kodkatfb');
            elch.Text := IntToStr(self.Kodkatfb);
            elch := elem.AddChild('klihkamb');
            elch.Text := self.Klihkamb;
            elch := elem.AddChild('inmb');
            elch.Text := self.Inmb;
            elch := elem.AddChild('nummaxlactmb');
            elch.Text := self.Nummaxlactmb;
            elch := elem.AddChild('udmb');
            elch.Text := FloatToStr(self.Udmb);
            elch := elem.AddChild('richmb');
            elch.Text := FloatToStr(self.Richmb);
            elch := elem.AddChild('belokmb');
            elch.Text := FloatToStr(self.Belokmb);
            elch := elem.AddChild('klihkagfb');
            elch.Text := self.Klihkagfb;
            elch := elem.AddChild('inngfb');
            elch.Text := self.Inngfb;
            elch := elem.AddChild('kodkatgfb');
            elch.Text := IntToStr(self.Kodkatgfb);
end;

class function TBull.UpdateBull(ADOQuery:TADOQuery;id:string;status:string;kodr:string;kodrn:string;kodh:string;
  klihkab:string;inb:string;porb:string;linb:string;grb:string;drb:string;mrb:string;klihkafb:string;
  infb:string;kodkatfb:string;klihkamb:string;inmb:string;nummaxlactmb:string;udmb:string;
  richmb:string;belokmb:string;klihkagfb:string;inngfb: string;kodkatgfb:string): integer;
begin
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('UPDATE  bull SET status="' + status + '",kodr=' + kodr +',kodrn=' + kodrn + ',kodh=' + kodh
        + ',klihkab="' + klihkab + '",inb="'+ inb + '",porb=' + porb + ',linb=' + linb
        + ',grb=' + grb + ',drb="' + drb + '",mrb='+ mrb
        + ',klihkafb="' + klihkafb + '",infb="' + infb + '",kodkatfb='
        + kodkatfb + ',klihkamb="' + klihkamb + '",inmb="' + inmb
        + '",nummaxlactmb="'+ nummaxlactmb + '",udmb="' + udmb + '",richmb="'
        + richmb + '",belokmb="'+ belokmb + '",klihkagfb="'
        + klihkagfb + '",inngfb="' + inngfb + '",kodkatgfb='
        + kodkatgfb + ' WHERE id=' + id);
//        + kodkatgf + ' WHERE inb="' + Trim(edtInvnum.Text) +'" and drb=#'
//        +  StringReplace(meDateBirthday.Text,'.','/',[rfReplaceAll]) + '#');
    ADOQuery.ExecSQL;
    Result := ADOQuery.RowsAffected;

end;

class function TBull.InsertBull(ADOQuery:TADOQuery;status:string;kodr:string;kodrn:string;kodh:string;
  klihkab:string;inb:string;porb:string;linb:string;grb:string;drb:string;mrb:string;klihkafb:string;
  infb:string;kodkatfb:string;klihkamb:string;inmb:string;nummaxlactmb:string;udmb:string;
  richmb:string;belokmb:string;klihkagfb:string;inngfb: string;kodkatgfb:string): integer;
begin
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('INSERT INTO bull(status,kodr,kodrn,kodh,klihkab,inb,porb,linb,grb,drb,mrb,'
        + 'klihkafb,infb,kodkatfb,klihkamb,inmb,nummaxlactmb,udmb,richmb,belokmb,klihkagfb,inngfb,kodkatgfb)'
        + ' values("' + status + '",' + kodr + ',' + kodrn + ',' + kodh + ',"' + klihkab + '","'
        + inb + '",'  + porb + ',' + linb + ',' + grb + ',"' + drb + '",' + mrb
        + ',"' + klihkafb + '","' + infb  + '",' + kodkatfb + ',"' + klihkamb
        + '","' + inmb + '","' + nummaxlactmb + '",' + udmb + ',"' + richmb + '","'
        + belokmb + '","' + klihkagfb + '","' + inngfb + '",' + kodkatgfb + ')');
    ADOQuery.ExecSQL;
    Result := ADOQuery.RowsAffected;
end;

class function TBull.BullIsUniq(ADOQuery:TADOQuery;inb:string;drb:string): Boolean;
begin
  Result := True;
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
  ADOQuery.SQL.Add('SELECT id FROM bull WHERE inb="' + inb +'" and drb="' + drb + '"');
      //+  StringReplace(meDateBirthday.Text,'.','/',[rfReplaceAll]) + '#');
  ADOQuery.Open;
  if ADOQuery.RecordCount > 0 then
    begin
      idBull := ADOQuery.FieldByName('id').AsString;
      Result := False;
    end;
end;

class function TBull.isBullFromId(ADOQuery:TADOQuery;id:string): Boolean;
begin
  Result := false;
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
   ADOQuery.SQL.Add('SELECT id FROM bull WHERE id=' + id);
  ADOQuery.Open;
  if ADOQuery.RecordCount > 0 then
  Result := true;
end;

class procedure TBull.SelectBull(ADOQuery:TADOQuery;idBull:string);
begin
  ADOQuery.Close;
  ADOQuery.Sql.Clear;
  ADOQuery.Sql.Add('SELECT bull.id, bull.status, bull.kodr, bull.kodrn, bull.kodh, bull.klihkab, bull.inb,'
  +' bull.linb, bull.drb, spobl.im, kodra.im, kodxoz.im, sklin.IM FROM sklin INNER JOIN'
  +' (kodxoz INNER JOIN (kodra INNER JOIN (spobl INNER JOIN bull ON spobl.kod = bull.kodr)'
  +' ON (kodra.kodraj = bull.kodrn) AND (kodra.kodr = spobl.kod)) ON (kodxoz.kodx = bull.kodh)'
  +' AND (kodxoz.kodraj = kodra.kodraj) AND (kodxoz.kodr = spobl.kod)) ON (bull.grb = sklin.GR)'
  +' AND (sklin.KOD = bull.linb) WHERE bull.id=' + idBull);
  ADOQuery.Open;
end;

//constructor TLineage.Create(id: integer; yearreport: string; idbull: integer; sper: currency; cena: currency;
//  kodkat: integer; pordaughter: integer);
constructor TLineage.Create(yearreport:string;idbull:string;sper:string;cena:string;
  kodkat:string;pordaughter:string);
begin
  //Fid := id;
  FYearreport := yearreport;
  FIdbull := idbull;
  FSper := sper;
  FCena := cena;
  FKodkat := kodkat;
  FPordaughter := pordaughter;
end;

constructor TLineage.Create(id:string;yearreport:string;idbull:string;sper:string;cena:string;
  kodkat:string;pordaughter:string);
begin
  Fid := id;
  FYearreport := yearreport;
  FIdbull := idbull;
  FSper := sper;
  FCena := cena;
  FKodkat := kodkat;
  FPordaughter := pordaughter;
end;

class function TLineage.LineageIsUniq(ADOQuery:TADOQuery;yearreport:string;idbull:string;pordaughter:string): Boolean;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
  ADOQuery.SQL.Add('SELECT id FROM lineage WHERE idbull=' + idBull
      + ' AND yearreport="' + yearreport + '" AND pordaughter=' + pordaughter);
  ADOQuery.Open;
  idLineage :=  ADOQuery.FieldByName('id').AsString;
  if ADOQuery.RecordCount > 0 then
    Result := false
  else
    Result := true;
end;

class function TLineage.InsertLineage(ADOQuery:TADOQuery;yearreport: string;idbull:string;sper:string;
  cena:string;kodkat:string;pordaughter:string): integer;
var
  tmp: string;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
  ADOQuery.SQL.Add('INSERT INTO lineage(yearreport,idbull,sper,cena,kodkat,pordaughter) '
                + 'VALUES("' + yearreport + '","' + idbull + '","' + sper + '","'
                + cena + '",' + kodkat + ',' + pordaughter + ')');
tmp := ADOQuery.SQL.Text;
  ADOQuery.ExecSQL;
  Result := ADOQuery.RowsAffected;
end;

class function TLineage.UpdateLineage(ADOQuery:TADOQuery;idLineage:string;sper:string;
  cena:string;kodkat:string): integer;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
  ADOQuery.SQL.Add('UPDATE lineage SET sper="' + sper + '",cena="' + cena
                  + '",kodkat='+ kodkat + ' WHERE id=' + idLineage);
  ADOQuery.ExecSQL;
  Result := ADOQuery.RowsAffected;
end;

procedure TLineage.AddLineage(root: IXMLNode; elem: IXMLNode; elch: IXMLNode);
begin
  elem := root.AddChild('Lineage');
  elch := elem.AddChild('id');
  elch.Text := self.Id;
  elch := elem.AddChild('yearreport');
  elch.Text := self.Yearreport;
  elch := elem.AddChild('idbull');
  elch.Text := self.Idbull;
  elch := elem.AddChild('sper');
  elch.Text := self.Sper;
  elch := elem.AddChild('cena');
  elch.Text := self.Cena;
  elch := elem.AddChild('kodkat');
  elch.Text := self.Kodkat;
  elch := elem.AddChild('pordaughter');
  elch.Text := self.Pordaughter;
end;

//событие, предваряющее соединение с DB
procedure TDataMdl.ADOConnection1WillConnect(Connection: TADOConnection;
  var ConnectionString, UserID, Password: WideString;
  var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
//var
//  aUserID,aPassword: String;
begin
{
  if LoginDialog('bulls',aUserID,aPassword)=true then
  begin
    UserID := aUserID;
    Password := aPassword;
    EventStatus := esOK;
  end
  else EventStatus := esCancel;//отказ от регистрации
  }
end;

function transform(s:ShortString): ShortString;
var
  i: Integer;
  stro: ShortString;
  ch: ansichar;
begin
  stro := '';
  for i := 1 to Length(s)  do
  begin
    ch := AnsiChar(chr(ord(s[i]) XOR 1));
    stro := stro + ch;
  end;
  Result := stro;
end;

procedure TDataMdl.ConnectToDB();
const
  a =  '00324';
var
  b: ShortString;
  i: integer;
begin
  b := transform(a);
  FullPathToProg := ExtractFilePath(GetModName());
  ConnectionStr := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+FullPathToProg+
    //'bulls.mdb;Jet OLEDB:System database='+FullPathToProg+'bulls.mdw;Jet OLEDB:Database Password='+ pass + ';';
    'bulls.mdb;Jet OLEDB:Database Password='+ b + ';';
  ADOConnection1.LoginPrompt := false;
  try
    ADOConnection1.ConnectionString := ConnectionStr;
    ADOQueryBull.Connection := DataMdl.ADOConnection1;
    ADOQuerySprav.Connection := DataMdl.ADOConnection1;
    ADOQueryEdit.Connection := DataMdl.ADOConnection1;
    ADOQueryOpt.Connection := DataMdl.ADOConnection1;
    ADOQueryTables.Connection := DataMdl.ADOConnection1;
    ADOQuerySprSost.Connection := DataMdl.ADOConnection1;
    ADOQueryCategory.Connection := DataMdl.ADOConnection1;
    ADOConnection1.Open;
  except on EOLEException do
    for i := 0 to ADOConnection1.Errors.Count - 1 do
      begin
        Application.MessageBox(pWideChar(ADOConnection1.Errors.Item[i].Description),
          pWideChar('Ошибка'), MB_OK+MB_ICONWARNING);
      end;

  end;
end;



procedure TDataMdl.DataModuleCreate(Sender: TObject);
begin
  ConnectToDB();
end;

//быкам которым в году не выставлена категория - выставляется категория БО = 1
function TDataMdl.WithoutCategoryFill(yearreport:String):Integer;
const
  withoutRating = '1';
  withoutPoroda = '99';
var
  colWithout: Integer;
begin
  colWithout := 0;
  with DataMdl.ADOQueryCategory do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT id FROM bull  WHERE NOT EXISTS '
        +'(SELECT idbull FROM lineage WHERE bull.id = lineage.idbull AND yearreport="'
        + yearreport + '")');
      Open;
      First;
      while not EOF do
        begin
          idBull := FieldByName('id').AsString;
          //Заполняем
          with DataMdl.ADOQuerySprav do
            begin
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO lineage(yearreport,idbull,kodkat,pordaughter) '
                + 'VALUES("' + yearreport + '",' + idBull + ',' + withoutRating
                + ',' + withoutPoroda + ')');
              ExecSQL;
              if RowsAffected > 0 then
                inc(colWithout);
            end;
          Next;
        end;
    end;
    Result := colWithout;
end;

//посчитаем всех быков
function TDataMdl.CounterBulls(ADOQuery: TADOQuery):integer;
begin
  with ADOQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT count(id) as cbulls FROM bull');
      Open;
      Result := FieldByName('cbulls').AsInteger;
    end;
end;

function TDataMdl.CounterLineages(ADOQuery: TADOQuery):integer;
begin
  with ADOQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT count(id) as clineages FROM lineage');
      Open;
      Result := FieldByName('clineages').AsInteger;
    end;
end;

end.
