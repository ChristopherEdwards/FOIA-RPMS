ABSPECA1 ; IHS/FCS/DRS - Assemble formatted claim ;   [ 09/23/2002  2:36 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,7,23,42**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;Assemble ASCII formatted claim submission record
 ;
 ;Input Variables:   CLAIMIEN - pointer into 9002313.02
 ;     The claim must be complete and well-constructed;
 ;     we do some paranoical checks below.
 ;
 ;     $$ Returns:   - Formatted NCPDP ASCII record
 ;----------------------------------------------------------------------
 ;
 ;IHS/SD/lwj 8/1/02  NCPDP 5.1 changes
 ; These is major differences in 3.2 vs 5.1 in the actual creation
 ; of the claim.  Of significance:
 ;     3.2 had 4 claim segments (hdr req, hdr opt, det req, det opt)
 ;     5.1 has 14 claim segments (header, patient, insurance, claim
 ;                                pharmacy provider, prescriber,
 ;                                COB, workers comp, DUR, Pricing,
 ;                                coupon, compound, prior auth,
 ;                                clinical)
 ;
 ;    3.2 required only field identifiers and separtors on optional
 ;        fields
 ;    5.1 requires field identifiers and separators on all fields
 ;        other than the header
 ;
 ;    3.2 there were no segment separators 
 ;    5.1 segment separators are required prior to each segment 
 ;        following the header
 ;
 ;    3.2/5.1  Group seperators appear at the end of each
 ;        transaction (prescription)
 ;
 ;  The first thing added to this routine is the retrieval of the
 ;  version from the claim file.  If the version is 3.2, we will 
 ;  process just like we used to.  If it is 5.1, we will alter the
 ;  creation of the claim to include the above differences.
 ;
 ;  Adjustments were also made to the reversal logic as well.
 ;------------------------------------------------------------
 ;IHS/SD/lwj 9/4/03 Patch 7 POS V1.0
 ; The payors do not want the Prior Authorization segment
 ; sent when there isn't a prior auth.  This is different than
 ; our normal processing, which allows us to send the segment
 ; blank.  To accomodate for this payor limitation, new logic
 ; was added to only process the prior authorization when
 ; information has been input into the PA fields.
 ;-----------------------------------------------------------
 ;IHS/SD/RLT - 06/26/07 - 10/18/07 - Patch 23
 ; New tag DIAGVAL for Diagnosis Code.
 ;
ASCII(CLAIMIEN) ;EP - from ABSPOSQH from ABSPOSQG from ABSPOSQ2
 N IEN,MABSP,RECORD,ABSP,REVERSAL,UERETVAL,CLMV,DET51,RTRNCD
 N PAFLAG            ;IHS/SD/lwj 09/04/03 prior values?
 I '$D(^ABSPC(CLAIMIEN,0)) D  G QERR  ; check for good parameter
 . S UERETVAL=$$IMPOSS^ABSPOSUE("DB,P","T",CLAIMIEN,,1,$T(+0))
 ;
 ;Setup IEN variables (used when executing format code)
 S IEN(9002313.02)=CLAIMIEN
 ; Point to ABSP INSURER
 S IEN(9002313.4)=$P($G(^ABSPC(IEN(9002313.02),0)),U,2)
 I 'IEN(9002313.4) D  G QERR ; claim must have an insurer
 . S UERETVAL=$$IMPOSS^ABSPOSUE("DB,P","T",CLAIMIEN,,2,$T(+0))
 ; Point to format
 S IEN(9002313.92)=$P($G(^ABSPEI(IEN(9002313.4),100)),U,1)
 I ('IEN(9002313.92))&&($G(^ABSP(9002313.99,1,"ABSPICNV"))'=1) D  G QERR ; insurer must have an e-format UNLESS conversion has been run
 . S UERETVAL=$$IMPOSS^ABSPOSUE("DB","T",CLAIMIEN,,3,$T(+0))
 ;
 ;
 ; But if it's a reversal claim, get the format for the reversal
 ; IHS/SD/lwj 08/15/02 NCPDP 5.1 needed to adjust reversal a little
 ; RTRNCD added - original IF stmt remarked out - new one added
 ; 5.1 transaction code for reversal is now B2 not 11
 ;
 S RTRNCD=$P(^ABSPC(IEN(9002313.02),100),U,3)
 ;I $P(^ABSPC(IEN(9002313.02),100),U,3)="11" D
 I (RTRNCD=11)!(RTRNCD="B2") D
 . S REVERSAL=1
 . S:$G(IEN(9002313.92)) IEN(9002313.92)=$P($G(^ABSPF(9002313.92,IEN(9002313.92),"REVERSAL")),U)
 . I ('IEN(9002313.92))&&($G(^ABSP(9002313.99,1,"ABSPICNV"))'=1) D  G QERR ; format must point to a reversal format
 . . S UERETVAL=$$IMPOSS^ABSPOSUE("DB","T",CLAIMIEN,,4,$T(+0))
 E  S REVERSAL=0
 ;
 I ($G(^ABSP(9002313.99,1,"ABSPICNV"))'=1)&&('$D(^ABSPF(9002313.92,IEN(9002313.92),0))) D  G QERR
 . S UERETVAL=$$IMPOSS^ABSPOSUE("P","T",CLAIMIEN,,5,$T(+0))
 ;
 ;IHS/SD/lwj 8/1/02
 ; retrieve the version number from the claim file so we know which
 ; way we have to process
 S CLMV=$P($G(^ABSPC(IEN(9002313.02),100)),U,2)
 ;
 ;Retrieve claim submission record (used when executing format code)
 D GETABSP2^ABSPECX0(IEN(9002313.02),.ABSP)
 ;W $T(+0)," we have:",! ZW ABSP R ">>>",%,!
 ;
 ;If reversal find current version number from Insurance file, if different then modify
 I REVERSAL S INSVER=$P($G(^ABSPEI(IEN(9002313.4),100)),U,15),INSVER=$S(INSVER=2:"D0",1:"51") I INSVER'=CLMV D
 .S CLMV=INSVER I $G(ABSP(9002313.02,CLAIMIEN,102,"I"))'="" S ABSP(9002313.02,CLAIMIEN,102,"I")=CLMV
 .S $P(^ABSPC(IEN(9002313.02),100),U,2)=CLMV
 ;
 ;Assember claim header required and optional format sections
 S RECORD=""
 ;IHS/OIT/CASSEVERN/RAN - 2/9/2011 - Patch 42 New code for D.0 START
 ;BREAK
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . I CLMV["D"  D
 . . I REVERSAL D
 . . . D EN^ABSPDB2("OUTHD",CLAIMIEN,.IEN)
 . . ELSE  D EN^ABSPDB1("OUTHD",CLAIMIEN,.IEN)
 . I CLMV["5"  D
 . . I REVERSAL D
 . . . D EN^ABSP5B2("OUTHD",CLAIMIEN,.IEN)
 . . ELSE  D EN^ABSP5B1("OUTHD",CLAIMIEN,.IEN)
 ;IHS/OIT/CASSEVERN/RAN - 2/9/2011 - Patch 42 New code for D.0 STOP
 ELSE  D
 . ;IHS/SD/lwj 8/1/02 nxt line remvd, following 2 lines added for 5.1 chgs
 . ;D XLOOP^ABSPECA2("10^20",.IEN,.ABSP,.RECORD)
 . D:CLMV[3 XLOOP^ABSPECA2("10^20",.IEN,.ABSP,.RECORD)   ;3.2 clms
 . D:CLMV[5 XLOOP^ABSPOSH2("100^110^120",.IEN,.ABSP,.RECORD)   ;5.1 clms
 ;IHS/SD/lwj 8/1/02  NCPDP 5.1 create chain of segments
 S DET51="130^140^150^160^170^180^190^200^210^220^230"
 ;
 ;Loop through prescription multiple
 S IEN(9002313.01)=0
 F  D  Q:'IEN(9002313.01)
 .S IEN(9002313.01)=$O(^ABSPC(IEN(9002313.02),400,IEN(9002313.01)))
 .Q:'IEN(9002313.01)
 .;
 .;Retrieve prescription information (used when executing format code)
 .K ABSP(9002313.0201)
 .D GETABSP3^ABSPECX0(IEN(9002313.02),IEN(9002313.01),.ABSP)
 .;
 .;IHS/SD/lwj 8/22/02 NCPDP 5.1 handle at least the DUR repeating flds
 .D DURVALUE
 .;
 .D DIAGVAL       ;Patch 23
 .; 
 .;IHS/SD/lwj 9/4/03 Patch 7 V1.0 check for prior auth value if 5.1
 .; if none, don't process prior auth segment (220)
 .I CLMV[5 D
 .. S PAFLAG=$$PAVALUE  ;if no PA, don't process segment
 .. S:'PAFLAG DET51="130^140^150^160^170^180^190^200^210^230"
 .;
 .;W $T(+0)," we have:",! ZW ABSP R ">>>",%,!
 .;
 .;Append group seperator character (but not in a reversal format)
 . I 'REVERSAL S RECORD=RECORD_$C(29)
 .;IHS/SD/lwj 08/15/02 NCPDP 5.1 - requires GS on reversal
 . I (REVERSAL)&(CLMV[5) S RECORD=RECORD_$C(29)
 . ;IHS/OIT/CASSEVERN/RAN - 2/9/2011 - Patch 42 New code for D.0 START
 . ;BREAK
 . I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . . I CLMV["D" D
 . . . I REVERSAL D
 . . . . D EN^ABSPDB2("OUTRST",CLAIMIEN,.IEN)
 . . . ELSE  D EN^ABSPDB1("OUTRST",CLAIMIEN,.IEN)
 . . I CLMV["5" D
 . . . I REVERSAL D
 . . . . D EN^ABSP5B2("OUTRST",CLAIMIEN,.IEN)
 . . . ELSE  D EN^ABSP5B1("OUTRST",CLAIMIEN,.IEN)
 .;IHS/OIT/CASSEVERN/RAN - 2/9/2011 - Patch 42 New code for D.0 STOP
 .;Assemble claim information required and optional sections
 .;IHS/SD/lwj 8/1/02 nxt ln rmkd out - following 2 lines added
 .;D XLOOP^ABSPECA2("30^40",.IEN,.ABSP,.RECORD)
 . ELSE  D
 . . D:CLMV[3 XLOOP^ABSPECA2("30^40",.IEN,.ABSP,.RECORD)
 . . D:CLMV[5 XLOOP^ABSPOSH2(DET51,.IEN,.ABSP,.RECORD)
 Q RECORD
QERR Q:$Q "" Q
 Q
DURVALUE ;NCPDP 5.1 - this subroutine will loop through the DUR/PPS repeating
 ; fields and load their values into the ABSP array for the claim
 ; generation process
 ;
 N DURCNT,DUR
 ;
 K ABSP(9002313.1001)
 ;
 ;we depend on the "count" since we set it when we created the clm entry
 S DURCNT=$P($G(^ABSPC(IEN(9002313.02),400,IEN(9002313.01),473.01,0)),U,4)
 F DUR=1:1:DURCNT  D
 . D GETABSP4^ABSPECX0(IEN(9002313.02),IEN(9002313.01),DUR,.ABSP)
 ;
 Q
 ;
PAVALUE() ;NCPDP 5.1 - IHS/SD/lwj 9/4/03 Payors do not want the Prior Auth
 ; segment if there is no data on it (contrary to other segments)
 ; This routine will check to see if there is information for processing.
 ;
 N ENT,PAFLAG,CLMIEN,CRXIEN,PAFLD
 S CLMIEN=IEN(9002313.02)
 S CRXIEN=IEN(9002313.01)
 S PAFLAG=0
 ;
 F ENT=498.01:.01:498.14  K ABSP("9002313.0201",CRXIEN,ENT)
 ;
 D GETABSP5^ABSPECX0(CLMIEN,CRXIEN,.ABSP)
 ;
 F ENT=498.01:.01:498.14  D
 . S PAFLD=$G(ABSP("9002313.0201",CRXIEN,ENT,"I"))
 . S:$L(PAFLD)>2 PAFLD=$TR($E(PAFLD,3,$L(PAFLD))," 0")
 . S:PAFLD'="" PAFLAG=1
 ;
 Q PAFLAG
 ;
DIAGVAL ;NCPDP 5.1 - loops through the diagnosis code repeating
 ; fields and loads their values into the ABSP array for the claim
 ; generation process
 ;
 N DIAGCNT,DIAG
 ;
 K ABSP(9002313.0701)
 ;
 S DIAGCNT=$P($G(^ABSPC(IEN(9002313.02),400,IEN(9002313.01),490)),U)
 Q:+$TR(DIAGCNT,"VE","")=0
 S ABSP(9002313.0701,0,491,"I")=DIAGCNT             ; set non-repeating field 491
 F DIAG=1:1:$TR(DIAGCNT,"VE")  D
 . D GETABSP6^ABSPECX0(IEN(9002313.02),IEN(9002313.01),DIAG,.ABSP)
 ;
 Q
