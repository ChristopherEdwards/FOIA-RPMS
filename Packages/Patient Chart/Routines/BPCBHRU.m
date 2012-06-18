BPCBHRU ; IHS/OIT/MJL - GUI V FILE VISIT CREATION ; [ 08/22/2007  8:47 AM ]
 ;;1.5;BPC;**4**;FEB 16, 2005
 ;;
TEST ;
 D EN(.RETVAL,24609)
 Q
EN(BPCARRAY,AMHR,AMHGUIV) ;EP CALL
 S ZTQUEUED=""
 S BPCERR=""
 ;AMHR must be ien of MHSS RECORD that was added or updated
 D
 .D PRECHECK Q:BPCERR'=""
 .D CHECKREC Q:BPCERR'=""
 .D PCCLINK
 I BPCERR="" D MSG("1") Q
 I BPCERR'="" D ERROR(BPCERR)
 D KILL
 Q
 ;
CHECKREC ;
 S AMHREC=^AMHREC(AMHR,0)
 I $P($P(AMHREC,U,1),".")>DT S BPCERR="FUTURE VISIT DATE NOT ALLOWED!!!" Q
 I $P(AMHREC,U,4)="" S BPCERR="LOCATION OF ENCOUNTER MISSING!" Q
 I $P(AMHREC,U,5)="" S BPCERR="Community of Service Missing!" Q
 I $P(AMHREC,U,6)="" S BPCERR="Activity Type Missing!" Q
 I $P(AMHREC,U,7)="" S BPCERR="Type of Contact Missing!" Q
 I $P(AMHREC,U,12)="" S BPCERR="Activity Time Missing!" Q
 I $P(AMHREC,U,19)="" S BPCERR="Who entered record Missing!" Q
 I $P(AMHREC,U,21)="" S BPCERR="Date Last Modified Missing!" Q
 I $P(AMHREC,U,22)="" S BPCERR="Extract Flag Missing!" Q
 I $P(AMHREC,U,28)="" S BPCERR="User Last Update Missing!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 S BPCERR="No primary Provider!" Q  ;IHS/CMI/LAB - UNCOMMENT LORI! *****
 I Y>1 S BPCERR="ERROR: Multiple Primary Providers!" Q
 I '$D(^AMHRPRO("AD",AMHR)) S BPCERR="ERROR: No POV entered!!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPRO("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPRO(X,0),U,4)="" S Z=1
 I Z S BPCERR="No Provider Narrative on a POV!" Q
 I $P(AMHREC,U,12)="" S BPCERR="ERROR:  Activity Time Missing!" Q
 Q
PCCLINK ;
 D PCCCHECK
 Q:'AMHLPCC  ;quit if no pcc link
 S AMHPTYPE=$P(^AMHREC(AMHR,0),U,2)
 D VISIT
 I 'AMHVISIT,$P(^AMHREC(AMHR,0),U,16)]"" D  Q
 .S APCDVDLT=$P(^AMHREC(AMHR,0),U,16) D ^APCDVDLT
 .S DIE="^AMHREC(",DA=AMHR,DR=".16///@" D CALLDIE^AMHLEIN
 Q:AMHVISIT
 Q
 ;
PCCCHECK ;check to see if link to pcc active, set AMHLPCC IF SO
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
 I $$DOD^AUPNPAT($P(^AMHREC(AMHR,0),U,8))]"",$$DOD^AUPNPAT($P(^AMHREC(AMHR,0),U,8))<$P($P(^AMHREC(AMHR,0),U),".") Q  ;if visit date after dod then don't go to pcc
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
 D START^AMHPCCL S AMHVISIT=1 Q  ;************ FOR TESTING IN FOREGROUND
 Q
ERROR(BPCX) ;
 D MSG("-1"_$C(30)_BPCX)
 Q
 ;
MSG(BPCX) ;
 S BPCARRAY=BPCX
 Q
 ;
PRECHECK ;
 I $G(AMHR)="" S BPCERR="IEN OF MHSS RECORD NOT SET" Q
 I '$D(^AMHREC(AMHR,0)) S BPCERR="IEN OF MHSS RECORD NOT VALID" Q
 Q
 ;
KILL ;
 D ^XBFMK
 K DLAYGO,DIADD
 K APCDALVR,BPCPARM,BPCERR,BPCVAL,AMHR,ZTQUEUED
 Q
 Q
