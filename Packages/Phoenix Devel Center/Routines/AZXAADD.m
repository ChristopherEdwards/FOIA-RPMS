AZXAADD ; IHS/PHXAO/TMJ - ADD A NEW DISCLOSURE DATE ;
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 ; Subscripted AZXAREC is EXTERNAL form.
 ;   AZXAREC("PAT NAME")=patient name
 ;   AZXAREC("REF DATE")=disclosure date
 ;   AZXADFN=patient ien
 ;   AZXARDATE=disclosure date in internal FileMan form
 ;   AZXARNUMB=disclosure number
 ;   AZXARIEN=Disclosure ien
 ;   AZXAMODE=A for add, M for modify
 ;   AZXARTYPE=type of disclousre (.04 field)
 ;
START ;
 F  D MAIN Q:AZXAQ  D HDR^AZXA
 D EOJ
 Q
 ;
MAIN ;
 S AZXAQ=0
 S AZXAMODE="A",AZXALOOK=""
 ;S APCDOVRR="" ;for provider narrative lookup
 D PATIENT ;              get patient being referred
 Q:AZXAQ
 D REFDISP
 I AZXAQ=1 G GETDATE
 ;
 D ASK
 Q:AZXAQ
 ;
GETDATE ;Do Get Date if no existing Disclosures
 D DATE ;                 get date of Disclosure
 Q:AZXAQ
 D ADD ;                  add new Disclosure record
 Q:AZXAQ
 D EDIT ;                 edit Disclosure record just added
 Q
 ;
PATIENT ; GET PATIENT
 F  D PATIENT2 I AZXAQ!($G(AZXADFN)) Q
 Q
 ;
PATIENT2 ; ASK FOR PATIENT UNTIL USER SELECTS OR QUITS
 S AZXAQ=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D DIC^AZXAFMC
 Q:Y<1
 S AZXADFN=+Y,AZXAREC("PAT NAME")=$P(^DPT(+Y,0),U)
 S AZXAQ=0
 I $$DOD^AUPNPAT(AZXADFN) D  I 'Y K AZXADFN,AZXAREC("PAT NAME") Q
 . W !!,"This patient is deceased."
 . S DIR(0)="YO",DIR("A")="Are you sure you want this patient",DIR("B")="NO" K DA D ^DIR K DIR
 . W !
 . Q
 Q
 ;
 ;
ASK ;Ask to Continue
 S AZXAQ=0
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue with adding a new Disclosure",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S AZXAQ=1 Q
 I 'Y S AZXAQ=1 Q
 Q
 ;
REFDISP ;Display if Patient has existing Disclosures
 W !!,?25,"********************",!
 W ?25,"**LAST 4 DISCLOSURES**",!,?25,"********************",!
 I '$D(^AZXAREC("AA",AZXADFN)) W !,?20,"**--NO EXISTING DISCLOSURES--**",! S AZXAQ=1 Q
 S AZXAQ=0
 S AZXADT=""
 F I=1:1:5 S AZXADT=$O(^AZXAREC("AA",AZXADFN,AZXADT),-1) Q:AZXADT=""  D NEXT
 Q
NEXT ;2ND $O
 S AZXARIEN=""
 F  S AZXARIEN=$O(^AZXAREC("AA",AZXADFN,AZXADT,AZXARIEN),-1) Q:AZXARIEN'=+AZXARIEN  D
 . Q:AZXADT=""
 . Q:AZXARIEN=""
 . D START^AZXALKI1
 . S I=I+1 ; increment outer loop counter to limit display to 4 Disclosures
 . Q
 Q
 ;
 ;
 ;
DATE ; GET DATE OF DISCLOSURE
 W !
 S AZXAQ=1
 ;
 S DIR(0)="1991075,.01",DIR("B")="TODAY" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S AZXARDATE=+Y,AZXAREC("REF DATE")=Y(0)
 S AZXAQ=0
 Q
 ;
ADD ; ADD NEW DISCLOSURE RECORD
 S AZXARR=""
 Q:AZXAQ
 I AZXARR="" D  Q
 .S DIC="^AZXAREC(",DIC(0)="L",DLAYGO=1991075,DIC("DR")=".03////"_AZXADFN,X=AZXARDATE
 .D FILE^AZXAFMC
 .I Y<0 W !,"Error creating DISCLOSURE.",!,"Notify programmer.",! D EOP^AZXA Q
 .;
 .S AZXARIEN=+Y
 . W !!,"DISCLOSURE NUMBER: ",$$VAL^XBDIQ1(1991075,AZXARIEN,.02)
 .S AZXAQ=0
 .Q
EDIT ; EDIT REFERRAL RECORD JUST ADDED
 S DIE="^AZXAREC(",DA=AZXARIEN,DR="[AZXA JCK BRANCH]",DIE("NO^")=1 D ^DIE K DA,DR,DIE,DIE("NO^")
 ;
RECVAR ;Get Record Variables
 ;
 S Y=AZXARIEN
 D ^AZXAREF ;              set standard variables from record
 Q
 ;
DELETE ; DELETE REFERRAL JUST ADDED BECAUSE OPERATOR DIDN'T FINISH
 W !!,"INCOMPLETE DISCLOSURE BEING DELETED!",!!
 S DIK="^AZXAREC(",DA=AZXARIEN D ^DIK
 D PAUSE^AZXA
 Q
 ;
 ;
EOJ ; END OF JOB
 D ^AZXAKILL
 Q
