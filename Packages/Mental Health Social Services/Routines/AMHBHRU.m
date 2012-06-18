AMHBHRU ; IHS/CMI/LAB - GUI V FILE VISIT CREATION ; 16 Dec 2010  11:54 AM
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;;
TEST ;
 D EN(.RETVAL,24609)
 Q
EN(AMHARRAY,AMHR,AMHGUIV) ;EP CALL
 ;N AMHZTQ
 ;I $G(ZTQUEUED)]"" S AMHZTQ=ZTQUEUED
 ;S ZTQUEUED=""  ;cmi/anch/maw 5/19/2009 removed causing errors when running face sheet after call to create visit
 S AMHBL=1  ;cmi/maw 5/19/2009 since ZTQUEUED
 S AMHERR=""
 ;AMHR must be ien of MHSS RECORD that was added or updated
 D
 .D PRECHECK Q:AMHERR'=""
 .D CHECKREC Q:AMHERR'=""
 .D PCCLINK
 I AMHERR="" D MSG("1") Q
 I AMHERR'="" D ERROR(AMHERR)
 D KILL
 Q
 ;
CHECKREC ;
 S AMHREC=^AMHREC(AMHR,0)
 I $P($P(AMHREC,U,1),".")>DT S AMHERR="FUTURE VISIT DATE NOT ALLOWED!!!" Q
 I $P(AMHREC,U,4)="" S AMHERR="LOCATION OF ENCOUNTER MISSING!" Q
 I $P(AMHREC,U,5)="" S AMHERR="Community of Service Missing!" Q
 I $P(AMHREC,U,6)="" S AMHERR="Activity Type Missing!" Q
 I $P(AMHREC,U,7)="" S AMHERR="Type of Contact Missing!" Q
 I $P(AMHREC,U,12)="" S AMHERR="Activity Time Missing!" Q
 I $P(AMHREC,U,19)="" S AMHERR="Who entered record Missing!" Q
 I $P(AMHREC,U,21)="" S AMHERR="Date Last Modified Missing!" Q
 I $P(AMHREC,U,22)="" S AMHERR="Extract Flag Missing!" Q
 I $P(AMHREC,U,28)="" S AMHERR="User Last Update Missing!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 S AMHERR="No primary Provider!" Q  ;IHS/CMI/LAB - UNCOMMENT LORI! *****
 I Y>1 S AMHERR="ERROR: Multiple Primary Providers!" Q
 I '$D(^AMHRPRO("AD",AMHR)) S AMHERR="ERROR: No POV entered!!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPRO("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPRO(X,0),U,4)="" S Z=1
 I Z S AMHERR="No Provider Narrative on a POV!" Q
 I $P(AMHREC,U,12)="" S AMHERR="ERROR:  Activity Time Missing!" Q
 Q
PCCLINK ;
 D PCCCHECK
 I 'AMHLPCC Q:'$$PRVLINK^AMHLE2($$PPINT^AMHUTIL(AMHR))  ;quit if no pcc link
 S AMHPTYPE=$P(^AMHREC(AMHR,0),U,2)
 D VISIT
 I 'AMHVISIT,$P(^AMHREC(AMHR,0),U,16)]"" D  Q
 .S APCDVDLT=$P(^AMHREC(AMHR,0),U,16) D ^APCDVDLT
 .S DIE="^AMHREC(",DA=AMHR,DR=".16///@" D CALLDIE^AMHLEIN
 Q:AMHVISIT
 Q
 ;
PCCCHECK ;EP - check to see if link to pcc active, set AMHLPCC IF SO
 K AMHLPCC
 S (AMHLPCC,AMHLPCCT)=$P(^AMHSITE(DUZ(2),0),U,12) I AMHLPCC S AMHLPCC=AMHLPCC-1
 I AMHLPCC="" S AMHLPCC=0 Q
 Q:'AMHLPCC
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",'$D(^APCCCTRL(DUZ(2),0))#2 S AMHLPCC=0 Q
 S AMHPKG=$O(^DIC(9.4,"C","AMH",""))
 I '$D(^APCCCTRL(DUZ(2),11,AMHPKG,0))#2 S AMHLPCC=0 Q
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",$D(^APCCCTRL(DUZ(2),0))#2,$D(^APCCCTRL(DUZ(2),11,AMHPKG,0))#2,$P(^(0),U,2) S AMHLPCC=AMHLPCC
 E  S AMHLPCC=0
 K AMHPKG
 Q
VISIT ;
 K AMHDNKA
 S AMHVISIT=0
 Q:'$G(AMHR)
 Q:'$P(^AMHREC(AMHR,0),U,8)  ;no pcc if not a patient encounter
 ;do not pass residential type of visits to pcc
 I $$VAL^XBDIQ1(9002011,AMHR,.07)="RESIDENTIAL" Q  ;if one record a day, don't want in PCC
 ;do not pass visits with dnka problem code
 ;check for at least one pov that is icd9 codable
 S (AMHX,AMHGOT,AMHDNKA)=0 F  S AMHX=$O(^AMHRPRO("AD",AMHR,AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.1 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.11 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.2 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.21 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U)=8.3 S AMHDNKA=1 Q  ;do not pass dnka
 .I $P(^AMHPROB($P(^AMHRPRO(AMHX,0),U),0),U,5)]"" S AMHGOT=1
 .Q
 Q:AMHDNKA
 Q:$P(^AMHREC(AMHR,0),U,6)=""
 Q:'AMHGOT
 Q:'$P(^AMHTACT($P(^AMHREC(AMHR,0),U,6),0),U,4)  ;quit if not an activity that gets passed to PCC
TASK ;
 ;*****************************
 S AMHBL=1,AMHACTN=2
 NEW AMHERR D START^AMHPCCL S AMHVISIT=1 Q  ;************ FOR TESTING IN FOREGROUND
 Q
ERROR(AMHX) ;
 D MSG("-1"_$C(30)_AMHX)
 Q
 ;
MSG(AMHX) ;
 S AMHARRAY=AMHX
 Q
 ;
PRECHECK ;
 I $G(AMHR)="" S AMHERR="IEN OF MHSS RECORD NOT SET" Q
 I '$D(^AMHREC(AMHR,0)) S AMHERR="IEN OF MHSS RECORD NOT VALID" Q
 Q
 ;
KILL ;
 D ^XBFMK
 K DLAYGO,DIADD
 K APCDALVR,AMHPARM,AMHERR,AMHVAL,AMHR  ;,ZTQUEUED
 I $G(AMHZTQ)]"" S ZTQUEUED=AMHZTQ
 Q
 ;
