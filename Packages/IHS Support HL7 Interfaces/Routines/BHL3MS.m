BHL3MS ;cmi/flag/maw - BHL Setup 3m Workstations [ 07/05/2002  2:22 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;
 ;
 ;
 ;this routine will allow the medical records staff to setup
 ;3M workstations.  It will add the IP address to the background
 ;process file, set up the destination properly, and then activate
 ;the transaction type and add it to the message multiple
 ;
MAIN ;EP - this is the main routine driver
 S BHLCONT=$$READY
 I '$G(BHLCONT) D  Q
 . W !,"Get IP address and 3m Port, run option again"
 . D EOJ
SET S BHLWS=$$ASK
 I '$G(BHLWS) W !,"Invalid Workstation Entered" D EOJ Q
 S BHLMN=$$MN("3M")
 D ACT(BHLWS)
 S BHLAN=$$AGAIN
 I $G(BHLAN) G SET
 D EOJ
 Q
 ;
READY() ;-- write message and ask for confirmation 
 W !!,"You must know the IP address and 3M port number"
 S DIR(0)="Y",DIR("A")="Continue "
 S DIR("B")="N"
 D ^DIR
 K DIR
 Q $G(Y)
 ;
ASK() ;-- ask the workstation id     
 S DIR(0)="N^2:14"
 S DIR("A")="What workstation number should I activate"
 D ^DIR
 Q:Y<0
 K DIR
 Q $G(Y)
 ;
AGAIN() ;-- ask the workstation id     
 S DIR(0)="Y"
 S DIR("A")="Do you wish to activate another"
 D ^DIR
 Q:Y<0
 K DIR
 Q $G(Y)
 ;
ACT(WS) ;-- activate the workstation and interface 
 S BHLBP=$O(^INTHPC("B","HL IHS 3M SENDER "_WS,0))
 S BHLDS="HL IHS 3M CODER "_WS
 S BHLTT="HL IHS A08 OUT 3M "_WS
 S BHLTTI=$O(^INRHT("B",BHLTT,0))
 S BHLTTP="HL IHS A08 OUT 3M P "_WS
 S BHLTTPI=$O(^INRHT("B",BHLTTP,0))
 S BHLMI=$O(^INTHL7M("B","HL IHS A08 OUT 3M",0))
 S BHLMII=$O(^INTHL7M("B","HL IHS A08 IN 3M",0))
 S BHLBP0=$G(^INTHPC(BHLBP,6,0))
 K ^INTHPC(BHLBP,6)
 S ^INTHPC(BHLBP,6,0)=$G(BHLBP0)
 S $P(^INTHPC(BHLBP,6,0),U,3)=""
 S $P(^INTHPC(BHLBP,6,0),U,4)=""
 W !!,"Now setting up the IP address of workstation ID "_WS
 K DIE,DR,DA,Y
 S DIE="^INTHPC("_BHLBP,DA=BHLBP,DR=".02///1;.07///"_BHLDS
 D ^DIE
 S DIC=DIE_",6,",DIC(0)="AELMQZ"
 S DIC("P")=$P(^DD(4004,6,0),U,2)
 S DA(1)=BHLBP
 D ^DIC
 Q:Y<0
 S BHLIPI=+Y
 K DA
 S DIC=DIC_BHLIPI_",1,"
 S DA(2)=BHLBP,DA(1)=BHLIPI
 S DIC("P")=$P(^DD(4004.03,.02,0),U,2)
 D ^DIC
 Q:Y<0
 K DIC,DIE,DR,DA
 W !!,"IP Address now set up, continuing with transaction setup..."
 S DIE="^INRHT(",DA=BHLTTI
 S DR=".02///"_BHLDS_";.05///ACTIVE"
 D ^DIE
 S DA=BHLTTPI,DR=".05///ACTIVE"
 D ^DIE
 K DIE
 K DD,DO,DA
 S DIC="^INTHL7M("_BHLMI_",2,",DIC(0)="L"
 S DA(1)=BHLMI
 S DIC("P")=$P(^DD(4011,2,0),U,2)
 S X=BHLTTI
 D FILE^DICN
 W !!,"Now compiling the message"
 F BHLY=BHLMI,BHLMII D COMPILE^BHLU(BHLY)
 W !!,"3M Workstation ID "_WS_" is now ready for use"
 Q
 ;
MN(MN) ;-- activate the mnemonic
 S BHLMNI=$O(^APCDTKW("B",MN,0))
 I 'BHLMNI Q ""
 S DIE="^APCDTKW(",DA=BHLMNI,DR=".07///A"
 D ^DIE
 K DIE,DR,DA
 Q +Y
 ;
EOJ ;-- kill variables and quit     
 D ^XBFMK
 D EN^XBVK("BHL")
 Q
 ;
