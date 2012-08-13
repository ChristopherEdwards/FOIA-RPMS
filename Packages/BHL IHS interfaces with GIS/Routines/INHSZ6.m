INHSZ6 ;JSH; 18 Oct 1999 09:27 ;Script compiler END code
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 9; 23-SEP-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Create any end code necessary
 D QCHK^INHSZ0
 I MODE="O" D  Q
 . S A=" S UIF=$$NEWO^INHD(INDEST,""^UTILITY(""""INH"""",$J)"",+$P($G(^INRHT(INTT,0)),U,12),INTT,MESSID,$G(INQUE),$G(INORDUZ),$G(INORDIV),.INUIF6,.INUIF7,$G(INA(""INMIDGEN"")))" D L
 . S A=" I UIF<0 D ERROR^INHS(""UIF creation failed"",2) Q 2" D L
 . ;Set sequence x-ref for NCPDP
 . I $G(INSTD)="NC"!($G(INSTD)="X12") S A=" D XREF^INHUT11" D L
 . S A=" Q 0" D L
 S A=" K @INV,INV,INDA,DIPA Q +$G(INREQERR)" D L
 Q
 ;
OUT Q
