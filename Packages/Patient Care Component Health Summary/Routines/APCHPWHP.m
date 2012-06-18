APCHPWHP ; IHS/CMI/LAB - PURGE FORMS TRACKING DATA ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009;Build 1
 D INIT
 D GETDATE
 I $D(APCHQUIT) D EOJ Q
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EOJ Q
 I $D(DIRUT) D EOJ Q
DRIVER ;
 D PURGE
 W !!,"A Total of ",APCHCNT," Entries Purged.",!
 D EOJ
 Q
 ;
INIT ;
 W !!,"Purging Patient Wellness Handout Log!"
 W !!,"This option is used to purge the file that maintains an entry each time a"
 W !,"patient wellness handout is generated.  This log can grow very large over"
 W !,"time and older data can be purged from the file if that is desired.  It is"
 W !,"not necessary to do this but it will free up space on the disk drive.  If"
 W !,"you purge this file you will no longer be able to get a tally of handouts"
 W !,"generated for the date range that has been purged.",!
 S APCHCNT=0
 K APCHQUIT
 Q
 ;
GETDATE ;
 S Y=DT X ^DD("DD") S APCHDTP=Y
 S %DT("A")="Purge log up to and including what PWH Generation DATE?  ",%DT="AEPX" W ! D ^%DT
 I Y=-1 S APCHQUIT="" Q
 S APCHPGE=Y X ^DD("DD") S APCHPGEY=Y
 Q
 ;
PURGE ;
 S APCHX=0 F  S APCHX=$O(^APCHPWHL("AC",APCHX)) Q:APCHX=""!(APCHX>APCHPGE)  D
 .S APCHY=0 F  S APCHY=$O(^APCHPWHL("AC",APCHX,APCHY)) S APCHCNT=APCHCNT+1 S DA=APCHY,DIK="^APCHPWHL(" D ^DIK
 .I '(APCDCNT#100) W "."
 Q
 ;
 ;
EOJ ;
 K APCHCNT,APCHPGE,X,Y,DIC,DA,DIE,DR,%DT,D,D0,D1,DQ,APCHDTP,APCHPGEY,POP,APCHX,APCHDUZ,APCHY
 I $D(ZTQUEUED) S ZTREQ="@" K ZTSK
 D ^%ZISC
 Q
