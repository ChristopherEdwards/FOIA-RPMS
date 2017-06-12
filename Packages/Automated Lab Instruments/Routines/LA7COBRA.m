LA7COBRA ;VA/DALOI/JMC - LAB OBR segment builder (cont'd); 22-Oct-2013 09:22 ; MAW
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,1018,64,1027,68,1033**;NOV 01, 1997
 ;
 Q
 ;
 ;
OBR2 ; Build OBR-2 sequence - placer's specimen id
 ;
 S LA7ID=$$CHKDATA^LA7VHLU3(LA7ID,LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),1)=LA7ID
 I $G(LA7ID("NMSP"))'="" S $P(LA7Y,$E(LA7ECH,1),2)=LA7ID("NMSP")
 I $G(LA7ID("SITE"))'="" D
 . S LA7X=$$FACDNS^LA7VHLU2(LA7ID("SITE"),LA7FS,LA7ECH,1)
 . I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),3)=$P(LA7X,$E(LA7ECH),2)
 . I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),4)=$P(LA7X,$E(LA7ECH),3)
 ;I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7Y,$E(LA7ECH),2)="NIST EHR"  ;mu2 inpatient micro
 I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),3)="2.16.840.1.113883.3.72.5.24"
 I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),4)="ISO"
 Q
 ;
 ;
OBR3 ; Build OBR-3 sequence - filler's specimen id
 ;
 S LA7ID=$$CHKDATA^LA7VHLU3(LA7ID,LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),1)=LA7ID
 I $G(LA7ID("NMSP"))'="" S $P(LA7Y,$E(LA7ECH,1),2)=LA7ID("NMSP")
 I $G(LA7ID("SITE"))'="" D
 . S LA7X=$$FACDNS^LA7VHLU2(LA7ID("SITE"),LA7FS,LA7ECH,1)
 . I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),3)=$P(LA7X,$E(LA7ECH),2)
 . I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),4)=$P(LA7X,$E(LA7ECH),3)
 I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),3)="2.16.840.1.113883.3.72.5.24"
 I $G(LA7INPT),$G(LRSS)'="MI" S $P(LA7Y,$E(LA7ECH),4)="ISO"
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH),3)=""
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH),4)=""
 Q
 ;
 ;
OBR4 ; Build OBR-4 sequence - Universal service ID
 ;
 S LA764=0,LA7Y=""
 ; specify component position - primary/alternate
 S LA7COMP=0
 ;
 ; Send non-VA test codes as first coding system
 I LA7ALT'="" D
 . N I
 . F I=1:1:3 S $P(LA7Y,$E(LA7ECH),LA7COMP+I)=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",I),LA7FS_LA7ECH)
 . S LA7COMP=LA7COMP+I
 ;
 ; Send NLT test codes as primary unless non-VA codes then send as alternate code
 ;lets try to get the loinc pointer here FOR MU2
 I LA7NLT'="" D
 . S LA764=$O(^LAM("E",LA7NLT,0)),LA7Z=""
 . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . I LA7Z="" D
 . . N LA7642
 . . S LA764=$O(^LAM("E",$P(LA7NLT,".")_".0000",0))
 . . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . . S LA7642=$O(^LAB(64.2,"F","."_$P(LA7NLT,".",2),0))
 . . I LA764,LA7642 S LA7Z=LA7Z_"~"_$$GET1^DIQ(64.2,LA7642_",",.01,"I")
 . I LRSS="MI",$G(LA7OBRSN)>1 D
 .. S LA7953=$P($G(^LAM(LA764,9)),U)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+4)=$$CHKDATA^LA7VHLU3(LA7NLT,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+5)=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+6)="L"
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+9)=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . ;S LA7COMP=LA7COMP+3
 ;I $G(LA760)]"" D
 ;. N SPI
 ;. S SPI=0 F  S SPI=$O(^LAB(60,LA760,1,SPI)) Q:'SPI!($G(LA7953))  D
 ;.. S LA7953=$G(^LAB(60,LA760,1,SPI,95.3))
 ;N LA7WKI
 ;I $G(LA7NLT)]"" S LA7WKI=$O(^LAM("E",LA7NLT,0))
 ;I $G(LA7WKI) S LA7953=$P($G(^LAM(LA7WKI,9)),U)
 ;MU2 we are going to use the IHS LOINC code field for all OBR segments
 I $G(LA7953)="" S LA7953=$P($G(^LAB(60,LA760,9999999)),U,2)  ;MU2 for panels since no site specimen
 I $G(LA7953)'="" D
 . N LA7IENS,LA7Z
 . S LA7953=$P(LA7953,"-"),LA7IENS=LA7953_","
 . D GETS^DIQ(95.3,LA7IENS,".01;80;99.99","E","LA7X")
 . ; Invalid code???
 . I $G(LA7X(95.3,LA7IENS,.01,"E"))="" Q
 . S LA7Z=LA7X(95.3,LA7IENS,.01,"E")
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),LA7COMP+1)=LA7Z
 . S LA7Z=$G(LA7X(95.3,LA7IENS,80,"E"))
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),LA7COMP+2)=LA7Z
 . S $P(LA7Y,$E(LA7ECH,1),LA7COMP+3)="LN"
 . S LA7COMP=LA7COMP+4
 ;
 ; Send file #60 test name if available and no alternate
 I LA7COMP<4,LA760 D
 . S LA7TN=$$GET1^DIQ(60,LA760_",",.01)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+1)=LA760
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+2)=$$CHKDATA^LA7VHLU3(LA7TN,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+3)="L"
 ;
 S $P(LA7Y,$E(LA7ECH),7)="2.40"
 S $P(LA7Y,$E(LA7ECH),8)="1.0"
 I $P(LA7Y,$E(LA7ECH),4)="",$G(LA7INPT) D  ;mu2 inpatient
 . S $P(LA7Y,$E(LA7ECH),4)=$P(LA7Y,$E(LA7ECH))
 . S $P(LA7Y,$E(LA7ECH),5)=$P(LA7Y,$E(LA7ECH),2)
 . S $P(LA7Y,$E(LA7ECH),6)="99USI"
 . S $P(LA7Y,$E(LA7ECH),9)=$E($P(LA7Y,$E(LA7ECH),2),1,20)
 Q
 ;
 ;
OBR9 ; Build OBR-9 sequence - collection volume
 ;
 ; Collection volume
 S $P(LA7Y,$E(LA7ECH,1))=LA7VOL
 ;
 I LA764061 D
 . S LA7IENS=LA764061_","
 . D GETS^DIQ(64.061,LA7IENS,".01;1","E","LA7Y")
 . ; Collection Volume units code
 . S $P(LA7X,$E(LA7ECH,4),1)=$G(LA7Y(64.061,LA7IENS,.01,"E"))
 . ; Collection Volume units text
 . S $P(LA7X,$E(LA7ECH,4),2)=$$CHKDATA^LA7VHLU3($G(LA7Y(64.061,LA7IENS,1,"E")),LA7FS_LA7ECH)
 . ; LOINC coding system
 . S $P(LA7X,$E(LA7ECH,4),3)="LN"
 . S $P(LA7Y,$E(LA7ECH,1),2)=LA7X
 ;
 Q
 ;
 ;
OBR24 ; Build OBR-24 sequence - diagnostic service id
 ;
 ; Code non-MI subscripts
 I $P(LA7SS,"^")'="MI" D  Q
 . S LA7X=$P(LA7SS,"^")
 . S LA7Y=$S(LA7X="CH":"CH",LA7X="SP":"SP",LA7X="CY":"CP",LA7X="EM":"PAT",LA7X="AU":"PAT",LA7X="BB":"BLB",1:"LAB")
 ;
 ; Code MI subscripts
 S LA7X=$P(LA7SS,"^",2)
 S LA7Y=$S(LA7X=11:"MB",LA7X=14:"PAR",LA7X=18:"MYC",LA7X=22:"MCB",LA7X=33:"VR",1:"MB")
 ;
 Q
 ;
 ;
OBR25 ; Build OBR-25 sequence - Result status
 ;
 S LA7Y=""
 ;
 I LA7FLAG="F" S LA7Y="F"
 I LA7FLAG="P" S LA7Y="P"
 I LA7FLAG="A" S LA7Y="A"
 I LA7FLAG="C" S LA7Y="C"
 I LA7Y="" S LA7Y="F"  ;MU2
 ;
 Q
 ;
 ;
OBR26 ; Build OBR-26 sequence - Parent result
 ;
 S LA7Y=""
 ;
 ; Move component into sub-component position
 ; Translate component character to sub-component character
 S LA7C=$E(LA7ECH,1),LA7SC=$E(LA7ECH,4)
 ;
 ; Parent result observation identifier in 1st component
 I LA7OBX3'="" S $P(LA7Y,$E(LA7ECH,1),1)=$TR(LA7OBX3,LA7C,LA7SC)
 ;
 ; Parent sub-id in 2nd component
 I LA7OBX4'="" S $P(LA7Y,$E(LA7ECH,1),2)=$TR(LA7OBX4,LA7C,LA7SC)
 ;
 ; Parent test result in 3rd component
 I LA7OBX5'="" S $P(LA7Y,$E(LA7ECH,1),3)=$TR(LA7OBX5,LA7C,LA7SC)
 I $G(LA7INPT),$G(LA7ADDON) D
 . N LNI
 . S LNI=$P($G(^LAB(60,LA7ADDON,9999999)),U,2)
 . Q:'LNI
 . S $P(LA7Y,$E(LA7ECH,1),1)=$TR($P($G(LA7STOR(LNI)),"*"),LA7C,LA7SC)
 . S $P(LA7Y,$E(LA7ECH,1),2)=$P($G(LA7STOR(LNI)),"*",2)
 I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7Y,$E(LA7ECH),2)=$G(LA7OBRSN)-1
 I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7Y,$E(LA7ECH),3,9)=""  ;mu2 inpatient micro
 ;I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH),2)=$G(LA7OBRSN)-1
 ;I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH),3)=""  ;mu2 inpatient
 ;
 Q
 ;
 ;
OBR29 ; Build OBR-29 sequence - Parent
 ;
 S LA7Y=""
 ;
 I $G(LA7PON)'="" D
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7PON,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),1)=LA7Z
 . I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7Y,$E(LA7ECH,4),2)="LR"
 . I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH,4),2)="LR"
 ;
 I $G(LA7FON)'="" D
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7FON,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),2)=LA7Z
 N LA7M
 S LA7M=$P(LA7Y,$E(LA7ECH),2)
 S $P(LA7M,$E(LA7ECH,4),2)="LIS"
 I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7M,$E(LA7ECH,4),2)="LR"
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7M,$E(LA7ECH,4),2)="LR"
 S $P(LA7M,$E(LA7ECH,4),3)="2.16.840.1.113883.3.72.6.27"
 I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7M,$E(LA7ECH,4),3)=""
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7M,$E(LA7ECH,4),3)="2.16.840.1.113883.3.72.5.24"
 S $P(LA7M,$E(LA7ECH,4),4)="ISO"
 I $G(LA7INPT),$G(LRSS)="MI" S $P(LA7M,$E(LA7ECH,4),4)=""
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7M,$E(LA7ECH,4),4)="ISO"
 I $G(LA7INPT),$G(LA7ADDON) S $P(LA7Y,$E(LA7ECH))=LA7M
 S $P(LA7Y,$E(LA7ECH),2)=LA7M
 ;
 Q
 ;
 ;
OBRPF ; Build OBR-18,19,20,21 Placer/Filler #1/#2
 ;
 S (LA7Y,LA7Z)="",LA7I=0
 F  S LA7I=$O(LA7X(LA7I)) Q:'LA7I  S $P(LA7Z,"^",LA7I)=LA7X(LA7I)
 S LA7Y=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 Q
 ;
 ;
OBR32 ; Build OBR-32 sequence - Principle Result Interpreter field
 ;
 S LA7X=$$XCN^LA7CHLU9(LA7DUZ,LA7DIV,LA7FS,LA7ECH,0,2)
 S LA7X=$TR(LA7X,$E(LA7ECH),$E(LA7ECH,4))  ;MU2
 S $P(LA7PRI,$E(LA7ECH))=$P(LA7X,$E(LA7ECH,4),1,9)
 ;I LA7DIV S $P(LA7PRI,$E(LA7ECH),7)=$$FACDNS^LA7VHLU2(LA7DIV,LA7FS,LA7ECH,2)
 Q
 ;
 ;
OBR33 ; Build OBR-32 sequence - Assistant Result Interpreter field
 ;
 S LA7X=$$XCN^LA7CHLU9(LA7DUZ,LA7DIV,LA7FS,LA7ECH,1,2)
 S $P(LA7ARI,$E(LA7ECH))=$P(LA7X,$E(LA7ECH,4),1,9)
 I LA7DIV S $P(LA7ARI,$E(LA7ECH),7)=$$FACDNS^LA7VHLU2(LA7DIV,LA7FS,LA7ECH,2)
 Q
 ;
OBR34 ; Build OBR-34 sequence - Technician field
 ;
 S LA7X=$$XCN^LA7VHLU9(LA7DUZ,LA7DIV,LA7FS,LA7ECH,1,1)
 S $P(LA7TECH,$E(LA7ECH))=$P(LA7X,$E(LA7ECH,4),1,9)
 I LA7DIV S $P(LA7TECH,$E(LA7ECH),7)=$$FACDNS^LA7VHLU2(LA7DIV,LA7FS,LA7ECH,2)
 Q
 ;
 ;
OBR35 ; Build OBR-35 sequence - Transcriptionist field
 ;
 S LA7X=$$XCN^LA7VHLU9(LA7DUZ,LA7DIV,LA7FS,LA7ECH,1,1)
 S $P(LA7TSPT,$E(LA7ECH))=$P(LA7X,$E(LA7ECH,4),1,9)
 I LA7DIV S $P(LA7TSPT,$E(LA7ECH),7)=$$FACDNS^LA7VHLU2(LA7DIV,LA7FS,LA7ECH,2)
 Q
 ;
 ;
OBR44 ; Build OBR-44
 ;
 S (LA7X,LA7Y,LA7Z)=""
 ;
 I LA7VAL="" Q
 ;
 ; Send NLT result code
 S LA764=$O(^LAM("E",LA7VAL,0))
 I LA764 S LA7X=$P($G(^LAM(LA764,0)),"^")
 ;
 ; If suffixed and not setup then construct from primary and suffix code.
 I LA7X="" D
 . N LA7642
 . S LA764=$O(^LAM("E",$P(LA7VAL,".")_".0000",0))
 . I LA764 S LA7X=$$GET1^DIQ(64,LA764_",",.01,"I")
 . S LA7642=$O(^LAB(64.2,"F","."_$P(LA7VAL,".",2),0))
 . I LA764,LA7642 S LA7X=LA7X_"~"_$$GET1^DIQ(64.2,LA7642_",",.01,"I")
 ;
 I LA7X'="" S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
 S $P(LA7Z,$E(LA7ECH,1),1)=LA7VAL
 S $P(LA7Z,$E(LA7ECH,1),2)=LA7X
 S $P(LA7Z,$E(LA7ECH,1),3)="99VA64"
 ;S LA7X=$$GET1^DID(64,"","","PACKAGE REVISION DATA")
 ;S $P(LA7Z,$E(LA7ECH,1),7)=LA7X
 S LA7Y=LA7Z
 ;
 ; Check for and build CPT code in primary, move NLT to alternate
 I LA764="" Q
 I '$D(^LAM("AD",LA764,"CPT")) Q
 S LA7X=$O(^LAM("AD",LA764,"CPT",0))
 S LA781=+$P($G(^LAM(LA764,4,LA7X,0)),"^")
 S LA7X=$$CPT^ICPTCOD(LA781,DT,1)
 S LA7Z=$P(LA7X,"^",2)
 S $P(LA7Z,$E(LA7ECH,1),2)=$$CHKDATA^LA7VHLU3($P(LA7X,"^",3),LA7FS_LA7ECH)
 S $P(LA7Z,$E(LA7ECH,1),3)=$S($P(LA7X,"^",5)="C":"C4",$P(LA7X,"^",5)="HCPCS":"HCPCS",1:"L")
 S LA7Y=LA7Z_$E(LA7ECH,1)_$P(LA7Y,$E(LA7ECH,1),1,3)
 ;S $P(LA7Y,$E(LA7ECH,1),8)=$P(LA7Y,$E(LA7ECH,1),7)
 ;S $P(LA7Y,$E(LA7ECH,1),7)=$P(LA7X,"^",6)
 ;
 Q
