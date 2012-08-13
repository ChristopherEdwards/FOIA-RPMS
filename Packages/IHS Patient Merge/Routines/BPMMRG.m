BPMMRG ; IHS/OIT/LJF - IHS CODE CALLED BY MERGE FUNCTION
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;
 Q
PKG ;EP; check to make sure Package file is clean before merge runs
 ; Called by XDRMERG0
 NEW IEN,DIK,DA
 S IEN=0
 F  S IEN=$O(^DIC(9.4,IEN)) Q:'IEN  D
 . Q:$$GET1^DIQ(9.4,IEN,.01)="IHS PATIENT MERGE"
 . K ^DIC(9.4,IEN,20)
 ;
 ;now clean up ANRG xref
 K ^DIC(9.4,"AMRG")
 NEW DIK S DIK="^DIC(9.4,DA(1),20,",DIK(1)=".01^AMRG"
 S DA(1)=0
 F  S DA(1)=$O(^DIC(9.4,DA(1))) Q:'DA(1)  D ENALL^DIK
 ;
 Q
 ;
DWAUD(ARRAY) ;EP; remove DW Audit entries for all FROM patients in batch
 ; called by DQ^XDRMERG0
 NEW FROM,DA,DIK
 S FROM=0 F  S FROM=$O(@ARRAY@(FROM)) Q:FROM'>0  D
 . S DA=FROM,DIK="^AUPNDWAF(" D ^DIK
 Q
 ;
VISITS(BPMRY) ;EP ; flag all visits to be repointed before merge runs
 ; insures visits are re-exported with new patient pointer
 ; called by EN^BPMXDRV
 NEW FROM,VST,AUPNVSIT
 S FROM=0 F  S FROM=$O(@BPMRY@(FROM)) Q:'FROM  D
 . S VST=0 F  S VST=$O(^AUPNVSIT("AC",FROM,VST)) Q:'VST  D
 . . S AUPNVSIT=VST D MOD^AUPNVSIT
 Q
 ;
ENDMRG(XDRFR,BPMTO,I) ;EP; perform end of merge steps
 ; called by CLOSEIT^XDRMERG
 ;IHS/PAO/AEF 03/06/2006
 D UPD(BPMTO) ;update 'UPDATE' fields in IHS Patient file for TO patient
 ; leave stub in ^AUPNPAT for FROM patient
 I I="^AUPNPAT(" D
 . S ^AUPNPAT(XDRFR,0)=XDRFR
 . S ^AUPNPAT(XDRFR,-9)=BPMTO
 . ; END IHS/PAO/AEF
 . ;
 . ; and set DELETE flag in DW Audit file
 . S ^AUPNDWAF(XDRFR,0)=XDRFR_U_DT,$P(^AUPNDWAF(XDRFR,0),U,13)=1
 . S ^AUPNDWAF("B",XDRFR,XDRFR)=""
 ;
 Q
 ;
UPD(DA) ;IHS/PAO/AEF
 ;----- SET 'DATE OF LAST UPDATE' AND 'USER-LAST UPDATE' FIELDS
 N DIE,DIR,X,Y
 S DIE="^AUPNPAT("
 S DR=".16////"_$G(DT)_";.12////"_$G(DUZ)
 D ^DIE
 Q
 ;
HSUM ;EP; print health summaries for verified or merged pairs
 ; Called by option BPM HS PRINT VERIFIED
 NEW BPMHST,BPMSTAT,SCREEN,DIC,Y,X,BPMREC1,BPMREC2
 S BPMHST=$O(^GMT(142,"B","BPM MERGE",0))
 I BPMHST<1 W !!,"  Merge Health Summary Type not installed.  Contact site manager" D PAUSE^BPMU Q
 ;
 ;select type of pairs wanted
 ;   Verified-Not Ready, Verified-Ready or Merged
 S BPMSTAT=$$READ^BPMU("SO^1:VERIFIED, NOT READY TO MERGE;2:VERIFIED, READY TO MERGE;3:MERGED","Select TYPE OF PAIRS")
 Q:BPMSTAT<1
 I BPMSTAT=1 S SCREEN="I $P(^VA(15,Y,0),U,3)=""V"",$P(^(0),U,5)=0"
 I BPMSTAT=2 S SCREEN="I $P(^VA(15,Y,0),U,3)=""V"",$P(^(0),U,5)=1"
 I BPMSTAT=3 S SCREEN="I $P(^VA(15,Y,0),U,5)=2"
 ;
 ;Lookup Patient Pairs based on screen
 NEW AUPNLK S AUPNLK("ALL")=1
 S DIC=15,DIC(0)="AEMQZ",DIC("A")="Select PATIENT:  ",DIC("S")=SCREEN D ^DIC Q:Y<1
 S BPMREC1=+$$GET1^DIQ(15,+Y,.01,"I")  ;record1 patient
 S BPMREC2=+$$GET1^DIQ(15,+Y,.02,"I")  ;record2 patient
 ;
 ;Ask for printer
 D ZIS^BPMU("QP","HSQUE^BPMMRG","Merge Health Summaries","BPMREC1;BPMREC2;BPMHST")
 D KILL^AUPNPAT
 D HOME^%ZIS
 Q
 ;
HSQUE ;EP; loop thru pair and print health summaries (VA type)
 ; Called by HSUM^BPMMRG (see above)
 ; variables BPMREC1, BPMREC2 & BPMHST set by ZTLOAD if queued
 NEW BPMI
 F BPMI=BPMREC1,BPMREC2 D ENX^GMTSDVR(BPMI,BPMHST)
 D KILL^AUPNPAT K HRCN
 D ^%ZISC
 Q
 ;
FIX ;EP; clean up process stopped by error
 ;Called by BPM RESET LOST MERGE option
 N BPMI,DIE,DA,DR,DIR,BPMC
 S (BPMC,BPMI)=0 F  S BPMI=$O(^VA(15.2,BPMI)) Q:BPMI'>0  I $P(^(BPMI,0),U,4)="A" D
 . S BPMC=BPMC+1
 . S DIR(0)="Y",DIR("A")="Do you want to reset "_$P(^VA(15.2,BPMI,0),U)
 . D ^DIR K DIR I Y'>0 Q
 . S DIE="^VA(15.2,",DA=BPMI,DR=".04///U;.09///1" D ^DIE
 . K DIE,DR
 I BPMC=0 W !!,"No lost merge processes were found.",!! D PAUSE^BPMU
 Q
