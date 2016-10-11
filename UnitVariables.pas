unit UnitVariables;

interface

const
xlContinuous = 1;
xlThin = 2;
xlTop = -4160;
xlCenter = -4108;
xlPortrait = 1 ;
xlLandscape = 2;
xlRight = -4152 ;
xlNormalView = 1;
xlPageBreakPreview = 2;
xlDown = -4121;
xlJustify = -4130 ;
HH_HELP_CONTEXT = $F;
FontExcel = 8;

var
FullPathToProg,FullPathToMdb,ConnectionStr,region,rajon,hoz,
  kodregion,kodrajon,kodokrug, kodhoz,kodkat,kodkatf,kodkatgf,kodline,kodcountry,gr,
  idBull,kodpor,idLineage,yearreport,sper,cena,category,poroda,fPath: String;
  isEditBull, isEditCategory, isSend: Boolean;
  ArchFolder, InFolder, OutFolder: String;
  MsExcel,Sheets,ArrayData,Cell1,Cell2,Range: Variant;


implementation

end.
