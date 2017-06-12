BSTSLKP ;GDIT/HS/BEE-Standard Terminology Lookups ; 15 Nov 2012  4:26 PM
 ;;1.0;IHS STANDARD TERMINOLOGY;;Sep 10, 2014;Build 101
 Q
 ;
DSC(OUT,BSTSWS) ;EP - Perform Lookup on Description Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  BSTSWS("SEARCH") - The Description/Concept Id to lookup 
 ;  BSTSWS("NAMESPACEID") (Optional) - The code set Id (default SNOMED US EXT '36') 
 ;  BSTSWS("SNAPDT") (Optional) - Snapshot Date to check (default DT)
 ;
 ;Output
 ; @VAR@(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Descriptor ID
 ;
 N DESC,IEN,NMID,SDATE,INMID,TIEN,CONC,DTS,CIEN
 ;
 S DESC=$G(BSTSWS("SEARCH")) Q:DESC="" "0"
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SDATE=$G(BSTSWS("SNAPDT")) S:SDATE="" SDATE=DT
 ;
 ;Pull internal Code Set ID
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) Q:INMID="" "0"
 ;
 ;Lookup of ID
 S TIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,"")) Q:TIEN="" "0"
 S CIEN=$$GET1^DIQ(9002318.3,TIEN_",",.03,"I") Q:CIEN="0"
 S CONC=$$GET1^DIQ(9002318.4,CIEN_",",.02,"I")
 S DTS=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I")
 S @OUT@(1)=CONC_U_DTS_U_DESC
 ;
 Q 1
 ;
DTS(OUT,BSTSWS) ;EP - Perform lookup on DTS Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  BSTSWS("SEARCH") - The DTS Id to lookup 
 ;  BSTSWS("NAMESPACEID") (Optional) - The code set Id (default SNOMED US EXT '36') 
 ;  BSTSWS("SNAPDT") (Optional) - Snapshot Date to check (default DT)
 ;
 ;Output
 ; @VAR@(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Descriptor ID
 ;
 N DTS,IEN,NMID,SDATE,CONC,CIEN
 ;
 S DTS=$G(BSTSWS("SEARCH")) Q:DTS="" "0"
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SDATE=$G(BSTSWS("SNAPDT")) S:SDATE="" SDATE=DT
 ;
 ;Lookup of ID
 S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTS,"")) Q:CIEN="" "0"
 S CONC=$$GET1^DIQ(9002318.4,CIEN_",",.02,"I") Q:CONC="" "0"
 S @OUT@(1)=CONC_U_DTS_U
 ;
 Q 1
 ;
CNC(OUT,BSTSWS) ;EP - Perform lookup on Concept Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  BSTSWS("SEARCH") - The Concept Id to lookup 
 ;  BSTSWS("NAMESPACEID") (Optional) - The code set Id (default SNOMED US EXT '36') 
 ;  BSTSWS("SNAPDT") (Optional) - Snapshot Date to check (default DT)
 ;
 ;Output
 ; @VAR@(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Descriptor ID
 ;
 N DTS,IEN,NMID,SDATE,CONC,CIEN
 ;
 S CONC=$G(BSTSWS("SEARCH")) Q:CONC="" "0"
 S NMID=$G(BSTSWS("NAMESPACEID")) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SDATE=$G(BSTSWS("SNAPDT")) S:SDATE="" SDATE=DT
 ;
 ;Lookup of ID
 S CIEN=$O(^BSTS(9002318.4,"C",NMID,CONC,"")) Q:CIEN="" "0"
 S DTS=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I")
 S @OUT@(1)=CONC_U_DTS_U
 ;
 Q 1
 ;
VNLKP(OUT,BSTSWS) ;EP - Perform local NDC/VUID lookup
 ;
 NEW NMID,CONC,DTS,CCT,NMIEN
 S CCT=0
 ;
 ;Get internal namespace IEN
 S NMID=$G(BSTSWS("NAMESPACEID"))
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) I NMIEN="" Q CCT
 ;
 ;NDC Search
 ;
 I $G(BSTSWS("LTYPE"))="N" D  Q CCT
 . NEW NDC,CIEN
 . ;
 . ;Get NDC
 . S NDC=$G(BSTSWS("SEARCH")) I NDC="" Q
 . ;
 . ;Lookup the entry
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"G",NMIEN,NDC,CIEN)) Q:CIEN=""  D
 .. NEW CONC,DTSID
 .. S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","I") Q:CONC=""
 .. S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",".08","I") Q:DTSID=""
 .. S CCT=CCT+1,@OUT@(CCT)=CONC_U_DTSID
 ;
 ;VUID search
 ;
 I $G(BSTSWS("LTYPE"))="V" D  Q CCT
 . NEW VUID,CIEN
 . ;
 . ;Get VUID
 . S VUID=$G(BSTSWS("SEARCH")) I VUID="" Q
 . ;
 . ;Lookup the entry
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"H",NMIEN,VUID,CIEN)) Q:CIEN=""  D
 .. NEW CONC,DTSID
 .. S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","I") Q:CONC=""
 .. S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",".08","I") Q:DTSID=""
 .. S CCT=CCT+1,@OUT@(CCT)=CONC_U_DTSID
 ;
 Q 0
 ;
CIEN(CONC,NMID) ;EP - Return the CIEN for the concept
 ;
 I $G(CONC)="" Q ""
 I $G(NMID)="" Q ""
 ;
 NEW TRNCONC,FOUND,CIEN
 ;
 S TRNCONC=$E(CONC,1,30)
 ;
 S FOUND=""
 S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,TRNCONC,CIEN)) Q:CIEN=""  D  I FOUND]"" Q
 . NEW CONCID
 . S CONCID=$$GET1^DIQ(9002318.4,CIEN_",",".02","I") Q:CONCID=""
 . I CONC'=CONCID Q
 . S FOUND=CIEN
 Q FOUND
