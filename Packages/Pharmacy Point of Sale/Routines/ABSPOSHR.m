ABSPOSHR ; IHS/SD/lwj - 3.2 to 5.1 clm reversal format ; [ 10/24/2002  8:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;
 ;-------------------------------------------------------
 ; IHS/SD/lwj 10/22/02 NCPDP 5.1 changes
 ; We ran into a big snag - some processors are doing an all or nothing
 ; switch to 5.1 with no grace period for 3.2 and 5.1 claims.  What this
 ; means is that we have to be able to reverse a previously submitted
 ; 3.2 claim in 5.1 reversal format since they won't accept 3.2 any
 ; more.  The biggest problem with this is that 3.2 and 5.1 fields
 ; are formatted differently, and the reversal process was used to 
 ; simply copy the information from the original claim into the 
 ; reversal claim.  To get around this, this routine was created
 ; to try and reformat those fields that require the 5.1 format to
 ; reverse properly.
 ;
 ; This routine should only be called from within the ABSPECA8 - it
 ; is dependent on variables set there.
 ;
 ; Basic logic:
 ;  Read the format for the designated segment
 ;  Read through the fields on the segment (no xref - very few fields)
 ;  Determine if there are "special" values for the field
 ;  Format the field with the proper value
 ;  Set the TMP field to the formatted value 
 ;
 Q
 ;
REFORM(ABSPFORM)   ;EP  main driver of problem and entry point - everything   
 ; should call through to here
 ;
 N ABSP
 ;
 D REFRMH(ABSPFORM)
 D REFRMD(ABSPFORM)
 ;
 Q
REFRMH(ABSPFORM)   ;
 ; This routine will only attempt to reset the "header" fields that need
 ; adjusting for 5.1.  There are four fields in the header segment that
 ; need to be reformatted - we will leave the others since they may have
 ; gone through extensive formatting for the original claim and are fine
 ; the way they are.  These four fields were either new to the reversal
 ; in 5.1, or changed value/length in 5.1.  The fields are:
 ;     109  Transaction Count   (not on 3.2 reversal)
 ;     110  Software Vendor/Certificationd ID  (new field to 5.1)
 ;     201  Service Provider ID (changed length in 5.1)
 ;     202  Service Provider ID Qualifier (new to 5.1)
 ;
 ; Remember - the header is stagnate - that's the only reason we look
 ; specifically for those two fields.
 ;
 ; IEN and TMP are set in ABSPECA8
 ; 
 ; The header segment is small, and there isn't a xref by field #, so we
 ; will read the entire segment here.
 ;
 N FLDIEN,PMODE,ORDER,RECMIEN,FIELD
 ;
 S ORDER=0
 F  S ORDER=$O(^ABSPF(9002313.92,ABSPFORM,100,"B",ORDER)) Q:'ORDER  D
 . S RECMIEN=$O(^ABSPF(9002313.92,ABSPFORM,100,"B",ORDER,0))
 . Q:'RECMIEN
 . S FLDIEN=$P($G(^ABSPF(9002313.92,ABSPFORM,100,RECMIEN,0)),U,2)
 . S FIELD=$P($G(^ABSPF(9002313.91,FLDIEN,0)),U)
 . Q:(FIELD'=110)&(FIELD'=202)&(FIELD'=201)&(FIELD'=109)
 . ;
 . ; check to see if the format has a "special" value for this field
 . S PMODE=$P($G(^ABSPF(9002313.92,ABSPFORM,100,RECMIEN,0)),U,3)
 . I PMODE="X" D XSPCCODE^ABSPOSCF(ABSPFORM,100,RECMIEN)
 . I PMODE'="X" S ABSP("X")=TMP(9002313.02,IEN,FIELD,"I")
 . ;
 . D FORMAT
 . ;
 . S TMP(9002313.02,IEN,FIELD,"I")=ABSP("X")
 ;         
 ;
 Q
 ;
REFRMD(ABSPFORM)   ; 
 ; This routine is going to try and reformat the "detail" portion of the
 ; claim. For now, the only segment we are going to look at is 130 
 ; which is the claim segment.  If other reversal formats become 
 ; available, and they require other segments - this section will have
 ; to change.  Since the claim segment full of optional fields, we wil
 ; read through the format and take it a field at a time.
 ;
 ; IEN, RX, and TMP were set in ABSPECA8
 ;
 ;
 N FLDIEN,PMODE,ORDER,RECMIEN,NODE,IDIEN,DOFORM,FIELD
 S NODE=130
 ;
 S ORDER=0
 F  S ORDER=$O(^ABSPF(9002313.92,ABSPFORM,NODE,"B",ORDER)) Q:'ORDER  D
 . S RECMIEN=$O(^ABSPF(9002313.92,ABSPFORM,NODE,"B",ORDER,0))
 . Q:'RECMIEN
 . S FLDIEN=$P($G(^ABSPF(9002313.92,ABSPFORM,NODE,RECMIEN,0)),U,2)
 . S FIELD=$P($G(^ABSPF(9002313.91,FLDIEN,0)),U)
 . Q:FIELD=111    ;(SEGMENT IDENTIFIER - SKIP)
 . ;
 . ; check to see if the format has a "special" value for this field
 . S PMODE=$P($G(^ABSPF(9002313.92,ABSPFORM,NODE,RECMIEN,0)),U,3)
 . I PMODE="X" D XSPCCODE^ABSPOSCF(ABSPFORM,NODE,RECMIEN)
 . ;
 . ; if this isn't a special value field in 5.1, we need to make sure 
 . ; it wasn't an optional field in 3.2. If it was, the field ID is
 . ; already a part of the field, and we don't need to reformat it
 . ;
 . S DOFORM=1
 . I PMODE'="X" D
 .. S:$P($G(^ABSPF(9002313.91,FLDIEN,0)),U,2)'="" DOFORM=0
 .. S:DOFORM ABSP("X")=TMP(9002313.0201,RX,FIELD,"I")
 . ;
 . ; format it only if it needs it
 . ;
 . I DOFORM D
 .. D FORMAT
 .. S TMP(9002313.0201,RX,FIELD,"I")=ABSP("X")
 ;         
 ;
 Q
 ;
FORMAT ; This routine will format the field to 5.1 standards - remember it 
 ; will set ABSP("X") based on what is in the ABSP NCPDP Field Defs file
 ;
 N INDEX,MCODE,NODE
 S NODE=25            ;we only want the 5.1 format code
 ;
 S INDEX=0
  F  D  Q:'+INDEX
 . S INDEX=$O(^ABSPF(9002313.91,FLDIEN,NODE,INDEX))
 . Q:'+INDEX
 . S MCODE=$G(^ABSPF(9002313.91,FLDIEN,NODE,INDEX,0))
 . Q:MCODE=""
 . Q:$E(MCODE,1)=";"
 . X MCODE
 ;
 ;
 Q
