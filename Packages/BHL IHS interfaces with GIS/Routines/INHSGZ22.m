INHSGZ22 ;JSH; 16 Nov 95 17:05;Script generator - audit code
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
INIT ;Start to build audit routine
 D K S ARMAX=$G(^DD("ROU")) S:'ARMAX ARMAX=4000 S ARNAME="IV"_$E(SCR#100000+100000,2,6),(ARDC,ARNUM)=0
 D NEWROU Q
 ;
K ;Kill vars
 K ^UTILITY("INAUD",$J),ARNOBRK,ARNAME,ARMAX,ARDC,ARNUM,ARDL,ARSEG,ADL,AMULT Q
 ;
NEWROU ;Make new routine
 S ARNUM=ARNUM+1 K ^UTILITY("INAUD",$J,ARNUM) S ARLINE=0,Y=$$DT^UTDT X ^DD("DD")
 S ^UTILITY("INAUD",$J,ARNUM,1)=ARNAME_$S(ARNUM>1:$C(63+ARNUM),1:"")_" ;Audit routine for message '"_$P(MESS(0),U)_"' compiled "_Y
 S ^UTILITY("INAUD",$J,ARNUM,2)=" ;Part "_ARNUM
 S:ARNUM=1 ^UTILITY("INAUD",$J,1,2.5)="INIT S INAUDWP=0 K ^INVQA(UIF,1) Q",^(2.6)="FINISH S ^INVQA(UIF,1,0)=""^^""_+$G(INAUDWP)_""^""_+$G(INAUDWP) K ^UTILITY(""INVAUD"",$J) Q"
 S ^(3)="L(%X) ;Place line in WP field",^(4)=" S INAUDWP=INAUDWP+1,^INVQA(UIF,1,INAUDWP,0)=%X_""|CR|"" Q"
 S ^(5)="EN ;",ARLINE=5,ARSIZE=250 Q
 ;
L(%X) ;Add line to routine
 I '$D(ARNOBRK) D:ARSIZE+$L(%X)>ARMAX
 . S ^UTILITY("INAUD",$J,ARNUM,ARLINE+1)=" G EN^"_ARNAME_$C(64+ARNUM) D NEWROU
 S ARLINE=ARLINE+1,^UTILITY("INAUD",$J,ARNUM,ARLINE)=%X,ARSIZE=ARSIZE+$L(%X) K ANOBRK Q
 ;
FILE ;File at end
 G:'$D(^UTILITY("INAUD",$J)) K
 W ! N INI,X S INI=0 F  S INI=$O(^UTILITY("INAUD",$J,INI)) Q:'INI  D
 .K ^UTILITY($J,0) M ^UTILITY($J,0)=^UTILITY("INAUD",$J,INI)
 .S X=$P(^UTILITY($J,0,1)," ") X ^DD("OS",^DD("OS"),"ZS") W !,"Audit routine: "_X_" ...filed"
 G K
 ;
SEGINIT ;Start a new segment
 D L($P(SEG(0),U,2)_" ;"_$P(SEG(0),U)) S ARSEG($P(SEG(0),U,2))=ARNUM
 D L(" Q:'$G(INAUDIT)  N ZDIE,X,Y,Z S ZDIE=$E(DIE(1),1,$L(DIE(1))-1) S:ZDIE[""("" ZDIE=ZDIE_"")"" S D0=INDA")
 D:REPEAT
 . D L(" D L("""_$P(SEG(0),U,2)_" - "_$P(SEG(0),U)_" Iteration #""_INI)")
 . D L(" D L(""File: "_$O(^DD(+FILE(FLVL),0,"NM",""))_$S($D(^DD(+FILE(FLVL),0,"UP")):" SUB-FIELD",1:"")_"     IEN: ""_INDA),L("""")")
 D:'REPEAT
 . D L(" D L("""_$P(SEG(0),U,2)_" - "_$P(SEG(0),U)_""")")
 . D L(" D L(""File: "_$O(^DD(+FILE(FLVL),0,"NM",""))_"     IEN: ""_INDA),L("""")")
 Q
 ;
SEGEND ;End a segment
 D L(" D L("""") Q") Q
 ;
FIELD(%F) ;Process a field
 ;%F = dictionary number
 N I,J,DICOMP,DICOMPX,DA,DQI,DICMX,X,Z,N,C,A,B
 S I(0)="@ZDIE@(",J(0)=%F,DA="DXS(",DQI="Y(",X=DL,DICOMPX="" S:+X=X X="#"_X D ^DICOMP
 Q:'$D(X)  I Y["D" S X=X_" S Y=X D DD^%DT S X=Y"
 I $D(X)>9 S I=0 F  S I=$O(X(I)) Q:'I  D L(" S DXS("_I_")="""_$$REPLACE^UTIL(X(I),"""","""""")_"""")
 S Z=$P(DICOMPX,";"),N=$J(INF,2),I=$E($P(^DD(+Z,$P(Z,U,2),0),U),1,16),I=I_$J("",16-$L(I)),C=$P(^DD(+Z,$P(Z,U,2),0),U,2)["C"
 I C,SLVL S A="S " D  D L(" "_A_"D"_SLVL_"=INDA") S X=X_" S D0=INDA"
 . F B=1:1:SLVL S A=A_"D"_(SLVL-B)_"=INDA("_B_"),"
 D L(" "_X_" K DXS")
 D L(" S Y=^UTILITY(""INVAUD"",$J,"_$$VEXP(SVAR)_",D="" """)
 I $P(DTY(0),U,2)="DT"!($P(DTY(0),U,2)="TS")!($P(DTY(0),U,2)="CP") D L(" S Z=X,X=Y "_^INTHL7FT(DTY,2)),L(" S Y=X,X=Z")
 I $P(DTY(0),U,2)="CN"!($P(DTY(0),U,2)="ID"),MAP D L(" S Y=$$MAP^INHVA2("_MAP_",Y,0),Y=$P(Y,U,2)")
 I $P(DTY(0),U,2)="CN"!($P(DTY(0),U,2)="CP") D L(" S:$L(Y)&(Y[SUBDELIM) Y=$P(Y,SUBDELIM,2,99)")
 D L(" I X'=Y S:'(Y=""""&(X=0)) D=""*""")
 D L(" S Y=Y_$J("""",50-$L(Y)),X=X_$J("""",50-$L(X)) D L(D_"""_N_". "_I_"   ""_Y_""     ""_X)")
 Q
 ;
VEXP(V) ;Expand variable
 N X,I
 S X=""""_V_""""
 F I=1:1:SLVL S X=X_",INI"_$S(I'=SLVL:"("_I_")",1:"")
 Q X_")"
