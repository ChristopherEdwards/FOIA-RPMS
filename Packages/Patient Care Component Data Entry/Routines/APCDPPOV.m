APCDPPOV ; IHS/CMI/LAB - post selection on V POV ;  
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
AGE ;IF THERE IS AGE CRITERIA DATA AVAILABLE CHECK TO SEE THAT IT FITS THE CRITERIA
 Q:$D(APCDTACC)
 Q:'$D(APCDTPCC)
 G:'$D(AUPNDAYS) XIT
 S APCDSY=Y,APCDY=+Y
 ;G:'$D(^ICD9(APCDY,9999999)) XIT
 ;I $P(^ICD9(APCDY,9999999),U)]"",($P(^ICD9(APCDY,9999999),U)>AUPNDAYS) D ACCEPT
 ;I $P(^ICD9(APCDY,9999999),U,2)]"",($P(^ICD9(APCDY,9999999),U,2)<AUPNDAYS) D ACCEPT
 NEW %,A,B
 S %=$$ICDDX^ICDCODE(APCDY)
 S (A,B)=""  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A=$P(%,U,15),B=$P(%,U,16)  ;CSV
 E  S A=$P($G(^ICD9(APCDY,9999999)),U),B=$P($G(^ICD9(APCDY,9999999)),U,2)
 I A]"",A>AUPNDAYS D ACCEPT
 I B]"",B<AUPNDAYS D ACCEPT
 D XIT
 Q
ACCEPT ;
 I $D(AUPNTALK) S APCDTACC="" Q
 I $D(ZTQUEUED) S APCDTACC="" Q
 W !!,$C(7),$C(7),"WARNING:  The Patient's age is outside the IHS edit age range for this ICD Code!",!
 I $D(AUPNDOB) S Y=AUPNDOB D DD^%DT S APCDRDOB=Y
 W "Patient's DOB:  ",$G(APCDRDOB),?35,"Patient's Age in Days:  ",AUPNDAYS,!,"ICD9 Edit Lower Age:  ",A,?35,"ICD9 Edit Upper Age:  ",B
 I APCDCAT="H",'$D(^APCDINPT(9,11,"AC",$P(^ICD9(APCDY,0),U))) W !!,"An ACCEPT command is not allowed for this code.  Refer to IHS Direct",!,"Inpatient Edit Documentation for further explanation.  You cannot use this code.",! S Y=-1 Q
 W !!,"Do you still want to use this code" S %=2 D YN^DICN I %'=1 S Y=-1 Q
 S APCDTACC=""
 Q
XIT ;
 I Y'=-1,$D(APCDSY) S Y=APCDSY
 K APCDY,APCDRDOB,APCDSY
 Q
