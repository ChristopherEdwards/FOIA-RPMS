ATXCHK ; IHS/OHPRD/TMJ - CHECK ICD CODES AGAINST TAXONOMY ; 
 ;;5.1;TAXONOMY;**11,13**;FEB 04, 1997;Build 13
 ;
 ;IHS/TUCSON/LAB - changed VCODE+2 $D TO $E 02/27/95
 ;
ICD(X,Y,Z) ;EP >>EXTRN FUNC to see if ICD code belongs in certain taxonomy
 ;input variables: X=dx ifn, Y=taxonomy ifn, Z=9 for dx or 0 for proc 1 for cpt
 I $G(X)="" Q ""
 I $G(Y)="" Q ""
 I $G(Z)="" Q ""
 I '$D(^ATXAX(Y,21,"AC")) Q $$ICD^ATXAPI(X,Y,Z)
 I $D(^ATXAX(Y,21,"AC",X)) Q 1
 Q 0
 ;NEW ATXX
 ; ATXX=$$ICD^ATXAPI(X,Y,Z)
 ;Q ATXX
 ;;;
