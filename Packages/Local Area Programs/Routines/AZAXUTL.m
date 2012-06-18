AZAXUTL ;IHS/PHXAO/AEF - UTILITY SUBROUTINES
 ;;V1.0;ANNE'S SPECIAL ROUTINES;;SEP 9, 2004
 ;
STACK ;EP
 ;----- PRINT STACK
 ;
 N I,J,X
 ;
 I '$D(IOM) S IOM=80
 ;
 W !,"$STACK="_$STACK
 W !
 F J=1:1:IOM W "-"
 ;
 F I=0:1:$STACK(-1) D
 . S X=$$PAD(I,"L",3,0)
 . W !,"$STACK("_X_")="_$STACK(I)
 . W !,"$STACK("_X_","_"""ECODE"""_")="_$STACK(I,"ECODE")
 . W !,"$STACK("_X_","_"""MCODE"""_")="_$STACK(I,"MCODE")
 . W !,"$STACK("_X_","_"""PLACE"""_")="_$STACK(I,"PLACE")
 . W !
 . F J=1:1:IOM W "-"
 Q
PAD(X,S,L,C)          ;EP
 ;----- PAD MACHINE - PAD CHARACTER STRING
 ;
 ;      X = DATA STRING
 ;      S = L=PADLEFT, R=PADRIGHT
 ;      L = LENGTH
 ;      C = PAD CHARACTER
 ;
 I $L(X)>L S X=$E(X,1,L) Q X
 S X=$TR(X," ","~")
 I S="R" D
 . S X=X_$J("",L-$L(X))
 I S="L" D
 . S X=$J("",L-$L(X))_X
 I C]"" S X=$TR(X," ",C)
 S X=$TR(X,"~"," ")
 Q X
