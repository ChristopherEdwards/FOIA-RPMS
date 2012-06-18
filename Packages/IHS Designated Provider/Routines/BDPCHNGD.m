BDPCHNGD ; IHS/CMI/TMJ - CHANGE NON-EXISTING PROVIDER TO NEW PROVIDER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ; Subscripted BDPREC is EXTERNAL form.
 ;   BDPREC("PAT NAME")=patient name
 ;   BDPREC("PROV TYPE")=Provider Category Type
 ;   BDPDFN=patient ien
 ;   BDPRDATE=date in internal FileMan form
 ;   BDPRIEN=Designated Provider ien
 ;
 ;This routine populates records which have deleted the
 ;current Desg. Provider and can assign unassigned patients
 ;to a current new Provider.
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
 ;
 ;
 ;
ASK ;Ask to Continue
 S BDPQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue changing the Designated Provider for each Patient",DIR("B")="Y" K DA D ^DIR K DIR
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
 W !!,?8,"Okay, all Patients with NO EXISTING Current Provider : ",!
 W ?8,"Will be assigned to NEW Provider Named: "_BDPRPRVP W !
 W ?8,"For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 W !,?8,"**********************************************",!
 ;
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Continue Updating to a new CURRENT Designated Provider",DIR("?")="Enter Y for Yes or N for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDPQ=1 Q
 I Y=0 S BDPQ=1 Q
 ;
 ;
UPDATE ;Update Records
 ;
 S BDPIEN="" F  S BDPIEN=$O(^BDPRECN("B",BDPTYPE,BDPIEN)) Q:BDPIEN'=+BDPIEN  D
 . Q:BDPIEN=""
 . S BDPTYPEM=$P($G(^BDPRECN(BDPIEN,0)),U) ;Type to Match On
 . Q:BDPTYPEM=""
 . Q:BDPTYPE=""
 . I BDPTYPE'=BDPTYPEM Q  ;Quit if No Match
 . S BDPPAT=$P($G(^BDPRECN(BDPIEN,0)),U,2) ;Patient
 . Q:BDPPAT=""
 . S BDPOPROV=$P($G(^BDPRECN(BDPIEN,0)),U,3) ;Existing Provider
 . Q:BDPOPROV'=""  ;Quit if they already have a Provider
 . ;Otherwise go on and populate these non-existing Current Providers
 .;with the new one the User Selected
 . Q:BDPPROV=""  ;Quit if No New Provider
 . S X=$$CREATE^BDPPASS(BDPPAT,BDPTYPE,BDPPROV) Q
 ;
 ;
MSGEND ;End of Add Message
 W !!!!,"Okay - I have changed all Patient Records - as follows: ",! D  Q
 .W !,"OLD Designated Provider: No Current Provider Assigned",!
 . W "has been re-assigned to NEW Designated Provider:"_BDPRPRVP W !
 . W "For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 . ;W "Note: If this Designated Provider already existed for the patient",!,?7," - No change was made to the patient record-.",!
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
 W !,?3,"This Option allows the automatic updating of all Records......",!,?10,"with NO existing CURRENT Designated Provider -",!,?10,"to a NEW assigned Designated Provider.",!!
 W ?3,"The User is prompted ONLY for the NEW Provider Name.",!
 W ?3,"Once the desired Provider Category Type is selected by the User,",!
 W ?3,"the Program will automatically LOOP through all Records",!,?3,"with NO EXISTING Provider and assign these Patients to the NEW Provider",!
 W ?3,"for this Category Type.",!!
 Q
