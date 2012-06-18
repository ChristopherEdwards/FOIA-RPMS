XBPFTV(F,E,V) ; IHS/ADC/GTH - RETURN POINTER FIELD TERMINAL VALUE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; NOTE TO PROGRAMMERS;  Use entry point PFTV.  Do not use
 ; the first line of this routine, as pending initiatives
 ; in MDC might make a formal list on the first line of a
 ; routine invalid.     GTH 07-10-95
 ;
 ; Given a file number, file entry number, and variable
 ; name into which the results will be placed, return the
 ; terminal value after following the pointer chain.
 ;
 ; U must exist and have a value of "^"
 ;
 ; Formal list:
 ;
 ; 1) F  = file number (call by value)
 ; 2) E  = file entry number (call by value)
 ; 3) V  = variable for results (call by reference)
 ;
 ; Scratch vars:
 ; D = Flag, 1 = Done, 0 = continue
 ; G = Global for file F.
 ;
 ; *** NO ERROR CHECKING DONE ***
 ;
 G START
 ;
 ; The below PEP should be used in case the current movement to
 ; not allow a formal list of parameters on the first line of a
 ; routine passes thru MDC.
 ;
PFTV(F,E,V) ;PEP - Return Pointer Field Terminal Value.
 ;
START ;
 NEW D,G
 F  D TRACE Q:D
 Q
 ;
TRACE ; FOLLOW POINTER CHAIN
 S D=1,V=E
 Q:'E
 S G=^DIC(F,0,"GL")
 Q:'$D(@(G_E_",0)"))
 S V=$P(@(G_E_",0)"),U)
 Q:$P(^DD(F,.01,0),U,2)'["P"
 S F=+$P($P(^DD(F,.01,0),U,2),"P",2)
 Q:'$D(@(G_E_",0)"))
 S E=$P(@(G_E_",0)"),U)
 S D=0
 Q
 ;
