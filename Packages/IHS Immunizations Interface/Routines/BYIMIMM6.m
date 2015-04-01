BYIMIMM6 ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE;**3,4,5,6**;NOV 01, 2013;Build 229
 ;
MENU ;EP;HEADER DISPLAY
 W @IOF
 N PAC,PAH,VER,EXP,IMP
 D M1
 D M2
 Q
 ;-----
M1 ;MENU DISPLAY
 D PATH
 S (PAC,PAH,VER)=""
 S PAC=+$O(^DIC(9.4,"C","BYIM",0))
 S VER=$P($G(^DIC(9.4,PAC,"VERSION")),U)
 S:VER PAH=$O(^DIC(9.4,PAC,22,"B",VER,0))
 S:PAH PAH=$O(^DIC(9.4,PAC,22,PAH,"PAH","B",99999),-1)
 S:PAH]"" VER=VER_" P "_PAH
 S VER="BYIM: "_VER
 S HL7="HL7 : "_BYIMVER
 S LOC=$P($G(^DIC(4,DUZ(2),0)),U)
 N X
 S X="Immunization Data Exchange"
 S EXP=$O(^DIC(19,"B","BYIM IZ AUTO EXPORT",0))
 S EXP=$O(^DIC(19.2,"B",+EXP,0))
 S EXP=$P($G(^DIC(19.2,+EXP,0)),U,2)
 I EXP S Y=EXP D DD^%DT S EXP=$P(Y,",")_"@"_$P(Y,"@",2)
 S EXP="NEXT EXP: "_$S(EXP="":"NOT SCHED",1:EXP)
 S IMP=$O(^DIC(19,"B","BYIM IZ AUTO IMPORT",0))
 S IMP=$O(^DIC(19.2,"B",+IMP,0))
 S IMP=$P($G(^DIC(19.2,+IMP,0)),U,2)
 I IMP S Y=IMP D DD^%DT S IMP=$P(Y,",")_"@"_$P(Y,"@",2)
 S IMP="NEXT IMP: "_$S(IMP="":"NOT SCHED",1:IMP)
 Q
 ;-----
ADDLOT(DFN,IVDA,LOTDA,VDATE) ;EP;TO ADD LOT NUMBER
 ;DFN     - PATIENT DFN
 ;IVDA    - IMMUNIZATION FILE IEN
 ;LOTDA   - LOT NUMBER FILE IEN
 ;VDATE   - VISIT DATE
 H 1
 N X,Y,Z
 S X=$O(^AUPNVIMM("AC",DFN,9999999999),-1)
 Q:'X
 Q:+$G(^AUPNVIMM(X,0))'=IVDA
 Q:$P($G(^AUPNVIMM(X,0)),U,5)
 S Y=+$P($G(^AUPNVIMM(X,0)),U,3)
 Q:$P($G(^AUPNVSIT(Y,0)),".")'=$P(VDATE,".")
 N DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S DA=X
 S DR=".05////"_LOTDA
 S DIE="^AUPNVIMM("
 D ^DIE
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 Q
 ;-----
M2 ;VERSION 2.0 HEADER
 N X
 S X="Immunization Data Exchange"
 W !?80-$L(X)\2,X
 W !?80-$L(LOC)\2,LOC
 W !!?20,VER,?40,EXP
 W !?20,HL7,?40,IMP
 Q
 ;-----
SCRN(INDA) ;EP;TO SCREEN IMM'S TO INCLUDE IN EXPORT
 I $G(INDA("BYIMALL"))=2 Q 1
 I $L($G(INDA("DDATE")))=7,$P($G(^AUPNVIMM(INDA,12)),U,18)>INDA("DDATE") Q 1
 I '$G(BYIMDATE) N X S X=9999999999,BYIMDATE=0 F  S X=$O(^BYIMPARA(DUZ(2),"LAST EXPORT",X),-1) Q:'X!BYIMDATE  I $P(^(X),U,2)]"" S BYIMDATE=X
 I BYIMDATE,$P($G(^AUPNVIMM(INDA,12)),U,18)>BYIMDATE Q 1
 I '$D(^BYIMEXP("D",INDA)),$P($G(^AUPNVIMM(INDA,0)),U,15)!($P($G(^AUTTIMM(+$G(^AUPNVIMM(+$G(INDA),0)),0)),U,3)=999) S ^BYIMEXP("D",INDA)="" Q 0
 I '$D(^BYIMEXP("D",INDA)),'$P($G(^AUPNVIMM(INDA,0)),U,15),$P($G(^AUTTIMM(+$G(^AUPNVIMM(+$G(INDA),0)),0)),U,3)'=999 Q 1
 Q 0
 ;-----
HFSA(DEST,PRI) ;EP;TO FIND HL7 MESSAGE THAT HAVEN'T BEEN EXPORTED
 Q:PRI=""!'DEST
 K ^BYIMTMP("LE")
 K ^BYIMTMP("OF")
 N X,Y,Z,XX
 S X=""
 F  S X=$O(^INLHDEST(DEST,PRI,X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(^INLHDEST(DEST,PRI,X,Y)) Q:'Y  S ^BYIMTMP("OF",Y)="" S:$G(^INTHU(Y,3,1,0))["FHS|" XX=$P(X,",")_","_($P(X,",",2)+1)
 S X=0
 ;PATCH 5 change ..."LAST EXPORT"),X... to ..."LAST EXPORT",X)...
 ;F  S X=$O(^BYIMPARA(DUZ(2),"LAST EXPORT",X)) Q:'X  I X'=DT,'$P(^(X),U,2) S ^BYIMTMP("LE",X+17000000)="",$P(^BYIMPARA(DUZ(2),"LAST EXPORT"),X,U,2)=$P(^BYIMPARA(DUZ(2),"LAST EXPORT",X),U)
 F  S X=$O(^BYIMPARA(DUZ(2),"LAST EXPORT",X)) Q:'X  I X'=DT,'$P(^(X),U,2) S ^BYIMTMP("LE",X+17000000)="",$P(^BYIMPARA(DUZ(2),"LAST EXPORT",X),U,2)=$P(^BYIMPARA(DUZ(2),"LAST EXPORT",X),U)
 ;END PATCH 5
 S:$G(BYIM("MSH3.1"))="" BYIM("MSH3.1")=$P($G(^BYIMPARA(DUZ(2)),1),U,3)
 S:$G(BYIM("MSH3.1"))="" BYIM("MSH3.1")="RPMS"
 S:'$G(XX) XX=$H
 S X=0
 F  S X=$O(^INTHU(X)) Q:'X  S Z=$G(^(X,3,1,0)) I Z["VXU^V04",Z["MSH|" D
 .Q:$P($P(Z,"|",3),U)'=BYIM("MSH3.1")
 .Q:$P(Z,"|",10)=""
 .Q:$D(^BYIMTMP("OF",X))
 .Q:$D(^BYIMMM("MID",$P(Z,"|",10)))
 .S Y=$E($P(Z,"|",7),1,8)
 .Q:'$D(^BYIMTMP("LE",Y))
 .S ^BYIMMM("MID",$P(Z,"|",10))=""
 .S ^INLHDEST(DEST,PRI,XX,X)=""
 .S ^BYIMTMP("OF",X)=""
 .S $P(^BYIMTMP("NUM"),U,2)=$P($G(^BYIMTMP("NUM")),U,2)+1
 .S Y=0
 .F  S Y=$O(^INTHU(X,3,Y)) Q:'Y  S:^(Y,0)["RXA|" $P(^BYIMTMP("NUM"),U,3)=$P($G(^BYIMTMP("NUM")),U,3)+1
 K ^BYIMTMP("LE")
 K ^BYIMTMP("OF")
 Q
 ;-----
RLSH ;EP;TO DISPLAY AND EDIT RELATIONSHIP
 K BYIMQUIT
 D RUPD
 D RDISPLAY
 F  D REDIT Q:$D(BYIMQUIT)
 Q
 ;-----
RUPD ;EP;TO UPDATE IZ RELATIONSHIP FILE FROM RELATIONSHIP FILE
 N X,Y,Z,XX,YY,ZZ
 S XX=0
 F  S XX=$O(^AUTTRLSH(XX)) Q:'XX  S Y=$P(^(XX,0),U) D:'$D(^BYIMREL(XX))
 .S Z=$O(^BYIMCDC("C",Y,0))
 .S X=XX
 .K DIC,DINUM,DR,DA
 .S DINUM=X
 .S DIC="^BYIMREL("
 .S DIC(0)="L"
 .S:Z DIC("DR")=".02////"_Z
 .D FILE^DICN
 .K DIC,DINUM,DR,DA
 .Q:$D(ZTQUEUED)
 .W !,XX,?10,$P(^AUTTRLSH(XX,0),U)," added to BYIM Relationship Table."
 Q
 ;-----
RDISPLAY ;EP;TO DISPLAY BYIM/CDC RELATIONSHIP CROSS OVER
 D RDHEAD
 D PAUSE^BYIMIMM6
 D RD
 N X,Y,Z,XX,YY,ZZ,JJ,BYIMPAUS
 S BYIMPAUS=""
 S JJ=0
 S XX=0
 F  S XX=$O(^BYIMREL(XX)) Q:'XX!$L(BYIMPAUS)  S Y=^(XX,0) D
 .S Z=^AUTTRLSH(XX,0)
 .S Z21=$G(^AUTTRLSH(XX,21))
 .W !,$J(XX,4)
 .W:$P(Y,U,2) ?10,$P(^BYIMCDC($P(Y,U,2),0),U)
 .W ?20,$P(Z,U),?52,$P(Z21,U,4)
 .S JJ=JJ+1
 .I JJ#15=0 D PAUSE^BYIMIMM6
 Q
 ;-----
REDIT ;EP;TO EDIT RELATIONSHIP CROSS OVER
 W !!,"Select No. to Edit"
 K DIR
 S DIR(0)="NO^1:"_$O(^BYIMREL(9999999999),-1)
 S DIR("A")="LOCAL Relationship No. (or '^' to exit)"
 W !
 D ^DIR
 K DIR
 I X[U S BYIMQUIT="" Q
 Q:X=""
 S BYIMJ=X
 I '$D(^BYIMREL(BYIMJ,0)) W !!,"No. ",BYIMJ," isn't defined." H 2 Q
 W !!?10,"RPMS - RELATIONSHIP entry selected: ",$P($G(^AUTTRLSH(BYIMJ,0)),U)
 S DA=BYIMJ
 S DR=".02T"
 S DIE="^BYIMREL("
 D ^DIE
 Q
 ;
RDHEAD ;
 W @IOF
 W !!?10,"CDC HL7 Table 0063 Codes and Descriptions"
 W !!,"Code",?10,"Description"
 W !,"-------",?10,"------------------------------"
 N X,Y,Z
 S X=0
 F  S X=$O(^BYIMCDC(X)) Q:'X  S Y=^(X,0) D
 .W !,$P(Y,U),?10,$P(Y,U,2)
 Q
 ;-----
RD ;RELATIONSHIP LIST DISPLAY
 W @IOF
 W !?10,"BYIM Immunization Data Exchange"
 W !?10,"Local RELATIONSHIP entry and CDC HL7 Table 0063 Code"
 W !?10,"(NOTE: Local RELATIONSHIP without CDC HL7 code will be sent as 'OTH')"
 W !!,?10,"CDC HL7",?52,"Local HL7"
 W !,"No.",?10,"Code",?20,"Local RELATIONSHIP Description",?52,"Code"
 W !,"----",?10,"---",?20,"------------------------------",?52,"---------"
 Q
 ;-----
PATH ;EP;SET PATH
 N X,X0
 S X0=$G(^BYIMPARA(DUZ(2),0))
 S X1=$G(^BYIMPARA(DUZ(2),1))
 S X6=$G(^BYIMPARA(DUZ(2),6))
 S OPATH=$P(X0,U,2)
 S IPATH=$P(X0,U,3)
 S QPATH=$P(X1,U)
 S RPATH=$P(X1,U,2)
 S BYIMEXT=$P(X0,U,8)
 S:BYIMEXT="" BYIMEXT="dat"
 S BYIMIN1=$P(X0,U,16)
 S X=$P(X0,U,11)
 S Y=$P(^DD(90480,.11,0),U,3)
 S BYIMVER=$P($P(Y,X_":",2),";")
 S BYIMBDG=$P(X0,U,12)
 S BYIMQT=$P(X0,U,13)
 S BYIMMSH8=$P(X0,U,15)
 S BYIM("MSH4.1")=$P(X0,U,7)
 S BYIM("MSH3.1")=$P(X1,U,3)
 S BYIM("MSH3.2")=$P(X1,U,4)
 S BYIM("MSH3.3")=$P(X1,U,5)
 S BYIM("MSH4.2")=$P(X1,U,6)
 S BYIM("MSH4.3")=$P(X1,U,7)
 S BYIM("MSH6")=$P(X1,U,8)
 S BYIM("PD13.1")=$P(X6,U)
 S BYIM("PD13.2")=$P(X6,U,2)
 S BYIM("MSH5.1")=$P(X6,U,3)
 S BYIM("MSH5.2")=$P(X6,U,4)
 S BYIM("MSH5.3")=$P(X6,U,5)
 S BYIMHIST=$P(X6,U,6)
 S BYIMESSN=$P(X6,U,7)
 S ASUFAC=$P($G(^AUTTLOC(+$G(DUZ(2)),0)),U,10)
 Q
 ;-----
NOPATH ;EP;NO PATH MESSAGE
 I $D(ZTQUEUED) S BYIMQUIT="" Q
 W @IOF
 W !!,"You are logged into site: ",$P(^AUTTLOC(DUZ(2),0),U,2)
 W !!,"Directory path information was missing."
 W !,"Please contact your Site Manager.  There must be entries in the"
 W !!?10,"PATH FOR OUTNBOUND MESSAGES field and the"
 W !?10,"PATH FOR INBOUND MESSAGES field of the"
 W !?10,"IZ PARAMETERS file for ",$P(^AUTTLOC(DUZ(2),0),U,2)
 D PAUSE
 Q
 ;-----
PAUSE ;EP;FOR PAUSE READ
 Q:$E($G(IOST),1,2)'="C-"
 W !
 K DIR
 S DIR(0)="E"
 S:'$D(DIR("A")) DIR("A")="Press <ENTER> to continue or '^' to exit..."
 D ^DIR
 K DIR
 S BYIMPAUS=X
 Q
 ;-----
