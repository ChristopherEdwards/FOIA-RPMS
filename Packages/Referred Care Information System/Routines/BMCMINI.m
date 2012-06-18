BMCMINI ; IHS/PHXAO/TMJ - MINI ADD A NEW REFERRAL ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;ITSC/IHS/FCJ MOVED REQ TO SND MSG AFTER ENTRY OF REF
 ;
 ; See ^BMCVDOC for system wide variables set by main menu
 ;
 ; Subscripted BMCREC is EXTERNAL form.
 ;   BMCREC("PAT NAME")=patient name
 ;   BMCREC("REF DATE")=referral date
 ;   BMCDFN=patient ien
 ;   BMCRDATE=referral date in internal FileMan form
 ;   BMCRNUMB=referral number
 ;   BMCRIEN=referral ien
 ;   BMCMODE=A for add, M for modify
 ;   BMCRTYPE=type of referral (.04 field)
 ;   BMCRIO=Inpatient or Outpatient (.14 field)
 ;
START ;
 D:$G(BMCPARM)="" PARMSET^BMC
 F  D MAIN Q:BMCQ  D HDR^BMC
 D EOJ
 Q
 ;
MAIN ;
 S BMCQ=0
 S BMCMODE="A",BMCLOOK=""
 S APCDOVRR=""
 D PATIENT ;              get patient being referred
 Q:BMCQ
 D DATE ;                 get date of referral
 Q:BMCQ
 D NUMBER ;               get next referral number
 Q:BMCQ
 D ADD ;                  add new referral record
 Q:BMCQ
 D EDIT ;                 edit referral record just added
 Q
 ;
PATIENT ; GET PATIENT
 F  D PATIENT2 I BMCQ!($G(BMCDFN)) Q
 Q
 ;
PATIENT2 ; ASK FOR PATIENT UNTIL USER SELECTS OR QUITS
 S BMCQ=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D DIC^BMCFMC
 Q:Y<1
 S BMCDFN=+Y,BMCREC("PAT NAME")=$P(^DPT(+Y,0),U)
 S BMCQ=0
 I $$DOD^AUPNPAT(BMCDFN) D  I 'Y K BMCDFN,BMCREC("PAT NAME") Q
 . W !!,"This patient is deceased."
 . S DIR(0)="YO",DIR("A")="Are you sure you want this patient",DIR("B")="NO" K DA D ^DIR K DIR
 . W !
 . Q
 Q
 ;
DATE ; GET DATE OF REFERRAL
 S BMCQ=1
 S DIR(0)="90001,.01",DIR("B")="TODAY" K DA D ^DIR K DIR Q:$D(DIRUT)
 S BMCRDATE=+Y,BMCREC("REF DATE")=Y(0)
 S BMCQ=0
 Q
 ;commented out check on 2 on one day
 ; Search index to determine if referral exists for patient/date.
 ; If so, display message.
 ;
 ;I $D(^BMCREF("AA",BMCDFN,BMCRDATE)) D  Q
 ;.W !!,"A REFERRAL FOR '",BMCREC("PAT NAME"),"', ON '",BMCREC("REF DATE"),"' EXISTS.",!,"USE THE 'MODIFY' OPTION TO EDIT THE REFERRAL.",!
 ;.D EOP^BMC
 ;.Q
 S BMCQ=0
 Q
 ;
NUMBER ; GENERATE REFERRAL NUMBER
 S BMCQ=1
 S X=$$REFN^BMC
 X $P(^DD(90001,.02,0),U,5,99)
 I '$D(X) W !,"Error generating new referral number.  Notify programmer.",! D EOP^BMC Q
 S BMCRNUMB=X
 S BMCQ=0
 Q
 ;
ADD ; ADD NEW REFERRAL RECORD
 S BMCQ=1
 S DIC="^BMCREF(",DIC(0)="L",DLAYGO=90001,DIC("DR")=".02////"_BMCRNUMB_";.03////"_BMCDFN_";.15////A;.25////"_DUZ_";.26////"_DT_";.27////"_DT,X=BMCRDATE
 D FILE^BMCFMC
 I Y<0 W !,"Error creating REFERRAL.",!,"Notify programmer.",! D EOP^BMC Q
 W !!,"REFERRAL number : ",BMCRNUMB,!
 ;
 S BMCRIEN=+Y
 S BMCQ=0
 Q
 ;
EDIT ; EDIT REFERRAL RECORD JUST ADDED
 S DDSFILE=90001,DA=BMCRIEN,DR="[BMCX REFERRAL ADD]",DDSPARM="C"
 D DDS^BMCFMC
 I '$G(DDSCHANG) D DELETE S BMCQ=1 Q
 S Y=BMCRIEN
 D ^BMCREF ;              set standard variables from record
 ;
 D DXPX ;                 get provisional dx's/px's
 ;D COMMENTS ;             get comments
 D STATIC ;               set static fields
 Q
 ;
DELETE ; DELETE REFERRAL JUST ADDED BECAUSE OPERATOR DIDN'T FINISH
 W !!,"INCOMPLETE REFERRAL BEING DELETED!",!!
 S DIK="^BMCREF(",DA=BMCRIEN D ^DIK
 D PAUSE^BMC
 Q
 ;
DXPX ; GET PROVIDIONAL DIAGNOSES/PROCEDURES IF WANTED
 Q:'BMCDXPR  ;            quit if site not entering dx/px
 D DX
 D PX
 Q
 ;
DX ; GET PROVISIONAL DIAGNOSES
 W:$D(IOF) @IOF
 W !?5,"Referral #: ",$$REFN^BMC
 W !?5,"Referral Date: " S Y=$P(^BMCREF(BMCRIEN,0),U) D DD^%DT W Y
 W ?40,"Patient Name: ",$P(^DPT(BMCDFN,0),U)
 W !!
 S DIR(0)="Y",DIR("A")="Do you want to enter a Provisional Diagnosis",DIR("B")="Y",DIR("?")="Enter 'YES' to enter provisional diagnoses now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 I Y S BMCQ=0 F  D  Q:BMCQ
 . S BMCLOOK=1
 . S BMCDXT="P"
 . S DIE="^BMCREF(",DA=BMCRIEN,DR="[BMC DIAGNOSIS ADD]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . S:'$G(BMCDX) BMCQ=1
 . K BMCDX
 . Q
 S BMCQ=0
 Q
 ;
PX ; GET PROVISIONAL PROCEDURES
 W !
 S DIR(0)="Y",DIR("A")="Do you want to enter a Provisional Procedure",DIR("B")="Y",DIR("?")="Enter 'YES' to enter provisional procedures now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 I Y S BMCQ=0 F  D  Q:BMCQ
 . S BMCLOOK=1
 . S BMCPXT="P"
 . S DIE="^BMCREF(",DA=BMCRIEN,DR="[BMC PROCEDURE ADD]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . S:'$G(BMCPX) BMCQ=1
 . K BMCPX
 . Q
 S BMCQ=0
 Q
 ;
COMMENTS ; GET COMMENTS
 W !
 S DIR(0)="Y",DIR("A")="Do you want to enter Case Review Comments",DIR("B")="N",DIR("?")="Enter 'YES' to enter comments now."
 D ^DIR K DIR
 Q:$D(DIRUT)
 I Y S BMCQ=0 D
 . S BMCLOOK=1
 . S DIE="^BMCREF(",DA=BMCRIEN,DR="[BMC COMMENTS ADD]"
 . D DIE^BMCFMC
 . K BMCLOOK
 . S DIE="^BMCREF(",DA=BMCRIEN,DR=".31"
 . D DIE^BMCFMC
 . Q
 S BMCQ=0
 Q
 ;
STATIC ; STORE STATIC DATA
 W !,"Storing static fields....",!
 ;
 S BMCREC=^BMCREF(BMCRIEN,0)
 S Y=^DPT(BMCDFN,0)
 S DR="5101///"_$P(Y,U) ;          name
 S DR=DR_";5103///"_$P(Y,U,3) ;    dob
 S DR=DR_";5104///"_$P(Y,U,9) ;    ssn
 S DR=DR_";5107///"_$P(Y,U,2) ;    sex
 S %=$P(BMCREC,U,5)
 I % D
 . S DR=DR_";5102///"_$P($G(^AUPNPAT(BMCDFN,41,%,0)),U,2) ; chart #
 . S DR=DR_";5113///"_$P($G(^DIC(4,%,0)),U) ;              facility
 . S DR=DR_";5114///"_$P($G(^AUTTLOC(%,0)),U,10) ;         asufac
 . Q
 S Y=$G(^AUPNPAT(BMCDFN,51))
 I $P(Y,U,18)'="" S DR=DR_";5105///"_$P(Y,U,18) ;   comm
 I $P(Y,U,8) S DR=DR_";5106///"_$P($G(^AUTTTRI($P(Y,U,8),0)),U,2) ; tribe
 S %=$P(BMCREC,U,7)
 I % D
 . S DR=DR_";5108///"_$P($G(^AUTTVNDR(%,0)),U) ;    vendor
 . S DR=DR_";5109///"_$P($G(^AUTTVNDR(%,51)),U) ;   ein
 . Q
 S %=$P(BMCREC,U)
 S DR=DR_";5110///"_$$MCR^AUPNPAT(BMCDFN,%) ;   medicare
 S DR=DR_";5111///"_$$MCD^AUPNPAT(BMCDFN,%) ;   medicaid
 S DR=DR_";5112///"_$$PI^AUPNPAT(BMCDFN,%) ;    private insurance
 ;
 S DIE="^BMCREF(",DA=BMCRIEN
 D DIE^BMCFMC
 W !,"Entry of Referral ",$P(^BMCREF(BMCRIEN,0),U,2)," is complete.",!
 ;IHS/ITSC/FCJ ADD 4 LINES TO REQ TO SEND MESSAGE
 I BMCCHSA,BMCRTYPE="C" D ENMM^BMCBULL
 I BMCIHSA,BMCRTYPE="I" D ENMM^BMCBULL
 I BMCOTHRA,BMCRTYPE="O" D ENMM^BMCBULL
 I BMCHOUSA,BMCRTYPE="N" D ENMM^BMCBULL
 D EOP^BMC
 Q
 ;
EOJ ; END OF JOB
 D ^BMCKILL
 Q
