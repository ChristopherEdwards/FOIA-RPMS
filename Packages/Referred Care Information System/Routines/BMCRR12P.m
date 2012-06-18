BMCRR12P ; IHS/PHXAO/TMJ - PRNT BILL VSTS ;     [ 09/27/2006  2:04 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**1**;JAN 09, 2006
 ;4.0*1 3.8.06 IHS/OIT/FCJ REWROTE SECTION TO PRT PROV IN ALPHA ORDR
 ;
START ;
 S BMC80E="==============================================================================="
 S BMC80D="-------------------------------------------------------------------------------"
 S BMCPG=0 D @("HEAD"_(2-($E(IOST,1,2)="C-"))) I '$D(^XTMP("BMCRR12",BMCJOB,BMCBT)) W !,"No data to report",! G DONE
 S BMCPN=0 K BMCQUIT
 ;4.0*1 3.8.06 IHS/OIT/FCJ REWROTE NXT SECTION TO PRT PROV IN ALPHA ORDR
 I BMCTYPE="P" S BMCSORT=0 D
 .F  S BMCSORT=$O(^XTMP("BMCRR12",BMCJOB,BMCBT,"REFERRALS",BMCSORT)) Q:BMCSORT=""!($D(BMCQUIT))  S BMCPN=0 D
 ..F  S BMCPN=$O(^XTMP("BMCRR12",BMCJOB,BMCBT,"REFERRALS",BMCSORT,BMCPN)) Q:BMCPN=""!($D(BMCQUIT))  S BMCX=^XTMP("BMCRR12",BMCJOB,BMCBT,"REFERRALS",BMCPN) D PROC
 E  F  S BMCPN=$O(^XTMP("BMCRR12",BMCJOB,BMCBT,"REFERRALS",BMCPN)) Q:BMCPN=""!($D(BMCQUIT))  S BMCX=^XTMP("BMCRR12",BMCJOB,BMCBT,"REFERRALS",BMCPN) D PROC
 ;4.0*1 3.8.06 IHS/OIT/FCJ END OF REWRITE
 I $Y>(IOSL-5) D HEAD G:$D(BMCQUIT) DONE
 I BMCTCOST="A" W !!,"** These costs only include actual known costs to date.  The costs",!,"may therefore increase as bills are received and paid",!
 I BMCTCOST="B" W !!,"** These costs are based on best available data (actual or estimates).",!,"Actual completed costs may vary from this.",!
DONE ;
 K ^XTMP("BMCRR12",BMCJOB,BMCBT)
 D DONE^BMCRLP2
 Q
PROC ;
 I $Y>(IOSL-5) D HEAD Q:$D(BMCQUIT)
 S X=$S(BMCTYPE="P":$P(^VA(200,BMCPN,0),U),1:$P(^DIC(4,BMCPN,0),U))
 W !,$E(X,1,20),?24,$J($P(BMCX,U),5)
 W ?34,$J($P(BMCX,U,2),5)
 S X=$P(BMCX,U,3),X2="$2" D COMMA^%DTC W ?38,X
 S X=$S($D(^XTMP("BMCRR12",BMCJOB,BMCBT,"PCC VISITS",BMCPN)):^(BMCPN),1:0)
 W ?53,$J(X,6)
 I X W ?66,$J(($P(BMCX,U,3)/X)*100,7,0)
 Q
HEAD ;ENTRY POINT
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BMCQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
HEAD2 ;
 S BMCPG=BMCPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?72,"Page ",BMCPG,!!
 W ?19,"CHS REFERRAL COSTS** BY REQUESTING ",$S(BMCTYPE="P":"PROVIDER",1:"FACILITY"),!
 S Y=DT D DD^%DT W ?(80-$L(Y)/2),Y
 S Y=BMCBD D DD^%DT W !,?28,"BEG DATE: "_Y
 S Y=BMCED D DD^%DT W !,?28,"END DATE: "_Y,!
 W !,$S(BMCTYPE="P":"PROVIDER",1:"FACILITY"),?23,"# REFS",?34,"# CHS",?42,"TOTAL CHS",?53,"# PCC",?61,"CHS REF COST"
 W !,?23,"INITIATED",?35,"REFS",?42,"REF COST",?53,"VISITS",?61,"PER 100 PCC VISITS"
 W !,BMC80D
 Q
