BDGM202A ; IHS/ANMC/LJF - M202 CALCULATE ;  [ 12/27/2004  3:24 PM ]
 ;;5.3;PIMS;**1001,1003,1005,1006,1008,1010,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 10/25/2004 PATCH 1001 count even if service is now inactive
 ;             04/27/2005 PATCH 1003 fixed code so transfers from observation to inpatient are counted as admissions
 ;IHS/OIT/LJF  05/04/2006 PATCH 1005 rewrote logic to count authorized beds
 ;             08/24/2006 PATCH 1006 added separate counts for observations and swing beds
 ;cmi/anch/maw 11/07/2007 PATCH 1008 Q:'$D(REM) as sometimes its not there when PEAK gets called
 ;cmi/anch/maw 09/19/2008 PATCH 1010 counts for special service (observations) were not correct in BOM and EOM
 ;ihs/cmi/maw  04/18/2011 PATCH 1013 RQMT155 added day surgery
 ;
 NEW BDGBD,BDGED,REM,DGA,DGLOS,BDGOB
 D INIT                ;initialize counts
 D LOOP                ;loop thru census files and count
 D PEAK                ;count peak and minimum census
 D AUTHBEDS            ;count authorized beds
 D NONBEN              ;count non-beneficiaries discharges
 ;D OBSERV              ;count observations;IHS/OIT/LJF 08/24/2006 PATCH 1006 no longer needed
 D ^BDGM202B           ;print report
 D EXIT                ;clean up and close
 Q
 ;
INIT ; -- initialize variables
 NEW I,J,X1,X2,X
 ;
 ; for 7 service categories in Part I, initialize 10 count categories
 ;   service categories are Med/Surg (adult), Med/Surg (peds), OB
 ;       TB, Alcohol/Subs Abuse, Mental Health and Newborn
 ;   count categories are beginning census, admits, transfers in,
 ;       deaths, other discharges, transfer out, ending census,
 ;       inpt days, los and # of 1 day pts
 F I=1:1:7 F J=1:1:10 S DGA(I,J)=0
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 adding swing bed & observations
 ;F I=8,9 F J=1:1:10 S DGA(I,J)=0
 F I=8,9,10 F J=1:1:10 S DGA(I,J)=0  ;ihs/cmi/maw 04/18/2011 added day surgery
 ;
 ; length of stay stats (Part III) only has 3 categories
 ;     adult, peds and newborn
 F I=1,2,4 S DGLOS(I)=1
 ;
 ; set starting and ending dates
 S X1=$E(BDGBM,1,5)_"01",X2=-1 D C^%DTC S BDGBD=X
 S BDGED=$E(BDGEM,1,5)_"31.9"
 ;
 Q
 ;
LOOP ; -- loop census file
 ; TS=treating specialty ien
 ; SS=1 if special service, 0 if not, "" if observation (don't count)
 ; LD=last date (used to find end of month census)
 NEW TS,SS,LD
 S TS=0 F  S TS=$O(^BDGCTX(TS)) Q:'TS  D
 . S SS=$$SS(TS) I SS'="" D BOM,DAYS,EOM
 Q
 ;
BOM ; -- patients in service (beginning of month)
 ; -- special service (adult & peds counts)
 ;I SS S DGA(SS,1)=$P($G(^BDGCTX(TS,1,BDGBD,0)),U,2)+$P($G(^(0)),U,12) Q  ;cmi/anch/maw 9/19/2008 orig line
 I SS S DGA(SS,1)=DGA(SS,1)+$P($G(^BDGCTX(TS,1,BDGBD,0)),U,2)+$P($G(^(0)),U,12) Q  ;cmi/anch/maw 9/19/2008 PATCH 1010 found by Chinle
 ; -- med/surg (adult=1, ped=2)
 S DGA(1,1)=DGA(1,1)+$P($G(^BDGCTX(+TS,1,+BDGBD,0)),U,2)
 S DGA(2,1)=DGA(2,1)+$P($G(^BDGCTX(+TS,1,+BDGBD,0)),U,12)
 Q
 ;
DAYS ; -- loop days and count
 NEW RD
 S RD=BDGBD F  S RD=$O(^BDGCTX(TS,1,RD)) Q:'RD!(RD>BDGED)  D
 . S DATA=$G(^BDGCTX(+TS,1,+RD,0)) D COUNT
 . S LD=RD               ;set last date
 Q
 ;
COUNT ; count for service and date
 NEW SV
 ;     count remaining by date excluding newborns
 I SS'=4 S REM(RD)=$G(REM(RD))+$P(DATA,U,2)+$P(DATA,U,12)
 ;
 ; -- adult
 S SV=$S(SS:SS,1:1)   ;subscript for adult data
 S DGA(SV,2)=DGA(SV,2)+$P(DATA,U,3)               ;admits
 S DGA(SV,3)=DGA(SV,3)+$P(DATA,U,7)               ;deaths
 S DGA(SV,4)=DGA(SV,4)+$P(DATA,U,4)               ;discharges
 S DGA(SV,6)=DGA(SV,6)+$P(DATA,U,2)+$P(DATA,U,8)  ;# remain + 1 day pts
 S DGA(SV,7)=DGA(SV,7)+$P(DATA,U,5)               ;transfers in
 S DGA(SV,8)=DGA(SV,8)+$P(DATA,U,6)               ;transfer out
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 account for observations
 ;S DGA(SV,9)=DGA(SV,9)+$P(DATA,U,9)               ;los for discharges
 S DGA(SV,9)=DGA(SV,9)+$P(DATA,U,$S(SV=9:11,1:9))   ;los for discharges
 ;
 S DGA(SV,10)=DGA(SV,10)+$P(DATA,U,8)             ;1day pts
 ;
 ; count # of adult patients who left service on date
 ;   counts deaths, discharges and transfers out
 S DGLOS(1)=DGLOS(1)+$P(DATA,U,4)+$P(DATA,U,7)+$P(DATA,U,6)
 ;
 ; -- peds
 S SV=$S(SS:SS,1:2)   ;subscript for peds data
 S DGA(SV,2)=DGA(SV,2)+$P(DATA,U,13)                ;admits
 S DGA(SV,3)=DGA(SV,3)+$P(DATA,U,17)                ;deaths
 S DGA(SV,4)=DGA(SV,4)+$P(DATA,U,14)                ;discharges
 S DGA(SV,6)=DGA(SV,6)+$P(DATA,U,12)+$P(DATA,U,18)  ;# remain+1 day pts
 S DGA(SV,7)=DGA(SV,7)+$P(DATA,U,15)                ;transfers in
 S DGA(SV,8)=DGA(SV,8)+$P(DATA,U,16)                ;transfers out
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 account for observations
 ;S DGA(SV,9)=DGA(SV,9)+$P(DATA,U,19)                ;los for discharges
 S DGA(SV,9)=DGA(SV,9)+$P(DATA,U,$S(SV=9:21,1:19))    ;los for discharges
 ;
 S DGA(SV,10)=DGA(SV,10)+$P(DATA,U,18)              ;1 day pts
 ;
 ; count # of peds patients who left service on date
 I SS=4 D  Q   ;count newborns separately
 . S DGLOS(4)=DGLOS(4)+$P(DATA,U,3)+$P(DATA,U,6)+$P(DATA,U,5)
 S DGLOS(2)=DGLOS(2)+$P(DATA,U,3)+$P(DATA,U,6)+$P(DATA,U,5)
 Q
 ;
EOM ; -- patients in service (end of month)
 Q:'$G(LD)   ;no data, so no last date
 ;  -- special service (adult & peds counts)
 ;I SS S DGA(SS,5)=$P($G(^BDGCTX(TS,1,LD,0)),U,2)+$P($G(^(0)),U,12) Q  ;cmi/anch/maw 9/19/2008 orig line
 I SS S DGA(SS,5)=DGA(SS,5)+$P($G(^BDGCTX(TS,1,LD,0)),U,2)+$P($G(^(0)),U,12) Q  ;cmi/anch/maw 9/19/2008 mod line PATCH 1010 found at Chinle
 ;  -- med/surg (adult=1; peds=2)
 S DGA(1,5)=DGA(1,5)+$P($G(^BDGCTX(+TS,1,+LD,0)),U,2)
 S DGA(2,5)=DGA(2,5)+$P($G(^BDGCTX(+TS,1,+LD,0)),U,12)
 Q
 ;
PEAK ; -- peak and minimum
 Q:'$D(REM)
 S RD=$O(REM(0)),(DGMAX,DGMIN)=REM(RD)
 F  S RD=$O(REM(RD)) Q:'RD  D
 . I REM(RD)>DGMAX S DGMAX=REM(RD) Q
 . I REM(RD)<DGMIN S DGMIN=REM(RD)
 Q
 ;
AUTHBEDS ; -- authorized beds by category
 D NEWAUTH Q   ;IHS/OIT/LJF 05/04/2006 PATCH 1005 rewrote logic under NEWAUTH
 NEW C,WD,P,N
 F C="AM","AS","PM","PS","I","O","N","T","AL","MH","P" S DGBED(C)=0
 S WD=0 F  S WD=$O(^BDGWD(WD)) Q:'WD  D
 . ;Q:$$GET1^DIQ(9009016.5,WD,.03)="INACTIVE"  ;IHS/ITSC/LJF 10/25/2004 PATCH 1001
 . ;
 . ; 
 . S N=$G(^BDGWD(WD,1))    ;node with authorized bed numbers
 . S P=10 F C="AM","AS","PM","PS","O","N","T","AL","MH" D
 .. S P=P+1,DGBED(C)=DGBED(C)+$P(N,U,P)
 . ;
 . ; now for ICU numbers
 . S DGBED("I")=DGBED("I")+$P(N,U,2)
 . S DGBED("P")=DGBED("P")+$P(N,U,3)
 Q
 ;
NONBEN ; -- # of non-beneficiaries discharged
 ; DGLOS=total length of stay of non-bens
 ; DGCNT=total # ofnonbens
 NEW RD,DFN,IEN,X,DGPMIFN
 S RD=BDGBD,(DGLOS,DGCNT)=0
 F  S RD=$O(^DGPM("AMV1",RD)) Q:'RD!(RD>BDGED)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",RD,DFN)) Q:'DFN  D
 .. Q:$$GET1^DIQ(9000001,DFN,1112)'="INELIGIBLE"
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV1",RD,DFN,IEN)) Q:'IEN  D
 ... S DGPMIFN=IEN D ^DGPMLOS S DGCNT=DGCNT+1,DGLOS=DGLOS+$P(X,U,5)
 Q
 ;
OBSERV ; count # of observations
 ; also update inpt counts for unplanned admits from observation status
 ;   for any transfers out of service, find inpt service by code
 ;    then ad one admit for inpt service and subtract one transfer in
 ; BDGOB = # of observations
 ;
 NEW TS,SS,RD,DATA
 S TS=0 F  S TS=$O(^BDGCTX(TS)) Q:'TS  D
 . S SS=$$SS(TS) Q:SS'=""
 . S RD=BDGBD F  S RD=$O(^BDGCTX(TS,1,RD)) Q:'RD!(RD>BDGED)  D
 .. S DATA=$G(^BDGCTX(+TS,1,+RD,0))
 .. S BDGOB=$G(BDGOB)+$P(DATA,U,4)+$P(DATA,U,7)+$P(DATA,U,14)+$P(DATA,U,17)
 .. ;
 .. ; if any transfers out, assume admits to inpt status
 .. I ($P(DATA,U,6)>0)!($P(DATA,U,16)>0) D
 ... NEW ITS,ISS,SV
 ... S ITS=$$ITS(TS) Q:ITS=""    ;find inpt service
 ... S ISS=$$SS(ITS) Q:ISS=""    ;find inpt service category
 ... S SV=$S(ISS:ISS,1:1)        ;subscript for adult data
 ... ; adult counts
 ... S DGA(SV,2)=DGA(SV,2)+$P(DATA,U,6)   ;convert TXO to ADM
 ... S DGA(SV,7)=DGA(SV,7)-$P(DATA,U,6)   ;subtract TXI, now ADM
 ... ; peds counts
 ... S SV=$S(ISS:ISS,1:2)        ;subscript for peds data
 ... S DGA(SV,2)=DGA(SV,2)+$P(DATA,U,16)  ;convert TXO to ADM
 ... S DGA(SV,7)=DGA(SV,7)-$P(DATA,U,16)  ;subtract TXI, now ADM
 Q
 ;
EXIT ; -- cleanup
 W @IOF D ^%ZISC
 K DGA,BDGBM,BDGEM,DGMAX,DGMIN,DGLOS,DGCNT,DGBED
 Q
 ;
SS(T) ; -- special service  3 ob, 4 nb, 5 tb, 6 mh, 7 al
 ;  --- ts ihs code       08    07    13    12    15
 ;  --- observation services return ""
 ; --- non SS = adult (1) or peds (2)
 NEW X S X=$$GET1^DIQ(45.7,+T,9999999.01)
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 accounts for observations & swing bed
 ;Q $S(X["O":"",X="08":3,X="07":4,X="13":5,X="15":6,X="12":7,1:0)
 ;Q $S(X["O":9,X="08":3,X="07":4,X="13":5,X="15":6,X="12":7,X="21":8,1:0)
 Q $S(X["O":9,X="08":3,X="07":4,X="13":5,X="15":6,X="12":7,X="21":8,X="23":10,1:0)  ;ihs/cmi/maw 04/18/2011 added day surgery
 ;
ITS(T) ; find corresponding inpt service for observation service
 NEW X,Y
 S X=$$GET1^DIQ(45.7,+T,9999999.01) I X'["O" Q ""
 ;S Y=$O(^DIC(45.7,"CIHS",+X,0)) I 'Y Q ""
 S Y=$O(^DIC(45.7,"CIHS",$E(X,1,2),0)) I 'Y Q ""   ;IHS/ITSC/LJF 4/27/2005 PATCH 1003
 Q Y
 ;
NEWAUTH ; -- authorized beds by category   ;IHS/OIT/LJF 05/04/2006 PATCH 1005 new logic
 NEW TYPE,WARD,IEN,COUNT,TMP,NODE,DATE
 ;initialize total counts
 F TYPE="AM","AS","PM","PS","IC","OB","NB","TB","AL","MH","PC" S DGBED(TYPE)=0
 ;
 ;for each ward find all counts
 S WARD=0 F  S WARD=$O(^BDGWD(WARD)) Q:'WARD  D
 . K TMP
 . S IEN=0 F  S IEN=$O(^BDGWD(WARD,2,IEN)) Q:'IEN  D
 . . S NODE=$G(^BDGWD(WARD,2,IEN,0))                ;node with authorized bed numbers
 . . S DATE=$P(NODE,U) Q:DATE>BDGED                 ;beds added to authorized totals after this month
 . . S TYPE=$P(NODE,U,2) S TMP(TYPE,DATE)=$P(NODE,U,3)
 . ;
 . ; add this ward's counts to totals  (find most recent for type)
 . S TYPE=0 F  S TYPE=$O(TMP(TYPE)) Q:TYPE=""  D
 . . S DATE=$O(TMP(TYPE,""),-1)
 . . S DGBED(TYPE)=DGBED(TYPE)+TMP(TYPE,DATE)
 Q
