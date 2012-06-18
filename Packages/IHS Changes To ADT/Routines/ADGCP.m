ADGCP ; IHS/ADC/PDW/ENM - provider conversion ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;   label V stuffs visit pointer in 405
 ;
A ; -- main       
 ;searhc/maw added this stuff
 W !!!,"Do not run this post init until you VERIFY COMPLETION ",!,"of the DGPM5 PARTS 1 & 2 Conversions...",!! ;IHS/DSD/ENM 03/06/99
 W *7,*7 H 3 W *7,*7 ;IHS/DSD/ENM 03/06/99
 S DIR(0)="Y",DIR("A")="Do you wish to continue "
 D ^DIR
 Q:$D(DIRUT)
 S YN=Y
 Q:Y<1
 ;
 ;searhc/maw end of added stuff
 ;
 W !!!,"Converting provider pointers to file 200..."
 D PM1,PM2,TS,HL,PT,IC,SV,DSIC,DS,V
 Q
 ;
IC ; -- incomplete chart
 W !!,"converting incomplete chart providers ...."
 N X,Y,Z,C,P,V S C=$P($G(^DG5(1,"IHS")),U,2) Q:C="C"
 K ^ADGIC("AC")
 S X=$S(C:C,1:0) F  S X=$O(^ADGIC(X)) Q:'X  D
 . S Y=0 F  S Y=$O(^ADGIC(X,"D",Y)) Q:'Y  D
 .. S Z=0 F  S Z=$O(^ADGIC(X,"D",Y,"P",Z)) Q:'Z  D
 ... S P=+$G(^ADGIC(X,"D",Y,"P",Z,0)) Q:'P
 ... S V=$G(^DIC(16,P,"A3")) Q:'V
 ... S $P(^ADGIC(X,"D",Y,"P",Z,0),U)=V
 ... K ^ADGIC(X,"D",Y,"P","B",P,Z)
 ... S ^ADGIC(X,"D",Y,"P","B",V,Z)=""
 ... S ^ADGIC("AC",V,X,Y,Z)=""
 ... S $P(^DG5(1,"IHS"),U,2)=X
 S $P(^DG5(1,"IHS"),U,2)="C"
 Q
 ;
DSIC ; -- day surgery incomplete chart
 W !!,"converting day surgery incomplete chart providers ...."
 N X,Y,Z,C,P,V S C=$P($G(^DG5(1,"IHS")),U,3) Q:C="C"
 K ^ADGDSI("AC")
 S X=$S(C:C,1:0) F  S X=$O(^ADGDSI(X)) Q:'X  D
 . S Y=0 F  S Y=$O(^ADGDSI(X,"DT",Y)) Q:'Y  D
 .. S Z=0 F  S Z=$O(^ADGDSI(X,"DT",Y,"P",Z)) Q:'Z  D
 ... S P=+$G(^ADGDSI(X,"DT",Y,"P",Z,0)) Q:'P
 ... S V=$G(^DIC(16,P,"A3")) Q:'V
 ... S $P(^ADGDSI(X,"DT",Y,"P",Z,0),U)=V
 ... K ^ADGDSI(X,"DT",Y,"P","B",P,Z)
 ... S ^ADGDSI(X,"DT",Y,"P","B",V,Z)=""
 ... S ^ADGDSI("AC",V,X,Y,Z)=""
 ... S $P(^DG5(1,"IHS"),U,3)=X
 S $P(^DG5(1,"IHS"),U,3)="C"
 Q
 ;
DS ; -- day surgery
 W !!,"converting day surgery providers ...."
 N X,Y,C,P,V S C=$P($G(^DG5(1,"IHS")),U,4) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^ADGDS(X)) Q:'X  D
 . S Y=0 F  S Y=$O(^ADGDS(X,"DS",Y)) Q:'Y  D
 .. S P=+$P($G(^ADGDS(X,"DS",Y,0)),U,6) Q:'P
 .. S V=$G(^DIC(16,P,"A3")) Q:'V
 .. S $P(^ADGDS(X,"DS",Y,0),U,6)=V
 .. S $P(^DG5(1,"IHS"),U,4)=X
 S $P(^DG5(1,"IHS"),U,4)="C"
 Q
 ;
SV ; -- scheduled visit
 W !!,"converting scheduled visit providers ...."
 N X,Y,C,P,V S C=$P($G(^DG5(1,"IHS")),U,5) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^ADGAUTH(X)) Q:'X  D
 . S Y=0 F  S Y=$O(^ADGAUTH(X,1,Y)) Q:'Y  D
 .. S P=+$P($G(^ADGAUTH(X,1,Y,0)),U,2) Q:'P
 .. S V=$G(^DIC(16,P,"A3")) Q:'V
 .. S $P(^ADGAUTH(X,1,Y,0),U,2)=V
 .. S $P(^DG5(1,"IHS"),U,5)=X
 S $P(^DG5(1,"IHS"),U,5)="C"
 Q
 ;
PM1 ; -- patient movement, primary care
 W !!,"converting patient movement admitting providers ...."
 N X,C,P,V S C=$P($G(^DG5(1,"IHS")),U,6) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^DGPM(X)) Q:'X  D
 . S P=+$P($G(^DGPM(X,0)),U,8) Q:'P
 . S V=$G(^DIC(16,P,"A3")) Q:'V
 . S $P(^DGPM(X,0),U,8)=V
 . S $P(^DG5(1,"IHS"),U,6)=X
 S $P(^DG5(1,"IHS"),U,6)="C"
 Q
 ;
PM2 ; -- patient movement, attending
 W !!,"converting patient movement attending providers ...."
 N X,C,P,V S C=$P($G(^DG5(1,"IHS")),U,7) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^DGPM(X)) Q:'X  D
 . S P=+$P($G(^DGPM(X,0)),U,16) Q:'P
 . S V=$G(^DIC(16,P,"A3")) Q:'V
 . S $P(^DGPM(X,0),U,16)=V
 . S $P(^DG5(1,"IHS"),U,7)=X
 S $P(^DG5(1,"IHS"),U,7)="C"
 Q
 ;
TS ; -- treating specialty
 W !!,"converting treating specialty providers ...."
 N X,Y,C,P,V S C=$P($G(^DG5(1,"IHS")),U,8) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^DIC(45.7,X)) Q:'X  D
 . S Y=0 F  S Y=$O(^DIC(45.7,X,"PRO",Y)) Q:'Y  D
 .. S P=+$G(^DIC(45.7,X,"PRO",Y,0)) Q:'P
 .. S V=$G(^DIC(16,P,"A3")) Q:'V
 .. S $P(^DIC(45.7,X,"DS",Y,0),U)=V
 .. S $P(^DG5(1,"IHS"),U,8)=X
 S $P(^DG5(1,"IHS"),U,8)="C"
 Q
 ;
HL ; -- hospital location
 W !!,"converting hospital location default providers ...."
 N X,C,P,V S C=$P($G(^DG5(1,"IHS")),U,9) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^SC(X)) Q:'X  D
 . S P=+$P($G(^SC(X,0)),U,13) Q:'P
 . S V=$G(^DIC(16,P,"A3")) Q:'V
 . S $P(^SC(X,0),U,13)=V
 . S $P(^DG5(1,"IHS"),U,9)=X
 S $P(^DG5(1,"IHS"),U,9)="C"
 Q
 ;
PT ; -- va patient
 W !!,"converting patient file providers ...."
 N X,C,P,V S C=$P($G(^DG5(1,"IHS")),U,10) Q:C="C"
 S X=$S(C:C,1:0) F  S X=$O(^DPT(X)) Q:'X  D
 . S P=+$G(^DPT(X,.104)) Q:'P
 . S V=$G(^DIC(16,P,"A3")) Q:'V
 . S $P(^DPT(X,.104),U)=V
 . K ^DPT("APR",P,X)
 . S ^DPT("APR",V,X)=""
 . D PT2
 . S $P(^DG5(1,"IHS"),U,10)=X
 S $P(^DG5(1,"IHS"),U,10)="C"
 Q
 ;
PT2 ; -- va patient admission multiple
 N A,P,V,T
 S A=0 F  S A=$O(^DPT(X,"DA",A)) Q:'A  D
 . S T=0 F  S T=$O(^DPT(X,"DA",A,"T",T)) Q:'T  D
 .. S P=$P($G(^DPT(X,"DA",A,"T",T,0)),U,3) Q:P=""
 .. S V=$G(^DIC(16,P,"A3")) Q:'V
 .. S $P(^DPT(X,"DA",A,"T",T,0),U,3)=V
 Q
 ;
V ; -- populate 405 /visit ptr
 W !!,"stuffing visit pointers in admission entries..."
 N DATE,DFN,IFN
 S DATE=0 F  S DATE=$O(^DGPM("AMV1",DATE)) Q:'DATE  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DATE,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV1",DATE,DFN,IFN)) Q:'IFN  D
 ... S:'$G(^DGPM(IFN,"IHS")) $P(^DGPM(IFN,"IHS"),U)=$$VIC(IFN,DFN)
 ... S:'$G(^DGPM(IFN,"IHS")) $P(^DGPM(IFN,"IHS"),U)=$$V1(IFN,DFN)
 Q
 ;
VIC(I,J) ; -- visit ien (I=admission IEN,J=patient DFN)
 N X,Y S (X,Y)=0
 F  S X=$O(^AUPNVSIT("AA",+J,+$$IDC(I),X)) Q:'X  Q:Y  D
 . I $P($G(^AUPNVSIT(X,0)),U,7)="H" S Y=X
 Q Y
 ;
IDC(I) ; -- inverse date
 Q (9999999-$P(+^DGPM(+I,0),"."))_"."_$P(+^DGPM(+I,0),".",2)
 ;
V1(I,J) ; -- visit ien (I=admission IEN,J=patient DFN)
 N X,Y S (X,Y)=0
 F  S X=$O(^AUPNVSIT("AA",+J,+$$I1(I),X)) Q:'X  Q:Y  D
 . I $P($G(^AUPNVSIT(X,0)),U,7)="H" S Y=X
 Q Y
 ;
I1(I) ; -- inverse date
 Q (9999999-$P(+^DGPM(+I,0),"."))
