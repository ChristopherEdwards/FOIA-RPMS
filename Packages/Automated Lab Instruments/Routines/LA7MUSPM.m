LA7MUSPM ;ihs/cmi/maw - MU2 SPM segment utility ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;BLR IHS REFERENCE LAB;**1033**;NOV 01, 1997
 ;
SPM2(CS,SC,AC) ;-- specimen id
 N SPM2
 S SPM2=CS_AC_SC_"Filler_LIS"_SC_"2.16.840.1.113883.3.72.5.21"_SC_"ISO"
 Q SPM2
 ;
SPM4(CS,ACC,SPC)  ;-- specimen type
 N SPM4,SNM
 S SNM=$$GET1^DIQ(61,SPC,2)
 S SPM4=SNM_CS_$$GET1^DIQ(61,SPC,.01)_CS_"SCT"_CS_$$GET1^DIQ(61,SPC,.08)_CS_$$GET1^DIQ(61,SPC,.01)_CS_"L"_CS_LA7VER_CS_$G(^DIC(9.4,$O(^DIC(9.4,"C","BLR",0)),"VERSION"))
 Q SPM4
 ;
SPM5(CS,ACC,SPC,RI)  ;-- specimen type modifier
 N SPM5
 S SPM5=""
 N RA,ID,TX
 S RA=0 F  S RA=$O(^BLRRLO(RI,4,RA)) Q:'RA  D
 . Q:$P($G(^BLRRLO(RI,4,RA,0)),U,3)'="SPM5"
 . S ID=$P($G(^BLRRLO(RI,4,RA,0)),U,4)
 . S TX=$P($G(^BLRRLO(RI,4,RA,0)),U,5)
 . S SPM5=ID_CS_TX_CS_"SCT"_CS_$E(TX,1,3)_CS_TX_CS_"L"_CS_"2.40"_CS_LA7VER
 Q SPM5
 ;
SPM6(CS,ACC,SPC)  ;-- specimen additives
 ;file 62 new field
 N SPM6,ADD,ADDD
 S SPM6=""
 S ADD=$P($G(^LAB(62,LRSAMP,9,LRAA,1,LA760,"IHS")),U)
 I $G(ADD)]"" S ADDD=$$LOOKTAB^LA7CQRY1("HL7","0371",ADD,$E(LA7ECH))
 I $G(ADD)]"" S SPM6=ADDD_CS_$E($P(ADDD,U),1)_CS_$P(ADDD,U,2)_CS_"L"_CS_"2.5.1"_CS_LA7VER
 Q SPM6
 ;
SPM7(CS,ACC,SPC)  ;-- specimen collection method
 ;file 62 new field
 N SPM7,MTH,METH
 S SPM7=""
 S MTH=$P($G(^LAB(62,LRSAMP,9,LRAA,1,LA760,"IHS")),U,2)
 I $G(MTH)]"",$E(MTH,1)?.N S METH=$$LOOKTAB^LA7CQRY1("","SCT",MTH,$E(LA7ECH))
 I $G(MTH)]"",$E(MTH,1)'?.N S METH=$$LOOKTAB^LA7CQRY1("HL7","0488",MTH,$E(LA7ECH))
 I $G(MTH)]"" S SPM7=METH_CS_$E($P(METH,U),1,4)_CS_$P(METH,U,2)_CS_"L"_CS_"07/31/2012"_CS_LA7VER
 Q SPM7
 ;
SPM8(CS,ACC,SPC)  ;-- specimen source site
 ;file 62 new field, points to 61
 N SPM8,SS,SSS,SSE
 S SPM8=""
 S SS=$P($G(^LAB(62,LRSAMP,9,LRAA,1,LA760,"IHS")),U,3)
 I 'SS Q SPM8
 S SSS=$P($G(^LAB(61,SS,0)),U,2)
 I $G(SSS)]"" S SSE=$$LOOKTAB^LA7CQRY1("","SCT",SSS,$E(LA7ECH))
 I $G(SSS)]"" S SPM8=SSE_CS_$E($P(SSE,U),1,4)_CS_$P(SSE,U,2)_CS_"L"_CS_"07/31/2012"_CS_LA7VER
 Q SPM8
 ;
SPM9(CS,ACC,SPC,RI)  ;-- specimen source site modifier
 N SPM9
 S SPM9=""
 N RA,ID,TX
 S RA=0 F  S RA=$O(^BLRRLO(RI,4,RA)) Q:'RA  D
 . Q:$P($G(^BLRRLO(RI,4,RA,0)),U,3)'="SPM9"
 . S ID=$P($G(^BLRRLO(RI,4,RA,0)),U,4)
 . S TX=$P($G(^BLRRLO(RI,4,RA,0)),U,5)
 . S SPM9=ID_CS_TX_CS_"SCT"_CS_$E(TX,1,3)_CS_TX_CS_"L"_CS_"2.40"_CS_LA7VER
 Q SPM9
 ;
SPM11(CS,ACC,SPC)  ;-- specimen role
 ;file 61 time aspect field
 N SPM11,TA,ID,IDD
 S SPM11=""
 S TA=$P($G(^LAB(61,SPC,0)),U,10)
 I 'TA Q SPM11
 S ID=$E($P($G(^LAB(64.061,TA,0)),U,2),1)
 I $G(ID)]"" S IDD=$$LOOKTAB^LA7CQRY1("HL7","0369",ID,$E(LA7ECH))
 I $G(ID)]"" S SPM11=IDD_CS_ID_CS_$P(IDD,U,2)_CS_"L"_CS_"2.5.1"_CS_LA7VER
 Q SPM11
 ;
SPM12(CS,SC,ACC,SPC)  ;-- specimen collection amount
 N SPM12
 S SPM12=""
 ;TODO MU2 add the following once we determine specimen collection amount
 ;MU2 hard coded per team 7/1/2013
 S SPM12=1_CS_"{#}"_SC_"Number"_SC_"UCUM"_SC_"unit"_SC_"unit"_SC_"L"_SC_"1.1"_SC_LA7VER
 Q SPM12
 ;
SPM17(CS,LDFN,LIDT)  ;-- speciment collection date/time
 N SPM17
 S SPM17=$$FMTHL7^XLFDT($P($G(^LR(LRDFN,LRSS,LRIDT,0)),U))_CS_$$FMTHL7^XLFDT($P($G(^LR(LRDFN,LRSS,LRIDT,0)),U))
 Q SPM17
 ;
SPM18(CS,LDFN,LIDT)  ;-- specimen received date/time
 N SPM18
 S SPM18=$$FMTHL7^XLFDT($P($G(^LR(LRDFN,LRSS,LRIDT,0)),U))
 Q SPM18
 ;
SPM21(CS,ACC,SPC)  ;-- specimen reject reason
 N SPM21
 S SPM21=""
 Q SPM21
 ;
