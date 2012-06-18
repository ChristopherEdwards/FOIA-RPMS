ASUUHDG ; IHS/ITSC/LMH - SAMS MENU HEADINGS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2980414
 ;;
EN ;EP
 ; ----- ENTRY POINT CALLED BY ENTRY ACTION FIELD -----
 K XQUIT
 D ^XBKVAR,^ASUVAR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q
 S ASUUOUT=0
 D HOME^ASUUHDG,AC^ASUUHDG,RV^ASUUHDG
 I ASUUOUT S XQUIT=1
 D KILL^ASUUHDG
 Q
HOME ;EP ; ----- SETS HOME DEVICE IO VARIABLES -----
 D HOME^%ZIS,ENS^%ZISS
 S ACRTRM=^%ZIS(2,IOST(0),5)
 S ACRON=$P(ACRTRM,U,4),ACROF=$P(ACRTRM,U,5)
 Q
AC ;EP ; ----- WRITES WARNING MESSAGE IF FILEMAN ACCESS CODE NOT RIGHT -----
 I DUZ(0)=""!((DUZ(0)'["#")&(DUZ(0)'["s")&(DUZ(0)'["S")) D
 . W *7,*7
 . D WRITE^ASUUHDG("ACTXT",0)
 . D PAZ^ASUURHDR
 Q
RV ;EP ; ----- WRITES WARNING MESSAGE IF REVERSE VIDEO NOT DEFINED -----
 Q:$G(ACRON)]""&($G(ACROF)]"")
 W @IOF
 W *7,*7
 K ASUU
 S ASUU(1)=$I
 D WRITE^ASUUHDG("RVTXT",0,.ASUU)
 D PAZ^ASUURHDR
 K ASUU
 Q
HDR(ASUUM)         ;EP
 ; ----- ENTRY POINT CALLED BY HEADER FIELD, WRITES HEADING -----
 ;         
 ;     ASUUM = MENU NAME
 ;
 N Y K ASUK("HDG")
 S Y=$O(^DIC(9.4,"C","ASU",0))
 I Y S (ASUU(1),ASUK("HDG","VER"))=$P(^DIC(9.4,Y,"VERSION"),U)
 S (ASUU(2),ASUK("HDG","ARNM"))=$G(ASUL(1,"AR","NM")) I ASUK("HDG","ARNM")']"" D
 .D ^ASUVAR Q:$D(DTOUT)  Q:$D(DUOUT)  S (ASUU(2),ASUK("HDG","ARNM"))=ASUL(1,"AR","NM")
 S (ASUU(3),ASUK("HDG","STNM"))=$G(ASUL(2,"STA","NM"))
 S Y=$P(^VA(200,DUZ,0),U)
 S (ASUU(4),ASUK("HDG","USER"))=$P($P(Y,",",2)," ")_" "_$P(Y,",")
 S (ASUU(5),ASUK("HDG","MENU"))=ASUUM
 W @IOF
 D WRITE^ASUUHDG("HDG",1,.ASUU)
 K ASUU Q
WRITE(ASUUTXT,ASUUCTR,ASUU)       ;EP ;
 ; ----- WRITES THE TEXT STRING -----
 ;
 ;     ASUUTXT = TEXT STRINGS
 ;     ASUUCTR = CENTERING 0=NO CENTER, 1=CENTER
 ;     ASUU    = ARRAY CONTAINING HEADER 'FILL IN BLANK' INFO
 ;
 I $G(ASUF("WARN"))']"" W !,"*************** WARNING: UNAUTHORIZED USE IS A FEDERAL CRIME ****************",! S ASUF("WARN")=1
 F ASUUI=1:1 Q:$P($T(@ASUUTXT+ASUUI),";",3)["$$END"  D
 . S ASUUX=$P($T(@ASUUTXT+ASUUI),";",3)
 . W !?$S(ASUUCTR:(IOM-$L($$STR^ASUUHDG(ASUUX,.ASUU)))\2,1:0),$$STR^ASUUHDG(ASUUX,.ASUU)
 Q
SETT ;EP;
 N X
 I $D(XQY0) S X=$P(XQY0,U,2)
 E  D
 .S X=$G(ASUL(11,"TRN","NAME")),Y="" D LOWCASE(.X,.Y) S X=$G(ASUL(11,"TRN","CDE"))_" - "_Y
 S Y="********** Entering "_X_" Records **********"
 Q
LOWCASE(X,Y) ;
 N Z F Z=1:1 S Z(1)=$P(X," ",Z) Q:Z(1)']""  D
 .S Z(2)=$E(Z(1),2,$L(Z(1)))
 .S Z(3)=$TR(Z(2),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 .S:$L(Y)>0 Y=Y_" "
 .S Y=Y_$E(Z(1))_Z(3)
 Q
SETU ;EP;
 S ASUU(1)=ASUK("HDG","VER")
 S ASUU(2)=ASUK("HDG","ARNM")
 S ASUU(3)=ASUK("HDG","STNM")
 S ASUU(4)=ASUK("HDG","USER")
 S ASUU(5)="Entering "_$S($D(XQY0):$P(XQY0,U,2),1:$G(ASUL(11,"TRN","NM")))_" Records"
 D SETY(1,.ASUU)
 Q
SETY(X,ASUU) ;EP;
 S Y=$P($T(HDG+X),";",3)
 S Y=$$STR^ASUUHDG(Y,.ASUU)
 Q
 ;
PAWS ;EP ; ----- GIVE USER CHANCE TO ESCAPE -----
 Q:$E(IOST,1,2)'="C-"
 S DIR(0)="E" D ^DIR K DIR
 S ASUUOUT='Y
 Q
KILL ;EP ; ----- CLEAN UP VARIABLES -----
 K ASUU,ASUUCTR,ASUUI,ASUUTXT,ASUUX
 Q
STR(ASUUX,ASUU)    ;EP
 ; ----- EXTRINSIC FUNCTION TO CONVERT TEXT STRINGS -----
 ;
 ;     ASUU  = THE ARRAY CONTAINING 'FILL IN BLANK' INFO
 ;     ASUUX = THE TEXT STRING TO BE CONVERTED
 ;
 F  Q:ASUUX'["|"  D
 . S ASUUX=$P(ASUUX,"|")_$S(+$P(ASUUX,"|",2)'>0:"",'$D(ASUU(+$P(ASUUX,"|",2)))#2:"",1:ASUU(+$P(ASUUX,"|",2)))_$E(ASUUX,$F(ASUUX,"|")+2,256)
 Q ASUUX
 ;
CLS ;EP ;FORM FEED OR CLEAR SCREEN
 I $G(IOF)]"" D
 .W @(IOF)
 E  D
 .I $D(ASUK("PTR")) D
 ..I $D(ASUK(ASUK("PTR"),"IOF")) W @(ASUK(ASUK("PTR"),"IOF"))
 .E  D ^XBCLS
 Q
ACTXT ;EP ; ----- TEXT FOR FM ACCESS CODE WARNING MESSAGE -----
 ;;
 ;;          WARNING     WARNING     WARNING     WARNING     WARNING
 ;;
 ;;You do NOT have the correct FILE MANAGER ACCESS CODE to use SAMS.
 ;;Contact the SAMS Manager at the Area Office Immediately.  DO NOT use
 ;;SAMS until you have been assigned the proper FILE MANAGER ACCESS CODE.
 ;;$$END
RVTXT ;EP ; ----- TEXT FOR REVERSE VIDEO WARNING MESSAGE -----
 ;;
 ;;          WARNING     WARNING     WARNING     WARNING     WARNING
 ;;
 ;;Your DEVICE and/or TERMINAL TYPE are not properly defined to work with the SAMS
 ;;system.  The REVERSE VIDEO ON and/or REVERSE VIDEO OFF are not properly defined.
 ;;This is the responsibility of the AREA OFFICE computer site manager.
 ;;
 ;;Please contact this individual for assistance.  Let him/her know that you
 ;;are logged in on device NO.: |1|.
 ;;$$END
HDG ;EP ; ----- TEXT OF THE MENU HEADING -----    
 ;;************************ S **** A **** M **** S *********************
 ;;SUPPLY ACCOUNTING MANAGEMENT SYSTEM VER: |1|
 ;;AREA: |2| STATION: |3| USED BY: |4|
 ;;*********************************************************************
 ;;|5|
 ;;$$END
