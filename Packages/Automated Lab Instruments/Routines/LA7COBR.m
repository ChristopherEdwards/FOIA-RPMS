LA7COBR ;VA/DALOI/JMC - LAB OBR segment builder ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,1018,64,1027,68,1033**;NOV 01, 1997
 ;
 Q
 ;
 ;
OBR1(LA7OBRSN) ; Build OBR-1 sequence - set segment id
 ; Call with LA7OBRSN = segment id (pass by reference)
 ;
 S LA7OBRSN=$G(LA7OBRSN)+1
 Q LA7OBRSN
 ;
 ;
OBR2(LA7ID,LA7FS,LA7ECH) ; Build OBR-2 sequence - placer's specimen id
 ; Call with LA7ID = placer's specimen id (accn number/UID)
 ;           LA7ID("NMSP") = application namespace (optional)
 ;           LA7ID("SITE") = placer facility
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;
 I $G(LA7INPT),$G(LA7OBRSN)>1,LRSS="MI" Q ""  ;mu2 inpatient
 I $G(LA7INPT),$G(LA7OBRSN)>1,$G(LA7ADDON) Q ""  ;mu2 inpatient
 N LA7X,LA7Y
 D OBR2^LA7COBRA
 Q LA7Y
 ;
 ;
OBR3(LA7ID,LA7FS,LA7ECH) ; Build OBR-3 sequence - filler's specimen id
 ; Call with LA7ID = filler's specimen id (accn number/UID)
 ;           LA7ID("NMSP") = application namespace (optional)
 ;           LA7ID("SITE") = filler facility
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;
 N LA7X,LA7Y
 D OBR3^LA7COBRA
 Q LA7Y
 ;
 ;
OBR4(LA7NLT,LA760,LA7ALT,LA7FS,LA7ECH) ; Build OBR-4 sequence - Universal service ID
 ; Call with LA7NLT = NLT test code
 ;            LA760 = file #60 ien if known
 ;           LA7ALT = alternate order code and system in form 
 ;                     test code^test name^coding system
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns     LA7Y = OBR-4 sequence
 ;
 N LA764,LA7COMP,LA7ERR,LA7TN,LA7X,LA7Y,LA7Z
 D OBR4^LA7COBRA
 Q LA7Y
 ;
 ;
OBR6(LA7DT) ; Build OBR-6 sequence - requested date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-6 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR7(LA7DT) ; Build OBR-7 sequence - collection date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-7 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR8(LA7DT) ; Build OBR-8 sequence - collection end date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-8 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR9(LA7VOL,LA764061,LA7FS,LA7ECH) ; Build OBR-9 sequence - collection volume
 ; Call with    LA7VOL = collection volume
 ;            LA764061 = units (pointer to #64.061)
 ;               LA7FS = HL7 field separator
 ;              LA7ECH = HL encoding characters
 ; Returns OBR-9 sequence
 ;
 N LA7IENS,LA7X,LA7Y
 D OBR9^LA7COBRA
 Q LA7Y
 ;
 ;
OBR11(LA7X) ; Build OBR-11 sequence - speciman action code
 ; Call with LA7X = HL7 Table 0065 entry
 ; Returns OBR-11 sequence
 ;
 ; JMC-12/09/99 Need to expand this function to determine based on collection status
 ;
 Q LA7X
 ;
 ;
OBR12(LRDFN,LA7FS,LA7ECH) ; Build OBR-12 sequence - patient info
 ; Call with  LRDFN = ien of patient in #63
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ; Returns OBR-12 sequence
 ;
 N LA7X
 ;
 S LRDFN=$G(LRDFN),LA7ECH=$G(LA7ECH)
 ; Infection Warning
 S LA7X=$P($G(^LR(LRDFN,.091)),"^")
 I LA7X'="" D
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
 . S LA7X=$E(LA7ECH,1)_LA7X
 ;
 Q LA7X
 ;
 ;
OBR13(LA7TXT,LA7SNM,LA7FS,LA7ECH) ; Build OBR-13 sequence - revelant clinical info
 ; Call with LA7TXT = text to place into OBR-13
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ; Returns OBR-12 sequence
 ;
 N LA7Y
 ;S LA7X=$$CHKDATA^LA7VHLU3(LA7TXT,LA7FS_LA7ECH)
 I LA7SNM="" Q ""
 N OBR131,OBR132,OBR133,OBR134,OBR135,OBR136,OBR139
 S OBR131=LA7SNM
 S OBR132=LA7TXT
 S OBR133="SCT"
 S OBR134=LA7SNM
 S OBR135=$E(LA7TXT,1,10)
 S OBR136="99USI"
 S OBR139=LA7TXT
 S $P(LA7Y,$E(LA7ECH),1)=OBR131
 S $P(LA7Y,$E(LA7ECH),2)=OBR132
 S $P(LA7Y,$E(LA7ECH),3)=OBR133
 S $P(LA7Y,$E(LA7ECH),4)=OBR134
 S $P(LA7Y,$E(LA7ECH),5)=OBR135
 S $P(LA7Y,$E(LA7ECH),6)=OBR136
 S $P(LA7Y,$E(LA7ECH),9)=OBR139
 Q LA7Y
 ;
 ;
OBR14(LA7DT) ; Build OBR-14 sequence - speciman arrival date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-14 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR15(LA761,LA762,LA7ALT,LA7FS,LA7ECH,LA7CM,LA7SNM) ; Build OBR-15 sequence - specimen source
 ; Call with LA761 = ien of topography file #61
 ;           LA762 = ien of collection sample in file #62
 ;          LA7ALT = alternate non-HL7 codes/text/coding system in form -
 ;                   specimen code^specimen text^specimen system^CONTROL^collection sample code^collection sample^collection system.
 ;                   "CONTROL" only present when specimen is a lab control from file #62.3.
 ;                   presence of these will override standard HL7 tables
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;           LA7CM = ien of shipping condition file #62.93 (collection method)
 ;          LA7SNM = 1-flag to send SNOMED CT instead of HL7 table 0070
 ;
 ; Returns OBR-15 sequence in LA7Y
 ;
 N LA764061,LA7COMP,LA7ERR,LA7X,LA7Y,LA7Z,X,Y
 D OBR15^LA7COBRB
 Q LA7Y
 ;
 ;
OBR17(FS,ECH) ;-- MU2 build the order call back phone number
 N LA7Y,CS,RS,PH1,PH2
 S CS=$E(LA7ECH)
 S RS=$E(LA7ECH,2)
 S PH1=$P($G(^BLRSITE(DUZ(2),3)),U,6)
 S PH2=$P($G(^BLRSITE(DUZ(2),3)),U,7)
 S LA7Y=CS_"WPN"_CS_"PH"_CS_CS_$E(PH1,1)_CS_$E(PH1,2,4)_CS_$E(PH1,5,11)_CS_$P(PH1,"x",2)_CS_"Callback #1"
 I $G(PH2)]"" S LA7Y=LA7Y_RS_CS_"WPN"_CS_"PH"_CS_CS_$E(PH2,1)_CS_$E(PH2,2,4)_CS_$E(PH2,5,11)_CS_$P(PH2,"x",2)_CS_"Callback #2"
 Q LA7Y
 ;
OBR18(LA7X,LA7FS,LA7ECH) ; Build OBR-18 sequence - Placer's field #1
 ; Call with   LA7X = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-18 sequence
 ;
 N LA7I,LA7Y,LA7Z
 D OBRPF^LA7COBRA
 Q LA7Y
 ;
 ;
OBR19(LA7X,LA7FS,LA7ECH) ; Build OBR-19 sequence - Placer's field #2
 ; Call with LA7X() = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-19 sequence
 ;
 N LA7I,LA7Y,LA7Z
 D OBRPF^LA7COBRA
 Q LA7Y
 ;
 ;
OBR20(LA7X,LA7FS,LA7ECH) ; Build OBR-20 sequence - Filler's field #1
 ; Call with   LA7X = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-20 sequence
 ;
 N LA7I,LA7Y,LA7Z
 D OBRPF^LA7COBRA
 Q LA7Y
 ;
 ;
OBR21(LA7X,LA7FS,LA7ECH) ; Build OBR-21 sequence - Filler's field #2
 ; Call with LA7X() = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-21 sequence
 ;
 N LA7I,LA7Y,LA7Z
 D OBRPF^LA7COBRA
 Q LA7Y
 ;
 ;
OBR22(LA7DT) ; Build OBR-22 sequence - date report completed
 ; Call with LA7DT = FileMan date/time
 ;
 ; Returns OBR-22 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR24(LA7SS) ; Build OBR-24 sequence - diagnostic service id
 ; Call with LA7SS = File #63 subscript^section within subscript
 ;
 ; Returns OBR-24 sequence
 ;
 N LA7Y,LA7X
 D OBR24^LA7COBRA
 Q LA7Y
 ;
 ;
OBR25(LA7FLAG) ; Build OBR-25 sequence - Result status
 ; Call with LA7FLAG = VistA Lab status flag
 ; Returns result status based on HL7 table 0123
 ;
 N LA7Y
 D OBR25^LA7COBRA
 Q LA7Y
 ;
 ;
OBR26(LA7OBX3,LA7OBX4,LA7OBX5,LA7FS,LA7ECH)     ; Build OBR-26 sequence - Parent result
 ; Call with LA7OBX3 = OBX-3 observation id of parent result
 ;           LA7OBX4 = OBX-4 sub-id of parent result
 ;           LA7OBX5 = OBX-5 parent result
 ;             LA7FS = HL7 Field separator
 ;            LA7ECH = HL7 encoding characters
 ;
 N LA7C,LA7SC,LA7Y,LA7Z
 D OBR26^LA7COBRA
 Q LA7Y
 ;
 ;
OBR27(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH) ; Build OBR-27 sequence - Quantity/Timing
 ; Call with  LA7DUR = collection duration
 ;           LA7DURU = duration units (pointer to #64.061)
 ;           LA76205 = test urgency
 ;             LA7FS = HL7 field separator
 ;            LA7ECH = HL encoding characters
 ;
 ; Returns OBR-27 sequence
 ;
 ; Since field is same as ORC-7, use builder for ORC-7 field.
 ;
 Q $$ORC7^LA7CORC(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH)
 ;
 ;
OBR28(LA7VAL,LA7ECH) ;-- Build OBR-28 result copies to
 N LA7Y,OBR281,OBR282,OBR283,OBR284,OBR285,OBR286,OBR289,OBR2810,OBR2813
 I LA7VAL="" Q ""
 S OBR281=$P($G(^VA(200,LA7VAL,"NPI")),U)
 S OBR282=$P($P(^VA(200,LA7VAL,0),U),",")
 S OBR283=$P($P($P(^VA(200,LA7VAL,0),U),",",2)," ")
 S OBR284=$P($P($P(^VA(200,LA7VAL,0),U)," ",2)," ")
 S OBR285=$P($P($P(^VA(200,LA7VAL,0),U)," ",3)," ")
 S OBR286=$P($P($P(^VA(200,LA7VAL,0),U)," ",4)," ")
 S OBR289="NIST-AA-1"
 S OBR2810="L"
 S OBR2813="NPI"
 S $P(LA7Y,$E(LA7ECH))=OBR281
 S $P(LA7Y,$E(LA7ECH),2)=OBR282
 S $P(LA7Y,$E(LA7ECH),3)=OBR283
 S $P(LA7Y,$E(LA7ECH),4)=OBR284
 S $P(LA7Y,$E(LA7ECH),5)=OBR285
 S $P(LA7Y,$E(LA7ECH),6)=OBR286
 S $P(LA7Y,$E(LA7ECH),9)=OBR289
 S $P(LA7Y,$E(LA7ECH),10)=OBR2810
 S $P(LA7Y,$E(LA7ECH),13)=OBR2813
 Q LA7Y
 ;
OBR29(LA7PON,LA7FON,LA7FS,LA7ECH)       ; Build OBR-29 sequence - Parent
 ; Call with LA7PON = parent's placer order number
 ;           LA7FON = parent's filler order nubmer
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ;
 N LA7Y,LA7Z
 D OBR29^LA7COBRA
 Q LA7Y
 ;
 ;
OBR31(OD,OI,OII,LA7FS,LA7ECH) ;-- MU2 build reason for study field 408 BLR MASTER CONTROL file
 N LA7Y,DXI,ODA,DX,DXE,CS
 S CS=$E(LA7ECH)
 S ODA=0 F  S ODA=$O(^LRO(69,OD,1,OI,2,OII,2,ODA)) Q:'ODA!$G(DXI)  D
 . S DXI=$P($G(^LRO(69,OD,1,OI,2,OII,2,ODA,0)),U)
 I $G(DXI) D
 . S DX=$$GET1^DIQ(80,DXI,.01)
 . S DXE=$$GET1^DIQ(80,DXI,3)
 S LA7Y=$S($G(DXI):DX_CS_$E(DXE,1,20)_CS_"I9CDX"_CS_$E(DXE,1,20)_CS_$E(DXE,1,20)_CS_"L"_CS_29_CS_"1.0",1:"")
 Q LA7Y
 ;
OBR32(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-32 sequence - Principle Result Interpreter field
 ; Call with   LA7DUZ = DUZ of verifying user
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-32 sequence
 ;
 N LA7PRI,LA7X
 D OBR32^LA7COBRA
 Q LA7PRI
 ;
 ;
OBR33(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-32 sequence - Assistant Result Interpreter field
 ; Call with   LA7DUZ = DUZ of assistant interpreter
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-33 sequence
 ;
 N LA7ARI,LA7X
 D OBR33^LA7VOBRA
 Q LA7ARI
 ;
 ;
OBR34(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-34 sequence - Technician field
 ; Call with   LA7DUZ = DUZ of techician
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-34 sequence
 ;
 N LA7TECH,LA7X
 D OBR34^LA7VOBRA
 Q LA7TECH
 ;
 ;
OBR35(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-35 sequence - Transcriptionist field
 ; Call with   LA7DUZ = DUZ of transcriptionist
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-35 sequence
 ;
 N LA7TSPT,LA7X
 D OBR35^LA7VOBRA
 Q LA7TSPT
 ;
 ;
OBR44(LA7VAL,LA7FS,LA7ECH) ; Build OBR-44 sequence - Procedure Code
 ; Call with   LA7VAL = Order NLT code
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns       LA7Y = OBR-44 sequence
 ;
 N LA764,LA781,LA7X,LA7Y,LA7Z
 D OBR44^LA7VOBRA
 Q LA7Y
 ;
OBR49(LA7VAL,LA7ECH) ;-- build OBR-49 Results Handling
 N LA7Y,OBR491,OBR492,OBR493,OBR494,OBR495,OBR496,OBR499
 I LA7VAL="" Q ""
 S OBR491="CC"
 S OBR492="Carbon Copy"
 S OBR493="HL70507"
 S OBR494="C"
 S OBR495=$E(OBR492,1,10)
 S OBR496="L"
 S OBR499=OBR492
 S $P(LA7Y,$E(LA7ECH),1)=OBR491
 S $P(LA7Y,$E(LA7ECH),2)=OBR492
 S $P(LA7Y,$E(LA7ECH),3)=OBR493
 S $P(LA7Y,$E(LA7ECH),4)=OBR494
 S $P(LA7Y,$E(LA7ECH),5)=OBR495
 S $P(LA7Y,$E(LA7ECH),6)=OBR496
 S $P(LA7Y,$E(LA7ECH),9)=OBR499
 Q LA7Y
 ;
