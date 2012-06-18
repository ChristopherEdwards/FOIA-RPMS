BMCVDV1 ; IHS/OIT/FCJ - SELECT CONTRACT NUMBER ; [ 10/15/2004  3:02 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**5**;JAN 09, 2006
 ;BMC*4.0*5 5.13.2009 IHS.OIT.FCJ ORIGIAL ROUTINE FR ACHSVDV1
 ;
A4 ;EP
 G A6:'$D(^AUTTVNDR(BMCPROV,"CN"))
 K BMCCTFL,BMCRQFL,BMCPAFL,BMCBPFL
 ;
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Contract Information","NO","","","",2)
 G END^BMCVDV:$D(DTOUT),A1^BMCVDV:$D(DUOUT),A6:'Y
 S BMCACO="L",P=BMCPROV,A("DISPLAY")=1,BMCCTFL=""
 D L^BMCVDV1
A6 ;
 G:BMCRT("RQ")<0 A7
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Rate Quotation Information","NO","","","",2)
 G END^BMCVDV:$D(DTOUT),A1^BMCVDV:$D(DUOUT),A7:'Y
 S BMCAGTP="RQ",BMCRQFL=""
 D AGRDSP^BMCVDV2
A7 ;
 G:'$D(BMCRT("PA")) A8
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Agreement Information","NO","","","",2)
 G END^BMCVDV:$D(DTOUT),A1^BMCVDV:$D(DUOUT),A8:'Y
 S BMCAGTP="PA",BMCPAFL=""
 D AGRDSP^BMCVDV2
A8 ;
 G:'$D(BMCRT("BPA")) A9
 S Y=$$DIR^XBDIR("Y","Want to see Vendor BPA Information","NO","","","",2)
 G END^BMCVDV:$D(DTOUT),A1^BMCVDV:$D(DUOUT),A9:'Y
 S BMCAGTP="BPA",BMCBPFL=""
 D AGRDSP^BMCVDV2
A9 ;
 I '$D(^XUSEC("BMCZVEN",DUZ)) G END^BMCVDV:'$$DIR^XBDIR("E")
 G A1^BMCVDV
 ;
L ;EP
 S E=9999999-DT,(S,C,L)=""
 I '$D(BMCACO) S BMCACO=""
L1 ;
 S S=$O(^AUTTVNDR(BMCPROV,"E",S))
 G L3:S=""
 S N=""
L2 ;
 S N=$O(^AUTTVNDR(BMCPROV,"E",S,N))
 G L1:N="",L2:'$D(^AUTTVNDR(BMCPROV,"CN",N,0))
 S I=$P(^AUTTVNDR(BMCPROV,"CN",N,0),U),C=C+1,L=N_U_S_U_I I BMCACO["L" D SBT:C=1 W !,$J(C,2),?3,$J($P(^(0),U),18) S D=$P(^(0),U,2,3) D SBD S C(C)=N
 I BMCACO["F",C=F G L3
 I $Y>24 K DIR S DIR(0)="E" D ^DIR Q:Y=0  K DIR D SBT
 G L2
 ;
L3 ;
 G END:'$D(^XUSEC("BMCZVEN",DUZ)),NEW:'$D(^AUTTVNDR(BMCPROV,"CN")),NEW:$P(^AUTTVNDR(BMCPROV,"CN",0),U,4)<1!(A("DISPLAY"))!(+C<1)
 W !!,"Which one: "
 D READ^BMC
 G END:$D(DUOUT)
 I Y?1"?".E W !!?3,"Enter 1 thru ",C G L3
 I Y="" G NEW
 I Y'?1N.N!(Y>C) W !!,"Enter 1 thru ",C G L3
 S DA=C(Y)
END ;
 K C,N,S,BMCCTFL,BMCRQFL,BMCPAFL,BMCBPFL
 Q
 ;
SBD ;
 W ?22,$$FMTE^XLFDT($P(D,U)),?35,$$FMTE^XLFDT($P(D,U,2)),?49,$E($P(^AUTTVNDR(BMCPROV,"CN",N,0),U,5),1,30)
 Q
 ;
SBT ;EP
 W @IOF,!!?5,"Contract Number",?22,"Begin Date",?35,"Ending Date",?49,"Description of Service",!?5,"---------------",?22,"------------",?35,"------------",?49,"-------------------------"
 Q
 ;
NEW ;
 W:+C<1 !!,"No Contracts on file."
 I $D(BMCCTFL) S DA="" G END
 W !!,"Want to Enter a New Contract?  NO// "
 D READ^BMC
 G END:$D(DUOUT)
 S Y=$E(Y_"N"),Y=$$UP^XLFSTR(Y)
 I Y?1"?".E D YN^BMC G NEW
 I Y=""!(Y?1"N".E) S DA="" G END
 I Y'?1"Y".E D YN^BMC G NEW
NEW1 ;
 W !!,"Enter CONTRACT NUMBER: "
 D READ^BMC
 G NEW:$D(DUOUT)
 I Y?1"?".E W !!,"Enter New Contract Number " G NEW1
 G NEW:Y=""
 S:'$D(^AUTTVNDR(BMCPROV,"CN",0)) ^(0)="^9999999.1112^"
 S DA(1)=BMCPROV,X=Y,DIC="^AUTTVNDR("_BMCPROV_",""CN"",",DIC(0)="ELMQZ"
 D ^DIC
 G NEW:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_BMCPROV_",""CN"",",DA(1)=BMCPROV,DR="1;2;4;3"
 D ^DIE
 K DIE,DA
 G END
 ;
MP ;EP
 W @IOF D MPDSP
 S (BMCMP,CT)=0
 F I=1:1  S BMCMP=$O(^AUTTVNDR(BMCPROV,"MP",BMCMP)) Q:BMCMP'>0  D
 .S BMCDSP(I)=^AUTTVNDR(BMCPROV,"MP",BMCMP,0)
 .I BMCDSP(I)'="" S CT=CT+1 S BMCMPN=$P(BMCDSP(I),U),BMCBDT=$P(BMCDSP(I),U,3),BMCEDT=$P(BMCDSP(I),U,4),BMCDES=$P(BMCDSP(I),U,2)
 .I $D(BMCDES) S BMCDES=$$EXTSET^XBFUNC(9999999.112303,2,BMCDES)
 .W ?2,CT,?6,$G(BMCMPN),?23,$$FMTE^XLFDT($G(BMCBDT)),?37,$$FMTE^XLFDT($G(BMCEDT)),?51,$G(BMCDES),!
 W:CT=0 !!,?6,"No Medicare Numbers listed.",! G ASK1
 I CT>0 G ASK1
 Q
 ;
MPDSP ;DISPLAY MEDICARE PROVIDER INFO
 W !!,"Item",?6,"Medicare Number",?23,"Begin Date",?37,"End Date",?51,"Description",!,"----",?6,"---------------",?23,"------------",?37,"------------",?51,"-------------------------",!
 Q
 ;
ASK1 ;     
 S Y=$$DIR^XBDIR("Y","Want to add Medicare Information","NO","","","",2)
 G END:$D(DUOUT),ASK2:'Y
 I Y G MPADD
ASK2 ;
 S Y=$$DIR^XBDIR("Y","Want to edit Medicare Information","NO","","","",2)
 G END:$D(DUOUT),END:'Y
 I Y G MPEDIT
MPADD ;
 W !!,"Enter the Medicare NUMBER: "
 D READ^BMC
 G END:$D(DUOUT)
 I Y?1"?".E W !!,"Enter New Number " G MPADD
 S:'$D(^AUTTVNDR(BMCPROV,"MP",0)) ^(0)="^9999999.112303^"
 S DA(1)=BMCPROV,X=Y,DIC="^AUTTVNDR("_BMCPROV_",""MP"",",DIC(0)="ELMQZ"
 D ^DIC
 G MPADD:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_BMCPROV_",""MP"",",DA(1)=BMCPROV,DR="2;3;4"
 D ^DIE
 K DIE,DA
 G END
 ;
MPEDIT ;
 W !!,"Which item: "
 D READ^BMC
 G END:$D(DUOUT)
 I Y?1"?".E W !!?3,"Enter 1 thru ",CT G MPEDIT
 I Y="" G MPEDIT
 I Y'?1N.N!(Y>CT) W !!,"Enter 1 thru ",CT G MPEDIT
 S X=$P(BMCDSP(Y),U)
 S DA(1)=BMCPROV,DIC="^AUTTVNDR("_BMCPROV_",""MP"",",DIC(0)="ELMQZ"
 D ^DIC
 G MPADD:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_BMCPROV_",""MP"",",DA(1)=BMCPROV,DR=".01;2;3;4"
 D ^DIE
 K DIE,DA
 G END
 G END:'Y
