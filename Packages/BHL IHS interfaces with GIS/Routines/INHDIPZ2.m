INHDIPZ2 ;GFT; 22 Oct 91 05:33 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 F R=0:0 S R=$O(DXS(R)),W="" Q:'R  K:$D(DXS(R))>9 ^DIPT(DIPZ,"DXS",R) F  S W=$O(DXS(R,W)) Q:W=""  S ^DIPT(DIPZ,"DXS",R,W)=DXS(R,W)
 S DIPZLR=DRN,DRN="",DIL=0 D NEW
 I $D(^DIPT(DIPZ,"DXS")) S X=" D:$D(DXS)<9 ^"_DNM_"D" D L
DIL S DIL=$O(^UTILITY("DIPZ",$J,DIL)) G DHD:'DIL
 S DHT=^(DIL) I DRN<DIPZLR,DIL>DRN(+DRN) D SV
 S X=DHT D L G DIL
 ;
DHD F F=2.9:0 S F=$O(^UTILITY($J,F)) Q:'F  S DIL=$L(^(F))+DIL
 I DIL+DIPZL>DMAX D SV
 S X=" Q" D L S X="HEAD ;" D L F F=2.9:0 S F=$O(^UTILITY($J,F)) Q:'F  S X=" "_^(F) D L
 S X=" W !,""" F %=1:1 S X=X_"-" I %=(IOM+(DIPZTYPE="A"*2))!(%>239) S X=X_""""_$S(DIPZTYPE="R":",!!",1:",!") D L Q
END S:DIPZTYPE="A" IOM=IOM+2
 D SV,DXS S DM=0,F=""
K K ^UTILITY($J),^("DIPZ",$J),DIPZL,DISMIN,%X,%Y,DG,DIL,DLN,DP,F,DL,DM,DMAX,DNM,DRD,DRJ,DIO,DX,DY,DRN,DIPZLR,V,R,W,Y,T
 Q
 ;
SV F %=$S($D(DCL)>9:1,0'[DCL:7,1:11):1 S X=$T(@("TEXT"_$S(DIPZTYPE="R":"",1:"A"))+%) Q:$E(X,2,3)'=";;"  S X=$E(X,4,999) D L
 S X="DT S DY=Y "_^DD("DD") D L S X=" "_$S(DIPZTYPE="R":"W Y",1:"S @INV@(INL)=$G(@INV@(INL))_Y,INP=INP+$L(Y)")_" S Y=DY Q" D L S X=DNM_DRN X ^("OS",^DD("OS"),"ZS") W !,"'"_X_"' ROUTINE FILED"
 S DRN=DRN+1
NEW K ^UTILITY($J,0) S L=0,X=DNM_DRN_" ; GENERATED FROM '"_$P(^DIPT(DIPZ,0),U)_"' PRINT TEMPLATE (#"_DIPZ_") ; "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 I DRN="" S X=X_" ; (FILE "_DP_", MARGIN="_IOM_")"
 D L Q:DRN]""
 S X=" K DUOUT" D L
 Q:DIPZTYPE'="A"
 S X=" S INP=0,INL=$G(INL)+1"
L S L=L+1,^UTILITY($J,0,L)=X Q
 ;
DXS ;Save code to build DXS array
 Q:'$D(^DIPT(DIPZ,"DXS"))
 N I,J,Z,L,S S Z=0 D DXSN
 F I=0:0 S I=$O(^DIPT(DIPZ,"DXS",I)) Q:'I  S J=$O(^(I,"")) F  Q:J=""  D
 . S X=" S DXS("_$S(+I=I:I,1:""""_I_"""")_","_$S(+J=J:J,1:""""_J_"""")_")="""_$$REPLACE^UTIL(^(J),"""","""""")_"""",S=S+$L(X) I S>DMAX D
 .. N X S X=" G ^"_DNM_$C(68+Z+1) D L S X=DNM_$C(68+Z) X ^DD("OS",^DD("OS"),"ZS") W !,"'",X,"' ROUTINE FILED" S Z=Z+1 D DXSN
 . D L S J=$O(^DIPT(DIPZ,"DXS",I,J))
 S X=" Q" D L S X=DNM_$C(68+Z) X ^DD("OS",^DD("OS"),"ZS") W !,"'",X,"' ROUTINE FILED"
 Q
DXSN ;Start new DXS routine
 S (S,L)=0 K ^UTILITY($J,0)
 S X=DNM_$C(68+Z)_" ; GENERATED FROM '"_$P(^DIPT(DIPZ,0),U)_"' PRINT TEMPLATE (#"_DIPZ_") ; "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),S=S+$L(X) D L
 S X=" ;Code to build the DXS array",S=S+$L(X) D L
 I 'Z S X=" K DXS",S=S+$L(X) D L
 ;
TEXT ;
 ;; Q
 ;;CP G CP^DIO2
 ;;C S DQ(C)=Y
 ;;S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
 ;;P S N(C)=N(C)+1
 ;;A S S(C)=S(C)+Y
 ;; Q
 ;;DITTO(Y,C) ;
 ;;D I Y=DITTO(C) S Y="" Q
 ;; S DITTO(C)=Y
 ;; Q
 ;;N Q:$G(DUOUT)  W !
 ;;T Q:$G(DUOUT)  W:$X ! I $D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL D TOP^DIWW W:$X !
 ;; Q
 ;;M Q:$G(DUOUT)  G @DIXX
TEXTA ;
 ;; Q
 ;;CP G CP^DIO2
 ;;C S DQ(C)=Y
 ;;S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
 ;;P S N(C)=N(C)+1
 ;;A S S(C)=S(C)+Y
 ;; Q
 ;;DITTO(Y,C) ;
 ;;D I Y=DITTO(C) S Y="" Q
 ;; S DITTO(C)=Y
 ;; Q
 ;;N S INL=INL+1,INP=0,@INV@(INL)=""
 ;;T S:INP INL=INL+1,INP=0,@INV@(INL)=""
 ;; Q
 ;;M G @DIXX
