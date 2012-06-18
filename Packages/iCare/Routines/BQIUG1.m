BQIUG1 ;PRXM/HC/DB - iCare GUI Utilities ; 17 Oct 2005  3:17 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; This is a utility program containing special function calls
 ; needed to support the iCare GUI.
 Q
 ;
PLID(OWNR,PLIEN) ;EP - Panel Identifier for the GUI
 ;
 ;Description
 ;  Returns a unique identifier for the panel using the following algorithm:
 ;            the OWNER_IEN concatenated with the PANEL_IEN
 ;            padded out to 4 with leading zeroes.
 ;Input:
 ;  OWNR  - Owner internal entry number
 ;  PLIEN - Panel internal entry number
 ;Output:
 ;  PLID - Unique Panel identifier
 ;
 N PLID
 I $G(OWNR)="" Q ""
 I $G(PLIEN)="" Q ""
 ;
 S PLID=OWNR_$E("0000",1,4-$L(PLIEN))_PLIEN
 Q PLID
