BDPCHNG ;IHS/CMI/TMJ - CHANGE PROVIDER
 ;;2.0;IHS PCC SUITE;**10**;MAY 14, 2009;Build 88
 ;
 ; Subscripted BDPREC is EXTERNAL form.
 ;   BDPREC("PAT NAME")=patient name
 ;   BDPREC("PROV TYPE")=Provider Category Type
 ;   BDPDFN=patient ien
 ;   BDPRDATE=date in internal FileMan form
 ;   BDPRIEN=Designated Provider ien
 ;
START ;
 ;
 D INFORM ;Data Entry Explanation
 ;
 D MAIN Q:BDPQ  D HDR^BDP
 D EOJ
 Q
 ;
MAIN ;
 S BDPQ=0,BDPYI=0
 D OLDPROV ;              get Old Existing Provider
 Q:BDPQ
 D COUNT
 Q:BDPQ  ;Quit No Records for this Provider
 D ASK
 Q:BDPQ
 D PROV
 I BDPQ=1 G MAIN
 ;
 ;D ASK
 ;
GETTYPE ;Do Get Date if no existing Designated Providers
 D TYPE ;                 get Provider Category Type
 Q:BDPQ
 D ASKGO ;                  add new Designated Provider record
 S BDPQ=0
 Q
 ;
OLDPROV ; GET OLD EXISTING PROVIDER
 ;
 S BDPOPROV="",BDPQ=0
 S DIC("A")="Select EXISTING Designated Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA S:$D(DUOUT) DIRUT=1,BDPQ=1
 I +Y<1 S BDPQ=1 Q
 Q:$D(DIRUT)
 S BDPOPROV=+Y,BDPOPRVP=$P(Y,U,2)
 S BDPOPRVP=$P(^VA(200,BDPOPROV,0),U,1) ;Provider Print Name
 S BDPQ=0
 Q
 ;
COUNT ;Count of # Patients for this Old Provider
 S BDPI="",BDPQ=0
 F BDPYI=1:1 S BDPI=$O(^BDPRECN("AC",BDPOPROV,BDPI)) Q:BDPI=""
 W !!?10,"There are ",BDPYI-1," patients currently assigned to this Provider."
 I BDPYI=1 S BDPQ=1 ;More than one patient exists for Provider
 K BDPI,BDPYI
 W !
 W !
 Q
 ;
 ;
ASK ;Ask to Continue
 S BDPQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue changing the Designated Provider for each Patient?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BDPQ=1 Q
 I 'Y S BDPQ=1 Q
 Q
 ;
 ;
TYPE ; GET CATEGORY TYPE FOR DESIGNATED PROVIDER
 W !
 S BDPQ=1
 S DIR(0)="90360.1,.01",DIR("B")="DPCP" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BDPTYPE=+Y,BDPREC("PROV TYPE")=Y(0)
 I $P(^BDPTCAT(BDPTYPE,0),U,1)="MESSAGE AGENT",'$D(^BDPMSGA("B",BDPPROV)) D  G TYPE
 .W !!,"The provider you selected is not listed as a Message Agent, he/she must "
 .W !,"be added to the Message Agent List using the option on the Manager's "
 .W !,"Menu before they can be assigned as a message agent.",!
 I $P(^BDPTCAT(BDPTYPE,0),U,1)="MESSAGE AGENT",$P($G(^BDPMSGA(BDPPROV,0)),U,3) D  G TYPE
 .W !!,"The provider you selected has been inactivated as a message agent, he/she"
 .W !," must be reactivated using the option on the Manager's Menu before they can "
 .W !,"be assigned as a message agent.",!
 ;
 S BDPQ=0
 Q
PROV ; GET DESIGNATED PROVIDER
 S BDPPROV="",BDPQ=0
 S DIC("A")="Select New Designated Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA S:$D(DUOUT) DIRUT=1,BDPQ=1
 Q:$D(DIRUT)
 I +Y<1 S BDPQ=1 Q
 S BDPPROV=+Y,BDPRPROV=$P(Y,U,2)
 S BDPRPRVP=$P(^VA(200,BDPPROV,0),U,1) ;Provider Print Name
 S BDPQ=0
 Q
 ;
ASKGO ;Ask to continue
 ;
 W !!!,?8,"**********************************************",!
 W !!,?8,"Okay, you have selected OLD Provider : ",BDPOPRVP,!
 W ?8,"To be re-assigned to NEW Provider Named: "_BDPRPRVP W !
 W ?8,"For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 W !,?8,"**********************************************",!
 ;
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Continue Changing to a new CURRENT Designated Provider",DIR("?")="Enter Y for Yes or N for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDPQ=1 Q
 I Y=0 S BDPQ=1 Q
 ;
 ;
UPDATE ;Update Records
 ;
 S BDPIEN="" F  S BDPIEN=$O(^BDPRECN("AC",BDPOPROV,BDPIEN)) Q:BDPIEN'=+BDPIEN  D
 . Q:BDPIEN=""
 . S BDPTYPEM=$P($G(^BDPRECN(BDPIEN,0)),U) ;Type to Match On
 . Q:BDPTYPEM=""
 . Q:BDPTYPE=""
 . I BDPTYPE'=BDPTYPEM Q  ;Quit if No Match
 . S BDPPAT=$P($G(^BDPRECN(BDPIEN,0)),U,2) ;Patient
 . Q:BDPPAT=""
 . Q:BDPPROV=""  ;Quit if No New Provider
 . S X=$$CREATE^BDPPASS(BDPPAT,BDPTYPE,BDPPROV) Q
 ;
 ;
MSGEND ;End of Add Message
 W !!!!,"Okay - I have changed all Patient Records - as follows: ",! D  Q
 .W !,"OLD Designated Provider : ",BDPOPRVP,!
 . W "has been re-assigned to NEW Designated Provider:"_BDPRPRVP W !
 . W "For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 . W "Note: If this Designated Provider already existed for the patient",!,?7," - No change was made to the patient record-.",!
 . D PAUSE^BDP
 S BDPQ=0
 Q
 ;
 ;
EOJ ; END OF JOB
 D ^BDPKILL
 Q
 ;
INFORM ;Data Entry Explanation
 ;
 W !,?3,"This option is used to assign a Message Agent to any patient who"
 W !,"has a particular provider assigned to them.  For example, if you want"
 W !,"to assign message agent Mary Smith, RN to all of Dr. Miller's patients"
 W !,"you can do so with this option."
 W !!!,"PLEASE NOTE:  If the patient already has a message agent assigned"
 W !,"this option will replace that message agent with the new one you are"
 W !,"assigning.",!
 Q
