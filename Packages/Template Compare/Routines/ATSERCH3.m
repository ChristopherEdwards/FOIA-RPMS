ATSERCH3 ;TUCSON/DG;ASKS USER IF WANTS TO STORE RESULTS AT THIS POINT  [ 10/25/91  1:38 PM ]
 ;;2.5;SEARCH TEMPLATE COMPARISON;;OCT 25, 1991
 ;
 S Y="" F L=0:0 Q:Y  D ASK
 Q
 ;
ASK ;
 S ATSRCSTR=0
 W !!,"Would you like to save the results of the following search comparison",!,"in a search template (template will be linked to the ",$P(^DIC(ATSEARCH("FILELINK"),0),U)," file) " S %=2 D YN^DICN
 I %=2 S Y=1 Q
 I %=0 D HELP Q
 I %=-1 S ATSFLAG=$S($D(^UTILITY("ATSEARCH",$J,"MERGED")):2,1:1) S Y=1 Q
 E  S Y="" F L=0:0 Q:Y  D SORTEMP
 Q
 ;
SORTEMP ;CREATES SORT TEMPLATE WITH MERGED SEARCH RESULTS
 ;LINKS TO CHOSEN FILE
 S ATSRCSTR=1
 W ! S DIC="^DIBT(",DIC("DR")="[ATSEARCH]",DIC(0)="AEMQL",DLAYGO=.401,DIC("A")="Select SEARCH TEMPLATE: ",DIC("S")="I $P(^(0),U,5)=DUZ&($P(^(0),U,4)=ATSEARCH(""FILELINK""))" D ^DIC K DIC I Y<0 S ATSRCSTR=0 Q
 S ATSETMP=+Y ;SAVE DFN OF TEMPLATE CHOSEN OR CREATED BY USER
 I $D(^DIBT(ATSETMP,2)) W !!,*7,"You cannot store results in a template used only for sort purposes." S Y="" Q
 I '$D(^DIBT(ATSETMP,1))&('$D(^DIBT(ATSETMP,"DIS"))) Q  ;NO RESULTS, NO FM SEARCH CODE
 I ATSETMP=$P(ATSEARCH("SRCHTEMPDFN",1),U)!(ATSETMP=$P(ATSEARCH("SRCHTEMPDFN",2),U)) W !!,*7,"Choose a template other than the one(s) you are using in the comparison." S Y="" Q
 I $D(^DIBT(ATSETMP,1)) W !!,*7,"Results already stored in this template.  Do you want to have",!,"the stored data deleted" S %=1 D YN^DICN
 I '$D(^DIBT(ATSETMP,1)) S %=1 ;IF A SEARCH TEMPLATE WITH NO RESULTS STORED
 I %=2!(%=0)!(%=-1) S Y="" Q
 I %=1 K ^DIBT(ATSETMP,1),^("DIS"),^("O") S DIE="^DIBT(",DA=ATSETMP,DR="[ATSDESC]" D ^DIE K DIE S Y=1 Q
 Q
 ;
SEARCH ; - EP - CREATES RESULT NODES AND SPECIFCATION NODES IN ^DIBT(ATSETMP,
 S ATSTMPNM=$P(^DIBT(ATSETMP,0),U)
 I ATSEARCH("MERGE COUNT")=0 S DIK="^DIBT(",DA=ATSETMP D ^DIK K ATSETMP W !!,*7,"The ",ATSTMPNM," template was deleted since there were 0 matches." H 3 Q
 S (ATSDFN,ATSUM,ATSEDOT)=0
 W:'ATSTASK !! F ATSL=0:0 S ATSDFN=$O(^UTILITY("ATSEARCH",$J,"MERGED",3,ATSDFN)) Q:ATSDFN'=+ATSDFN  S ^DIBT(ATSETMP,1,ATSDFN)="",ATSEDOT=ATSEDOT+1 W:'ATSTASK&('ATSEDOT#20) "."
 S ^DIBT(ATSETMP,1,0)=ATSEARCH("MERGE COUNT") ; added line 2-7-91 dg/ohprd
 I ATSTASK W !!,"There ",$S(ATSEARCH("MERGE COUNT")=1:"was ",1:"were "),ATSEARCH("MERGE COUNT"),$S(ATSEARCH("MERGE COUNT")=1:" match ",1:" matches "),"entered into the ",ATSTMPNM," search template"
 E  W "Results entered into search template" H 2
 K ATSDFN,ATSUM,ATSETMP,ATSEDOT,ATSTMPNM
 Q
 ;
HELP ;
 S XQH="ATSEARCH-CREATE-TEMPLATE",DIC(0)="X" D EN^XQH
 W:$D(IOF) @IOF
 Q
 ;
EOJ ;
 K Y
 Q
 ;
