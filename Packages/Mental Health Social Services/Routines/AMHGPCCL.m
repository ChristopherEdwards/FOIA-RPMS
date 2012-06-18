AMHGPCCL ; IHS/CMI/MAW - AMHG Interactive PCC Link 5/19/2009 10:44:13 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
 ;
DEBUG(RETVAL,AMHSTR) ;-- debug entry point
 D DEBUG^%Serenji("PCC^AMHGPCCL(.RETVAL,.AMHSTR)")
 Q
 ;
PCC(RETVAL,AMHSTR) ;-- create/edit PCC visit from MHSS RECORD ENTRY
 S X="MERR^AMHGU",@^%ZOSF("TRAP") ; m error trap
 N AMHI,P,R,AMHIEN,AMHVS,AMHER,AMHREC
 S P="|",R="~"
 S RETVAL="^AMHTMP("_$J_")"
 S AMHI=0
 K ^AMHTMP($J)
 S AMHIEN=$P(AMHSTR,P)
 S AMHVS=$P(AMHSTR,P,2)
 D EN(AMHIEN,AMHVS)
 I $E($G(AMHARRAY),1,2)="-1" D
 . S AMHER="0~"_$P(RET,$C(30),2)
 I $G(AMHARRAY)=1 D
 . S AMHREC=$$GET1^DIQ(9002011,AMHIEN,.16,"I")
 S @RETVAL@(AMHI)="T00030Result"_$C(30)
 S AMHI=AMHI+1
 S @RETVAL@(AMHI)=$S($G(AMHER)]"":AMHER,1:$G(AMHREC))_$C(30)
 S @RETVAL@(AMHI+1)=$C(31)
 Q
 ;
EN(AMHR,AMHGUIV) ;EP CALL
 ;S ZTQUEUED=""
 S AMHERRR=""
 ;AMHR must be ien of MHSS RECORD that was added or updated
 D PRECHECK I AMHERRR'="" D ERROR(AMHERRR) Q
 D CHECKREC I AMHERRR'="" D ERROR(AMHERRR) Q
 D PCCLINK
 I AMHERRR="" D MSG("1") Q
 I AMHERRR'="" D ERROR(AMHERRR)
 D KILL
 Q
 ;
CHECKREC ;
 N AMHREC
 S AMHREC=^AMHREC(AMHR,0)
 I $P($P(AMHREC,U,1),".")>DT S AMHERRR="FUTURE VISIT DATE NOT ALLOWED!!!" Q
 I $P(AMHREC,U,4)="" S AMHERRR="LOCATION OF ENCOUNTER MISSING!" Q
 I $P(AMHREC,U,5)="" S AMHERRR="Community of Service Missing!" Q
 I $P(AMHREC,U,6)="" S AMHERRR="Activity Type Missing!" Q
 I $P(AMHREC,U,7)="" S AMHERRR="Type of Contact Missing!" Q
 I $P(AMHREC,U,12)="" S AMHERRR="Activity Time Missing!" Q
 I $P(AMHREC,U,19)="" S AMHERRR="Who entered record Missing!" Q
 I $P(AMHREC,U,21)="" S AMHERRR="Date Last Modified Missing!" Q
 I $P(AMHREC,U,22)="" S AMHERRR="Extract Flag Missing!" Q
 I $P(AMHREC,U,28)="" S AMHERRR="User Last Update Missing!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 S AMHERRR="No primary Provider!" Q  ;IHS/CMI/LAB - UNCOMMENT LORI! *****
 I Y>1 S AMHERRR="ERROR: Multiple Primary Providers!" Q
 I '$D(^AMHRPRO("AD",AMHR)) S AMHERRR="ERROR: No POV entered!!" Q
 S (X,Y,Z)=0 F  S X=$O(^AMHRPRO("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPRO(X,0),U,4)="" S Z=1
 I Z S AMHERRR="No Provider Narrative on a POV!" Q
 I $P(AMHREC,U,12)="" S AMHERRR="ERROR:  Activity Time Missing!" Q
 Q
PCCLINK ;
 D PCCCHECK
 I 'AMHLPCC Q:'$$PRVLINK^AMHLE2($$PPINT^AMHUTIL(AMHR))   ;quit if no pcc link
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
 NEW AMHERRR D START^AMHPCCL S AMHVISIT=1 Q  ;************ FOR TESTING IN FOREGROUND
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
 I $G(AMHR)="" S AMHERRR="IEN OF MHSS RECORD NOT SET" Q
 I '$D(^AMHREC(AMHR,0)) S AMHERRR="IEN OF MHSS RECORD NOT VALID" Q
 Q
 ;
KILL ;
 D ^XBFMK
 K DLAYGO,DIADD
 K APCDALVR,AMHPARM,AMHERRR,AMHVAL,AMHR,ZTQUEUED,AMHERR,AMHBL,AMHDNKA,AMHLPCC,AMHLPCCT,AMHPTYPE,AMHVISIT
 Q
 ;
