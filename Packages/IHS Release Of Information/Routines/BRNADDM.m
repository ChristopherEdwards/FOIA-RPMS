BRNADDM ; IHS/OIT/LJF - ADD MULTIPLE PATIENTS UNDER ONE REQUEST
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ; IHS/OIT/LJF 01/03/2008 PATCH 1 - routine added
 ;
 W !!,"This option allows you to enter multiple patients under one request."
 W !,"You will be asked the requesting information once and then the "
 W !,"specific information for each patient.",!
 ;
 NEW BRNQUIT,BRNRDATE,BRNTYPE,BRNOTHER,BRNMETH,BRNPARTY,BRNPUR,BRNPRIOR
DATE S BRNRDATE=$$READ^BRNU("90264,.01","DATE REQUEST INITIATED","TODAY")
 Q:BRNRDATE<1
 I '$$FACOK^BRNU(BRNRDATE) W !,"** MUST BE BEFORE YOUR DIVISION'S INACTIVATION DATE **",! D DATE Q
 ;
 S BRNTYPE=$$READ^BRNU("90264,.04") Q:BRNTYPE=U
 I BRNTYPE="O" S BRNOTHER=$$READ^BRNU("90264,.05")
 ;
 S BRNMETH=$$READ^BRNU("90264,.21") Q:BRNMETH=U
 S BRNPARTY=+$$READ^BRNU("90264,.06") Q:BRNPARTY=U
 S BRNPUR=$$READ^BRNU("90264,.07") Q:BRNPUR=U
 S Y=BRNPUR,C=$P(^DD(90264,.07,0),U,2) D Y^DIQ S BRNPUR=Y K C,Y
 S BRNPRIOR=$$READ^BRNU("90264,.09",,"NON-CRITICAL") Q:BRNPRIOR=U
 ;
PATS ; loop through patients, stuff common data and ask individual data
 NEW FIRST,BRNDFN,BRNRIEN
 S BRNQUIT=0,FIRST=1
 F  D  Q:BRNDFN<1
 . S PROMPT="Select "_$S(FIRST:"",1:"Another ")_"PATIENT",FIRST=0
 . S BRNDFN=+$$READ^BRNU("PO^2:EMQZ",PROMPT) Q:BRNDFN<1
 . ;
 . I $$DOD^AUPNPAT(BRNDFN) D  Q:BRNQUIT
 . . W !!,"This patient is deceased."
 . . I '$$READ^BRNU("Y","Are you sure you want this patient","NO") S BRNQUIT=1
 . ;
 . E  Q:'$$READ^BRNU("Y","Do you want to continue with adding a new Disclosure","YES")
 . ;
 . D ADDPAT Q:BRNQUIT
 . ;
 . S DIE="^BRNREC(",DA=BRNRIEN,DR="[BRN MULTIPLE ADD]",DIE("NO^")=1
 . D ^DIE K DA,DR,DIE,DIE("NO^")
 . W !
 Q
 ;
ADDPAT ; add new disclosure for this patient
 NEW DIC,Y,DD,DO,DLAYGO
 S DIC="^BRNREC(",DIC(0)="L",DLAYGO=90264,DIC("DR")=".03////"_BRNDFN,X=BRNRDATE
 D FILE^DICN
 I Y<0 D  Q
 . W !,"Error creating DISCLOSURE.",!,"Notify programmer.",!
 . D PAUSE^BRNU
 . S BRNQUIT=1
 ;
 S BRNRIEN=+Y
 W !!,"DISCLOSURE NUMBER: ",$$GET1^DIQ(90264,BRNRIEN,.02)
 Q
