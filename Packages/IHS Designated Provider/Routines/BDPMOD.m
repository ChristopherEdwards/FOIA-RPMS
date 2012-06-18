BDPMOD ; IHS/CMI/TMJ - EDIT AN EXISTING DESIGNATED PROVIDER ;
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
 F  D MAIN Q:BDPQ  D HDR^BDP
 D EOJ
 Q
 ;
MAIN ;
 S BDPQ=0
 ;S BDPMODE="A",BDPLOOK=""
 D PATIENT ;              get patient Name
 Q:BDPQ
 D PROVDISP
 I BDPQ=1 G GETTYPE
 ;
 D ASK
 Q:BDPQ
 ;
GETTYPE ;Do Get Date if no existing Designated Providers
 D TYPE ;                 get Provider Category Type
 Q:BDPQ
 D ADD ;                  add new Designated Provider record
 ;Q:BDPQ
 Q
 ;
PATIENT ; GET PATIENT
 F  D PATIENT2 I BDPQ!($G(BDPDFN)) Q
 Q
 ;
PATIENT2 ; ASK FOR PATIENT UNTIL USER SELECTS OR QUITS
 S BDPQ=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D DIC^BDPFMC
 Q:Y<1
 S BDPDFN=+Y,BDPREC("PAT NAME")=$P(^DPT(+Y,0),U)
 S BDPQ=0
 I $$DOD^AUPNPAT(BDPDFN) D  I 'Y K BDPDFN,BDPREC("PAT NAME") Q
 . W !!,"This patient is deceased."
 . S DIR(0)="YO",DIR("A")="Are you sure you want this patient",DIR("B")="NO" K DA D ^DIR K DIR
 . W !
 . Q
 Q
 ;
 ;
ASK ;Ask to Continue
 S BDPQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue changing one of the above Designated Providers",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BDPQ=1 Q
 I 'Y S BDPQ=1 Q
 Q
 ;
PROVDISP ;Display if Patient has existing Designated Providers
 W !!,?25,"********************",!
 W ?10,"**CURRENT DESIGNATED PROVIDERS - BY PROVIDER CATEGORY TYPE**",!
 W !,?15,"Assigned to Patient: "
 W ?35,$P($G(^DPT(BDPDFN,0)),U)
 W !,?25,"********************"
 W !,?10,"**CATEGORY TYPE**",?46,"**CURRENT PROVIDER ASSIGNED**",!
 I '$D(^BDPRECN("AA",BDPDFN)) W !,?20,"**--NO EXISTING DESIGNATED PROVIDERS--**",! S BDPQ=1 Q
 S BDPQ=0
 S BDPTYPE=""
 S BDPCOUNT=0
 F I=1:1:100 S BDPTYPE=$O(^BDPRECN("AA",BDPDFN,BDPTYPE)) Q:BDPTYPE=""  S BDPCOUNT=BDPCOUNT+1 D NEXT
 Q
NEXT ;2ND $O
 S BDPRIEN=""
 F  S BDPRIEN=$O(^BDPRECN("AA",BDPDFN,BDPTYPE,BDPRIEN)) Q:BDPRIEN'=+BDPRIEN  D
 . Q:BDPTYPE=""
 . Q:BDPRIEN=""
 . S BDPPTNAM=$P(^DPT(BDPDFN,0),U,1) ;Patient Print Name
 . S BDPTYPNM=$P(^BDPTCAT(BDPTYPE,0),U,1) ;Type Print
 . S BDPCPRV=$P($G(^BDPRECN(BDPRIEN,0)),U,3) ;Current Provider IEN
 . I BDPCPRV="" S BDPCPRVP="<None Currently Assigned>" ;If no current Provider
 . E  S BDPCPRVP=$P(^VA(200,BDPCPRV,0),U,1) ;Provider Print Name
 . W !,?5,BDPCOUNT,?10,$E(BDPTYPNM,1,30),?50,$E(BDPCPRVP,1,35)
 . S I=I+1 ; increment outer loop counter to limit display to 10 Designated Providers
 . Q
 Q
 ;
 ;
 ;
TYPE ; GET CATEGORY TYPE FOR DESIGNATED PROVIDER
 W !
 S BDPQ=1
 ;
 S DIR(0)="90360.1,.01",DIR("B")="DPCP" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S BDPTYPE=+Y,BDPREC("PROV TYPE")=Y(0)
 S BDPQ=0
 Q
PROV ; GET NEW DESIGNATED PROVIDER
 S BDPPROV="",BDPQ=1
 S DIC("A")="Select New Designated Provider: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I +Y<1 S BDPQ=1 Q
 S BDPPROV=+Y,BDPRPROV=$P(Y,U,2) ;Provider IEN
 S BDPRPRVP=$P(^VA(200,BDPPROV,0),U,1) ;Provider Print Name
 S BDPQ=0
 Q
 ;
ADD ; ADD NEW DESIGNATED PROVIDER RECORD
 S BDPQ=1
 S BDPRR=$O(^BDPRECN("AA",BDPDFN,BDPTYPE,"")) ;Check to see if this Patient already has this Type
 I BDPRR'="" S BDPLPROV=$P($G(^BDPRECN(BDPRR,0)),U,3) ;Current Provider
 I BDPRR="" W !!,?10,"This patient does NOT have a Designated Provider Type",!,"for the Category you selected. See the Listing above."
 I BDPRR="" W !!,"-Use the ADD MENU to Add a CURRENT Provider for this Category Type-",!! D PAUSE^BDP Q
 ;
 S BDPRIEN=BDPRR ;Assign Record IEN to populate Multiple
 ;
 D PROV
 Q:BDPQ
 Q:BDPRPROV=""
 I BDPLPROV=BDPPROV W !!,"This is the existing Current Provider for this Category",!! D PAUSE^BDP Q  ;Quit if the same Provider
ASKGO ;Ask to continue
 ;
 W !!!,?8,"**********************************************",!
 W !!,?8,"Okay, you have selected DESIGNATED PROVIDER : ",BDPRPRVP,!
 W ?8,"To be assigned to Patient Name: "_$P($G(^DPT(BDPDFN,0)),U,1) W !
 W ?8,"For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 W !,?8,"**********************************************",!
 ;
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Continue Changing to a new CURRENT Designated Provider",DIR("?")="Enter Y for Yes or N for NO",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BDPQ=1 Q
 I Y=0 S BDPQ=1 Q
 W !!,"Okay - I have changed this Patient Record - as follows: ",! D  Q
 .W !!,"DESIGNATED PROVIDER : ",BDPRPRVP,!
 . W "Has been assigned to Patient Name: "_$P($G(^DPT(BDPDFN,0)),U,1) W !
 . W "For Designated Provider Category/Type: "_$P($G(^BDPTCAT(BDPTYPE,0)),U,1) W !!
 .S BDPLINKI=1
 .S BDPLINKI=1
 .I $D(BDPRIEN) D
 .. Q:'BDPRIEN
 .. S:'$D(^BDPRECN(BDPRIEN,1,0)) $P(^(0),U,2)="90360.11P"
 .. S BDPLIEN=$P($G(^BDPRECN(BDPRIEN,1,0)),U,3) ;Last IEN in Multiple
 .. I BDPLIEN="" S BDPLIEN=0
 .. S BDPLNUM=$P($G(^BDPRECN(BDPRIEN,1,0)),U,4) ;Las Number in Multiple
 .. I BDPLNUM="" S BDPLNUM=0
 .. S BDPLIEN=BDPLIEN+1
 .. S BDPLNUM=BDPLNUM+1
 .. S $P(^BDPRECN(BDPRIEN,1,0),U,3)=BDPLIEN
 .. S $P(^BDPRECN(BDPRIEN,1,0),U,4)=BDPLNUM
 .. S DR=".01///"_"`"_BDPPROV
 .. S DIE="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DA=BDPLIEN D ^DIE K DIE,DR,DA,DINUM
 .D PAUSE^BDP
 .S BDPQ=0
 .Q
EOJ ; END OF JOB
 D ^BDPKILL
 Q
 ;
 ;
INFORM ;Data Entry Explanation
 ;
 W !,?20,"******************************"
 W !,?2,"Utilize this Option to MODIFY Existing Designated Specialty Provider Records.",!
 W ?3,"If the Patient has already been assigned the same Provider for the",!,?3,"Category and Provider selected - the record will not be Updated.",!
 W ?20,"******************************",!
 Q
