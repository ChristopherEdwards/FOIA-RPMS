ACDDE3A ;IHS/ADC/EDE/KML - DATA ENTRY/CHECK CONTACT TYPES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
CHKRE ; EP - CHECK REOPEN
 ; ADD MODE
 ; should have been a t/d/c, may have followups
 S ACDX="A",ACDQ=0
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX),-1) Q:ACDX=""  D  Q:ACDQ
 . Q:ACDX>ACDVDTI  ;       ignore later dates
 . S ACDY="A"
 . F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY),-1) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)="TD" S ACDQ=1 Q
 .. Q
 . Q:ACDQ
 . S ACDY="A"
 . F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY),-1) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)'="FU" S ACDQ=1 Q
 .. Q
 . Q
 S ACDQ=0
 I ACDY,$P(X,U,4)'="TD" W !,IORVON,"Last non-followup CDMIS VISIT for component ",ACDCOMCL,"/",ACDCOMTL,!,"on or prior to ",ACDVDTE," was not a TRANS/DISC/CLOSE.",IORVOFF,! D DSPVSIT^ACDDEU(ACDY) D  Q
 . S DIR(0)="Y",DIR("A")="Do you want to add this CDMIS VISIT anyway",DIR("B")="N" K DA D ^DIR K DIR
 . S:'Y ACDQ=1
 . Q
 S ACDFLG=0
 I ACDY S ACDX=ACDX-1 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX)) Q:ACDX=""  D  Q:ACDQ
 . S ACDY=+ACDY F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY)) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT D  Q
 ... I $P(X,U,4)="TD" S ACDFLG=1,ACDQ=1 Q
 ... I $P(X,U,4)="RE" S ACDFLG=2,ACDQ=1 Q
 ... Q
 .. Q
 . Q
 S ACDQ=0
 I ACDFLG W !,IORVON,"Subsequent ",$S(ACDFLG=1:"TRANS/DISC/CLOSE",1:"REOPEN")," CDMIS VISIT for component ",ACDCOMCL,"/",ACDCOMTL,!,"after ",ACDVDTE,".",IORVOFF,! D
 . D DSPHIST^ACDDEU
 . S DIR(0)="Y",DIR("A")="Do you want to add this CDMIS VISIT anyway",DIR("B")="N" K DA D ^DIR K DIR
 . S:'Y ACDQ=2
 . Q
 Q:ACDQ
 Q
 ;
CHKFU ; EP - CHECK FOLLOWUP
 ; ADD MODE
 ; should have been a t/d/c, may have followups
 S ACDX=""
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX),-1) Q:ACDX=""  D  Q:ACDQ
 . Q:ACDX>ACDVDTI  ;       ignore later dates
 . S ACDY="A"
 . F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY),-1) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)'="FU" S ACDQ=1 Q
 .. Q
 . Q
 S ACDQ=0
 I ACDY,$P(X,U,4)'="TD" W !,IORVON,"Last non-followup CDMIS VISIT for component ",ACDCOMCL,"/",ACDCOMTL,!,"was not a TRANS/DISC/CLOSE.",IORVOFF,! D DSPVSIT^ACDDEU(ACDY) D  Q
 . S DIR(0)="Y",DIR("A")="Do you want to add this CDMIS VISIT anyway",DIR("B")="N" K DA D ^DIR K DIR
 . S:'Y ACDQ=1
 . Q
 Q
 ;
CHKTD ; EP - CHECK TRANS/DISC/CLOSE
 ; ADD MODE
 ; should be initial or reopen with no t/d/c
 S ACDX="A"
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX),-1) Q:ACDX=""  D  Q:ACDQ
 . Q:ACDX>ACDVDTI  ;       ignore later dates
 . S ACDY="A"
 . F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY),-1) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,($P(X,U,4)="TD"!($P(X,U,4)="IN")!($P(X,U,4)="RE")) S ACDQ=1 Q
 .. Q
 . Q
 S ACDQ=0
 I 'ACDY W !,IORVON,"Impossible error in ADDTD^ACDDE.  Notify programmer.",IORVOFF,!! S ACDQ=1 S:$D(^%ZOSF("$ZE")) X="CDMIS VISIT",@^("$ZE") D @^%ZOSF("ERRTN") D PAUSE^ACDDEU Q  ;    should have been caught by CHKFIN
 I $P(X,U,4)="TD" W !,IORVON,"There is already a TRANS/DISC/CLOSE CDMIS VISIT for component",!,ACDCOMCL,"/",ACDCOMTL," on or before ",ACDVDTE,".",IORVOFF,! D DSPVSIT^ACDDEU(ACDY),PAUSE^ACDDEU S ACDQ=1 Q
 I ACDY S ACDX=ACDX-1 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX)) Q:ACDX=""  D  Q:ACDQ
 . S ACDY=+ACDY F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY)) Q:'ACDY  D  Q:ACDQ
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT D  Q
 ... I $P(X,U,4)="TD" S ACDQ=1 Q
 ... I $P(X,U,4)="RE" S ACDY=0,ACDQ=1 Q
 ... Q
 .. Q
 . Q
 S ACDQ=0
 I ACDY W !,IORVON,"Subsequent TRANS/DISC/CLOSE CDMIS VISIT for component ",ACDCOMCL,"/",ACDCOMTL,!,"after ",ACDVDTE,".",IORVOFF,! D
 . D DSPHIST^ACDDEU
 . S DIR(0)="Y",DIR("A")="Do you want to add this CDMIS VISIT anyway",DIR("B")="N" K DA D ^DIR K DIR
 . S:'Y ACDQ=2
 . Q
 Q:ACDQ
 Q
 ;
CHKCS ; EP - CHECK CLIENT SERVICE
 ; ADD MODE
 ; should be initial or reopen with no t/d/c
 S ACDX="A",ACDLI="",ACDLT=""
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX),-1) Q:ACDX=""  D  Q:ACDQ
 . Q:$E(ACDX,1,5)>$E(ACDVDTI,1,5)  ;       ignore later months
 . S ACDY="A"
 . F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY),-1) Q:'ACDY  D  I ACDLI]"",ACDLT]"" S ACDQ=1 Q
 .. S X=^ACDVIS(ACDY,0)
 .. I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT D  Q
 ... I $P(X,U,4)="TD" S ACDLT=ACDX Q
 ... I $P(X,U,4)="IN"!($P(X,U,4)="RE") S ACDLI=ACDX Q
 ... Q
 .. Q
 . Q
 S ACDQ=0
 I ACDLT>ACDLI,$E(ACDLT,1,5)<$E(ACDVDTI,1,5) W !,IORVON,"There is a TRANS/DISC/CLOSE CDMIS VISIT for component",!,ACDCOMCL,"/",ACDCOMTL," before ",ACDVDTE,".",IORVOFF,! D DSPVSIT^ACDDEU(ACDY),PAUSE^ACDDEU S ACDQ=1 Q
 ;I ACDLT>ACDLI W !,IORVON,"Not an open component.",IORVOFF S DIR(0)="Y",DIR("A")="Are you sure you want to add CS to this component",DIR("B")="Y" K DA D ^DIR K DIR I 'Y S ACDQ=1 Q
 Q
