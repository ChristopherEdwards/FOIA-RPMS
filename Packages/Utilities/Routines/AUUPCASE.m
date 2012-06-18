AUUPCASE ; [ 09/24/85  12:41 PM ]
 N I,J,C,NX
 S J=$L(X),NX="" F I=1:1:J S C=$E(X,I),NX=NX_$S(C?1L:$C($A(C)-32),1:C)
 S X=NX
 Q
