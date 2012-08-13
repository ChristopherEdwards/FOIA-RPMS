INHSGZ21 ;JSH; 1 Jul 97 10:20;Continuation of INHSGZ2
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L(%L,%C) ;Place a line in the global
 G L1^INHSGZ2
 ;
PROC ;Check if field is to be used in lookup
 ;Also look for the .01 field
 ;Create template code for it
 N ML,DL,DA,Y,DQI,X,DICOMPX,I,F,I0
 S DL=$G(^INTHL7F(FIELD,"C")) Q:DL=""   ;I DL="" D WARN^INHSGZ2("Field '"_$P(FIELD(0),U)_"' is missing a data location - IGNORED.") Q
 S ML=$P(^INTHL7F(FIELD,0),U,3)
DIC K DIC S X=DL,DIC="^DD("_+FILE(FLVL)_",",DIC(0)="FZ",DIC("S")="I $P(^(0),U,2)'[""C""" D ^DIC I Y>0 S DICOMPX=+FILE(FLVL)_U_+Y,%=1 D  G FOK:% Q
 . Q:'$P(^DD(+FILE(FLVL),+Y,0),U,2)
 . S MULT=+$P(^(0),U,2) I $P(^DD(MULT,.01,0),U,2)["W" D  S (MULT,%)=0 Q
 .. N N S N=$P($P(^DD(+FILE(FLVL),+Y,0),U,4),";") I $P(FIELD(0),U,4) D  Q
 ... S A="I $G(DIPA("""_SVAR_"""))]"""" N I,% S %=0,INDIG=DIE_DA_"","""""_N_""""")"" F I=0:0 S:'$O(@INDIG@(I)) ^(I+1,0)=DIPA("""_SVAR_"""),%=1,@INDIG@(0)=U_U_(I+1)_U_(I+1)_U_DT S I=$O(@INDIG@(I)) Q:%" D TL
 .. S A="I $G(DIPA("""_SVAR_"""))]"""" S INDIG=DIE_DA_"","""""_N_""""")"" K @INDIG S @INDIG@(1,0)=DIPA("""_SVAR_"""),@INDIG@(0)=U_U_1_U_1_U_DT" D TL
 S J(0)=+FILE(FLVL),I(0)="" I '$D(^DD(J(0))) D ERROR^INHSGZ2("File #"_+FILE_" does not exist.") Q
 S DA="DA(",DQI="Y(",DICOMPX="",X=DL S:X X="#"_X
 I $E(X)'="@" D ^DICOMP I '$D(X),'MULT D ERROR^INHSGZ2("DATA LOCATION for field '"_$P(FIELD(0),U)_"' is invalid.") Q
 I MULT S FLVL=FLVL-1,MULT=0,A="||" D TL S MULTL(0)=1 G DIC
FOK I $G(MULTL(0)) S $P(MULTL(MULTL),U,3)=+$P(DICOMPX,U,2),MULTL=MULTL-1 K MULTL(0)
 D:OTHER
 . I $L(DICOMPX,";")=1,DICOMPX[(+FILE(FLVL)_U_".01") D  Q
 .. S A="" D L(.STORE,1) S A="IF $D(@INV@("""_SVAR_"""))" D L(.STORE,1) S A="OTHER "_+FILE(FLVL)_";"_SVAR,SVAR(.01)=SVAR D L(.STORE,1)
 . I UFL S A="MATCH "_SVAR_"="_DL_";E" D L(.STORE,1)
 I REPEAT,'OTHER D
 . I $L(DICOMPX,";")=1,DICOMPX[(+FILE(FLVL)_U_".01") D  Q
 .. S A="" D L(.STORE,1) S A="IF $D(@INV@("""_SVAR_"""))" D L(.STORE,1) S A="MULT "_$P(^DD(+FILE(FLVL-1),MULTF,0),U)_";"_SVAR,SVAR(.01)=SVAR D L(.STORE,1)
 .. S ^UTILITY("INDIA",$J,.01)=MULTF_"///^S X=$E(DIPA("""_SVAR_"""),1,"_ML_")"
 . I UFL S A="MATCH "_SVAR_"="_DL_";E" D L(.STORE,1)
 I MULT D  Q
 . S F=$P(DICOMPX,";")
 . I MULT'=+FILE(FLVL) S A="S DLAYGO="_MULT D TL S A=$P(F,U,2)_"///"_$E("/",+$P(FIELD(0),U,5))_"^S X=$E($G(DIPA("""_SVAR_""")),1,"_ML_")" D TL D  Q
 .. I INAUDIT S ADL=DL,AMULT=$P(F,U,2),DL="LAST(#"_AMULT_")" D FIELD^INHSGZ22(+FILE(FLVL)) S DL=ADL
 .. I '$O(^DD(MULT,.01)) S MULT=0 Q
 .. S MULTL=MULTL+1,MULTL(MULTL)=(TEMP-.5)_"^"_SVAR
 .. S A=".01///"_$E("/",+$P(FIELD(0),U,5))_"^S X=$E($G(DIPA("""_SVAR_""")),1,"_ML_")" D TL S FLVL=FLVL+1,FILE(FLVL)=+MULT Q
 . S A=$P(F,U,2)_"///"_$E("/",+$P(FIELD(0),U,5))_"^S X=$E($G(DIPA("""_SVAR_""")),1,"_ML_")" D TL
 . I INAUDIT S ADL=DL,DL="1ST(#"_AMULT_":#"_$P(F,U,2)_")" D FIELD^INHSGZ22(+FILE(FLVL-1)) S DL=ADL
 G:REPEAT!OTHER T
 I $L(DICOMPX,";")=1,DICOMPX[(+FILE(FLVL)_U_".01") S IDENT=1 S:'$D(LSR) ^UTILITY("INS",$J,701)="IDENT "_SVAR_"|CR|",^UTILITY("INS",$J,798)="SAVE "_$P(SEG(0),U,2)_".01|CR|" S FSAV(+FILE(FLVL))=$P(SEG(0),U,2)_".01" G T
 I UFL S A="MATCH "_SVAR_"="_DL_";E" D L(.LOOKUP,1)
T I $O(^INTHL7F(FIELD,6,0)) S I=0 F  S I=$O(^INTHL7F(FIELD,6,I)) Q:'I  S A=$P(^(I,0),"|CR|") D:A]"" TL
 Q:'DICOMPX  D:INAUDIT FIELD^INHSGZ22(+FILE(FLVL)) I REPEAT,'OTHER,DICOMPX[(+FILE(FLVL)_U_".01") Q
 F I=$L(DICOMPX,";"):-1:1 S F=$P(DICOMPX,";",I) D
 . I I=1 S A=$P(F,U,2)_"///"_$E("/",+$P(FIELD(0),U,5))_"^S X=$E($G(DIPA("""_SVAR_""")),1,"_ML_")"_$P(" S:X="""" X=""@""",U,$P(FIELD(0),U,6)) D TL Q
 . S A=$P(F,U,2)_":" D TL
 I $L(DICOMPX,";")>1 F I=2:1:$L(DICOMPX,";") S A="||" D TL
 Q
 ;
TL ;Place a line in the template
 I 'INSYS,A["//^S X=" S TEMP=TEMP+1,^UTILITY("INDIA",$J,TEMP)="K INY "_$P(A,"^",2,99)_" S INY(DP_"",""_"_+A_")=X"
 S TEMP=TEMP+1,^UTILITY("INDIA",$J,TEMP)=A Q
 ;
LINK ;Link up files by adding code to template
 ;+FILE(FLVL) = current file level
 N F,I,J,K
 S F=+FILE(FLVL),I="",K=.04
 F  S I=$O(FSAV(I)) Q:'I  D
 . Q:'$D(^DD(I,0,"PT",F))
 . S J=0 F  S J=$O(^DD(I,0,"PT",F,J)) Q:'J  S K=K+.01,^UTILITY("INDIA",$J,K)=J_"///^S X=$S($G(@INV@("""_FSAV(I)_"""))>0:""`""_@INV@("""_FSAV(I)_"""),1:"""")"
 Q
