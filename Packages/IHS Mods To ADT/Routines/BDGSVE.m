BDGSVE ; IHS/ANMC/LJF - SCHEDULED VISIT EDIT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
PAT ; ask user for patient
 ; If BDGSVEis set and = 1 then in edit mode, else in view mode
 NEW DFN D KILL^AUPNPAT
 S DFN=+$$READ^BDGF("PO^9000001:EMQZ","Select Patient") Q:DFN<1
 ;
PATSET ;EP; entry where patient already known
 ; find all entries in SV file for patient (except deleted ones)
 ;  put into array sorted by date
 NEW BDGN,COUNT,BDGA,BDGA1,X,PROMPT
 S BDGN=0
 F  S BDGN=$O(^BDGSV("B",DFN,BDGN)) Q:'BDGN  D
 . Q:$$GET1^DIQ(9009016.7,BDGN,.16,"I")="ER"  ;quit if entered in error
 . S BDGA1(9999999-$$GET1^DIQ(9009016.7,BDGN,.02,"I"))=BDGN
 ;
 ; create numbered array linked to sorted array
 S X=0 F  S X=$O(BDGA1(X)) Q:'X  D
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=BDGA1(X)
 ;
 ; if no entries found, drop right into add mode
 I '$D(BDGA) D  Q
 . W !!,"No Scheduled Visits found for patient"
 . I '$G(BDGSVE) D PAUSE^BDGF Q
 . Q:'$$READ^BDGF("Y","OKAY TO ADD NEW SCHEDULED VISIT","NO")
 . D ADD,PAT
 ;
 W !!,"Scheduled Visit Entries for "_$$GET1^DIQ(2,DFN,.01)_":"
 F COUNT=1:1 Q:'$D(BDGA(COUNT))  Q:COUNT=10  D
 . W !,$J(COUNT,3),?6,$$GET1^DIQ(9009016.7,BDGA(COUNT),.02)  ;date
 . W ?25,$$GET1^DIQ(9009016.7,BDGA(COUNT),.03)
 . S X=$$GET1^DIQ(9009016.7,BDGA(COUNT),.16)             ;disposition
 . W ?45,$S(X]"":X,1:"Open/Pending")
 W !
 ;
 S PROMPT="Select Date by Number"
 I $G(BDGSVE) S PROMPT=PROMPT_" or ""A"" to Add New Entry"
 S Y=$$READ^BDGF("FO^1:"_$L(COUNT),PROMPT)
 ;
 I Y="A",$G(BDGSVE) D ADD,PAT Q
 I $D(BDGA(+Y)) S BDGN=BDGA(Y) D
 . I $G(BDGSVE) D SCREEN,PAT Q             ;edit then view
 . D ^BDGSVS Q                             ;view only
 Q
 ;
 ;
SCREEN ; -- call ScreenMan to add/edit parameters
 NEW DDSFILE,DA,DR,X
 S DDSFILE=9009016.7,DA=BDGN
 S X=$$GET1^DIQ(9009016.7,BDGN,.03,"I")  ;type of visit
 S DR="[BDG SCHED "_$S(X="A":"ADMIT",X="D":"DAY SURGERY",1:"OUTPATIENT")_"]"
 D ^DDS
 I $$READ^BDGF("Y","Want to print Scheduled Visit Summary","NO") D ^BDGSVS
 Q
 ;
ADD ; add new entry then call Screenman
 NEW DIC,X,DA,DLAYGO
 S (DIC,DLAYGO)=9009016.7,X=DFN,DIC(0)="AEMQLZ"
 S DIC("DR")=".02;.03" K DO,DD D FILE^DICN
 I Y S BDGN=+Y D SCREEN
 Q
 ;
