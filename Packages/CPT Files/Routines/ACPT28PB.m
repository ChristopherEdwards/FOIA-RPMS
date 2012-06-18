ACPT28PB ;IHS/VEN/TOAD - ACPT*2.08*1 postinit step 3 ; 04/20/2008 23:03
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This subroutine of the post-init for ACPT*2.08*1 preps the existing
 ; HCPCS codes in the site's CPT file (81) for the loading of the new
 ; 2008 AMA codes. See routine ACPT28PA for the complete algorithm and
 ; overview.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at PREPCODE by ACPT28PA as part of the
 ; post-init for ACPT*2.08*1.
 ;
 ; 2008 04 16-20 Rick Marshall created this routine to handle the HCPCS
 ; prep step of the post-init (step 3). Previously this step just set the 
 ; Date Deleted field (8) to a special value (3080000) prior to loading
 ; the AMS's 2008 HCPCS codes. As each AMA code was loaded, the Date
 ; Deleted was cleared, so that after loading the "deleted" codes in need 
 ; of inactivation could be easily identified. The loop to handle this
 ; was originally in routine ACPTPOST (now called ACPT28PA). During
 ; testing, numerous data integrity problems were found in the CPT file,
 ; so this subroutine was split off into its own new routine and expanded 
 ; to include cleanup of the existing HCPCS data. Problems were mainly
 ; found in the Effective Date subfile, which contained duplicate entries 
 ; and sometimes an erroneous -1 node. The subfile also contained traces
 ; of entries that were deleted though they should not have been; the B
 ; index is used to recreate these lost entries, and the subfile as a
 ; whole is renumbered and reindexed.
 ;
 ; The original loop from ACPTPOST was the work of IHS/ASDST/DMJ and
 ; Shonda Render (SDR).
 ;
 ;
PREPCODE ; step 3 of post-init: prep site's existing HCPCS codes
 ;
 ; private: called only by step 3 of routine ACPT28PA
 ;
 ; input: ACPTYR = 3080000, to use as the flag value for the Date Deleted
 ; field.
 ;
 ; 3.1. traverse site's existing HCPCS codes in the CPT file
 ;
 N ACPTCNT
 N ACPTIEN S ACPTIEN=99999 ; IENs of HCPCS entries, start just before
 N ACPTTO S ACPTTO=999999 ; last IEN in HCPCS range
 F ACPTCNT=1:1 S ACPTIEN=$O(^ICPT(ACPTIEN)) Q:ACPTIEN>ACPTTO!'ACPTIEN  D
 . ;
 . ; 3.2. set Date Deleted field to flag value
 . ;
 . I '$P($G(^ICPT(ACPTIEN,0)),U,7) D  ; if it hasn't already been deleted
 . . S $P(^ICPT(ACPTIEN,0),U,7)=ACPTYR ; set its Date Deleted field (8)
 . ;
 . ; 3.3. clean up Effective Date subfile
 . ;
 . D CLEANUP(ACPTIEN)
 . I '(ACPTCNT#100) U IO(0) W "." ; print a dot every 100 records
 ;
 ;
 QUIT  ; end of PREPCODE
 ;
 ;
CLEANUP(ACPTIEN) ; clean up Effective Date subfile for a CPT entry
 ;
 ; private, called only by PREPCODE above
 ;
 ; this subroutine has been separated from PREPCODE to make
 ; testing easier.
 ;
 ; a. build local subfile, dinummed by date, out of subentries
 ;
 N ACPTDATE ; local subfile
 N ACPTEDI S ACPTEDI=0 ; Effective Date IEN
 F  S ACPTEDI=$O(^ICPT(ACPTIEN,60,ACPTEDI)) Q:'ACPTEDI  D
 . N ACPTNODE S ACPTNODE=$G(^ICPT(ACPTIEN,60,ACPTEDI,0)) Q:ACPTNODE=""
 . N ACPTED S ACPTED=$P(ACPTNODE,U) Q:'ACPTED  ; skip nonnumerics
 . D  ; handle insertions into the list
 . . I '$D(ACPTDATE(ACPTED)) D  Q  ; if new to the local list, add it
 . . . S ACPTDATE(ACPTED)=ACPTNODE ; later entries overwrite earlier
 . . N ACPTSTAT S ACPTSTAT=$P(ACPTNODE,U,2) ; Status field (.02)
 . . I ACPTSTAT'="" D  Q  ; if it has a status
 . . . S $P(ACPTDATE(ACPTED),U,2)=ACPTSTAT ; it overrides the older entry
 . K ^ICPT(ACPTIEN,60,"B",ACPTED) ; remove found dates
 ;
 ; b. extend local subfile with lost entries in B index
 ;
 N ACPTS1 S ACPTS1="" ; 1st subscript of B index entries
 F  S ACPTS1=$O(^ICPT(ACPTIEN,60,"B",ACPTS1)) Q:ACPTS1=""  D
 . Q:'ACPTS1  ; skip nonnumeric entries
 . Q:$D(ACPTDATE(ACPTS1))  ; skip if already found (just in case)
 . S ACPTDATE(ACPTS1)=ACPTS1 ; create stub entries for lost entries
 ;
 ; c. replace global subfile with local subfile
 ;
 K ^ICPT(ACPTIEN,60) ; first clear out old subfile (incl -1 nodes)
 ;
 ; then copy local subfile to global subfile
 N ACPTEMP S ACPTEMP=0 ; temporary IENs in local subfile
 N ACPTNEW ; new IEN for each subentry
 F ACPTNEW=1:1 S ACPTEMP=$O(ACPTDATE(ACPTEMP)) Q:'ACPTEMP  D
 . S ^ICPT(ACPTIEN,60,ACPTNEW,0)=ACPTDATE(ACPTEMP) ; move entry
 . S ^ICPT(ACPTIEN,60,"B",ACPTEMP,ACPTNEW)="" ; create B index entry
 S ACPTNEW=ACPTNEW-1 ; reduce to actual number of subentries
 ;
 ; last, reset the subheader
 S ^ICPT(ACPTIEN,60,0)="^81.02DA^"_ACPTNEW_U_ACPTNEW
 ;
 QUIT  ; end of CLEANUP
 ;
 ;
 ; end of routine ACPT28PB
