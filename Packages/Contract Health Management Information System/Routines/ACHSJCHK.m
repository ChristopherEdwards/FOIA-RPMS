ACHSJCHK ; IHS/ITSC/PMF - CHECK FOR ACTIVE CHS OPTIONS ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;  Return Y=1 if compiled menu has ACHS option.
 ;  J = JOB subscript
 ;  N = Namespace to check
 ;  O = Option
E(N) ;EP - Are other CHS options in the compiled menu?
 N J,O
 S J=""
JOBS ;
 S J=$O(^XUTL("XQ",J))
 I 'J Q 0
 I '(J=$J),$D(^XUTL("XQ",J,"IO")),'(^("IO")=$G(I0)),$$PASS(J) Q 1
 G JOBS
PASS(J) ;
 S O=0
P1 ;
 S O=$O(^XUTL("XQ",J,O))
 I 'O Q 0
 I $P(^XUTL("XQ",J,O),U,2)[N Q 1
 G P1
 ;
