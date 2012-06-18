ANSUCK ;IHS/OIRM/DSD/CSC - UTILITY TO CHECK ADMISSION; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;UTILITY TO CHECK ADMISSION
ANEW S L=0,N=$O(^ANSR("AA",ANSDFN,0)),H=DT_".9"
 I N S N=$O(^ANSR("AA",ANSDFN,N,0)) D DC
 I X'>L W !!,"  Can't Be Prior To The Last Discharge." G NO
 I X>H W !!,"  Can't Be Greater Than Today." G NO
 G OK
AOLD S L=0,H=$O(^ANSR(A,"AT",0)),D=9999998-^ANSR(A,0)
 I 'H S H=DT_".9"
A1 S D=$O(^ANSR("AA",ANSDFN,D)),N=0 G A3:D=""
 S N=""
A2 S N=$O(^ANSR("AA",ANSDFN,D,N)) G A1:N="",A1:N=A
A3 D DC
 I X'>L W !!,"  Must Be After The Prior Discharge." G NO
 I X>H W !!,"  Must Be Before The Date Of The First Care Level Record." G NO
 G OK
DNEW S H=DT_".9",L=0 D LI
 I X<L W !!," Can't Be Prior To The Date Of The Last Care Level Record." G NO
 I X>H W *7,"  Can't Be Greater Than Today." G NO
 G OK
DOLD D LI S H=DT_"."_9,P=0
 G D3:'$D(^ANSR(A,0)) S C=9999999-^(0),N=0,D=0
D1 S D=$O(^ANSR("AA",ANSDFN,D)) G D3:D="",D3:D>C
 S N=0
D2 S N=$O(^ANSR("AA",ANSDFN,D,N)) G D1:N="",D1:N=A
 S P=N
 G D2
D3 I P,$D(^ANSR(P,0)) S H=$P(^ANSR(P,0),U)_"."_$P(^ANSR(P,0),U,2)
 I X<L W !!,"  Can't Be Less Than The Date Of The Last Care Level Record." G NO
 I X'<H W !!,"  Can't Be After The Next Admission." G NO
 G OK
NO K Y
 W *7
 D PAUSE^ANSDIC
OK Q
DC I N,$D(^ANSR(N,"DX")) S N=$P(^ANSR(N,"DX"),U,5) I N,$D(^ANSR(N,0)) S L=$P(^ANSR(N,0),U)_"."_$P(^ANSR(N,0),U,2)
 Q
LI I $D(^ANSR(A,0)) S L=$P(^ANSR(A,0),U)_"."_$P(^ANSR(A,0),U,2)
 S N="" F I=1:1 S N=$O(^ANSR(A,"AT",N)) Q:N=""  S L=N
 Q
