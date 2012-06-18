ABSPOS6J ; IHS/FCS/DRS - user screen subrous ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
HEADER ; protocol ABSP P1 HEADER ; edit header  (EV  "Edit view screen")
 ; first, ask "All users or just one user or one patient?"
 D FULL^VALM1
 N WHO,TIMEWIN,PAT,PATTIME,UPDFREQ,DIC,DA,Y,X,DTOUT,DUOUT
 W !
HDR1 S X=$$SET^ABSPOSU3("Display for  1:One user  or  2:All users  or  3:One patient? ","1",0,"H","1:One user;2:All users;3:One patient")
 W !
 I X<1 G HDR8A
 ; Note: one user / one patient combination is not implemented 
 ;  If you choose one patient, you get them all, regardless of user,
 ;  and the time window for weeding out old ones does not apply.
 I X=2 S WHO=0 G HDR3
 I X=3 S WHO=0 G HDRA ; and later come back to HDR88 or HDR8A
HDR2 ; just one user - which one?
 S DIC=200,DIC(0)="AEMNQZ",DIC("A")="Select POS user: "
 S DIC("B")=$P(^VA(200,DUZ,0),U)
 ;S DIC("S")=screening, with Y=IEN, ^VA(200,Y,0) in naked
 D ^DIC W ! G HDR8A:$G(DUOUT)!$G(DTOUT),HDR1:Y<1 S WHO=+Y
HDR3 ; time frame to keep patient on screen
 W !,"Enter the number of MINUTES, the length of time that",!
 W "completed transactions will be retained on the screen.",!
 S X=^TMP("ABSPOS",$J,"TIME"),X=$P(X,".",2),X=X_"000000" ; hhmmss0000
 S Y=$E(X,1,2)*60+$E(X,3,4)
 S X=$$FREETEXT^ABSPOSU2("Retention time:  ",Y,1,1,6) W !
 I X<1 G HDR8A
 I X'?1N.N!(X>1439) W " ??" G HDR3
 S TIMEWIN="."_$TR($J(X\60,2)," ","0")_$TR($J(X#60,2)," ","0")
HDR4 ; Frequency of updates in continuous update mode
 ; HDRA rejoins here
 S X=5 ; minimum allowed value for frequency
 W !,"Enter the number of SECONDS between updates when the display",!
 W "is in CONTINUOUS UPDATE MODE.",!
 S X=$$NUMERIC^ABSPOSU2("Seconds between updates: ",^TMP("ABSPOS",$J,"FREQ"),0,X,9999,0) W !
 I X'?1N.N G HDR8A
 S UPDFREQ=X
HDR8 S ^TMP("ABSPOS",$J,"USER")=WHO
 I TIMEWIN'=^("TIME") S ^("TIME")=TIMEWIN,^("LAST UPDATE")=""
 S ^TMP("ABSPOS",$J,"FREQ")=UPDFREQ
 S ^TMP("ABSPOS",$J,"PATIENT")=0
HDR88 W !,"Settings have been changed.",!
 ; at this point, shouldn't we wipe everything off and rebuild?
 N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A
 G HDR9
HDR8A W !,"No settings have been changed.",!
HDR9 W "Done",! H 2
 S VALMBCK="R"
 Q
HDRA ; display for which one patient?
 ; *ABSP*1.0T7*7* :
 ;    Want to do the lookup with DUZ(2)=0 so as to be able to
 ;    access all point of sale patients regardless of division.
 ;    SAC 2.3.1.4.1 says this is okay so long as we reset DUZ(2)
 ;    to its original value.
 N ABSPDUZ2 S ABSPDUZ2=+$G(DUZ(2)),DUZ(2)=0 ; ABSP*1.0T7*7
 S DIC=2,DIC(0)="AEMQZ",DIC("A")="Prescriptions for which patient? "
 S DIC("S")="I $D(^ABSPT(""AC"",Y))"
 D ^DIC W !
 S DUZ(2)=ABSPDUZ2 ; Restore original DUZ(2) ; ABSP*1.0T7*7
 G HDR9:$G(DUOUT)!$G(DTOUT),HDRA:(Y<1)  S PAT=+Y
 W !,"Enter the number of DAYS to go back to find"
 W !,"Point of Sale activity for ",$P(Y(0),U),"."
 W ! S X=^TMP("ABSPOS",$J,"PATIENT TIME")
 S X=$$NUMERIC^ABSPOSU2("Number of days:  ",X,1,1,365) W !
 I X<1 G HDRA
 S PATTIME=X
 S ^TMP("ABSPOS",$J,"PATIENT")=PAT,^("PATIENT TIME")=PATTIME
 S ^TMP("ABSPOS",$J,"USER")=0
 G HDR88
