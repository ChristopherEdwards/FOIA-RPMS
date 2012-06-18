XBHEDD9 ;402,DJB,10/23/91,EDD - NODE Lookup and Look-up by Global
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 N FILE,FLD,NODE,NODE0,NODE1,PIECE
 K ^UTILITY($J,"EDD/NP") S FILE=ZNUM
ND ;Lookup by NODE and PIECE
 D NDGET G:FLAGQ EX D NDBLD
 I '$D(^UTILITY($J,"EDD/NP")) W *7,"   No such node." G ND
ND1 D NDPRT G:FLAGQ EX
 I $O(^UTILITY($J,"EDD/NP",NODE,""))=0 S FILE=+$P(^UTILITY($J,"EDD/NP",NODE,0),U,3),NODE1=NODE G ND
 D NDSUM G:FLAGD ND G:FLAGE EX
 S FLAGQ=0 G ND1
EX ;
 S:'FLAGE FLAGQ=0 K NP,FLAGD,FNAM,FNUM,LEV,^UTILITY($J,"EDD/NP")
 Q
NDGET ;Node get
 W !
NDGET1 I FILE'=ZNUM W !,"Select '",NODE1,"' SUBNODE: "
 E  W !,"Select NODE: "
 R NODE:DTIME S:'$T NODE="^" I "^"[NODE S FLAGQ=1 Q
 I NODE="?" D HELP G NDGET1
 Q
NDBLD ;
 S FLD=0 K ^UTILITY($J,"EDD/NP")
 F  S FLD=$O(^DD(FILE,FLD)) Q:FLD'>0  I $P($P(^DD(FILE,FLD,0),U,4),";")=NODE S NODE0=^(0),NP=$P(NODE0,U,4),PIECE=$P(NP,";",2),^UTILITY($J,"EDD/NP",NODE,PIECE)=FLD_U_$P(NODE0,U,1,4)
 Q
NDPRT ;Print
 S PIECE="" W @IOF D HD
 F  S PIECE=$O(^UTILITY($J,"EDD/NP",NODE,PIECE)) Q:PIECE=""  W !?3,$J(NODE_";"_PIECE,12),?20,$J($P(^UTILITY($J,"EDD/NP",NODE,PIECE),U),7),?32,$P(^(PIECE),U,2) I $Y>SIZE D PAGE Q:FLAGQ=1
 Q
NDSUM ;
 W !!?2,"You may now do an 'INDIVIDUAL FIELD SUMMARY'",!?2,"on the field(s) listed above.."
 S FLAGD=0 W ! S DIC="^DD("_FILE_",",DIC(0)="QEAM" D ^DIC I Y<0 S FLAGD=1 Q
 S FNUM=+Y,FNAM=$P(Y,U,2),LEV=1,FILE(LEV)=FILE D ^XBHEDD4 Q:FLAGQ
 I $Y'>SIZE F I=$Y:1:SIZE W !
 R ?2,"<RETURN> to continue..",XX:DTIME
 Q
PAGE ;
 R !!?2,"<RETURN> to continue, '^' to quit, '^' to exit: ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 W @IOF D HD
 Q
HELP ;
 N FLD,NDTEMP
 S FLD=0 K ^UTILITY($J,"EDD/NP")
 F  S FLD=$O(^DD(FILE,FLD)) Q:FLD'>0  S NDTEMP=$P($P(^DD(FILE,FLD,0),U,4),";") W:'$D(^UTILITY($J,"EDD/NP",NDTEMP))#2 "  ",NDTEMP W:$X>70 !?5 S ^UTILITY($J,"EDD/NP",NDTEMP)=""
 K ^UTILITY($J,"EDD/NP") Q
HD ;Node look-up
 W !?3,"NODE ; PIECE",?20,"FLD NUM",?42,"FIELD NAME"
 W !?3,"------------",?20,"-------",?32,"------------------------------"
 Q
GLOBAL ;Find File when user enters global
 K ^UTILITY($J) S (FLAGGL,FLAGGL1)=0
 I '$D(^UTILITY("EDD/GL")) W *7,!?25,"You have no data in ^UTILITY(""EDD/GL""). You must run",!?25,"option 10, List Globals in ASCII Order, before you",!?25,"can do a lookup on a global." S FLAGGL=1 Q
 I $D(^UTILITY("EDD/GL",X)) S ZNUM=$P(^(X),U),ZNAM=$P(^(X),U,2),ZGL=X Q
 S XX=X F I=1:1 S XX=$O(^UTILITY("EDD/GL",XX)) Q:XX=""!($E(XX,1,$L(X))'=X)  D GLLIST I I#5=0 D GLPAGE Q:FLAGGL!FLAGGL1
 I '$D(^UTILITY($J)) W *7," ??" S FLAGGL=1
 Q:FLAGGL
 I 'FLAGGL1 S I=(I-1) D GLPAGE1 Q:FLAGGL
 I Z1>I F II=(I+1):1:Z1 S XX=$O(^UTILITY("EDD/GL",XX)) Q:XX=""!($E(XX,1,$L(X))'=X)  S ^UTILITY($J,II)=$P(^UTILITY("EDD/GL",XX),U)_"\~"_$P(^(XX),U,2)_"\~"_XX
 I '$D(^UTILITY($J,Z1)) W *7," ??" S FLAGGL=1 Q
 S ZNUM=$P(^UTILITY($J,Z1),"\~"),ZNAM=$P(^(Z1),"\~",2),ZGL=$P(^(Z1),"\~",3)
 I '$D(^DD(ZNUM)) W *7," ?? This file has been deleted." S FLAGGL=1 ;Check to see if file still exists
 Q
GLLIST ;List Globals
 I I=1 W !?28,"FILE NUM",?38,"FILE NAME (Truncated to 32)",!?28,"--------",?38,"--------------------------------"
 W !?3,$J(I,3),"  ",XX,?28,$J($P(^UTILITY("EDD/GL",XX),U),8),?38,$E($P(^(XX),U,2),1,32)
 S ^UTILITY($J,I)=$P(^UTILITY("EDD/GL",XX),U)_"\~"_$P(^(XX),U,2)_"\~"_XX
 Q
GLPAGE ;
 W !,"TYPE '^' TO STOP, OR",!,"CHOOSE NUMBER: "
 R Z1:DTIME S:'$T Z1="^" I Z1="?" W "  Enter a number from left hand column.." G GLPAGE
 S:Z1["^" FLAGGL=1 I +Z1>0 S FLAGGL1=1
 Q
GLPAGE1 ;
 W !,"TYPE '^' TO STOP, OR",!,"CHOOSE NUMBER: "
 R Z1:DTIME S:'$T Z1="^" I "^"[Z1!(+Z1'>0) S FLAGGL=1
 I Z1="?" W "  Enter a number from left hand column.." G GLPAGE1
 Q
