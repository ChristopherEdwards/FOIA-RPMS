DGMTUTL1 ;ALB/RMM - Means Test Consistency Checker ; 07/24/03
 ;;5.3;Registration;**463,542**;Aug 13, 1993
 ;
 ;
 ; Apply Consistency Checks to the Income Test Processes: ADD,
 ; EDIT, and COMPLETE.
 ;
 ;
 Q
 ;
INCON(DFN,DGMTDT,DGMTI,IVMTYPE,IVMERR) ;
 ;
 ; Check Income Test before applying consistency checks
 ; - If AGREED TO PAY DEDUCTIBLE is NO
 ; - or DECLINES TO GIVE INCOME INFO and AGREED TO PAY DEDUCTIBLE are YES
 ; Quit, the consistency checks are unnecessary.
 N NODE0,APD,DTGII
 S NODE0=$G(^DGMT(408.31,DGMTI,0)),APD=$P(NODE0,U,11),DTGII=$P(NODE0,U,14)
 I APD=0!(APD=1&(DTGII=1)) Q
 ;
 ; Build the data strings for the veteran, and apply consistency checks
 ; Get information and initialize variables
 N CNT,I,HLFS,IEN,ARRAY,SPOUSE,DEP,DEPIEN,DGDEP,DGINC,DGINR,DGREL
 N ZIC,ZIR,ZMT,ZDP,ARRAY,DIEN
 S CNT=1,HLFS=U,SPOUSE=0
 D ALL^DGMTU21(DFN,"VSC",DGMTDT)
 ;
 ; Build ZMT array for CC's
 S $P(ARRAY("ZMT"),U,2)=$P($G(^DGMT(408.31,DGMTI,0)),U,1)
 S $P(ARRAY("ZMT"),U,2)=$E($P(ARRAY("ZMT"),U,2),1,3)+1700_$E($P(ARRAY("ZMT"),U,2),4,7)
 S $P(ARRAY("ZMT"),U,3)=$P($G(^DGMT(408.31,DGMTI,0)),U,3)
 S $P(ARRAY("ZMT"),U,3)=$P(^DG(408.32,$P(ARRAY("ZMT"),U,3),0),U,2)
 ;
 ; Build Spouse ZIC, ZIR, and ZDP Arrays
 I $D(DGREL("S")) D
 .S SPOUSE=1
 .; Use the Individual Annual Income File #408.21
 .S ARRAY(SPOUSE,"ZIC")=$$ZIC^DGMTUTL2(DGINC("S"),SPOUSE)
 .; Use the Income Relation File #408.22
 .S ARRAY(SPOUSE,"ZIR")=$$ZIR^DGMTUTL2(DGINR("S"),SPOUSE)
 .; Use Patient Relation File #408.12 and Income Person File #408.13
 .S ARRAY(SPOUSE,"ZDP")=$$ZDP^DGMTUTL2(DGREL("S"),SPOUSE)
 ;
 ; Build Dependent ZIC, ZIR, and ZDP Arrays
 F IEN=1:1:DGDEP D
 .S DIEN=IEN+SPOUSE
 .; Use the Individual Annual Income File #408.21
 .S ARRAY(DIEN,"ZIC")=$$ZIC^DGMTUTL2(DGINC("C",IEN),DIEN)
 .; Use the Income Relation File #408.22
 .S ARRAY(DIEN,"ZIR")=$$ZIR^DGMTUTL2(DGINR("C",IEN),DIEN)
 .; Use Patient Relation File #408.12 and Income Person File #408.13
 .S ARRAY(DIEN,"ZDP")=$$ZDP^DGMTUTL2(DGREL("C",IEN),DIEN)
 S DEP=DGDEP+SPOUSE
 ;
 ; Check the Individual Annual Income File #408.21
 S ZIC=$$ZIC^DGMTUTL2(DGINC("V"))
 D ZIC^IVMCMF1(ZIC)
 ;
 ; Check the Income Relation File #408.22
 S ZIR=$$ZIR^DGMTUTL2(DGINR("V"),DGMTDT)
 D ZIR^IVMCMF1(ZIR,"",1)
 ;
 ; Check the Annual Means Test File #408.31
 I "^1^2^4^"[("^"_IVMTYPE_"^") D 
 .S ZMT=$$ZMT^DGMTUTL2(DGMTI)
 .; Create array for Income Calculator
 .M ARRAY("ZIC")=ZIC
 .D ZMT^IVMCMF2(ZMT)
 ;
 ; Apply the Consistency Checks to the dependent information
 F IEN=1:1:DEP D
 .; Check Patient Relation File #408.12 and Income Person File #408.13
 .D ZDP^IVMCMF2(ARRAY(IEN,"ZDP"),IEN)
 .; Check the Individual Annual Income File #408.21
 .D ZIC^IVMCMF1(ARRAY(IEN,"ZIC"),IEN)
 .; Check the Income Relation File #408.22
 .D ZIR^IVMCMF1(ARRAY(IEN,"ZIR"),IEN)
 ;
 Q
