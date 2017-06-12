AMERBEDD ;GDIT/HS/BEE - AMER UTILITY CALLS ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**6**;MAR 03, 2009;Build 30
 ;
 Q
 ;
INJ(FIELD,VALUE) ;Update BEDD injury field if BEDD is installed
 ;
 ;Quit if BEDD 2.0 not installed
 I $T(INJFLD^BEDDINJ)="" Q
 I $G(FIELD)="" Q
 I $G(VALUE)="" Q
 ;
 NEW VIEN
 ;
 ;Look for VIEN
 S VIEN=$G(^TMP("AMER",$J,4))
 ;
 ;If no VIEN, try getting from DFN
 I VIEN="" D  Q:VIEN=""
 . NEW DFN
 . S DFN=$G(^TMP("AMER",$J,1,1)) Q:DFN=""
 . S VIEN=$$GET1^DIQ(9009081,DFN_",",1.1,"I")
 ;
 ;Make the call to BEDD
 D INJFLD^BEDDINJ(VIEN,FIELD,VALUE)
 ;
 Q
