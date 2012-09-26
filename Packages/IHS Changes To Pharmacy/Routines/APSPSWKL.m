APSPSWKL ; IHS/MSC/PLS - PHARMACY STAFF WORKLOAD REPORT ;28-Sep-2011 12:06;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 33
 ;
EN ;EP
 N AOSOQ,APSPBDF,APSPEDF,APSPDIV,APSPNUM,APSPUSR,APSPNAME,APSPCNT
 N APSPTOT,APSPTYP,APSPCLAS,APSPBD,APSPED,APSPDARY,APSPQ,QFLG
 K ^TMP("APSPW",$J)
 S APSPDIV="",APSPQ=0,APSPCNT=0,APSPTYP=0,APSPUSR=""
 S APSPTOT=0_U_0_U_0    ;Total new orders ^ total refills ^ grand total
 W @IOF
 W !!,"Pharmacy Staff Workload Report"
 D ASKDATES^APSPUTIL(.APSPBD,.APSPED,.APSPQ,DT,DT)
 Q:APSPQ
 S APSPBDF=$P($TR($$FMTE^XLFDT(APSPBD,"5Z"),"@"," "),":",1,2)
 S APSPEDF=$P($TR($$FMTE^XLFDT(APSPED,"5Z"),"@"," "),":",1,2)
 S APSPBD=APSPBD-.01,APSPED=APSPED+.99
 S APSPDIV=$$DIR^APSPUTIL("Y","Would you like all pharmacy divisions","Yes",,.APSPQ)
 Q:APSPQ
 I APSPDIV D
 .S APSPDIV="*"
 E  D  Q:APSPQ
 .S APSPDIV=$$GETIEN^APSPUTIL(59,"Select Pharmacy Division: ",.APSPQ)
 Q:APSPQ
 S APSPNUM=$$DIR^APSPUTIL("S^I:Individual Pharmacy user;A:All Pharmacy users","Lookup Individual User or List ALL Users? ","A",,.APSPQ)
 I APSPNUM="A" S APSPDARY="*"
 I APSPNUM="I" D
 .F  D  Q:QFLG
 ..S APSPUSR=$$GETIEN1^APSPUTIL(200,"Select Pharmacy User: ",-1,"B")
 ..I APSPUSR<1 S QFLG=1 Q
 ..S APSPCLAS=$$GET1^DIQ(200,APSPUSR,53.5)
 ..S APSPNAME=$$GET1^DIQ(200,APSPUSR,.01)
 ..I APSPCLAS="PHARMACIST"!(APSPCLAS="PHARMACY TECHNICIAN")!(APSPCLAS="PHARMCY PRACTITIONER")!(APSPCLAS="CLINICAL PHARMACY SPECIALIST") D
 ...S APSPDARY(APSPUSR)=APSPNAME
 ...S APSPCNT=APSPCNT+1
 ..E  D
 ...W !,APSPNAME_" is not a pharmacy user."
 ..S QFLG='$$DIRYN^APSPUTIL("Want to Select Another User","No","Enter a 'Y' or 'YES' to include more pharmacy users in your search",.APSPQ)
 ..S:'QFLG QFLG=APSPQ
 Q:APSPQ
 D DEV
 Q
DEV ;
 N XBRP,XBNS
 S XBRP="OUT^APSPSWKL"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 U IO
 K ^TMP($J)
 D FIND(APSPBD,APSPED,"AD")  ; Regular and Refill
 D PRINT
 K ^TMP("APSPW",$J)
 Q
 ;
FIND(SDT,EDT,XREF) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN,PHARM
 S FDTLP=SDT-.01
 F  S FDTLP=$O(^PSRX(XREF,FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RXIEN=0
 .F  S RXIEN=$O(^PSRX(XREF,FDTLP,RXIEN)) Q:'RXIEN  D
 ..Q:'$P(^PSRX(RXIEN,0),U,6)   ; Prescription must have a drug
 ..Q:$$GET1^DIQ(52,RXIEN,100,"I")=13  ; Quit if Deleted status
 ..Q:$$GET1^DIQ(52,RXIEN,111,"I")'=1   ; Quit if not POE entered RX
 ..S IEN="" F  S IEN=$O(^PSRX(XREF,FDTLP,RXIEN,IEN)) Q:IEN=""  D
 ...Q:'IEN&($$GET1^DIQ(52,RXIEN,32.1,"I"))  ; Quit if original fill and a return to stock date exists
 ...Q:'$$DIVVRY(RXIEN,APSPDIV,XREF,IEN)  ;check division
 ...Q:'$$DSPRDT(RXIEN,XREF,IEN)  ;check for release date
 ...I IEN=0 D NEW(RXIEN,IEN)
 ...I IEN>0 D REFILL(RXIEN,IEN)
 Q
 ;
NEW(RXIEN,IEN) ;Find new prescriptions
 N PHARM
 S PHARM=$P($G(^PSRX(RXIEN,2)),U,3)
 I APSPNUM="A" D SETNEW(PHARM)
 I APSPNUM="I" D
 .I $D(APSPDARY(PHARM)) D SETNEW(PHARM)
 Q
SETNEW(PHARM) ;Set the pharmacist data
 N PHARNAME,GT,RT,NT,NP,RP,TP,DATA
 S PHARNAME=$$GET1^DIQ(200,PHARM,.01)
 I $D(^TMP("APSPW",$J,PHARNAME)) D
 .S DATA=$G(^TMP("APSPW",$J,PHARNAME))
 .S NP=$P(DATA,U,1),RP=$P(DATA,U,2),TP=$P(DATA,U,3)
 .S NP=NP+1,TP=TP+1
 .S ^TMP("APSPW",$J,PHARNAME)=NP_U_RP_U_TP
 I '$D(^TMP("APSPW",$J,PHARNAME)) D
 .S ^TMP("APSPW",$J,PHARNAME)=1_U_0_U_1
 S NT=$P(APSPTOT,U,1),RT=$P(APSPTOT,U,2),GT=$P(APSPTOT,U,3)
 S NT=NT+1,GT=GT+1
 S APSPTOT=NT_U_RT_U_GT
 Q
REFILL(RXIEN,IEN) ;Find refills
 N PHARM
 S PHARM=$P($G(^PSRX(RXIEN,1,IEN,0)),U,5)
 I APSPNUM="A" D SETRFILL(PHARM)
 I APSPNUM="I" D
 .I $D(APSPDARY(PHARM)) D SETRFILL(PHARM)
 Q
SETRFILL(PHARM) ;Set provider data
 N PHARNAME,GT,RT,NT,NP,RP,TP,DATA
 S PHARNAME=$$GET1^DIQ(200,PHARM,.01)
 I $D(^TMP("APSPW",$J,PHARNAME)) D
 .S DATA=$G(^TMP("APSPW",$J,PHARNAME))
 .S NP=$P(DATA,U,1),RP=$P(DATA,U,2),TP=$P(DATA,U,3)
 .S RP=RP+1,TP=TP+1
 .S ^TMP("APSPW",$J,PHARNAME)=NP_U_RP_U_TP
 I '$D(^TMP("APSPW",$J,PHARNAME)) D
 .S ^TMP("APSPW",$J,PHARNAME)=0_U_1_U_1
 S NT=$P(APSPTOT,U,1),RT=$P(APSPTOT,U,2),GT=$P(APSPTOT,U,3)
 S RT=RT+1,GT=GT+1
 S APSPTOT=NT_U_RT_U_GT
 Q
 ; Return boolean flag indicating valid pharmacy division
DIVVRY(RX,DIV,TYP,SIEN) ;EP
 Q:DIV="*" 1
 Q $S($G(SIEN):DIV=+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,9),1:DIV=+$P(^PSRX(RX,2),U,9))
 ; Return release date for dispense
DSPRDT(RX,TYP,SIEN) ;EP
 Q $S($G(SIEN):+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,$S(TYP="ADP":19,1:18)),1:+$P(^PSRX(RX,2),U,13))
PRINT ;Print out the report
 N PHARM,TOT,NUMBERS,%NEW,%RFILL
 I APSPNUM="I" D PRT1
 I APSPNUM="A" D PRT2
 Q
PRT1 ;Print individual providers
 N PHARM,NUMBERS
 D HDR1
 S PHARM="" F  S PHARM=$O(^TMP("APSPW",$J,PHARM)) Q:PHARM=""  D
 .S NUMBERS=$G(^TMP("APSPW",$J,PHARM))
 .W !,PHARM,?30,$P(NUMBERS,U,1),?40,$P(NUMBERS,U,2),?50,$P(NUMBERS,U,3)
 .I $Y+4>IOSL,IOST["C-" D PAUS Q:APSPQ  D HDR1
 .Q:APSPQ=1
 W !!,?50,"Total New RX: "_$P(APSPTOT,U,1)
 W !,?50,"Total Refills: "_$P(APSPTOT,U,2)
 W !,?50,"GRAND TOTAL: "_$P(APSPTOT,U,3)
 Q
PRT2 ;Print all providers
 N PHARM,NUMBERS,NNUM,RNUM,TOT,NTOT,RTOT
 D HDR2
 S PHARM="" F  S PHARM=$O(^TMP("APSPW",$J,PHARM)) Q:PHARM=""  D
 .S NUMBERS=$G(^TMP("APSPW",$J,PHARM))
 .S NNUM=$P(NUMBERS,U,1),RNUM=$P(NUMBERS,U,2),TOT=$P(NUMBERS,U,3)
 .S NTOT=$P(APSPTOT,U,1),RTOT=$P(APSPTOT,U,2)
 .I NTOT=0 S %NEW=0
 .E  S %NEW=$$ROUND((NNUM/NTOT),3)*100
 .I RTOT=0 S %RFILL=0
 .E  S %RFILL=$$ROUND((RNUM/RTOT),3)*100
 .W !,PHARM,?30,NNUM,?40,%NEW,?50,RNUM,?60,%RFILL,?70,TOT
 .I $Y+4>IOSL,IOST["C-" D PAUS Q:APSPQ  D HDR2
 .Q:APSPQ=1
 W !!,?50,"Total New RX: "_$P(APSPTOT,U,1)
 W !,?50,"Total Refills: "_$P(APSPTOT,U,2)
 W !,?50,"GRAND TOTAL: "_$P(APSPTOT,U,3)
 Q
PAUS ;
 N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S APSPQ=1
 Q
HDR1 ; Header for individual users
 N LIN
 I IOST["C-" W @IOF
 W !,"Pharmacist Workload Report: Individual Users"
 W !,"Pharmacy User",?30,"New",?40,"Refills",?50,"Total"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
HDR2 ; Hader for all users
 N LIN
 I IOST["C-" W @IOF
 W !,"Pharmacist Workload Report: All Users"
 W !,"Pharmacy User",?30,"New",?40,"% total",?50,"Refills",?60,"% total",?70,"Total"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
ROUND(VAL,SD) ;
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
