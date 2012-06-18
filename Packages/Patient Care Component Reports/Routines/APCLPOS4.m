APCLPOS4 ; IHS/OHPRD/TMJ -CREATED BY ^XBERERTN ON APR 04, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ; This routine loads Routine ^ZIBVK
 ;
START ;
 S XBERPGM="ZIBVK"
 F I=1:1 S Y=$P($T(RTN+I),";;",2,99) Q:Y=""  S X="^TMP(""XBERPGM"",$J,"_I_",0)" S @X=Y
 S XCN=0,DIE="^TMP(""XBERPGM"","_$J_",",X=XBERPGM
 X ^%ZOSF("SAVE")
 K DIE,XCM,XCN
 S X=XBERPGM
 X ^%ZOSF("TEST")
 W !
 I $T W "Routine ^",XBERPGM," has been filed.",! I 1
 E  W "Saving of routine ^",XBERPGM," failed.",!
 K ^TMP("XBERPGM",$J)
 K XBERPGM,I,X,Y
 Q
 ;
RTN ; The routine to be loaded follows:
 ;;ZIBVKMSM ; IHS/OHPRD/EDE - KILL VARIABLES [ 09/30/95  11:55 AM ]
 ;; ;
 ;; ; ZL this routine and ZS as ZIBVK
 ;; ;
 ;; ; This routine kills variables that begin with the string entered
 ;; ; by the user.
 ;; ;
 ;; Q  ;        No entry from top
 ;; ;
 ;;EN(ZIBVKNS)        ;EP - KILL VARIABLES IN NAME SPACE
 ;; Q:$G(ZIBVKNS)=""
 ;; NEW ZIBVKX
 ;; S ZIBVKX=$O(@ZIBVKNS,-1)
 ;; S:ZIBVKX="" ZIBVKX="%"
 ;; K:ZIBVKNS="%" @ZIBVKNS
 ;; F  S ZIBVKX=$O(@ZIBVKX) Q:ZIBVKX=""  Q:$E(ZIBVKX,1,$L(ZIBVKNS))]ZIBVKNS  I $E(ZIBVKX,1,$L(ZIBVKNS))=ZIBVKNS,ZIBVKX'["ZIBVK" K @ZIBVKX
 ;; Q
