unit UnitExchange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, XMLDoc, XMLIntf;

type
  TFormExchange = class(TForm)
    MemoExchange: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure SendData();
procedure ReciveData();

var
  FormExchange: TFormExchange;

implementation

uses UnitVariables, UnitDB, UnitMain;

var
  SearchRec:TSearchRec;

{$R *.dfm}

//Отправить данные lineage     это для Филиала!!! центр отправляет bull
procedure SendData();
var
  //OutXML: TXMLDocument;
  OutXML: IXMLDocument;
  root, elem, elch: IXMLNode;
  //bull: TBull;
  lineage: TLineage;
  fName: WideString;
  {nBulls,} nLineages: Integer;
begin
  //OutXml := TXMLDocument.Create(nil);
  OutXML := NewXMLDocument;
  OutXml.Active := true;
  OutXML.Version := '1.0';
  OutXML.Encoding := 'utf-8';
  //root := OUTXml.AddChild('BullsCategory');
  root := OUTXml.AddChild('Lineages');

{  with DataMdl.ADOQueryOpt do
    begin
      //root := root.ChildNodes['Bulls'];
      Close;
      Sql.Clear;
      Sql.Add('SELECT id,kodr,kodrn,kodh,klihkab,inb,markab,porb,linb,grb,drb,ddb,' +
         'mrb,klihkafb,infb,kodkatfb,klihkamb,inmb,nummaxlactmb,udmb,richmb,belokmb,' +
         'klihkagfb,inngfb,kodkatgfb FROM bull');
      Open;
      nBulls := RecordCount;
      while not Eof do
        begin
          try
            bull := TBull.Create(FieldByName('id').AsInteger,FieldByName('kodr').AsInteger,
              FieldByName('kodrn').AsInteger,FieldByName('kodh').AsInteger,FieldByName('klihkab').AsString,
              FieldByName('inb').AsString,FieldByName('markab').AsString,FieldByName('porb').AsInteger,
              FieldByName('linb').AsInteger,FieldByName('grb').AsInteger,FieldByName('drb').AsString,
              FieldByName('ddb').AsString,FieldByName('mrb').AsInteger,FieldByName('klihkafb').AsString,
              FieldByName('infb').AsString,FieldByName('kodkatfb').AsInteger,FieldByName('klihkamb').AsString,
              FieldByName('inmb').AsString,FieldByName('nummaxlactmb').AsString,FieldByName('udmb').AsSingle,
              FieldByName('richmb').AsCurrency,FieldByName('belokmb').AsCurrency,FieldByName('klihkagfb').AsString,
              FieldByName('inngfb').AsString,FieldByName('kodkatgfb').AsInteger);
            bull.AddBull(root,elem,elch);
     }
            with DataMdl.ADOQueryEdit do
              begin
                //root := OUTXml.ChildNodes['Bulls'];
                //root.AddChild('Lineages');
                //root := root.ChildNodes['Bull'];
                //root := root.AddChild('Lineages');
                Close;
                Sql.Clear;
                //Sql.Add('SELECT id,yearreport,idbull,sper,cena,kodkat,pordaughter FROM lineage WHERE idBull='
                //  + IntToStr(bull.Id));
                Sql.Add('SELECT id,yearreport,idbull,sper,cena,kodkat,pordaughter FROM lineage');
                Open;
                nLineages := RecordCount;
                while not Eof do
                  begin
                    try
                      lineage := TLineage.Create(FieldByName('id').AsString,FieldByName('yearreport').AsString,
                        FieldByName('idbull').AsString,FieldByName('sper').AsString,FieldByName('cena').AsString,
                        FieldByName('kodkat').AsString,FieldByName('pordaughter').AsString);
                      lineage.AddLineage(root,elem,elch);
                      Next;
                    finally
                      lineage.Free;
                    end;
                  end;
              end;
      {
             Next;
          finally
            bull.Free;
          end;
        end;//2
    end;//1

    with DataMdl.ADOQueryOpt do
    begin
      root := OUTXml.ChildNodes['BullsCategory'];
      root := root.AddChild('Lineages');
      Close;
      Sql.Clear;
      Sql.Add('SELECT id,yearreport,idbull,sper,cena,kodkat,pordaughter FROM lineage');
      Open;
      nLineages := RecordCount;
      while not Eof do
        begin
          try
            lineage := TLineage.Create(FieldByName('id').AsInteger,FieldByName('yearreport').AsString,
              FieldByName('idbull').AsInteger,FieldByName('sper').AsCurrency,FieldByName('cena').AsCurrency,
              FieldByName('kodkat').AsInteger,FieldByName('pordaughter').AsInteger);
            lineage.AddLineage(root,elem,elch);
            Next;
          finally
            lineage.Free;
          end;
    end;
    end;}
  fName := OutFolder + '\' + CreateNameForOutFile();
  OutXML.SaveToFile(fName);
  FormExchange.MemoExchange.Clear;
  FormExchange.MemoExchange.Lines.Add('Передача данных.');
  //FormExchange.MemoExchange.Lines.Add('Быки. Сформировано ' + IntToStr(nBulls) + ' записей.');
  FormExchange.MemoExchange.Lines.Add('Категории. Сформировано ' + IntToStr(nLineages) + ' записей.');
  FormExchange.MemoExchange.Lines.Add('Файл для отправки: ' + fName);
end;

//принять данные
procedure ReciveData();
var
  InXML: IXMLDocument;
  root, elem, ANode, StartNode: IXMLNode;
  //bull: TBull;
  lineage: TLineage;
  //id, kodr, kodrn, kodh, porb, linb, grb, mrb, kodkatfb, kodkatgfb: integer;
  //id, kodr, kodrn, kodh, porb, linb, grb, mrb, kodkatfb, kodkatgfb, klihkab, inb,
  //markab, drb, ddb, klihkafb, infb, klihkamb, inmb, nummaxlactmb, udmb, richmb, belokmb,
  //klihkagfb, inngfb: string;
  id, yearreport, idbull, sper, cena, kodkat, pordaughter: String;
  //udmb: single;
  //richmb, belokmb: currency;
  insertLineage, updateLineage: integer;
begin
   if FindFirst(FullPathToProg+'in\*.xml', faAnyFile, SearchRec)=0 then
   begin
     insertLineage := 0;
     updateLineage := 0;
     repeat
     FormExchange.MemoExchange.Lines.Add('Прием данных.');
     FormExchange.MemoExchange.Lines.Add('Обрабатываем файл '+SearchRec.Name+'.');
     InXml := TXMLDocument.Create(FullPathToProg+'in\' + SearchRec.Name);
     InXML.Active := true;
{     root := InXML.ChildNodes['Bulls'];
     StartNode := root.ChildNodes.FindNode('Bull','');
     ANode := StartNode;
     repeat
       elem := ANode.ChildNodes.FindNode('id');
       id := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodr');
       kodr := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodrn');
       kodrn := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodh');
       kodh := elem.Text;
       elem := ANode.ChildNodes.FindNode('klihkab');
       klihkab := elem.Text;
       elem := ANode.ChildNodes.FindNode('inb');
       inb := elem.Text;
       elem := ANode.ChildNodes.FindNode('porb');
       porb := elem.Text;
       elem := ANode.ChildNodes.FindNode('linb');
       linb := elem.Text;
       elem := ANode.ChildNodes.FindNode('grb');
       grb := elem.Text;
       elem := ANode.ChildNodes.FindNode('mrb');
       mrb := elem.Text;
       elem := ANode.ChildNodes.FindNode('klihkafb');
       klihkafb := elem.Text;
       elem := ANode.ChildNodes.FindNode('infb');
       infb := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodkatfb');
       kodkatfb := elem.Text;
       elem := ANode.ChildNodes.FindNode('markab');
       markab := elem.Text;
       elem := ANode.ChildNodes.FindNode('drb');
       drb := elem.Text;
       elem := ANode.ChildNodes.FindNode('ddb');
       ddb := elem.Text;
       elem := ANode.ChildNodes.FindNode('klihkamb');
       klihkamb := elem.Text;
       elem := ANode.ChildNodes.FindNode('inmb');
       inmb := elem.Text;
       elem := ANode.ChildNodes.FindNode('nummaxlactmb');
       nummaxlactmb := elem.Text;
       elem := ANode.ChildNodes.FindNode('udmb');
       udmb := elem.Text;
       elem := ANode.ChildNodes.FindNode('richmb');
       richmb := elem.Text;
       elem := ANode.ChildNodes.FindNode('belokmb');
       belokmb := elem.Text;
       elem := ANode.ChildNodes.FindNode('klihkagfb');
       klihkagfb := elem.Text;
       elem := ANode.ChildNodes.FindNode('inngfb');
       inngfb := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodkatgfb');
       kodkatgfb := elem.Text;

       if TBull.BullIsUniq(DataMdl.ADOQuerySprav,inb,drb) then
         FormExchange.MemoExchange.Lines.Add('Добавлено ' + TBull.InsertBull(DataMdl.ADOQueryOpt,kodr,
         kodrn, kodh, porb, linb, grb, mrb, kodkatfb, kodkatgfb, klihkab, inb,
         markab, drb, ddb, klihkafb, infb, klihkamb, inmb, nummaxlactmb, udmb, richmb, belokmb,
         klihkagfb, inngfb) + ' бык(а)ов.')
       else
         FormExchange.MemoExchange.Lines.Add('Изменено '+ TBull.UpdateBull(DataMdl.ADOQueryOpt,idBull,kodr,kodrn, kodh, porb, linb, grb,
           mrb, kodkatfb, kodkatgfb, klihkab, inb, markab, drb, ddb, klihkafb, infb,
           klihkamb, inmb, nummaxlactmb, udmb, richmb, belokmb, klihkagfb, inngfb) + ' бык(а)ов.');
        }
     //root := InXML.ChildNodes['BullsCategory'];
     //root := root.ChildNodes['Lineages'];
     root := InXML.ChildNodes['Lineages'];
     StartNode := root.ChildNodes.FindNode('Lineage','');
     ANode := StartNode;
     repeat
       elem := ANode.ChildNodes.FindNode('id');
       id := elem.Text;
       elem := ANode.ChildNodes.FindNode('yearreport');
       yearreport := elem.Text;
       elem := ANode.ChildNodes.FindNode('idbull');
       idbull := elem.Text;
       elem := ANode.ChildNodes.FindNode('sper');
       sper := elem.Text;
       elem := ANode.ChildNodes.FindNode('cena');
       cena := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodkat');
       kodkat := elem.Text;
       elem := ANode.ChildNodes.FindNode('pordaughter');
       pordaughter := elem.Text;

       lineage := TLineage.Create(yearreport, idbull, sper, cena, kodkat, pordaughter);
       if lineage.LineageIsUniq(DataMdl.ADOQuerySprav,lineage.Yearreport,lineage.Idbull,lineage.Pordaughter) then
          begin
          if TBull.isBullFromId(DataMdl.ADOQuerySprav,lineage.Idbull) then
           insertLineage := insertLineage + lineage.InsertLineage(DataMdl.ADOQuerySprav,
             lineage.Yearreport,lineage.Idbull,lineage.Sper,lineage.Cena,lineage.Kodkat,
             lineage.Pordaughter)
            else
              FormExchange.MemoExchange.Lines.Add('Нет такого быка с id= ' + lineage.Idbull + '.');
          end
       else
          updateLineage := updateLineage + lineage.UpdateLineage(DataMdl.ADOQuerySprav,
            idLineage,sper,cena,kodkat);


       ANode := ANode.NextSibling;
     until ANode = nil;
     FormExchange.MemoExchange.Lines.Add('Добавлено оценок ' + IntToStr(insertLineage) + '.');
     FormExchange.MemoExchange.Lines.Add('Обновлено оценок ' + IntToStr(updateLineage) + '.');
     if MoveFile(PWideChar(FullPathToProg+'in\' + SearchRec.Name),PWideChar(FullPathToProg+'in\arch\'+
            SearchRec.Name)) then
     FormExchange.MemoExchange.Lines.Add('Файл ' + SearchRec.Name + ' перенесен в in\arch');


     //  ANode := ANode.NextSibling;
     //until ANode = nil;
 {
     root := InXML.ChildNodes['BullsCategory'];
     root := root.ChildNodes['Lineages'];
     StartNode := root.ChildNodes.FindNode('Lineage','');
     ANode := StartNode;
     repeat
       elem := ANode.ChildNodes.FindNode('id');
       id := elem.Text;
       elem := ANode.ChildNodes.FindNode('yearreport');
       yearreport := elem.Text;
       elem := ANode.ChildNodes.FindNode('idbull');
       idbull := elem.Text;
       elem := ANode.ChildNodes.FindNode('sper');
       sper := elem.Text;
       elem := ANode.ChildNodes.FindNode('cena');
       cena := elem.Text;
       elem := ANode.ChildNodes.FindNode('kodkat');
       kodkat := elem.Text;
       elem := ANode.ChildNodes.FindNode('pordaughter');
       pordaughter := elem.Text;
       ANode := ANode.NextSibling;
     until ANode = nil;
  }
     until FindNext(SearchRec) <> 0;
   FindClose(SearchRec);
   end
   else
     FormExchange.MemoExchange.Lines.Add('Нет файлов для обработки в каталоге in.');

end;

procedure TFormExchange.FormShow(Sender: TObject);
begin
 //передача данных
 if isSend then
   begin
     SendData();
   end
 else
   //прием данных
   begin
     ReciveData();


   end;
end;

end.
