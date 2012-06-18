LRORD ;VA/DALOI/CJS - LAZY ACCESSION LOGGING ;JUL 06, 2010 3:14 PM;
 ;;5.2;LAB SERVICE;**100,121,153,286,1027**;NOV 01, 1997
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("^LRORD 0.0")
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 S:XQY0["LRFASTS" BLROPT="FASTORD",BLROPT(0)=$P(XQY0,U)
 S XWBWRAP=1  ;IHS/ITSC/TPF 10/10/02 REQUESTED BY PATIENT CHART DEV. F.J.EVANS **1014**
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="MULTI",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/1/97
 ; ----- END IHS/OIT/MKK - LR*5.2*1027 
 ;
EN ;; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EN^LRORD 0.0")
 ; I $D(^LAB(69.9,1,"RO")),+$H'=+^("RO") W $C(7),!,"ROLLOVER ",$S($P(^("RO"),U,2):"IS RUNNING.",1:"HAS NOT RUN.")," ACCESSIONING SHOULDN'T BE DONE NOW.",$C(7),!,"  Are you sure you want to continue"
 ; I $T S %=2 D YN^DICN W:%=0 !,"If you continue to accession, you may block accessions from yesterday from",!,"rolling over." G LRORD:%=0 I %'=1 W !,"OK, try later." Q
 ;-----BEGIN IHS MODIFICATION LR*5.2*1018
 I $D(^LAB(69.9,1,"RO")),+$H'=+^("RO") D  Q:$G(BLRGUI)  G LRORD:%=0 Q:%'=1
 . I $G(BLRGUI) S RESULT(1)=-1,RESULT(2)="ROLLOVER HAS NOT RUN.  CHECK WITH SITE MANAGER" Q
 . ;
 . W $C(7),!,"ROLLOVER ",$S($P(^("RO"),U,2):"IS RUNNING.",1:"HAS NOT RUN.")
 . W " ACCESSIONING SHOULDN'T BE DONE NOW.",$C(7),!
 . W "  Are you sure you want to continue"
 . S %=1 I $T S %=2 D YN^DICN W:%=0 !,"If you continue to accession, you may block accessions from yesterday from",!,"rolling over." Q:%=0  I %'=1 W !,"OK, try later."
 ;----- END IHS MODIFICATION
 ;
EN1 ;;EP - from LROR4
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EN1^LRORD 0.0")
 D ^LRPARAM
 K ^TMP("LRSTIK",$J),DIC,LRURG,LRSAME,LRCOM,LRNATURE,LRTCOM
 S LRORDTIM="" S:'$D(LRORDR) LRORDR="" D DT^LRX
 I $D(LRADDTST) Q:LRADDTST=""
 S LRFIRST=1,LRODT=DT,U="^",LRECT=0,LROUTINE=$P(^LAB(69.9,1,3),U,2)
 S:$G(LRORDRR)="R" LRECT=1,LRFIRST=0
 I '$G(LRECT),LRORDR="" W !!,"WANT TO ENTER COLLECTION TIMES? Y//" D % S LRECT='(%["N") G KILL:$E(%)="^"
 I LRORDR="LC" W !!," Ordering for ROUTINE LAB COLLECT ONLY",$C(7),! S LRLWC="LC",LRLLOC=".",LREND=0 D NEXTCOL^LROW5 G KILL:LREND
 I LRORDR="SP" W !!," Ordering for SEND PATIENT ONLY",$C(7),! S LRLWC="SP"
 I LRORDR="WC" W !!,"Ordering for WARD COLLECT & DELIVER ONLY",$C(7),! S LRLWC="WC"
 I LRORDR="I" D ^LRORDIM G KILL:'$D(LRCDT)
 ;
L5 ; EP 
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("L5^LRORD 0.0")
 I LRORDR]"",LRORDR'="LC",LRORDR'="I" S %DT="AET",%DT("A")=$S(LRORDR="WC":"COLLECTION",LRORDR="SP":"PATIENT VISIT",1:"")_" DATE: "
 I $T D DATE^LRWU G KILL:Y<1 S LRORDTIM=$P(Y,".",2),LRODT=$P(Y,".",1),X1=Y,X2=DT D ^%DTC IF X>370 W !,"Can't order more than 12 months ahead!!" G L5
 I $D(LRODT),$P(LRODT,".")?7N,'+$E($P(LRODT,"."),6,7) W !!?7,$C(7),"Please enter a date, ie. 4/1/90",!! G L5
 I $D(LRODT),$P(LRODT,".")<DT W !,$C(7),"Cannot order in the Past.",! G L5
 I $D(LRFLOG) S Y=LRFLOG G G0:LRFLOG>0
 S DIC="^LAB(62.6,",DIC(0)="AEQMZ"
 S DIC("S")=$S($D(LRLABKY):"I '(LRORDR=""LC""&'$P(^(0),U,4))",1:"I '(LRORDR=""LC""&'$P(^(0),U,4))&'$P(^(0),U,3)")
 D ^DIC K DIC G KILL:$D(DUOUT)!$D(DTOUT),G1:Y<1 S LRFLOG=Y
 ;
G0 ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("G0^LRORD 0.0")
 S $P(LRFLOG,U,3)=$P(^LAB(62.2,+$P(^LAB(62.6,+LRFLOG,0),U,2),0),U,2)
 S LRFLOG(0)=^LAB(62.6,+LRFLOG,0)
 S (LRWP,I)=0
 F  S I=$O(^LAB(62.6,+Y,1,I)) Q:I<1  D
 . S Y(0)=$G(^LAB(62.6,+Y,1,I,0)),LRWP=LRWP+1
 . S ^TMP("LRSTIK",$J,$S($P(LRFLOG(0),"^",5):I,1:LRWP))=Y(0)
 . ; Lookup by number user enters.
 . S ^TMP("LRSTIK",$J,"B",LRWP)=$S($P(LRFLOG(0),"^",5):I,1:LRWP)
 . ; Lookup by test - used by LEDI (LRORDB) when user creates list "on-the-fly"
 . S ^TMP("LRSTIK",$J,"C",+Y(0),$S($P(LRFLOG(0),"^",5):I,1:LRWP))=""
 I LRWP>40 S LRFIRST=0 ; Don't automatically display "long" test lists.
 G G5
 ;
G1 ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("G1^LRORD 0.0")
 S LRWP=0 W !,"Select one or more tests from which you will be generating your entries."
 ;
GET ; EP 
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GET^LRORD 0.0")
 D Q15^LRORD2
 D ^DIC K DIC("S") G:Y<1 G5
 S LRWP=LRWP+1,LRY=Y
 S ^TMP("LRSTIK",$J,LRWP)=$P(LRY,U,1,2)
 ; "B" Used to lookup by number user enters.
 S ^TMP("LRSTIK",$J,"B",LRWP)=LRWP
 ; "C" Used by LEDI (LRORDB)
 S ^TMP("LRSTIK",$J,"C",+LRY,LRWP)=""
 S LRTSTS=+^TMP("LRSTIK",$J,LRWP) D GS^LRORD3
 S:+LRSAMP=-1&(LRSPEC=-1) LRWP=LRWP-1
 G GET:+LRSAMP=-1&(LRSPEC=-1)
 S ^TMP("LRSTIK",$J,LRWP)=^TMP("LRSTIK",$J,LRWP)_U_LRSAMP_U_U_LRSPEC
 G GET
 ;
G5 ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("G5^LRORD 0.0")
 G KILL:LRWP<1
 S:'$D(^LRO(69,LRODT,0)) ^(0)=$P(^LRO(69,0),U,1,2)_U_LRODT_U_(1+$P(^(0),U,4)),^LRO(69,LRODT,0)=LRODT,^LRO(69,"B",LRODT,LRODT)=""
 S LRURG="",LRAD=DT,LRWPD=LRWP\2+(LRWP#2) D ^LRORD1
 ;
KILL ; EP 
 D ^LRORDK,HOME^%ZIS Q
 ;
% R %:DTIME Q:%=""!(%["N")!(%["Y")!($E(%)="^")  W !,"Answer 'Y' or 'N': " G %
 ;
EN01 ;EP - LAB COLLECT ORDER ENTRY
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EN01^LRORD 0.0")
 ;
ORDER ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ORDER^LRORD 0.0")
 S %=2 W !,"Do you want copies of the orders" D YN^DICN Q:%=-1  S:%=1 LRSLIP="" I %=0 D QUIZ G ORDER
 S LRORDR="LC",LRLWCURG=$S($P(^LAB(69.9,1,3),U,2)'="":$P(^(3),U,2),1:9)
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="FASTORD",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/13/97
 G LRORD
 ;
EN02 ; EP SEND PATIENT ORDER ENTRY
SENDPAT ; EP - S %=2 W !,"Do you want copies of the orders" D YN^DICN Q:%=-1  S:%=1 LRSLIP="" I %=0 D QUIZ G SENDPAT
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("SENDPAT^LRORD 0.0")
 S %=2 W !,"Do you want copies of the orders" D YN^DICN Q:%=-1  S:%=1 LRSLIP="" I %=0 D QUIZ G SENDPAT   ; IHS/OIT/MKK -- LR*5.2*1027 -- Restored line
 S LRORDR="SP"
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="FASTORD",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/13/97
 G LRORD
 ;
IMMCOL ;EP - IMMEDIATE LAB COLLECTION
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("IMMCOL^LRORD 0.0")
 I '$P($G(^LAB(69.9,1,7,DUZ(2),0)),U,6) W !!?5," This option is not available at the time ",!!,$C(7) Q
 S LRORDR="I"
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="FASTORD",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/13/97  -- IHS/OIT/MKK -- LR*5.2*1027 -- Restored line
 K LRODT G LRORD
 ;
EN03 ; EP - WARD COLLECT ORDER ENTRY
WARDCOL ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("WARDCOL^LRORD 0.0")
 S %=2
 W !,"Do you want copies of the orders" D YN^DICN Q:%=-1  S:%=1 LRSLIP="" I %=0 D QUIZ G WARDCOL
 S LRORDR="WC"
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER WARDCOL^LRORD","BLROPT")      ; <<<<<<< DEBUG
 S:$G(BLROPT)=""!($G(BLROPT(0))'=$P(XQY0,U)) BLROPT="FASTORD",BLROPT(0)=$P(XQY0,U)  ;IHS/OIRM TUC/AAB 2/13/97  -- IHS/OIT/MKK -- LR*5.2*1027 -- Restored line
 D LRORD
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("WARDCOL^LRORD 9.0")
 Q
 ;
LEDI ; EP - Laboratory Electronic Data Exchange
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("LEDI^LRORD 0.0")
 ; This entry point is used to select patients from ^LRT(67, file
 ; Routine LRDPAREF controls patient selection, patients must already
 ; exist in ^DPT in order to be selected.
 D ^LRPARAM
 I $G(LREND) D ^LRORDK Q
 N CONTROL,LA7,LA7SCFG,LA7X,LA7Y,LR64,LR696,LRLABLIO,LRRSTAT,LRRSITE,LRSD,LRTSN
 S LRREFBAR=$$BAR^LA7SBCR
 I LRREFBAR<0 D ^LRORDK Q
 S LRRSTAT="I"
 S LRRSTAT(0)=$$FIND1^DIC(64.061,"","OMX","Specimen in process","","I $P(^LAB(64.061,Y,0),U,7)=""U""")
 D SITE^LA7SBCR2(.LRRSITE,"Scan Remote Site Barcode (SM)",LRREFBAR)
 I LRRSITE("ERROR") D  Q
 . W !!,$C(7),"ERROR -- ",$P(LRRSITE("ERROR"),"^",2),!
 . D ^LRORDK
 ;
 ; Get shipping manifest ID manual input
 I $G(LRRSITE("SMID"))="" D
 . F  D SMID^LRORDB Q:LREND!($G(LRRSITE("SMID"))'="")
 I $G(LREND) D ^LRORDK Q
 ;
 ; LRORDRR="R" variable indicates host accessioning of remote orders
 S LRORDRR="R",LRORDR="" K LRODT
 D LRORD,^LRORDK
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("LEDI^LRORD 9.0")
 Q
 ;
 ; LRORDRR =TYPE OF ORDER, LRECT =ASK COLECTION TIME
 ; LRFLOG =ACCESSION TEST GROUP, IF DEFINED ON ENTRY, PRESELECTS GROUP
 ;
QUIZ ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("QUIZ^LRORD 0.0")
 W !,"The order copy is automatically sent to the CLOSEST PRINTER,"
 W !,"if a closest printer is defined for the device you are using."
 W !,"Otherwise, you will be prompted with ORDER COPY DEVICE.",!
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
START(RESULT,BPCPARAM)  ;EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("START^LRORD 0.0")
 I $$VERSION^XPDUTL("LAB SERVICE")'="5.2" D  Q
 . S RESULT(1)=-1
 . S RESULT(2)="LAB ORDERING NOT ALLOWED.  Wrong LAB version or LAB not installed."
 ;
 S BLRGUI=1
 S DFN=$P(BPCPARAM,";",1)
 S BPCTL=$P(BPCPARAM,";",2)
 S LRORDR=$P(BPCPARAM,";",3) I LRORDR="" I '$D(^XUSEC("LRLAB",DUZ)) S RESULT(1)=-1,RESULT(2)="User not authorized for LAB ACCESSIONING." Q 
 S BPCURG=$P(BPCPARAM,";",4) I '$D(^LAB(62.05,"B",BPCURG)) S RESULT(1)=-1,RESULT(2)="No URGENCY "_BPCURG_" defined in Lab file 62.05." Q
 S BPCURG=$O(^LAB(62.05,"B",BPCURG,0))
 S BPCODT=$P(BPCPARAM,";",6)
 S BPCCOM=$P(BPCPARAM,";",7)    ; MJL I $L(BPCCOM)
 S BPCOORDS=$P(BPCPARAM,";",8)  ; FHL 8/7/98 - OTHER ORDERS
 S BLRPRAC=$P(BPCPARAM,";",9)   ; MJL - PROVIDER
 S LRFLOG=$P(BPCPARAM,";",10)   ; MJL - PICKLIST
 S BPCACC=""
 D ^LRORDGUI                    ; Patient Chart version of LRORD
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("START^LRORD 9.0")
 Q
 ; ----- END IHS/OIT/MKK - LR*5.2*1027 
