XMP ;(WASH ISC)/THM/CAP-PackMan Version 1.01 ;7/6/90  14:13 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**1**;Jun 02, 1994
NOKL G F:$D(^DOPT("XMP"))
GO K ^DOPT("XMP") S DIK="^DOPT(""XMP"","
 S ^DOPT("XMP",0)="PackMan function^1N^"
 F I=1:1 S X=$E($T(TABLE+I),4,99) Q:X=""  S ^DOPT("XMP",I,0)=X
 D IXALL^DIK Q:$D(DIFROM)!'$D(XMZ)
F D NEW Q:Y<0
FX S DIC="^DOPT(""XMP"",",DIC(0)="AEQZ" D ^DIC K DIC
 S XMR=^XMB(3.9,XMZ,0) G Q:Y<0 S X=$P(Y(0),U,2,99) K DD,DO,Y
 I $D(^XMB(3.9,XMZ,2,0)) S XCNP=$P(^(0),U,3)
 I $D(XCNP),XCNP>1,X["LOAD"!(X["PACK") S Y=$O(^XMB(3.9,XMZ,1,"C",0)) I $L(Y),$S(Y'=XMDUZ&Y:1,Y'=$P(XMR,U,2):1,$O(^(Y))'="":1,1:0) W !,"This message has already been SENT.  You may not CHANGE it.",*7 G FX
 I X["LOAD"!(X["PACK"),$S('$D(DUZ(0)):1,DUZ(0)="@":0,$D(^XUSEC("XUPROG",DUZ)):0,1:1) W !,"You do not have the privilege to LOAD packages nor routines nor globals.",*7 G FX
 I X="XI^XMP2",$S('$D(DUZ(0)):1,DUZ(0)="@":0,$D(^XUSEC("XUPROGMODE",DUZ)):0,1:1)
 I  W !!,*7,"You may only check the security of this message.",!,$S($P(^XMB(3.9,XMZ,0),U,10)'="":"You will not be allowed to install it.",1:"This message was not secured -- nothing done"),!!
 D @X D ^%ZISC D Q G FX
Q W ! K DIE,DIF,XMSUB,XCNP
 Q
TABLE ;;;DESCRIPTION^PROGRAM OR TAG^PROGRAM
 ;;ROUTINE LOAD^LOAD^XMPH
 ;;GLOBAL LOAD^LOAD^XMPG
 ;;PACKAGE LOAD^PACK^XMPH
 ;;SUMMARIZE MESSAGE^XS^XMP2
 ;;PRINT MESSAGE^XP^XMP2
 ;;INSTALL/CHECK MESSAGE^XI^XMP2
 ;;INSTALL SELECTED ROUTINE(S)^XR^XMP2
 ;;TEXT PRINT/DISPLAY^XT^XMP2
 ;;COMPARE MESSAGE^XC^XMP2
 ;;
 ;;DATA LOAD^LOAD^XMPDAT  ***** FILEMANAGER DATA MOVE ***** NOT READY
 ;;
 ;;
NEW I $S($D(DIFROM):1,$D(ZTQUEUED):1,$D(XMDF):1,1:0) G DIFROM
 W !,"Please enter description of PACKMAN Message",!,*7
 S DWPK=1,DWLW=75,DIC="^TMP(""XMP"",$J," D EN^DIWE
DIFROM S %="Created ",(DIF,DIE)="^XMB(3.9,XMZ,2,"
 I $D(DUZ),$D(^VA(200,DUZ,0)) S %=%_"by "_$P(^(0),U)_" "
 I $D(^XMB("NAME")) S %=%_"at "_$P(^("NAME"),U)_" "
 I $D(DIFROM) S %=%_" (DIFROM) "
 S %DT="T",X="NOW",XMA0=% D ^%DT
 S (XMA,X)=Y D DW^%DTC
 S XMA=$E(XMA_"0000",1,12),@(DIF_"0)")="^3.92A^2^2^"_$P(XMA,"."),^(1,0)="$TXT "_XMA0_"on "_X_", "_$E(XMA,4,5)_"/"_$E(XMA,6,7)_"/"_$E(XMA,2,3)_" at "_$E(XMA,9,10)_":"_$E(XMA,11,12)
 I '$O(^TMP("XMP",$J,0)) S ^XMB(3.9,XMZ,2,2,0)="$END TXT",XCNP=2 G OLD
 S I=2,J=0,^XMB(3.9,XMZ,2,2,0)=" "
 F  S J=$O(^TMP("XMP",$J,J)) Q:J=""  S %=" "_^(J,0),I=I+1,^XMB(3.9,XMZ,2,I,0)=%
 S ^XMB(3.9,XMZ,2,I+1,0)=" ",^XMB(3.9,XMZ,2,I+2,0)="$END TXT",XCNP=I+2,^XMB(3.9,XMZ,2,0)="^3.92A^"_XCNP_U_XCNP_U_$P(XMA,".") K ^TMP("XMP",$J),XMA0,%
OLD S XCN=0 K ^XMP("XMP",$J),XMA0 I '$D(ZTQUEUED) W !
O1 D NT Q:+XCN'=XCN  Q:X'["$TXT"  W:'$D(ZTQUEUED) !,$P(X,"TXT",2,999) G O1
NT S XCN=$O(@(DIE_XCN_")")) Q:+XCN'=XCN  S X=^(XCN,0) Q
MM S (DIE,DIF)="^XMB(3.9,XMZ,2," G FX
