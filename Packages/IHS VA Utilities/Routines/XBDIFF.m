XBDIFF ; IHS/ADC/GTH - RETURN DIFFERENCE BETWEEN TWO DATE/TIMES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Passed two date/times this routine returns the difference
 ; in days, hours, minutes, seconds separated by colons ":".
 ;
 ; The date/times must be passed in the variables X and X1.
 ; The result will be returned in X.  X1 will be killed.
 ;
 ; If either X or X1 are invalid X will be returned as -1 and
 ; X1 will be killed.
 ;
 ; The date/times may be passed in $HOROLOG format or in
 ; internal FileMan format.
 ;
 ; See also, $$FMDIFF^XLFDT, and $$HDIFF^XLFDT.
 ;
START ;
 NEW A,B,C,D,E,F,G
 D EDIT
 Q:X<0
 S:X>X1 A=X,X=X1,X1=A
 I X?5N1","5N S A=$P(X,",",1),B=$P(X,",",2) I 1
 E  D H^%DTC S A=%H,B=%T
 I X1?5N1","5N S C=$P(X1,",",1),D=$P(X1,",",2) I 1
 E  S X=X1 D H^%DTC S C=%H,D=%T
 S E=C-A S:D<B E=E-1,D=D+86400 S D=D-B,F=D\3600,D=D-(F*3600),G=D\60,D=D-(G*60)
 S X=E_":"_F_":"_G_":"_D
 KILL %H,%T,%Y,A,B,C,D,E,F,G,X1
 Q
 ;
EDIT ; EDIT INPUT
 D EDITX
 Q:X<0
 D EDITX1
 Q:X<0
 I X?5N1"."5N D  Q
 . I $P(X,".",2)>86399 S X=-1 KILL X1
 . Q
 S A=$P(X,".",2)
 I +$E(A,1,2)<24,+$E(A,3,4)<60,+$E(A,5,6)<60 Q
 E  S X=-1 KILL X1
 KILL A
 Q
 ;
EDITX ; EDIT X
 Q:X?5N1"."5N
 Q:X?7N
 Q:X?7N1"."1.6N
 S X=-1
 KILL X1
 Q
 ;
EDITX1 ; EDIT X1
 Q:X?5N1"."5N
 Q:X?7N
 Q:X?7N1"."1.6N
 S X=-1
 KILL X1
 Q
 ;
