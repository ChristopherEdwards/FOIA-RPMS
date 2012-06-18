INHPSAL2 ;KN; 16 Apr 96 14:50; MFN Loader Control - applications - data
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
TEXT(INTER,LI) ;Return a line of data or "" if line not found
 ;INPUT:
 ;  INTER - interface application identifier
 ;  LI - offset from DATA tag to get data from
 ;
 Q:'$G(LI)!'$L($G(INTER)) ""
 N X,INLINE,INROU
 F X=1,2 S INROU="INHPSAL"_X,INLINE=$T(@INTER+LI^@INROU) Q:$L(INLINE)
 Q INLINE
 ;
DATA ;data - INHPSAM for description of structure 
 ;;;       DESTINATION:   EMPTY
AP ;;DESTINATION: ANATOMIC PATHOLOGY
 ;;4000^^HL MASTER FILE NOTIFICATION LOAD (AP)
 ;;
BB ;;       DESTINATION: HL BLOOD BANK
 ;;4000^^HL MASTER FILE NOTIFICATION LOAD (BB)
 ;;
CIW ;;     DESTINATION: HL CIW - OUT
 ;;4000^^HL MASTER FILE NOTIFICATION LOAD (CIW)
 ;;
TSC ;;     DESTINATION: HL TSC
 ;;4000^^HL MASTER FILE NOTIFICATION LOAD (TSC)
 ;;
