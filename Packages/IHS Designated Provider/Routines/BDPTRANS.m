BDPTRANS ; IHS/CMI/TMJ - TRANSFER FROM A TEMPLATE OF PATIENTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
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
 S BDPQ=0
 D TEMPLATE ;              get patient Name
 Q:BDPQ
 D PROV
 I BDPQ=1 G MAIN
 ;
 D ASK
 Q:BDPQ
 ;
GETTYPE ;Do Get Date if no existing Designated Providers
 D TYPE ;                 get Provider Category Type
 Q:BDPQ
 D ASKGO ;                  add new Designated Provider record
 S BDPQ=0
 Q
 ;
TEMPLATE ; GET TEMPLATE
 ;
TLOOK K DIC,DIRUT
 S DIC="^DIBT(",DIC(0)="AEQZ",DIC("A")="Select SEARCH TEMPLATE: ",DIC("S")="I ($P(^(0),U,4)=2!($P(^(0),U,4)=9000001)),$D(^DIBT(+$G(Y),1))"
 D ^DIC K DIC,DA,DR
 I $D(DIRUT) S BDPQ=1 Q
 I +Y<1 S BDPQ=1 Q
 W !
 S BDPTRN=+Y,BDPTRNA=$P(Y,U,2),(BDPRGTP,BDPI)=""
 F BDPYI=1:1 S BDPI=$O(^DIBT(BDPTRN,1,BDPI)) Q:BDPI=""
 W !!?10,"There are ",BDPYI-1," patients in this SEARCH TEMPLATE."
 K BDPI,BDPYI
 W !
 S BDPYI=0
 K BDPYI
 W !
 Q
 ;
 ;
ASK ;Ask to Continue
 S BDPQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue changing the Designated Provider for each Patient in this Templates",DIR("B")="Y" K DA D ^DIR K DIR
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
 W !!,?8,"Okay, you have selected DESIGNATED PROVIDER : ",BDPRPRVP,!
 W ?8,"To be assigned to Patients in Template Named: "_BDPTRNA W !
 W ?8,"For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 W !,?8,"**********************************************",!
 ;
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Continue Changing to a new CURRENT Designated Provider",DIR("?")="Enter Y for Yes or N for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDPQ=1 Q
 I Y=0 S BDPQ=1 Q
 ;
 ;
ADDTEMP ;Add Patients in Template to File
 ;
 ;S BDPPAT=""
 S BDPPAT="" F  S BDPPAT=$O(^DIBT(BDPTRN,1,BDPPAT)) Q:BDPPAT'=+BDPPAT  D
 . Q:BDPPAT=""
 . Q:BDPTYPE=""
 . Q:BDPPROV=""
 . S X=$$CREATE^BDPPASS(BDPPAT,BDPTYPE,BDPPROV) Q
 . ;
 ;
 ;
MSGEND ;End of Add Message
 W !!!!,"Okay - I have changed all Patient Records - as follows: ",! D  Q
 .W !,"DESIGNATED PROVIDER : ",BDPRPRVP,!
 . W "Has been assigned to Patients existing in Template: "_BDPTRNA W !
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
 ;
INFORM ;Data Entry Explanation
 ;
 W !,?3,"This Option allows automatic ADD/UPDATE of Records from a Patient TEMPLATE",!
 W ?3,"The User is prompted for the TEMPLATE Name and the desired Provider Name.",!
 W ?3,"Once the desired Provider Category Type is selected by the User,",!
 W ?3,"the Program will automatically LOOP through the Template of Patients and",!,?3,"Add or Update the selected Current Provider for this Category Type.",!!
 W ?3,"If an existing patient's Current Provider/Category Type are the same,",!,?3,"no update will occur.",!
 Q
