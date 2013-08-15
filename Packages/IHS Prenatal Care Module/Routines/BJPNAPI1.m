BJPNAPI1 ;GDIT/HS/BEE-Prenatal Care Module API Calls (Cont.) ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
VFADD(TARGET,PIPIEN,VIEN,APCDALVR) ;PEP - Add entry to the V OB file and update the PIP entry
 ;
 ;This API adds a new entry to the V OB (#9000010.43) file and also adds (or updates)
 ;the corresponding prenatal problem list (#90680.01) entry with the new information.
 ;The V OB file is a dynamic file, meaning it tracks the values of problems over time. Therefore,
 ;a NEW entry to this file is created WHENEVER a problem is added to a patient's PIP OR WHENEVER
 ;an UPDATE is made to that problem entry on the PIP. If an update and fields are not passed in,
 ;current values are used in the new entry.
 ;
 ;The only exception is that notes are stored across entries (to save space in resaving them each time).
 ;To see therefore ALL notes that have been entered for a problem on the PIP, you have to loop through
 ;ALL V OB entries relating to that patient's PIP problem and pull ALL of the notes in each.
 ;
 ;Input:
 ;   PIPIEN - Pointer to prenatal problem list (#90680.01) entry - Null if NEW entry
 ;     VIEN - Visit IEN
 ; APCDALVR - Array of entry values
 ;          - ("APCDSMD")  - Pointer to BJPN SNOMED TERMS (#90680.02) entry. *REQUIRED for NEW PIP entry
 ;          - ("APCDPRI")  - Priority (L-Low,M-Medium,H-High)
 ;          - ("APCDSCO")  - Scope (A-All Pregnancies,C-Current Pregnancy)
 ;          - ("APCDSTS")  - Status (A-Active,I-Inactive)
 ;          - ("APCDEDD")  - Definitive EDD - Internal FM format
 ;          - ("APCDPTX")  - Provider Text String
 ;          - ("APCDPOV")  - Visit Set as POV (1-Yes,""-No)
 ;          - ("NOTE")     - Note to be added
 ;          - ("APCDDELD") - Problem Deleted Date/Time - Internal FM format
 ;          - ("APCDDELB") - Problem Deleted By - DUZ value
 ;          - ("APCDDELR") - Problem Delete Reason - (D-Duplicate,E-Entered in Error,O-Other)
 ;          - ("APCDDELO") - Delete Reason - if other
 ;
 ;Output:
 ;  TARGET - Piece 1 - 1-Success/0-Failure
 ;           Piece 2 - PIPIEN
 ;           Piece 3 - Error Message
 ;
 NEW DFN,ADD,SMDTM,NOW,%,APCDVUPD,BJPNUPD,ERROR,IEN,EVDT,PPROV,PKIEN,APCDTMP
 ;
 ;Save current copy of APCDALVR
 M APCDTMP=APCDALVR
 ;
 ;Input validation
 S PIPIEN=$G(PIPIEN)
 S PKIEN=$G(APCDALVR("APCDSMD"))
 I PIPIEN="",PKIEN="" S @TARGET@(1,0)="0^^New PIP problem - Missing APCDPKL" G XVFADD
 I $G(VIEN)="" S @TARGET@(1,0)="0^^Missing VIEN" G XVFADD
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") I DFN="" S @TARGET@(1,0)="0^^Missing DFN" G XVFADD
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Set up additional APCDALVR entries
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=VIEN
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.43 (MOD)]"
 S APCDALVR("APCDAUTO")=1
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDLMD")=NOW
 S:$D(APCDALVR("NOTE")) APCDVUPD(2100)=1
 S APCDALVR("APCDEPV")=DUZ
 ;
 ;Determine if Add or Update - Look for UPDATE match if PIPIEN isn't passed
 S ADD=0 S:PIPIEN="" ADD=1
 I ADD=1 S IEN="" F  S IEN=$O(^BJPNPL("AC",DFN,PKIEN,IEN)) Q:IEN=""  D  Q:'ADD
 . ;
 . ;Skip Deletes
 . I $$GET1^DIQ(90680.01,IEN_",",2.01,"I")]""
 . S ADD=0,PIPIEN=IEN
 ;
 ;If update, make sure it hasn't been deleted
 I ADD=0,$$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" S @TARGET@(1,0)="0^^Problem has been deleted - enter a new record (send PIPIEN as null)" G XVFADD
 ;
 ;Define Technical Note
 I ADD=1 S APCDALVR("TNOTE")="Added Problem To PIP"
 E  S APCDALVR("TNOTE")="Updated Problem Entry"
 ;
 ;If Add - Create 90680.01 entry
 I ADD=1 D  I PIPIEN="" G XVFADD
 . NEW DIC,DLAYGO,X,Y
 . S DIC="^BJPNPL("
 . S DLAYGO=90680.01,DIC("P")=DLAYGO,DIC(0)="LOX"
 . S X=PKIEN
 . S DIC("DR")=".02////"_DFN_";.03////"_PKIEN
 . K DO,DD D FILE^DICN
 . I Y=-1 S @TARGET@(1,0)="0^^Could not add problem to PIP" Q
 . S PIPIEN=+Y
 S APCDALVR("APCDPIP")=PIPIEN
 ;
 ;Get SNOMED Term
 S SMDTM=$$GET1^DIQ(90680.02,PKIEN_",",.02,"E")
 ;
 ;Priority
 I $D(APCDALVR("APCDPRI")) S APCDVUPD(.06)=""
 I $D(APCDALVR("APCDPRI")),APCDALVR("APCDPRI")="" S APCDALVR("APCDPRI")="@"
 I ADD=0,'$D(APCDALVR("APCDPRI")) S APCDALVR("APCDPRI")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I")
 ;
 ;Provider Text
 S:$G(APCDALVR("APCDPTX"))]"" APCDALVR("APCDPTX")=$$PNARR^BJPNVFIL(APCDALVR("APCDPTX")),APCDVUPD(.07)=""
 I ADD=0,'$D(APCDALVR("APCDPTX")) S APCDALVR("APCDPTX")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I")
 ;
 ;Provider Narrative
 I $G(APCDALVR("APCDPTX"))]"" D
 . NEW PTX
 . S PTX=$$GET1^DIQ(9999999.27,APCDALVR("APCDPTX"),".01","E")
 . S APCDALVR("APCDPNR")=$E(SMDTM_"| "_PTX,1,160)
 . S APCDALVR("APCDPNR")=$$PNARR^BJPNVFIL(APCDALVR("APCDPNR"))
 . S APCDVUPD(.11)=""
 ;
 ;Scope
 I (ADD=1)!$D(APCDALVR("APCDSCO")) S APCDVUPD(.08)=""
 I ADD=0,'$D(APCDALVR("APCDSCO")) S APCDALVR("APCDSCO")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 I ADD=1,'$D(APCDALVR("APCDSCO")) S APCDALVR("APCDSCO")="C"
 ;
 ;Status
 I (ADD=1)!$D(APCDALVR("APCDSTS")) S APCDVUPD(.09)=""
 I ADD=0,'$D(APCDALVR("APCDSTS")) S APCDALVR("APCDSTS")=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 I ADD=1,'$D(APCDALVR("APCDSTS")) S APCDALVR("APCDSTS")="A"
 ;
 ;Definitive EDD
 I (ADD=1)!$D(APCDALVR("APCDEDD")) S APCDVUPD(.1)=""
 I ADD=0,'$D(APCDALVR("APCDEDD")) S APCDALVR("APCDEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 I ADD=1,'$D(APCDALVR("APCDEDD")) S APCDALVR("APCDEDD")=$$GET1^DIQ(9000017,DFN_",",1311,"I")
 ;
 ;Snomed Term
 I (ADD=1)!$D(APCDALVR("APCDSMD")) S APCDVUPD(.12)=""
 I ADD=0,'$D(APCDALVR("APCDSMD")) S APCDALVR("APCDSMD")=$$GET1^DIQ(90680.01,PIPIEN_",",.01,"I")
 ;
 ;Process Deletes
 I $D(APCDALVR("APCDDELB")) S APCDVUPD(2.01)=""
 I $D(APCDALVR("APCDDELD")) S APCDVUPD(2.02)=""
 I $D(APCDALVR("APCDDELR")) S APCDVUPD(2.03)=""
 I $D(APCDALVR("APCDDELO")) S APCDVUPD(2.04)=""
 ;
 ;Set as POV
 I $D(APCDALVR("APCDPOV")) D
 . S APCDVUPD(.05)=""
 . I APCDALVR("APCDPOV")=1 Q
 . I APCDALVR("APCDPOV")="" S APCDALVR("APCDPOV")="@"
 ;
 ;Original Entry Date/Entered By
 I ADD=1 S APCDALVR("APCDOEDT")=NOW,APCDALVR("APCDOEBY")=DUZ,APCDVUPD(1216)="",APCDVUPD(1217)=""
 E  D
 . S APCDALVR("APCDOEDT")=$$GET1^DIQ(90680.01,PIPIEN_",",1.01,"I")
 . S APCDALVR("APCDOEBY")=$$GET1^DIQ(90680.01,PIPIEN_",",1.02,"I")
 ;
 ;Last Modified Date and By
 S APCDALVR("APCDLMDT")=NOW
 S APCDALVR("APCDLMBY")=DUZ
 ;
 ;1201 EVENT DATE AND TIME
 S EVDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 I EVDT]"" S APCDALVR("APCDEDT")=EVDT
 ;
 ;Ordering Provider
 ;S PPROV=$$PPRV^BJPNPKL(VIEN)
 ;I PPROV]"" S APCDALVR("APCDOPV")=PPROV
 ;
 ;Save Technical Notes
 S APCDVUPD(1218)="",APCDVUPD(1219)=""
 M APCDALVR("TNOTE")=APCDVUPD
 ;
 ;File V OB entry
 D ^APCDALVR
 I $G(APCDALVR("APCDAFLG"))=2 S @TARGET@(1,0)="0^^V OB file failed" G XVFADD
 ;
 ;Update Prenatal Problem entry
 S:$G(APCDALVR("APCDSMD"))]"" BJPNUPD(90680.01,PIPIEN_",",.01)=APCDALVR("APCDSMD")
 S:$G(APCDALVR("APCDPRI"))]"" BJPNUPD(90680.01,PIPIEN_",",.06)=APCDALVR("APCDPRI")
 S:$G(APCDALVR("APCDSCO"))]"" BJPNUPD(90680.01,PIPIEN_",",.07)=APCDALVR("APCDSCO")
 S:$G(APCDALVR("APCDSTS"))]"" BJPNUPD(90680.01,PIPIEN_",",.08)=APCDALVR("APCDSTS")
 S:$G(APCDALVR("APCDEDD"))]"" BJPNUPD(90680.01,PIPIEN_",",.09)=APCDALVR("APCDEDD")
 S:$G(APCDALVR("APCDPTX"))]"" BJPNUPD(90680.01,PIPIEN_",",.05)=APCDALVR("APCDPTX")
 S:$G(APCDALVR("APCDOEDT"))]"" BJPNUPD(90680.01,PIPIEN_",",1.01)=APCDALVR("APCDOEDT")
 S:$G(APCDALVR("APCDOEBY"))]"" BJPNUPD(90680.01,PIPIEN_",",1.02)=APCDALVR("APCDOEBY")
 S:$G(APCDALVR("APCDDELD"))]"" BJPNUPD(90680.01,PIPIEN_",",2.01)=APCDALVR("APCDDELD")
 S:$G(APCDALVR("APCDDELB"))]"" BJPNUPD(90680.01,PIPIEN_",",2.02)=APCDALVR("APCDDELB")
 S:$G(APCDALVR("APCDDELR"))]"" BJPNUPD(90680.01,PIPIEN_",",2.03)=APCDALVR("APCDDELR")
 S:$G(APCDALVR("APCDDELO"))]"" BJPNUPD(90680.01,PIPIEN_",",2.04)=APCDALVR("APCDDELO")
 S:$G(APCDALVR("NOTE"))]"" BJPNUPD(90680.01,PIPIEN_",",3)=APCDALVR("NOTE")
 S BJPNUPD(90680.01,PIPIEN_",",1.03)=NOW
 S BJPNUPD(90680.01,PIPIEN_",",1.04)=DUZ
 ;
 I $D(BJPNUPD) D FILE^DIE("","BJPNUPD","ERROR")
 I $D(ERROR) S @TARGET@(1,0)="0^^File 90680.01 update failed" G XVFADD
 ;
 ;Set as POV
 I $D(APCDALVR("APCDPOV")) D
 . I APCDALVR("APCDPOV")=1 D POV^BJPNPUP("",VIEN,PIPIEN) Q
 . I APCDALVR("APCDPOV")="" D DPOV^BJPNPUTL("",VIEN,PIPIEN)
 ;
 S @TARGET@(1,0)="1^"_PIPIEN_"^"
 ;
XVFADD ;Restore original APCDALVR
 K APCDALVR M APCDALVR=APCDTMP
 Q "~@"_$NA(@TARGET)
