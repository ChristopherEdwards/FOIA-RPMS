ATSERCHF ;TUCSON/DG;JOINS TWO TEMPLATES LINKED TO SAME FILE  [ 10/25/91  1:22 PM ]
 ;;2.5;SEARCH TEMPLATE COMPARISON;;OCT 25, 1991
 ;
 S Y="" F ATSL=0:0 Q:Y]""  D SORTEMP
 I '$D(ATSTP) D ZIS D @$S($D(ATSTSK):"TSKMN",1:"STORE")
 D EOJ
 Q
 ;
SORTEMP ;CREATES SORT TEMPLATE
 S ATSEARCH("FILELINK")=ATSEARCH(1,"SRCHFILENUM")
 W ! S DIC="^DIBT(",DIC("DR")="[ATSEARCH]",DIC(0)="AEMQL",DLAYGO=.401,DIC("A")="Store results in SEARCH TEMPLATE: ",DIC("S")="I $P(^(0),U,5)=DUZ&($P(^(0),U,4)=ATSEARCH(1,""SRCHFILENUM""))" D ^DIC K DIC I Y<0 S ATSTP="" Q
 S ATSTMP=+Y ;SAVE DFN OF TEMPLATE CHOSEN OR CREATED BY USER
 I ATSTMP=$P(ATSEARCH("SRCHTEMPDFN",1),U)!(ATSTMP=$P(ATSEARCH("SRCHTEMPDFN",2),U)) W !,*7,"Choose a template other than one of the templates you are using in the joining." S Y="" Q
 I $D(^DIBT(ATSTMP,2)) W !!,*7,"You cannot store results in a template used only for sort purposes." S Y="" Q
 I '$D(^DIBT(ATSTMP,1))&('$D(^DIBT(ATSTMP,"DIS"))) Q  ;NO RESULTS, NO FM SEARCH CODE
 I $D(^DIBT(ATSTMP,1)) W !,*7,"Results already stored in this template.  Do you want to have",!,"the stored data deleted" S %=1 D YN^DICN
 I '$D(^DIBT(ATSTMP,1)) S %=1 ;IF A SEARCH TEMPLATE WITH NO RESULTS STORED
 I %=2 S Y="" Q
 I %=1 S DIE="^DIBT(",DA=ATSTMP,DR="[ATSDEL]" D ^DIE K DIE D TEST Q
 S Y=""
 Q
 ;
TEST ;SEE IF USER HATTED OUT OF [ATSDEL]
 I $D(ATSY) S Y="" K ATSY Q
 E  K ^DIBT(ATSTMP,1),^("DIS"),^("O") S Y=1
 Q
 ;
ZIS ;SEE IF USER QUEUES ;
 W !!,"Do you want to queue the merge to another device" S %=2 D YN^DICN
 I %=2 G A
 I %=0 W !,"Enter  ""Y"" if you want to queue the joining of the templates to another device." G ZIS
 I %=-1 G A
 K IO("Q")
 S %IS="PQ",IOP="Q" D ^%ZIS
 I $D(IO("Q")),'POP S ATSTSK=""
A Q
 ;
TSKMN ;
 K ZTSAVE F %="ATSTMP","ATSEARCH(1,""SRCHRESLTREF"")","ATSEARCH(2,""SRCHRESLTREF"")" S ZTSAVE(%)="" S:$D(ATSTSK) ZTSAVE("ATSTSK")=""
 S ZTRTN="ZTM^ATSERCHF",ZTDESC="MERGE TWO SEARCH TEMPLATES",ZTIO=IO,ZTDTH="" D ^%ZTLOAD
 X ^%ZIS("C")
 Q
 ;
ZTM ;
 D STORE
 D EOJ
 I $D(ZTQUEUED) S ZTREQ="@"
 K ATSEARCH(1,"SRCHRESLTREF"),ATSEARCH(2,"SRCHRESLTREF")
 Q
 ;
STORE ;STORES DFNS IN SEARCH TEMPLATE
 I '$D(ATSTSK) W !,"Please wait "
 F ATSI=1:1:2 S ATSDFN=0 F ATSL=0:0 S ATSDFN=$O(@(ATSEARCH(ATSI,"SRCHRESLTREF")_ATSDFN_")")) Q:ATSDFN'=+ATSDFN  S ^DIBT(ATSTMP,1,ATSDFN)="" W:'$D(ATSTSK) "."
 S (ATSDFN,ATSCNT)=0 F L=0:0 S ATSDFN=$O(^DIBT(ATSTMP,1,ATSDFN)) Q:'ATSDFN  S ATSCNT=ATSCNT+1
 S ^DIBT(ATSTMP,1,0)=ATSCNT ; added line 2-7-91 dg/ohprd
 W !,"There are ",ATSCNT," entries in the ",$P(^DIBT(ATSTMP,0),U)," template.",!
 I '$D(ATSTSK) W !,"Done!"
 Q
 ;
EOJ ;
 K ATSDFN,ATSI,ATSL,ATSETMP,ATSY,ATSTP,ATSCNT,ATSTSK,IO("Q")
 Q
 ;
