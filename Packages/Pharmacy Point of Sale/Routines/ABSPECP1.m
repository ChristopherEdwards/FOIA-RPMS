ABSPECP1 ; IHS/FCS/DRS - printing for PCS ;  [ 10/09/2002  8:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,12,17,23,42,44**;JUN 21, 2001
 ;
 ;---------------------------------
 ;IHS/SD/lwj 10/08/02  NCPDP 5.1 changes
 ; With 5.1 the segments, fields, and field identifiers changed.
 ; This routine had to be adjusted to account for the differences
 ; between a 5.1 and 3.2 claims.  Changes made where needed.
 ;---------------------------------
 ;IHS/SD/lwj 3/11/05 patch 12 need to add the DUR segment to
 ; the claim and response portions of the receipt
 ;---------------------------------
 ;IHS/SD/RLT - 05/01/06 - Patch 17
 ; Allow for double zeros in fields 440 and 441.
 ; Fix the displaying of multiple DUR sets.
 ;---------------------------------
 ;IHS/SD/RLT - 08/03/07 - 10/18/07 - Patch 23
 ; Diagnois Code
 Q
TEST K TMP D FILEMAN("TMP",255)
 ;O 51:("TMP.OUT":"W") U 51 ZW TMP C 51
 Q
FILEMAN(DEST,IEN,FIELDS,RX,RXFIELDS)     ;EP - from ABSPECP0 and ABSPOS6E
 ; generalized FileMan fetch for pharm e-claims and responses
 ; DEST = destination (closed ref, used in @DEST@(subs) format)
 ;   if global, it must be ^TMP or ^UTILITY
 ; FILE = file number (9002313.02 or 9002313.03)
 ; IEN as usual;  FIELDS = the DR string of field numbers
 ; RX = prescription sub-entry; RXFIELDS = the DR string for it
 ; FIELDS, RX, RXFIELDS optional; they default to all RXs,all fields
 ; Returns @DEST@("C",field)=value    for fields in the claim
 ;         @DEST@("C",field,"RX",rx,field)=value
 ;         @DEST@("R" similarly
 ;    where "field" is field name (not field number)
 K ^UTILITY("DIQ1",$J)
 N FILE S FILE=9002313.02 D FM1
 S FILE=9002313.03,IEN=$O(^ABSPR("B",IEN,""),-1) ; last resp
 I IEN D
 .D FM1
 D FORMAT
 Q
FORMAT ; ^UTILITY("DIQ1",$J,file,DA,field,*)->@TMP@(...)
 ;------------------------
 ;IHS/SD/lwj 10/08/02  NCPDP 5.1 changes
 ; added the NCPDP field to decipher the version - this will help
 ; in the data translation
 ;-------------------------
 N SRC S SRC="^UTILITY(""DIQ1"",$J)"
 N EFORMAT,INSURER,FILE,DA,FIELD
 N NCPDP51               ;IHS/SD/lwj 10/08/02  NCPDP 5.1 change
 S NCPDP51=0             ;IHS/SD/lwj 10/08/02  NCPDP 5.1 change
 N RXSEQ                 ;IHS/SD/lwj 6/13/05 need to know the rx seq
 S RXSEQ=1               ;IHS/SD/lwj 6/13/05 default it to one
 S DA=$O(@SRC@(9002313.02,0))
 S INSURER=$G(@SRC@(9002313.02,DA,.02,"I"))
 I INSURER S EFORMAT=$P($G(^ABSPEI(INSURER,100)),U)
 E  S EFORMAT=0
 I ('EFORMAT),$G(^ABSP(9002313.99,1,"ABSPICNV"))'=1 W "Internal error - no FORMAT for INSURER=",INSURER,! Q
 ;
 S:$G(@SRC@(9002313.02,DA,102,"I"))=51 NCPDP51=1
 ;IHS/OIT/CASSEVERN/RAN - 02/10/2011 - Patch 42 Temporary change to allow printing of D.0 receipts as if they were 5.1 Receipts 
 S:$G(@SRC@(9002313.02,DA,102,"I"))="D0" NCPDP51=1
 ;
 ;ZW EFORMAT
 S FILE="" F  S FILE=$O(@SRC@(FILE)) Q:'FILE  D
 .S DA=""  F  S DA=$O(@SRC@(FILE,DA)) Q:'DA  D
 ..N FIELD S FIELD="" F  S FIELD=$O(@SRC@(FILE,DA,FIELD)) Q:'FIELD  D
 ...I EFORMAT,'$$INCLUDE(EFORMAT,FILE,FIELD) D  Q
 ....;W "FORMAT+n^",$T(+0)," excludes EFORMAT=",EFORMAT,", FIELD=",FIELD,!
 ...;IHS/SD/lwj 6/13/05 patch 12 need to know the rx sequence
 ...S:((FILE=9002313.0301)&(FIELD=.01)) RXSEQ=DA
 ...D FMTFIELD
 Q
INCLUDE(EFORMAT,FILE,FIELD)  ; is the field part of this protocol?
 ; returns 1 or 10 or 20 or 30 or 40 maybe with ^ID appended
 ;--------------------------------
 ;IHS/SD/lwj 10/08/02   NCPDP 5.1 changes - need to include all
 ; the new segments
 ;
 ;--------------------------------
 ;
 N START,END
 S START=10,END=40
 I NCPDP51 S START=100,END=230
 ;
 I FILE=9002313.03 Q 1 ; always yes for response fields
 I FILE=9002313.0301 Q 1 ; always yes for response fields
 I FILE=9002313.1101 Q 1 ; IHS/SD/lwj 3/11/05 patch 12 DUR resp segment
 I FIELD<101!(FIELD>600) Q 1 ; yes for fields outside protocol range
 N FIELDIEN S FIELDIEN=$O(^ABSPF(9002313.91,"B",FIELD,0))
 I FIELDIEN="" Q 0 ; should never happen?
 ;IHS/OIT/CASSEVER/RAN 03/24/2011 patch 42 Get rid of references to formats for new method of claims processing
 I $P($G(^ABSP(9002313.99,1,"ABSPICNV")),"^",1)=1 Q "110^"_$$FIELDID(FIELD)
 ;
 ;IHS/SD/lwj 10/08/02  NCPDP 5.1 nxt line remarked out, following added
 ;N I,FIND S FIND=0 F I=10,20,30,40 D  Q:$G(FIND)
 N I,FIND S FIND=0 F I=START:10:END D  Q:$G(FIND)
 .N J S J=0
 .F  S J=$O(^ABSPF(9002313.92,EFORMAT,I,J)) Q:'J  D  Q:$G(FIND)
 ..I $P(^ABSPF(9002313.92,EFORMAT,I,J,0),U,2)=FIELDIEN D
 ...S FIND=I
 ...S FIND=FIND_U_$$FIELDID(FIELD)
 Q FIND
FIELDID(FIELD)     ; the two character field ID, given the external field #
 ;--------------------------------------
 ;IHS/SD/lwj 10/08/02  NCPDP 5.1 changes
 ; With 5.1 all the fields will have a field identifier, except for the
 ; header segment.  Must adjust this routine to account for that.
 ; (NCPDP51 is defined in the FORMAT subroutine and is based on fld 102)
 ;
 ;--------------------------------------
 N ID
 N FIELDIEN S FIELDIEN=$O(^ABSPF(9002313.91,"B",FIELD,0))
 I FIELDIEN="" Q ""
 ;
 S:'NCPDP51 ID=$P(^ABSPF(9002313.91,FIELDIEN,0),U,2)
 S:NCPDP51 ID=$P($G(^ABSPF(9002313.91,FIELDIEN,5)),U)
 ;
 ;IHS/SD/lwj 10/08/02 NCPDP 5.1 nxt line remarked out - following added
 ;Q $P(^ABSPF(9002313.91,FIELDIEN,0),U,2)
 Q ID
 ;
ISVARFLD(EFORMAT,FILE,FIELD) ; is it a variable length field?
 ;---------------------------------
 ;IHS/SD/lwj 10/08/02  NCPDP 5.1 changes
 ; if we are working with a 5.1 format, and it's any segment other
 ; than 100, return the field id.
 ;---------------------------------
 ; returns 2-char field ID if it is
 N X S X=$$INCLUDE(EFORMAT,FILE,FIELD)
 Q:(NCPDP51)&(X>100) $P(X,U,2)    ;IHS/SD/lwj 10/08/02 NCPDP 5.1
 I +X=20!(+X=40) Q $P(X,U,2)
 E  Q ""
FMTFIELD ; given FILE,DA,FIELD,@SRC@(FILE,DA,FIELD,"E" and "I"), set @TMP
 ; given INSURER and EFORMAT, too
 ; Fetch the INT and EXT values
 ;-----------------------------------------
 ;IHS/SD/lwj 10/08/02 NCPDP 5.1 changes
 ; needed to format a couple of the newer field a little different
 ;-----------------------------------------
 ;
 N INT S INT=$G(@SRC@(FILE,DA,FIELD,"I"))
 N EXT S EXT=$G(@SRC@(FILE,DA,FIELD,"E"))
 ; If it's a variable field, remove the field ID
 N VARFIELD
 ;
 ;IHS/SD/lwj 10/08/02 NCPDP 5.1 fields need more formatting
 N CKFLD,FLDLST
 ;IHS/SD/lwj 3/11/05 patch 12, need to format 412 (disp fee)
 ;nxt line remrkd out, following added
 ;S FLDLST=",409,448,449,477,480,481,482,483,487,558,562,566,"
 ;S FLDLST=",409,412,448,449,477,480,481,482,483,487,558,562,566,"
 ;IHS/OIT/SCR 12/05/08 patch 28 t4 need to format 438 (Incentive amount)
 S FLDLST=",409,412,448,449,477,480,481,482,483,487,558,562,566,438,"
 I FIELD=524 S VARFIELD="FO"  ; have to hardcode response cases
 E  S VARFIELD=$$ISVARFLD(EFORMAT,FILE,FIELD)
 I VARFIELD]"" D
 .I $E(INT,1,2)=VARFIELD S INT=$E(INT,3,$L(INT))
 .I $E(EXT,1,2)=VARFIELD S EXT=$E(EXT,3,$L(EXT))
 ;I FIELD=422 ZW VARFIELD,EFORMAT,FILE,FIELD,INT,EXT
 ; Trailing spaces, leading zeroes
 F  Q:$E(EXT,$L(EXT))'=" "  S EXT=$E(EXT,1,$L(EXT)-1)
 ;IHS/SD/RLT - 05/01/06 - Patch 17
 ;Allow for double zeros in fields 440 and 441
 ;I FIELD'=407,FIELD'=302 D
 ;Patch 23 added 492 below
 ;OIT/CAS/RCS 10022012 - Patch 44, added fields 101, 104, 301, 303 and 110
 I FIELD'=407,FIELD'=302,FIELD'=440,FIELD'=441,FIELD'=492,FIELD'=101,FIELD'=104,FIELD'=301,FIELD'=110,FIELD'=303 D
 .F  Q:$E(EXT)'=0  Q:$L(EXT)=1  S EXT=$E(EXT,2,$L(EXT))
 I FIELD=426!(FIELD=430) D  ; for some reason they're missed
 .S EXT="$"_$J($$DFF2EXT^ABSPECFM(EXT),7,2)
 ;
 ;IHS/SD/lWJ 10/08/02 NCPDP 5.1 some more signed fields
 S CKFLD=","_FIELD_","
 S:FLDLST[CKFLD EXT="$"_$J($$DFF2EXT^ABSPECFM(EXT),7,2)
 ;
 ;IHS/SD/lwj 3/11/05 format .01 fld for claim DUR
 S:((FIELD=.01)&(FILE=9002313.1001)) EXT=$E(EXT,3,$L(EXT))
 ;
 ; Format .01 fld for claim DIAG                     Patch 23
 S:((FIELD=.01)&(FILE=9002313.0701)) EXT=$E(EXT,3,$L(EXT))
 ;
 I FIELD=103 S EXT=$$TCODE^ABSPECP2(EXT)
 ; Get the field name
 N FLDNAME S FLDNAME=$P(^DD(FILE,FIELD,0),U)
 ; If it's a date field that didn't get formatted, format it
 I FLDNAME["Date",EXT?8N D
 .N Y S Y=EXT-17000000 X ^DD("DD") S EXT=Y
 ; Other enumerated fields
 ;IHS/SD/lwj 10/08/02 NCPDP 5.1 field now include "Patient"
 I FLDNAME="Patient Relationship Code" D
 .S EXT=$S(EXT=1:"Cardholder",EXT=2:"Spouse",EXT=3:"Child",EXT=4:"Other Dependent",1:EXT)
 I FLDNAME="Compound Code" D
 .S EXT=$S(EXT=1:"Not a compound",EXT=2:"Compound",1:EXT)
 I FLDNAME="Dispense As Written" S EXT=$$DAW^ABSPECP2(EXT)
 I FLDNAME="Basis of Reimb Determination" S EXT=$$REIMB^ABSPECP2(EXT)
 I FLDNAME="Diagnosis Code Count" S FLDNAME="DIAG Count"         ;Patch 23
 ; Store it
 I EXT="",'$$INCLUDE(EFORMAT,FILE,FIELD) Q
 I FILE=9002313.02 D
 .S @DEST@("C",FLDNAME)=EXT
 E  I FILE=9002313.0201 D
 .S @DEST@("C",FLDNAME,"RX",DA)=EXT
 E  I FILE=9002313.1001 D  ;IHS/SD/lwj 3/11/05 patch 12 clm DUR
 .;IHS/SD/RLT - 05/01/06 - Patch 17
 .;Fix displaying of multiple DUR sets
 .;S @DEST@("C","DUR entry "_DA_": "_FLDNAME,"RX",DA)=EXT
 .S @DEST@("C","DUR entry "_DA_": "_FLDNAME,"RX",RXSEQ)=EXT
 E  I FILE=9002313.0701 D                                        ;Patch 23
 .S @DEST@("C","DIAG entry "_DA_": "_FLDNAME,"RX",RXSEQ)=EXT     ;Patch 23
 E  I FILE=9002313.03 D
 .S @DEST@("R",FLDNAME)=EXT
 E  I FILE=9002313.0301 D
 .I FLDNAME="Additional Message Information" S FLDNAME="Message (more)"
 .S @DEST@("R",FLDNAME,"RX",DA)=EXT
 E  I FILE=9002313.1101 D  ;IHS/SD/lwj 3/11/05 patch 12 DUR resp
 .S @DEST@("R","DUR Resp "_DA_" "_FLDNAME,"RX",RXSEQ)=EXT
 E  D IMPOSS^ABSPOSUE("P","TI",,,"FMTFIELD",$T(+0))
 Q
FM1 N DIC,DR,DA,DIQ,SUBFILE
 I '$D(FIELDS) S FIELDS=".01:99999999"
 I '$D(RX)
 I '$D(RXFIELDS) S RXFIELDS=".01:99999999"
 ; Safety - make sure if DEST is global, it's probably a scratch global
 I DEST?1"^".E I DEST'?1"^TMP("1E.E,DEST'?1"^UTILITY("1E.E D IMPOSS^ABSPOSUE("P","TI","Bad DEST",DEST,"FM1",$T(+0))
 D FETCH ; gives ^UTILITY("DIQ1",$J,file,DA,field,"E") and ^("I")
 Q
FETCH ;
 I '$D(RX) N RX S RX=0 D  Q
 .; RX not yet determined:  recurse
 .N GLO S GLO="^ABSP"_$S(FILE=9002313.02:"C",FILE=9002313.03:"R")
 .N SUB S SUB=$S(FILE=9002313.02:400,FILE=9002313.03:1000)
 .F  S RX=$O(@GLO@(FILE,IEN,SUB,RX)) Q:'RX  D
 ..D 2
2 ; with RX determined
 I FILE=9002313.03 D  ; Reject Code(s) done manually
 .N X S X=0 F  S X=$O(^ABSPR(IEN,1000,RX,511,X)) Q:'X  D
 ..;ZW X W ^(X,0),!
 ..N Y S Y=^ABSPR(IEN,1000,RX,511,X,0),Y=$P(Y,U)
 ..N Z S Z=$O(^ABSPF(9002313.93,"B",Y,0))
 ..;W Y," -> ",Z,!
 ..I Z,$D(^ABSPF(9002313.93,Z,0)) S Z=$P(^(0),U,2)
 ..S @DEST@("R","Reject Code","RX",RX,$S(Y?1"0"1N:+Y,1:Y))=Y_" "_Z
 ..;ZW @DEST@("R","Reject Code","RX") R ">>",%,!
 .;Preferred Product data sent back
 .N X S X=0 F  S X=$O(^ABSPR(IEN,1000,RX,551.01,X)) Q:'X  D
 ..N Y S Y=$G(^ABSPR(IEN,1000,RX,551.01,X,1)) I Y="" Q
 ..N Z S Z=$P(Y,"^",2)_" "_$P(Y,"^",5)
 ..S @DEST@("R","Preferred Product","RX",RX,X)=Z
 .;Additional Message Information sent back
 .N X S X=0 F  S X=$O(^ABSPR(IEN,1000,RX,526,X)) Q:'X  D
 ..N Y S Y=$G(^ABSPR(IEN,1000,RX,526,X,0)) I Y="" Q
 ..S @DEST@("R","Additional Information","RX",RX,X)=Y
 S DIC=FILE,DA=IEN,DR=FIELDS,DIQ(0)="IEN"
 S SUBFILE=FILE+.0001 ; as it happens to work out
 S DA(SUBFILE)=RX
 S DR(SUBFILE)=RXFIELDS
 D EN^DIQ1
 ;
 ;IHS/SD/lwj 3/11/05 patch 12 retrieve the claim and resp DUR
 D:FILE=9002313.02 SETCDUR   ;retrieve the claim DUR info
 D:FILE=9002313.03 SETRDUR   ;retrieve the response DUR info
 ;
 ;
 ;IHS/SD/RLT - 08/03/07 - Patch 23
 ; Diagnois Code information
 D:FILE=9002313.02 SETCDIAG   ;retrieve the claim DIAG info
 ;
 Q
SETCDUR ;------------------------------------------------------------
 ;IHS/SD/LWJ 3/11/05 patch 12
 ; set fields needed to retrieve DUR information from the claim
 ;------------------------------------------------------------
 N DURCNT
 ;
 S DURCNT=0
 S DR(9002313.0201)=473.01
 S DR(9002313.1001)=".01;439;440;441;474;475;476"  ;fields
 ;
 F  S DURCNT=$O(^ABSPC(IEN,400,RX,473.01,DURCNT)) Q:DURCNT=""  D
 . S DA(9002313.1001)=DURCNT
 . S DIQ(0)="IEN"
 . D EN^DIQ1
 ;
 Q
SETRDUR ;----------------------------------------------------------------
 ;IHS/SD/lwj 3/11/05 patch 12
 ; set fields needed to retrieve DUR information from the response
 ;----------------------------------------------------------------
 N DURCNT
 ;
 S DURCNT=0
 S DR(9002313.0301)=567.01    ;DUR multiple
 S DR(9002313.1101)=".01;439;528;529;530;531;532;533;544"  ;fields
 ;
 F  S DURCNT=$O(^ABSPR(IEN,1000,RX,567.01,DURCNT)) Q:DURCNT=""  D
 . S DA(9002313.1101)=DURCNT
 . S DIQ(0)="IEN"
 . D EN^DIQ1
 ;
 Q
SETCDIAG ;
 ;IHS/SD/RLT - 08/03/07 - 10/18/07 - Patch 23
 ; set Diagnosis Code information from the claim
 ;
 N DIAGCNT
 ;
 S DIAGCNT=0
 S DR(9002313.0201)=491.01
 S DR(9002313.0701)=".01;492;424"  ;fields
 ;
 F  S DIAGCNT=$O(^ABSPC(IEN,400,RX,491.01,DIAGCNT)) Q:'+DIAGCNT  D
 . S DA(9002313.0701)=DIAGCNT
 . S DIQ(0)="IEN"
 . D EN^DIQ1
 ;
 Q
