BSDUSR ; IHS/ANMC/LJF - DISPLAY USER SETUP ;
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 11/22/2006 PATCH 1007 removed screen of terminated users in ASK for item 1007.31
 ;
ASK ; -- ask for user name
 NEW DIC,X,Y
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Select SCHEDULING USER:  "
 ;S DIC("S")="I $P(^VA(200,+Y,0),U,3)]"""",$P(^(0),U,11)="""""  ;cmi/anch/maw 11/22/06 orig line item 1007.31 patch 1007
 S DIC("S")="I $P(^VA(200,+Y,0),U,3)]"""""  ;cmi/anch/maw 11/22/06 modified line item 1007.31 patch 1007
 D ^DIC I (X="")!(X=U)!(Y<1) S BSDQ=1 D EXIT Q
 S BSDU=Y
 ;
DEV ; -- ask for device
 D ZIS^BDGF("QP","EN^BSDUSL","DISPLAY SCHED USER","BSDU")
 ;
EXIT ; -- eoj
 D ^%ZISC K BSDU,BSDQ,BSDLN Q
 ;
DISP ;EP; -- display user data
 NEW BSDL
 K ^TMP("BSDUSL",$J) S BSDLN=0
 S BSDL=$$PAD("Name:  "_$E($P(BSDU,U,2),1,20),25)
 S X=$$GET1^DIQ(200,+BSDU,29)
 I X]"" S BSDL=BSDL_$$PAD("Service: "_$E(X,1,22),33)
 S X=$$GET1^DIQ(200,+BSDU,.132)
 I X]"" S BSDL=BSDL_"Phone: "_$E(X,1,12)
 D SET(BSDL),SET(" ")
 D KEYS,OVERBK,ACCESS
 I IOST'["C-" D PRINT
 Q
 ;
KEYS ; -- display user's sd keys and descriptions
 NEW BSDX,BSDY
 D SET("User's Access based on Security Keys:")
 S BSDX="SDZ"
 F  S BSDX=$O(^DIC(19.1,"B",BSDX)) Q:(BSDX="")!($E(BSDX,1,2)'="SD")  D
 . Q:'$D(^XUSEC(BSDX,+BSDU))
 . S BSDY=$O(^DIC(19.1,"B",BSDX,0)) Q:BSDY=""
 . D SET($$SP(5)_$$GET1^DIQ(19.1,BSDY,.02))
 I $D(^XUSEC("AGZDOG",+BSDU)) D
 . D SET($$SP(5)_"CAN ACCESS FULL REGISTRATION EDIT")
 D SET("")
 Q
 ;
OVERBK ; -- display overbook level
 NEW BSDX
 I $D(^XUSEC("SDMOB",+BSDU)) D  Q
 . D SET($$SP(5)_"Has MASTER OVERBOOK in all clinics")
 I $D(^XUSEC("SDOB",+BSDU)) D
 . D SET($$SP(5)_"Has OVERBOOK access in all clinics")
 I $D(^BSDSC("AOV",+BSDU)) D
 . D SET($$SP(5)_"Has OVERBOOK access in these clinics:")
 S BSDX=0 F  S BSDX=$O(^BSDSC("AOV",+BSDU,BSDX)) Q:BSDX=""  D
 . D SET($$SP(10)_$$GET1^DIQ(44,BSDX,.01)_$$MSTOV)
 Q
 ;
MSTOV() ; -- returns whether user has master ovbk in clinic
 NEW X
 S X=$P($G(^BSDSC(BSDX,1,+BSDU,0)),U,2)
 Q $S(X="M":"  (Master Overbook)",1:"")
 ;
ACCESS ; -- display access to restricted clinics
 NEW BSDX
 Q:'$D(^SC("AIHSPRIV",+BSDU))  D SET(" ")
 D SET($$SP(5)_"Has access to these RESTRICTED Clinics:")
 S BSDX=0 F  S BSDX=$O(^SC("AIHSPRIV",+BSDU,BSDX)) Q:BSDX=""  D
 . Q:$$GET1^DIQ(44,BSDX,2500)'="YES"
 . S X=$$GET1^DIQ(44,BSDX,2505,"I") I X]"",X'>DT Q
 . D SET($$SP(10)_$$GET1^DIQ(44,BSDX,.01))
 Q
 ;
PRINT ; -- print list if sent to a printer
 U IO NEW BSDL,BSDPG
 S (BSDPG,BSDL)=0 D HDR
 F  S BSDL=$O(^TMP("BSDUSL",$J,BSDL)) Q:'BSDL  D
 . I $Y>(IOSL-3) D HDR
 . W !,^TMP("BSDUSL",$J,BSDL,0)
 D EXIT
 Q
 ;
HDR ; -- header
 W:BSDPG>0 @IOF S BSDPG=BSDPG+1
 W !?30,"SCHEDULING USER SETUP",!
 Q
 ;
SET(DATA) ; -- sets ^tmp
 S BSDLN=BSDLN+1,^TMP("BSDUSL",$J,BSDLN,0)=DATA
 S ^TMP("BSDUSL",$J,"IDX",BSDLN,BSDLN)=""
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
