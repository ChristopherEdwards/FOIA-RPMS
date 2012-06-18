BDGSPTR ;cmi/anch/maw - BDG Sensitive Patient Tracking Report 6/3/2009 2:17:08 PM
 ;;5.3;PIMS;**1010,1011**;MAY 28, 2004
 ;
 ;
 ;
 ;
MAIN ;-- this is the main routine driver
 N BDGSPTS,BDGINDX
 S BDGSPTS=$$SORT()
 I $G(BDGSPTS)="" Q
 I BDGSPTS="S" S BDGSS=$$S()
 I BDGSPTS="S",+$G(BDGSS)<0 Q
 D LOOP(BDGSPTS)
 D PRINT(BDGSPTS)
 D EOJ
 Q
 ;
SORT() ;-- ask the sort for the report
 S DIR(0)="S^M:MAIL CODE;S:SERVICE SECTION",DIR("A")="Sort By ",DIR("B")="M"
 D ^DIR
 I Y=U Q ""
 S BDGSPTSE=Y(0)
 Q Y
 ;
S() ;-- get service section
 S DIC=49,DIC(0)="AEMQZ",DIC("A")="Service/Section: "
 D ^DIC
 I 'Y Q ""
 Q +Y
 ;
LOOP(IDX) ;-- loop through the new person file
 N BDGDA
 S BDGDA=0 F  S BDGDA=$O(^BDGSPT("B",BDGDA)) Q:'BDGDA  D
 . N BDGIEN
 . S BDGIEN=0 F  S BDGIEN=$O(^BDGSPT("B",BDGDA,BDGIEN)) Q:'BDGIEN  D
 .. N BDGNM,BDGSSE,BDGMC,BDGI
 .. S BDGI=$P($G(^BDGSPT(BDGIEN,0)),U)
 .. S BDGNM=$P($G(^VA(200,BDGI,0)),U)
 .. S BDGSSE=$$GET1^DIQ(200,BDGI,29)
 .. I BDGSSE="" S BDGSSE="N/A"
 .. S BDGMC=$$GET1^DIQ(200,BDGI,28)
 .. I BDGMC="" S BDGMC="N/A"
 .. S ^TMP("BDGSPT",$J,$S(IDX="S":BDGSSE,1:BDGMC),BDGNM)=$S(IDX="S":BDGMC,1:BDGSSE)
 Q
 ;
PRINT(IDX) ;-- print the report
 D ^%ZIS
 Q:POP
 U IO
 D XHDR(IDX)
 N BDGTDA
 S BDGTDA=0 F  S BDGTDA=$O(^TMP("BDGSPT",$J,BDGTDA)) Q:BDGTDA=""  D
 . N BDGTIEN
 . S BDGTIEN=0 F  S BDGTIEN=$O(^TMP("BDGSPT",$J,BDGTDA,BDGTIEN)) Q:BDGTIEN=""  D
 .. N BDGDATA,BDGTSS,BDGTMC
 .. S BDGDATA=$G(^TMP("BDGSPT",$J,BDGTDA,BDGTIEN))
 .. S BDGTMC=$P(BDGDATA,U)
 .. D:$Y+2>IOSL HDR(IDX) Q:$G(DIRUT)
 .. W !,BDGTIEN,?35,BDGTDA,?55,BDGTMC
 Q
 ;
HDR(ID) ;-- do the charge header
 K DIRUT
 I $E(IOST,1,1)="C" S DIR(0)="E" D ^DIR I Y<1 S DIRUT=1 Q
XHDR(ID) W @IOF
 W "Sensitive Patient Tracking - Users Access by "_BDGSPTSE,?60,"Date:  "_$$FMTE^XLFDT(DT)
 W !!,"Name",?35,$S(ID="S":"Service Section",1:"Mail Code"),?55,$S(ID="S":"Mail Code",1:"Service/Section")
 W !
 F I=1:1:80 W "-"
 Q
 ;
EOJ ;-- kill variables
 D ^%ZISC
 K BDGSPTSE
 K ^TMP("BDGSPT",$J)
 Q
 ;
