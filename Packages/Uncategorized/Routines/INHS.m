INHS ;JSH; 16 Nov 95 16:45;Interface - Script utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
ERROR(MESS,TYPE) ;Report an error in a script
 ;MESS = error message (if passed by reference it may contain subscripts)
 ;TYPE = type of error:
 ;          1 = Non-fatal
 ;          2 = Fatal (default)
 ;
 S:$G(TYPE)="" TYPE=2
 S INSTERR=$S(INSTERR>TYPE:INSTERR,1:TYPE)
 I $D(MESS)<9 S MESS(1)=$G(MESS)
 N I
 S I=0 F  S I=$O(MESS(I)) Q:'I  S INHERCNT=$G(INHERCNT)+1,INHERR(INHERCNT)=MESS(I)
 Q
 ;
SREPERR(UIF,ERROR) ;Script reports an error
 ;UIF = entry # in UIF
 ;ERROR = array of error messages
 ;
 ;First, log in UIF
 D ULOG^INHU(UIF,"",.ERROR)
 ;Log in the IEF
 D END^INHE(UIF,.ERROR)
 Q
 ;
MC ;Check if time to move variables to a global
 Q:INV["^"
 I $S<INSMIN M ^UTILITY("INV",$J)=INV K INV S INV="^UTILITY(""INV"",$J)"
 Q
MC1 ;Check if time to move variables to a global
 Q:INVTMP["^"
 I $S<INSMIN M ^UTILITY("INVTMP",$J)=INVTMP K INVTMP S INVTMP="^UTILITY(""INVTMP"",$J)"
 Q
MC2 ;Check if time to move variables to a global
 Q:%INV["^"
 I $S<INSMIN M ^UTILITY("%INV",$J)=%INV K %INV S %INV="^UTILITY(""%INV"",$J)"
 Q
 ;
WP(%D,%F,%V,%M) ;Word processing store
 ;%D = file # which contains the multiple field [REQD]
 ;%F = WP field # within %D [REQD]
 ;%V = reference whose next level descendents have text [REQD]
 ;        ex. @%V@(1) has first node, @%V@(2) has second node, etc.
 ;%M = mode of operation (0:default = OVERWRITE, 1 = APPEND) [REQD]
 ;Assumes DIE set to current global reference
 ;Assumes the DA array is properly constructed
 Q:'$G(%D)!'$G(%F)!'$D(DA)!($G(DIE)="")!($G(%V)="")  Q:'$D(^DD(%D,%F))  S %M=+$G(%M)
 N N,G,I,%,J
 S N=$P($P(^DD(%D,%F,0),U,4),";") Q:'$L(N)
 S:$D(@%V)<9 @%V@(1)=@%V
 S G=DIE_DA_","_$S(+N=N:N,1:""""_N_"""")_")" L +@G
 I '%M D  Q
 . K @G S (%,I)=0 F  S I=$O(@%V@(I)) Q:'I  S %=%+1,@G@(I,0)=@%V@(I)
 . S @G@(0)=U_U_%_U_%_U_DT L -@G
 S (%,I)=0 F  Q:'$O(@G@(I))  S %=%+1,I=$O(@G@(I))
 S J=0 F  S J=$O(@%V@(J)) Q:'J  S %=%+1,I=I+1,@G@(I,0)=@%V@(J)
 S @G@(0)=U_U_%_U_%_U_DT L -@G
 Q
 ;
GSAVE(%G) ;Save array into message - called from within a script
 ;%G = array reference [eg. ^UTILITY("X",2, ]
 ;DO NOT include variables in %G!
 Q:%G=""
 N A,B,C S A=%G,C=$L(A),B=$E(A,1,$L(A)-1) S:B["(" B=B_")" Q:$D(@B)<9
 F  S B=$Q(@B) Q:$E(B,1,C)'=A  S LCT=LCT+1,^UTILITY("INH",$J,LCT)=$E(B,C+1,256),LCT=LCT+1,^UTILITY("INH",$J,LCT)=@B
 Q
 ;
GLOAD(%G) ;Load array from message beginning at the current position
 ;%G = root reference where data should go
 ;   [eg. ^UTILITY(10, ]
 Q:%G=""
 N X,Y
 F  D GET^INHOU(UIF,0) Q:'$D(LINE)  S X=LINE D GET^INHOU(UIF,0) Q:'$D(LINE)  S Y=LINE,@(%G_X_"=Y")
 Q
