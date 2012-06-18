APCLVLP1 ; IHS/CMI/LAB - CONT OF APCLVLP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
COVPAGE ;EP
 ;W:$D(IOF) @IOF
 W !?20,"PCC MANAGEMENT REPORTS ",$S(APCLPTVS="P":"PATIENT",1:"VISIT")," ",$S(APCLCTYP="D":"LISTING",1:"COUNT")
 W !?34,"SUMMARY PAGE"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U),!
SHOW ;
 W !,$S(APCLPTVS="P":"PATIENT",1:"VISIT")," Selection Criteria"
 W:APCLTYPE["V" !?6,"Encounter Date range:  ",APCLBDD," to ",APCLEDD
 I APCLTYPE="VP"!(APCLTYPE="VV")!(APCLTYPE="PS") W !!?6,"Search Template used: ",$P(^DIBT(APCLSEAT,0),U),!
 I APCLTYPE="PR"!(APCLTYPE="VR") W !!?6,"CMS Register: ",$P(^ACM(41.1,APCLCMSR,0),U) I $D(APCLCMSS) W "    Status: ",$O(APCLCMSS(""))
 I '$D(^APCLVRPT(APCLRPT,11)) G SHOWP
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,11,APCLI)) Q:APCLI'=+APCLI  D
 .I $Y>(IOSL-5) D PAUSE^APCLVL01 W @IOF
 .W !?6,$P(^APCLVSTS(APCLI,0),U),":  "
 .K APCLQ S APCLY="",C=0 K APCLQ F  S APCLY=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",APCLY)) S C=C+1 W:C'=1&(APCLY'="") " ; " Q:APCLY=""!($D(APCLQ))  S X=APCLY X:$D(^APCLVSTS(APCLI,2)) ^(2) W X
 K APCLQ
SHOWP ;
 W !!,"REPORT/OUTPUT TYPE",!
 I APCLCTYP="F" D  D PAUSE^APCLVL01 W @IOF Q
 .W ?6,"A File of records called ",APCLOUTF," will be created."
 .W !?6,"Total number of visits counted is ",APCLRCNT,"."
 I APCLCTYP="T" D COUNT Q
 I APCLCTYP="C"!(APCLCTYP="P") W !,?6,"SEARCH TEMPLATE Created: "_$P(^DIBT(APCLSTMP,0),U),!
 I APCLCTYP="C"&(APCLPTVS="P") D COUNT D SETRECS^APCLSTMP Q
 I APCLCTYP="P" D COUNT D SETRECS^APCLSTMP Q
 I APCLCTYP="C"&(APCLPTVS="V") D COUNT D SETRECS^APCLSTMV Q
 I APCLCTYP="S" D  I 1
 .I $Y>(IOSL-6) D PAUSE^APCLVL01 W @IOF
 .W ?6,"Report will contain sub-totals by ",$P(^APCLVSTS(APCLSORT,0),U)," and ",!?6,"total counts."
 .I '$D(^XTMP("APCLVL",APCLJOB,APCLBTH)) W !!,"NO DATA TO REPORT.",! D PAUSE^APCLVL01 W:$D(IOF) @IOF
 .Q
 I APCLCTYP'="D",APCLCTYP'="L" D PAUSE^APCLVL01 W:$D(IOF) @IOF Q
 I $Y>(IOSL-4) D PAUSE^APCLVL01 W @IOF
 I APCLCTYP="D" W ?6,"Detailed Listing containing"
 I APCLCTYP="L" D
 .W !?5,"PLEASE NOTE:  The first column of the delimited output will always"
 .W !?5,"              be the patient internal entry number which uniquely"
 .W !?5,"              identifies the patient.  If this is a VISIT general"
 .W !?5,"              retrieval the second column will always be the visit"
 .W !?5,"              internal entry number which uniquely identifies the visit.",!
 .W ?6,"A File of records called ",APCLDELF," will be created."
 I APCLCTYP="L" W !?6,"Delimited output file will contain:"
 I '$D(^APCLVRPT(APCLRPT,12)) G PAUSE
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,12,APCLI)) Q:APCLI'=+APCLI  S APCLCRIT=$P(^APCLVRPT(APCLRPT,12,APCLI,0),U) D
 .I $Y>(IOSL-4) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 .W !?6,$P(^APCLVSTS(APCLCRIT,0),U) I APCLCTYP="D" W "  (" S X=$O(^APCLVRPT(APCLRPT,12,"B",APCLCRIT,"")) W $P(^APCLVRPT(APCLRPT,12,X,0),U,2),")"
 I $Y>(IOSL-4) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 I APCLCTYP="D" W !?10,"     TOTAL column width: ",APCLTCW
 Q:'$G(APCLSORT)
 I $Y>(IOSL-4) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 W !!,$S(APCLPTVS="V":"Visits",1:"Patients")," will be SORTED by:  ",$P(^APCLVSTS(APCLSORT,0),U),!
 I $Y>(IOSL-4) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 I $G(APCLSPAG) W !?6,"Each ",$P(^APCLVSTS(APCLSORT,0),U)," will be on a separate page.",!
 I '$D(^XTMP("APCLVL",APCLJOB,APCLBTH)) W !!,"NO DATA TO REPORT.",!
 I APCLCTYP="L" D
 .I $D(APCLRCNT) W !!!,"Total ",$S(APCLPTVS="P":"Patients",1:"Visits"),":  ",APCLRCNT
 .I $G(APCLPTVS)="V" W !,"Total Patients:  ",APCLPTCT
PAUSE D PAUSE^APCLVL01 W:$D(IOF) @IOF
 Q
COUNT ;if COUNTING entries only   
 I $Y>(IOSL-5) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 W ?6,"Totals Displayed"
 I '$D(^XTMP("APCLVL",APCLJOB,APCLBTH)) W !!!,"NO DATA TO REPORT.",!
 W:$D(APCLRCNT) !!!?6,"Total COUNT of ",$S(APCLPTVS="P":"Patients",1:"Visits"),":  ",?34,APCLRCNT
 W:APCLPTVS="V" !?6,"Total COUNT of Patients:  ",?34,APCLPTCT
 Q
WP ;EP - Entry point to print wp fields pass node in APCLNODE
 ;PASS FILE IN APCLFILE, ENTRY IN APCLDA
 K ^UTILITY($J,"W")
 S APCLRLX=0
 S APCLG1=^DIC(APCLFILE,0,"GL"),APCLG=APCLG1_APCLDA_","_APCLNODE_",APCLRLX)",APCLGR=APCLG1_APCLDA_","_APCLNODE_",APCLRLX"
 S DIWL=1,DIWR=$P(^APCLVRPT(APCLRPT,12,APCLI,0),U,2) F  S APCLRLX=$O(@APCLG) Q:APCLRLX'=+APCLRLX  D
 .S Y=APCLGR_",0)" S X=@Y D ^DIWP
 .Q
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=^UTILITY($J,"W",DIWL,Z,0)
 S APCLPCNT=APCLPCNT+1
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),APCLNODE,APCLFILE,APCLDA,APCLG1,APCLGR,APCLRLX
 Q
