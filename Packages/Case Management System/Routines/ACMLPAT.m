ACMLPAT ;cmi/anch/maw - LOOKUP FOR CMS CLIENTS ;  [ 02/10/2009  9:42 AM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**5,7,8**;JAN 10, 1996
 ;LOOKUP FOR CMS CLIENTS, INTERNAL ENTRY POINT: ADD
 ;PEP - LOOKUP CMS CLIENTS
EN Q:'$D(ACMRG)!$D(ACMQUIT)
 D LOOKUP
 D ^ACMLCMS:'$D(ACMQUIT)
 Q
LOOKUP D HEAD^ACMMENU
 I $P(^ACM(41.1,ACMRG,0),U,9)=1 W !!,*7,*7,"Patient lookup for the ",ACMRGNA,!,"is temporarily suspended during patient transfer." H 3 S ACMQUIT="ACMQUIT" Q
 S ACMX="PATIENT LOOKUP UTILITY"
 W !!?80-$L(ACMX)\2,ACMX,!!?15,"Select ",$S($D(ACMOUT):"another ",1:""),"CLIENT"
 K ACMX,ACMOUT
 ;cmi/anch/maw 8/14/2007 removed I from DIC call patch 7
 ;S DIC="^ACM(41,",DIC(0)="AEIMQ",DIC("A")="NAME OR CHART: ",D="B^C",DIC("S")="I $D(^ACM(41,+Y)),$P(^ACM(41,+Y,0),U)=ACMRG"
 S DIC="^ACM(41,",DIC(0)="AEMQ",DIC("A")="NAME OR CHART: ",D="B^C",DIC("S")="I $D(^ACM(41,+Y)),$P(^ACM(41,+Y,0),U)=ACMRG"
 ;cmi/anch/maw 8/14/2007 end of mods patch 7
 W !
 D MIX^DIC1
 K DIC
 I Y=-1&("^"[$E(X))!(X="") S ACMQUIT="ACMQUIT" Q
 I Y=-1 D NEW G LOOKUP
 S ACMPTNO=$P(^ACM(41,+Y,0),U,2),ACMPTNA=$P(^DPT(ACMPTNO,0),U),ACMPTNA2=$P($P(ACMPTNA,",",2)," ")_" "_$P(ACMPTNA,",")
 I '$D(^ACM(41,"AC",ACMPTNO,ACMRG)) W !!?10,@ACMRVON,ACMPTNA2,@ACMRVOFF," is not on the ",ACMRGNA," register.",!?10,"You must add the patient before entering or printing data." H 3 G EN
 S:'$D(ACMQUIT) ACMRGDFN=^ACM(41,"AC",ACMPTNO,ACMRG)
 I $D(ACMPTDEL) D DELETE Q
 D DECEASED(ACMPTNO,$G(ACMRGDFN)) ;IHS/CIM/THL PATCH 5
 Q
NEW W !?14,"This CLIENT is not a registered patient.",!?14,"He/she must be registered before entry in the CMS."
 S DIR(0)="EOA",DIR("A")="Press <ENTER> to continue..... "
 D ^DIR K DIR
 Q
ADD ;EP;TO ADD PATIENT TO A REGISTER
 Q:'$D(ACMRG)
 D HEAD^ACMMENU
 W !!?14,"Add patient(s) to the ",ACMRGNA," register."
 S DIC="^AUPNPAT(",DIC(0)="AEMQZ",DIC("A")="NAME, DOB OR CHART: "
 D SET^AUPNLKZ
 D ^AUPNLK
 D RESET^AUPNLKZ
 K DIC
 I Y=-1&("^"[$E(X))!(X="") Q
 I Y=-1 D NEW G ADD
 S ACMPTNO=+Y,ACMPTNA=$P(^DPT(+Y,0),U),ACMPTNA2=$P($P(ACMPTNA,",",2)," ")_" "_$P(ACMPTNA,",")
 I $D(^ACM(41,"AC",ACMPTNO,ACMRG)) W !!?14,ACMPTNA2," is already on the ",ACMRGNA," register." H 2 G ADD
 W !!?17,"Add ",@ACMRVON,ACMPTNA2,@ACMRVOFF,!?14,"to the ",@ACMRVON,ACMRGNA,@ACMRVOFF," register"
 S %=1
 D YN^DICN
 I %'=1 K ACMPTNO,ACMPTNA,ACMPTNA2 G ADD
 K DIC,DD
 S X=ACMRG,(DIE,DIC)="^ACM(41,",DIC(0)="L",DIC("DR")=".02////"_ACMPTNO_";1////A;2////"_DT_";4////"_DT
 K DD,DO D FILE^DICN K DIC,DIE,DR,DA
 D DECEASED(ACMPTNO,+Y) ;IHS/CIM/THL PATCH 5
 W !!,"Edit data for ",ACMPTNA
 S %=2
 D YN^DICN
 I %=1 S ACMRGDFN=^ACM(41,"AC",ACMPTNO,ACMRG) D ^ACMQK
 G ADD
 ;
DELETE ;D DUPCHK Q:$D(ACMQUIT) ;TMJ 11/7/94
 W !!?10,*7,*7,"******  WARNING  ******",!!,"This procedure will delete ALL data for",!?12,@ACMRVON,ACMPTNA2,@ACMRVOFF," from the ",!?12,@ACMRVON,ACMRGNA,@ACMRVOFF," register.",!,"Are you certain you want to do this" S %=2 D YN^DICN
 I %'=1 W !!,"No data deleted." H 1 S ACMQUIT="" Q
 W !!,"Deletion of ",@ACMRVON,ACMPTNA2,@ACMRVOFF,!?3,"from the ",@ACMRVON,ACMRGNA,@ACMRVOFF," register..."
 S ACMX=0,ACMGREF="^ACM(49)"
 F  S ACMX=$O(@ACMGREF@("AC",ACMRG,ACMPTNO,ACMX)) Q:'ACMX  S DA=0 F  S DA=$O(@ACMGREF@("AC",ACMRG,ACMPTNO,ACMX,DA)) Q:'DA  S DIK="^ACM(49,",DA=DA D ^DIK K DIK,DIC
 F ACMI=42,43,44,45,46,47,48,51,53,54,41 S ACMGREF="^ACM("_ACMI_")" F  S ACMX=$O(@ACMGREF@("AC",ACMRG,ACMPTNO,ACMX)) Q:'ACMX  S DIK="^ACM("_ACMI_",",DA=^(ACMX) D ^DIK W !,ACMI_"  "_DA K DIK,DIC,DA
 S DA=^ACM(41,"AC",ACMPTNO,ACMRG),DIK="^ACM(41,"
 D ^DIK
 K DIK,DIC,ACMGREF,ACMI,ACMX
 W "is now complete."
 S ACMQUIT=""
 H 3
 Q
DUPCHK N ACM
 K ACMQUIT
 S ACM=0
 F  S ACM=$O(^ACM(41,"C",ACMPTNO,ACM)) Q:'ACM  I ^ACM(41,"AC",ACMPTNO,ACMRG)'=ACM S DA=ACM,DIK="^ACM(41," D ^DIK S ACMQUIT="",^ACM(41,"AC",ACMPTNO,ACMRG)=$O(^ACM(41,"C",ACMPTNO,""))
 Q
DECEASED(DFN,DA) ;EP;TO SET STATUS TO DECEASED ;IHS/CIM/THL PATCH 5
 Q:DFN<1!(DA<1)
 Q:'$G(^DPT(DFN,.35))
 S DIE="^ACM(41,"
 S DR="1////D"
 D ^DIE
 K DA,DIE,DR
 Q
