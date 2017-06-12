GMRA1007 ;IHS/MSC/PLS - Patch support;24-Mar-2014 12:10;DU
 ;;4.0;Adverse Reaction Tracking;**1007**;Mar 29, 1996;Build 18
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*1006"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;Check for the installation of IHS terminology services
 S IN="IHS STANDARD TERMINOLOGY 1.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install IHS STANDARD TERMINOLOGY 1.0 before this patch"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS STANDARD TERMINOLOGY 1.0 must be completely installed before installing this patch"
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
PRE ;EP -
 Q
POST ;EP Run the post-init routines
 D EVENTS
 D INACT
 D ADDSYM
 D ADDING
 S X=$$ADD^XPDMENU("GMRA CLINICIAN MENU","GMRAZ NO ALLERGY ASSESSMENT","8")
 I 'X W "Attempt to add GMRA menu option option failed." H 3
 Q
EVENTS ;Enter old SNOMED event codes
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,DIR
 S ZTRTN="UPDATE^GMRA1007",ZTIO="",ZTSAVE("DUZ")=""
 S ZTDESC="Store Event Codes, SNOMEDs and UNIIs on old allergies"
 D ^%ZTLOAD
 I $G(ZTSK) D
 .K ^XTMP("GMRA1007")
 .N X,X1,X2 S X1=DT,X2=30
 .D C^%DTC
 .S ^XTMP("GMRA1007",0)=X_"^"_DT_"^"
 .S ^XTMP("GMRA1007","COUNT")=0
 .W !!,"A task has been queued in the background."
 .W !,"  The task number is "_$G(ZTSK)_"."
 .W !,"  To check on the status of the task, in programmer mode "
 .W !,"    type D STATUS^GMRA1007"
 N X
 Q
UPDATE ; Run the post-init
 S ^XTMP("GMRA1007","STARTDT")=$$NOW^XLFDT
 D EVENT
 D BACKLOAD^GMRAZRXU
 S ^XTMP("GMRA1007","ENDDT")=$$NOW^XLFDT
 D MAIL
 Q
EVENT ; EP Populate old allergies with event codes
 N IEN,TYPE,CNT,ECNT,EIE,MECH
 S CNT=0,ECNT=0
 S IEN=0 F  S IEN=$O(^GMR(120.8,IEN)) Q:'+IEN  D
 .S EIE=$$GET1^DIQ(120.8,IEN,22)
 .Q:EIE'=""
 .I $P($G(^GMR(120.8,IEN,9999999.11)),U,2)=""  D
 ..S TYPE=$$GET1^DIQ(120.8,IEN,3.1,"I")
 ..S MECH=$$GET1^DIQ(120.8,IEN,17,"I")
 ..I MECH="" S MECH="U"
 ..I TYPE="" S TYPE="O"
 ..D ADD(IEN,MECH,TYPE)
 Q
ADD(IEN,MECH,TYPE) ;ADD the event code
 N SNO,IENS,ERR,SNOIEN,FDA
 I MECH="A" D
 .S SNO=$S(TYPE="D":"DRUG ALLERGY",TYPE="F":"FOOD ALLERGY",1:"ALLERGY TO SUBSTANCE")
 I MECH="P" D
 .S SNO=$S(TYPE="D":"DRUG INTOLERANCE",TYPE="F":"FOOD INTOLERANCE",1:"PROPENSITY TO ADVERSE REACTIONS TO SUBSTANCE")
 I MECH="U" D
 .S SNO=$S(TYPE="D":"PROPENSITY TO ADVERSE REACTIONS TO DRUG",TYPE="F":"FOOD INTOLERANCE",1:"PROPENSITY TO ADVERSE REACTIONS TO SUBSTANCE")
 S SNOIEN=$O(^BEHOAR(90460.06,"B",SNO,""))
 S IENS=IEN_","
 K AIEN,ERR
 S FDA(120.8,IENS,9999999.13)=SNOIEN
 D UPDATE^DIE("","FDA","AIEN","ERR")
 K FDA,AIEN,ERR
 Q
STATUS ;check on status of VS xref indexing
 I $G(^XTMP("GMRA1007","ENDDT")) D
 . N START,END,X,Y
 . W !,"Data update completed!"
 . S Y=$G(^XTMP("GMRA1007","STARTDT")) D DD^%DT
 . W !,"Task started: "_Y
 . S Y=$G(^XTMP("GMRA1007","ENDDT")) D DD^%DT
 . W !,"Task ended:   "_Y
 I '$G(^XTMP("GMRA1007","ENDDT")) D
 . W !,"Still working on the update."
 . I $G(^XTMP("GMRA1007","COUNT"))=0 W !,"You must have tasked it!"
 Q
INACT ;EP Remove duplicate toothpaste entries
 N IEN,X,SAVE
 S SAVE=0
 S IEN="" F  S IEN=$O(^GMRD(120.82,"B","TOOTHPASTE",IEN)) Q:IEN=""  D
 .S X=$$CHECK^ORWDAL32(IEN)
 .I X=0&(SAVE=0) S SAVE=1
 .E  I X=0&(SAVE=1) D INAC(IEN)
 Q
INAC(IEN) ;Inactivate this entry
 K ERR,FDA,NIEN,FNUM
 S FNUM=120.8299
 S AIEN="+1,"_IEN_","
 S FDA(120.8299,AIEN,.01)=$$NOW^XLFDT
 S FDA(120.8299,AIEN,.02)=0
 D UPDATE^DIE(,"FDA","NIEN","ERR")
 I $D(ERR) W !,IENS W ERR("DIERR",1,"TEXT",1) W !
 Q
MAIL ;Send completion message to user who initiated post-install
 N XMSUB,XMTEXT,XMDUZ,XMY,XMZ,XMMG,TXT,GMRATXT
 S XMDUZ="PATCH GMRA*4*1007 Backload event codes",XMY(.5)=""
 S:$G(DUZ) XMY(DUZ)=""
 S GMRATXT(1)="Backload SNOMED and UNII codes"
 S GMRATXT(2)=""
 S GMRATXT(3)="Task Started: "_$$FMTE^XLFDT($G(^XTMP("GMRA1007","STARTDT")))
 S GMRATXT(4)="Task   Ended: "_$$FMTE^XLFDT($G(^XTMP("GMRA1007","ENDDT")))
 S GMRATXT(5)=""
 S XMTEXT="GMRATXT(",XMSUB="GMRA*4*1007 SNOMED Event backload"
 D ^XMD
 Q
ADDSYM ;Add new symptom to the file
 N XUMF,FDA,IEN,IENS,ERR,FILE,SIEN,SIGN,SYN,SYNIEN
 S SIGN="THROAT IRRITATION"
 S SYN="ITCHING OF THROAT"
 S SIEN=$O(^GMRD(120.83,"B",SIGN,"")) Q:SIEN=""  D
 .S SYNIEN=$O(^GMRD(120.83,SIEN,2,"B",SYN,"")) Q:SYNIEN'=""  D
 ..S XUMF=1,FILE=120.832
 ..S IENS="+1,"_SIEN_","
 ..S FDA(FILE,IENS,.01)=SYN
 ..D UPDATE^DIE("","FDA","IENS","ERR")
 Q
ADDING ;Add new ingredient to the file
 N SULFA,ING,INGIEN,SULIEN,IENS,IEN2,ERR,FDA,FILE,IENS,IN,X,PT,RXNORM,UNII
 S SULFA="SULFA DRUGS"
 S ING="SULFISOXAZOLE"
 S INGIEN="" S INGIEN=$O(^PS(50.416,"B",ING,INGIEN))
 Q:INGIEN=""
 S SULIEN="" S SULIEN=$O(^GMRD(120.82,"B",SULFA,SULIEN))
 Q:SULIEN=""
 S XUMF=1,FILE=120.824
 ;Continue if its not already there
 S ERR=""
 I $D(^GMRD(120.82,SULIEN,"ING","B",INGIEN))=0 D
 .S IENS="+1,"_SULIEN_","
 .S FDA(FILE,IENS,.01)=INGIEN
 .D UPDATE^DIE("","FDA","IEN2","ERR")
 Q:ERR
 ;Next update users with this allergy
 S IN=ING_U_"32771^^1"
 S X=$$ASSOC^BSTSAPI(IN)
 I $P(X,U,2)'=""!($P(X,U,3)'="") D
 .S RXNORM=$P(X,U,2),UNII=$P(X,U,3)
 S PT="" F  S PT=$O(^GMR(120.8,"C",SULFA,PT)) Q:'+PT  D
 .I $D(^GMR(120.8,PT,2,"B",INGIEN))=0 D
 ..K FDA,IENS,IEN2
 ..S IENS="+1,"_PT_","
 ..S FDA(120.802,IENS,.01)=INGIEN
 ..S FDA(120.802,IENS,9999999.01)=RXNORM
 ..S FDA(120.802,IENS,9999999.02)=UNII
 ..D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
