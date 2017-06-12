LA7COBX3 ;VA/DALOI/JMC - LAB OBX Segment message builder (MI subscripts) cont'd ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,1018,64,1027,68,1033**;NOV 01, 1997
 ;
 ; Reference to ^DD supported by DBIA #999
 ;
MI ; Build OBX segments for results that are microbiology subscript.
 ; Called by LA7VOBX
 ;
 N I,LA761,LA76305,LA7ALT,LA7ALTCS,LA7CODE,LA7DIV,LA7IENS,LA7LOINC,LA7NLT,LA7OBX,LA7ORS,LA7PARNT,LA7SAVID,LA7SUBFL,LA7VAL,LA7VERP
 ;
 I $P(LRIDT,",",2) S LRIDT(2)=$P(LRIDT,",",2),LRIDT(3)=$P(LRIDT,",",3),LRIDT=$P(LRIDT,",")
 ;
 I '$D(^LR(LRDFN,LRSS,LRIDT)) Q
 ;
 F I=0,1,5,8,11,16 S LA76305(I)=$G(^LR(LRDFN,LRSS,LRIDT,I))
 ;
 S (LA7ALT,LA7ALTCS,LA7CODE,LA7ID,LA7LOINC,LA7NLT,LA7ORS,LA7SAVID,LA7SUBFL,LA7VAL,LA7VERP)=""
 ;
 ; Specimen topography
 S LA761=$P(LA76305(0),"^",5)
 ; Default codes
 S LA7CODE=$$DEFCODE^LA7VHLU5(LRSS,LRSB,LA7CODE,LA761)
 ;
 D SEC,GEN
 ;S LRSPEC=$P($G(LA76305(0)),U,11)   ;MU2 get the microsusept specimen for SPM from collection sample field
 Q
 ;
SEC ; Build section specific fields
 N LA7X,LA7Y
 ;
 ; Urine screen
 I LRSB=11.57 D  Q
 . N LA7ERR
 . S LA7VERP=$P(LA76305(1),"^",3),LA7ORS=$P(LA76305(1),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7COBX(63.05,11.57)
 . S LA7IENS=LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.05,LA7IENS,11.57,"","LA7ERR")
 . S LA7Y="MI-"_LRSB_"^"_$$GET1^DID(63.05,11.57,"","LABEL")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ; Sputum Screen
 I LRSB=11.58 D  Q
 . N LA7ERR
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7COBX(63.05,11.58)
 . S LA7VAL=$P(^LR(LRDFN,LRSS,LRIDT,1),"^",5)
 . S LA7Y="MI-"_LRSB_"^"_$$GET1^DID(63.05,11.58,"","LABEL")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ; Gram stain
 I LRSB=11.6 D  Q
 . N LA7ERR
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7COBX(63.05,11.6)
 . S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.29,LA7IENS,.01,"","LA7ERR")
 . S LA7Y="MI-"_LRSB_"^"_$$GET1^DID(63.29,.01,"","LABEL")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 . ; Setup DoD special coding system
 . I LA7NVAF=1,$P(LA7CODE,"!",2) S LA7ALTCS="99VA64MG"
 ;
 ; Micro organism
 I $P(LRSB,",")=12 D  Q
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7SUBFL=63.3
 . ; Working on colony count
 . I $P(LRSB,",",2)=1 D CC Q
 . ; Working on organism
 . I $G(LRIDT(3))="" D ORG Q
 . ; Working on susceptibilities
 . I $P(LA76305(1),"^",4) S LA7VERP=$P(LA76305(1),"^",4)
 . I $P(LRSB,",",2)<3 D MIC Q
 . I $P(LRSB,",",2)=3 D MICA Q
 ; 
 ; Parasite organism
 I $P(LRSB,",")=16 D  Q
 . S LA7ORS=$P(LA76305(5),"^",2)
 . S LA7VERP=$P(LA76305(5),"^",3)
 . ; Working on organism
 . S LA7SUBFL=63.34 D ORG
 ;
 ; Mycology organism
 I $P(LRSB,",")=20 D  Q
 . S LA7ORS=$P(LA76305(8),"^",2)
 . S LA7VERP=$P(LA76305(8),"^",3)
 . S LA7SUBFL=63.37
 . ; Working on colony count
 . I $P(LRSB,",",2)=1 D CC Q
 . ; Working on organism
 . D ORG
 ;
 ; Acid Fast stain
 I LRSB=24 D  Q
 . N LA7ERR
 . S LA7VERP=$P(LA76305(11),"^",3)
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7COBX(63.05,24)
 . S LA7IENS=LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.05,LA7IENS,24,"","LA7ERR")
 . S LA7Y="MI-"_LRSB_"^"_$$GET1^DID(63.05,24,"","LABEL")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ; Acid Fast stain quantity
 I LRSB=25 D  Q
 . N LA7ERR
 . S LA7VERP=$P(LA76305(11),"^",3)
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7COBX(63.05,25)
 . S LA7IENS=LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.05,LA7IENS,25,"","LA7ERR")
 . S LA7Y="MI-"_LRSB_"^"_$$GET1^DID(63.05,25,"","LABEL")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ; TB organism
 I $P(LRSB,",")=26 D  Q
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7VERP=$P(LA76305(11),"^",5)
 . S LA7SUBFL=63.39
 . ; Working on colony count
 . I $P(LRSB,",",2)=1 D CC Q
 . ; Working on organism
 . I $G(LRIDT(3))="" D ORG Q
 . ; Working on susceptibilities
 . D MIC
 ;
 ; Virology virus
 I $P(LRSB,",")=36 D  Q
 . S LA7ORS=$P(LA76305(16),"^",2)
 . S LA7VERP=$P(LA76305(16),"^",3)
 . ; Working on virus
 . S LA7SUBFL=63.43
 . D ORG
 ;
 ; Antibiotic levels
 I $P(LRSB,",")=28 D  Q
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7SUBFL=63.42
 . S LA7OBX(2)="SN"
 . S LA7X=$G(^LR(LRDFN,LRSS,LRIDT,14,LRIDT(2),0))
 . S $P(LA7CODE,"!",2)="93978.0000"
 . S $P(LA7CODE,"!",3)=$S($P(LA7X,"^",2)="P":44433,$P(LA7X,"^",2)="T":44434,1:23816)
 . S LA7VAL=$P(LA7X,"^",3)
 . S LA7Y="MI-"_$P(LRSB,",")_"-"_$P(LRSB,",",2)_"^"_$P(LA7X,"^")_"^99VA63"
 . S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ;
 Q
 ;
 ;
CC ; Organism's Colony count
 ; If "CFU/ml" found then move units to OBX-6 (Units).
 N LA7X
 ;
 S LA7ID=$P(LRSB,",")_"-"_LRIDT(2)
 S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 S LA7OBX(2)=$$OBX2^LA7COBX(LA7SUBFL,1)
 S LA7VAL=$$GET1^DIQ(LA7SUBFL,LA7IENS,1)
 S LA7X=$$UP^XLFSTR(LA7VAL)
 I LA7X["CFU/ML" D
 . S LA7OBX(6)=$$OBX6^LA7COBX("CFU/ml","",LA7FS,LA7ECH,$G(LA7INTYP))
 . S LA7X("CFU/ml")="",LA7X("CFU/ML")=""
 . S LA7VAL=$$REPLACE^XLFSTR(LA7VAL,.LA7X)
 ;
 S LA7Y="MI-"_$P(LRSB,",")_"-1^"_$$GET1^DID(LA7SUBFL,1,"","LABEL")_"^99VA63"
 S LA7ALT=LA7Y_"^"_LA7Y
 ;
 Q
 ;
 ;
ORG ; Organism
 ;
 N LA7X,LA7Y,X
 ;
 S LA7ID=LRSB_"-"_LRIDT(2)
 S LA7OBX(2)=$$OBX2^LA7COBX(LA7SUBFL,.01)
 S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 S LA7VAL=""
 S LA7X=$$GET1^DIQ(LA7SUBFL,LA7IENS,.01,"I"),LA7X(.01)=$$GET1^DIQ(LA7SUBFL,LA7IENS,.01)
 ;
 S LA7NORG=$$FNDORG(LRDFN,LRIDT,LA7ND,LA7ORG)  ;MU2
 ; Check for SNOMED coding/local coding as alternate
 S X=$$GET1^DIQ(LA7SUBFL,LA7IENS,".01:2")
 ;I X'="" D
 ;. S LA7VAL="E-"_X_"^"_LA7X(.01)_"^SNM",$P(LA7VAL,"^",4,6)=LA7X_"^"_LA7X(.01)_"^99VA61.2"
 ;. I $G(LA7NVAF)'=1 S LA7OBX(2)="CWE",$P(LA7VAL,"^",7,8)="1974^5.2",$P(LA7VAL,"^",9)=LA7X(.01)
 I X'="" D  ;mu2
 . S LA7VAL=X_"^"_LA7X(.01)_"^SCT",$P(LA7VAL,"^",4,6)=$E(LA7X(.01),1,3)_"^"_LA7X(.01)_"^L"
 . I $G(LA7NVAF)'=1 S LA7OBX(2)="CWE",$P(LA7VAL,"^",7,8)="1974^5.2",$P(LA7VAL,"^",9)=LA7X(.01)
 ;
 ; If no SNOMED then use local coding as primary
 I LA7VAL="" D
 . S LA7VAL=LA7X_"^"_LA7X(.01)_"^L"
 . I $G(LA7NVAF)'=1 S LA7OBX(2)="CWE",$P(LA7VAL,"^",7)="5.2",$P(LA7VAL,"^",9)=LA7X(.01)
 ;
 S LA7Y="MI-"_$P(LRSB,",")_"-.01^"_$$GET1^DID(LA7SUBFL,.01,"","LABEL")_"^L"
 S LA7ALT=LA7Y_"^"_LA7Y
 ;
 ;TODO mu2 may need this back in a different way
 ;S LA7OBX(8)=$$OBX8^LA7COBX("A")
 ;
 ; Set flag to save sub-id for parent-child relationship
 S LA7SAVID=1
 Q
 ;
 ;
MIC ; Organism's susceptibilities
 ;
 N LA7IENS,LA7SUB
 ;
 ; Bact or TB organism
 S LA7SUB=$S($P(LRSB,",")=12:3,1:12)
 ;
 S LA7OBX(2)=$$OBX2^LA7COBX(62.06,.01)
 ;
 ; Determine local code for antibiotic if not mapped to NLT or in file #62.06
 ;  - Use file #62.06 entry if available otherwise generate from drug node field in file #63
 ;    also used to convey local display name in 9th component
 S LA7X=""
 I $P(LRSB,",")=12 D
 . S LA7X=$O(^LAB(62.06,"AD",$P(LRSB,",",2),0))
 . I LA7X S LA7ALT=LA7X_"^"_$$GET1^DIQ(62.06,LA7X_",",.01)_"^L",LA7ALT=LA7ALT_"^"_LA7ALT
 I LA7ALT="" D
 . S LA7X=$P(LRSB,",",2),LA7Y=$O(^DD(LA7SUBFL,"GL",LA7X,1,0))
 . I LA7Y<1 Q
 . S LA7ALT="MIAB"_$P(LRSB,",")_"-"_$P(LRSB,",",2)_"^"_$$GET1^DID(LA7SUBFL,LA7Y,"","LABEL")_"^L"
 . S LA7ALT=LA7ALT_"^"_LA7ALT
 ;
 S LA7X=$G(^LR(LRDFN,"MI",LRIDT,LA7SUB,LRIDT(2),LRIDT(3)))
 S LA7VAL=$P(LA7X,"^")
 I LA7VAL'="" D
 . I "SIR"[$E(LA7VAL) S LA7OBX(8)=$$OBX8^LA7COBX($E(LA7VAL)) Q
 . I "SIR"[$E($P(LA7X,"^",2)) D  Q
 .. S LA7OBX(8)=$$LOOKTAB^LA7CQRY1("HL7","0078",$E($P(LA7X,"^",2)),$E(LA7ECH))
 .. S $P(LA7OBX(8),$E(LA7ECH),7)="2.7"
 .. ;S LA7OBX(8)=$$OBX8^LA7COBX($E($P(LA7X,"^",2)))
 ;
 ; Determine access screen for this susceptibility
 I $P(LA7X,"^",3)="" S $P(LA7X,"^",3)="A"
 I $G(LA7INPT),$G(LRSS)="MI",$G(LA7OBRSN)>1 S LA7VAL="S"  ;mu2 inpatient mu2 micro
 S LA7OBX(13)=$$OBX13^LA7COBX($P(LA7X,"^",3),$S($G(LA7INTYP)=30:"MIS-HDR",1:"MIS"),LA7FS,LA7ECH)
 ;
 Q
 ;
 ;
MICA ;  Bacteria organism's susceptibilities - free text
 ;
 N LA7SUB,LA7X
 S LA7OBX(2)="NM"
 ;
 ; Bact organism
 S LA7SUB=3
 ;
 ; Determine local code for free text antibiotic also used to convey local display name in 9th component
 S LA7X=$G(^LR(LRDFN,"MI",LRIDT,LA7SUB,LRIDT(2),3,LRIDT(3),0))
 S LA7ALT="MIAB"_$P(LRSB,",")_"-"_$P(LRSB,",",2)_"-"_$P(LRSB,",",3)_"^"_$P(LA7X,"^")_$S($P(LRSB,",",3)=1:" MIC",1:" MBC")_"^L"
 S LA7ALT=LA7ALT_"^"_LA7ALT
 S $P(LA7CODE,"!",2)="87565.0000"
 S $P(LA7CODE,"!",3)=$S($P(LRSB,",",3)=1:21070,1:23658)
 ;
 S LA7VAL=$P(LA7X,"^",$S($P(LRSB,",",3)=1:2,1:3))
 ;
 S LA7OBX(6)="UG/ML"
 S LA7OBX(8)=""
 ;
 Q
 ;
 ;
GEN ; Fields common to all MI OBX segments.
 ;
 ; Initialize OBX segment
 S LA7OBX(0)="OBX"
 S LA7OBX(1)=$$OBX1^LA7COBX(.LA7OBXSN)
 ;
 N LA7WKI
 ;I $P(LA7CODE,"!",2)]"",$G(LA7953)="" S LA7WKI=$O(^LAM("E",$P(LA7CODE,"!",2),0))  ;will this break script #3 & #4 MU2
 ;need to figure out these codes here for micro
 I $P(LA7CODE,"!",2)]"" S LA7WKI=$O(^LAM("E",$P(LA7CODE,"!",2),0))  ;will this break script #9 MU2
 ;the following 2 lines will look up the org if there
 ;I $G(LA7NORG) S LA7WKI=$O(^LAB(61.2,LA7NORG,9,"B",0))
 I $G(LA7WKI) S LA7953=$P($G(^LAM(LA7WKI,9)),U)
 ;MU2 added 3 below lines for NIST 9 testing, this seems to work for both NIST 4 and NIST 9, will leave this in for now, until retesting
 I $G(LA7NORG),$G(LA7OBRSN)=1 D
 . S LA7WKI=$O(^LAB(61.2,LA7NORG,9,"B",0))
 . S LA7953=$P($G(^LAM(LA7WKI,9)),U)
 S LA7OBX(3)=$$OBX3^LA7COBX($P(LA7CODE,"!",2),$S($G(LA7953):LA7953,1:$P(LA7CODE,"!",3)),LA7ALT,LA7FS,LA7ECH,$G(LA7INTYP))
 I $G(LA7INPT) S $P(LA7OBX(3),$E(LA7ECH),9)=$E($P(LA7OBX(3),$E(LA7ECH),2),1,30)  ;mu2 inpatient
 K LA7NORG
 ;S LA7OBX(3)=$$OBX3^LA7COBX($P(LA7CODE,"!",2),$P(LA7CODE,"!",3),LA7ALT,LA7FS,LA7ECH,$G(LA7INTYP))
 ;
 ; Change normal coding system for DoD special
 I LA7NVAF=1,LA7ALTCS'="" D
 . F I=3,6 I $P(LA7OBX(3),$E(LA7ECH,1),I)="99VA64" S $P(LA7OBX(3),$E(LA7ECH,1),I)=LA7ALTCS Q
 ;
 I $G(LA7INPT) S LA7OBX(4)=$P($G(LA7OBXSN),"-",2)  ;mu2 inpatient micro
 I $G(LA7INPT),$G(LA7OBX(4))="" S LA7OBX(4)=1
 ; Test value
 K LA75UNIT
 S LA7OBX(5)=$$OBX5^LA7COBX(LA7VAL,LA7OBX(2),LA7FS,LA7ECH)
 I $G(LA7OBX(5))["-" S LA7OBX(5)=$P(LA7OBX(5),"-",2)
 I $G(LA7OBX(2))="SN",$P(LA7OBX(5)," ",2)]"" D
 . S LA75UNIT=$P(LA7OBX(5)," ",2)
 . S LA7OBX(5)=$P(LA7OBX(5)," ")
 ;
 ;  units
 I $G(LA7INPT),$G(LA75UNIT)="" S LA75UNIT="ug/mL"  ;mu2 inpatient micro
 I $G(LA75UNIT)]"" D
 . S $P(LA7OBX(6),$E(LA7ECH))=LA75UNIT
 . S $P(LA7OBX(6),$E(LA7ECH),2)=$P($$LOOKTAB^LA7CQRY1("","UCUM",LA75UNIT,$E(LA7ECH)),$E(LA7ECH),2)
 . S $P(LA7OBX(6),$E(LA7ECH),3)="UCUM"
 . S $P(LA7OBX(6),$E(LA7ECH),4)=LA75UNIT
 . S $P(LA7OBX(6),$E(LA7ECH),6)="L"
 . S $P(LA7OBX(6),$E(LA7ECH),7)="1.8.2"
 ; Set sub-id and save for constructing parents
 I LA7ID'="" D
 . S LA7OBX(4)=$$OBX4^LA7COBX(LA7ID,LA7FS,LA7ECH)
 . I $G(LA7INPT),$G(LA7OBX(4))["-" S LA7OBX(4)=$P(LA7OBX(4),"-",2)
 . I $G(LA7INPT),$G(LA7OBX(4))="" S LA7OBX(4)=1
 . I LA7SAVID D
 . . F I=1,2 S LA7ID(LA7ID,I)=LA7OBX(I+2)
 . . I $G(HL("VER"))="2.2" S LA7ID(LA7ID,3)=LA7OBX(5) Q
 . . F I=2,4 I $P(LA7OBX(5),$E(LA7ECH,1),I)'="" S LA7ID(LA7ID,3)=$P(LA7OBX(5),$E(LA7ECH,1),I) Q
 ;
 ; Order result status - "P"artial, "F"inal , "A"mended results
 ; If no status from individual components then use status from zeroth node.
 ; If no release date then pending else final
 ; If amended, overrides all other status
 I $G(LA7INPT) S LA7OBX(8)="A"  ;mu2 inpatient
 I LA7ORS="" S LA7ORS=$S('$P(LA76305(0),"^",3):"P",1:"F")
 I $P(LA76305(0),"^",9) S LA7ORS="A"
 S LA7OBX(11)=$$OBX11^LA7COBX(LA7ORS)
 ;
 S LA7DIV=$P($G(^LR(LRDFN,LRSS,LRIDT,"RF")),"^")
 I LA7DIV="",$$DIV4^XUSER(.LA7DIV,$P(LA76305(0),"^",4)) S LA7DIV=$O(LA7DIV(0))
 ;
 ; Observation date/time - collection date/time per HL7 standard
 I $P(LA76305(0),"^") S LA7OBX(14)=$$OBX14^LA7COBX($P(LA76305(0),"^"))
 ;
 ; Facility that performed the testing
 S LA7OBX(15)=$$OBX15^LA7COBX(LA7DIV,LA7FS,LA7ECH)
 ;
 ; Person that verified the test
 I $P(LA76305(0),"^",4) S LA7VERP=$P(LA76305(0),"^",4)
 I LA7VERP S LA7OBX(16)=$$OBX16^LA7COBX(LA7VERP,LA7DIV,LA7FS,LA7ECH)
 ;
 ; Date/time of the analysis
 I $P(LA76305(0),"^",10)'="" S LA7OBX(19)=$$OBX19^LA7COBX($P(LA76305(0),"^",10))
 I $G(LA7OBX(19))="" S LA7OBX(19)=$G(LA7OBX(14))
 ;
 ; Performing organization name/address
 I LA7DIV="" S LA7DIV=DUZ(2)  ;MU2
 I LA7DIV'="" D
 . N LA7DT
 . S LA7OBX(23)=$$OBX23^LA7COBX(4,LA7DIV,LA7FS,LA7ECH)
 . S $P(LA7OBX(23),$E(LA7ECH,1),6)="CLIA"_$E(LA7ECH,4)_"2.16.840.1.113883.4.7"_$E(LA7ECH,4)_"ISO"
 . S $P(LA7OBX(23),$E(LA7ECH,1),7)="XX"
 . S $P(LA7OBX(23),$E(LA7ECH,1),10)=$P($G(^DIC(4,LA7DIV,99)),U)
 . S LA7DT=$S($P(LA76305(0),"^",3):$P(LA76305(0),"^",3),1:$$NOW^XLFDT)
 . S LA7OBX(24)=$$OBX24^LA7COBX(4,LA7DIV,LA7DT,LA7FS,LA7ECH)
 . S $P(LA7OBX(24),$E(LA7ECH),6)="USA"
 . S $P(LA7OBX(24),$E(LA7ECH),7)="L"
 . S $P(LA7OBX(24),$E(LA7ECH),9)=$P(LA7OBX(24),$E(LA7ECH),5)  ;MU2 county code same as zip for now
 ;
 S LA7OBX(25)=$$OBX25^LA7COBX($$GET1^DIQ(9009029,DUZ(2),3027,"I"),DUZ(2),LA7FS,LA7ECH)
 S $P(LA7OBX(25),$E(LA7ECH),9)="NPI"_$E(LA7ECH,4)_"2.16.840.1.113883.4.6"_$E(LA7ECH,4)_"ISO"
 S $P(LA7OBX(25),$E(LA7ECH),10)="L"
 S $P(LA7OBX(25),$E(LA7ECH),13)="NPI"
 S $P(LA7OBX(25),$E(LA7ECH),14)="NPI_Facility"_$E(LA7ECH,4)_"2.16.840.1.113883.3.72.5.26"_$E(LA7ECH,4)_"ISO"
 S $P(LA7OBX(25),$E(LA7ECH),21)=$P(LA7OBX(25),$E(LA7ECH),6)
 I $G(LA7INPT) S $P(LA7OBX(25),$E(LA7ECH),7)=""  ;mu2 inpatient
 ;
 D BUILDSEG^LA7VHLU(.LA7OBX,.LA7ARRAY,LA7FS)
 ;
 Q
 ;
FNDORG(DF,IDT,ND,ORG) ;-- return the org IEN for file 61.2
 N ORGI
 S ORGI=$P($G(^LR(DF,LRSS,IDT,ND,ORG,0)),U)
 Q ORGI
 ;
