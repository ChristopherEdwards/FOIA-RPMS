ASDUSR1 ; IHS/ADC/PDW/ENM - DISPLAY USER SETUP ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 S ASDQ=0
 D ASK I ASDQ D EXIT Q
 D DEV I ASDQ D EXIT Q
 I IOST["C-" D ^ASDUSL1,EXIT Q
 D DISP
 ;
EXIT ; -- eoj
 D ^%ZISC K ASDU,ASDQ,ASDLN Q
 ;
ASK ; -- ask for user name
 NEW DIC,X,Y
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Select SCHEDULING USER:  "
 S DIC("S")="I $P(^VA(200,+Y,0),U,3)]"""",$P(^(0),U,11)="""""
 D ^DIC I X=""!(X=U)!(Y<1) S ASDQ=1 Q
 S ASDU=Y
 Q
 ;
DEV ; -- ask for device
 S %ZIS="Q" D ^%ZIS I POP S ASDQ=1 Q
 I $D(IO("Q")) D  S ASDQ=1 Q
 . S ZTRTN="DISP^ASDUSR1",ZTDESC="DISPLAY SCHED USER"
 . S ZTSAVE("ASDU")=""
 . K IO("Q") D ^%ZTLOAD K ZTSK D HOME^%ZIS
 Q
 ;
DISP ;EP; -- display user data
 NEW ASDL
 K ^TMP("ASDUSL1",$J) S ASDLN=0
 S ASDL=$$PAD("Name:  "_$E($P(ASDU,U,2),1,20),25)
 S X=$$VAL^XBDIQ1(200,+ASDU,29)
 I X]"" S ASDL=ASDL_$$PAD("Service: "_$E(X,1,22),33)
 S X=$$VAL^XBDIQ1(200,+ASDU,.132)
 I X]"" S ASDL=ASDL_"Phone: "_$E(X,1,12)
 D SET(ASDL),SET(" ")
 D KEYS,OVERBK,ACCESS
 I IOST'["C-" D PRINT
 Q
 ;
KEYS ; -- display user's sd keys and descriptions
 NEW ASDX,ASDY
 S ASDX="SDZ"
 F  S ASDX=$O(^DIC(19.1,"B",ASDX)) Q:ASDX=""!($E(ASDX,1,2)'="SD")  D
 . Q:'$D(^XUSEC(ASDX,+ASDU))
 . S ASDY=$O(^DIC(19.1,"B",ASDX,0)) Q:ASDY=""
 . D SET($$SP(5)_$$VAL^XBDIQ1(19.1,ASDY,.02))
 I $D(^XUSEC("AGZDOG",+ASDU)) D
 . D SET($$SP(5)_"CAN ACCESS FULL REGISTRATION EDIT")
 Q
 ;
OVERBK ; -- display overbook level
 NEW ASDX
 I $D(^XUSEC("SDMOB",+ASDU)) D  Q
 . D SET($$SP(5)_"Has MASTER OVERBOOK in all clinics")
 I $D(^XUSEC("SDOB",+ASDU)) D
 . D SET($$SP(5)_"Has OVERBOOK access in all clinics")
 I $D(^SC("AIHSOV",+ASDU)) D
 . D SET($$SP(5)_"Has OVERBOOK access in these clinics:")
 S ASDX=0 F  S ASDX=$O(^SC("AIHSOV",+ASDU,ASDX)) Q:ASDX=""  D
 . D SET($$SP(10)_$$VAL^XBDIQ1(44,ASDX,.01)_$$MSTOV)
 Q
 ;
MSTOV() ; -- returns whether user has master ovbk in clinic
 NEW X
 S X=$P($G(^SC(ASDX,"IHS OB",+ASDU,0)),U,2)
 Q $S(X="M":"  (Master Overbook)",1:"")
 ;
ACCESS ; -- display access to restricted clinics
 NEW ASDX
 Q:'$D(^SC("AIHSPRIV",+ASDU))  D SET(" ")
 D SET($$SP(5)_"Has access to these RESTRICTED Clinics:")
 S ASDX=0 F  S ASDX=$O(^SC("AIHSPRIV",+ASDU,ASDX)) Q:ASDX=""  D
 . Q:$$VAL^XBDIQ1(44,ASDX,2500)'="YES"
 . S X=$$VALI^XBDIQ1(44,ASDX,2505) I X]"",X'>DT Q
 . D SET($$SP(10)_$$VAL^XBDIQ1(44,ASDX,.01))
 Q
 ;
PRINT ; -- print list if sent to a printer
 U IO NEW ASDL,ASDPG
 S (ASDPG,ASDL)=0 D HDR
 F  S ASDL=$O(^TMP("ASDUSL1",$J,ASDL)) Q:'ASDL  D
 . I $Y>(IOSL-3) D HDR
 . W !,^TMP("ASDUSL1",$J,ASDL,0)
 D EXIT
 Q
 ;
HDR ; -- header
 W:ASDPG>0 @IOF S ASDPG=ASDPG+1
 W !?30,"SCHEDULING USER SETUP",!
 Q
 ;
SET(DATA) ; -- sets ^tmp
 S ASDLN=ASDLN+1,^TMP("ASDUSL1",$J,ASDLN,0)=DATA
 S ^TMP("ASDUSL1",$J,"IDX",ASDLN,ASDLN)=""
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
