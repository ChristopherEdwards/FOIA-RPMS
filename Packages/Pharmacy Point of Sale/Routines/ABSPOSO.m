ABSPOSO ; IHS/FCS/DRS - "O" is for Override NCPDP field values ;  [ 08/20/2002  8:46 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,6,23**;JUN 21, 2001
 ; 
 ; File 9002313.511 ABSP NCPDP OVERRIDE
 ; It acts like an extension of the ^PSRX entry,
 ; though it's not tied to ^PSRX in any structural way.
 ; ^PSRX has a pointer to this file.
 ;
 ; IHS/SD/lwj 8/20/02 NCPDP 5.1 changes
 ; In 5.1 there is now some repeating fields/records.  The DUR/PPS
 ; segment is a repeating segment (i.e. all the fields in this
 ; segment repeat.)  Much like the values for the ABSP NCPDP 
 ; Overrides are stored in a separate file, and referenced in
 ; the prescription file, the DUR/PPS values will be stored in
 ; a separate file (ABSP DUR/PPS) and simply referenced in the 
 ; prescription file.  For this reason, I'm adding the retrieval
 ; of the prescription DUR/PPS pointer in this routine to keep
 ; things consistent. (Site must have Outpatient Pharmacy V6.0
 ; Patch 4 loaded for the DUR/PPS field to be found.)
 ;
 ;---
 ;IHS/SD/lwj 6/19/03 Patch 6 - DUR segment for NCPDP 5.1
 ; We need to allow the pharmacist to override the DUR
 ; values as they exist in the 5.1 segment. New subroutine
 ; created to allow for both the incoming IEN value for the
 ; regular overrides, and the DIEN for the DUR segment
 ; overrides.  (Subroutine will look much like OVERRIDE
 ; with the exception of the new parameters - new routine
 ; created to avoid conflict with existing code.)
 ;---
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ;  Added new tag GETDIAG.
 Q
 ;
OVERRIDE(IEN)  ; main entry point
 ; IEN points to file 9002313.511
 ; Sometimes we have IEN; sometimes we don't
 ; called from pharmacy package
 ; called from somewhere in POS, too
 I $D(IEN) D
 . I '$D(^ABSP(9002313.511,IEN)) D  ; it must have been winnowed
 . . S IEN=$$NEW^ABSPOSO2
 E  D
 . I '$D(IEN) S IEN=$$NEW^ABSPOSO2
 I 'IEN D IMPOSS^ABSPOSUE("FM,P","TI","Failed to create Overrides record / or bad parameter in call",,"OVERRIDE",$T(+0)) Q:$Q "" Q
 D MENU^ABSPOSO1(IEN)
 Q:$Q IEN Q
OVERRIDR(RXI,RXR)  ; alternative entry point - given RXI,RXR instead of IEN
 N IEN
 I $G(RXR) S IEN=$$GETIEN(RXI,RXR)
 E  S IEN=$$GETIEN(RXI)
 S IEN=$$OVERRIDE(IEN)
 Q:$Q IEN Q
GETIEN(RXI,RXR) ;EP -  also called from claim construction
 N IEN
 I $G(RXR) S IEN=$P($G(^PSRX(RXI,1,RXR,9999999)),U,12)
 E  S IEN=$P($G(^PSRX(RXI,9999999)),U,12)
 Q IEN
 ;
 ;
GETDUR(RXI,RXR) ;EP -  also called from claim construction
 ;IHS/SD/lwj 8/20/02  NCPDP 5.1 changes - retrieve DUR/PPS pointer 
 ; from the prescription file
 N IEN
 I $G(RXR) S IEN=$P($G(^PSRX(RXI,1,RXR,9999999)),U,13)
 E  S IEN=$P($G(^PSRX(RXI,9999999)),U,13)
 Q IEN
 ;
GETDIAG(RXI,RXR) ;EP -  called from ABSPOSII and ABSPOSQB
 ;Get DIAGNOSIS CODE POINTER from prescription file
 N IEN
 ;I $G(RXR) S IEN=$P($G(^PSRX(RXI,1,RXR,9999999)),U,17)
 ;E  S IEN=$P($G(^PSRX(RXI,9999999)),U,17)
 ;POINTERS REMOVED FROM PRESCRIPTION FILE
 S IEN=0
 S IEN=$O(^ABSP(9002313.491,"AC",RXI,IEN))
 Q IEN
 ;
NEWOVER(IEN,DURIEN)  ;EP   IHS/SD/lwj 6/19/03 patch 6
 ; This routine was copied from OVERRIDE.  It was
 ; adjusted to allow for entry of the usual overrides,
 ; plus the 5.1 DUR segment values.
 ;
 ; IEN points to file 9002313.511
 ; DURIEN points to file ^ABSP(9002313.473 DUR/PPS
 ; (We only have the EN when this is an edit to
 ; existing entries.)
 ;
 ;
 N DIEN,CIEN,RIEN
 S DIEN=$G(DURIEN)
 ;
 I $G(IEN) D
 . I '$D(^ABSP(9002313.511,IEN)) D  ; it must have been winnowed
 . . S IEN=$$NEW^ABSPOSO2
 ;
 S:'$G(IEN) IEN=$$NEW^ABSPOSO2
 I 'IEN D IMPOSS^ABSPOSUE("FM,P","TI","Failed to create Overrides record / or bad parameter in call",,"OVERRIDE",$T(+0)) Q:$Q "" Q
 ;
 ; Now create the DIEN - the difference between this and the IEN is that
 ; if they don't add anything in for the DIEN, we delete the whole record
 ;
 I $G(DIEN) D
 . I '$D(^ABSP(9002313.473,DIEN)) D  ;must be there
 . . S DIEN=$$NEW^ABSPOSD2
 ;
 S:'$G(DIEN) DIEN=$$NEW^ABSPOSD2
 ;
 I 'DIEN D IMPOSS^ABSPOSUE("FM,P","TI","Failed to create DUR rec",,"OVERRIDE",$T(+0)) Q:$Q "" Q
 ;
 ; call the menu for the user
 ;
 S RIEN=IEN
 S:$G(DIEN)'="" RIEN=RIEN_"^"_$G(DIEN)
 ;
 D MENU^ABSPOSO1(RIEN)
 ;
 ;Last step - we need to verify we have values - otherwise
 ; let's get rid of the DUR record so it's not cluttering
 ; up the place
 ;
 S DIEN=$$CHKDUR^ABSPOSD2(DIEN)
 ;
 S RIEN=IEN
 S:$G(DIEN)'="" RIEN=RIEN_"^"_$G(DIEN)
 ;
 Q:$Q RIEN Q
