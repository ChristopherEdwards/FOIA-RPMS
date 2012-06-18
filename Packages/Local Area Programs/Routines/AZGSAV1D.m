AZGSAV1D ;RPMS/TJF/MLQ;TRANSFER TX GLOBALS TO TAPE, DSM SPECIFIC 
 ;;1.4;AUGS;*0*;OCT 16, 1991
 U IO W AUDT W:AUPAR'["V" ! W AUTLE W:AUPAR'["V" ! S GO=AUGL
Z S:'$D(AUF) AUF=""  S A=AUF,(B,C,D,E,F,G,H)=""
1 S A=$O(@(GO_"A)")) G END:A="" I $D(AUE) G END:A>AUE
 I $D(^(A))#2 S S=A D SB1
2 S B=$O(@(GO_"A,B)")) G 1:B="" I $D(^(B))#2 S S=B D SB1
3 S C=$O(@(GO_"A,B,C)")) G 2:C="" I $D(^(C))#2 S S=C D SB1
4 S D=$O(@(GO_"A,B,C,D)")) G 3:D="" I $D(^(D))#2 S S=D D SB1
5 S E=$O(@(GO_"A,B,C,D,E)")) G 4:E="" I $D(^(E))#2 S S=E D SB1
6 S F=$O(@(GO_"A,B,C,D,E,F)")) G 5:F="" I $D(^(F))#2 S S=F D SB1
7 S G=$O(@(GO_"A,B,C,D,E,F,G)")) G 6:G="" I $D(^(G))#2 S S=G D SB1
8 S H=$O(@(GO_"A,B,C,D,E,F,G,H)")) G 7:H="" I $D(^(H))#2 S S=H D SB1
 G 8
END W "**END**" W:AUPAR'["V" ! W "**END**" W:AUPAR'["V" !
 K A,B,C,D,E,F,G,H,I,X,GO,DATA,SS,EDE
 Q
SB1 S EDE=GO F I=65:1:72 S X=$C(I),SS=0 Q:'$D(@X)  Q:@X=""  S @("SS="_X_"'=+"_X) S:I>65 EDE=EDE_"," S:SS EDE=EDE_"""" S EDE=EDE_@X S:SS EDE=EDE_""""
 S DATA=^(S)
 W EDE_")" W:AUPAR'["V" ! W DATA W:AUPAR'["V" !
 Q
