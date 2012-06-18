BRNADD ; IHS/PHXAO/TMJ - ADD A NEW DISCLOSURE DATE ; 
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 01/04/2008 PATCH 1 Added screen on date for facility inactivation date
 ;
 ; Subscripted BRNREC is EXTERNAL form.
 ;   BRNREC("PAT NAME")=patient name
 ;   BRNREC("REF DATE")=disclosure date
 ;   BRNDFN=patient ien
 ;   BRNRDATE=disclosure date in internal FileMan form
 ;   BRNRNUMB=disclosure number
 ;   BRNRIEN=Disclosure ien
 ;   BRNMODE=A for add, M for modify
 ;   BRNRTYPE=type of disclousre (.04 field)
 ;
START ;
 F  D MAIN Q:BRNQ  D HDR^BRN
 D EOJ
 Q
 ;
MAIN ;
 S BRNQ=0
 S BRNMODE="A",BRNLOOK=""
 ;S APCDOVRR="" ;for provider narrative lookup
 D PATIENT ;              get patient being referred
 Q:BRNQ
 D REFDISP
 I BRNQ=1 G GETDATE
 ;
 D ASK
 Q:BRNQ
 ;
GETDATE ;Do Get Date if no existing Disclosures
 D DATE ;                 get date of Disclosure
 Q:BRNQ
 D ADD ;                  add new Disclosure record
 Q:BRNQ
 D EDIT ;                 edit Disclosure record just added
 Q
 ;
PATIENT ; GET PATIENT
 F  D PATIENT2 I BRNQ!($G(BRNDFN)) Q
 Q
 ;
PATIENT2 ; ASK FOR PATIENT UNTIL USER SELECTS OR QUITS
 S BRNQ=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D DIC^BRNFMC
 Q:Y<1
 S BRNDFN=+Y,BRNREC("PAT NAME")=$P(^DPT(+Y,0),U)
 S BRNQ=0
 I $$DOD^AUPNPAT(BRNDFN) D  I 'Y K BRNDFN,BRNREC("PAT NAME") Q
 . W !!,"This patient is deceased."
 . S DIR(0)="YO",DIR("A")="Are you sure you want this patient",DIR("B")="NO" K DA D ^DIR K DIR
 . W !
 . Q
 Q
 ;
 ;
ASK ;Ask to Continue
 S BRNQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue with adding a new Disclosure",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BRNQ=1 Q
 I 'Y S BRNQ=1 Q
 Q
 ;
REFDISP ;Display if Patient has existing Disclosures
 W !!,?25,"********************",!
 W ?25,"**LAST 4 DISCLOSURES**",!,?25,"********************",!
 I '$D(^BRNREC("AA",BRNDFN)) W !,?20,"**--NO EXISTING DISCLOSURES--**",! S BRNQ=1 Q
 S BRNQ=0
 S BRNDT=""
 F I=1:1:5 S BRNDT=$O(^BRNREC("AA",BRNDFN,BRNDT),-1) Q:BRNDT=""  D NEXT
 Q
NEXT ;2ND $O
 S BRNRIEN=""
 F  S BRNRIEN=$O(^BRNREC("AA",BRNDFN,BRNDT,BRNRIEN),-1) Q:BRNRIEN'=+BRNRIEN  D
 . Q:BRNDT=""
 . Q:BRNRIEN=""
 . D START^BRNLKI1
 . S I=I+1 ; increment outer loop counter to limit display to 4 Disclosures
 . Q
 Q
 ;
 ;
 ;
DATE ; GET DATE OF DISCLOSURE
 W !
 S BRNQ=1
 ;
 S DIR(0)="90264,.01",DIR("B")="TODAY" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I '$$FACOK^BRNU(+Y) W !,"** MUST BE BEFORE YOUR DIVISION'S INACTIVATION DATE **",! D PAUSE^BRNU,DATE Q  ;IHS/OIT/LJF 01/04/2008 PATCH 1
 S BRNRDATE=+Y,BRNREC("REF DATE")=Y(0)
 S BRNQ=0
 Q
 ;
ADD ; ADD NEW DISCLOSURE RECORD
 S BRNRR=""
 Q:BRNQ
 I BRNRR="" D  Q
 .S DIC="^BRNREC(",DIC(0)="L",DLAYGO=90264,DIC("DR")=".03////"_BRNDFN,X=BRNRDATE
 .D FILE^BRNFMC
 .I Y<0 W !,"Error creating DISCLOSURE.",!,"Notify programmer.",! D EOP^BRN Q
 .;
 .S BRNRIEN=+Y
 . W !!,"DISCLOSURE NUMBER: ",$$VAL^XBDIQ1(90264,BRNRIEN,.02)
 .S BRNQ=0
 .Q
EDIT ; EDIT DISCLOSURE RECORD JUST ADDED
 S DIE="^BRNREC(",DA=BRNRIEN,DR="[BRN JCK BRANCH]",DIE("NO^")=1 D ^DIE K DA,DR,DIE,DIE("NO^")
 ;
RECVAR ;Get Record Variables
 ;
 S Y=BRNRIEN
 D ^BRNREF ;              set standard variables from record
 Q
 ;
DELETE ; DELETE DISCLOSURE JUST ADDED BECAUSE OPERATOR DIDN'T FINISH
 W !!,"INCOMPLETE DISCLOSURE BEING DELETED!",!!
 S DIK="^BRNREC(",DA=BRNRIEN D ^DIK
 D PAUSE^BRN
 Q
 ;
 ;
EOJ ; END OF JOB
 D ^BRNKILL
 Q
