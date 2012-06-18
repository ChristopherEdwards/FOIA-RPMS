DWCNST02 ;NEW PROGRAM [ 07/07/1999  3:35 PM ]
 ;WRITTEN BY DAN WALZ PIMC TO ALLOW REVIEW OF PENDING CONSULTATIONS
 ;DWCNST02
 ;  vjm 7/7/99 - mods...see note below at OTHER+4
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 Q
 I '$D(DUZ(2)) W !,"DUZ(2) not set ABORTING..." H 3 Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 ;check if other service is to be used from ^DWCNST03
 ;
 I '$D(^VA(200,DUZ,5)) W "Unable to locate Service - ABORTING.." H 3 Q
 S SVCN=+^(5) I SVCN=0 W "Unable to locate Service - ABORTING.." H 3 Q
 I '$D(^DIC(49,SVCN,0)) W "Unable to locate Service - ABORTING.." H 3 Q
 S SVC=$P(^(0),"^",1)
 I '$D(DTIME)  D NOW^%DTC S DTIME=X
 D ^DWSETSCR K XIT  S SEL=0
 I $D(^DWCNST03("B",DUZ)) D ^%AUCLS,HEAD,OTHER
 I '$D(SVCN) W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 F II=0:0 D REG Q:$D(XIT)
XIT K OGSV,OGSVNA,SGSV,NSVNA,DIR,DTOUT,DUOUT,DIRUT,ODUZ,OSIE,HDIE,HDA,DWNOW,SEEN,WHT,USN,SVPRV,STAT,WDRM,SVC,SVCN,XXX,DWDFN,II,DA,DIC,DIE,Y,DR,RS,%,USR,ARY,PTNA,III,CNT,XIT,WAIT,SEL,ID,DNA
 D KILL^DWSETSCR
 Q
 ;
REG K XIT D GETLIST Q:SEL["^"
 I '$D(ARY) D ^%AUCLS,HEAD W !!,?25,HI_"There are NO Consultations..."_NO W !!,"Press <Return> to Continue..." R XXX:15 S XIT="" Q
 I +SEL=0 S XIT="" Q
 S DA=+ARY(+SEL),DWDFN=DA
 I '$D(^DWCNST01(DA,0)) D ^%AUCLS,HEAD W !!,HI_BLK_"Unable to Locate Selection - Aborting.  Nothing Done!"_NO W !!,"Press <Return> to Continue..." R XXX:60 K XXX,ARY,XIT S SEL=0 Q
 D PRT
 S DA=DWDFN I '$D(^DWCNST01(DWDFN,4)) D ACCEPT,XT Q
 I $P(^(4),"^",5)="" D ACCEPT,XT Q
 ;if already accepted
 S DIE="^DWCNST01(",DA=DWDFN
 K % I $D(^DWCNST01(DWDFN,4)) S USN=+$P(^(4),"^",5) I USN>0 D:$P(^VA(200,USN,0),"^",1)'=USR CHKACC
 I $D(%) I %'=1 S SEL=0 K XIT,ARY Q
 S DR="20" D ^DIE I X["Y" D NOW^%DTC S DWNOW=% S DR="21///^S X=USR;22///^S X=DWNOW" D ^DIE
 I $D(DTOUT)!($D(DUOUT)) D XT Q
 ;;;S DR="7" D ^DIE I $D(DTOUT)!($D(DUOUT)) D XT Q
 S DIR(0)="SM^S:Sign-Off WITHOUT Entering a Report;R:Sign-Off and ENTER a Report;C:CANCEL the Consult;N:Do NOTHING At This Time",DIR("B")="N",DIR("A")="Enter Desired Action: "
 D ^DIR
 I Y="N"!(Y="")!($D(DTOUT))!($D(DUOUT))!($D(DIRUT)) D XT Q
 S WHT=Y D NOW^%DTC S DWNOW=%
 I WHT="C" W !,"Ok to CANCEL (Y/N)" S %=2 D YN^DICN I %'=1 W !,HI_"Ok, Nothing Done!"_NO H 2 D XT Q
 I WHT="C" S DR="3///^S X=WHT;18///^S X=USR;10///^S X=DWNOW" D ^DIE W !,HI_"The consultation has been CANCELED!"_NO H 2 D XT Q
 I WHT="S" S DR="3///^S X=WHT;18///^S X=USR;10///^S X=DWNOW" D ^DIE W !,HI_"The consultation has been Signed-Off!"_NO D XT,ASKPRT Q
REALLY I WHT="R" S WHT="S"
 S DR="7;3///^S X=WHT;18///^S X=USR;10///^S X=DWNOW"
 D ^DIE
 I '$D(^DWCNST01(DWDFN,3)) S %=1 W !,HI_"You did not enter a Consultation Report. Enter it now" D YN^DICN W NO I %=1 D REALLY
 W !,HI_"The consultation has been Signed-Off!"_NO D XT
 S HDIE=DIE,HDA=DA
 D ASKPRT
EDT W !!,"Do you want to EDIT your Consultation Report (Y/N)" S %=1 D YN^DICN
 I %=1 S DIE=HDIE,DA=HDA,DR=7 D ^DIE G EDT
 D ASKPRT Q:%'=1
 G EDT
 Q
ACCEPT W !!,"Do want to ACCEPT this Consultation Request (Y/N)" K % D YN^DICN
 ;set flag for accepted
 I %'=1 D XT Q
 ;accept consult
 S DR="3///^S X="_""""_"A"_""""_";17///^S X=DWNOW"
 S DIE("NO^")="",DIE="^DWCNST01(" D NOW^%DTC S DWNOW=% D ^DIE
USEROK S DR="16R//^S X=USR"
 D ^DIE
 I $D(^DWCNST01(DA,4)) S ODUZ=+$P(^(4),"^",5) I $D(^DWCNST03("B",ODUZ))  I $P(^DWCNST03(+$O(^DWCNST03("B",ODUZ,0)),0),"^",2)=SVCN G SKPCHK ;skip check if user is in file ^DWCNST03
 I $D(^DWCNST01(DA,4)) I +^VA(200,+$P(^(4),"^",5),5)'=SVCN W !,$C(7),"Selected Provider is not a member of the "_SVC_" Service!" G USEROK
SKPCHK I $D(^DWCNST01(DA,4)) S ACUSER=+$P(^(4),"^",5) I ACUSER>0 D MM ;send MM message
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?33,"Pending Consults",?54,"*",!,?26,"*****************************"_NO
 W !,"Service: "_SVC,?40,"User: "_USR,!!
 Q         
HD W "SEL#",?6,"ST",?9,"CLIENT",?35,"SEEN",?41,"PIMC#",?51,"RQSV or *PROV",?65,"WARD-ROOM",!,"-------------------------------------------------------------------------------"
 Q
GETLIST K ARY
 S CNT=0
 I $D(^DWCNST01("C","R")) S CNT=0,DWDFN=0 F III=0:0 S DWDFN=+$O(^DWCNST01("C","R",DWDFN)) Q:DWDFN=0  I $D(^DWCNST01("D",SVCN,DWDFN)) S CNT=CNT+1,ARY(CNT)=DWDFN_"^R"
 S DWDFN=0 F III=0:0 S DWDFN=+$O(^DWCNST01("C","A",DWDFN)) Q:DWDFN=0  I $D(^DWCNST01("D",SVCN,DWDFN)) S CNT=CNT+1,ARY(CNT)=DWDFN_"^A"
 Q:'$D(ARY)
 D ^%AUCLS,HEAD,HD
 S DWDFN=0 F III=1:1:CNT S DWDFN=+ARY(III) Q:$D(XIT)  D DISP
 Q
DISP D IDSETUP
 W !,III,?6,STAT,?9,$E(PTNA,1,24),?35,$S(SEEN="N":"NO",SEEN="Y":"YES",1:""),?41,ID,?51,SVPRV,?65,WDRM K X1,X,Y,DWX
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
 S WDRM="" I $D(^DWCNST01(DWDFN,4)) S:$D(^DPT(+^(4),.1)) WDRM=$P(^(.1),"^",1) 
 I $D(^DWCNST01(DWDFN,4)) S:$D(^DPT(+^(4),.101)) WDRM=WDRM_"-"_$P(^(.101),"^",1) 
 S STAT="" S:$D(^DWCNST01(DWDFN,0)) STAT=$P(^(0),"^",4)
 S SVPRV="" I $D(^DIC(49,+$P(^DWCNST01(DWDFN,0),"^",3),0)) S SVPRV=$S($P(ARY(III),"^",2)="R":$P(^DIC(49,+$P(^DWCNST01(DWDFN,0),"^",3),0),"^",1),$P(ARY(III),"^",2)="A":"*"_$P(^VA(200,+$P(^DWCNST01(DWDFN,4),"^",5),0),"^",1),1:"")
 I SVPRV]""&($P(ARY(III),"^",2)="A") S SVPRV=$P(SVPRV,",",1)_","_$E($P(SVPRV,",",2),1,1)
 S SVPRV=$E(SVPRV,1,12)
 Q
CHKACC ;give opportunity to change accepting privider
 D ^%AUCLS,HEAD W !!!,HI_"This consult has already been accecpted by "_$P(^VA(200,USN,0),"^",1)_".",!!,"Do you want to take over this consult (Y/N)"
 S %=2 D YN^DICN W NO
 I %'=1 W !!,BLK_HI_"Ok, Nothing Done!"_NO,!!,"Press Return to Continue..." R XXX:60 K XXX Q
 S DR="16///^S X=USR" D ^DIE
 W !!,HI_"Ok, "_USR_" is now assigned to this consult!"_NO
 Q
PRT W !!,"Do want to print the Consultation Request (Y/N)" S %=1 D YN^DICN
 Q:%'=1
 K IOP
 S FLDS="[1966180-REQUEST]"
FPRT I '$D(^DWCNST01(DWDFN,0)) W !!,HI_"SORRY UNABLE TO SEND YOUR PRINT REQUEST - ABORTING"_NO H 3 Q
 S DIC=1966180,L=0,BY="NUMBER",FR=DWDFN,TO=DWDFN
 D EN1^DIP
 Q
VERIFY K XIT I '$D(^DWCNST01(DWDFN,0)) W !!,HI_"SORRY UNABLE VERIFY YOU ENTRY - ABORTING"_NO H 3 S XIT="" Q
XT K ARY,XIT,DTOUT,DUOUT,DIRUT,DIR SET SEL=0
 Q
MM ;mailman message if accepted
 Q:DUZ=ACUSER ;don't send message to yourself
 S PTNA="" I $D(^DWCNST01(DWDFN,4)) I $P(^(4),"^",1)]"" S:$D(^DPT(+$P(^(4),"^",1),0)) PTNA=$P(^(0),"^",1)
 I PTNA="" S PTNA="*** ERROR ON SET UP OF NAME ***"
 S ID="" I $D(^DWCNST01(DWDFN,4)) S:$D(^AUPNPAT(+$P(^(4),"^",1),41,DUZ(2),0)) ID=$P(^(0),"^",2) I ID="" S ID="*** ERROR IN SET UP OF ID ***"
 Q:'$D(^XMB(3.7,ACUSER,0))
 S Y=+$P(^VA(200,ACUSER,0),"^",11) I Y>0 Q
 S DWA(1)="**** NOTICE OF CONSULT ASSIGNEMENT **** "
 S DWA(2)=" "
 S DWA(3)="To: "_$S($D(^VA(200,ACUSER,0)):$P(^(0),"^",1),1:"")
 S DWA(4)=" "
 S DWA(5)=USR_" has assigned the following consult to you."
 S DWA(6)=" "
 S DWA(7)="Patient: "_PTNA_"   PIMC#: "_ID
 S DWA(8)=" "
 S DWA(9)="Please check consult system for details."
 S XMTEXT="DWA("
 S XMSUB="PIMC CONSULTATION REMINDER"
 Q:'$D(ACUSER)!(ACUSER=0)
 S XMY(ACUSER)=""
 S XMDUZ=DUZ
 D ^XMD
 K DWA,XMY,XMTEXT,XMSUB
 W !,HI_"MailMan message sent to :"_$S($D(^VA(200,ACUSER,0)):$P(^(0),"^",1),1:"")_NO H 2
 Q
OTHER ;replace usual service with the entry in ^DWCNST03 1966195 
 S OGSV=SVCN
 S OSIE=+$O(^DWCNST03("B",DUZ,0))
 I '$D(^DWCNST03(OSIE,0)) Q
 ; vjm 7/7/99 - commented the line below with the naked global
 ;              reference.  added the line as is should be.
 ;S SVCN=+$P(^(0),"^",2) I SVCN=0 K SVCN
 S SVCN=+$P(^DWCNST03(OSIE,0),U,2) I SVCN=0 K SVCN
 S NSVNA=$S($D(^DIC(49,SVCN,0)):$P(^(0),"^",1),1:"")
 I NSVNA="" K SVCN
 W !!,"You may SWITCH your Service From: "_SVC_" To: "_NSVNA,!!,"Do you want to switch" S %=2 D YN^DICN
 I %=1 S SVC=NSVNA Q
 S SVCN=OGSV
 Q
ASKPRT W !!,"Done.  Do you want to print a Final Consultation Form (Y/N)" S %=1 D YN^DICN
 I %'=1 Q
 S FLDS="[1966180-FINAL]" D FPRT
 S %=1
 Q
