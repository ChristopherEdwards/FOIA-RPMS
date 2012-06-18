PSOCLO1 ;BHAM ISC/SAB - clozaril rx lockout routine ; 20 Apr 1999  10:50 AM
 ;;7.0;OUTPATIENT PHARMACY;**1,23,37**;DEC 1997
 ;Changes added 7-1-91 to get data for transmission to Sandoz data base
 ;External reference ^YSCL(603.01 supported by DBIA 2697
 ;External reference ^LAB(60 supported by DBIA 333
 ;External reference ^LR( supported by DBIA 844
 ;External reference ^PS(55 supported by DBIA 2228
 ;External reference ^PSDRUG( supported by DBIA 221
 N X,Y,%,%DT,ANQD,ANQRE,ANQNO,ANQT,DTOUT,DUOUT,DIR,DIRUT,OK
 I '$D(^PS(55,DFN,"SAND")) D  S VALMBCK="Q" Q
 .K DIR S DIR("A",1)="This patient has not been registered in the clozapine program."
 .S DIR(0)="E",DIR("A")="Press return to continue" D ^DIR K DIR S ANQX=1
 I $P(^PS(55,DFN,"SAND"),"^")="" D  S VALMBCK="Q" Q
 .K DIR S DIR("A",1)="This patient has no clozapine registration number."
 .S DIR(0)="E",DIR("A")="Press return to continue" D ^DIR K DIR S ANQX=1
 I $P(^PS(55,DFN,"SAND"),"^",2)="D" D  S VALMBCK="Q" Q
 .K DIR S DIR("A",1)="This patient has been discontinued from the clozapine treatment program and",DIR(0)="E"
 .S DIR("A")="must have a new registration number assigned" S ANQX=1
 .D ^DIR K DIR
 S CLOZPAT=$O(^YSCL(603.01,"C",PSODFN,0)) I CLOZPAT S CLOZPAT=$S($P($G(^YSCL(603.01,CLOZPAT,0)),"^",3)="B":1,1:0) G PTCHK
 D:CLOZPAT=""  S VALMBCK="Q" Q
 .K DIR S DIR("A",1)="This patient has not been registered in the clozapine program."
 .S DIR(0)="E",DIR("A")="Press return to continue" D ^DIR K DIR S ANQX=1
PTCHK I '$D(^DPT(DFN,"LR")) W !!,"*** No WBC or ANC values on file CANNOT fill ***",! S (ANQX,ANQRE)=1 G CLEAN
 K ANQRS,CNT
SETUP S CNT=0 F I=0:0 S I=$O(^PSDRUG(P(5),"CLOZ2",I)) Q:'I  S CNT=CNT+1
 I +CNT'=2 W !,"Invalid Number of Tests ("_+CNT_") entered.  Cannot dispense Clozapine Prescription.",!,"You must have TWO test identified for this drug." S (ANQX,ANQNO)=1 G CLEAN
 S ANQDAYS=6
 F I=0:0 S I=$O(^PSDRUG(P(5),"CLOZ2",I)) Q:'I  S ANQTST($P(^PSDRUG(P(5),"CLOZ2",I,0),"^",4))=^PSDRUG(P(5),"CLOZ2",I,0)
 F I=0:0 S I=$O(ANQTST(I)) Q:'I!($G(ANQX)&$D(ANQRS(2)))  D  G:$D(ANQNO) CLEAN
 .K ANQNO
 .S ANQTST=$P(ANQTST(I),"^"),ANQTSTSP=$P(ANQTST(I),"^",3),ANQTSTYP=$P(ANQTST(I),"^",4)
 .S LRDFN=$P(^DPT(DFN,"LR"),"^"),ANQTSTN=$P(^LAB(60,ANQTST,0),"^"),ANQLDN=^LAB(60,ANQTST,.2)
 .S %DT="",X="T-6" D ^%DT S ANQEDATE=Y X ^DD("DD") S ANQEDTR=Y S X="T-"_$S($G(CLOZPAT)=1:42,1:21) D ^%DT S ANQ21=9999999-Y
 .S ANQEDL=9999999-ANQEDATE,ANQINDIC=0,ANQB=0,ANQV="",ANQRE=1
 .F ANQJ1=0:0 S ANQB=$O(^LR(LRDFN,"CH",ANQB)) Q:ANQB=""  Q:ANQB>ANQEDL  D CHECK Q:$D(ANQNO)
 .I $D(ANQNO) Q
 .I ANQINDIC=0,ANQTSTYP=1 W !!,"*** No "_ANQV_"results for "_ANQTSTN_" in past "_ANQDAYS_" days CANNOT fill ***",! S ANQX=1,ANQRS(2)="" Q
 .;Q:ANQINDIC>1
 .;Check for three in a row
 .I ANQTSTYP=1 S ANQD(1)=ANQRSDT(1,"DT") S ANQB=$P(ANQB,".")
 .F ANQJ=2:0 S ANQB=$O(^LR(LRDFN,"CH",ANQB)) Q:'ANQB  Q:ANQB>ANQ21  I $D(^(ANQB,ANQLDN)) S X=$P(^(ANQLDN),"^") I +X,$P(^(0),"^",5)=ANQTSTSP,$P(^(0),"^",3) S ANQ(ANQJ)=X,ANQD(ANQJ)=ANQB Q:$G(ANQ(ANQJ-1))'<ANQ(ANQJ)  S ANQJ=ANQJ+1
 .S TST=$O(ANQ(""),-1),OK=0 D:ANQTSTYP=1 NUMD
 .I OK,$D(ANQ(2)),$D(ANQ(3)),(ANQ(2)-ANQ(1))+(ANQ(3)-ANQ(2))'<3!(ANQ(3)-ANQ(1))'<3 S ANQX=1 D
 ..;Fails 3 in a row decreasing WBC only
 ..W !,"*** Last Three WBC Tests were:",! F ANQJ=3,2,1 S ANQDT=9999999-ANQD(ANQJ)_"0000" W ?5,$E(ANQDT,4,5)_"/"_$E(ANQDT,6,7)_"/"_($E(ANQDT,1,3)+1700) W:ANQDT["." "@",$E(ANQDT,9,10),":",$E(ANQDT,11,12) W ?29,"Results: "_(ANQ(ANQJ)*1000),!
 ..W "Prescription Cannot be Filled",! S ANQRE=4
 .Q:ANQTSTYP=2
 .S TST=$G(ANQ(2))-ANQ(1) I TST'<3 S ANQX=1 W !,"A Repeat of the CBC/Differential is needed before dispensing!",! D
 ..S ANQDT=9999999-ANQD(2)_"0000" W "*** Previous WBC Test: "_$E(ANQDT,4,5)_"/"_$E(ANQDT,6,7)_"/"_($E(ANQDT,1,3)+1700) W:ANQDT["." "@",$E(ANQDT,9,10),":",$E(ANQDT,11,12) W "   Results: "_(ANQ(2)*1000),!
 .I $D(ANQ(2)),$D(ANQ(3)),(ANQ(2)-ANQ(1))+(ANQ(3)-ANQ(2))'<3!(ANQ(3)-ANQ(1))'<3 S ANQX=1 W !,"A Repeat of the CBC/Differential is needed before dispensing!",! D
 ..S ANQDT=9999999-ANQD(2)_"0000" W "*** Previous WBC Test: "_$E(ANQDT,4,5)_"/"_$E(ANQDT,6,7)_"/"_($E(ANQDT,1,3)+1700) W:ANQDT["." "@",$E(ANQDT,9,10),":",$E(ANQDT,11,12) W "   Results: "_(ANQ(2)*1000),!
 G CLEAN
CHECK K ANQD,NOANC I ANQTSTYP=1,$D(ANQRS(1)) Q
 I ANQTSTYP=2,$D(ANQRS(2)) Q
 S ANQV="" I '$D(^LR(LRDFN,"CH",ANQB,ANQLDN)) S ANQRE=1 Q
 I $P(^LR(LRDFN,"CH",ANQB,0),"^",5)'=ANQTSTSP S ANQRE=1 Q
 I '$P(^LR(LRDFN,"CH",ANQB,0),"^",3) S ANQV="VERIFIED ",ANQRE=2 Q
 I '$P(^LR(LRDFN,"CH",ANQB,ANQLDN),"^") Q
 W !,"*** Most recent "_$S(ANQTSTYP=1:ANQTSTN,1:"Absolute Neutrophil Count")_" performed on "
 S Y=$P(^LR(LRDFN,"CH",ANQB,0),"^") X ^DD("DD") W $P(Y,"@")
 I ANQTSTYP=2 D ANC G VALCK1
 W !,?5,"Results: "_($P(^LR(LRDFN,"CH",ANQB,ANQLDN),"^")*1000)
VALCK S ANQ(1)=$P(^LR(LRDFN,"CH",ANQB,ANQLDN),"^"),ANQD(1)=ANQB,PSOLR=ANQ(1),PSOLDT=$P(9999999-ANQB,".")
VALCK1 S ANQRS($S(ANQTSTYP=2:2,1:1))=ANQ(1),ANQRSDT($S(ANQTSTYP=2:2,1:1),"DT")=ANQB
 I $D(ANQRSDT(1,"DT")),$D(ANQRSDT(2,"DT")) D  I $G(NOANC) K NOANC Q  ;checks for WBC & ANC same day and time
 .I ANQRSDT(1,"DT")=ANQRSDT(2,"DT") Q
 .W !,"WBC and ANC test results are not the SAME DAY and TIME!  ANC ignored.",! K ANQRS(2) S NOANC=1
 I ANQ(1)<$S(ANQTSTYP=2:1.5,1:3) D  Q  ;ok
 .W !,"*** "_$S(ANQTSTYP=2:"ANC",1:"WBC")_" count less than "_$S(ANQTSTYP=2:1500,1:3000)_" Rx cannot be filled ***"
 .W !!,"Daily CBC/Differential including WBC and ANC is required until WBC is greater",!,"than 3000 and ANC is greater than 1500.  Patient should be monitored for signs",!,"of infection."
 .W "  Twice weekly CBC/Differential counts including WBC and ANC are",!,"required until the WBC is greater than 3500 and the ANC is greater than 1500",!,"with no signs of infection.",!
 .W !,"If WBC is less than 2000 or ANC is less than 1000 patient CANNOT",!,"be Restarted on Clozapine!",!
 .W !,"No Override Permitted!",! S (ANQX,ANQNO)=1
 .I ANQTSTYP=1,'$D(ANQRS(2)) S ANQRS(2)=""
 S:ANQTSTYP=1 ANQBC=ANQB,ANQLDA=ANQLDN I +$G(ANQRS(1))>3,+$G(ANQRS(1))'>3.5,+$G(ANQRS(2))>1.5 D  ;checks for previous result
 .S ANQB=ANQBC,ANQLDN=ANQLDA K ANQ(2),ANQ(3)
 .F ANQJ=2:0 S ANQB=$O(^LR(LRDFN,"CH",ANQB)) Q:'ANQB  Q:ANQB>ANQ21  I $D(^(ANQB,ANQLDN)) S X=$P(^(ANQLDN),"^") I +X,$P(^(0),"^",5)=ANQTSTSP,$P(^(0),"^",3) S ANQ(ANQJ)=X,ANQD(ANQJ)=ANQB Q:ANQ(ANQJ-1)'<ANQ(ANQJ)  S ANQJ=ANQJ+1 Q:ANQJ>3
 .D:$D(ANQ(2)) NUMD
 .I $D(ANQ(3)),ANQ(3)>ANQ(2),ANQ(2)>ANQ(1) S ANQLDN=ANQLDA,ANQB=ANQBC K ANQ(2),ANQ(3),ANQBC,ANQLDA Q
 .S OK=0 I $D(ANQ(2)) D CPRE
 .I OK,$D(ANQ(2)) S ANQDT=9999999-ANQD(2)_"0000" W !,"*** Previous WBC Test: "_$E(ANQDT,4,5)_"/"_$E(ANQDT,6,7)_"/"_($E(ANQDT,1,3)+1700) W:ANQDT["." "@",$E(ANQDT,9,10),":",$E(ANQDT,11,12) W "   Results: "_(ANQ(2)*1000)
 .S ANQB=ANQBC K ANQBC,ANQJ,ANQ(2),ANQ(3),ANQDT,ANQD(2),ANQD(3),ANQLDA
 .W !,"A CBC/Differential including WBC and ANC Must Be Ordered and Monitored on a",!,"Twice weekly basis until the WBC STABILIZES above 3500/mm and ANC above",!,"1500 (with no signs of infection).",! S ANQX=1,ANQRE=3
 S:ANQTSTYP=1 ANQINDIC=ANQ(1)'<5+1
 Q
CLEAN K ANQINDIC,ANQTST,ANQDAYS,ANQTSTN,ANQLDN,ANQEDL,ANQB,ANQEDATE,ANQEDTR,ANQTSTSP,ANQJ1,LRDFN,ANQV,ANQ,ANQD,ANQJ,ANQDT,ANQ21,CNT,OK,TST,ANQRSDT
 I $G(OR0),$G(ANQNO) K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR,DIRUT
 I $D(ANQRS(1)),ANQRS(1)<3.5,'$D(ANQRS(2)) S (ANQX,ANQNO)=1 W !,"WBC is less than 3500 without an ANC test.",!,"A repeat of the CBC/Differential including WBC and ANC are Required.",!,"No Override Permitted!" G EXIT
 K DIR,DIRUT I $D(ANQRS(1)),ANQRS(1)<5,ANQRS(1)>3.5,'$D(ANQRS(2)) S DIR("A",1)="***CBC Differential (including ANC) is Required***",ANQX=1
 I 'ANQX G DOSAGE
 I '$D(^XUSEC("PSOLOCKCLOZ",DUZ))!($D(ANQNO)) D  G EXIT
 .S ANQNO=1 W !,"You Are Not Authorized to Override! See Clozapine Manager with PSOLOCKCLOZ key."
OVRD ;
 S DIR("A")="Do you want to override and issue this prescription",DIR(0)="Y",DIR("B")="N" D ^DIR K DIR I 'Y!($D(DIRUT)) G EXIT
DOC S DIC=200,DIC(0)="AEQM",DIC("A")="Approving member of the Clozapine team: ",DIC("S")="I $D(^XUSEC(""PSOLOCKCLOZ"",+Y)),+Y'=DUZ" D ^DIC K DIC S ANQD=+Y I Y<0 S ANQX=1 W !!,"No Prescription entered!" G EXIT
COM S DIR(0)="52.52,5",DIR("A")="Remarks" S:$D(ANQREM) DIR("B")=ANQREM
 D ^DIR K DIR I $D(DIRUT) S ANQX=1 W !!,"No Prescription entered!" K ANQREM G EXIT
 S ANQX=0,ANQDATA=DUZ_"^"_ANQD_"^"_ANQRE_"^"_X,ANQREM=X
 ;
DOSAGE ; set variable to ask daily dose
 D DOSE^PSODRDUP
EXIT I $G(OR0)!$G(ANQNO) W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR
 K X,Y,%,%DT,ANQD,ANQRE,ANQNO,ANQT,DTOUT,DUOUT,DIR,DIRUT Q
CPRE ;finds previous
 S X1=$E((ANQ(2)-9999999),2,8),X2=$E((ANQ(1)-9999999),2,8) D ^%DTC I X'<1,X'>$S(CLOZPAT=1:27,1:13) S OK=1 Q
 S OK=0,TST=$O(ANQ(""),-1) Q:TST'>2
CPRE1 F J=3:1:TST S X1=$E((ANQ(J)-9999999),2,8),X2=DT D  Q:OK
 .D ^%DTC I X'<6,X'>$S(CLOZPAT=1:20,1:13) S OK=1,ANQ(2)=ANQ(J),ANQD(2)=ANQD(J)
 Q
NUMD ;finds last three
 S J=1
NUMD1 S J=J+1,OK=0 Q:J>TST!('$D(ANQD(J)))
 S X2=$E((ANQD(J)-9999999),2,8),X1=$E((ANQD(1)-9999999),2,8) D ^%DTC
 I X'<1,X'>$S(CLOZPAT=1:20,1:13) S OK=1,ANQ(2)=ANQ(J),ANQD(2)=ANQD(J)
 I 'OK G NUMD1
NUMD2 S J=J+1,OK=0 Q:J>TST!('$D(ANQD(J)))
 S X2=$E((ANQD(J)-9999999),2,8),X1=$E((ANQD(1)-9999999),2,8) D ^%DTC
 I X'<$S(CLOZPAT=1:21,1:13),X'>$S(CLOZPAT=1:34,1:20) S OK=1,ANQ(3)=ANQ(J),ANQD(3)=ANQD(J)
 I 'OK G NUMD2
 Q
ANC ;returns ANC results
 S ANQ(1)=(ANQRS(1)/100)*$P(^LR(LRDFN,"CH",ANQB,ANQLDN),"^")
 W !,?5,"Results: "_(ANQ(1)*1000) S ANQD(1)=ANQB,PSOLR=ANQ(1),PSOLDT=$P(9999999-ANQB,".")
 Q
