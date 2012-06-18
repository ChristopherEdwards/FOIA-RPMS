FH ; HISC/REL - Dietetics System ;2/15/95  15:56 
 ;;5.0;Dietetics;**17,37**;Oct 11, 1995
EN0 ; Set Dietetics Patient File Entry
SET ;
 Q
EN2 ; Queue a task
 K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE S ZTRTN=FHPGM,ZTREQ="@",ZTSAVE("ZTREQ")=""
 S ZTDESC=$P(XQY0,"^",1)
 F V3=1:1 S V1=$P(FHLST,"^",V3) Q:V1=""  S ZTSAVE(V1)=""
 D ^%ZTLOAD D ^%ZISC U IO W !,"Request Queued",! K V1,V3,FHPGM,FHLST,ZTSK Q
EN4 ; Kill System Variables
 Q
SITE ; Get Site Name & Number
 S FHSITE=$P($G(^XMB(1,1,"XUS")),"^",17),SITE(1)="   ",SITE="" Q:'FHSITE
 S SITE(1)=$P($G(^DIC(4,FHSITE,99)),"^",1)
 I $$PATCH^XPDUTL("DG*5.3*134") S SITE=$$NAME^VASITE I SITE'="" K FHSITE Q
 S SITE=$P($G(^DIC(4,FHSITE,0)),"^",1) K FHSITE Q
TR ; Translate All Lower Case entry to Upper Case
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
DTP ; Printable Date/Time
 S %=DTP,DTP=$J(+$E(DTP,6,7),2)_"-"_$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(DTP,4,5))_"-"_$E(DTP,2,3)
 S:%#1 %=+$E(%_"0",9,10)_"^"_$E(%_"000",11,12),DTP=DTP_$J($S(%>12:%-12,1:+%),3)_":"_$P(%,"^",2)_$S(%<12:"am",%<24:"pm",1:"m") K % Q
 Q
DLSO ; Delete Standing Order if Inactivated (called by 118.3,99 dd)
 Q
 ;I Y'="Y" Q
 ;W ! S SO=D0,CT=0
 ;F FHPAT=0:0 S FHPAT=$O(^FHPT(FHPAT)) Q:FHPAT'>0  D
 ;.S CT=CT+1 I CT#10=0 W "."
 ;.F FHADM=0:0 S FHADM=$O(^FHPT(FHPAT,"A",FHADM)) Q:FHADM'>0  D
 ;..F FHSO=0:0 S FHSO=$O(^FHPT(FHPAT,"A",FHADM,"SP",FHSO)) Q:FHSO'>0  D
 ;...I $P($G(^FHPT(FHPAT,"A",FHADM,"SP",FHSO,0)),U,2)=SO S $P(^FHPT(FHPAT,"A",FHADM,"SP",FHSO,0),U,2)=""
 ;Q
SPKS ; Kill Stmt for file #119.6, fields 3,4,5 AS x-refs
 S VAR=$S(DI=3:"T",DI=4:"C",DI=5:"D",1:"") Q:VAR=""
 S STR=$P($G(^FH(119.6,DA,0)),U,10),NWSTR=""
 I STR'[VAR Q
 S NWSTR=$E(STR,1,$F(STR,VAR)-2)_$E(STR,$F(STR,VAR),3)
 S $P(^FH(119.6,DA,0),U,10)=NWSTR
 Q
