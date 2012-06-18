ADEKNT4 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
ASKYQ() ;EP
 ;Displays periods for which objectives data
 ;have already been compiled in ^ADEKNT
 ;Asks for YEAR and QUARTER 
 ;beginning Y2K fix
 ;Default is most recent YYYY.Q
 ;Returns YYYY.Q
 ;Returns 0 if no valid YYYY.Q entered or hat out
 ;Prompts confirmation if a YYYY.Q is entered for
 ;which stats have already been compiled
 ;end Y2K fix block
 ;
 N ADEY,ADEQ,ADEYQ,ADESET,ADECNT,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 S ADEYQ=0
 F  S ADEYQ=$O(^ADEKNT("AD",ADEYQ)) Q:ADEYQ=""  D
 . S ADEYQ=$P(ADEYQ,".",1,2)
 . S ADEYQ(ADEYQ)=""
 . S $P(ADEYQ,".",3)=99999
 ;
DIR ;
 ;beginning Y2K fix
 ;S DIR(0)="F^4:6"
 S DIR(0)="F^6:6"  ;Y2000
 S DIR("A")="Enter YEAR.QUARTER"
 S DIR("A",1)="Enter the calendar year and quarter for which you wish to compile statistics"
 ;S DIR("A",2)="Using the format YY.Q where YY is the last 2 digits of the year"
 S DIR("A",2)="Using the format YYYY.Q where YYYY is the 4 digit year" ;Y2000
 ;S DIR("A",3)="and Q is the quarter of the year, e.g. 94.2 for the second quarter of 1994. "
 S DIR("A",3)="and Q is the quarter of the year, e.g. 1994.2 for the second quarter of 1994. "  ;Y2000
 S DIR("A",4)=" "
 ;S DIR("?")="Enter the Year and Quarter in the form YY.Q"
 S DIR("?")="Enter the Year and Quarter in the form YYYY.Q"  ;Y2000
 S DIR("B")=+$$QTR^ADEKNT5(DT)
 K:$D(ADEYQ(DIR("B"))) DIR("B")
 I '$O(ADEYQ(0)) W !,"No prior statistics are on file on this computer."
 E   S ADEYQ=0 W !!!,"Statistics have already been compiled for the following quarters:" F  S ADEYQ=$O(ADEYQ(ADEYQ)) Q:'ADEYQ  D
 . W !,?5,ADEYQ
 D ^DIR
 I $$HAT^ADEPQA Q 0
 ;I X'?1.4N1"."1N W *7," ??" G DIR
 I X'?4N1"."1N W *7," "_DIR("?") G DIR  ;Y2000
 S ADEY=$P(X,".")
 ;I $L(ADEY)>2 S ADEY=$E(ADEY,$L(ADEY)-1,$L(ADEY))
 ;I ADEY<80 W *7," Must be 1980 or later." G DIR
 I ADEY<1980 W *7," Must be 1980 or later." G DIR  ;Y2000
 ;end Y2K fix block
 S ADEQ=$P(X,".",2)
 I ADEQ<1!(ADEQ>4) W *7," Quarter must be 1, 2, 3 or 4." G DIR
 I ADEY_"."_ADEQ>$$QTR^ADEKNT5(DT) W *7," Must be "_+$$QTR^ADEKNT5(DT)_" or earlier." G DIR
 S ADEYQ=ADEY_"."_ADEQ
 I '$D(ADEYQ(ADEYQ)) Q ADEYQ
 K DIR
 S DIR(0)="YA",DIR("B")="NO"
 W !!,"Statistics have already been compiled for period "_ADEYQ
 S DIR("A")="Do you want to re-compile the statistics for this period? "
 D ^DIR
 G:'Y DIR
 Q ADEYQ
