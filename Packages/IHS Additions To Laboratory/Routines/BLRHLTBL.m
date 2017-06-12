BLRHLTBL ; cmi/anch/maw - BHL Import HL7 Tables ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 01, 1997
 ;
BHLTBLL(DIR,FILE) ; EP
 ;;3.01;BHL IHS HL7 UTILTIES;;JUL 11,2013
 ;
 ;
 ;EP - This is the main routine driver
 S C=","
 D LOAD(DIR,FILE)
 Q:$G(BHLFLG)
 Q
 ;D EOJ
 Q
 ;
LOAD(DIR,FL) ;-- load from the file and bhl hl7 tables File
 N VALUE,DESC,TB
 S BLRY=$$OPEN^%ZISH(DIR,FL,"R")
 I BLRY D  Q
 . S BLRFLG=1
 . W !,"Trouble Opening File, please fix and try again" Q
 F BLRI=1:1 U IO R BLRX:DTIME D  Q:BLRX=""
 . Q:BLRX=""
 . S VALUE=$P(BLRX,C)
 . S DESC=$E($P(BLRX,C,2),1,150)
 . S DESC=$TR(DESC,"""","")
 . S TB=$E($P(BLRX,C,3),4,7)
 . S BLRTI=$$ADD(TB,VALUE,DESC)
 . Q:'BLRTI
 . Q
 . ;S BLRLT=$$MTCH(BLRTI)
 D ^%ZISC
 Q
 ;
ADD(TAB,VAL,DSC)          ;-- add the test code to the file
 I $O(^BHLTBL("AVAL",TAB,VAL,0)) Q ""
 N FDA,FIENS,FERR
 S FDA(90076.9,"+1,",.01)=TAB
 S FDA(90076.9,"+1,",.02)=VAL
 S FDA(90076.9,"+1,",.03)=DSC
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q ""
 ;
LOADO(DIR,FL) ;-- load from the file and bhl other tables File
 N VALUE,DESC,TB
 S BLRY=$$OPEN^%ZISH(DIR,FL,"R")
 I BLRY D  Q
 . S BLRFLG=1
 . W !,"Trouble Opening File, please fix and try again" Q
 F BLRI=1:1 U IO R BLRX:DTIME D  Q:BLRX=""
 . Q:BLRX=""
 . S VALUE=$P(BLRX,C)
 . S DESC=$E($P(BLRX,C,2),1,150)
 . S DESC=$TR(DESC,"""","")
 . S TB=$P(BLRX,C,3)
 . S BLRTI=$$ADDO(TB,VALUE,DESC)
 . Q:'BLRTI
 . Q
 . ;S BLRLT=$$MTCH(BLRTI)
 D ^%ZISC
 Q
 ;
ADDO(TAB,VAL,DSC)          ;-- add the test code to the file
 I $O(^BHLOTBL("AVAL",TAB,VAL,0)) Q ""
 N FDA,FIENS,FERR
 S FDA(90076.8,"+1,",.01)=TAB
 S FDA(90076.8,"+1,",.02)=VAL
 S FDA(90076.8,"+1,",.03)=DSC
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q ""
 ;
DISP ; EP -- display the values in an HL7 table
 N HTAB,TABL,TDA,TIEN,DATA
 S TABL=$$ASKTAB()
 I TABL="O" D DISPO Q
 S HTAB=$$ASKHTAB()
 I $G(HTAB)="" W !!,?4,"HL7 table not on system" D PRESSKEY^BLRGMENU(9)  Q
 ;
 D DSPHLTBL(HTAB)
 ; W @IOF
 ; W "HL7 Table "_HTAB
 ; W !,"Value",?17,"Description"
 ; S TDA=0 F  S TDA=$O(^BHLTBL("AVAL",HTAB,TDA)) Q:TDA=""  D
 ; . S TIEN=0 F  S TIEN=$O(^BHLTBL("AVAL",HTAB,TDA,TIEN)) Q:'TIEN  D
 ; .. S DATA=$G(^BHLTBL(TIEN,0))
 ; .. W !,$P(DATA,U,2),?17,$P(DATA,U,3)
 ; D PRESSKEY^BLRGMENU(9)
 Q
 ;
DISPO ;-- display the values in an HL7 table
 N OTAB,TABL,TDA,TIEN,DATA
 S OTAB=$$ASKOTAB()
 I $G(OTAB)="" W !!,?4,"Other table not on system" D PRESSKEY^BLRGMENU(9)  Q
 ;
 D DSPOTTBL(OTAB)
 ; W @IOF
 ; W "Other Table "_OTAB
 ; W !,"Value",?17,"Description"
 ; S TDA=0 F  S TDA=$O(^BHLOTBL("AVAL",OTAB,TDA)) Q:TDA=""  D
 ; . S TIEN=0 F  S TIEN=$O(^BHLOTBL("AVAL",OTAB,TDA,TIEN)) Q:'TIEN  D
 ; .. S DATA=$G(^BHLOTBL(TIEN,0))
 ; .. W !,$P(DATA,U,2),?27,$P(DATA,U,3)
 ; D PRESSKEY^BLRGMENU(9)
 Q
 ;
DSPHLTBL(TABLE) ; EP - Display HL7 Table
 NEW DESC,HEADER,LINES,MAXLINES,PG,QFLG
 ;
 S HEADER(1)="HL7"
 S HEADER(2)="Table "_TABLE
 S HEADER(3)=" "
 S $E(HEADER(4),5)="Value"
 S $E(HEADER(4),20)="Description"
 ;
 S MAXLINES=(IOSL-3),LINES=MAXLINES+10,PG=0,QFLG="NO"
 ;
 S TDA=0 F  S TDA=$O(^BHLTBL("AVAL",TABLE,TDA)) Q:TDA=""!(QFLG="Q")  D
 . S TIEN=0 F  S TIEN=$O(^BHLTBL("AVAL",TABLE,TDA,TIEN)) Q:'TIEN!(QFLG="Q")  D
 .. S DATA=$G(^BHLTBL(TIEN,0))
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 .. S DESC=$P(DATA,U,3)
 .. W ?4,$P(DATA,U,2)
 .. W:$L(DESC)<61 ?19,DESC
 .. D:$L(DESC)>60 LINEWRAP^BLRGMENU(19,DESC,60)
 .. W !
 .. S LINES=LINES+1
 ;
 D:QFLG'="Q" PRESSKEY^BLRGMENU(9)
 Q
 ;
DSPOTTBL(TABLE) ; EP - Display OTHER Table
 NEW DESC,HEADER,LINES,MAXLINES,PG,QFLG
 ;
 S HEADER(1)="Other"
 S HEADER(2)="Table "_TABLE
 S HEADER(3)=" "
 S $E(HEADER(4),5)="Value"
 S $E(HEADER(4),30)="Description"
 ;
 S MAXLINES=(IOSL-3),LINES=MAXLINES+10,PG=0,QFLG="NO"
 ;
 S TDA=0 F  S TDA=$O(^BHLOTBL("AVAL",TABLE,TDA)) Q:TDA=""!(QFLG="Q")  D
 . S TIEN=0 F  S TIEN=$O(^BHLOTBL("AVAL",TABLE,TDA,TIEN)) Q:'TIEN!(QFLG="Q")  D
 .. S DATA=$G(^BHLOTBL(TIEN,0))
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 .. S DESC=$P(DATA,U,3)
 .. W ?4,$P(DATA,U,2)
 .. W:$L(DESC)<51 ?29,DESC
 .. D:$L(DESC)>50 LINEWRAP^BLRGMENU(29,DESC,50)
 .. W !
 .. S LINES=LINES+1
 ;
 D:QFLG'="Q" PRESSKEY^BLRGMENU(9)
 Q
 ;
ASKTAB() ;-- get the table number
 N TAB
 S DIR("A")="HL7 or Other Table",DIR(0)="S^H:HL7;O:Other"
 D ^DIR
 I $D(DIRUT) Q ""
 S TAB=Y
 Q TAB
 ;
ASKHTAB() ;-- get the table number
 N TAB
 S DIR("A")="Which HL7 table",DIR(0)="F^1:6"
 D ^DIR
 I $D(DIRUT) Q ""
 S TAB=Y
 I '$O(^BHLTBL("B",TAB,0)) Q ""
 Q TAB
 ;
ASKOTAB() ;-- get the table number
 N TAB
 S DIR("A")="Which table",DIR(0)="F^1:15"
 D ^DIR
 I $D(DIRUT) Q ""
 S TAB=Y
 I '$O(^BHLOTBL("B",TAB,0)) Q ""
 Q TAB
 ;
