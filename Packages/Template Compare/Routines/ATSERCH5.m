ATSERCH5 ;TUCSON/DG;ASKS USER AND PROVIDES INSTRUCTION FOR STOPPING OR CONTINUING  [ 10/25/91  1:37 PM ]
 ;;2.5;SEARCH TEMPLATE COMPARISON;;OCT 25, 1991
 ;
 D CHOOSE
 D EOJ Q
CHOOSE ;DISPLAYS MENU - COMPARE AGAIN, CREATE TEMPLATE, OR STOP
 S X="" F ATSL=0:0 Q:X]""&(X=+X)&(X'<1&(X'>4))  D:X["?" HELP D CHOOSE1 R !!,"Your choice (1-4): ",X:DTIME W:X=1&(ATSRCSTR) *7,!!,"Results already stored!" G:X=1&(ATSRCSTR) CHOOSE S:'$T X="^" I X="^"!(X=4) S ATSFLAG=1 Q
 I ATSFLAG Q
 I X=1 D CALLSORT Q
 I X=2!(X=3) W:$D(IOF) @IOF D COMPMERG^ATSERCHI Q
 ;
CHOOSE1 ;WRITES MENU
 W !!,"Select by number one of the following:",!!,1," Create search template to be linked to the ",$P(^DIC(ATSEARCH("FILELINK"),0),U)," file",$S(ATSRCSTR:"   (NOT AVAILABLE)",1:"")
 W !,2," Compare the Intermediate Results with another search template"
 W !,3," Compare the Intermediate Results to itself so as to utilize a pointer field"
 W !,"  within the ",$P(^DIC(ATSEARCH("FILELINK"),0),U)," file as a basis for comparison"
 I 'ATSRCSTR W !,4," Stop without storing results and without continuing search result comparison"
 E  W !,4," Stop search comparison"
 Q
 ;
CALLSORT ; - EP - CALL TO SORTEMP TO CREATE SORT TEMPLATE
 I $D(ATSTORE),'ATSRCSTR S X="" F ATSL=0:0 Q:X]""&(X=+X)&(X=1!(X=2))  D:X["?" HELP2 D CALLSRT1 R !!,"Your choice (1 or 2): ",X:DTIME S:'$T X="^" I X="^"!(X=2) S ATSFLAG=1 Q
 I ATSRCSTR S ATSFLAG=1 Q
 I ATSFLAG=1 Q
 S Y="" F L=0:0 Q:Y]""  D SORTEMP
 I ATSFLAG=1 Q
 D SEARCH
 S ATSFLAG=1
 Q
 ;
CALLSRT1 ;CONTINUE MENU DISPLAY FROM CALLSORT
 W:$D(IOF) @IOF
 S ATSEARCH("FILELINK")=^UTILITY("ATSEARCH",$J,"FILELINK") ;IN CASE CHANGED LINKED FILE BEFORE HATTED OUT
 W !!,"Select by number one of the following:",!!,1," Create search template to be linked to the ",$P(^DIC(ATSEARCH("FILELINK"),0),U)," file"
 W !,2," Stop without storing results"
 Q
 ;
HELP ;HELP FOR CHOOSE MODULE
 S XQH="ATSEARCH-GO-OR-STOP",DIC(0)="X" D EN^XQH
 W:$D(IOF) @IOF
 Q
 ;
HELP2 ;HELP FOR CALLSORT MODULE MENU
 S XQH="ATSEARCH-STORE-STOP",DIC(0)="X" D EN^XQH
 W:$D(IOF) @IOF
 Q
 ;
SORTEMP ;CREATES SORT TEMPLATE WITH MERGED SEARCH RESULTS
 ;LINKS TO CHOSEN FILE
 S ATSMSG="W !!,*7,""Template was not created, results deleted!"""
 W ! S DIC="^DIBT(",DIC("DR")="[ATSEARCH]",DIC(0)="AEMQL",DLAYGO=.401,DIC("A")="Select SEARCH TEMPLATE: ",DIC("S")="I $P(^(0),U,5)=DUZ&($P(^(0),U,4)=ATSEARCH(""FILELINK""))" D ^DIC K DIC I Y<0 X ATSMSG S ATSFLAG=1 Q
 S ATSETMP=+Y ;SAVE DFN OF TEMPLATE CHOSEN OR CREATED BY USER
 I $D(^DIBT(ATSETMP,2)) W !!,*7,"You cannot store results in a template used only for sort purposes." S Y="" Q
 I '$D(^DIBT(ATSETMP,1))&('$D(^DIBT(ATSETMP,"DIS"))) Q  ;NO RESULTS, NO FM SEARCH CODE
 I $D(^DIBT(ATSETMP,1)) W !!,*7,"Results already stored in this template.  Do you want to have",!,"the stored data deleted" S %=1 D YN^DICN
 I '$D(^DIBT(ATSETMP,1)) S %=1 ;IF A SEARCH TEMPLATE WITH NO RESULTS STORED
 I %=2 S Y="" Q
 I %=1 S DIE="^DIBT(",DA=ATSETMP,DR="[ATSDESC]" D ^DIE K DIE D TEST Q
 I %=0 S Y="" Q
 I %=-1 W !!,*7,"End of search comparison.  Results not stored." S ATSFLAG=1 Q
 Q
 ;
TEST ;SEE IF USER HATTED OUT OF [ATSDESC]
 I $D(ATSY) S Y="" K ATSY Q
 E  K ^DIBT(ATSETMP,1),^("DIS"),^("O") S Y=1
 Q
 ;
SEARCH ;CREATES RESULTS AND SPECIFCATION NODES IN ^DIBT(ATSETMP,
 S (ATSDFN,ATSUM)=0
 W !! F ATSL=0:0 S ATSDFN=$O(^UTILITY("ATSEARCH",$J,"MERGED",3,ATSDFN)) Q:ATSDFN'=+ATSDFN  S ^DIBT(ATSETMP,1,ATSDFN)="" W "." S ATSUM=ATSUM+1 ; modified 2-7-91 dg/ohprd
 S ^DIBT(ATSETMP,1,0)=ATSUM ; added 2-7-91 dg/ohprd
 W !!,"Results entered.  Search template comparison ended!"
 Q
 ;
COMPMERG ;SETS VARIABLES TO COMPARE MERGED RESULTS WITH NEXT TEMPLATE
 S ATSEARCH(1,"SRCHRESLTREF")="^UTILITY(""ATSEARCH"",$J,""MERGED"",3,"
 S:X=3 ATSEARCH(2,"SRCHRESLTREF")="^UTILITY(""ATSEARCH"",$J,""MERGED"",3,"
 S ATSEARCH(1,"SRCHFILENAM")=$P(^DIC(ATSEARCH("FILELINK"),0),U),ATSEARCH(1,"SRCHFILENUM")=ATSEARCH("FILELINK"),ATSEARCH(1,"SRCHNAM")="INTERMEDIATE SEARCH RESULTS"
 S:X=3 ATSEARCH(2,"SRCHFILENAM")=$P(^DIC(ATSEARCH("FILELINK"),0),U),ATSEARCH(2,"SRCHFILENUM")=ATSEARCH("FILELINK"),ATSEARCH(2,"SRCHNAM")="INTERMEDIATE SEARCH RESULTS",ATSEINRL=1
 Q
 ;
EOJ ;
 K ATSI,ATSVAR,ATSMTCH,ATSNOT,Y,%,ATSEARCH(2,"PTEDTOFILE"),ATSEARCH(1,"PTEDTOFILE"),ATSETMP,ATSENLAG
 Q
 ;
