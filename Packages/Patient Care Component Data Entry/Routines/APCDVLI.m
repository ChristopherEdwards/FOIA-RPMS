APCDVLI ; IHS/CMI/LAB - generate V Line Items ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
VLI(APCDFILE,APCDIEN,APCDMODE) ;EP called to update v line items
 I '$G(APCDFILE) Q 1
 I '$G(APCDIEN) Q 1
 I "AM"'[$G(APCDMODE) Q 3
 NEW G
 S G=$$DIC^XBDIQ1(APCDFILE)
 W G
 ;CHK FOR existance of entry in v file
 ;do @ of second piece of the file
 ;set 0 node of v entry in Z
 Q E
01 ;V MEASUREMENT
 Q:$$VAL^XBDIQ1(APCDFILE,APCDIEN,.011)=""  ;no cpt entry/no line item
 ;add or mode or delete
 Q
02 ;V HOSPITALIZATION
 Q
03 ;V CHS
 Q
04 ;V DENTAL
 Q
