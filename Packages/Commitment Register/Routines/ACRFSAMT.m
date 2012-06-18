ACRFSAMT ;IHS/OIRM/DSD/AEF - SEARCH FOR PAYMENT BY AMOUNT [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
 ;This routine will loop through the 1166 Approvals for Payment
 ;file ^AFSLAFP global and find batches containing the specified
 ;payment amount.  An optional date range can be included to narrow the 
 ;search.
 ;
 ;
EN ;----- MAIN ENTRY POINT
 ;
 N AMT,BEG,END
 D AMT(.AMT)
 Q:AMT=""
 D DATES(.BEG,.END)
 Q:'$G(BEG)
 Q:'$G(END)
 D SEARCH(AMT,BEG,END)
 Q
AMT(AMT) ;----- PROMPT FOR DOLLAR AMOUNT
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S AMT=""
 S DIR(0)="N^::2"
 S DIR("A")="Enter DOLLAR AMOUNT"
 D ^DIR
 Q:Y["^"
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 S AMT=Y
 S AMT=$J(AMT,$L(AMT),2)
 Q
DATES(BEG,END)     ;
 ;----- PROMPT FOR BEGINNING AND ENDING DATES
 ;
D ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 K BEG,END
 S DIR(0)="D^::E"
 S DIR("A")="Enter BEGINNING DATE"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 S BEG=Y
 S DIR("A")="Enter ENDING DATE"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 S END=Y
 I END<BEG D  G D
 . W !?5,"ENDING DATE cannot be less than BEGINNING DATE",!
 Q
SEARCH(AMT,BEG,END)          ;
 ;----- SEARCH AFSLAFP GLOBAL BY EXPORT DATE AND AMOUNT
 ;
 I BEG="" S BEG=0
 I END="" S END=9999999
 F X=BEG:1:END D EXP(X,AMT)
 Q
EXP(X,AMT)         ;
 ;----- SEARCH AFSLAFP GLOBAL
 ;
 S D0=0
 F  S D0=$O(^AFSLAFP("EXP",X,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AFSLAFP("EXP",X,D0,D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^AFSLAFP(D0,1,D1,1,D2)) Q:'D2  D
 . . . S DOL=$P($G(^AFSLAFP(D0,1,D1,1,D2,0)),U,11)
 . . . I +DOL=+AMT D DISP(D0,D1,D2)
 Q
DISP(D0,D1,D2)     ;
 ;----- DISPLAY DATA
 ;
 S BATCH=$P($G(^AFSLAFP(D0,1,D1,0)),U)
 S SCHNO=$P($G(^AFSLAFP(D0,1,D1,2)),U,6)
 S CERT=$P($G(^AFSLAFP(D0,1,D1,0)),U,5)
 S CERT=$E(CERT,4,5)_"/"_$E(CERT,6,7)_"/"_$E(CERT,2,3)
 S EXP=$P($G(^AFSLAFP(D0,1,D1,2)),U)
 S EXP=$E(EXP,4,5)_"/"_$E(EXP,6,7)_"/"_$E(EXP,2,3)
 S AMT=$P($G(^AFSLAFP(D0,1,D1,1,D2,0)),U,11)
 S AMT=$J(AMT,$L(AMT),2)
 W !
 W EXP
 W ?10,AMT
 W ?30,BATCH
 W ?40,SCHNO
 W ?55,CERT
 W ?65,EXP
 Q
