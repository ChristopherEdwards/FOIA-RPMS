LA7VORC ;VA/DALOI/JMC - LAB ORC Segment message builder ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,1027**;NOV 01, 1997;Build 9
 ;
 Q
 ;
ORC1(LA7TYP) ; Build ORC-1 sequence - Order control
 ; Call with LA7TYP = order type from table 0119
 ;
 Q LA7TYP
 ;
 ;
ORC2(LA7VAL,LA7FS,LA7ECH) ; Build ORC-2 sequence - Placer order number
 ; Call with  LA7VAL = accession number/UID
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 N LA7Y
 ;
 S $P(LA7Y,$E(LA7ECH),1)=$$CHKDATA^LA7VHLU3(LA7VAL,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
ORC3(LA7VAL,LA7FS,LA7ECH) ; Build ORC-3 sequence - Filler order number
 ; Call with  LA7VAL = accession number/UID
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 N LA7Y
 ;
 S $P(LA7Y,$E(LA7ECH),1)=$$CHKDATA^LA7VHLU3(LA7VAL,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
ORC4(LA7VAL,LA7FS,LA7ECH) ; Build ORC-4 sequence - Placer group number
 ; Call with  LA7VAL = LEDI - shipping manifest number
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ; Returns ORD-4 sequence
 ;
 N LA7Y
 ;
 S $P(LA7Y,$E(LA7ECH),1)=$$CHKDATA^LA7VHLU3(LA7VAL,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
ORC5(LA7VAL,LA7FS,LA7ECH) ; Build ORC-5 sequence - Order status
 ; Call with  LA7VAL = order status
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ; Returns ORC-5 sequence
 ;
 N LA7Y
 ;
 I LA7VAL="CM" S LA7Y="CM"
 ;
 Q LA7Y
 ;
 ;
ORC7(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH) ; Build ORC-7 sequence - Quantity/Timing
 ; Call with  LA7DUR = collection duration
 ;           LA7DURU = duration units (pointer to #64.061)
 ;           LA76205 = test urgency
 ;             LA7FS = HL field separator
 ;            LA7ECH = HL encoding characters
 ;
 ; Returns ORC-7 sequence
 ;
 N LA7X,LA7Y
 ;
 I LA7DUR'="",LA7DURU D
 . S LA7X=$$GET1^DIQ(64.061,LA7DURU_",",2) ; duration units
 . S $P(LA7Y,$E(LA7ECH,1),3)=$$CHKDATA^LA7VHLU3(LA7X_LA7DUR,LA7FS_LA7ECH)
 ;
 I LA76205 D
 . S LA7X=$$GET1^DIQ(64.061,+$$GET1^DIQ(62.05,LA76205_",",4,"I")_",",2) ; Urgency
 . S $P(LA7Y,$E(LA7ECH,1),6)=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
 ;
 Q LA7Y
 ;
 ;
ORC9(LA7DT) ; Build ORC-9 sequence - date/time of transaction
 ; Call with LA7DT = order date/time
 ;
 ; Returns ORC-9 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
ORC12(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build ORC-12 sequence - Ordering provider
 ; Call with   LA7DUZ = DUZ of ordering provider
 ;             LA7DIV = Facility (division) of provider
 ;             LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns ORC-12 sequence
 ; Also used to build OBR-16 sequence
 ;
 ;Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 ;cmi/maw 3/10/2010 modified to add UPIN
 N LA7PRV,LA7ORC12
 S LA7PRV=$$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 S LA7ORC12=$$GET1^DIQ(200,LA7DUZ,41.99,"I")_HLCOMP_$P(LA7PRV,HLCOMP,2,7)
 S $P(LA7ORC12,HLCOMP,8)="N"  ;cmi/maw includes NPI indicator
 Q $G(LA7ORC12)
 ;cmi/maw 3/10/2010 end of mods
 ;
 ;
ORC17(LA74,LA7FS,LA7ECH) ; Build ORC-17 sequence - Entering organization
 ; Call with   LA74 = ien of institution in file #4
 ;                    if null/undefined then use Kernel Site file.
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns ORC-17 sequence (ID^text^99VA4)
 ;
 Q $$INST^LA7VHLU4(LA74,LA7FS,LA7ECH)
 ;
 ;
ORC21(LA74,LA7FS,LA7ECH) ; Build ORC-21 sequence - Ordering facility name
 ; Call with   LA74 = ien of institution in file #4
 ;                    if null/undefined then use Kernel Site file.
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns ORC-21 sequence
 ;
 N LA7X,LA7Y
 ;
 I $G(LA74)<1 S LA74=0
 S LA7X=$$NAME^XUAF4(LA74)
 S LA7Y=""
 ;
 Q LA7Y
 ;
 ;
ORC22(LA74,LA7DT,LA7FS,LA7ECH) ; Build ORC-22 sequence - Ordering facility address
 ; Call with   LA74 = ien of institution in file #4
 ;                    if null/undefined then use Kernel Site file.
 ;            LA7DT = "as of" date in FileMan format
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns ORC-22 sequence
 ;
 N LA7X,LA7Y
 ;
 S LA7X=$$PADD^XUAF4(LA74)
 S LA7Y=""
 ;
 Q LA7Y
 ;
 ;
ORC23(LA74,LA7DT,LA7FS,LA7ECH) ; Build ORC-23 sequence - Ordering facility phone number
 ; Call with   LA74 = ien of institution in file #4
 ;                    if null/undefined then use Kernel Site file.
 ;            LA7DT = "as of" date in FileMan format
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns ORC-23 sequence
 ;
 N LA7Y
 ;
 S LA7Y=""
 ;
 Q LA7Y
 ;
 ;
ORC24(LA7200,LA7DT,LA7FS,LA7ECH) ; Build ORC-24 sequence - Ordering provider address
 ; Call with LA7200 = ien of provider in file #200
 ;            LA7DT = "as of" date in FileMan format
 ;            LA7FS = HL field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns ORC-24 sequence
 ;
 N LA7Y
 ;
 S LA7Y=""
 ;
 Q LA7Y
