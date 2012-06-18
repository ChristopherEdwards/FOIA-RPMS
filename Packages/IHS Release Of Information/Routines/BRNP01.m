BRNP01 ; IHS/OIT/LJF - PRE & POST INIT CODE FOR PATCH 1
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/11/2007 PATCH 1 Added this routine
 ;
CHKEN ;
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." S XPDQUIT=2 Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." S XPDQUIT=2 Q
 ;
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ;CHECKS FOR PACKAGES AND PATCHES HERE
 I $$VERSION^XPDUTL("IHS RELEASE OF INFORMATION")<2 D
 . W !,"You must first install IHS RELEASE OF INFORMATION V2.0." S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP; pre-init code
 D BMES^XPDUTL("Removing triggers for Suspend Date fields.")
 D DELIX^DDMOD(90264,2402,1),DELIX^DDMOD(90264,2403,1)
 Q
 ;
POST ;EP; post init code
 ;D FIX   ;TEMPORARY FOR TEST SITES ONLY
 D ACTIVE,XREF,RPTMENU,FAC
 Q
 ;
ACTIVE ; set all current ROI LISTING REC PARTY entries as Active
 D BMES^XPDUTL("Stuffing ACTIVE for all ROI LISTING REC PARTY entries")
 NEW BRN,DIE,DA,DR
 S DIE=90264.1,DR=".08///A"
 S BRN=0 F  S BRN=$O(^BRNTREQ(BRN)) Q:'BRN  D
 . Q:$P(^BRNTREQ(BRN,0),U,8)]""   ;skip if already answered
 . S DA=BRN D ^DIE
 Q
 ;
XREF ; reindex ROI LISTING RECORD file
 ; make sure all new and fixed indices are in good shape
 D BMES^XPDUTL("Re-indexing ROI LISTING RECORD file for selected indices.")
 K ^BRNREC("AA"),^BRNREC("AC"),^BRNREC("AD"),^BRNREC("AP")
 NEW DIK S DIK="^BRNREC(",DIK(1)=".01^AA1^AC1^AD1^AP1^AF1^AG1" D ENALL^DIK
 S DIK(1)=".22^AJ" D ENALL^DIK
 Q
 ;
RPTMENU ; remove old BRN GS AGING1 RPT option from Reports Menu
 D BMES^XPDUTL("Removing old Aging Report option from Menu.")
 NEW OPT,MENU,ITEM,DIK,DA
 S OPT=$O(^DIC(19,"B","BRN GS AGING1 RPT",0)) I 'OPT D ERR Q
 S MENU=$O(^DIC(19,"B","BRN MENU RPT",0)) I 'MENU D ERR Q
 S ITM=$O(^DIC(19,MENU,10,"B",OPT,0)) I 'ITM Q
 S DA=ITM,DA(1)=MENU,DIK="^DIC(19,"_DA(1)_",10,"
 D ^DIK
 Q
 ;
ERR ; report error if action could not be performed
 D BMES^XPDUTL("  **** ERROR REPORTED:  Could not remove option. ****")
 Q
 ;
FAC ; stuff new facility field where possible
 ; This code will attempt to determine the facility involved for
 ; each past disclosure.  If the site has only one facility set up
 ; in the parameter file, that will be stuffed.  For sites with more
 ; than one facility, the code will try to match on patient, user who
 ; initiated, staff assignment or user who completed.  If none match
 ; exactly, the field will be left blank.
 ;
 D BMES^XPDUTL("Stuffing new FACILITY field based on site parameter.")
 NEW FAC,BRN,PAT,HRCN,FOUND,SAV,USER
 S FAC=$O(^BRNPARM("B",0)) Q:'FAC
 I '$O(^BRNPARM("B",FAC)) D ONEFAC(FAC) Q    ;one facility in site parameter file
 ;
 ;now for multiple site databases
 ;   loop through ROI file
 S BRN=0 F  S BRN=$O(^BRNREC(BRN)) Q:'BRN  D
 . ;Q:$$GET1^DIQ(90264,BRN,.22)]""          ;already has facility set
 . S PAT=$P(^BRNREC(BRN,0),U,3) Q:'PAT     ;get patient
 . K HRCN S FAC=0 F  S FAC=$O(^AUPNPAT(PAT,41,FAC)) Q:'FAC  S HRCN(FAC)=""   ;get chart #s
 . S (FOUND,FAC)=0 K SAV
 . F  S FAC=$O(^BRNPARM("B",FAC)) Q:'FAC  I $D(HRCN(FAC)) S FOUND=FOUND+1 S:FOUND=1 SAV=FAC
 . I FOUND=1 D STUFFAC(BRN,SAV) Q    ;only one match found, so okay to stuff value
 . ;
 . ; else try matching on user's division
 . S USER=$P(^BRNREC(BRN,0),U,12) Q:'USER   ;get user who initiated
 . S (FOUND,FAC)=0 K SAV
 . F  S FAC=$O(^BRNPARM("B",FAC)) Q:'FAC  I $D(^VA(200,USER,2,FAC)) S FOUND=FOUND+1 S:FOUND=1 SAV=FAC
 . I FOUND=1 D STUFFAC(BRN,SAV)
 Q
 ;
ONEFAC(FAC) ; stuff all entries with the one facility in the site parameter file
 NEW IEN S IEN=$O(^BRNPARM("B",FAC,0)) Q:'IEN
 Q:'$$ACTIVFAC^BRNU(IEN)   ;quit if no longer active
 NEW BRN,DIE,DR,DA
 S DIE="^BRNREC(",DR=".22////"_IEN
 S BRN=0 F  S BRN=$O(^BRNREC(BRN)) Q:'BRN  D
 . ;Q:$$GET1^DIQ(90264,BRN,.22)]""          ;already has facility set
 . S DA=BRN D ^DIE
 Q
 ;
STUFFAC(DA,FAC) ; stuff this entry with this facility
 NEW IEN S IEN=$O(^BRNPARM("B",FAC,0)) Q:'IEN
 Q:'$$ACTIVFAC^BRNU(IEN)   ;quit if no longer active
 NEW DIE,DR
 S DIE="^BRNREC(",DR=".22////"_IEN
 D ^DIE
 Q
 ;
FIX ; fix test sites for trigger problems on reindexing
 NEW BRN,BRN1,LIST
 S BRN=0 F  S BRN=$O(^BRNREC(BRN)) Q:'BRN  D
 . K LIST
 . S BRN1=0 S BRN1=$O(^BRNREC(BRN,23,BRN1)) Q:'BRN1  D
 . . Q:'$D(^BRNREC(BRN,23,BRN1,0))
 . . S LIST(BRN1)=^BRNREC(BRN,23,BRN1,0)
 . ;
 . NEW OPEN,CLOSED,DATE,LAST
 . S LAST="",CLOSED=""
 . S BRN1=0 F  S BRN1=$O(LIST(BRN1)) Q:'BRN1  D
 . . S OPEN=$G(OPEN)+1                       ;count entry
 . . S DATE=$P(LIST(BRN1),U,2) I (DATE]""),(DATE>LAST) S LAST=DATE
 . . I DATE]"" S CLOSED=$G(CLOSED)+1         ;count closed
 . ;
 . I OPEN]"" D   ;data found to update
 . . S $P(^BRNREC(BRN,0),U,25,26)=OPEN_U_CLOSED
 . . I OPEN=CLOSED S $P(^BRNREC(BRN,0),U,8)="C" D
 . . . I LAST]"" S $P(^BRNREC(BRN,0),U,19)=LAST
 Q
