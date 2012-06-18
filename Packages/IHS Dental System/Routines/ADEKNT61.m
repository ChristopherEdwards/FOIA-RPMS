ADEKNT61 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
ASKFY() ;EP
 ;Displays FY periods for which objectives data
 ;have already been compiled in ^ADEKNT
 ;Asks for FISCAL YEAR YYYY
 ;Default is most recent FY
 ;Returns YYYY.Q where Q is always 3
 ;Returns 0 if no valid YYYY entered or hatout
 ;
 N ADEY,ADEQ,ADEYQ,ADESET,ADECNT,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 S ADEYQ=0
 F  S ADEYQ=$O(^ADEKNT("AD",ADEYQ)) Q:ADEYQ=""  D
 . Q:$P(ADEYQ,".",2)'=3
 . S ADEYQ=$P(ADEYQ,".",1,2)
 . S ADEYQ(ADEYQ)=""
 . S $P(ADEYQ,".",3)=99999
 ;
DIR ;
 ;beginning Y2K fix
 ;S DIR(0)="F^2:4"
 S DIR(0)="F^4:4"
 ;end Y2K fix block
 S DIR("A")="Select FISCAL YEAR"
 S DIR("A",1)="A mail message may be created containing dental statistics"
 S DIR("A",2)="for one of the Fiscal years listed above."
 ;beginning Y2K fix
 ;S DIR("?")="Enter the Fiscal Year (or '^' to exit)"
 S DIR("?")="Enter the Fiscal Year as YYYY (or '^' to exit)"  ;Y2000
 ;end Y2K fix block
 I '$O(ADEYQ(0)) W !,"No prior Fiscal year statistics are on file on this computer." Q 0
 E   S ADEYQ=0 W !!!,"Statistics have been compiled for the following Fiscal years:" F  S ADEYQ=$O(ADEYQ(ADEYQ)) Q:'ADEYQ  D
 . W !,?5,$P(ADEYQ,".")
 D ^DIR
 I $$HAT^ADEPQA Q 0
 ;beginning Y2K fix
 ;I X'?1.4N W *7," ??" G DIR
 I X'?4N W *7," "_DIR("?") G DIR  ;Y2000
 ;S ADEY=$P(X,".")
 ;I $L(ADEY)>2 S ADEY=$E(ADEY,$L(ADEY)-1,$L(ADEY))
 ;I ADEY<80 W *7,!," Must be 1980 or later." G DIR
 S ADEY=X
 I ADEY<1980 W *7,!," Must be 1980 or later." G DIR  ;Y2000
 ;end Y2K fix block
 S ADEQ=3
 I ADEY_"."_ADEQ>$$QTR^ADEKNT5(DT) W *7,!," You must select a prior Fiscal year." G DIR
 S ADEYQ=ADEY_".3"
 I '$D(ADEYQ(ADEYQ)) W !,"No statistics for FY"_ADEY_" have been compiled on this computer. " G DIR
 Q ADEYQ
