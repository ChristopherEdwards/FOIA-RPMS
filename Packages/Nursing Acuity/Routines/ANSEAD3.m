ANSEAD3 ;IHS/OIRM/DSD/CSC - ENTER/EDIT ADMISSIONS/DISCHARGES; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ADD/EDIT ADMISSIONS & DISCHARGES
 D HEAD
 S X=$P(^DPT(ANSDFN,0),U)
 W !!,$P(X,","),", ",$P(X,",",2,99)
 I ANSSITE,$D(^AUPNPAT(ANSDFN,41,ANSSITE,0)) S X=$P(^(0),U,2) I X]"" W "   (",X,")"
 D DISP
A1 S DIR(0)="YO",DIR("A")="DELETE the Entire Admission",DIR("B")="NO",DIR("?")="You may delete this admission and all of it's associated data."
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I Y'=1 D B0 Q
 W *7
A2 S DIR(0)="YO",DIR("A",1)="This Admission and all of the associated Acuity data will be deleted.",DIR("A")="Are You certain you want to do this",DIR("B")="YES"
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)!($G(Y)'=1)
 W !!,"Standby..."
 D DEL
 W:$X>60 !
 W "   Done."
 Q
B0 S (L,D)=0,N="" ;CSC 12/19/96 (N="")
 ;I $D(^ANSR("PT",ANSDFN,ANSDA)) G ^ANSEAD1
 Q:$D(^ANSR("PT",ANSDFN,ANSDA))
 S D=9999999-^ANSR(ANSDA,0)
B1 F  S N=$O(^ANSR("AA",ANSDFN,D,N)) Q:N=""  S L=N
 Q:L'=ANSDA
B2 S DIR(0)="YO",DIR("A")="Delete The Discharge",DIR("B")="NO"
 S DIR("?",1)="Because this is the last Admission, you may choose to delete",DIR("?",1)="the Dischage and thus make the Admission 'CURRENT' again."
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 Q:Y'=1
 S (X,D)=""
 S X=$P($D(^ANSR(ANSDA,"DX")),U,5)
 I X,$D(^ANSR(X,0)) S D=+^(0),S=$P(^(0),U,2)
 I 'D W *7,!!,"Unable to delete Discharge." H 3 Q
 S ^ANSR("PT",ANSDFN,ANSDA)=""
 S DA=X,DIK="^ANSR("
 I ANSDA'=X D DIK^ANSDIC K ^ANSR(ANSDA,"AT",D_"."_S,X)
 S:ANSDA=X $P(^ANSR(X,0),U,5)="A"
 S $P(^ANSR(ANSDA,"DX"),U,5)=""
 W !!,"Deleted."
 Q
DEL S (A,C)=0
 F  S A=$O(^ANSR(ANSDA,"AT",A)) Q:A=""  D
 .S B=0
 .S B=$O(^ANSR(ANSDA,"AT",A,B)) Q:B=""  D:$D(^ANSR(B,0))
 ..S X=^ANSR(B,0),C=C+1,D=+X
 ..S DA=B,DIK="^ANSR("
 ..D DIK^ANSDIC
 I $D(^ANSR("PT",ANSDFN,ANSDA)) K ^(ANSDA)
 S D=0
 I $D(^ANSR(ANSDA,0)) S DA=ANSDA,DIK="^ANSR(" D DIK^ANSDIC
 Q
DAT S Y=""
 Q:X'?7N
 S Y=$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",+$E(X,4,5))_" "_($E(X,6,7))_", "_($E(X,1,3)+1700)
 Q
HEAD W @IOF
 S X=$P(ANSPAR,U,2)
 W ?80-$L(X)\2,X,!,?28,"ADMIT/DISCHARGE PATIENTS",!!
 Q
DISP Q:'$D(^ANSR(ANSDA,0))
 S A=^ANSR(ANSDA,0),B=$G(^("DX"))
 S Y=$P(A,U)
 Q:'Y
 X ^DD("DD")
 W !!,"Admitted On"," ",Y
 S X=$P(B,U,5)
 I 'X W "    (Active Inpatient)" Q
 I $D(^ANSR(X,0)) S X=$P(^(0),U) I Y D
 .X ^DD("DD")
 .W "    Discharged On ",Y
 Q
