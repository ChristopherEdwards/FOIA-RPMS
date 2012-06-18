INHSZ21 ;JSH,DGH; 20 Dec 1999 09:35 ;INHSZ2 continued outbound msg; 19 Dec 91  1:00PM 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 10; 23-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;Changes needed for X12, NOT for NCPDP after redesign.
L G L^INHSZ1
 ;
DELIM ;Set delimiter character
 N %1 S %1=$$LBTB^UTIL($P(LINE,"=",2))
 I MODE="I" D DELI G DELQ
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1"""""""".E.""""""""")
 S A=" S DELIM="""_$P($P(%1,"""",2),"""")_"""" D L
DELQ S DELIM=1,DICOMPX("DELIM")=""""_$P($P(%1,"""",2),"""")_""""
 Q
DELI ;INPUT mode version of delimiter set.
 N DICOMPX S DICOMPX("DATA")="$$GL^INHOU(UIF,LCT)",X=%1 D DICOMP(.X)
 I '$D(X) D ERROR^INHSZ0("Invalid expression to set the DELIMITER.",1) Q
 S A=" "_X_" S DELIM=X K DXS" D L Q
 ;
SUBDELIM ;set subdelimiter character
 N %1 S %1=$$LBTB^UTIL($P(LINE,"=",2))
 I MODE="I" D SUBI G SUBQ
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1"""""""".E1""""""""")
 S A=" S SUBDELIM="""_$P($P(%1,"""",2),"""")_"""" D L
SUBQ S SUBDELIM=1,DICOMPX("SUBDELIM")=""""_$P($P(%1,"""",2),"""")_""""
 Q
SUBI ;INPUT mode version of subdelimiter set
 N DICOMPX S DICOMPX("DATA")="$$GL^INHOU(UIF,LCT)",X=%1 D DICOMP(.X)
 I '$D(X) D ERROR^INHSZ0("Invalid expression to set the SUBDELIMITER.",1) Q
 S A=" "_X_" S SUBDELIM=X K DXS S INDELIMS=DELIM_$P(Y(1),DELIM,2)" D L
 Q
 ;
SET ;SET statement
 I MODE="I" D ERROR^INHSZ0("SET statement allow in Output scripts only.",1) Q
 Q:'$$SYNTAX^INHSZ0($$LB^UTIL($P(LINE,COMM,2,99)),"."" ""1.ANP1""=""1.E")
 N %1,I,J,V,X,INXFRM,INCONV
 S V=$$LBTB^UTIL($P($P(LINE,"SET",2),"="))
 S A=" ;"_LINE D L
 S X=$$LB^UTIL($P(LINE,"=",2)) S:X X="#"_X
 ;Following replaces old INSGX function
 I $E(X,1,5)="INSGX" S INXFRM=$P(X,"\",2),INCONV=$P(X,"\",3),LEN=$P(X,"\",4),X=$P(X,"\",5,99)
 S DICOMPX=""
 D ATSET(X),DICOMP(.X,0,1)
 I FILE="",$P(DICOMPX,U)=0 K X
 I '$D(X) D ERROR^INHSZ0("Invalid expression in SET statement.",1) Q
 S A=" S D0=INDA "_X D L
 ;To replace INSGX function create another line in compiled code which
 ;will execute the transform or the conversion.
 I ($L($G(INXFRM))!$L($G(INCONV))) D
 .I $L($G(INXFRM)) S A=" S X1="""_INXFRM_""" X:$L($G(@X1)) $G(@X1)"
 .S A=A_" S X=$E(X,1,"_LEN_")"
 .I $L($G(INCONV)) S A=A_" S X1="""_INCONV_""" X:$L($G(@X1)) $G(@X1)"
 .D L
 S A=" S @INV@("""_V_""")=X K DXS,D0" D L S SET(V)="",DICOMPX(V)="@INV@("""_V_""")"
 Q
 ;
IF ;IF statement
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"1."" ""1.ANP")
 N I,J,DA,DQI,X,Q,D0,%1 S D0=0
 S A=" ;"_LINE D L
 S (%1,X)=$$LBTB^UTIL($P(LINE," ",2,999))
 D ATSET(X),DICOMP(.X)
 G:'$D(X) IFM
 I Y'["B" D ERROR^INHSZ0("Expression is not Boolean in structure.",1) Q
 S:X["D0" D0=1
 I MODE="I",SECT'="STORE",D0 D ERROR^INHSZ0("Expression involves a file entry which is not yet determined.",1) Q
 S A=" "_X_" K DXS,D0 I X" D L
IFQ S IF=IF+1,A=" D:$T" D L,DOWN^INHSZ1("I") Q
 ;
IFM ;IF may be MUMPS code
 S X="I "_%1 D ^DIM I '$D(X) D ERROR^INHSZ0("Expression INVALID.",1) Q
 S A=" "_X D L G IFQ
 ;
ENDIF ;end of an IF block
 I 'IF D ERROR^INHSZ0("No active IF to end.",0) Q
 I $P(INDS(DOTLVL),U)'="I" D ERROR^INHSZ0("Misplaced ENDIF",0) Q
 S IF=IF-1 D UP^INHSZ1 Q
 ;
DICOMP(X,%N,%W) ;Run DICOMP to evaluate expression
 ;X= expression to evaluate (pass by reference)
 ;If %N=1 then DICOMPX will not be used
 ;If %W=1 then WP fields may be specified - first line will be used
 N %,V,V1,I,J,DICOMP,DS,DL,DE,DICMX,INOLDX N:$G(%N) DICOMPX
 S:$G(%W) DICMX="S INX=$P(X,""|CR|"") Q "
 S DA="DXS(",DQI="Y(",DICOMP="",I(0)="^"_$P(FILE,U,2),J(0)=+FILE,DICOMP="",INOLDX=X
 D ^DICOMP I '$D(X) D  Q:'$D(X)
 .  Q:$G(MODE)="I"   ;Don't double check inbound scripts
 .  S %=$P($G(^DIC(+FILE,0)),U,1) S:'$L(%) %=$P($G(^DD(+FILE,0)),U,1)
 .  W *7,!!,"Ambiguity in the following expression:"
 .  W !,"Current base file: ",%," (#",+FILE,")",!,"Expression:  ",INOLDX,!
 .  S X=INOLDX,DICOMP="?" D ^DICOMP S DICOMP=""
 .  W !,"Ambiguity ",$S($D(X):"",1:"NOT "),"resolved.",!
 F I=0:0 S I=$O(X(I)) Q:'I  S:X(I)["D0" D0=1 S A=" S DXS("_I_")="""_$$REPLACE^UTIL(X(I),"""","""""")_"""" D L
 S:Y["w"!(Y["l") X="K INX "_X_" S X=$G(INX)"
 Q
 ;
ATSET(X) ;Set DICOMPX array for any @variables in the code
 ;X = code to process
 N Q,I,J
 S Q=0 F I=1:1:$L(X) D
 . I $E(X,I)="""" S Q='Q Q
 . Q:$E(X,I)'="@"
 . F J=I+1:1 Q:$E(X,J)'?1AN
 . S DICOMPX($E(X,I,J-1))="$G(INA("""_$E(X,I+1,J-1)_""""_$G(WHSUB)_"))",I=J
 Q
 ;
WHILE ;WHILE loop initiate 
 N %E I $D(LINE)>9 D ERROR^INHSZ0("Line too long.",1)
 S %E=$$LBTB^UTIL($P(LINE,"WHILE",2,99))
 S:$P(%E," ")="~REQUIRED~" %E=$$LBTB^UTIL($P(LINE,"~REQUIRED~",2,99))
 I '$L(%E) D ERROR^INHSZ0("Condition missing from WHILE statement.",1) Q
 G:MODE="O" WHILE^INHSZ20
 S X="I "_%E D ^DIM I '$D(X) D ERROR^INHSZ0("Condition not valid.",1) Q
 S A=" ;"_LINE D L S WHILE=WHILE+1
 I $P(LINE," ",1,2)="WHILE ~REQUIRED~" S A=" I $P($$GL^INHOU(UIF,LCT),DELIM)'="_$P(%E,"=",2)_" Q:'$$CHECKSEG^INHOU("_$P(%E,"=",2)_",1,"_WHILE_")"_$S(WHILE>1:"",1:" 2") D L
 S A=" S INI("_WHILE_")=1 F  "_$S(MODE="I":"S DATA=$$GL^INHOU(UIF,LCT) Q:'$$CHECKSEG^INHOU("_$P(%E,"=",2)_",0,"_WHILE_")",1:"Q:'("_%E_")")_"  D  S INI("_WHILE_")=INI("_WHILE_")+1" D L
 D DOWN^INHSZ1("W")
 S WHSUB=WHSUB_",INI("_WHILE_")"
 Q
 ;
ENDWHILE ;End of while loop
 I 'DOTLVL D ERROR^INHSZ0("No active WHILE to end.",1) Q
 I $P(INDS(DOTLVL),U)'="W" D ERROR^INHSZ0("Misplaced ENDWHILE.",1) Q
 G:MODE="O" ENDWHILE^INHSZ20
 S WHILE=WHILE-1 D UP^INHSZ1 S WHSUB=$P(WHSUB,",",1,WHILE+1) S:'WHILE WHSUB=""
 Q
 ;
GROUP ;Initiate a GROUP
 I $P(LINE,COMM,2)]"" D WARN^INHSZ0("Characters after GROUP ignored.",1)
 S A=" ;Start of GROUP" D L
 S A=" F  S MATCH=0 D  Q:'MATCH" D L
 D DOWN^INHSZ1("G") S GROUP=1 Q
 ;
ENDGROUP ;End of group
 I 'DOTLVL D ERROR^INHSZ0("No active GROUP to end.",1) Q
 I $P(INDS(DOTLVL),U)'="G" D ERROR^INHSZ0("Misplaced ENDGROUP.",1) Q
 D UP^INHSZ1 S GROUP=0 Q
 ;
ERROR ;ERROR command
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2),"."" ""1""=""."" ""1""""""""1.ANP1""""""""."" "".1"";""."" "".1N")
 N M,T
 S M=$$LBTB^UTIL($P($P(LINE,"=",2),";"))
 S T=$$LBTB^UTIL($P(LINE,";",2))
 I T]"",$L(T)>1!("12"'[T) D ERROR^INHSZ0("Illegal error type '"_T_"' in ERROR statement.",1) Q
 S:T="" T=2
 S A=" D ERROR^INHS("_M_","_T_")" D L
 Q
 ;
BHLMIEN ;Set Message IEN
 N %1 S %1=$$LBTB^UTIL($P(LINE,"=",2))
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1"""""""".E.""""""""")
 S A=" S BHLMIEN="""_$P($P(%1,"""",2),"""")_"""" D L
 S BHLMIEN=1,DICOMPX("BHLMIEN")=""""_$P($P(%1,"""",2),"""")_""""
 Q
