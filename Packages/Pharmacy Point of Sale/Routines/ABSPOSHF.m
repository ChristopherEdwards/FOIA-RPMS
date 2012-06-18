ABSPOSHF ;IHS/SD/lwj- Get/Format/Set value for DUR/PPS segment [ 09/04/2002  2:09 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,23**;JUNE 21,2001
 ;
 ; This routine is an addemdum to ABSPOSCF.  Its purpose is to handle
 ; some of the repeating fields that now exist in NCPDP 5.1.  
 ; The logic was put in here rather than ABSPOSCF to keep the original
 ; routine (ABSPOSCF) from growing too large and too cumbersome to
 ; maintain.
 ;
 ; At this point, the only repeating fields we handle in this routine
 ; are those contained in the DUR/PPS segment.
 ;
 ;IHS/SD/RLT - 06/27/07 - 10/18/07 - Patch 23
 ; DIAGNOSIS CODE in CLINICAL Segment.
 ;
DURPPS(FORMAT,NODE,MEDN)     ;EP called from ABSPOSCF  
 ;---------------------------------------------------------------
 ;NCPDP 5.1 changes   
 ; Processing of the 5.1 DUR/PPS segment is much different than the
 ; conventional segments of 3.2, simply because all of its fields
 ; are optional, and repeating.  The repeating portion of this 
 ; causes us to have yet another index we have to account for, and
 ; we must be able to tell which of the fields really needs to be
 ; populated.  The population of this segment is based on those
 ; values found for the prescription or refill in the ABSP DUR/PPS
 ; file.  The file's values are temporarily stored in the
 ; ABSP("RX",MEDN,DUR....) array for easy access and reference.
 ; (Special note - Overrides are not allowed on this multiple since
 ; they can simply update the DUR/PPS filed directly. For the same
 ; reason, "special" code is not accounted for either.
 ;---------------------------------------------------------------
 ;
 ; first order of business - check the ABSP("RX",MEDN,"DUR") array
 ; for values - if there aren't any, we don't need to write this
 ; segment
 ;
 N FIELD,ABSP51,RECCNT,DUR,FLD,OVERRIDE,FLAG,ORD,FLDIEN,FLDNUM
 S FLAG="FS"
 ;
 Q:'$D(ABSP("RX",MEDN,"DUR"))
 ;
 ;next we need to figure out which fields on this format are really
 ; needed, then we will loop through and populate them
 ;
 D GETFLDS(FORMAT,NODE,.FIELD)
 ;
 ; now lets get, format and set the field
 S ABSP51=1 ;needed in the set logic for dual 3.2/5.1 fields
 S (RECCNT,DUR)=0
 F  S DUR=$O(ABSP("RX",MEDN,"DUR",DUR)) Q:DUR=""  D
 . S RECCNT=RECCNT+1
 . S ORD=""
 . F  S ORD=$O(FIELD(ORD)) Q:ORD=""  D
 .. S FLDNUM=$P(FIELD(ORD),U,2)
 .. S FLDIEN=$P(FIELD(ORD),U)
 .. S ABSP("X")=$G(ABSP("RX",MEDN,"DUR",DUR,FLDNUM)) ;get
 .. D XFLDCODE^ABSPOSCF(FLDIEN,FLAG)  ;format/set
 ;
 ; this sets the record count and last record on the subfile
 S ^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),473.01,0)="^9002313.1001A^"_RECCNT_"^"_RECCNT
 ;
 Q
 ;
DIAG(FORMAT,NODE,MEDN)     ;EP called from ABSPOSCF  
 ;DIAGNOSIS CODE in the CLINICAL Segment
 ;
 Q:'$D(ABSP("RX",MEDN,"DIAG"))   ;quit if no data
 ;
 N FIELD,RECCNT,DIAG,FLD,OVERRIDE,FLAG,ORD,FLDIEN,FLDNUM
 S FLAG="FS"
 ;
 ; get list of fields
 D GETFLDS(FORMAT,NODE,.FIELD)
 ;
 ; set field 491 which is not repeating
 S ORD=0
 S FLDNUM=$P(FIELD(ORD),U,2)
 S FLDIEN=$P(FIELD(ORD),U)
 S ABSP("X")=$G(ABSP("RX",MEDN,"DIAG",ORD,FLDNUM)) ;get
 D XFLDCODE^ABSPOSCF(FLDIEN,FLAG)  ;format/set
 ;
 ; get, format and set the field
 S (RECCNT,DIAG)=0
 F  S DIAG=$O(ABSP("RX",MEDN,"DIAG",DIAG)) Q:'+DIAG  D
 . S RECCNT=RECCNT+1
 . S ORD=0
 . F  S ORD=$O(FIELD(ORD)) Q:'+ORD  D
 .. S FLDNUM=$P(FIELD(ORD),U,2)
 .. S FLDIEN=$P(FIELD(ORD),U)
 .. S ABSP("X")=$G(ABSP("RX",MEDN,"DIAG",DIAG,FLDNUM)) ;get
 .. D XFLDCODE^ABSPOSCF(FLDIEN,FLAG)  ;format/set
 ;
 ; set rec count and last rec on the subfile
 S ^ABSPC(ABSP(9002313.02),400,ABSP(9002313.0201),491.01,0)="^9002313.0701A^"_RECCNT_"^"_RECCNT
 ;
 Q
 ;
GETFLDS(FORMAT,NODE,FIELD) ;EP NCPDP 5.1 
 ;---------------------------------------------------------------
 ;This routine will get the list of repeating fields that must be
 ; be worked with separately
 ; (This was originally coded for the DUR/PPS segment - I'm not
 ; 100% sure how and if it will work for the other repeating
 ; fields that exist within a segment.)
 ;---------------------------------------------------------------
 ; Coming in:
 ;   FORMAT = ABSPF(9002313.92 's format IEN
 ;   NODE   = which segment we are processing (i.e. 180 - DUR/PPS)
 ;  .FIELD  = array to store the values in
 ;
 ; Exitting:
 ;  .FIELD array will look like:
 ;     FIELD(ord)=int^ext
 ;  Where:   ext = external field number from ABSPF(9002313.91
 ;           int = internal field number from ABSPF(9002313.91
 ;           ord = the order of the field - used in creating clm
 ;---------------------------------------------------------------
 ;
 N ORDER,RECMIEN,MDATA,FLDIEN,FLDNUM,DUR
 ;
 S ORDER=0
 ;
 F  D  Q:'ORDER
 . ;
 . ; let's order through the format file for this node
 . ;
 . S ORDER=$O(^ABSPF(9002313.92,FORMAT,NODE,"B",ORDER)) Q:'ORDER
 . S RECMIEN=$O(^ABSPF(9002313.92,FORMAT,NODE,"B",ORDER,0))
 . I 'RECMIEN D IMPOSS^ABSPOSUE("DB","TI","NODE="_NODE,"ORDER="_ORDER,2,$T(+0))
 . S MDATA=^ABSPF(9002313.92,FORMAT,NODE,RECMIEN,0)
 . S FLDIEN=$P(MDATA,U,2)
 . I 'FLDIEN D IMPOSS^ABSPOSUE("DB","TI","NODE="_NODE,"RECMIEN="_RECMIEN,3,$T(+0)) ; corrupt or erroneous format file
 . I '$D(^ABSPF(9002313.91,FLDIEN,0)) D IMPOSS^ABSPOSUE("DB,P","TI","FLDIEN="_FLDIEN,,"DURPPS",$T(+0))  ;incomplete field definition
 . ;
 . ;lets create a list of fields we need
 . S FLDNUM=$P($G(^ABSPF(9002313.91,FLDIEN,0)),U)
 . S:FLDNUM=491 FIELD(0)=FLDIEN_"^"_FLDNUM
 . S:FLDNUM'=111&(FLDNUM'=491) FIELD(ORDER)=FLDIEN_"^"_FLDNUM
 Q
