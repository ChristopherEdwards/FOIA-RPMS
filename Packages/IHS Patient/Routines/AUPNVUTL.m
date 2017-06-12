AUPNVUTL ; IHS/CMI/LAB - AUPN UTILITIES ; 25 Feb 2016  12:47 PM
 ;;2.0;IHS PCC SUITE;**2,10,11,15,16,17**;MAY 14, 2009;Build 18
SNOMED(N) ;PEP - called from various dds provider narrative
 ;TRANSFORM TO ADD DESCRIPTIVE TEXT FOR SNOMED CODE IF THERE IS A "|" PIECE
 I $G(N)="" Q N
 S N=$P($G(^AUTNPOV(N,0)),U,1)
 I N'["|" Q N  ; no vertical equals no snomed desc id
 I N["| " Q N  ;prenatal v1.0
 I $T(DESC^BSTSAPI)="" Q N  ;no snomed stuff installed
 NEW SDI,SDIT,LAT
 S (SDI,SDIT)=$P(N,"|",2)  ;snomed descriptive id is in piece 2
 S LAT=$P(N,"|",3)  ;laterality text is in piece 3
 I SDI?.AN S SDIT=$P($$DESC^BSTSAPI(SDI_"^^1"),U,2)
 I SDIT="",SDI]"" S SDIT=SDI
 I SDIT="" Q "*"_$P(N,"|",1)  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_$S(LAT]"":", "_LAT,1:"")_" | "_$P(N,"|",1)
PNPROB(N) ;PEP - called from various dds provider narrative
 ;TRANSFORM TO ADD DESCRIPTIVE TEXT FOR SNOMED CODE IF THERE IS A "|" PIECE
 ;N must be a valid IEN in AUTNPOV (provider narrative)
 I $G(N)="" Q N
 S N=$P($G(^AUTNPOV(N,0)),U,1)
 I N'["|" Q "*"_N  ; no vertical equals no snomed desc id
 I N["| " Q N  ;prenatal v1.0
 I $T(DESC^BSTSAPI)="" Q "*"_N  ;no snomed stuff installed
 NEW SDI,SDIT,LAT
 S (SDI,SDIT)=$P(N,"|",2)  ;snomed descriptive id is in piece 2
 S LAT=$P(N,"|",3)  ;laterality text is in piece 3
 I SDI?.AN S SDIT=$P($$DESC^BSTSAPI(SDI_"^^1"),U,2)
 I SDIT="" S SDIT=SDI
 I SDIT="" Q "*"_$P(N,"|",1)  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_$S(LAT]"":", "_LAT,1:"")_" | "_$P(N,"|",1)
EXFIND(%) ;PEP - RETURN EXAM FINDING TEXT BASED ON SNOMED CODE
  ;NOTE:  only 2 SNOMEDs are supported at this time, this will need to be updated if others are ever added.
  I %=162656002 Q "without abnormal findings"
  I %=71994000 Q "with abnormal findings"
  Q %
AQ(%) ;PEP RETURN HUMAN READABLE LATERALITY ATTRIBUTE/QUALIFIER VALUE
 NEW A,Q,V,A1
 I $G(%)="" Q ""
 S A=$P(%,"|")
 I A="" S V="" G AQQ
 ;S V=$$CONCPT(A)
 S V=$$CVPARM^BSTSMAP1("LAT",A)
 I V="" S V=A  ;if no text just use the code
AQQ ;
 S V=V_"|"
 S Q=$P(%,"|",2)
 I Q="" Q V
 ;S A1=$$CONCPT(Q)
 S A1=$$CVPARM^BSTSMAP1("LAT",Q)
 I A1="" S A1=Q
 Q V_A1
EDNAME(I) ;PEP - RETURN EDUCATION TOPIC TEXT
 ;if the topic contains a snomed display preferred term and then subtopic
 NEW N
 I $G(I)="" Q I
 S N=$P($G(^AUTTEDT(I,0)),U,1)
 I $P($G(^AUTTEDT(I,0)),U,12)="" Q N
 I $T(CONC^BSTSAPI)="" Q N  ;no snomed stuff installed
 NEW SDI,SDIT
 S SDI=$P(N,"-",1)  ;snomed descriptive id is in piece 2
 S SDIT=$$CONCPT(SDI)
 I SDIT="" Q N  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_"-"_$P(N,"-",2)
FSOT(X) ;PEP - FINDING SITE OUTPUT TX/COMPUTED FIELD
 ;get each | piece, then each ":" piece and get perferred term
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 NEW A,B,V,D,E
 S V=""
 F A=1:1 S B=$P(X,"|",A) Q:B=""  D
 .;S D=$P(B,":",1)
 .S E=$P(B,":",2)
 .I V]"" S V=V_", "
 .; V=V_$$CONCPT(D)_":"_$$CONCPT(E)
 .S V=V_$$CONCPT(E)
 Q V
TESTFS ;
 ;
 S X="272741003:7771000|363698007:56459004"
 W $$FSOT(X)
 Q
CONC(X) ;EP 22
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 Q $$CONC^AUPNSICD(X_"^^^1")
CONCPT(X) ;PEP - GET CONCEPT PREFERRED TERM
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID PREFERRED TERM IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 NEW D,B,E,V,A,B
 Q $P($$CONC^BSTSAPI(X_"^^^1"),U,4)
DESCPT(X) ;PEP - GET DESC ID
 I $T(DESC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 I $G(X)'?.AN Q X
 Q $P($$DESC^BSTSAPI(X_"^^1"),U,2)
LOINCT(X) ;EP
 ;put api in here when get it from apelon group
 Q ""
LOINCPT(X) ;EP
 ;put api in here when get it from apelon group
 Q ""
ICD(X,Y,Z) ;PEP - CHECK FOR ICD10
 ;I $T(ICD^ATXAPI)]"" Q $$ICD^ATXAPI(X,Y,Z)
 Q $$ICD^ATXCHK(X,Y,Z)
 ;
ICDDX(C,D,I) ;PEP - CHECK FOR ICD10
 I $G(I)="" S I="I"
 I $T(ICDDX^ICDEX)]"" Q $$ICDDX^ICDEX(C,$G(D),,I)
 Q $$ICDDX^ICDCODE(C,$G(D))
 ;
ICDOP(C,D,I) ;PEP - CHECK FOR ICD10
 I $G(I)="" S I="E"
 I $T(ICDOP^ICDEX)]"" Q $$ICDOP^ICDEX(C,$G(D),,I)
 Q $$ICDOP^ICDCODE(C,$G(D))
 ;
VSTD(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTD^ICDEX)]"" Q $$VSTD^ICDEX(C,$G(D))
 Q $$VSTD^ICDCODE(C,$G(D))
 ;
VSTP(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTP^ICDEX)]"" Q $$VSTP^ICDEX(C,$G(D))
 Q $$VSTP^ICDCODE(C,$G(D))
 ;
ICDD(C,A,D) ;EP - CHECK FOR ICD10
 I $T(ICDD^ICDEX)]"" Q $$ICDD^ICDEX(C,A,$G(D))
 Q $$ICDD^ICDCODE(C,A,$G(D))
CONFSN(C) ;EP - FSN
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID FSN IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 Q $P($$CONC^BSTSAPI(X_"^^^1"),U,2)
MC(X) ;EP - called from cross ref
 I $G(X)="" Q ""
 NEW A,B,C
 S A=$O(^AUTTREFR("B",X,0))
 I 'A Q ""
 Q $P($G(^AUTTREFR(A,0)),U,4)
M07(X) ;EP - map .07 to 1.01
 I $G(X)="" Q ""
 NEW A
 S A=$O(^AUTTREFR("AM",X,0))
 I 'A Q ""
 Q $P(^AUTTREFR(A,0),U,1)
 ;
IMP(%) ;EP
 Q $$IMP^ICDEX(%)
REFR(%) ;PEP - REFUSAL REASON TEXT FORM
 I '$G(%) Q ""
 I '$D(^AUPNPREF(%,0)) Q ""
 NEW A,B,C
 S A=$$VAL^XBDIQ1(9000022,%,1.01)
 I A]"" S A=$$CONCPT(A)
 I A]"" Q A
 Q $$VAL^XBDIQ1(9000022,%,.07)
