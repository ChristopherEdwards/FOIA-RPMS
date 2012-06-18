BEHOARIN ;MSC/IND/DKM - ART Package KIDS Support ;22-Apr-2011 15:52;PLS
 ;;1.1;BEH COMPONENTS;**045002**;Sep 18, 2007
 ;=================================================================
 ; Environment check
EC Q
 ; Pre-init
PRE ;
 N DIU
 S DIU="^BEHOAR(90460.06,",DIU(0)="D" D EN^DIU2
 Q
 ;N IEN,REC,DFN
 S IEN=0
 F  S IEN=$O(^GMR(120.86,IEN)) Q:'IEN  S DFN=+$G(^(IEN,0)) D
 .I DFN,DFN'=IEN D
 ..M REC(DFN)=^GMR(120.86,IEN)
 ..K ^GMR(120.86,IEN),^GMR(120.86,"B",DFN,IEN)
 ..S ^GMR(120.86,"B",DFN,DFN)=""
 M:$D(REC) ^GMR(120.86)=REC
 Q
 ; Post-init
POST ;D REGMENU^BEHUTIL("BEHOAR MAIN",,"ART","BEHOMENU")
 N LP,DA
 S LP=0 F  S LP=$O(^BEHOAR(90460.06,LP)) Q:'LP  D
 .S DA=LP,DIK="^BEHOAR(90460.06," D IX^DIK
 Q
