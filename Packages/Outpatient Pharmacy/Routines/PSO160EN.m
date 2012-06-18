PSO160EN ;BIR/MR-Patch 160 Environment Check routine ;11/27/03
 ;;7.0;OUTPATIENT PHARMACY;**160**;DEC 1997
 ;External reference to ^ORD(101, is supp. by DBIA# 872
 ;
 N RXSTS,DIR,SDPRTCL,PSOPRTCL,X,DIC,DA,DLAYGO,DD,DO,DINUM,Y
 ;
 ;- Looking for 'NON-VA' entry in the RX PATIENT STATUS file (#53)
 S XPDABORT=2
 S RXSTS="" F  S RXSTS=$O(^PS(53,"B",RXSTS)) Q:RXSTS=""  D  I 'XPDABORT Q
 . I $$UP^XLFSTR(RXSTS)="NON-VA" S XPDABORT=0 Q
 ;
 I XPDABORT D  S XPDABORT=2 Q
 . W !!,"The RX PATIENT STATUS File (#53) named 'NON-VA' was not found."
 . W !,"It must be created before this patch can be installed.",!
 . K DIR S DIR(0)="E",DIR("A")="Press Return to Continue"
 . D ^DIR K DIR
 ;
 ;- Checking existence of SD Event Protocol SDAM APPOINTMENT EVENTS
 S SDPRTCL=$O(^ORD(101,"B","SDAM APPOINTMENT EVENTS",""))
 I 'SDPRTCL D  S XPDABORT=2 Q
 . W !!,"The Scheduling Event Protocol SDAM APPOINTMENT EVENTS was not found."
 . W !,"This protocol must be present before this patch can be installed.",!
 . K DIR S DIR(0)="E",DIR("A")="Press Return to Continue"
 . D ^DIR K DIR
 ;
 S PSOPRTCL=$O(^ORD(101,"B","PSO TPB SD SUB",""))
 I 'PSOPRTCL D
 . N DIC S X="PSO TPB SD SUB",DIC="^ORD(101,",DLAYGO=101,DIC(0)="L"
 . S DIC("DR")="4///A"
 . D FILE^DICN Q:$G(Y)<0  S PSOPRTCL=+Y
 . S ^ORD(101,PSOPRTCL,20)="EN^PSOTPINA"
 ;
 I 'PSOPRTCL D  S XPDABORT=2 Q
 . W !!,"The new protocol PSO TPB SD SUB could not be created."
 . W !,"The installation of this patch will be aborted.",!
 . K DIR S DIR(0)="E",DIR("A")="Press Return to Continue"
 . D ^DIR K DIR
 ;
 I '$D(^ORD(101,SDPRTCL,10,"B",PSOPRTCL)) D
 . N DIC S X=PSOPRTCL,DIC="^ORD(101,"_SDPRTCL_",10,",DLAYGO=101.01
 . S DA(1)=SDPRTCL,DIC(0)="L" D FILE^DICN I $G(Y)<0 S XPDABORT=2
 ;
 I XPDABORT D  Q
 . W !!,"The new Outpatient Pharmacy Protocol PSO TPB SD SUB could not be added as a subscriber"
 . W !,"to the Scheduling Event Protocol SDAM APPOINTMENT EVENTS. The installation of this patch"
 . W !,"will be aborted.",!
 . K DIR S DIR(0)="E",DIR("A")="Press Return to Continue"
 . D ^DIR K DIR
 ;
 Q:'$G(XPDENV)
 W ! K %DT D NOW^%DTC S %DT="RAEX",%DT(0)=%,%DT("A")="Queue the Post-Install to run at what Date@Time: "
 D ^%DT K %DT I $D(DTOUT)!(Y<0) W !!,"Cannot install the patch without queuing the post-install, install aborted!",! S XPDABORT=2 Q
 S @XPDGREF@("PSO160Q")=Y,@XPDGREF@("PSOUSER")=DUZ
 Q
