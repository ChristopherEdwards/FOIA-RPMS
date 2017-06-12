ABSPOSH4 ; IHS/FCS/DRS - Parse Claim 5.1,D.0 Response ;    [ 09/04/2002  12:56 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,14,36,42,46**;JUN 21, 2001;Build 15
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Parse ASCII Response Claim Record and Sup FDATA() Array
 ;
 ;Parameters:  RREC     - Ascii Response Record
 ;             RESPIEN  - Claim Response IEN (90023130.3)
 ;----------------------------------------------------------------------
 ; Calls ABSPOSH5
 ;
 ;----------------------------------------------------------------------
 ; IHS/SD/lwj  8/6/02  NCPDP 5.1 changes
 ;  NCPDP 5.1 response segments are completely different than the
 ;  3.2 response.  Of significant importance are:
 ;   In 3.2, there were 4 basic repsonse segments (header required,
 ;     header option, information required, information optional.) 
 ;   In 5.1, there are 8 possible segments (header, message, insurance,
 ;     status, claim, pricing, DUR/PPS, and prior authorization)
 ;
 ;   In 5.1, for all segments following the header, a segment separator
 ;     is used.
 ;
 ;   In 5.1, field separators, and field identifiers are used for all
 ;     fields not appearing on the header segment.
 ;
 ; This routine will be solely responsible for parsing the data
 ; for 5.1 claims.  It is called by ABSPECA4.
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 10/27/05 patch 14 - new subroutine added to parse out the
 ; E1 response
 ;
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 10/27/05 patch 14 - new subroutine for E1 parsing
PARSEE1(RREC,E1IEN) ;EP - from ABSPECA4
 N GS,FS,SS
 ;
 ;Make sure input varaibles are defined
 Q:$G(RREC)=""
 Q:$G(E1IEN)=""
 Q:'$D(^ABSPE(E1IEN,0))
 ;
 ;group and field separator characters
 S GS=$C(29),FS=$C(28),SS=$C(30)
 ;
 D TRANSMSN            ;process the transmission level data
 D TRANSACT            ;process the transaction level data
 ;
 Q
 ;
PARSE51(RREC,RESPIEN) ;EP - from ABSPECA4
 N GS,FS,SS
 ;
 ;Make sure input varaibles are defined
 Q:$G(RREC)=""
 Q:$G(RESPIEN)=""
 Q:'$D(^ABSPR(RESPIEN,0))
 ;
 ;group and field separator characters
 S GS=$C(29),FS=$C(28),SS=$C(30)
 ;
 D TRANSMSN            ;process the transmission level data
 D TRANSACT            ;process the transaction level data
 D FILE^ABSPOSH5(RESPIEN)   ;add information to the response file
 ;
 Q
 ;
 ;
TRANSMSN ;This subroutine will work through the transmission level information
 ;
 N RTRANM,RHEADER,SEG,SEGMENT,SEGID
 ;
 ;Parse response transmission level from ascii record
 S RTRANM=$P(RREC,GS,1)
 ;
 ; get just the header segment 
 S RHEADER=$P(RTRANM,SS,1)    ;header- required/fixed length
 D PARSEH
 ;
 ; There are 2 optional segments on the trasmission level - message
 ; and insurance.  We'll check for both and parse what we find.
 ;
 ; OIT/CAS/RCS 092013 Patch 46 More that two segments are allowed
 F SEG=2:1 S SEGMENT=$P(RTRANM,SS,SEG) Q:SEGMENT=""  D
 . S SEGID=$P(SEGMENT,FS,2)
 . I $E(SEGID,1,2)="AM" D                ;segment identification
 . D:($E(SEGID,3,4)=20)!($E(SEGID,3,4)=25) PARSETM
 . I ($E(SEGID,3,4)=27)!($E(SEGID,3,4)=29) S MEDN=1 D PARSETN ;D.0 Record
 ;
 Q
 ;
TRANSACT ;This subroutine will work through the transaction level information
 ;
 N RTRAN,SEG,SEGMENT,MEDN
 S MEDN=0
 ;
 F GRP=2:1 D  Q:RTRAN=""
 . S RTRAN=$P(RREC,GS,GRP)     ;get the next transaction (could be 4)
 . Q:RTRAN=""                  ;we're done if it's empty
 . S MEDN=MEDN+1               ;transaction counter
 . ;
 . F SEG=2:1 D  Q:SEGMENT=""   ;break the record down by segments
 .. S SEGMENT=$P(RTRAN,SS,SEG) ;get the segment
 .. Q:SEGMENT=""
 .. D PARSETN                  ;get the fields
 ;
 ;
 Q
 ;
 ;
PARSEH ; The header record is required on all responses, and is fixed 
 ; length.  It is the only record that is fixed length.
 ;
 S FDATA(102)=$E(RHEADER,1,2)    ;version/release number
 S FDATA(103)=$E(RHEADER,3,4)    ;transaction code
 S FDATA(109)=$E(RHEADER,5,5)    ;transaction count
 S FDATA(501)=$E(RHEADER,6,6)    ;header response status
 S FDATA(202)=$E(RHEADER,7,8)    ;service provider id qualifier
 S FDATA(201)=$E(RHEADER,9,23)   ;service provider id
 S FDATA(401)=$E(RHEADER,24,31)  ;date of service
 ;
 Q
 ;
PARSETM ; This subroutine will parse the variable portions of the transmission 
 ; level message.  Keep in mind that most fields are optional
 ; so we have no idea what is coming back.  We will parse based 
 ; on the field separators, and field identification.
 ; (tranmission level variable records are the message (ID=20) 
 ;  and insurance (ID=25) segments)
 ;
 N FIELD,PC,FLDNUM
 ;
 F PC=3:1 D  Q:FIELD=""        ;skip the seg id -already know its value 
 . S FIELD=$P(SEGMENT,FS,PC)   ;piece through the record
 . Q:FIELD=""                  ;stop - we hit the end
 . S FLDNUM=$$GETNUM(FIELD)    ;get the field number used for storage
 . Q:FLDNUM=""                 ;shouldn't happen - but lets skip
 . S FDATA(FLDNUM)=$E(FIELD,3,$L(FIELD))  ;hold the value
 ;
 Q
 ; 
PARSETN ; This subroutine will parse the transaction level segments. For 
 ; most transactions, the only segment required in this area of 
 ; the response is the status segment.  However, since we aren't
 ; sure what we will be getting back, we will process whatever
 ; is sent our way.
 ;
 ; Please note that most fields are optional, so we will parse the
 ; record based on field separators and the value of the field
 ; identification.  
 ; Also please note that several of the segments have repeating
 ; fields - we will determine which fields are repeating, based
 ; on the segment identification.
 ;
 ; Possible values of the SEGFID field:
 ;  21 = Response Status Segment
 ;  22 = Response Claim Segment
 ;  23 = Response Pricing Segment
 ;  24 = Response DUR/PPS Segment
 ;  26 = Repsonse Prior Authorization Segment
 ;  28 = Other Payer Segment
 ;
 N FIELD,PC,FLDNUM,RPTFLD,RCNT,REPEAT,OCNT
 ;
 S RPTFLD=""
 S SEGID=$P(SEGMENT,FS,2)           ;this should be the segment id
 Q:SEGID=""                         ;don't process without a Seg id
 Q:$E(SEGID,1,2)'="AM"              ;don't know what we have - skip
 ;
 S SEGFID=$E(SEGID,3,4)             ;this should be the field ID
 ;
 ; setup the repeating flds based on the segment
 I SEGFID=21 D               ;status segment
 . S RPTFLD=",548,511,546,526,"
 . S (RCNT(548),RCNT(511),RCNT(546),RCNT(526))=0
 ;
 I SEGFID=22 D                 ;claim segment
 . S RPTFLD=",552,553,554,555,556,"
 . S (RCNT(552),RCNT(553),RCNT(554),RCNT(555),RCNT(556))=0
 ;
 I SEGFID=23 D                ;pricing segment
 . S RPTFLD=",564,565,"
 . S (RCNT(564),RCNT(565))=0
 ;
 I SEGFID=24 D                ;DUR/PPS segment
 . S RPTFLD=",439,528,529,530,531,532,533,544,567,"
 . S (RCNT(439),RCNT(528),RCNT(529),RCNT(530),RCNT(531))=0
 . S (RCNT(532),RCNT(533),RCNT(544),RCNT(567))=0
 ;
 I SEGFID=28 D  Q                ;Other Payer segment
 . F PC=3:1 D  Q:FIELD=""        ;skip the seg id -jump to the other flds
 . . S FIELD=$P(SEGMENT,FS,PC)   ;piece through the record
 . . Q:FIELD=""                  ;stop - we hit the end
 . . S FLDNUM=$$GETNUM(FIELD)    ;get the field number used for storage
 . . Q:FLDNUM=""
 . . I FLDNUM=355 Q
 . . I FLDNUM=338 S OCNT=+$E(FIELD,3,$L(FIELD)) ;Other coverage type
 . . S FDATA("M",MEDN,FLDNUM,OCNT)=$E(FIELD,3,$L(FIELD))
 ;
 ; now lets parse out the fields
 ;
 F PC=3:1 D  Q:FIELD=""        ;skip the seg id -jump to the other flds
 . S FIELD=$P(SEGMENT,FS,PC)   ;piece through the record
 . Q:FIELD=""                  ;stop - we hit the end
 . S FLDNUM=$$GETNUM(FIELD)    ;get the field number used for storage
 . ;IHS/OIT/SCR 11/26/08 - next line avoids subscript error on last line of routine
 . ;EMERGENCY FIX distributed on 12/2/08 -added to patch 36 011910
 . Q:FLDNUM=""
 . I ",304,310,311,"[(","_FLDNUM_",") S FLDNUM=FLDNUM_".01" ;Save response data to different field
 . S REPEAT=0                  ;for this segment, lets figure
 . S CKRPT=","_FLDNUM_","      ;out if the field is a repeating
 . S:RPTFLD[CKRPT REPEAT=1     ;field
 . ;
 . I REPEAT D                  ;if rptg, store with a counter
 .. S RCNT(FLDNUM)=$G(RCNT(FLDNUM))+1
 .. S FDATA("M",MEDN,FLDNUM,RCNT(FLDNUM))=$E(FIELD,3,$L(FIELD))
 . ;
 . I 'REPEAT D                 ;not rptg, store without counter
 .. S FDATA("M",MEDN,FLDNUM)=$E(FIELD,3,$L(FIELD))
 ;
 ;
 Q
 ;
GETNUM(FIELD) ; This routine will translate the field ID into a field number.  
 ; We will use the ABSP NCPDP field Defs files, corss ref "D" to
 ; perform this translation.  (The field number is needed to store
 ; the data in the correct field within the response file.)
 ;
 N FLDID,FLDIEN,FLDNUM
 S (FLDID,FLDNUM)=""
 S FLDIEN=0
 ;
 S FLDID=$E(FIELD,1,2)       ;field identifier
 Q:FLDID=""
 ;
 I FLDID'="" D
 . S FLDIEN=$O(^ABSPF(9002313.91,"D",FLDID,FLDIEN))  ;internal fld #
 . S:FLDIEN FLDNUM=$P($G(^ABSPF(9002313.91,FLDIEN,0)),U) ;fld number
 ;
 ;
 Q FLDNUM
 ;
