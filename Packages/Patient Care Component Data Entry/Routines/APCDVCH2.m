APCDVCH2 ; IHS/CMI/LAB - CONT. HOSP REVIEW ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 D CHKADM
 D CHKTS
 D CHKAGE
 D DATES
 ;
XIT ;
 Q
 ;
 ;
ERR ;
 D ERR^APCDRV
 Q
CHKTS ;
 I $P(APCDVINR,U,12)="" W !,$C(7),"WARNING:  Admitting Diagnosis is Missing!",!
 I APCDTS="07",AUPNDAYS]"",AUPNDAYS>1 W !!,"WARNING: Admitting or Discharge Service cannot be NEWBORN if Patient is over 1 day old.",!
 I APCDTS="11",AUPNDAYS]"",AUPNDAYS>5479 W !!,"WARNING: Admitting Service is PEDIATRICS (11) and the patient is over 15 years old.",!,"Please Review.",!
 I APCDTS="05"!(APCDTS="08"),AUPNSEX'="F" W !!,$C(7),$C(7),"Patient Must be FEMALE if Admitting Service is OBSTETRICS (08) or ",!,"GYNEGOLOGY (05)!",!
 ;I APCDDS="08",AUPNDAYS]"",(AUPNDAYS<3652!(AUPNDAYS>20088)) W !!,$C(7),$C(7),"This Patient's age is outside the IHS edit range for Admitting/Discharge",!,"Service 08!  Please Review!",!
 I APCDDS="11",AUPNDAYS]"",AUPNDAYS>5479 W !!,"WARNING: Discharge Service PEDIATRICS (11) and the patient is over",!,"15 years old!  Please review.",!
 I APCDDS="05"!(APCDDS="08"),AUPNSEX'="F" W !!,$C(7),$C(7),"Patient Must be FEMALE if Discharge Service is OBSTETRICS (08) or ",!,"GYNEGOLOGY (05)!",!
 ;I APCDDS="08",AUPNDAYS]"",(AUPNDAYS<3652!(AUPNDAYS>20088)) W !!,$C(7),$C(7),"This Patient's age is outside the IHS edit range for Admitting/Discharge",!,"Service 08!  Please Review!",!
 Q
 ;
CHKAGE ;
 ;Q:$D(APCDACC)
 Q:AUPNDAYS>5
 I $E($P(APCDVCPV("P"),U),1,2)'="V3" W !,$C(7),$C(7),"WARNING:  The Admission Date is within 5 days of the DOB, Please Review.",!
 Q
CHKADM ;check admission date
 S APCDDIS=$P($P(APCDVINR,U),"."),APCDADM=$P($P(APCDVREC,U),".")
 I APCDDIS<APCDADM W !!,"Admission Date is less than Discharge Date!!",! Q
 Q:APCDADM'=AUPNDOB
 ;Q:$D(APCDACC)
 I $E($P(APCDVCPV("P"),U),1,2)'="V3" W !,$C(7),$C(7),"WARNING:  DOB is equal to Admission Date and 1st DX is NOT V30-V39.  PLEASE REVIEW.",!
 Q
 ;
DATES ;
 S X1=$P(APCDVINR,U),X2=$P(APCDVREC,U) D ^%DTC I X<0 W !,$C(7),"WARNING: Discharge Date MUST be greater than or equal to Admission Date!",!,"PLEASE CORRECT!",!
 I X>99 W !,$C(7),"WARNING: Length of Stay is > 99 days!.",!,"Notify your Supervisor!",!
 Q
