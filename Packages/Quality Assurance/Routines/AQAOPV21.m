AQAOPV21 ; IHS/ORDC/LJF - PRINT QI CODES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine lets a user select providers/persons/vendors to match
 ;the names with their corresponding QI code.
 ; Routine added with Enhancement #1
 ;
 ;-- Logic Flow:
 ;    LOOP until user finishes with selection
 ;      calls LOOKUP to dic call to appropriate file
 ;    DEV to select print device
 ;    PRINT loops thru selections
 ;      use PERSON to print data for providers/persons
 ;      use VENDOR to print data for chs vendors
 ;    EXIT to clean up and quit
 ;
 D LOOKUP^AQAOHPRV ;intro text
 K AQAOARR ;make sure array is empty to start
 S AQAOX=0 ;flag for first time thru
 ;
LOOP ; -- ask for names or qi codes until user is done
 K DIR W !! S DIR(0)="FO^3:50^I (X'?1""I."".E),(X'?1""C."".E) K X"
 S DIR("A")="Select "_$S(AQAOX:"ANOTHER ",1:"")_"NAME or QI CODE"
 S DIR("A")=DIR("A")_" (eg.: I.SMITH or C.345)"
 S DIR("?")="Enter Provider/Employee Name or QI Code."
 S DIR("?",1)="Use 'I.' as the prefix for an IHS Provider or Employee."
 S DIR("?",2)="Use 'C.' as the prefix for a CHS Provider."
 S DIR("?",3)="Examples:"
 S DIR("?",4)="   I.SMITH for IHS provider Dr. Joe Smith."
 S DIR("?",5)="   I.234 for IHS provider/employee with QI code I234."
 S DIR("?",6)="   C.ABC DIAGNOSTIC SRV for CHS provider by that name."
 S DIR("?",7)="   C.567 for CHS provider with QI code C567."
 S DIR("?",8)=" "
 D ^DIR I $D(DIRUT) D DEV Q
 ;
 S S=$S(Y?1"I.".E:"",1:"I $P(^(0),Y,5)=""""") ;code for dic(s)
 I Y?1"I.".E D LOOKUP(200,S,Y) S AQAOX=1 D LOOP Q
 I Y?1"C.".E D LOOKUP(9999999.11,S,Y) S AQAOX=1 D LOOP Q
 ;
 ;
DEV ; -- SUBRTN to get print device and call print rtn
 I '$D(AQAOARR) D EXIT Q  ;no one selected
 W !! S %ZIS="QP" D ^%ZIS
 I POP D EXIT Q
 I '$D(IO("Q")) D PRINT Q
 K IO("Q") S ZTRTN="PRINT^AQAOPV21",ZTDESC="SINGLE QI CODES"
 S ZTSAVE("AQAOARR(")="" D ^%ZTLOAD K ZTSK D ^%ZISC
 D PRTOPT^AQAOVAR D EXIT Q
 ;
 ;
EXIT ; -- SUBRTN for eoj
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR ;ask to  hit return
 D ^%ZISC D KILL^AQAOUTIL Q
 ;
 ;
PRINT ;EP; -- loop thru user's selections
 U IO D INIT^AQAOUTIL S AQAOHCON="Provider"
 S AQAOTY="LISTING OF SELECTED QI CODES"
 D HEADING^AQAOUTIL,HEADING2
 ;
 F AQAOI="C","I" Q:AQAOSTOP=U  D
 . S AQAOX=0
 . F  S AQAOX=$O(AQAOARR(AQAOI,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 .. I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 .. S X=$S(AQAOI="I":"PERSON",1:"VENDOR")_"(AQAOI,AQAOX)" D @X
 D EXIT
 Q
 ;
 ;
PERSON(AQAOI,AQAOX) ;EP; -- SUBRTN to print provider/person data
 NEW AQAO
 D ENP^XBDIQ1(200,AQAOX,".01;8;53.5;9999999.039","AQAO(")
 W !?1,AQAOI,AQAOX
 W ?10,$E(AQAO(.01),1,25)
 I AQAO(53.5)]"" W ?40,"IHS ",$E(AQAO(53.5),1,20)
 E  W ?40,"IHS ",$E(AQAO(8),1,20)
 I AQAO(9999999.039)]"" W " (",AQAO(9999999.039),")"
 Q
 ;
 ;
VENDOR(AQAOI,AQAOX) ;EP; -- SUBRTN to print vendor data
 NEW AQAO
 D ENP^XBDIQ1(9999999.11,AQAOX,".01;1102.01","AQAO(")
 W !?1,AQAOI,AQAOX
 W ?10,$E(AQAO(.01),1,25),?40,"CHS "
 S X=$$VALI^XBDIQ1(9999999.11,AQAOX,1103) ;vendor type code
 I X W $E($$VAL^XBDIQ1(9999999.34,X,.02),1,25) ;vendor type name
 W:AQAO(1102.01)]"" " (",AQAO(1102.01),")"
 Q
 ;
 ;
HEADING2 ;EP; -- SUBRTN to print second half of heading
 W ?14,"(Please forward any INACTIVE NAMES to the proper dept.)"
 W !,AQAOLIN2,!,"QI Code",?10,"Name",?40,"Description"
 W !,AQAOLINE,! Q
 ;
 ;
LOOKUP(DIC,DICS,INPUT) ; -- SUBRTN to find prov/pers/vendr from user input
 NEW X,Y
 S DIC(0)="EQ",X=$P(INPUT,".",2) I +X S X="`"_X
 S:DICS]"" DIC("S")=DICS D ^DIC I Y=-1 W *7,"Try again",! Q
 S AQAOARR($E(INPUT,1),+Y)=""
 Q
