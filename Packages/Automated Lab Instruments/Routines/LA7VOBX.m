LA7VOBX ;VA/DALOI/JMC - LAB OBX Segment message builder ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,1027**;NOV 01, 1997
 ;
OBX(LRDFN,LRSS,LRIDT,LRSB,LA7ARRAY,LA7OBXSN,LA7FS,LA7ECH,LA7NVAF) ; Observation/Result segment for Lab Results.
 ; Call with    LRDFN = ien of entry in file #63
 ;               LRSS = file #63 subscript
 ;              LRIDT = inverse date/time of specimen
 ;               LRSB = ien of dataname if "CH" subscript or global subscript for others
 ;           LA7ARRAY = array to return OBX segment, pass by reference
 ;           LA7OBXSN = OBX segment sequence number, pass by reference
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;            LA7NVAF = flag indicating type of receiving facility (see NVAF^LA7VHLU2)
 ;
 ; Returns LA7OBXSN = current OBX segment sequence number 
 ;         LA7ARRAY = array containing OBX segment
 ;
 N LA7OBX,LA7VAL,LA7X
 ;
 ; No subscript/patient/specimen
 I $G(LRSS)=""!('$G(LRDFN))!('$G(LRIDT)) Q
 ;
 S LA7NVAF=$G(LA7NVAF)
 ;
 ; "CH" subscript
 I LRSS="CH" D CH^LA7VOBX1 Q
 ;
 ; "MI" subscript
 I LRSS="MI" D MI^LA7VOBX3 Q
 ;
 ; "SP" subscrpt
 I LRSS="SP" D AP^LA7VOBX2 Q
 ;
 ; "CY" subscrpt
 I LRSS="CY" D AP^LA7VOBX2 Q
 ;
 ; "EM" subscrpt
 I LRSS="EM" D AP^LA7VOBX2 Q
 ;
 Q
 ;
 ;
OBX1(LA7OBXSN) ; Build OBX-1 sequence - Set ID (sequence number)
 ; Call with LA7OBXSN = sequence number (pass by reference)
 ;
 N LA7Y
 ;
 ; increment sequence number
 S (LA7OBXSN,LA7Y)=$G(LA7OBXSN)+1
 ;
 Q LA7Y
 ;
 ;
OBX2(LA7FILE,LA7FIELD) ; Build OBX-2 sequence - Value type
 ; Call with   LA7FILE = FileMan DD file/subfield number
 ;            LA7FIELD = Fileman DD field number
 ;
 ; Returns      LA7VAL = value type  (HL7 table 0125)
 ;
 N LA7ERR,LA7TYP,LA7VAL
 ;
 D OBX2^LA7VOBXA
 ;
 Q LA7VAL
 ;
 ;
OBX3(LA7NLT,LA7953,LA7ALT,LA7FS,LA7ECH) ; Build OBX-3 sequence - Observation identifier field
 ; Call with  LA7NLT = NLT code.
 ;            LA7953 = LOINC code
 ;            LA7ALT = alternate code - local/non-VA (code^text^system)
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;
 N LA764,LA7J,LA7LN,LA7X,LA7Y
 ;
 D OBX3^LA7VOBXA
 ;
 Q LA7Y
 ;
 ;
OBX4(LA7VAL,LA7FS,LA7ECH) ; Build OBX-4 sequence - Observation sub-ID
 ; Call with  LA7VAL = value of the observation
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;
 ; Returns LA7Y = Observation sub-ID checked for escape encoding
 ;
 N LA7Y
 ;
 S LA7Y=$$CHKDATA^LA7VHLU3(LA7VAL,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
OBX5(LA7VAL,LA7OBX2,LA7FS,LA7ECH) ; Build OBX-5 sequence - Observation value
 ; Call with  LA7VAL = value of the observation
 ;           LA7OBX2 = value type
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;
 N LA7Y
 ;
 D OBX5^LA7VOBXA
 ;
 Q LA7Y
 ;
 ;
OBX5M(LA7FN,LA7IENS,LA7FLD,LA7WP,LA7FS,LA7ECH) ; Build OBX-5 sequence - Observation value - multi-line textual result
 ; Call with LA7FN = File number or subfile
 ;         LA7IENS = Standard FileMan IENS indicating internal entry numbers
 ;          LA7FLD = Field number
 ;           LA7WP = array passed by reference to return text
 ;           LA7FS = HL field separator
 ;          LA7ECH = HL encoding characters
 ;
 ; Returns   LA7WP = subscripted array containing text of results
 ;                   LA7WP(0), LA7WP(1), LA7WP(2),...
 ;
 N LA7ERR,LA7I,LA7J,LA7TYPE,LA7X,LA7Y
 ;
 D OBX5M^LA7VOBXA
 ;
 Q
 ;
 ;
OBX5R(LA7VAL,LA7OBX2,LA7FS,LA7ECH) ; Build OBX-5 sequence with repetition - Observation value
 ; Call with  LA7VAL = array passed by reference
 ;           LA7OBX2 = value type
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;
 N LA7I,LA7Y
 ;
 D OBX5R^LA7VOBXA
 ;
 Q LA7Y
 ;
 ;
OBX6(LA7VAL,LA764061,LA7FS,LA7ECH) ; Build OBX-6 sequence - Units
 ; Call with   LA7VAL = Units if in external format
 ;           LA764061 = ien of units in #64.061
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ; Returns units
 ;
 N LA7Y
 ;
 D OBX6^LA7VOBXA
 ;
 Q LA7Y
 ;
 ;
OBX7(LA7LOW,LA7HIGH,LA7FS,LA7ECH) ; Build OBX-7 sequence - Reference range
 ; Call with  LA7LOW = lower limit
 ;           LA7HIGH = upper limit
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ; Returns reference range
 ;
 N LA7Y
 ;
 D OBX7^LA7VOBXA
 ;
 Q LA7Y
 ;
 ;
OBX8(LA7FLAG) ; Build OBX-8 sequence - Abnormal flags
 ; Call with LA7FLAG = DHCP Lab normalcy flag
 ; Returns abnormal flags based on HL7 table 0078
 ;
 N LA7Y
 ;
 S LA7Y=$TR(LA7FLAG,"*",$E(LA7FLAG,1)) ; abnormal flag
 Q LA7Y
 ;
 ;
OBX11(LA7FLAG) ; Build OBX-11 sequence - Observation result status
 ; Call with LA7FLAG = DHCP Lab status flag
 ; Returns result status based on HL7 table 0085
 ;
 N LA7Y
 ;
 S LA7Y=""
 ;
 I LA7FLAG="canc" S LA7Y="X"
 I LA7FLAG="comment" S LA7Y="F"
 I LA7FLAG="pending" S LA7Y="I"
 I LA7FLAG="F" S LA7Y="F"
 I LA7FLAG="P" S LA7Y="P"
 I LA7FLAG="A" S LA7Y="C"
 I LA7FLAG="C" S LA7Y="C"
 ;
 Q LA7Y
 ;
 ;
OBX13(LA7VAL,LA7SRC,LA7FS,LA7ECH) ; Build OBX-13 sequence - User defined access checks
 ; Call with LA7VAL = access screen to expand
 ;           LA7SRC = source of access screen
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns     LA7Y = access screen text
 ;
 N LA7Y
 S LA7Y=""
 ;
 ; Expanding antibiotic susceptibility display screen
 I LA7SRC="MIS" D
 . S LA7Y=$S(LA7VAL="A":"ALWAYS DISPLAY",LA7VAL="N":"NEVER DISPLAY",LA7VAL="R":"RESTRICT DISPLAY",1:"")
 ;
 S LA7Y=$$CHKDATA^LA7VHLU3(LA7Y,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
OBX14(LA7DT) ; Build OBX-14 sequence - date/time of observation
 ; Call with LA7DT = FileMan date/time
 ; Returns OBX-14 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBX15(LA74,LA7FS,LA7ECH) ; Build OBX-15 sequence - Producer's ID field
 ; Call with   LA74 = ien of institution in file #4
 ;                    if null/undefined then use Kernel Site file.
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns facility that performed the testing (ID^text^99VA4)
 ;
 Q $$INST^LA7VHLU4(LA74,LA7FS,LA7ECH)
 ;
 ;
OBX16(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBX-16 sequence - Responsible observer field
 ; Call with   LA7DUZ = DUZ of verifying user
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBX-16 sequence
 ;
 Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 ;
 ;
OBX17(LA7VAL,LA7FS,LA7ECH) ; Build OBX-17 sequence - Observation method field
 ; Call with   LA7VAL = WKLD SUFFIX CODES #64.2 with leading decimal
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns       LA7Y = OBX-17 sequence
 ;
 N LA7X,LA7Y
 ;
 ; method suffix code maybe stored without leading decimal,
 ;  add "." back for lookup, also add trailing space for lookup in x-ref.
 I LA7VAL>1 S LA7VAL="."_LA7VAL
 S LA7X=$O(^LAB(64.2,"C",LA7VAL_" ",0)),LA7Y=""
 I LA7X D
 . S LA7X(.01)=$$GET1^DIQ(64.2,LA7X_",",.01)
 . S LA7X(.01)=$$CHKDATA^LA7VHLU3(LA7X(.01),LA7FS_LA7ECH)
 . S LA7Y=LA7VAL_$E(LA7ECH)_LA7X(.01)_$E(LA7ECH)_"99VA64_2"
 ;
 Q LA7Y
 ;
 ;
OBX18(LA7VAL,LA7FS,LA7ECH) ; Build OBX-18 sequence - Equipment entity identifier field
 ; Call with   LA7VAL = Equipment entity identifier
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns       LA7X = OBX-18 sequence
 ;
 N LA7I,LA7J,LA7X,LA7Y
 ;
 S LA7X="",LA7J=$L(LA7VAL,"!")
 F LA7I=1:1:LA7J D
 . S LA7Y=$P(LA7VAL,"!",LA7I)
 . I LA7Y="" Q
 . S $P(LA7X,$E(LA7ECH,1),LA7I)=$$CHKDATA^LA7VHLU3(LA7Y,LA7FS_LA7ECH)
 ;
 Q LA7X
