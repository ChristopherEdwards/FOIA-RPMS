AQAOPV22 ; IHS/ORDC/LJF - PRINT QI CODES BY NUMBER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine prints listing of providers, persons, and/or vendors
 ;in order by QI code number.
 ;Routine added with Enhancement #1
 ;
 ;-- Logic Flow:
 ;    ASK to ask user which groups to include (prov, pers, +/or vend)
 ;    DEV to select print device
 ;    PRINT checks groups selected:
 ;      if ihs provider or employee selected:
 ;         use PERSON^AQAOPV21 to print data for providers/persons
 ;      if chs provider selected:
 ;         use VENDOR^AQAOPV21 to print data for chs vendors
 ;    EXIT to clean up and quit
 ;
 D BYNUM2^AQAOHPRV ;intro text
 ;
ASK ; -- ask for groups to include
 K DIR W !! S DIR(0)="LO^1:3"
 S DIR("A")="Select ALL groups you want in report"
 S DIR("A",1)="   1. Include IHS PROVIDERS"
 S DIR("A",2)="   2. Include IHS EMPLOYEES"
 S DIR("A",3)="   3. Include CHS PROVIDERS"
 S DIR("A",4)=" "
 D ^DIR I $D(DIRUT) D EXIT Q
 S AQAOSEL=Y
 ;
 ;
DEV ; -- SUBRTN to get print device and call print rtn
 W !! S %ZIS="QP" D ^%ZIS
 I POP D EXIT Q
 I '$D(IO("Q")) D PRINT Q
 K IO("Q") S ZTRTN="PRINT^AQAOPV22",ZTDESC="QI CODES BY NUMBER"
 S ZTSAVE("AQAOSEL")="" D ^%ZTLOAD K ZTSK D ^%ZISC
 D PRTOPT^AQAOVAR D EXIT Q
 ;
 ;
EXIT ; -- SUBRTN for eoj
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR ;ask to  hit return
 D ^%ZISC D KILL^AQAOUTIL Q
 ;
 ;
PRINT ;EP; -- check user selections and call proper subrtn
 U IO D INIT^AQAOUTIL S AQAOHCON="Provider"
 S AQAOTY="QI CODES BY NUMBER"
 D HEADING^AQAOUTIL,HEADING2
 ;
 I AQAOSEL[3 D VENDOR
 I (AQAOSEL[1)!(AQAOSEL[2) D PERSON
 D EXIT
 Q
 ;
 ;
PERSON ; -- SUBRTN to print provider/person data
 NEW AQAO,AQAOX S AQAOX=0
 F  S AQAOX=$O(^VA(200,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 . Q:'$D(^VA(200,AQAOX,0))
 . I (AQAOSEL[1),(AQAOSEL'[2) Q:'$D(^XUSEC("PROVIDER",AQAOX))
 . I $Y>(IOSL-3) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 . D PERSON^AQAOPV21("I",AQAOX)
 Q
 ;
VENDOR ; -- SUBRTN to print chs provider data
 NEW AQAO,AQAOX S AQAOX=0
 F  S AQAOX=$O(^AUTTVNDR(AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 . Q:'$D(^AUTTVNDR(AQAOX,0))
 . Q:$$VALI^XBDIQ1(9999999.11,AQAOX,.05)  ;screen out inactives
 . Q:$$VALI^XBDIQ1(9999999.11,AQAOX,1103)=""  ;needs vendor type
 . I $Y>(IOSL-3) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 . D VENDOR^AQAOPV21("C",AQAOX)
 Q
 ;
 ;
 ;
HEADING2 ; -- SUBRTN to print second half of heading
 D HEADING2^AQAOPV21 Q
