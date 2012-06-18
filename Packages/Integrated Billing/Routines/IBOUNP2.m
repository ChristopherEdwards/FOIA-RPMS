IBOUNP2	;ALB/CJM - OUTPATIENT INSURANCE REPORT ;JAN 25,1992
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	; IBOTIME appointment time
	; IBODIV  division
	; IBOCLNC clinic
	; IBOCTG category vet is in (no=noinsurance,expired,unknow)
	; IBOEND2  end of the date range + 30 days
	; IBOINS =1 in there is insurance data
	; IBORPTD =1 if appt should appear on report
LOOPCLNC	; loops through selected clinics
	N IBOCLNC,IBOTIME,IBOEND2,IBOCTG,IBOINS,IBORPTD,IBONAME S IBOCLNC=""
	S X1=IBOEND,X2=30 D C^%DTC S IBOEND2=X
	I VAUTC=1 F  S IBOCLNC=$O(^SC("AC","C",IBOCLNC)) Q:'IBOCLNC  D LOOPAPPT
	I VAUTC'=1 F  S IBOCLNC=$O(VAUTC(IBOCLNC)) Q:'IBOCLNC  D LOOPAPPT
	Q
LOOPAPPT	; loops through appointments for a selected clinic
	N J,R,IBOCLN,IBODIV I $D(^SC(IBOCLNC,0)) D
	.S IBODIV=$P($G(^SC(IBOCLNC,0)),"^",15) S:IBODIV IBODIV=$P($G(^DG(40.8,IBODIV,0)),"^",1) S:IBODIV="" IBODIV="UNKNOWN"
	.N IBOCLN S IBOCLN=$P($G(^SC(IBOCLNC,0)),"^",1) I IBOCLN="" S IBOCLN="NOT KNOWN"
	.F IBOTIME=IBOBEG-.0001:0 S IBOTIME=$O(^SC(IBOCLNC,"S",IBOTIME)) Q:'IBOTIME!(IBOTIME>(IBOEND+.99))  F J=0:0 S J=$O(^SC(IBOCLNC,"S",IBOTIME,1,J)) Q:J<1  I $D(^SC(IBOCLNC,"S",IBOTIME,1,J,0)) D
	.. S R=^(0),DFN=+R
	.. I $P(R,"^",9)'="C",$D(^DPT(DFN,"S",IBOTIME,0)),$P(^(0),"^",2)']"" S IBOQUIT=0 D DONE,VET:'IBOQUIT,STATUS:'IBOQUIT Q:IBOQUIT  S IBORPTD=0 D UNK:IBOUK,EXP:'IBORPTD&IBOEXP,UNI:'IBORPTD&IBOUI,INDEX:IBORPTD
	Q
VET	; checks if patient is a vet
	S IBOQUIT=1 D ELIG^VADPT Q:VAERR  S:VAEL(4) IBOQUIT=0
	Q
DONE	; checks if patient already on report
	S:$D(^TMP($J,"PATIENTS",DFN)) IBOQUIT=1
	Q
STATUS	; checks if appt status="",otherwise should not be on report
	S:($P($G(^DPT(DFN,"S",IBOTIME,0)),"^",2)]"") IBOQUIT=1
	Q
INDEX	; indexes appointment,also indexs vet so he won't be reported
	S IBONAME=$P($G(^DPT(DFN,0)),"^",1) Q:IBONAME'[""
	S ^TMP($J,IBOCTG,IBODIV,IBOCLN,IBONAME,DFN)=IBOTIME
	S ^TMP($J,"PATIENTS",DFN)=""
	Q
UNK	; goes in 'unknown' category if the field COVERED BY HEALTH INSURANCE
	; was not answered, was answered unknown, and there is no insurance data
	S IBORPTD=0 N T S T=$P($G(^DPT(DFN,.31)),"^",11) I T="U"!(T="") D CKINS I 'IBOINS S IBOCTG="UNKNOWN",IBORPTD=1 Q
	Q
EXP	; goes in expired category only if there is insurance and
	; all of it expired before end of specified period + 30 days
	S IBORPTD=0 N T,E D CKINS Q:'IBOINS
	S IBORPTD=1,IBOCTG="EXPIRED" F T=0:0 S T=$O(^DPT(DFN,.312,T)) Q:T'>0  S E=$P($G(^(T,0)),"^",4) I E=""!(E>IBOEND2) S IBORPTD=0 Q
	Q
UNI	; goes in unisured category if there is no insurance data and 
	; the field COVERED BY HEALTH INSURANCE was answered YES or NO
	S IBORPTD=0 N T S T=$P($G(^DPT(DFN,.31)),"^",11) I T="N"!(T="Y") D CKINS I 'IBOINS S IBOCTG="NO",IBORPTD=1
	Q
CKINS	; checks if any insurance in insurance multiple of patient record
	S IBOINS=0 I $O(^DPT(DFN,.312,0)) S IBOINS=1
	Q
