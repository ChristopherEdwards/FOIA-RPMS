BEDDEHR ;VNGT/HS/BEE-EHR Utility Routine ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 Q
 ;
CHGPAT(DFN,DUZ) ;EP - Change the patient in EHR to the selected patient
 ;
 NEW Z,SUB,FND
 ;
 ;Data validation
 I $G(DFN)="" Q 0
 I $G(DUZ)="" Q 0
 S:$G(U)="" U="^"
 ;
 ;Return list of subscribers to patient context
 D GETSUBSC^CIANBEVT(.SUB,"CONTEXT.PATIENT")
 ;
 ;Try to find the user's EHR session
 S FND=0 F Z=0:0 S Z=$O(@SUB@(Z)) Q:'Z  D
 . NEW DZ,UID
 . S DZ=$P($G(@SUB@(Z)),U,4)
 . I DZ'=DUZ Q
 . S UID=$P($G(@SUB@(Z)),U) Q:UID=""
 . ;
 . ;Change the context
 . D QUEUE^CIANBEVT("CONTEXT.PATIENT",+DFN,UID)
 . S FND=1
 Q FND
 ;
CHGENC(ENC,DUZ) ;EP - Change the Encounter in EHR to the selected visit
 ;
 NEW Z,SUB,FND
 ;
 ;Data validation
 I $G(ENC)="" Q 0
 I $G(DUZ)="" Q 0
 S:$G(U)="" U="^"
 ;
 ;Return list of subscribers to encounter context
 D GETSUBSC^CIANBEVT(.SUB,"CONTEXT.ENCOUNTER")
 ;
 ;Try to find the user's EHR session
 S FND=0 F Z=0:0 S Z=$O(@SUB@(Z)) Q:'Z  D
 . NEW DZ,UID
 . S DZ=$P($G(@SUB@(Z)),U,4)
 . I DZ'=DUZ Q
 . S UID=$P($G(@SUB@(Z)),U) Q:UID=""
 . ;
 . ;Change the context
 . D QUEUE^CIANBEVT("CONTEXT.ENCOUNTER",+ENC,UID)
 . S FND=1
 Q FND
