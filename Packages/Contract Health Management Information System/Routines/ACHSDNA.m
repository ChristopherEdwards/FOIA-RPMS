ACHSDNA ; IHS/ITSC/PMF - DENIAL LIST ALPHA BY PATIENT ;7/27/10  16:17
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**1,6,18**;JUNE 11, 2001
 ;;ACHS*3.1*1;  make call to ACHSDNI into call to ACHSDNA
 ;;ACHS*3.1*6;  Add close device 
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 K X2,X3
A2 ;
 S %=$$DIR^ACHS("Y","ALL DENIALS","YES","Enter 'YES' for all denials or 'NO' to select a date range.","",2)
 I $D(DUOUT)!$D(DTOUT) Q
 I % S ACHDBDT=1,ACHDEDT=9999999 G B
BDT ; --- Input date range
 S ACHDBDT=$$DATE^ACHS("B","DENIAL LIST BY PATIENT")
 G:ACHDBDT<1 A2
 S ACHDEDT=$$DATE^ACHS("E","DENIAL LIST BY PATIENT")
 G:ACHDEDT<1 BDT
 I $$EBB^ACHS(ACHDBDT,ACHDEDT) G A2
B ;
 S ACHDHAT=""
DEV ; --- Select device for report.
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS Q
 G:'$D(IO("Q")) START
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 ;
 ;11/26/01  pmf  replace next line to call ACHSDNA, not DNI ACHS*3.1*1
 ;S ZTRTN="START^ACHSDNI",ZTDESC="CHS Denial Documents "_(ACHDBDT+17000000)_" to "_(ACHDEDT+17000000) ; ACHS*3.1*1
 S ZTRTN="START^ACHSDNA",ZTDESC="CHS Denial Documents "_(ACHDBDT+17000000)_" to "_(ACHDEDT+17000000)  ; ACHS*3.1*1
 ;
 F %="ACHDBDT","ACHDEDT" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
 K ZTSK
 Q
 ;
START ;EP - TaskMan.
 K ^TMP($J,"ACHSDNA")
 S ACHDISU=ACHDBDT-1
 S (ACHDTOT("$"),ACHDTOT)=0
 S ACHDT1=$$C^ACHS($S(ACHDBDT=1:"***   ALL DENIALS   ***",1:"For the period "_$$FMTE^XLFDT(ACHDBDT)_" through "_$$FMTE^XLFDT(ACHDEDT)))
 D BRPT^ACHS
 D HDR
 D EXTR
 D PRINT
 ;IHS/SET/JVK ACHS*3.1*6 - ADD LINE BELOW TO CLOSE DEVICE
 D ERPT^ACHS
 K ACHDISU,ACHDNAME,ACHDTOT,DA,^TMP($J,"ACHSDNA")
 Q
 ;
EXTR ;
 F  S ACHDISU=$O(^ACHSDEN(DUZ(2),"D","AISSUE",ACHDISU)) Q:ACHDISU=""  Q:(ACHDISU>ACHDEDT)  D
 . S DA=0 F  S DA=$O(^ACHSDEN(DUZ(2),"D","AISSUE",ACHDISU,DA)) Q:'DA  D
 .. S ACHD0=$G(^ACHSDEN(DUZ(2),"D",DA,0)) I ACHD0="" Q
 .. ;if cancelled, stop
 .. I $P(ACHD0,U,8)="Y" Q
 .. I $E(ACHD0)="#" Q
 .. D GETNAME
 .. I ACHDNAME="" Q
 .. S ^TMP($J,"ACHSDNA",ACHDNAME,DA)=""
 .. Q
 . Q
 Q
 ;
PRINT ;
 S ACHDNAME="" F  S ACHDNAME=$O(^TMP($J,"ACHSDNA",ACHDNAME)) Q:ACHDNAME=""!$G(ACHSQUIT)  D
 . S DA=0 F  S DA=$O(^TMP($J,"ACHSDNA",ACHDNAME,DA)) Q:DA=""!$G(ACHSQUIT)  D
 .. S ACHD0=^ACHSDEN(DUZ(2),"D",DA,0)
 .. S ACHDISU=$P(ACHD0,U,2)
 .. S ACHD("$")=""
 .. I $D(^ACHSDEN(DUZ(2),"D",DA,100)) D DOLLARS
 .. W ACHDNAME,?38,$$FMTE^XLFDT(ACHDISU),?51,$P(ACHD0,U),?65
 .. S X=ACHD("$"),X2=2,X3=12
 .. D FMT^ACHS
 .. W !
 .. I $Y>ACHSBM D  I $G(ACHSQUIT) Q
 ... D RTRN^ACHS
 ... I $D(DUOUT)!$D(DTOUT)!$G(ACHSQUIT) D ERPT^ACHS S ACHSQUIT=1 Q
 ... D HDR
 ... Q
 .. S ACHDTOT=ACHDTOT+1
 .. S ACHDTOT("$")=ACHDTOT("$")+ACHD("$")
 .. Q
 . Q
 ;
 I $G(ACHSQUIT) Q
 ;
 S X=ACHDTOT("$"),X2="2$",X3=16
 D COMMA^%DTC
 W !,$$REPEAT^XLFSTR("=",79),!,"TOTALS FOR THIS REPORT: ",ACHDTOT," DENIAL",$S(ACHDTOT=1:"",1:"S"),?61,X
 K ACHDHAT
 I IO(0)=IO D RTRN^ACHS
 W @IOF
 Q
 ;
GETNAME ;
 ;get the name and format it.  default is null
 ;
 S ACHDNAME=""
 ;if patient is not registered, then get the name from denial
 ;formatting is simple, but will fail on complicated names
 ;the forms we look for are
 ;    LAST,FIRST (MIDDLE OPTIONAL)
 ;    FIRST LAST
 ;    FIRST MIDDLE LAST
 ;
 I $P(ACHD0,U,6)="N" D  Q
 . S ACHDNAME=$P($G(^ACHSDEN(DUZ(2),"D",DA,10)),U,1)
 . I ACHDNAME["," Q
 . S LEN=$L(ACHDNAME," ")
 . S ACHDNAME=$P(ACHDNAME," ",LEN)_", "_$P(ACHDNAME," ",1,LEN-1)
 . Q
 ;fetch name from DPT
 S ACHDNAME=$P(ACHD0,U,7) I ACHDNAME="" Q
 S ACHDNAME=$P($G(^DPT(ACHDNAME,0)),U,1)
 Q
 ;
HDR ; --- Pagination for report.
 S ACHSPG=$G(ACHSPG)+1
 ;{ABK, 4/2/10}W @IOF,!!,$$C^ACHS("***  CHS DENIAL/DEFERRED SERVICES  ***",80),!!,ACHSLOC,!?19,"DENIAL DOCUMENTS ALPHABETICALLY BY PATIENT",?71,"Page",$J(ACHSPG,3),!
 W @IOF,!!,$$C^ACHS("***  CHS DENIAL  ***",80),!!,ACHSLOC,!?19,"DENIAL DOCUMENTS ALPHABETICALLY BY PATIENT",?71,"Page",$J(ACHSPG,3),!
 W ACHSTIME,!!,ACHDT1,!!,"PATIENT",?38,"ISSUE DATE",?51,"DOCUMENT #",?70,"DOLLARS",!,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
DOLLARS ;EP - Get Dollar Amount for each Denial.
 S ACHD("$")=$S(+$P($G(^ACHSDEN(DUZ(2),"D",DA,100)),U,9):+$P($G(^ACHSDEN(DUZ(2),"D",DA,100)),U,9),1:+$P($G(^ACHSDEN(DUZ(2),"D",DA,100)),U,8))
 ;
 I $D(^ACHSDEN(DUZ(2),"D",DA,200)) D
 .F DA(1)=0:0 S DA(1)=$O(^ACHSDEN(DUZ(2),"D",DA,200,DA(1))) Q:'DA(1)  D
 ..I $D(^ACHSDEN(DUZ(2),"D",DA,200,DA(1),0)) D
 ...S ACHD("$")=ACHD("$")+$S(+$P($G(^ACHSDEN(DUZ(2),"D",DA,200,DA(1),0)),U,3):$P($G(^ACHSDEN(DUZ(2),"D",DA,200,DA(1),0)),U,3),1:+$P($G(^ACHSDEN(DUZ(2),"D",DA,200,DA(1),0)),U,2))
 ;
 I $D(^ACHSDEN(DUZ(2),"D",DA,210)) D
 .F DA(1)=0:0 S DA(1)=$O(^ACHSDEN(DUZ(2),"D",DA,210,DA(1))) Q:'DA(1)  D
 ..I $D(^ACHSDEN(DUZ(2),"D",DA,210,DA(1),0)) D
 ...S ACHD("$")=ACHD("$")+$S(+$P($G(^ACHSDEN(DUZ(2),"D",DA,210,DA(1),0)),U,7):+$P($G(^ACHSDEN(DUZ(2),"D",DA,210,DA(1),0)),U,7),1:+$P($G(^ACHSDEN(DUZ(2),"D",DA,210,DA(1),0)),U,6))
 ;
 I $D(^ACHSDEN(DUZ(2),"D",DA,800)) D
 .F DA(1)=0:0 S DA(1)=$O(^ACHSDEN(DUZ(2),"D",DA,800,DA(1))) Q:'DA(1)  D
 ..I $D(^ACHSDEN(DUZ(2),"D",DA,800,DA(1),0)) S ACHD("$")=ACHD("$")-(+$P($G(^ACHSDEN(DUZ(2),"D",DA,800,DA(1),0)),U,2))
 Q
 ;
AMT ;EP - Write amount of denial on denial letter(s).
 S ACHD("$")=0
 D DOLLARS
 W:$X>9 !
 W ?DIWL+3,"Total amount of services denied : "
 S X=ACHD("$")
 D FMT^ACHS
 W !
 Q
 ;
