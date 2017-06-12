AMHUTIL2 ; IHS/CMI/LAB - provider functions ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1,4,5**;JUN 02, 2010;Build 18
 ;
PNPV(N,AMHDA) ;PEP - OUTPUT TX PROVIDER NARRATIVE
 S AMHDA=$G(AMHDA)
 S N=$G(N)
 I N="" Q ""
 NEW R,D
 S (R,D)=""
 I AMHDA S R=$P($G(^AMHRPRO(AMHDA,0)),U,3)
 I AMHDA S D=$P($G(^AMHRPRO(AMHDA,0)),U,1)
 I N="" Q "<No Provider Narrative>"
 I R,$P($G(^AMHREC(R,11)),U,10) G EHR  ;if EHR created do EHR stuff
 Q $P(^AUTNPOV(N,0),U)  ;IF NOT AN EHR CREATED VISIT JUST DISPLAY THE NARRATIVE LIKE WE ALWAYS DID
EHR ;
 S N=$P($G(^AUTNPOV(N,0)),U,1)
 I N'["|" Q $$GET1^DIQ(9002012.2,D,.02)_" | "_N  ; no vertical equals no snomed desc id so use problem narrative
 I N["| " Q $$GET1^DIQ(9002012.2,D,.02)_" | "_N  ;prenatal v1.0
 I $T(DESC^BSTSAPI)="" Q $$GET1^DIQ(9002012.2,D,.02)_" | "_N  ;no snomed stuff installed
 NEW SDI,SDIT
 S SDI=$P(N,"|",2)  ;snomed descriptive id is in piece 2
 S SDIT=$P($$DESC^BSTSAPI(SDI_"^^1"),U,2)
 I SDIT="" Q $$GET1^DIQ(9002012.2,D,.02)_" | "_$P(N,"|",1)  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_" | "_$P(N,"|",1)
CS(I) ;EP - called to determine coding system of ien I
 ;are the icd10 routines in place?, if so, use them
 I $T(ICDDX^ICDEX)]"" Q $P($$ICDDX^ICDEX(I),U,20)  ;return 1 or 30
 Q 1  ;if no icdex then assume site is only on icd9
IMP(D) ;EP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 S Y=""
 I '$O(^ICDS(0)) Q 1  ;icd 10 not installed yet
 S X=0 F  S X=$O(^ICDS("F",80,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
PRIMCPT(V,F) ;EP - primaryCPT in many different formats
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=$O(^AMHRPROC("AD",V,0)) I Y S P=$P(^AMHRPROC(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^ICPT(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
SECCPT(V,N,F) ;EP
 I 'V Q ""
 I '$D(^AMHREC(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0,C=-1 F  S Y=$O(^AMHRPROC("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AMHRPROC(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^ICPT(P)) Q ""
 I $G(F)="" S F="C"
 S %="" D @F
 Q %
 ;
CPT ;EP
 NEW Z,C,%,S,I,J
 S (C,Y)=0 F  S Y=$O(^AMHRPROC("AD",V,Y)) Q:Y'=+Y   S C=C+1 S APCLV(C)="",P=$P(^AMHRPROC(Y,0),U),Z=Y D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,I)=% ;IHS/TUCSON/LAB - patch 1 05/19/97 changed ,I TO ,J
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
 ;
I ;
 S %=P Q
E ;CATEGORY
 S %=$$CPT^ICPTCOD(P,$P($P($G(^AMHREC(V,0)),U),"."),U,4) Q
C ;CODE
 S %=$$CPT^ICPTCOD(P,$P($P($G(^AMHREC(V,0)),U),"."),U,2) Q
 ;
N ;NARRATIVE - SHORT NAME
 S %=$$CPT^ICPTCOD(P,$P($P($G(^AMHREC(V,0)),U),"."),U,3) Q
 ;
PTSEC(RESULT,DFN,MSG,OPT) ;EP - RPC/API entry point for patient sensitive & record access checks
 ;Output array (Required)
 ;    RESULT(1)= -1-RPC/API failed
 ;                  Required variable not defined
 ;                0-No display/action required
 ;                  Not accessing own, employee, or sensitive record
 ;                1-Display warning message
 ;                  Sensitive and DG SENSITIVITY key holder
 ;                  or Employee and DG SECURITY OFFICER key holder
 ;                2-Display warning message/require OK to continue
 ;                  Sensitive and not a DG SENSITIVITY key holder
 ;                  Employee and not a DG SECURITY OFFICER key holder
 ;                3-Access to record denied
 ;                  Accessing own record
 ;                4-Access to Patient (#2) file records denied
 ;                  SSN not defined
 ;                5-Access to Patient for this User is denied ;IHS/OIT/LJF 08/31/2007 PATCH 1008
 ;
 ;    RESULT(2-8) = error or display messages
 ;
 ;Input parameters: DFN = Patient file entry (Required)
 ;                  MSG = If 1, generate message (optional)
 ;                  OPT  = Option name^Menu text (Optional)
 ;
 K RESULT
 I $G(DFN)="" D  Q
 .S RESULT(1)=-1
 .S RESULT(2)="Required variable missing."
 ;
 ;IHS/OIT/LJF 08/31/2007 PATCH 1008
 ;S DGMSG=$G(DGMSG)
 S MSG=$G(MSG,1)
 I $$STATUS^BDGSPT2(DUZ,DFN,1)["RESTRICTED ACCESS" D  Q
 .S RESULT(1)=5 Q:MSG'=1
 .S RESULT(2)="Sorry, you are restricted from accessing this patient's record."
 .S RESULT(3)="If you have questions, please contact your HIM department."
 ;end of PATCH 1008 code
 ;
 D OWNREC^DGSEC4(.RESULT,DFN,$G(DUZ),MSG)
 I RESULT(1)=1 S RESULT(1)=3 Q
 I RESULT(1)=2 S RESULT(1)=4 Q
 K RESULT
 D SENS^DGSEC4(.RESULT,DFN,$G(DUZ))
 ;
 ;IHS/OIT/LJF 01/06/2006 PATCH 1005 account for tracking all patients
 ;I RESULT(1)=1 D
 I (RESULT(1)=1)!(RESULT(1)=0) D
 .I (RESULT(1)=0)&($$GET1^DIQ(43,1,9999999.01)'="YES")&('$P($G(^DGSL(38.1,+DFN,0)),U,2)) Q  ;cmi/maw 1/26/2010 PATCH 1011
 .;
 .I $G(DUZ)="" D  Q
 ..;DUZ must be defined to access sensitive record & update DG Security log
 ..S RESULT(1)=-1
 ..S RESULT(2)="Your user code is undefined.  This must be defined to access a restricted patient record."
 .D SETLOG1^DGSEC(DFN,DUZ,,$G(DGOPT))  ;ihs/cmi/maw 12/15/2010 added set of log
 Q
ANY25(AMHX) ;EP
 NEW F,X,G
 S X="",G=0 F  S X=$O(^TMP("DDS",$J,+DDS,"F9002013.01101",X)) Q:X=""  D
 .I $G(^TMP("DDS",$J,+DDS,"F9002013.01101",X,.02,"D"))=2 S G=1
 .I $G(^TMP("DDS",$J,+DDS,"F9002013.01101",X,.02,"D"))=5 S G=1
 .Q
 Q G
ICD9 ;EP - CALLED FROM INPUT TX ON SITE PARAMETERS FIELD .13
 I $$CHK(Y)
 Q:$D(^ICD9(Y))
 Q
 ;
CHK(Y) ;EP - SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $T(ICDDX^ICDEX)]"" S %=$$ICDDX^ICDEX(Y) I $P(%,U,20)'=1 Q 0
 I $T(ICDDX^ICDEX)="" S %=$$ICDDX^ICDCODE(Y)
 ;I $P(%,U,20)'=1 Q 0   ;not correct coding system
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
ICD10 ;EP CALLED FROM INPUT TX ON SITE PARAMETERS FIELD 1204
 ;
 I $$CHK1(Y)
 Q:$D(^ICD9(Y))
 Q
 ;
CHK1(Y) ;EP - SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $T(ICDDX^ICDEX)]"" S %=$$ICDDX^ICDEX(Y) I $P(%,U,20)'=30 Q 0
 I $T(ICDDX^ICDEX)="" S %=$$ICDDX^ICDCODE(Y)
 ;I $P(%,U,20)'=30 Q 0   ;not correct coding system
 I $E($P(%,U,2),1)="V" Q 0  ;no codes V00-Y99 per Leslie Racine.
 I $E($P(%,U,2),1)="W" Q 0
 I $E($P(%,U,2),1)="X" Q 0
 I $E($P(%,U,2),1)="Y" Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
