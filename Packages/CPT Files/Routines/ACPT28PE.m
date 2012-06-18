ACPT28PE ;IHS/VEN/TOAD - ACPT*2.08*1 postinit step 6 ; 04/20/2008 23:32
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This subroutine of the post-init for ACPT*2.08*1 activates the 2008
 ; HCPCS codes and deactivates the deleted ones. See routine ACPT28PA
 ; for the complete algorithm and overview, and LOADCODE^ACPT28PC for
 ; the data import and the set up of the flags that drive ACTIV8 and
 ; INACTIV8.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at STEP6 by ACPT28PA as part of the
 ; post-init for ACPT*2.08*1.
 ;
 ; 2007 01 Shonda Render (IHS) edited to set the status flag with a new
 ; call to DIE, replacing the prior setting of DIC("DR") input to the
 ; DIC calls.
 ;
 ; 2008 03 Rick Marshall (VEN/CNI/IHS) commented the routine top to
 ; bottom while tracking down a bug: the status flag was found during
 ; verification of ACPT*2.08*1 to be set inconsistently, suggesting
 ; fragility in the algorithm. I also took the opportunity to tighten up
 ; variable scoping to help make the code a bit more robust. I also got
 ; rid of the calls to DOTS^ACPTPOST as unnecessary calls for such
 ; simple code, half of which (U IO(0)) we should only do once at the top
 ; not for every CPT code we traverse. I fixed a bug in which the dots
 ; not printing out nearly as often as the original designer expected. I
 ; also eliminated all code not related to HCPCS codes specifically.
 ;
 ; 2008 04 17-20 Rick Marshall renamed this routine from ACPTSINF to
 ; ACPT28PE to make its relationship to the other post-init routines
 ; clearer and to follow the standard for naming poast-inits. I also
 ; redid many of the comments, introduced a label for ACPT28PA to call,
 ; and otherwise brought it in line with the other ACPT28P* routines. I
 ; also radically simplify ACTIV8's logic in synch with the overhaul of
 ; LOADCODE^ACPT28PC that did likewise; a lesser simplification was also
 ; done on INACTIV8's logic.
 ;
 ; The original routine ACPTSINF was the work of IHS/ASDST/DMJ and
 ; Shonda Render (SDR).
 ;
 ; Called only by routine ACPT28PA as part of the post-init that imports
 ; and installs the CPT data from the text files. This subroutine
 ; traverses the CPT file (81) and corrects the Inactive Flag; new codes
 ; have their Date Added set to a real date; deleted codes have their
 ; Date Deleted set to a real date and a corresponding Effective Date's
 ; Status set to INACTIVE.
 ;
 ; The reason none of this is done up front in ACPT28PC is because this
 ; might be a test site installing prior to the codes' activation (&
 ; deactivation) dates; for example, a test site might be installing the
 ; patch for the 2008 codes in December, 2007, so we do not want to
 ; activate them yet. Instead, ACPT28PC imports the codes but does not
 ; activate them; it flags them for later activation and queues STEP6 as
 ; a task to run Jan 1, 2008 at 6:00 a.m., at which point STEP6 will
 ; activate the new codes and deactivate any HCPCS codes that exist but
 ; were not included in the 2008 codeset. STEP6 has to be able to handle
 ; both this test-site situation, in which it runs as a task long after
 ; the post-init, and a non-test-site situation, in which it is called
 ; during the post-init and runs immediately.
 ;
 ; This subroutine's main inputs and outputs are the HCPCS entries in the
 ; CPT file itself.
 ;
 ;
STEP6 ; post-init step 6: activate 2008 HCPCS codes, deactivate deleted ones
 ;
 ; private: called only by step 6 of routine ACPT28PC
 ;
 ; input: ACPTYR = 3080000, to use as the flag value for the Date Deleted
 ; field.
 ;
 ; loop: traverse the entries for HCPCS codes in the CPT file (81)).
 ; For each, activate if new, inactivate if deleted.
 ;
 D
 . N ACPTDA S ACPTDA=99999 ; CPT file entry #, from just before HCPCS
 . N ACPTDOTS ; count, so that a dot is printed every 100 codes
 . F ACPTDOTS=1:1 S ACPTDA=$O(^ICPT(ACPTDA)) Q:'ACPTDA!(ACPTDA>999999)  D
 . . D ACTIV8(ACPTDA,ACPTYR) ; activate 2008 HCPCS codes
 . . D DEACTIV8(ACPTDA,ACPTYR) ; deact codes not in 2008 HCPCS codeset
 . . Q:$D(ZTQUEUED)  ; if this has been queued, skip the dots
 . . W:'(ACPTDOTS#100) "." ; otherwise, write a dot for every 100 codes
 ;
 QUIT  ; end of STEP6
 ;
 ;
ACTIV8(ACPTDA,ACPTYR) ; activate 2008 HCPCS codes
 ;
 ; private: called only by STEP6 above
 ;
 ; called only by the main procedure above; only ACPTDA passed in (by
 ; value), though the major input is the corresponding CPT record;
 ; likewise the output is to the record: the Inactive Flag field (5) of
 ; the CPT record, the creation if missing of a new Effective Date
 ; subfile (60/81.02) record, and the Status field (.02) of that
 ; subrecord. The Status Field is a set of codes: 0 = INACTIVE,
 ; 1 = ACTIVE.
 ;
 ; This code no longer worries about the Effective Date subfile, which
 ; has been completely handled by the overhauled LOADCODE^ACPT28PC. It
 ; only has to clear the Inactive Flag and set the Date Added to a real
 ; date.
 ;
 ; Likewise, the logic deciding which entries to activate has been
 ; simplified. It is only looking for inactive entries with a Date Added
 ; set to 3080000. We no longer worry about checking for whether we are
 ; running too soon; we leave that protection up to ACPT28PA to decide
 ; when and how we are called.
 ;
 N ACPTNODE S ACPTNODE=$G(^ICPT(ACPTDA,0)) ; get CPT's header node
 Q:ACPTNODE=""  ; skip bad records with no header
 ;
 N ACPTADD S ACPTADD=$P(ACPTNODE,U,6) ; CPT's Date Added (7)
 Q:ACPTADD'=ACPTYR  ; if new, Date Added = 3080000 from LOADCODE^ACPT28PC
 ;
 N ACPTINAC S ACPTINAC=$P(ACPTNODE,U,4) ; CPT's Inactive Flag (5)
 Q:'ACPTINAC  ; new codes also have this flag set to INACTIVE (1)
 ;
 S $P(ACPTNODE,U,4)="" ; clear the Inactive Flag
 S $P(ACPTNODE,U,6)=3080101 ; set Date Added to a real date
 ;
 S ^ICPT(ACPTDA,0)=ACPTNODE ; copy results back to CPT's header node
 ;
 QUIT  ; end of ACTIV8
 ;
 ;
DEACTIV8(ACPTDA,ACPTYR) ; deactivate codes not in 2008 HCPCS codeset
 ;
 ; private: called only by STEP6 above
 ;
 ; called only by the main procedure above; only ACPTDA passed in (by
 ; value), though the major input is the corresponding CPT record;
 ; likewise the output is to the record: the Inactive Flag (5) and Date
 ; Deleted (8) fields of the CPT record, the creation if missing of a new 
 ; Effective Date subfile (60/81.02) record, and the Status field (.02)
 ; of that subrecord. The Status Field is a set of codes: 0 = INACTIVE,
 ; 1 = ACTIVE.
 ;
 ; Which codes this inactivates is driven by the CPT's Date Deleted field
 ; (8). Step 3 of the post-init (in PREPCODE^ACPT28PB) processes HCPCS
 ; codes to set Date Deleted to 3080000 for those that do not already
 ; have a Date Deleted, and then in step 4 (in LOADCODE^ACPT28PC) it
 ; clears the Date Deleted value for each HCPCS code brought in by the
 ; update from AMA, that is, for every new, changed, or merely preserved
 ; code in the set. The result should be that codes deleted from the new
 ; AMA set will have their Date Deleted set to 3080000.
 ;
 ; A code is inactivated by setting its Inactive Flag to 1, its Date
 ; Deleted to a real date, and also each year, as long as a "deleted"
 ; code remains "deleted", it gets a new Effective Date entry created for 
 ; that year with the Status field for that year set to INACTIVE.
 ;
 N ACPTDEL S ACPTDEL=$P($G(^ICPT(ACPTDA,0)),U,7) ; CPT's Date Deleted (8)
 Q:ACPTDEL'=ACPTYR  ; skip codes not deleted by this post-init
 ;
 ; otherwise, let's inactivate it:
 ;
 S $P(^ICPT(ACPTDA,0),U,4)=1 ; first, set the Inactive Flag
 S $P(^ICPT(ACPTDA,0),U,7)=3080101 ; 2nd, set Date Deleted to a real date
 ;
 ; third, let's find or add the current Effective Date (1/1/2008)
 N DA S DA(1)=ACPTDA ; parent record, i.e., the CPT code
 D
 . N DIC S DIC="^ICPT("_DA(1)_",60," ; Effective Date subfile (60/81.02)
 . S DIC(0)="L" ; allow LAYGO (Learn As You Go, i.e., add if not found)
 . S DIC("P")=$P(^DD(81,60,0),"^",2) ; subfile # & specifier codes
 . N X S X="01/01/2008" ; value to lookup in the subfile
 . N DLAYGO,Y,DTOUT,DUOUT ; other parameters for DIC
 . D ^DIC ; Fileman Lookup call
 . S DA=+Y ; save IEN of found/added record for next call below
 ;
 D  ; third, let's inactivate it
 . N DIE S DIE="^ICPT("_DA(1)_",60," ; Effective Date subfile (60/81.02)
 . N DR S DR=".02////0" ; set Status field to INACTIVE
 . N DIDEL,DTOUT ; other parameters for DIE
 . D ^DIE ; Fileman Data Edit call
 ;
 QUIT  ; end of DEACTIV8
 ;
 ;
 ; end of routine ACPT28PE
