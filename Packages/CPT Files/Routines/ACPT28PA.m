ACPT28PA ;IHS/VEN/TOAD - ACPT*2.08*1 postinit ; 04/21/2008 11:06
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This is the post-init for ACPT*2.08*1, which calls it at IMPORT.
 ; It imports the HCPCS 2008 data from the American Medical Association's
 ; text files acpt2008.01h (HCPCS 2008 codeset) and acpt2008.01c (HCPCS
 ; 2008 modifiers) and installs them in the CPT (81) and CPT Modifier
 ; files (9999999.88).
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at IMPORT by KIDS as the post-init
 ; for ACPT*2.08*1.
 ;
 ; 2008 03-04 Rick Marshall rewrote this set of routines to handle ONLY
 ; the HCPCS codeset. Previous versions of this routine contained code to
 ; handle all three ranges of the CPT codes; for any given codeset's
 ; release the code that did not apply was commented out for each patch.
 ; This change was made because the shared code had grown too complex and 
 ; fragile to work consistently. From now on, separate sets of routines
 ; will be written for each release to keep the code clean and
 ; consistent. As part of the refactoring, all unnecessary subroutines
 ; were folded into the main procedure to simplify the flow of control.
 ; ACPTPOST was renamed ACPT28PA to make it fit the standard for pre-
 ; and post-inits (ACPT28P1 is the pre-init). LOADCODE and CLEAN were
 ; split out into a new routine, ACPT28PC, to keep ACPT28PA within the
 ; 10,000-character routine-portability limit. Likewise, step 3 was split 
 ; out into a new routine, ACPT28PB, so it could be expanded to clean up
 ; data integrity problems in existing HCPCS entries. The patch's
 ; original post-init called routine ACPT27P2, which cleaned up pseudo-
 ; entries in the indexes, leaving ACPTPOST to be called manually; it
 ; has been folded into this routine as the second part of step 3. I also
 ; have removed all prompts form this routine and replaced the prompt
 ; about the files' directory with a KIDS question, whose input appears
 ; in this routine in XPDQUES("POST1").
 ;
 ; The original unrefactored code was written by IHS/ASDST/DMJ and Shonda
 ; Render (SDR).
 ;
 ; There are three levels of CPT codes: 1) CPT level one, 2) HCPCS, and
 ; 3) CPT level three.
 ;
 ; CPT level-one codes are completely numeric. In VISTA's CPT file they
 ; make up the first range of entries (IENs with five or fewer digits),
 ; whose IENs equal their code value.
 ;
 ; HCPCS codes are a letter followed by four digits. In the CPT file they
 ; make up the second range of entries (IENs with six digits), divided
 ; into two subranges: older HCPCS codes with arbitrary IENs from 100,000 
 ; to 103,863, and newer HCPCS codes that are DINUMed to their code value 
 ; by replacing the lead letter with its ASCII value, yielding IENs from
 ; 650,300 (for A0300) to 865,298 (for V5298), though the complete
 ; possible range is from 650,001 (A0001) to 909,999 (Z9999).
 ;
 ; The CPT file then contains an obsolete range of entries (with seven-
 ; digit IENs) made up of two subranges: local codes (IENs from 1,000,000 
 ; to 9,990,000) which can no longer be used because of HIPAA, and forty-
 ; four CPT level-three codes (0001T to 0044T, stored from 9,990,001 to
 ; 9,990,044) that have been inactivated and replaced by corresponding
 ; entries in the fourth range.
 ;
 ; All active CPT level-three codes are four digits followed by a letter.
 ; In the CPT file they make up the fourth range of entries (IENs with
 ; ten digits). The IENs for these codes are DINUMed to their code values 
 ; by replacing all five characters with their ASCII code values,
 ; yielding IENs from 4848484965 (for 0001A) to 5757575790 (for 9999Z).
 ;
 ; This version of the postinit is entirely concerned with the HCPCS
 ; codes.
 ;
 ;
IMPORT ; ACPT*2.08*1 POST-INIT: Import HCPCS Codes & Modifiers form AMA files
 ;
 ;
 ; 1. Tell user what we are about to do
 ;
 ;
 D BMES^XPDUTL($$T("MSG+1")) ; ACPT*2.08*1 POST-INIT
 D BMES^XPDUTL($$T("MSG+2")) ; HCPCS 2008 Install (CPT Version 2.08 ...
 ; CPT version 2.08 patch 1 contains HCPCS codes & Modifiers for 2008.
 D MES^XPDUTL($$T("MSG+3"))
 ; The install will attempt to read the the HCPCS Description file
 D MES^XPDUTL($$T("MSG+4"))
 ; (acpt2008.01h) and HCPCS Modifiers file (acpt2008.c) from the
 D MES^XPDUTL($$T("MSG+5"))
 D MES^XPDUTL($$T("MSG+6")) ; directory you specified.
 ;
 ;
 ; 2. Get the directory containing the two files
 ;
 ;
 N ACPTPTH S ACPTPTH=$G(XPDQUES("POST1")) ; path to files
 I ACPTPTH="" D  ; for testing at programmer mode
 . S ACPTPTH=$G(^XTV(8989.3,1,"DEV")) ; default directory
 . D POST1^ACPT28PF(.ACPTPTH) ; input transform
 ;
 ;
 ; 3. prep existing HCPCS entries in site's CPT file
 ;
 ;
 ; Cleaning up existing HCPCS entries & setting Year Deleted field.
 D BMES^XPDUTL($$T("MSG+7"))
 N ACPTYR S ACPTYR=3080000 ; current year in FM format, important flag
 D PREPCODE^ACPT28PB
 ;
 D BMES^XPDUTL($$T("MSG+8")) ; Cleaning out false entries.
 D
 . N ACPTIEN S ACPTIEN=" "
 . F  S ACPTIEN=$O(^ICPT(ACPTIEN)) Q:ACPTIEN=""  D
 . . Q:+ACPTIEN=ACPTIEN
 . . Q:$P($G(^ICPT(ACPTIEN,0)),U)'=""
 . . Q:(ACPTIEN="BA")!(ACPTIEN="C")!(ACPTIEN="D")!(ACPTIEN="I")
 . . Q:(ACPTIEN="B")&'$D(^ICPT(ACPTIEN,0))  ; entries like ^ICPT("B",0)
 . . D MES^XPDUTL(ACPTIEN_"   "_$G(^ICPT(ACPTIEN,0)))
 . . K ^ICPT(ACPTIEN)
 ;
 ;
 ; 4. load HCPCS 2008 codes and modifiers from AMA files
 ;
 ;
 ; Installing 2008 HCPCS codes from file acpt2008.01h
 D BMES^XPDUTL($$T("MSG+9"))
 D LOADCODE^ACPT28PC ; step 4.1
 ;
 ; Loading 2008 HCPCS modifiers from file acpt2008.01c
 D BMES^XPDUTL($$T("MSG+10"))
 D LOADMOD^ACPT28PD ; step 4.2
 ;
 ; Reindexing CPT file (81); this will take awhile.
 D BMES^XPDUTL($$T("MSG+11"))
 D  ; step 4.3
 . N DA,DIK S DIK="^ICPT(" ; CPT file's global root
 . D IXALL^DIK ; set all cross-references for all records
 . D ^ACPTCXR ; rebuild C index for all records
 ;
 ; Reindexing CPT Modifier file (9999999.88).
 D BMES^XPDUTL($$T("MSG+12"))
 D  ; step 4.4
 . N DIK S DIK="^AUTTCMOD(" ; MODIFIER file's global root
 . D IXALL^DIK ; set all cross-references for all records
 ;
 ;
 ; 5. if CPT file is missing from Local Lookup file (8984.4), add it
 ;
 ;
 I '$D(^XT(8984.4,81,0)) D  ; if an entry for CPT (81) is not defined:
 . ; Adding CPT file to Local Lookup file (8984.4).
 . D BMES^XPDUTL($$T("MSG+13"))
 . I '$D(^DIC(8984.4)) D  Q
 . . ; Cannot add CPT file because Local Lookup file is missing.
 . . D MES^XPDUTL($$T("MSG+14"))
 . ;
 . D  Q:Y<0  ; add CPT to Local Lookup file with a LAYGO lookup
 . . N DLAYGO S DLAYGO=8984.4 ; override security restrictions on LAYGO
 . . N DIC S DIC="^XT(8984.4," ; global root of Local Lookup file
 . . S DIC(0)="LX" ; LAYGO, exact match
 . . N X S X=81 ; CPT file
 . . N DA,DTOUT,DUOUT ; unused input & outputs
 . . D ^DIC ; lookup
 . ;
 . D  ; set the .03 field of the new entry to "C"
 . . N DA S DA=+Y ; entry added by LAYGO lookup
 . . N DIE S DIE="^XT(8984.4," ; edit Local Lookup file
 . . S DR=".03////C" ; stuff "C" as the field's value
 . . N DIDEL,DTOUT ; unused input & outputs
 . . D ^DIE ; edit
 . ;
 . D MES^XPDUTL($$T("MSG+15")) ; File 81 added.
 ;
 ;
 ; 6. activate 2008 HCPCS codes, deactivate deleted ones
 ;
 ;
 I ACPTYR>DT D  ; for future: queue this step if not yet time to activate
 . N ZTRTN S ZTRTN="STEP6^ACPT28PE" ; entry point
 . N ZTDESC ; description
 . S ZTDESC="ACPT*2.08*1 post-init: activate/deactivate 2008 HCPCS codes"
 . N ZTIO S ZTIO="" ; no I/O device
 . N ZTDTH S ZTDTH="60996,21600" ; start time
 . N ACPTRDT S ACPTRDT=$$HTE^XLFDT(ZTDTH,1) ; save start time in external
 . N ZTSAVE S ZTSAVE("ACPTYR")="" ; save variable ACPTYR for the task
 . N ZTUCI,ZTCPU,ZTPRI,ZTKIL,ZTSYNC ; unused inputs & outputs
 . N ZTSK ; output: task # created
 . D ^%ZTLOAD
 . ;
 . I $G(ZTSK) D  ; if the task was queued
 . . ; I've taken the liberty to queue task # to run on [date]
 . . D MES^XPDUTL($$T("MSG+16")_ZTSK_$$T("MSG+17")_ACPTRDT)
 . . ; This routine will inactivate deleted codes & activate new ones.
 . . D MES^XPDUTL($$T("MSG+18"))
 . . ; If this date and time is inconvenient, you may use the Taskman
 . . D MES^XPDUTL($$T("MSG+19"))
 . . ; reschedule option to run at a more suitable time.
 . . D MES^XPDUTL($$T("MSG+20"))
 . E  D  ; if it was not
 . . ; Attempt to queue routine ACPT28PE was unsuccessful. This routi...
 . . D MES^XPDUTL($$T("MSG+21"))
 . . ; need to be run to activate new codes and deactivate old ones a...
 . . D MES^XPDUTL($$T("MSG+22"))
 . . ; should be run January or February 2008.
 . . D MES^XPDUTL($$T("MSG+23"))
 ;
 E  D  ; otherwise (if time to activate), do so now
 . ; Activating 2008 codes and deactivating deleted ones.
 . D BMES^XPDUTL($$T("MSG+24"))
 . D STEP6^ACPT28PE
 ;
 ;
 ; 7. update Package file (9.4)
 ;
 ;
 N DA D  Q:'DA  ; update current version of package to 2.08
 . S DA=$O(^DIC(9.4,"C","ACPT",0)) ; entry to edit
 . Q:'DA  ; skip if can't find ACPT
 . N DIE S DIE="^DIC(9.4," ; Package file
 . N DR S DR="13///2.08" ; stuff 2.08 in Curent Version field
 . D ^DIE ; edit the entry
 ;
 K Y D  Q:+Y<0  ; add 2.08 to subfile 22 of CPT package entry
 . S DA(1)=DA ; shift focus to subfile
 . N X S X=2.08
 . N DIC S DIC="^DIC(9.4,DA(1),22," ; 
 . S DIC(0)="LX" ; LAYGO and exact match
 . N DLAYGO,DTOUT,DUOUT
 . D ^DIC ; LAYGO lookup entry
 ;
 D
 . S DA=+Y ; shift focus to new subrecord
 . N DIE S DIE="^DIC(9.4,DA(1),22," ; 
 . N DR S DR="1///3071231;2///"_DT_";3///`"_DUZ ; stuff three fields
 . D ^DIE ; edit entry
 ;
 ;
 ; 8. done
 ;
 ;
 D BMES^XPDUTL($$T("MSG+25")) ; POST-INSTALL COMPLETE
 ;
 ;
 QUIT  ; end of IMPORT
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;;ACPT*2.08*1 POST-INIT
 ;;HCPCS 2008 Install (CPT Version 2.08 Patch 1)
 ;;CPT version 2.08 patch 1 contains HCPCS codes & Modifiers for 2008.
 ;;The install will attempt to read the the HCPCS Description file
 ;;(acpt2008.01h) and HCPCS Modifiers file (acpt2008.c) from the
 ;;directory you specified.
 ;;Cleaning up existing HCPCS entries & setting Year Deleted field.
 ;;Cleaning out false entries.
 ;;Installing 2008 HCPCS codes from file acpt2008.01h
 ;;Loading 2008 HCPCS modifiers from file acpt2008.01c
 ;;Reindexing CPT file (81); this will take awhile.
 ;;Reindexing CPT Modifier file (9999999.88).
 ;;Adding CPT file to Local Lookup file (8984.4).
 ;;Cannot add CPT file because Local Lookup file is missing.
 ;;File 81 added.
 ;;I've taken the liberty to queue task # 
 ;; to run on 
 ;;This routine will inactivate deleted codes & activate new ones.
 ;;If this date and time is inconvenient, you may use the Taskman
 ;;reschedule option to run at a more suitable time.
 ;;Attempt to queue routine ACPT28PE was unsuccessful. This routine will
 ;;need to be run to activate new codes and deactivate old ones and
 ;;should be run January or February 2008.
 ;;Activating 2008 codes and deactivating deleted ones.
 ;;POST-INSTALL COMPLETE
 ;
 ;
 ; end of routine ACPT28PA
