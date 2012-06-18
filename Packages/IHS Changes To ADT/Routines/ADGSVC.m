ADGSVC ; IHS/ADC/PDW/ENM - HSA-202 CALCULATE ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 N PED,RD,TS,IEN,ED,ADU,IEN,LD,LN,ND,PD
 D INI I '$D(^ADGTX(+$O(^ADGTX(0)),1,+PD)) W !!,"No data",!! Q
A ; -- driver
 D LTX,PK,AB,NB,^ADGSVP,^ADGSVP1,Q Q
 ;
INI ; -- initialize variables
 N I,J F I=1:1:7 F J=1:1:10 S DGA(I,J)=0
 F I=1,2,4 S DGLOS(I)=1
 S X1=$E(DGSMON,1,5)_"01",X2=-1 D C^%DTC S PD=X
 S ED=$E(DGEMON,1,5)_"31.9" Q
 ;
LTX ; -- loop census file
 S TS=0 F  S TS=$O(^ADGTX(TS)) Q:'TS  D BOM,LRD,EOM
 Q
 ;
BOM ; -- patients in service (beginning of month)
 ; -- special service
 I $$SS S DGA($$SS,1)=$P($G(^ADGTX(+TS,1,+PD,0)),U,2)+$P($G(^(1)),U) Q
 ; -- other (adult=1, ped=2)
 S DGA(1,1)=DGA(1,1)+$P($G(^ADGTX(+TS,1,+PD,0)),U,2)
 S DGA(2,1)=DGA(2,1)+$P($G(^ADGTX(+TS,1,+PD,1)),U) Q
 ;
LRD ; -- loop days
 S RD=PD F  S RD=$O(^ADGTX(TS,1,RD)) Q:'RD!(RD>ED)  D
 . S:'$D(DGC(RD)) DGC(RD)=0 S ADU=$G(^ADGTX(+TS,1,+RD,0)),PED=$G(^(1))
 . S LD=RD D SC:$$SS,OS:'$$SS
 Q
 ;
SC ; -- counts, special service
 S DGA($$SS,2)=DGA($$SS,2)+$P(ADU,U,3)+$P(PED,U,2)            ;adm
 S DGA($$SS,3)=DGA($$SS,3)+$P(ADU,U,7)+$P(PED,U,6)            ;dth
 S DGA($$SS,4)=DGA($$SS,4)+$P(ADU,U,4)+$P(PED,U,3)            ;dsc
 S DGA($$SS,6)=DGA($$SS,6)+$P(ADU,U,2)+$P(ADU,U,8)
 S DGA($$SS,6)=DGA($$SS,6)+$P(PED,U)+$P(PED,U,7)              ;rem
 S DGA($$SS,7)=DGA($$SS,7)+$P(ADU,U,5)+$P(PED,U,4)            ;tx in
 S DGA($$SS,8)=DGA($$SS,8)+$P(ADU,U,6)+$P(PED,U,5)            ;tx out
 ; -- adult
 S DGA(1,9)=DGA(1,9)+$P(ADU,U,9)                              ;los
 S DGA(1,10)=DGA(1,10)+$P(ADU,U,8)                            ;1day
 S DGLOS(1)=DGLOS(1)+$P(ADU,U,4)+$P(ADU,U,7)+$P(ADU,U,6)
 ; -- day's count (exclude newborn)
 S:$$SS'=4 DGC(RD)=DGC(RD)+$P(ADU,U,2)+$P(PED,U)
 ; -- newborn
 I $$SS=4 D  Q
 . S DGA(4,9)=DGA(4,9)+$P(PED,U,8)                            ;los
 . S DGA(4,10)=DGA(4,10)+$P(PED,U,7)                          ;1day
 . S DGLOS(4)=DGLOS(4)+$P(PED,U,3)+$P(PED,U,6)+$P(PED,U,5)
 ; -- ped
 S DGA(2,9)=DGA(2,9)+$P(PED,U,8)                              ;los
 S DGA(2,10)=DGA(2,10)+$P(PED,U,7)                            ;1day
 S DGLOS(2)=DGLOS(2)+$P(PED,U,3)+$P(PED,U,6)+$P(PED,U,5) Q
 ;
OS ; -- counts, other service
 S DGC(RD)=DGC(RD)+$P(ADU,U,2)+$P(PED,U)
 ; -- adult
 S DGA(1,2)=DGA(1,2)+$P(ADU,U,3)                              ;adm
 S DGA(1,3)=DGA(1,3)+$P(ADU,U,7)                              ;dth
 S DGA(1,4)=DGA(1,4)+$P(ADU,U,4)                              ;dsc
 S DGA(1,6)=DGA(1,6)+$P(ADU,U,2)+$P(ADU,U,8)                  ;rem
 S DGA(1,9)=DGA(1,9)+$P(ADU,U,9)                              ;los
 S DGA(1,10)=DGA(1,10)+$P(ADU,U,8)                            ;1day
 S DGLOS(1)=DGLOS(1)+$P(ADU,U,4)+$P(ADU,U,7)+$P(ADU,U,6)
 ; -- peds
 S DGA(2,2)=DGA(2,2)+$P(PED,U,2)                              ;adm
 S DGA(2,3)=DGA(2,3)+$P(PED,U,6)                              ;dth
 S DGA(2,4)=DGA(2,4)+$P(PED,U,3)                              ;dsc
 S DGA(2,6)=DGA(2,6)+$P(PED,U)+$P(PED,U,7)                    ;rem
 S DGA(2,9)=DGA(2,9)+$P(PED,U,8)                              ;los
 S DGA(2,10)=DGA(2,10)+$P(PED,U,7)                            ;1day
 S DGLOS(2)=DGLOS(2)+$P(PED,U,3)+$P(PED,U,6)+$P(PED,U,5) Q
 ;
EOM ; -- patients in service (end of month)
 I $$SS D  Q
 . S DGA($$SS,5)=$P($G(^ADGTX(+TS,1,+LD,0)),U,2)+$P($G(^(1)),U)
 S DGA(1,5)=DGA(1,5)+$P($G(^ADGTX(+TS,1,+LD,0)),U,2)
 S DGA(2,5)=DGA(2,5)+$P($G(^ADGTX(+TS,1,+LD,1)),U) Q
 ;
PK ; -- peak and minimum
 S RD=$O(DGC(0)),(DGMAX,DGMIN)=DGC(RD)
 F  S RD=$O(DGC(RD)) Q:'RD  D
 . I DGC(RD)>DGMAX S DGMAX=DGC(RD) Q
 . I DGC(RD)<DGMIN S DGMIN=DGC(RD) Q
 Q
 ;
AB ; -- authorized beds by category
 N C,WD,P,N
 F C="AM","AS","PM","PS","I","O","N","T","AL","MH","P" S DGBED(C)=0
 S WD=0 F  S WD=$O(^DIC(42,WD)) Q:'WD  D
 . Q:$G(^DIC(42,+WD,"I"))="I"  Q:'$D(^DIC(42,+WD,"IHS1"))  S N=^("IHS1")
 . S P=0 F C="AM","AS","PM","PS","O","N","T","AL","MH" D
 .. S P=P+1,DGBED(C)=DGBED(C)+$P(N,U,P)
 . S DGBED("I")=DGBED("I")+$P($G(^DIC(42,WD,"IHS")),U,2)
 . S DGBED("P")=DGBED("P")+$P($G(^DIC(42,WD,"IHS")),U,3)
 Q
 ;
NB ; -- # of non-beneficiaries discharged
 S RD=PD,(DGLOS,DGCNT)=0
 F  S RD=$O(^DGPM("AMV1",RD)) Q:'RD!(RD>ED)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",RD,DFN)) Q:'DFN  D
 .. Q:$P($G(^AUPNPAT(+DFN,11)),U,12)'="I"
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV1",RD,DFN,IEN)) Q:'IEN  D
 ... S DGPMIFN=IEN D ^DGPMLOS S DGCNT=DGCNT+1,DGLOS=DGLOS+$P(X,U,5)
 Q
 ;
Q ; -- cleanup
 K DGPMIFN,DGA,DGSMON,DGEMON,DGMAX,DGMIN,DGX
 W @IOF D ^%ZISC,KILL^ADGUTIL Q
 ;
SS() ; -- special service  3 ob, 4 nb, 5 tb, 6 mh, 7 al           ;non SS
 ; -- ts ihs code        08    07    13    12    15           ;------
 N X S X=$P($G(^DIC(45.7,+TS,9999999)),U)                     ;adu 1
 Q $S(X="08":3,X="07":4,X="13":5,X="15":6,X="12":7,1:0)       ;ped 2
