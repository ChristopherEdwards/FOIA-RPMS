BJPNAPIS ;GDIT/HS/BEE-Prenatal Care Module API Call - Set PIP Problem ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**7**;Feb 24, 2015;Build 53
 ;
 Q
 ;
SET(PRBIEN) ;PEP - Set IPL problem to PIP
 ;
 NEW RET,DFN,B,BMXSEC
 ;
 ;Validate input
 I '+$G(PRBIEN) Q "-1^PIP problem set failed - no problem IEN passed in"
 I '$D(^AUPNPROB(PRBIEN,0)) Q "-1^PIP problem set failed - invalid problem IEN"
 ;
 ;Retrieve patient DFN
 S DFN=$$GET1^DIQ(9000011,PRBIEN_",",.02,"I") I '+DFN Q "-1^PIP problem set failed - invalid DFN in problem"
 ;
 ;Set up the 'B' PIP entry
 S B="B"_U_"A"_U_"C"_U_U_$$GET1^DIQ(9000017,DFN_",",1311,"I")
 ;
 ;Update the IPL PIP column
 D
 . NEW PRBUPD,ERROR,PIP
 . S PIP=$$GET1^DIQ(9000011,PRBIEN_",",.19,"I")
 . I PIP=$S($P(B,U,2)="A":1,1:"") Q   ;Skip if already the same value
 . S PRBUPD(9000011,PRBIEN_",",".19")=$S($P(B,U,2)="A":1,1:"@")
 . D FILE^DIE("","PRBUPD","ERROR")
 ;
 ;Make the call to create the PIP entry
 S RET=$$ADDPIP^BJPNPSET(DFN,PRBIEN,B)
 ;
 ;Handle failure
 I RET=-1 Q "-1"_U_$G(BMXSEC)
 ;
 Q ""
 ;
ERR      ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 Q
