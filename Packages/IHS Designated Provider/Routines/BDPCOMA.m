BDPCOMA ; IHS/CMI/TMJ - ADD RECORDS FOR A PARTICULAR COMMUNITY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;This routine adds patient living in a selected community
 ;for a selected Provider and Provider Type
 ;If Matching Record Exists no update is done
 ;
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
 D COM ;              get patient Community
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
COM ; GET COMMUNITY
 S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Select a Particular COMMUNITY: " D ^DIC K DIC
 I Y=-1 S BDPQ=1 Q
 S BDPCOMN=+Y
 Q:BDPCOMN=""
 S BDPCOMP=$P($G(^AUTTCOM(BDPCOMN,0)),U,1) ;Community Text
 Q:BDPCOMP=""
 Q
 ;
 ;
 ;
ASK ;Ask to Continue
 S BDPQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue changing the Designated Provider for each Patient living in this Community",DIR("B")="Y" K DA D ^DIR K DIR
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
 W ?8,"To be assigned to Patients living in Community Named: "_BDPCOMP W !
 W ?8,"For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 W !,?8,"**********************************************",!
 ;
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Continue Changing to a new CURRENT Designated Provider",DIR("?")="Enter Y for Yes or N for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDPQ=1 Q
 I Y=0 S BDPQ=1 Q
 ;
 ;
ADDCOM ;Add Patients in this Community to File
 ;
 ;S BDPPAT=""
 S BDPIEN="" F  S BDPIEN=$O(^BDPRECN("B",BDPTYPE,BDPIEN)) Q:BDPIEN'=+BDPIEN  D
 . S BDPPAT=$P($G(^BDPRECN(BDPIEN,0)),U,2) ;Get Patient
 . Q:BDPPAT=""  ;Quit if Patient Missing
 . S BDPTYPEM=$P($G(^BDPRECN(BDPIEN,0)),U) ;Type of Match On
 . Q:BDPTYPEM=""
 . Q:BDPTYPE=""
 . I BDPTYPE'=BDPTYPEM Q  ;Quit No Match on Type
 . S BDPCMCK=$P($G(^AUPNPAT(BDPPAT,11)),U,17) ;Get Patients Existing Community IEN
 . I BDPCMCK'=BDPCOMN Q  ;Quit if No Match On Community
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
 . W "Has been assigned to Patients Living in Community: "_BDPCOMP W !
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
 W !,?3,"This Option allows automatic UPDATE of existing Records for a Patients",!,?15,"Living in a Selected C0MMUNITY",!
 W ?3,"The User is prompted for the COMMUNITY Name and the desired Provider Name.",!
 W ?3,"Once the desired Provider Category Type is selected by the User,",!
 W ?3,"the Program will automatically LOOP through all existing Patient Records and",!,?3,"Update the selected Current Provider for this Category Type.",!!
 W ?3,"If the patient's Current Provider/Category Type/Community",!,?3,"are the same, no updating will occur.",!
