XBGXREFS(FILE,FIELD,ROOT) ; IHS/ADC/GTH - GET XREFS FOR ONE FIELD IN ONE FILE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;  ATTENTION PROGRAMMERS:  Do not use line one for entry.
 ;                          Use label XREF for entry.
 ;
 ; Given a file/subfile number, a field number, and a variable
 ; from which to assign subscripted values, this routine will
 ; return the xrefs for the specified field.
 ;
 ; The returned xrefs will be subscripted from the ROOT as
 ; follows:
 ;
 ;  ROOT(FIELD,n)     = file/subfile^xref (e.g. 9000010^AC)
 ;  ROOT(FIELD,n,"K") = executable kill logic
 ;  ROOT(FIELD,n,"S") = executable set logic
 ;
 ; Formal list:
 ;
 ; 1)  FILE   = file or subfile number (call by value)
 ; 2)  FIELD  = field number (call by value)
 ; 3)  ROOT   = array root (call by reference)
 ;
 G START
 ;
XREF(FILE,FIELD,ROOT) ;PEP - Return x-ref info for a field.
 ;
START ;
 NEW Y
 F Y=0:0 S Y=$O(^DD(FILE,FIELD,1,Y)) Q:Y'=+Y  S ROOT(FIELD,Y)=^(Y,0),ROOT(FIELD,Y,"S")=^(1),ROOT(FIELD,Y,"K")=^(2)
 Q
 ;
