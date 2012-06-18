BMCADD ; IHS/PHXAO/TMJ - ADD A NEW REFERRAL ;         [ 07/12/2006  3:48 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2*;JAN 09, 2006
 ;4.0*2 IHS/OIT/FCJ Marked EP for API routine
 ;
 ;IHS/OIT/FCJ Messages are no longer triggered.  Prompts
 ;    user if they would like to send a message.
 ;   CHANGED COMMENT CALL, BUSINESS OFF AND MED HX
 ;   ARE NO LONGER CALLED FROM FORM. Called at the end of Data entry.
 ;   CHANGED OPT 1 AND 4 DISPLAY NAMES
 ;   Remove BO/Case/Manage care comments fr physician option 
 ;   Removed asking for Case comments
 ;   Test for SR and add a new form for call-in's
 ;
 ; See ^BMCVDOC for system wide variables set by main menu
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
 D REFDISP
 I BMCQ=1 G GETDATE
 D ASK
 Q:BMCQ
 ;
GETDATE ;EP;Do Get Date if no existing Referrals
 D DATE ;                 get date of referral
 Q:BMCQ
 D NUMBER ;               get next referral number
 Q:BMCQ
 D ADD ;                  add new referral record
 Q:BMCQ
 D EDIT ;                 edit referral record just added
 Q
 ;
PATIENT ;EP; GET PATIENT
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
 Q
 ;
ASK ;EP;Ask to Continue
 S BMCQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue with adding a new referral",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQ=1 Q
 I 'Y S BMCQ=1 Q
 Q
 ;
REFDISP ;EP;Display if Patient has existing Referrals
 W !!,?25,"********************",!
 W ?25,"**LAST 5 REFERRALS**",!,?25,"********************",!
 I '$D(^BMCREF("AA",BMCDFN)) W !,?20,"**--NO EXISTING REFERRALS--**",! S BMCQ=1 Q
 S BMCQ=0
 S BMCDT=""
 F I=1:1:5 S BMCDT=$O(^BMCREF("AA",BMCDFN,BMCDT),-1) Q:BMCDT=""  D NEXT
 Q
NEXT ;2ND $O
 S BMCRIEN=""
 F  S BMCRIEN=$O(^BMCREF("AA",BMCDFN,BMCDT,BMCRIEN),-1) Q:BMCRIEN'=+BMCRIEN  D
 . Q:BMCDT=""
 . Q:BMCRIEN=""
 . Q:$P($G(^BMCREF(BMCRIEN,1)),U)'=""  ;4.0 IHS/ITSC/FCJ TST FOR SR
 . D START^BMCLKID1
 Q
 ;
DATE ; GET DATE OF REFERRAL
 W !
 S BMCQ=1
 S DIR(0)="90001,.01",DIR("B")="TODAY" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCRDATE=+Y,BMCREC("REF DATE")=Y(0)
 S BMCQ=0
 Q
 ; Search index to determine if referral exists for patient/date.
 ; If so, display message.
 ;
 I $D(^BMCREF("AA",BMCDFN,BMCRDATE)) D  Q
 .W !!,"A REFERRAL FOR '",BMCREC("PAT NAME"),"', ON '",BMCREC("REF DATE"),"' EXISTS.",!,"USE THE 'MODIFY' OPTION TO EDIT THE REFERRAL.",!
 .D EOP^BMC
 S BMCQ=0
 Q
 ;
PROV ; GET REQUESTING PROVIDER
 S BMCPROV="",BMCQ=1
 I $G(BMCOUTR) S BMCQ=0 Q  ; do not ask provider if outside referral
 S DIR(0)="90001,.06",DIR("A")="Enter REQUESTING PROVIDER" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BMCPROV=+Y,BMCRPROV=$P(Y,U,2)
 S BMCQ=0
 Q
NUMBER ; GENERATE REFERRAL NUMBER
 S BMCQ=1
 S X=$$REFN^BMC
 Q:'X
 X $P(^DD(90001,.02,0),U,5,99)
 I '$D(X) W !,"Error generating new referral number.  Notify programmer.",! D EOP^BMC Q
 S BMCRNUMB=X
 S BMCQ=0
 Q
 ;
ADD ; ADD NEW REFERRAL RECORD
 S BMCQ=1
 D ADD2 Q:'$D(BMCRR)  I 1
 E  S BMCRR=""
 D PROV
 Q:BMCQ
 I BMCRR="" D  Q
 .S DIC="^BMCREF(",DIC(0)="L",DLAYGO=90001,DIC("DR")=".02////"_BMCRNUMB_";.03////"_BMCDFN_";.06////"_BMCPROV_";.15////A;.25////"_DUZ_";.26////"_DT_";.27////"_DT,X=BMCRDATE
 .D FILE^BMCFMC
 .I Y<0 W !,"Error creating REFERRAL.",!,"Notify programmer.",! D EOP^BMC Q
 .W !!,"REFERRAL number : ",BMCRNUMB,!
 .S BMCRIEN=+Y
 .S BMCQ=0
 .Q
RR ;routine referral selected
 ;create entry with .01
 ;%rcr
 ;re-index
 ;call die with other fields
 ;set BMCRIEN,BMCQ=0
 S BMCOVRPS="" ;override post selection action
 S DIC="^BMCREF(",DIC(0)="L",DLAYGO=90001,X=BMCRDATE D FILE^BMCFMC
 K BMCOVRPS ;kill override variable
 I Y<0 W !,"Error creating REFERRAL.",!,"Notify programmer.",! D EOP^BMC Q
 S BMCRIEN=+Y
 ;call %RCR to copy routine referral into the newly created
 ;RCIS Referral entry
 S %X="^BMCRTNRF("_BMCRR_",",%Y="^BMCREF("_BMCRIEN_"," D %XY^%RCR ;move 0 node
 K ^BMCREF(BMCRIEN,61),^BMCREF(BMCRIEN,62) ;kill off nodes that don't belong
 I $D(^BMCREF(BMCRIEN,21,0)),$P(^BMCREF(BMCRIEN,21,0),U,2)[3221 S $P(^BMCREF(BMCRIEN,21,0),U,2)="90001.21PA"
 ;*******IMPORTANT - in line above, if nodes are added to the routine referral definition file, you must add the node to the line above
 S $P(^BMCREF(BMCRIEN,0),U)=BMCRDATE
 S DA=BMCRIEN,DIK="^BMCREF(" D IX1^DIK ;reindex entry
 S DIE="^BMCREF(",DR=".02////"_BMCRNUMB_";.03////"_BMCDFN_";.06////"_BMCPROV_";.15////A;.25////"_DUZ_";.26////"_DT_";.27////"_DT
 D DIE^BMCFMC
 I $D(Y) W !!,"Error in editing referral entry.  NOTIFY PROGRAMMER." Q
 S Y=BMCRIEN D ^BMCREF
 S BMCQ=0
 Q
 ;
ADD2 ;add if routine referrals have been defined
 K BMCDISP,BMCSEL,BMCHIGH,BMCRR,BMCOUTR,BMCMINI,BMCMINIX
 S BMCHIGH=1,BMCSEL(1)="Mini Referral"
 S BMCHIGH=2,BMCSEL(2)="Complete Referral (all referral data)"
 S BMCHIGH=3,BMCSEL(3)="Call In Notification by outside facility"
 S BMCHIGH=4,BMCSEL(4)="Abbreviated entry for clinicians"
 W:$D(IOF) @IOF
 W !,"Please select the referral form you wish to use."
 W !!?5,"1.  ",BMCSEL(1)
 W !?5,"2.  ",BMCSEL(2)
 W !?5,"3.  ",BMCSEL(3)
 W !?5,"4.  ",BMCSEL(4)
 S (X,BMCRRC)=0 F  S X=$O(^BMCRTNRF("B",X)) Q:X=""  S BMCRRC=BMCRRC+1
 W:BMCRRC<31 !!?5,"Locally-defined Routine Referral Templates:",!
 S X=0 F  S X=$O(^BMCRTNRF("B",X)) Q:X=""  S Y=$O(^BMCRTNRF("B",X,"")) S BMCHIGH=BMCHIGH+1,BMCSEL(BMCHIGH)=Y_U_$E($P(^BMCRTNRF(Y,0),U))_$E($$LOW^XLFSTR($P(^BMCRTNRF(Y,0),U)),2,999)
L16 I BMCRRC<16 D
 .S I=4 F  S I=$O(BMCSEL(I)) Q:I'=+I  W !?5,I,".  ",$P(BMCSEL(I),U,2)
 .D GETANS
 I BMCRRC>15&(BMCRRC<31) D
 .S BMCCUT=(BMCHIGH-3)/2 S:BMCCUT'=(BMCCUT\1) BMCCUT=(BMCCUT\1)+1
 .S I=4,J=1,K=1 F  S I=$O(BMCSEL(I)) Q:I'=+I!($D(BMCDISP(I)))  W !?5,I,")  ",$P(BMCSEL(I),U,2) S BMCDISP(I)="",J=I+BMCCUT I $D(BMCSEL(J)),'$D(BMCDISP(J)) W ?40,J,")  ",$P(BMCSEL(J),U,2) S BMCDISP(J)=""
 .D GETANS
G30 ;
 I BMCRRC>30 D
 .S BMCSEL(5)="5.  Select a locally defined routine referral template from a list"
 .W !!?5,BMCSEL(5),!
 .W ! S DIR(0)="N^1:"_BMCHIGH_":0",DIR("A")="Enter REFERRAL FORM ",DIR("B")=2 D ^DIR K DIR
 .Q:$D(DIRUT)
 .I Y=2 S BMCRR="" Q
 .I Y=3 S BMCOUTR=1,BMCRR="" Q
 .I Y=1 S BMCMINI=1,BMCRR="" Q
 .I Y=4 S BMCMINIX=1,BMCRR="" Q
 .I Y=5 K BMCRR D ^BMCADD2
 Q
GETANS ;
 W ! S DIR(0)="N^1:"_BMCHIGH_":0",DIR("A")="Enter REFERRAL FORM",DIR("B")=2 D ^DIR K DIR
 Q:$D(DIRUT)
 I Y=2 S BMCRR="" Q
 I Y=3 S BMCOUTR=1,BMCRR="" Q
 I Y=1 S BMCMINI=1,BMCRR="" Q
 I Y=4 S BMCMINIX=1,BMCRR="" Q
 S BMCRR=Y,BMCRR=$P(BMCSEL(BMCRR),U)
 Q
EDIT ; EDIT REFERRAL RECORD JUST ADDED
 S DDSFILE=90001,DA=BMCRIEN
 ;4.0 IHS/OIT/FCJ ADDED A NEW FORM FOR CALL IN REFERRALS
 ;S DR=$S($G(BMCMINI):"[BMCX REFERRAL ADD]",$G(BMCMINIX):"[BMCXX REFERRAL ADD]",1:"[BMC REFERRAL ADD]"),DDSPARM="C"
 S DR=$S($G(BMCMINI):"[BMCX REFERRAL ADD]",$G(BMCMINIX):"[BMCXX REFERRAL ADD]",$G(BMCOUTR):"[BMC REF ADD CALL-IN]",1:"[BMC REFERRAL ADD]"),DDSPARM="C"
 D DDS^BMCFMC
 I '$G(DDSCHANG) D DELETE S BMCQ=1 Q
 S Y=BMCRIEN
 D ^BMCREF              ; set standard variables from record
 ;6.1.04 IHS/ITSC/FCJ TEST FOR PROVIDER
 S X=$S(BMCRTYPE="I":$P(^BMCREF(BMCRIEN,0),U,8),BMCRTYPE="N":$P(^BMCREF(BMCRIEN,0),U,23),1:$P(^BMCREF(BMCRIEN,0),U,7))
 I 'X W !,"You must enter a Vendor, IHS Facility or In-House Clinic, depending on the",!,"referral type.",! D PAUSE^BMC G EDIT
 D DXPX                 ; get provisional dx's/px's
 ;7/27/04 IHS/OIT/FCJ cmt nxt lne no longer asking for Case cmts
 D:'$G(BMCMINI)&'$G(BMCMINIX) BOCOM   ; get Business Office comments except for MINIX and MINI
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
 D DXPX^BMCADD1
 Q
CSECOM ;EP; GET CASE COMMENTS
 W !
 S DIR("A")="Do you want to enter Case Review Comments"
 S BMCCTYP="C"
 D COMMENTS
 ;
MGDCARE ; Get Managed Care Committee Action
 D MGDCARE^BMCADD1
 Q
 ;
MEDCOM ;EP;MEDICAL HX/FINDINGS COMMENTS
 W !
 S DIR("A")="Do you want to enter Medical HX and Findings Comments"
 S BMCCTYP="M"
 D COMMENTS
 W !
 Q
BOCOM ;EP;BUSINESS OFFCIE COMMENTS
 W !
 S DIR("A")="Do you want to enter Business Office/CHS Comments"
 S BMCCTYP="B"
 D COMMENTS
 Q
COMMENTS ;EP
 S DIR(0)="Y",DIR("B")="N",DIR("?")="Enter 'YES' to enter comments now."
 S:BMCCTYP="M" DIR("B")="Y"
 D ^DIR K DIR
 Q:$D(DIRUT)!'Y
 D COMMENTS^BMCADD1
 Q
 ;
STATIC ; STORE STATIC DATA
 D STATIC^BMCADD1
 Q
 ;
EOJ ; END OF JOB
 D ^BMCKILL
 Q
