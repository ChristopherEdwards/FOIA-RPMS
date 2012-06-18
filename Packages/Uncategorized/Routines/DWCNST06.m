DWCNST06 ;NEW PROGRAM [ 04/14/97  2:39 PM ]
 ;WRITTEN BY DAN WALZ PIMC TO ALLOW REVIEW OF CONSULTATIONS
 ;FOR A SELECTED PATIENT BETWEEN SELECTED DATES
 ;
 I '$D(DTIME)  D NOW^%DTC S DTIME=X
 D ^DWSETSCR K XIT  S SEL=0
 F II=0:0 D SEL Q:Y<0  D REG S Y=0 Q:$D(XIT)
 K DIR,%DT,SDT,DFN,SEEN,SVPRV,STAT,DTRQ,XXX,DWDFN,DIC,II,Y,%,ARY,PTNA,III,CNT,XIT,SEL,ID
 D KILL^DWSETSCR
 Q
SEL K ARY D HEAD S DIC="^DPT(",DIC(0)="AEMQ"
 D ^DIC
 I Y<0 S XIT="" Q
 S DWDFN=+Y
 S %DT="AE",%DT("A")="Display list for consults starting on: ",%DT("B")="T-30"
 D ^%DT
 I Y<0 S XIT="" Q
 S SDT=+Y
 Q
 ;
REG D GETLIST I SEL["^" Q
 I '$D(ARY) D ^%AUCLS,HEAD W !!,?25,HI_"There are NO Consulations..."_NO W !!,"Press <Return> to Continue..." R XXX:15 S XIT="" Q
 I +SEL=0 S XIT="" Q
 S DWDFN=+ARY(+SEL)
 I '$D(^DWCNST01(DWDFN,0)) D ^%AUCLS,HEAD W !!,HI_BLK_"Unable to Locate Selection - Aborting.  Nothing Done!"_NO W !!,"Press <Return> to Continue..." R XXX:60 K XXX,ARY,XIT S SEL=0 Q
 D PRT K XIT
 W !,"Press <Return> to Continue..." R XXX:120 K XXX
 Q
 ;
HEAD D ^%AUCLS W ?26,HI_"*****************************",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?33,"Selected Client",?54,"*",!,?26,"*****************************"_NO,!! I $D(ARY) W "Select the number of the entry to display or type ^ to Exit.",!,"Status (ST) Translation: R=New Request; A=Accepted; S=Signed Off; C=Canceled",!!
 Q         
HD W "SEL#",?6,"ST",?9,"CLIENT",?35,"SEEN",?41,"PIMC#",?51,"REQ SERVICE",?65,"CONSULT DATE",!,"-------------------------------------------------------------------------------"
 Q
GETLIST K ARY
 S CNT=0
 Q:'$D(^DWCNST01("F",DWDFN))
 S CNT=0,DFN=0 F III=0:0 S DFN=+$O(^DWCNST01("F",DWDFN,DFN)) Q:DFN=0  I +$P(^DWCNST01(DFN,0),"^",1)\1'<SDT\1 S CNT=CNT+1,ARY(CNT)=DFN_"^"_$P(^DWCNST01(DFN,0),"^",4)
 Q:'$D(ARY)
 D ^%AUCLS,HEAD,HD
 S DWDFN=0 F III=1:1:CNT S DWDFN=+ARY(III) Q:$D(XIT)  D DISP
 Q
DISP D IDSETUP
 W !,III,?6,STAT,?9,$E(PTNA,1,24),?35,$S(SEEN="N":"NO",SEEN="Y":"YES",1:""),?41,ID,?51,SVPRV,?65,DTRQ K X1,X,Y,DWX
 I $Y>20!(III'<CNT) D SELECT
 Q
SELECT K XIT W !!,"Select Client or Press <Return> for More: "
RESEL R SEL:DTIME I '$T S XIT=""
 I SEL["^" S XIT="" Q
 I +SEL=0&(III=CNT) Q
 I +SEL=0 D ^%AUCLS,HD Q
 I +SEL>0&(+SEL'>CNT) S XIT="" Q
 I +SEL<1!(SEL>CNT) W " ?? Invalid - Try Again: " G RESEL
 ;;D ^%AUCLS,HEAD,HD
 Q
IDSETUP S PTNA="",SEEN="" I $D(^DWCNST01(DWDFN,4)) S SEEN=$P(^(4),"^",9) I $P(^(4),"^",1)]"" S:$D(^DPT(+$P(^(4),"^",1),0)) PTNA=$P(^(0),"^",1)
 S ID="" I $D(^DWCNST01(DWDFN,4)) S:$D(^AUPNPAT(+$P(^(4),"^",1),41,DUZ(2),0)) ID=$P(^(0),"^",2)
 S:PTNA="" PTNA="Request in Progress"
 S DTRQ="" I $D(^DWCNST01(DWDFN,0)) S DTRQ=$P(^(0),"^",1),DTRQ=$E(DTRQ,4,5)_"/"_$E(DTRQ,6,7)_"/"_$E(DTRQ,2,3)
 ;;;I $D(^DWCNST01(DWDFN,4)) S:$D(^DPT(+^(4),.101)) WDRM=WDRM_"-"_$P(^(.101),"^",1) 
 S STAT="" S:$D(^DWCNST01(DWDFN,0)) STAT=$P(^(0),"^",4)
 I '$D(^DIC(49,+$P(^DWCNST01(DWDFN,0),"^",3),0)) S SVPRV="?" Q
 S SVPRV=$P(^DIC(49,+$P(^DWCNST01(DWDFN,0),"^",3),0),"^",1)
 ;;I SVPRV]""&($P(ARY(III),"^",2)="A") S SVPRV=$P(SVPRV,",",1)_","_$E($P(SVPRV,",",2),1,1)
 S SVPRV=$E(SVPRV,1,12)
 Q
PRT K XIT D FQ Q:$D(XIT)
 K IOP
 S:'$D(FLDS) FLDS="[1966180-FULL]"
 I '$D(^DWCNST01(DWDFN,0)) W !!,HI_"SORRY UNABLE TO SEND YOUR PRINT REQUEST - ABORTING"_NO H 3 Q
 S DIC=1966180,L=0,BY="@NUMBER",FR=DWDFN,TO=DWDFN
 D EN1^DIP
 Q
FQ S DIR(0)="S^F:Full List;C:Consult Sheet",DIR("A")="Select the Type of Output ",DIR("B")="F",DIR("?")="Select 'F' for a full report -or- 'C' to print a Consultation Sheet."
 D ^DIR
 K DIR
 I $D(DTOUT)!($D(DUOUT)) S XIT="" Q
 S FLDS=$S(Y="C":"[1966180-FINAL]",1:"[1966180-FULL]")
 Q
