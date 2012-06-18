INHDIPZ3 ;JSH; 8 Apr 94 17:02;Modify FileMan generated code.
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
MOD(G,%WRT,%YS,%DREF,%START,%END) ;
 ;Scan through @G array and modify the Write statements
 ;%WRT = Write messages (0 = NO, 1:default = YES)
 ;%YS = Substitute $Y references (0 = NO, 1:default = YES)
 ;%DREF = Routine which all non-specific DOs are invoked from
 ;%START = starting node (default: first)
 ;%END = ending node (default: last)
 S:'$D(%WRT) %WRT=1 S:'$D(%YS) %YS=1 S:'$D(%END) %END=99999
 N C,CL,CL1,COND,DE,F,FP,I,J,L,LZ,NL,P,P1,P2,P3,PAR,PC,Q,QS,WE,Z
 S Q=""""
 S I=$G(%START)-.00001 F  S I=$O(@G@(I)) Q:'I  Q:I>%END  S L=^(I) D  S @G@(I)=L
 . S P=1,QS=0 W:%WRT "."
 . F  D  Q:P'<$L(L)  S P=P+1
 .. I $E(L,P)=Q S QS='QS Q
 .. Q:QS
 .. I $E(L,P,P+2)=" D " S Z=L K L S L=Z D DO(.L,.P),LFIX Q
 .. I $E(L,P,P+1)="$Y" S L=$E(L,1,P-1)_$S(%YS:"INL",1:0)_$E(L,P+2,999),P=P+2 Q
 .. I $E(L,P,P+1)="$X" S L=$E(L,1,P-1)_"INP"_$E(L,P+2,999),P=P+2 Q
 .. I $E(L,P,P+2)=" W " S Z=L K L S L=Z D W(.L,.P,0),LFIX Q
 .. I $E(L,P,P+2)=" W:" S Z=L K L S L=Z D W(.L,.P,1),LFIX Q
 Q
 ;
LFIX ;Reset lines
 F J=0:1 Q:'$D(L(J))  S @G@(J/100+I)=L(J),L=L(J)
 S I=J-1/100+I Q
 ;
DO(%L,%P) ;Convert a DO statement
 ;%L = line of code
 ;%P = position
 N I,P2,C,LZ
 S LZ=0,%L(LZ)=$E(%L,1,%P-1)
 S P2=$$ENDW(%L,%P+3," "),DE=$E(%L,%P+3,P2) Q:DE=""
 F PC=1:1:$L(DE,",") D
 . S C=$P(DE,",",PC),P3=$$ENDW(C,1,":"),C=$E(C,1,P3),COND=$E($P(DE,",",PC),P3+1,999) D CONDSET:COND]""
 . I C["^DIWW" S NL=" D "_$P(C,"^")_"^DIWWA" D SET Q
 . I $G(%DREF)]"" S F=0 D  Q:F
 .. F I=1:1:$L(%DREF,",") I $P($P(%DREF,",",I),";")=C S NL=" D "_$P($P(%DREF,",",I),";",2)_COND D SET S F=1 Q
 . S NL=" D "_C_COND D SET Q
 I $L($E(%L,P2+1,999)) S LZ=LZ+1,%L(LZ)=$E(%L,P2+1,999),%P=0
 Q
 ;
CONDSET ;Check for $X and $Y in COND
 N P,P1 S P=0
 F  S P1=$F(COND,"$X",P) S:'P1 P1=$F(COND,"$Y",P) Q:'P1  D
 . S COND=$E(COND,1,P1-3)_$P("INP^INP^0^INL",U,$E(COND,P1-1)="Y"+1+%YS)_$E(COND,P1,999),P=P1+1
 Q
 ;
W(%L,%P,%I) ;Convert Write statements
 ; %L = Line of code
 ; %P = Starting position of ' W '
 ; %I = condition present (0:default = NO, 1 = YES)
 N P2,WE,QS,CL,NL,Q,PC,LZ,COND,P1 S %I=+$G(%I),COND=""
 S %L(0)=$E(%L,1,%P-1)
 I %I S P1=$$ENDW(%L,%P+1," "),COND=$E(%L,%P+2,P1),%P=P1-1
 S P2=$$ENDW(%L,%P+3," "),WE=$E(%L,%P+3,P2) Q:P2=""
 D:COND]"" CONDSET
 S PC=1,CL="",(PAR,QS,LZ)=0,Q="""" F PC=1:1:$L(WE) D
 . I $E(WE,PC)=Q S QS='QS
 . I 'QS,"()"[$E(WE,PC) S PAR=PAR+$P("1^-1",U,$E(WE,PC)=")"+1)
 . I " ,"'[$E(WE,PC)!QS!PAR S CL=CL_$E(WE,PC) Q:PC'=$L(WE)
 . Q:QS!PAR
 . I CL="!" S NL=" S"_COND_" INL=INL+1,INP=0,@INV@(INL)=""""" D SET Q
 . I CL?1"?"1.N S NL=" S"_COND_" INP0=INP,@INV@(INL)=$G(@INV@(INL))_$J("""","_+$P(CL,"?",2)_"-INP),INP=$S("_+$P(CL,"?",2)_"<INP0:INP0,1:"_+$P(CL,"?",2)_")" D SET Q
 . I $L(CL)>90 S NL=" S"_COND_" @INV@(INL)=$G(@INV@(INL))_"_CL S CL1=CL D SET S NL=" S"_COND_" INP=INP+$L("_CL1_")" D SET Q
 . S NL=" S"_COND_" @INV@(INL)=$G(@INV@(INL))_"_CL_",INP=INP+$L("_CL_")" D SET Q
 I $L($E(%L,P2+1,999)) S LZ=LZ+1,%L(LZ)=$E(%L,P2+1,999),%P=0
 Q
 ;
SET ;Set new info in place
 I $L(%L(LZ))+$L(NL)<240 S %L(LZ)=%L(LZ)_NL,%P=$L(%L(LZ))+1 S CL="" Q
 S LZ=LZ+1,%L(LZ)=NL,%P=$L(NL)+1
 S CL="" Q
 ;
WP ;Word Processing
 S NL=" S LM=$O(^UTILITY($J,""W"",0)) I LM]"""" F I=0:0 S I=$O(^UTILITY($J,""W"",LM,I)) Q:'I  S X=^(I,0) S @INV@(INL)=@INV@(INL)_$J("""",LM-INP-1)_X D N" D SET
 S LZ=LZ+1,%L(LZ)="",NL=" K ^UTILITY($J,""W"")" D SET
 I $L($E(%L,P2+1,999)) S LZ=LZ+1,%L(LZ)=$E(%L,P2+1,999),%P=0
 Q
 ;
ENDW(%L,%P,%TERM) ;Find end of a statement and return it
 N QS,Q,P,FP
 S QS=0,Q="""",FP=0
 F P=%P:1:$L(%L) D  Q:FP
 . I $E(%L,P)=Q S QS='QS
 . Q:QS
 . S:%TERM[$E(%L,P) FP=P
 Q $S(FP:FP-1,1:$L(%L))
 ;
