APCPREG ; IHS/TUCSON/LAB - OHPRD-TUCSON/LAB - Check Registration export AUGUST 14, 1992 ; [ 04/03/98  08:39 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;;APR 03, 1998
CHKREG ; Code to check and see if a Registration tape has been
 ; created for all dates in this PCC tape range
 S (APCP("REG END"),APCP("REG"))="",APCP("RDFN")=0
 I '$D(^AGTXST(DUZ(2))) W:$D(ZTQUEUED) !!,$C(7),$C(7),"Patient Registration Transmission for this Facility has not been activated.",!,"No PCC Transmission can be done!  NOTIFY YOUR SUPERVISOR",! S APCP("QFLG")=19 Q
 F  S APCP("RDFN")=$O(^AGTXST(DUZ(2),1,APCP("RDFN"))) Q:APCP("RDFN")'=+APCP("RDFN")!(APCP("REG")=1)  S APCP("REG END")=$P(^AGTXST(DUZ(2),1,APCP("RDFN"),0),U) D CHKDATE
 I APCP("REG")="" S APCP("QFLG")=20 D REGINF
 K APCP("REG END"),APCP("REG"),APCP("RDFN")
 Q
CHKDATE ;
 I APCP("REG END")'<APCP("RUN END") S APCP("REG")=1
 Q
REGINF ;
 Q:$D(ZTQUEUED)
 W $C(7),$C(7),!!,"A Patient Registration Tape that includes all of the dates in the PCC",!,"date range has not been created!",!,"You cannot create a PCC tape until a Patient Registration tape has been created."
 W !,"SEE YOUR SUPERVISOR FOR ASSISTANCE",!
 Q
