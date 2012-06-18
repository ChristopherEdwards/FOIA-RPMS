XBDAD0 ; IHS/ADC/GTH - SET ALTERNATE DA/D0 ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine sets the DA array from D0,D1 etc. or D0,D1
 ; etc. from the DA array.  If the variable XBDAD0=2 it sets
 ; the DA array, otherwise it sets D0,D1 etc.
 ;
 ; The variable XBDAD0 will be killed upon exiting this
 ; routine.
 ;
 ; The entry point KILL kills D0, D1, etc.
 ;
START ;
 NEW I,J
 I $G(XBDAD0)=2 D D0DA I 1
 E  D DAD0
 KILL XBDAD0
 Q
 ;
DAD0 ; -----  Set D0 (etc) from DA array.
 F I=1:1 Q:'$D(DA(I))  S I(99-I)=DA(I)
 S J=0
 F I=0:1 S J=$O(I(J)) Q:J'=+J  S @("D"_I)=I(J)
 S @("D"_I)=DA
 Q
 ;
D0DA ; ----- Set DA array from D0 (etc).
 F I=0:1 Q:'$D(@("D"_I))  S J=I
 F I=0:1 S DA(J)=@("D"_I) S J=J-1 Q:J<1
 S DA=@("D"_(I+1))
 Q
 ;
KILL ;PEP - KILL D0, D1, ETC.
 NEW I
 F I=0:1 Q:'$D(@("D"_I))  KILL @("D"_I)
 Q
 ;
