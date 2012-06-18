ACDAUTO ;IHS/ADC/EDE/KML - auto-create an initial or reopen;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;***************************************************************
 ;ACDVISP=DA
 ;ACDDFNP=PATIENT
 ;Auto create may be executed only if the user has just finished
 ;adding a new entry and the contact type was 'TDC'
 ;*****************************************************************
EN ;EP
 ;//^ACDDE
 ;
 Q:'$G(ACDVISP)
 S:'$D(ACDLINE) $P(ACDLINE,"=",80)="="
 W @IOF,!,ACDLINE,!,*7,*7,*7,"Since you have created a new Transfer/Discharge/Close visit, I can now"
 W !,"automatically create an Initial or Re-open visit for you with a new"
 W !,"component code/type that you select."
 W !!,"If you plan to provide future services after discharge you should create an"
 W !,"Initial for the AFTCARE component."
 W !,ACDLINE
 ;
EN1 ;
 S DIR("A")="Choose =>"
 S DIR(0)="S^1:CREATE A NEW INITIAL VISIT;2:CREATE A NEW RE-OPEN VISIT;3:EXIT" D ^DIR
 S ACDCONT=Y
 G:X["^"!($D(DTOUT)) K I Y=3 W !!,"OK, no new visit created..." G K
 ;
 ;Get new component code
 K DIR,X,Y S DIR(0)="P^9002170.1:AEQM" D ^DIR G:"^"[X!($D(DTOUT)) K
 S ACDCOMC=+Y
 ;
 ;Get new component type
 K DIR,X,Y S DIR(0)="9002172.1,5" D ^DIR G:"^"[X!($D(DTOUT)) K
 S ACDCOMT=Y
 ;
 ;Check for initial contact for component
 S Y=0,DA=ACDVISP F ACDDA=0:0 S ACDDA=$O(^ACDVIS("D",ACDDFNP,ACDDA)) Q:'ACDDA  I ACDDA'=DA S ACDN0=^ACDVIS(ACDDA,0) I $P($G(^("BWP")),U)=ACDPGM,$P(ACDN0,U,2)=ACDCOMC,$P(ACDN0,U,4)="IN" S Y=1 Q
 I ACDCONT=1,Y W !!!,*7,*7,"An INITIAL visit already exists for this component code.",!,"No new visit created. You may try again." D PAUSE^ACDDEU,GETVSITS^ACDDEU,DSPHIST^ACDDEU,K G EN1
 I ACDCONT=2,'Y W !!!,*7,*7,"No INITIAL visit exists for this component code.",!,"No new visit created. You may try again." D PAUSE^ACDDEU,GETVSITS^ACDDEU,DSPHIST^ACDDEU,K G EN1
 W !!,"Filing new entry now...."
 S ACD("V")=^ACDVIS(ACDVISP,0)
 S $P(ACD("V"),U,4)=$S(ACDCONT=1:"IN",1:"RE")
 S $P(ACD("V"),U,2)=ACDCOMC
 S $P(ACD("V"),U,7)=ACDCOMT
 S ACDVPGM=^ACDVIS(ACDVISP,"BWP")
FILEV ;File visit into ^ACDVIS
 S DIC="^ACDVIS(",X=$P(ACD("V"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDVIS(+Y,0)=ACD("V")
 S ACDBWP=+Y
 S DIE="^ACDVIS(",DA=ACDBWP,DR="99.99////"_ACDVPGM_";1102////"_DUZ D DIE^ACDFMC
 S DA=ACDBWP,DIK="^ACDVIS(" D IX1^DIK
IIF ;
 S ACDDA=$O(^ACDTDC("C",ACDVISP,0))
 S ACD("TDC")=^ACDTDC(ACDDA,0)
 ;
 S $P(ACD("IIF"),U)=$P(ACD("TDC"),U,27)
 S $P(ACD("IIF"),U,2)=$P(ACD("TDC"),U,28)
 S $P(ACD("IIF"),U,4)=$P(ACD("TDC"),U)
 S $P(ACD("IIF"),U,5)=$P(ACD("TDC"),U,2)
 S $P(ACD("IIF"),U,7)=$P(ACD("TDC"),U,4)
 S $P(ACD("IIF"),U,8)=$P(ACD("TDC"),U,5)
 S $P(ACD("IIF"),U,10)=$P(ACD("TDC"),U,7)
 S $P(ACD("IIF"),U,11)=$P(ACD("TDC"),U,8)
 S $P(ACD("IIF"),U,12)=$P(ACD("TDC"),U,9)
 S $P(ACD("IIF"),U,13)=$P(ACD("TDC"),U,10)
 S $P(ACD("IIF"),U,14)=$P(ACD("TDC"),U,11)
 S $P(ACD("IIF"),U,15)=$P(ACD("TDC"),U,12)
 S $P(ACD("IIF"),U,16)=$P(ACD("TDC"),U,13)
 S $P(ACD("IIF"),U,17)=$P(ACD("TDC"),U,14)
 S $P(ACD("IIF"),U,18)=$P(ACD("TDC"),U,15)
 S $P(ACD("IIF"),U,19)=$P(ACD("TDC"),U,16)
 S $P(ACD("IIF"),U,20)=$P(ACD("TDC"),U,17)
FILEIIF ;File entry into ^ACDIIF
 S DIC="^ACDIIF(",X=$P(ACD("IIF"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDIIF(+Y,0)=ACD("IIF"),^("BWP")=ACDBWP
 S ACDIIF=+Y
 ; set variables for PCC link
 I (ACDFHCP+ACDFPCC) S ACDPCCL(ACDDFNP,ACDBWP)="",ACDPCCL(ACDDFNP,ACDBWP,"IIF",ACDIIF)=""
 F ACDMULT=2,3 F ACDMLEV=0:0 S ACDMLEV=$O(^ACDTDC(ACDDA,ACDMULT,ACDMLEV)) Q:'ACDMLEV  S ACDPNTR=^(ACDMLEV,0) D
 .S:ACDMULT=3 DIC("DR")=".02////"_$P(^ACDTDC(ACDDA,ACDMULT,ACDMLEV,0),U,2)
 .S DA(1)=ACDIIF,DIC="^ACDIIF("_DA(1)_","_ACDMULT_",",DIC(0)="L",X=ACDPNTR S:'$D(@(DIC_"0)")) @(DIC_"0)")="^9002170."_$S(ACDMULT=2:"05",1:"01")_"PA" D FILE^ACDFMC
 S DA=ACDIIF,DIK="^ACDIIF(" D IX1^DIK
 I (ACDFHCP+ACDFPCC) S ACDPCCL(ACDDFNP,ACDVISP)="",ACDPCCL(ACDDFNP,ACDVISP,"IIF",ACDIIF)=""
 W !!,"Finished auto creation..."
 ;
K ;
 K ACDCOMC,ACDCOMT,ACDCONT,ACDDA,ACDIIF,ACDLINE,ACDMLEV,ACDMULT,ACDPNTR
 Q
