ACDFUNC ;IHS/ADC/EDE/KML - VARIOUS EXTRINSICS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
DD(Y) ;EP-get external date
 X ^DD("DD")
 Q Y
SETS(X) ;EP-Convert sets to op format
 ;file is X(1), field is X(2), and code is X(3)
 ;
 I X(3)="" S ACDX="UNKNOWN" Q ACDX
 S ACDX=$P(^DD(X(1),X(2),0),U,3),ACDX=$P(ACDX,X(3)_":",2),ACDX=$P(ACDX,";") I ACDX="" S ACDX="UNKNOWN"
 Q ACDX
 ;
LZERO(V,L) ;EP-left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;EP-right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LBLNK(V,L) ;EP-left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLNK(V,L) ;EP-right blank fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
