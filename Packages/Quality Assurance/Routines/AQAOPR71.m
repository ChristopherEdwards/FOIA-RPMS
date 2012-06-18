AQAOPR71 ; IHS/ORDC/LJF - CALCULATE REVIEWED OCC RPRT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn finds all appropriate occurrences based on indicators
 ;selected and date range.
 ;
 K ^TMP("AQAOPR7A",$J)
 S AQAOCNT=0 ;initialize total count
TMP ; >>> loop thru ^TMP to find indicators
 F AQAOI="SINGLE","MED STAFF F","FACILITY WIDE","KEY FUNCTION","DIMENSION","OTHER" D
 .S AQAOF=AQAOI
 .F  S AQAOF=$O(^TMP("AQAOPR7",$J,1,AQAOF)) Q:AQAOF'[AQAOI  D
 ..S AQAOIND=0
 ..F  S AQAOIND=$O(^TMP("AQAOPR7",$J,1,AQAOF,AQAOIND)) Q:AQAOIND=""  D
 ...;
 ...; >>for this indicator, find occ for date range
 ...S AQAODT=AQAOBD-.0001,AQAOEDT=AQAOED_.2400
 ...F  S AQAODT=$O(^AQAOC("AA",AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAODT>AQAOEDT  D
 ....S DFN=0
 ....F  S DFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN)) Q:DFN=""  D
 .....S AQAOIFN=0
 .....F  S AQAOIFN=$O(^AQAOC("AA",AQAOIND,AQAODT,DFN,AQAOIFN)) Q:AQAOIFN=""  D
 ......Q:'$$STATUS  ;wrong case status
 ......Q:'$$USERTEAM  ;at least one rev/ref has one of selected user/team
 ......S AQAOCNT=AQAOCNT+1 ;increment total cases
 ......S X=$P(^AQAO(2,AQAOIND,0),U)_"   "_$P(^(0),U,2) ;ind # & name
 ......S ^TMP("AQAOPR7A",$J,X,AQAODT,AQAOIFN)=""
 ;
NEXT ; >>> go to print rtn
 G ^AQAOPR72
 ;
 ;
STATUS() ;EXTR VAR to check case status against user's choice
 N X,Y S X=1,Y=$P(^AQAOC(AQAOIFN,1),U) ;status (open,closed,deleted)
 I (AQAOSTAT'[1),(Y=0) S X=0 ;open not included in user's choice
 I (AQAOSTAT'[2),(Y=1) S X=0 ;closed not included in user's choice
 I (AQAOSTAT'[3),(Y=2) S X=0 ;deleted not included in user's choice
 Q X
 ;
 ;
USERTEAM() ;EXTR VAR to check selected user/teams against occ review
 N W,X,Y,Z
 S Z=$P($G(^AQAOC(AQAOIFN,1)),U,4) I Z="" Q 0 ;initial reviewer
 I ('$O(AQAOO("USR",0))),('$O(AQAOO("TEAM",0))) Q 1 ;no restrictions
 I $$OK Q 1
 S Z=$P($G(^AQAOC(AQAOIFN,1)),U,9) I Z="" Q 0 ;initial referral
 I $$OK Q 1
 S (Y,X)=0 F  S X=$O(^AQAOC(AQAOIFN,"IADDRV",X)) Q:'X  Q:Y=1  D
 .S Z=$P($G(^AQAOC(AQAOIFN,"IADDRV",X,0)),U) I Z="" Q
 .I $$OK S Y=1 Q
 I Y=1 Q 1 ;at least one add referrals
 S (Y,X)=0 F  S X=$O(^AQAOC(AQAOIFN,"REV",X)) Q:'X  Q:Y=1  D
 .S Z=$P($G(^AQAOC(AQAOIFN,"REV",X,0)),U,2) I Z="" Q
 .I $$OK S Y=1 Q
 .S W=0 F  S W=$O(^AQAOC(AQAOIFN,"REV",X,"ADDRV",W)) Q:'W  Q:Y=1  D
 ..S Z=$P($G(^AQAOC(AQAOIFN,"REV",X,"ADDRV",W,0)),U) I Z="" Q
 ..I $$OK S Y=1 Q
 Q Y
 ;
 ;
OK() ;EXTR VAR to test entry against selection arrays
 Q ($D(AQAOO("USR",Z)))!($D(AQAOO("TEAM",Z)))
