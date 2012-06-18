BMCRR6P ; IHS/PHXAO/TMJ - PRNT BILL VSTS ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
START ;
 S BMCPG=0 D @("HEAD"_(2-($E(IOST,1,2)="C-"))) I '$D(^XTMP("BMCRR6",BMCJOB,BMCBT)) W !,"No referrals to report",! G DONE
 S BMCF=0 K BMCQUIT
 F  S BMCF=$O(^XTMP("BMCRR6",BMCJOB,BMCBT,"REFERRALS",BMCF)) Q:BMCF=""!($D(BMCQUIT))  D PRINT
 G:$D(BMCQUIT) DONE
 I $Y>(IOSL-6) D HEAD G:$D(BMCQUIT) DONE
DONE ;
 K ^XTMP("BMCRR6",BMCJOB,BMCBT)
 D DONE^BMCRLP2
 Q
PRINT ;print one referral
 I $Y>(IOSL-9) D HEAD Q:$D(BMCQUIT)
 W !,$E(BMCF,1,23) S T=$P(^XTMP("BMCRR6",BMCJOB,BMCBTH,"REFERRALS",BMCF),U) W ?25,$J(T,5) S %=$P(^(BMCF),U,2) W ?32,$J(%,5) F X=3:1:6 D
 .S J=38+(11*(X-3)),K=J+6
 .S Z=$P(^XTMP("BMCRR6",BMCJOB,BMCBTH,"REFERRALS",BMCF),U,X)
 .S Y=(Z/T)*100
 .W ?J,$J(Z,5),?K,$J(Y,3,0)
 .Q
 Q
HEAD ;ENTRY POINT
 W !!,"* any referral with an ending service date of less than 31 days ago is excluded.",!
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BMCQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
HEAD2 ;
 S BMCPG=BMCPG+1
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?72,"Page ",BMCPG,!
 W ?20,"TIMELINESS OF RECEIPT OF DISCHARGE LETTERS",!?30,"BY REFERRAL FACILITY"
 W !?10,"REFERRAL INITIATED DATE RANGE:  ",$$FMTE^XLFDT(BMCBD)," to ",$$FMTE^XLFDT(BMCED),!
 W !,"* any referral with an ending service date of less than 31 days ago is excluded.",!
 W !,?26,"TOTAL",?33,"NOT YET",?48,"RECEIVED WITH (#MONTHS)"
 W !,"REFERRAL FACILITY",?26,"REFS",?32,"RECD*",?43,"<1",?53,"1-3",?64,"4-6",?75,">6"
 W !?28,"N",?35,"N",?41,"N    %",?52,"N    %",?63,"N    %",?74,"N    %"
 W !,$TR($J(" ",80)," ","-")
 Q
