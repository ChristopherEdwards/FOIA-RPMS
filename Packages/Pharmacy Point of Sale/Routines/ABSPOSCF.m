ABSPOSCF ; IHS/FCS/DRS - Low-level format of .02 ;  [ 12/02/2002  2:54 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,23,39**;JUN 21, 2001
 ;
 ; This routine will read the formats file.  As it reads a field
 ; from the formats file, it will execute the needed get, format,
 ; and set code from the ABSP NCPDP Field Defs dictionary.  Please
 ; note that for 5.1, we will use the 5.1 format code from within
 ; the Field Defs dictionary.  Also please note that the Set code
 ; will "set" the value into the ABSP Claims file.
 ;
 ; Note: The only external entry point is XLOOP, below.
 ;   It is called only 
 ; from ABSPOSCE from ABSPOSCA from ABSPOSQG from ABSPOSQ2
 ;
 ; For 3.2 claims this routine is called four times with 
 ;  NODE=10, 20, 30, 40,
 ;  for Claim Header Required and then Claim Header Optional,
 ;  then Claim Data Required and Claim Data Optional, in that order
 ;
 ; FORMAT is a pointer to 9002313.92
 ; NODE = 10, 20, 30, 40 field in the format's record
 ; MEDN, pointer into ABSP("RX",*,...) appears only when NODE=30, 40
 ;
 ; IHS/SD/lwj  8/1/02  NCPDP 5.1 changes
 ; For 5.1 the call is made fourteen times, with NODES=100 thru 230
 ;  The one time segments are the 100, 110, and 120 segments,
 ;   all other segments could repeat depending on the number
 ;   of prescriptions on a claim.
 ;
 ; FORMAT is a pointer to 9002313.92
 ; NODE = 100  (5.1 Transaction Header Segment)
 ;        110  (5.1 Patient Segment)
 ;        120  (5.1 Insurance Segment)
 ;        130  (5.1 Claim Segment)
 ;        140  (5.1 Pharmacy Provider Segment)
 ;        150  (5.1 Prescriber Segment)
 ;        160  (5.1 COB/Other Payments Segment)
 ;        170  (5.1 Worker's Compensation Segment)
 ;        180  (5.1 DUR/PPS Segment)
 ;        190  (5.1 Pricing Segment)
 ;        200  (5.1 Coupon Segment)
 ;        210  (5.1 Compound Segment)
 ;        220  (5.1 Prior Authorization Segment)
 ;        230  (5.1 Clinical Segment)
 ; MEDN set to reflect the prescription for nodes 130 - 230
 ;
 ; For 5.1 there is only one significant change to this routine - 
 ; the values used in the NODE field in the XFLDCODE subroutine
 ; will be now based on the version of claim we are processing.
 ; For 3.2 claims, we will process the 10, 20, and 30 nodes from
 ; from the NCPDP Field defs dictionary.  
 ; For 5.1, we will process 10, 25 and 30.
 ;
 ; Another change - in 3.2 there would always be fields in the
 ; hdr req, hdr opt, det req, and det opt segments - that is no
 ; longer true with 5.1 - segments will not also have a fields to 
 ; print.
 ;
 ; MAJOR change - in 3.2 there were no repeating fields - in 5.1
 ; there are lots of them spread across 4 segments.  These fields
 ; offer us a special challenge as they must be stored in a multiple
 ; and that gives us yet one more index to keep track of.  
 ; At the onset of 5.1, IHS was not ready to use the repeating fields
 ; in the claim segment (procedures), the COB/Other payment segment
 ; (payer specific fields, payer amount, and pay reject information)
 ; and the Pricing Segment (other amount claimed submitted).
 ; Because of time, these repeating fields are not being addressed
 ; in V1.0 P3, but in order to pass PCS certification, we did
 ; have to address the repeating fields on the DUR/PPS Segment
 ; (the entire record is repeating). Chances are extremely slim
 ; that the fields in this repeating section are ones that IHS will
 ; need at first, so it's possible we may need to rework the logic 
 ; a little when they actually start to use the repeating fields.
 ;
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; DIAGNOSIS CODE in CLINICAL segment.
 ;
XLOOP(FORMAT,NODE,MEDN) ;EP
 N ORDER,RECMIEN,MDATA,FLDIEN,PMODE,FLAG
 ;
 ;IHS/SD/lwj 8/1/02 for 5.1, segments won't always be defined-just quit
 Q:(ABSP("NCPDP","Version")[5)&('$D(^ABSPF(9002313.92,FORMAT,NODE,0)))
 ;
 ;IHS/SD/lwj 8/20/01 for 5.1 segment 180 is the DUR/PPS segment
 ; this is a repeating field segment, and must be handled differently
 ; than the regular sections
 I NODE=180 D DURPPS^ABSPOSHF(FORMAT,NODE,MEDN) Q
 ;
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; DIAGNOSIS CODE in CLINICAL segment
 I NODE=230 D DIAG^ABSPOSHF(FORMAT,NODE,MEDN) Q
 ;
 I '$D(^ABSPF(9002313.92,FORMAT,NODE,0)) D IMPOSS^ABSPOSUE("DB,P","TI","FORMAT="_FORMAT,"NODE="_NODE,1,$T(+0))
 ;
 S ORDER=0
 F  D  Q:'ORDER
 .S ORDER=$O(^ABSPF(9002313.92,FORMAT,NODE,"B",ORDER)) Q:'ORDER
 .S RECMIEN=$O(^ABSPF(9002313.92,FORMAT,NODE,"B",ORDER,0))
 .I 'RECMIEN D IMPOSS^ABSPOSUE("DB","TI","NODE="_NODE,"ORDER="_ORDER,2,$T(+0))
 .S MDATA=^ABSPF(9002313.92,FORMAT,NODE,RECMIEN,0)
 .S FLDIEN=$P(MDATA,U,2)
 .I 'FLDIEN D IMPOSS^ABSPOSUE("DB","TI","NODE="_NODE,"RECMIEN="_RECMIEN,3,$T(+0)) ; corrupt or erroneous format file
 .S PMODE=$P(MDATA,U,3)
 .I PMODE="" S PMODE="S" ;default it
 .;/IHS/OIT/CNI/RAN 06042010 Patch 39 Changes at Emdeon mean we can now use special code for field 104 BEGIN commenting out
 .;I PMODE="X",$P(^ABSPF(9002313.91,FLDIEN,0),U)=104 D
 .;. ; Processor control number is different for Envoy
 .;. ; It's always the Envoy Terminal ID, regardless of payor
 .;. ; The XECUTE special code is only for non-Envoy
 .;. ; Change it to "standard" mode for Envoy
 .;. ;I ABSP("Site","Switch Type")="ENVOY" S PMODE="S"
 .;/IHS/OIT/CNI/RAN 06042010 Patch 39 Changes at Emdeon mean we can now use special code for field 104 END commenting out
 . S FLAG=$S(PMODE="S":"GFS",1:"FS")
 . ; Apply any override values, as needed.
 . N OVERRIDE ; the override value, if any
 . I $D(MEDN) D  ; for a prescription detail
 . . I $D(ABSP("OVERRIDE","RX",MEDN,FLDIEN)) D
 . . . S OVERRIDE=ABSP("OVERRIDE","RX",MEDN,FLDIEN)
 . E  D  ; for patient/header info
 . . I $D(ABSP("OVERRIDE",FLDIEN)) D
 . . . S OVERRIDE=ABSP("OVERRIDE",FLDIEN)
 . ; ABSP("X") is the field value as it's being computed
 . S ABSP("X")=""
 . I PMODE="X" D  ; special Xecute code, in lieu of the field's Get code
 . . I $D(OVERRIDE) S ABSP("X")=OVERRIDE
 . . E  D XSPCCODE(FORMAT,NODE,RECMIEN)
 . I $D(OVERRIDE) D
 . . D XFLDCODE(FLDIEN,FLAG,OVERRIDE)
 . E  D
 . . D XFLDCODE(FLDIEN,FLAG)
 Q
 ;Execute Get, Format and/or Set MUMPS code for a NCPDP Field
 ;
 ;Parameters:   FLDIEN  -  NCPDP Field Definitions IEN
 ;              FLAG    -  If variable contains:
 ;                         "G" - Execute Get Code
 ;                         "F" - Execute Format Code
 ;                         "S" - Execute S Code
 ;              OVERRIDE - if defined, it's used instead of Get Code
 ;---------------------------------------------------------------------
XFLDCODE(FLDIEN,FLAG,OVERRIDE) ;EP 
 ;Manage local variables
 ;IHS/SD/lwj  8/1/02  added logic to work with the 5.1 format
 ; code instead of the 3.2 format code.  If the claim is for 
 ; 5.1, we will loop with 10, 25, 30 and if it is 3.2 we will 
 ; loop with 10, 20, 30.
 ;
 ; This subroutine was flagged as an entry point with the NCPDP 
 ; 5.1 changes.  The only call to this subroutine from outside 
 ; of this program is done in ABSPOSHF.
 ;
 N NODE,INDEX,MCODE
 N FNODE                    ;IHS/SD/lwj 8/1/02 format node
 S FNODE=25                 ;IHS/SD/lwj 8/1/02 default to 5.1 node
 ;
 ;I FLDIEN=50 W $T(+0) ZW FLDIEN ; temporary!!
 ;
 ;Check if record exist and FLAG variable is set correctly
 ; (Changed from Q: to give fatal error  10/18/2000)
 I 'FLDIEN D IMPOSS^ABSPOSUE("DB,P","TI","FLDIEN="_FLDIEN,,"XFLDCODE",$T(+0))
 I '$D(^ABSPF(9002313.91,FLDIEN,0)) D IMPOSS^ABSPOSUE("DB,P","TI","FLDIEN="_FLDIEN,,"XFLDCODE",$T(+0))
 I FLAG="" D IMPOSS^ABSPOSUE("DB,P","TI","FLAG null",,"XFLDCODE",$T(+0))
 ;
 ; IHS/SD/lwj 8/1/02  added next line of code
 I ABSP("NCPDP","Version")[3 S FNODE=20
 ;
 ;Loop through Get, Format and Set Code fields and execute code
 ;
 ; IHS/SD/lwj 8/1/02  nxt line remarked out - new line added
 ;F NODE=10,20,30 D
 F NODE=10,FNODE,30 D
 .;
 .; IHS/SD/lwj 8/21/02 nxt line remarked out- new line added
 .;  Q:FLAG'[$S(NODE=10:"G",NODE=20:"F",NODE=30:"S",1:"")
 .Q:FLAG'[$S(NODE=10:"G",NODE=20:"F",NODE=25:"F",NODE=30:"S",1:"")
 .I '$D(^ABSPF(9002313.91,FLDIEN,NODE,0)) D IMPOSS^ABSPOSUE("DB","TI","FLDIEN="_FLDIEN,"NODE="_NODE,"XFLDCODE",$T(+0))
 . ;If value is being overridden, just take the override value & get out
 .I NODE=10,$D(OVERRIDE) S ABSP("X")=OVERRIDE Q
 .S INDEX=0
 .F  D  Q:'+INDEX
 ..S INDEX=$O(^ABSPF(9002313.91,FLDIEN,NODE,INDEX))
 ..Q:'+INDEX
 ..S MCODE=$G(^ABSPF(9002313.91,FLDIEN,NODE,INDEX,0))
 ..Q:MCODE=""
 ..Q:$E(MCODE,1)=";"
 ..X MCODE
 ..;I NODE=30 W $T(+0)," $ZR=",$ZR," ",@$ZR," ",$P(@$ZR,"^",43),! R ">>>",%,!
 Q
 ;----------------------------------------------------------------------
 ;Execute Special Code (for a NCPDP Field within a NCPDP Record)
 ;
 ;Parameters:    FORMAT  - NCPDP Record Format IEN (9002313.92)
 ;               NODE     - Global node value (10,20,30,40)
 ;               RECMIEN  - Field Multiple IEN
 ;---------------------------------------------------------------------
XSPCCODE(FORMAT,NODE,RECMIEN) ;EP
 ;Manage local variables
 ;
 ; This subroutine was flagged as an entry point with the NCPDP 
 ; 5.1 changes.  The only call to this subroutine from outside 
 ; of this program is done in ABSPOSHR.
 ;
 N INDEX,MCODE
 I '$D(^ABSPF(9002313.92,FORMAT,NODE,RECMIEN,0)) D IMPOSS^ABSPOSUE("DB,P","TI","no special code there to XECUTE","FORMAT="_FORMAT,"XSPCCODE",$T(+0))
 ;
 S INDEX=0
 F  D  Q:'+INDEX
 .S INDEX=$O(^ABSPF(9002313.92,FORMAT,NODE,RECMIEN,1,INDEX))
 .Q:'+INDEX
 .S MCODE=$G(^ABSPF(9002313.92,FORMAT,NODE,RECMIEN,1,INDEX,0))
 .Q:MCODE=""
 .Q:$E(MCODE,1)=";"
 . ;
 .;
 . S ^BZHD(FORMAT,NODE,RECMIEN,1,INDEX)=MCODE
 . ;
 .X MCODE
 Q
