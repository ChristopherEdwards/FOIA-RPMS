BYIMIMM6 ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**3**;JAN 15, 2013;Build 79
 ;
MENU ;EP;HEADER DISPLAY
 W @IOF
 N PAC,PAH,VER,EXP,IMP
 D M1
 D M2
 Q
 S K=1
 D L1
 D L2
 D L3
 S K=2
 D L2
 D L1
 Q
L1 ;
 S X=""
 F J=17:1:55 S $E(X,J)="*"
 W !,X
 Q
 ;-----
L2 ;
 F J=1:1:2 D
 .S X=""
 .I J=1,K=1 S $E(X,17)="** Immunization Data Exchange"
 .I J=2,K=1 S $E(X,17)="** "_$E(LOC,1,26)
 .I J=1,K=2 S $E(X,17)="** "_VER
 .I J=2,K=2 S $E(X,17)="** "_HL7
 .S $E(X,47)="|*     **                      **"
 .W !,X
 Q
 ;-----
L3 ;
 S X=""
 S $E(X,2)="<"
 F J=3:1:17 S $E(X,J)="="
 S $E(X,47)="|"
 F J=48:1:79 S $E(X,J)="*"
 W !,X
 Q
 ;-----
L32 ;
 S X=""
 F J=5:1:23 S $E(X,J)="*"
 S $E(X,17)="*   **"
 F J=29:1:73 S $E(X,J)="*"
 W !,X
 Q
 ;-----
M1 ;MENU DISPLAY
 D PATH^BYIMIMM
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
