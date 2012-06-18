AQAOPV23 ; IHS/ORDC/LJF - PRINT QI CODES BY CLASS/TYPE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine prints listing of CHS or IHS providers by CHS provider
 ;type or IHS provider class.
 ;Routine added with Version 1.01
 ;
 ;-- Logic Flow:
 ;    ASK to ask user which groups to include (chs or ihs providers)
 ;    DEV to select print device
 ;    PRINT checks groups selected:
 ;      if ihs provider selected:
 ;         use PERSON^AQAOPV21 to print by class
 ;      if chs provider selected:
 ;         use VENDOR^AQAOPV21 to print by type
 ;    EXIT to clean up and quit
 ;
 D BYCLASS^AQAOHPRV ;intro text
 ;
ASK ; -- ask for groups to include
 K DIR W !! S DIR(0)="NO^1:2"
 S DIR("A")="Select Which Group you want in report"
 S DIR("A",1)="   1. IHS Providers by CLASS"
 S DIR("A",2)="   2. CHS Providers by Type"
 S DIR("A",3)=" "
 D ^DIR I $D(DIRUT) D EXIT Q
 S AQAOSEL=Y
 ;
WHICH ; -- which class or types or all
 K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to print for ALL "_$S(AQAOSEL=1:"Classes",1:"Types")
 D ^DIR I $D(DIRUT) D ASK Q
 I Y=1 S AQAOSEL1="ALL" D DEV Q
 ;
 K DIC S DIC(0)="AEMQZ",DIC=$S(AQAOSEL=1:7,1:9999999.34)
 S DIC("A")="Which "_$S(AQAOSEL=1:"CLASS",1:"TYPE")_"?  "
 D ^DIC I Y<1 D WHICH Q
 S AQAOSEL1=$P(Y,U,2)
 ;
 ;
DEV ; -- SUBRTN to get print device and call print rtn
 W !! S %ZIS="QP" D ^%ZIS
 I POP D EXIT Q
 I '$D(IO("Q")) D PRINT Q
 K IO("Q") S ZTRTN="PRINT^AQAOPV23",ZTDESC="QI CODES BY NUMBER"
 F I="AQAOSEL","AQAOSEL1" S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 D PRTOPT^AQAOVAR D EXIT Q
 ;
 ;
EXIT ; -- SUBRTN for eoj
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR ;ask to  hit return
 K ^TMP("AQAOPV23",$J)
 D ^%ZISC K AQAOSEL D KILL^AQAOUTIL Q
 ;
 ;
PRINT ;EP; -- check user selections and call proper subrtn
 U IO K ^TMP("AQAOPV23",$J)
 D INIT^AQAOUTIL S AQAOHCON="Provider"
 S AQAOTY="QI CODES BY "_$S(AQAOSEL=1:"CLASS",1:"TYPE")
 ;
 I AQAOSEL=1 D PERSON
 I AQAOSEL=2 D VENDOR
 D EXIT
 Q
 ;
 ;
PERSON ; -- SUBRTN to print ihs provider data
 NEW AQAOC,AQAOX,AQAOY,X,Y
 S AQAON=0
 F  S AQAON=$O(^VA(200,"AK.PROVIDER",AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 . S AQAOX=0
 . F  S AQAOX=$O(^VA(200,"AK.PROVIDER",AQAON,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 .. Q:'$D(^VA(200,AQAOX,0))
 .. I $P($G(^VA(200,AQAOX,"PS")),U,4)]"",$P(^("PS"),U,4)'>DT Q  ;inact
 .. S X=$$VAL^XBDIQ1(200,AQAOX,53.5) S:X="" X="UNKNOWN"
 .. I AQAOSEL1'="ALL",X'=AQAOSEL1 Q  ;not for class selected
 .. S ^TMP("AQAOPV23",$J,"IHS "_X,AQAON,AQAOX)=""
 ;
 S AQAOC=0
 F  S AQAOC=$O(^TMP("AQAOPV23",$J,AQAOC)) Q:AQAOC=""  Q:AQAOSTOP=U  D
 . D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 . S AQAOY=0
 . F  S AQAOY=$O(^TMP("AQAOPV23",$J,AQAOC,AQAOY)) Q:AQAOY=""  Q:AQAOSTOP=U  D
 .. S AQAOX=""
 .. F  S AQAOX=$O(^TMP("AQAOPV23",$J,AQAOC,AQAOY,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 ... I $Y>(IOSL-3) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 ... D PERSON^AQAOPV21("I",AQAOX)
 Q
 ;
VENDOR ; -- SUBRTN to print chs provider data
 NEW AQAOT,AQAOX,AQAOY,X,Y
 S AQAOX=0
 F  S AQAOX=$O(^AUTTVNDR(AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 . Q:'$D(^AUTTVNDR(AQAOX,0))
 . Q:$$VALI^XBDIQ1(9999999.11,AQAOX,.05)  ;screen out inactives
 . S X=$$VALI^XBDIQ1(9999999.11,AQAOX,1103) Q:X=""  ;needs vendor type
 . I AQAOSEL1'="ALL",X'=AQAOSEL1 Q  ;not for type selected
 . S X=$$VAL^XBDIQ1(9999999.34,X,.02)
 . S Y=$$VAL^XBDIQ1(9999999.11,AQAOX,.01)
 . S ^TMP("AQAOPV23",$J,"CHS "_X,Y,AQAOX)=""
 ;
 S AQAOT=0
 F  S AQAOT=$O(^TMP("AQAOPV23",$J,AQAOT)) Q:AQAOT=""  Q:AQAOSTOP=U  D
 . D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 . S AQAOY=0
 . F  S AQAOY=$O(^TMP("AQAOPV23",$J,AQAOT,AQAOY)) Q:AQAOY=""  Q:AQAOSTOP=U  D
 .. S AQAOX=0
 .. F  S AQAOX=$O(^TMP("AQAOPV23",$J,AQAOT,AQAOY,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 ... I $Y>(IOSL-3) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 ... D VENDOR^AQAOPV21("C",AQAOX)
 Q
 ;
 ;
 ;
HEADING2 ; -- SUBRTN to print second half of heading
 D HEADING2^AQAOPV21 Q
