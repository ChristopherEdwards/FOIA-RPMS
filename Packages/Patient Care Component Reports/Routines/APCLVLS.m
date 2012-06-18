APCLVLS ; IHS/CMI/LAB - APC visit counts - show screens ; 29 Jun 2009  7:10 AM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
SHOWP ;EP
 I '$D(APCLDONE) W:$D(IOF) @IOF
 W !!?6,"REPORT/OUTPUT Type:"
 I APCLCTYP="S" W !,?12,"Report includes sub-totals by ",$G(APCLSORV)," and total count." Q
 I APCLCTYP="T" W !,?12,"Report will include total only." Q
 I APCLCTYP="C" W !?12,"SEARCH TEMPLATE ",$P(^DIBT(APCLSTMP,0),U)," will be created.",!?12,"Total record count will be displayed." Q
 I APCLCTYP="F" W !?12,"FLAT file of Area Database formatted records will be created.",!?12,"File Name: ",APCLOUTF
 Q:'$D(^APCLVRPT(APCLRPT,12))
 W !?12,"PRINT Items Selected:"
 S (APCLI,APCLTCW)=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,12,APCLI)) Q:APCLI'=+APCLI  S APCLCRIT=$P(^APCLVRPT(APCLRPT,12,APCLI,0),U) D
 .W !?12,$P(^APCLVSTS(APCLCRIT,0),U)," - column width ",$P(^APCLVRPT(APCLRPT,12,APCLI,0),U,2) S APCLTCW=APCLTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 W !?12,"Total Report width (including column margins - 2 spaces):   ",APCLTCW
 Q
SHOW ;EP
 W:$D(IOF) @IOF
 I $D(APCLDONE) S APCLLHDR="REPORT SUMMARY" W ?((80-$L(APCLLHDR))/2),APCLLHDR,!
 W !!?6,$S(APCLPTVS="V":"VISIT",1:"PATIENT")_" Selection Criteria:"
 W:APCLTYPE="VV" !?12,"VISIT Search Template: ",$P(^DIBT(APCLSEAT,0),U)
 W:APCLTYPE="VP" !?12,"PATIENT Search Template: ",$P(^DIBT(APCLSEAT,0),U)
 W:APCLTYPE["V" !?12,"Encounter Date range:  ",APCLBDD," to ",APCLEDD
 W:APCLTYPE="PS" !?12,"PATIENT Search Template: ",$P(^DIBT(APCLSEAT,0),U)
 I APCLTYPE="PR"!(APCLTYPE="VR") W !!?6,"CMS Register: ",$P(^ACM(41.1,APCLCMSR,0),U) I $D(APCLCMSS) W "    Status: ",$O(APCLCMSS(""))
 Q:'$D(^APCLVRPT(APCLRPT,11))
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,11,APCLI)) Q:APCLI'=+APCLI  D
 .I $Y>(IOSL-5) D PAUSE^APCLVL01 W @IOF
 .W !?12,$P(^APCLVSTS(APCLI,0),U),":  "
 .K APCLQ
 .S APCLY="",APCLC=0 K APCLQ F  S APCLY=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",APCLY)) S APCLC=APCLC+1 Q:APCLY=""!($D(APCLQ))  S APCLZ=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",APCLY,0)) W:APCLC'=1 " ; " S X=APCLY X:$D(^APCLVSTS(APCLI,2)) ^(2) W X
 K APCLC,APCLQ
 Q
SHOWR ;EP
 I '$D(APCLDONE) W:$D(IOF) @IOF
 W !!?6,"SORTING Item:"
 I APCLCTYP="T" W !?12,"Total only will be displayed, no sorting done.",! Q
 I APCLCTYP="C" W !?12,"Search Template being created, no sorting done.",! Q
 ;W:APCLTYPE="D"&('$D(APCLDONE)) !?12,"Encounter Date range:  ",APCLBDD," to ",APCLEDD
 ;W:APCLTYPE="S"&('$D(APCLDONE)) !?12,"Search Template: ",$P(^DIBT(APCLSEAT,0),U)
 Q:'$G(APCLSORT)
 W !?12,$S(APCLPTVS="V":"Visits",1:"Patients")_" will be sorted by:  ",$P(^APCLVSTS(APCLSORT,0),U),!
 Q
