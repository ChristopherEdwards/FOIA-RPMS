APCDFCTP ; IHS/CMI/LAB - print apc report by prov disc ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 S APCD80S="-------------------------------------------------------------------------------",APCDPG=0
 S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 S (APCDTOT,APCDPROV,APCDTDES)=0
 K APCDQUIT
 I '$D(^XTMP("APCDFCT",APCDJOB,APCDBT)) S APCDPROV="NONE TO REPORT" D HEAD G DONE
 F  S APCDPROV=$O(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV)) Q:APCDPROV=""!($D(APCDQUIT))  D HEAD Q:$D(APCDQUIT)  D SORT
 G:$D(APCDQUIT) DONE
 I $Y>(IOSL-5) D HEAD G:$D(APCDQUIT) DONE
 W !?42,"------",?52,"-------",?65,"------",!
 W ?5,"Grand Total for ALL Operators:",?42,$J(APCDTOT,6),?52,$J(APCDTDES,7) S APCDAVG=APCDTDES/APCDTOT W ?65,$J(APCDAVG,6,1)
 D SUMMPAGE
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
 K ^XTMP("APCDFCT",APCDJOB,APCDBT),APCDJOB,APCDBT
 Q
SORT ;
 S (APCDSUB,APCDDESU)=0,APCDFCT("DAYS",APCDPROV)=0
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT)) Q:APCDSORT=""!($D(APCDQUIT))  D SORT1
 W !?42,"------",?52,"-------",?65,"------",!
 W ?5,"Totals for ",APCDPROV,?42,$J(APCDSUB,6),?52,$J(APCDDESU,7),?65,$J((APCDDESU/APCDSUB),6,1)
 S APCDFCT("FORMS",APCDPROV)=APCDSUB
 S APCDFCT("AVG DEC",APCDPROV)=$J((APCDDESU/APCDSUB),6,1)
 Q
SORT1 ;
 I $Y>(IOSL-6) D HEAD Q:$D(APCDQUIT)
 W !,$S(APCDSRT]"":APCDSORT,1:"")
 S APCDDATE=0 F  S APCDDATE=$O(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,APCDDATE)) Q:APCDDATE'=+APCDDATE!($D(APCDQUIT))  D WRITE
 Q
 ;
WRITE ;
 S Y=APCDDATE D DD^%DT S APCDWDAT=Y
 I $Y>(IOSL-5) D HEAD Q:$D(APCDQUIT)
 S APCDVDES=^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,"DEP COUNT",APCDDATE),APCDAVG=(APCDVDES/^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,APCDDATE))\1
 W ?25,APCDWDAT,?42,$J(^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,APCDDATE),6),?52,$J(APCDVDES,7),?65,$J(APCDAVG,6),!
 S APCDSUB=APCDSUB+^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,APCDDATE),APCDTOT=APCDTOT+^XTMP("APCDFCT",APCDJOB,APCDBT,APCDPROV,APCDSORT,APCDDATE),APCDDESU=APCDDESU+APCDVDES,APCDTDES=APCDTDES+APCDVDES
 S APCDFCT("DAYS",APCDPROV)=APCDFCT("DAYS",APCDPROV)+1
 Q
SUMMPAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !?55,$$FMTE^XLFDT(DT),?70,"Page ",APCDPG
 W !?20,"SUMMARY OF FORMS KEYED BY ALL OPERATORS"
 W !?15,"VISIT POSTING DATES:  ",APCDBDD,"  TO  ",APCDEDD,!
 W !?35,"No. of",?43,"Forms",?53,"% of",?65,"Avg # of"
 W !?11,"Operator",?35,"Forms",?43,"per day",?53,"Workload",?65,"tran codes ent"
 W !,APCD80S
 S X="" F  S X=$O(APCDFCT("FORMS",X)) Q:X=""  W !,X,?32,$J(APCDFCT("FORMS",X),8),?40,$J((APCDFCT("FORMS",X)/APCDFCT("DAYS",X)),8,1),?51,$J(((APCDFCT("FORMS",X)/APCDTOT)*100),8,1),?67,APCDFCT("AVG DEC",X)
 W !?35,"--------",!?32,$J(APCDTOT,8)
 Q
HEAD I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W @IOF S APCDPG=APCDPG+1
 W !?55,$$FMTE^XLFDT(DT),?70,"Page ",APCDPG,!
 S APCDLENG=$L($P(^DIC(4,DUZ(2),0),U))
 W ?((80-APCDLENG)/2),$P(^DIC(4,DUZ(2),0),U),!
 S APCDLENG=37+$L(APCDSRT)
 I APCDSRT]"" W ?((80-APCDLENG)/2),"NUMBER OF FORMS KEYED SUBTOTALED BY ",APCDSRT,!
 I APCDSRT="" W ?29,"NUMBER OF FORMS KEYED",!
 S APCDLENG=21+$L(APCDPROV)
 W ?((80-APCDLENG)/2),"DATE ENTRY OPERATOR:  ",APCDPROV,!
 W ?15,"VISIT POSTING DATES:  ",APCDBDD,"  TO  ",APCDEDD,!
 W !,APCDSRT,?25,"POSTING DATE",?40,"# FORMS",?50,"# TRANS",?63,"AVG # TRAN ENT",!
 W APCD80S,!
 Q