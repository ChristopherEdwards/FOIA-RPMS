ANSEAD ;IHS/OIRM/DSD/CSC - ENTER/EDIT ADMISSIONS/DISCHARGES; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
EN N A,B,C,D,H,I,F,L,N,M,P,S,X,Y,Z
 D EN1
EXIT K ANS,ANSD,ANSADM,ANSTYPE,ANSADMS,ANSDA,ANSDT,ANSU,ANSUN,ANSS,ANSSH
 K ANSR,ANSB,ANSDC,ANSDX,ANSX
 Q
EN1 K ANSDFN
 D HEAD,^ANSUPT
 Q:$D(DTOUT)!$D(DUOUT)!'$D(ANSDFN)
 S ANSADM=$O(^ANSR("PT",ANSDFN,0)),ANSTYPE="A",ANSDA=0
 D DISP
 I ANSADM="" D ADM I 1
 E  D DSCH
 Q
ADM S DIR(0)="YO",DIR("A")="Admit This Patient",DIR("B")="NO"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I Y'=1 D PRI Q
 D B1
 Q
DSCH S DIR(0)="YO",DIR("A")="Discharge This Patient",DIR("B")="NO"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I Y'=1 D EDIT Q
 S ANSTYPE="D"
 D B1
 Q
EDIT S DIR(0)="YO",DIR("A")="Edit This Admission",DIR("B")="NO"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I Y'=1 D PRI Q
 S ANSDA=ANSADM
 D B1
 Q
PRI S ANSD=$O(^ANSR("AA",ANSDFN,0))
 Q:ANSD=""
PRI1 S DIR(0)="YO",DIR("A")="Edit A Prior Admission",DIR("B")="NO"
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 Q:Y'=1
 D ^ANSUAD
 Q:$D(DTOUT)!$D(DUOUT)!'$D(ANSADM)
 S ANSDA=ANSADM
 D ^ANSEAD3
 Q
B1 D ^ANSEAD1
 Q
DAT S Y=""
 Q:X'?7N
 S Y=$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(X,4,5))_" "_($E(X,6,7))_", "_($E(X,1,3)+1700)
 Q
HEAD D ^ANSMENU
 S ANSX="ADMIT/DISCHARGE PATIENTS"
 W !!,?80-$L(ANSX)/2,ANSX
 Q
DISP I ANSADM D DISP1 Q
 W !!,"Not Currently An Inpatient"
 S D=$O(^ANSR("AA",ANSDFN,0))
 I D="" W "  (No Prior Admissions Recorded)" Q
 S L=0,X=""
 F I=1:1 S L=$O(^ANSR("AA",ANSDFN,D,L)) Q:L=""  S X=L
 S P=1
DISP1 I ANSADM S X=ANSADM,P=0
DISP2 Q:'$D(^ANSR(X,0))
 S A=^ANSR(X,0),B=$G(^("DX"))
 S Y=$P(A,U)
 Q:'Y
 X ^DD("DD")
 W !!,$S(P:"Last Admission",1:"Admitted On")," ",Y
 I P S X=$P(B,U,5) I X,$D(^ANSR(X,0)) S Y=$P(^(0),U) I Y X ^DD("DD") W "    Discharged On ",Y Q
 Q:P
DISP3 S Y=$P(B,U,2)
 Q:'Y
 Q:'$D(^ANSD(59.1,Y,0))
 W !!,"Current Location: ",$P(^ANSD(59.1,Y,0),U) S Y=$P(B,U,3)
 I Y,$D(^ANSD(59.1,Y,"R",Y,0)) W "   Rm ",$P(^(0),U) S Y=$P(B,U,4) I Y,$D(^("B",Y,0)) W "-",$P(^(0),U)
 S Y=$P(B,U)
 I Y]"" W !!,"Diagnosis: ",Y
 Q
