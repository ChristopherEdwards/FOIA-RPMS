APCDEGP2 ; IHS/CMI/LAB - CONT. OF GROUP FORM DATA ENTRY ; 02 Mar 2010  9:13 AM
 ;;2.0;IHS PCC SUITE;**1**;MAY 14, 2009
EDITCHKS ;EP;check and edit visit/pov info
 W !,"Checking Visit and POV data for this Patient...",!
 K AUPNTALK,APCDEFLG
VISIT ;
 S X=APCDDATE
 X $P(^DD(9000010,.01,0),U,5,99)
 I '$D(X) W !,APCDBEEP,APCDBEEP,?5,"A VISIT Cannot be Created for this Patient!",!?5,"You Must Correct any Problems and Re-Enter this VISIT through ENTER MODE!",! S APCDEFLG="" Q
CHKPOVS ;
 S APCDEGX=0 F  S APCDEGX=$O(^TMP("APCDEGP",$J,"POV",APCDEGX)) Q:APCDEGX=""  D CHKPOV1
 I $D(APCDEFLG) W !,APCDBEEP,APCDBEEP,?5,"One of the PURPOSE of VISITS is INVALID for this Patient!!",!?5,"You must Correct any Problems and Re-Enter this VISIT through ENTER MODE!" Q
 Q
CHKPOV1 ;
 K APCDTACC
 S (APCDEGY,Y)=$P($P(^TMP("APCDEGP",$J,"POV",APCDEGX,"APCDTPOV"),U),"`",2)
 D ^AUPNSICD
 I '$T S APCDEFLG="" Q
AGEEDIT ;
 Q:'$D(AUPNDAYS)
 ;Q:'$D(^ICD9(APCDEGY,9999999))
 ;I $P(^ICD9(APCDEGY,9999999),U)]"",($P(^ICD9(APCDEGY,9999999),U)>AUPNDAYS) D ACCEPT
 ;I $P(^ICD9(APCDEGY,9999999),U,2)]"",($P(^ICD9(APCDEGY,9999999),U,2)<AUPNDAYS) D ACCEPT
 S %=$$ICDDX^ICDCODE(APCDEGY)
 S (A,B)=""  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A=$P(%,U,15),B=$P(%,U,16)  ;CSV
 E  S A=$P($G(^ICD9(APCDEGY,9999999)),U),B=$P($G(^ICD9(APCDEGY,9999999)),U,2)
 I A]"",A>AUPNDAYS D ACCEPT
 I B]"",B<AUPNDAYS D ACCEPT
 Q
ACCEPT ;
 W !!,$C(7),$C(7),"WARNING:  The Patient's age is outside the IHS edit age range",!,"for this ICD Code:  ",@APCDRVON,$P($$ICDDX^ICDCODE(APCDEGY),U,2),@APCDRVOF,!
 I $D(AUPNDOB) S Y=AUPNDOB D DD^%DT S APCDRDOB=Y
 ;W "Patient's DOB:  ",$G(APCDRDOB),?35,"Patient's Age in Days:  ",AUPNDAYS,!,"ICD9 Edit Lower Age:  ",$P(^ICD9(APCDEGY,9999999),U),?35,"ICD9 Edit Upper Age:  ",$P(^ICD9(APCDEGY,9999999),U,2)
 W "Patient's DOB:  ",$G(APCDRDOB),?35,"Patient's Age in Days:  ",AUPNDAYS,!
 S %=$$ICDDX^ICDCODE(APCDEGY)
 S (A,B)=""  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A=$P(%,U,14),B=$P(%,U,15)  ;CSV
 E  S A=$P($G(^ICD9(APCDEGY,9999999)),U),B=$P($G(^ICD9(APCDEGY,9999999)),U,2)
 W "ICD9 Edit Lower Age:  ",A,?35,"ICD9 Edit Upper Age:  ",B
 W !!,"Do you still want to use this code" S %=2 D YN^DICN I %'=1 S Y=-1 S APCDEFLG="" Q
 S APCDTACC=""
 Q
