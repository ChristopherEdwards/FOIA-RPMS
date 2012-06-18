APCLAGE ; IHS/CMI/LAB - Age bucker driver ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This routine will print the PCC Report that uses age buckets
 ;to tabulate sex,tribe or current community by age.
 ;
 ;Calls APCLBIN1
 ;Called from option APCL P BIN AGE BUCKETS
 ;
START ;
 S APCLPG=0
 W:$D(IOF) @IOF
 K ^TMP("APCLAGE",$J)
 W !,"This report will present, for all Living Patients registered at the facility",!,"that you select, age groups for a selected attribute.",!
 S Y=DT D DD^%DT S APCLDT=Y
F ;
 S DIC("A")="Include Patients Registered at Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 EOJ
 S APCLSITE=+Y
MENU ;
 S DIR(0)="S^1:SEX;2:CURRENT COMMUNITY;3:TRIBE OF MEMBERSHIP",DIR("A")="Present Age groups by" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G F
 I $T(@Y)="" D HELP G MENU
 S APCLZ=$T(@X)
 ;
BIN D SETBIN
 W !,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="YO",DIR("A")="Do you wish to modify these age groups",DIR("B")="No" D ^DIR K DIR
 I $D(DIRUT) G MENU
 I Y=0 G PRNT
 W !!,$C(7),"WARNING:  If you use more than 8 age groups the report will wrap around",!,"the page.  Only 8 will fit on an 80 column screen or page!!",!
RUN ;
 K APCLQUIT S APCLY="",APCLA=-1 W ! F  D AGE Q:APCLX=""  I $D(APCLQUIT) G BIN
 D CLOSE I $D(APCLQUIT) G BIN
 D LIST
 G PRNT
 ;
AGE ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the starting age of the "_$S(APCLY="":"first",1:"next")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S (APCLQUIT,APCLX)="" Q
 S APCLX=Y
 I Y="" Q
 I APCLX?1.3N,APCLX>APCLA D SET Q
 W $C(7) W !,"Make sure the age is higher the beginning age of the previous group.",! G RUN
 ;
SET S APCLA=APCLX
 I APCLY="" S APCLY=APCLX Q
 S APCLY=APCLY_":"_(APCLX-1)_";"_APCLX
 Q
 ;
CLOSE I APCLY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S APCLQUIT="" Q
 S APCLX=Y I Y="" S APCLX=199
 I APCLX?1.3N,APCLX'<APCLA S APCLY=APCLY_":"_APCLX,APCLAGEG=APCLY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
 ;
LIST ;
 S %=APCLAGEG
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,":")," - ",$P(X,":",2)
 W !
 Q
 ;
PRNT ;
 S APCLTEMP=$P(APCLZ,";;",3) I APCLTEMP="" W !!,$C(7),$C(7),"TEMPLATE MISSING",! D EOJ Q
 S DIS(0)="I 1",DIS(1)="I '$D(^DPT(D0,.35)),$D(^AUPNPAT(D0,41,APCLSITE))",DIS(2)="I $D(^DPT(D0,.35)),$P(^DPT(D0,.35),U)="""",$D(^AUPNPAT(D0,41,APCLSITE))"
 S FLDS="["_APCLTEMP_"]"
 S L=0,FR="",BY="@NUMBER",DIC=$P(APCLZ,";;",4),APCLHDR=$P(APCLZ,";;",2)
 D EN1^DIP
EOJ ;ENTRY POINT
 K ^TMP("APCLAGE",$J)
 K APCLAGEG
 W:$D(IOF) @IOF
 K APCLSITE,APCLTEMP,APCLX,APCLY,APCLHDR,APCLHDRL,APCLA,APCLZ,APCLDT,APCLQUIT,APCLPG
 K %,X,Y,%F,Z,DCC,DHD,DIS,DISH,DIPT,DINS,DR,FLDS,TO,BY,FR
 Q
 ;
 ;
HDR ;EP -Header
 S APCLPG=APCLPG+1
 S APCLHDRL=(13+$L(APCLHDR))
 W ?((80-APCLHDRL)/2),APCLHDR," By AGE GROUP",?71,"Page ",APCLPG,!
 S APCLHDRL=(34+$L($P(^DIC(4,APCLSITE,0),U)))
 W ?((80-APCLHDRL)/2),"All Living Patients Registered at ",$P(^DIC(4,APCLSITE,0),U),!
 W ?(80-$L(APCLDT)/2),APCLDT,!
 W !?35,"AGE GROUPS",!
 Q
HELP ;
 W !,"Choose a number from the menu presented.  The item selected will be ",!,"displayed in a matrix by age groups.",!
 Q
SETBIN ;
 S APCLAGEG="0:0;1:4;5:14;15:19;20:24;25:44;45:64;65:125"
 Q
 ;
1 ;;SEX;;APCL P BIN SEX;;^DPT(
2 ;;CURRENT COMMUNITY;;APCL P BIN CURRENT COMM;;^AUPNPAT(
3 ;;TRIBE OF MEMBERSHIP;;APCL P BIN TRIBE;;^AUPNPAT(
