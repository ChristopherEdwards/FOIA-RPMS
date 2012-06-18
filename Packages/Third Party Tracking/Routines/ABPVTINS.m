ABPVTINS ;Add/Edit Insurer File Data;[ 07/15/91  3:03 PM ]
 ;;1.34;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 W !!,"<<< NOT AN ENTRY POINT - ACCESS DENIED >>>",!! Q
HEAD ;
 ;PROCEDURE TO DRAW THE SCREEN HEADING
 S X="Add/Edit Insurer File Data" D SCREEN^ABPVZMM
 Q
WARN ;
 ;PROCEDURE TO ISSUE FILE MAINTENANCE RESPONSIBILITY WARINING
 W !!,"WARNING: Before ADDING a new INSURER you should "
 W "ensure that it does not",!?9,"already exist!"
 Q
ADD ;
 ;PROCEDURE TO ADD A NEW INSURER FILE ENTRY
 S ABPV("DFN")=0,ABPV("MODE")=1,DA=+$P(^AUTNINS(0),"^",3)-1
 W ! K DIR S DIR(0)="FO",DIR("A")="Enter the NAME of the INSURER"
 D ^DIR K DIR I $D(DIRUT) D XIT S ABPV("QUIT")="" Q
 S ABPV("X")=X D  G DISP:+Y>0
 .K DIC S DIC="^AUTNINS(",DIC(0)="EM" D ^DIC K DIC Q:+Y'>0
 .S ABM("DFN")=+Y,DA=+Y,D0=+Y,ABM("MODE")=0
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to Add '"_ABPV("X")
 S DIR("A")=DIR("A")_"' as a New INSURER",DIR("B")="NO" W *7 D ^DIR
 K DIR Q:$D(DUOUT)!$D(DTOUT)!(Y<1)  W !,"OK, adding..."
DFN F  S DA=$O(^AUTNINS(DA)) Q:'+DA  S ABPV("DFN")=DA
 S ABPV("DFN")=ABPV("DFN")+1,ABPV("LOCKED")=0
LOCK F ABPVI=0:1:9 L ^AUTNINS(ABPV("DFN")):1 I $T S ABPV("LOCKED")=1 Q
 I 'ABPV("LOCKED") D  S Y=-1 H 3 G XIT
 .W !,*7,"INSURER File is LOCKED by another USER, INSURER NOT CREATED!"
 S X=ABPV("X"),DIC="^AUTNINS(",DIC(0)="L",DINUM=ABPV("DFN") K DD,DO
 D FILE^DICN I +Y<1 W *7,!!,"ERROR: INSURER NOT CREATED",!! H 3 Q
 ;
EDIT S DA=ABPV("DFN"),DIE="^AUTNINS(" ;I $P($G(^AUTNINS(DA,1)),U,7)=2 G ADDR
 W ! S DR=".01R~Insurer Name.......: ;.41R~Long Lookup Name...: "
 D ^DIE G KILL:$D(Y)
ADDR W !!,"<--------------- MAILING ADDRESS --------------->"
 S DR=".02R~Street...: ;.03R~City.....: ;.04R~State....: ;.05R~Zip "
 S DR=DR_"Code.: " D ^DIE G KILL:$D(Y) S ABPV("MODE")=0
 W !!,"<--------------- BILLING ADDRESS --------------->",!?6
 W "(if Different than Mailing Address)"
 S DR="1Billing Office.: ;I X="""" S Y=""@9"";2        Street.: ;"
 S DR=DR_"3        City...: ;4        State..: ;5        Zip....: ;@9"
 D ^DIE G KILL:$D(Y)
DISP K DXS D ^%AUCLS,HEAD,^ABPVDIN K DXS
SELECT W !,"CHANGE which item? (1-12)// " R X:DTIME
 Q:X["^"!(X']"")  I +X<1!(+X>12) D  G SELECT
 .W *7,!,"     PLEASE ENTER A NUMBER FROM ""1"" TO ""12"" ONLY."
 S LBL="X"_X,DIE="^AUTNINS(" W ! D @LBL G DISP
X1 S DR=.01 D ^DIE Q
X2 S DR=.02 D ^DIE Q
X3 S DR=.03 D ^DIE Q
X4 S DR=.04 D ^DIE Q
X5 S DR=.05 D ^DIE Q
X6 S DR=.06 D ^DIE Q
X7 S DR=.09 D ^DIE Q
X8 S DR=1 I $D(^AUTNINS(DA,1))=0 D
 .S DR=DR_";I X=""^""!(X="""") S Y="""",AFLG="""";5"
 K AFLG D ^DIE I $D(AFLG)=1 K AFLG Q
X8A I $P(^AUTNINS(DA,1),"^",1)'=""&($P(^AUTNINS(DA,1),"^",5)="") D
 .W !?3,*7,"REQUIRED INFORMATION - PLEASE RESPOND!" S DR=5 D ^DIE G X8A
 I $P(^AUTNINS(DA,1),"^",1)="" F ABPVI=2:1:5 S $P(^(1),"^",ABPVI)=""
 Q
X9 S DR=2 D ^DIE Q
X10 S DR=3 D ^DIE Q
X11 S DR=4 D ^DIE Q
X12 S DR=5 D ^DIE Q
 ;
XIT L  K DA,DIC,DIE,DR,ABPV("MODE"),ABPV("DFN"),ABPV("LOCKED"),X,Y
 K ABPV("X"),DD,DO,ABPV("QUIT"),ABPVI,AFLG,LBL
 Q
 ;
KILL I ABPV("MODE") S DIK=DIE D ^DIK
 K ABPVMESS S ABPVMESS="Data Incomplete: Entry Deleted" W *7
 S ABPVMESS(2)="... Press any key to continue ... " D PAUSE^ABPVZMM
 Q
MAIN ;
 ;ENTRY POINT - THE PRIMARY ROUTINE DRIVER
 D XIT,HEAD,WARN,ADD I $D(ABPV("QUIT"))'=1 G MAIN
 K ABPV("QUIT") Q
