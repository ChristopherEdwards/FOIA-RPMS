INHSGZ23 ; LD,DGH ; 20 Dec 1999 09:09 ; X12 Script generator functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 1;
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
ISA ;Set up Message header (ISA) segment, (GS) segment , and (ST)
 ;
 ;
 S MESS(12)=$G(^INTHL7M(MESS,12))
 ;--ISA segment
 N I F I=1:1:5,7,8,12,14,15 S A=" SET ISA"_I_"="_""""_$P(MESS(12),U,I)_"""" D L^INHSGZ1(1)
 S A=" SET ISA6="_$S($E($P(MESS(12),U,6)="@"):$P(MESS(12),U,6),1:""""_$P(MESS(12),U,6)_"""") D L^INHSGZ1(1)
 S A=" SET ISA9="_"$E(INTX(NOW,""TS""),3,8)" D L^INHSGZ1(1)
 S A=" SET ISA10="_"$E(INTX(NOW,""TS""),9,12)" D L^INHSGZ1(1)
 S A=" SET ISA11=""U""" D L^INHSGZ1(1)
 S A=" SET ISA13=@INSEQ" D L^INHSGZ1(1)
 ;Concatenate subdelimiter (ISA16) to ISA15. Otherwise ISA16 will
 ;consist only of a subdelimiter and will be translated out in
 ;the compiled script.
 S A=" SET ISA15=ISA15_"_"DELIM"_"_"_"SUBDELIM" D L^INHSGZ1(1)
 S A=" LINE ""ISA"""
 ;--following specifies ISA as minimum/maximum length.
 S A=A_"^$E(ISA1,1,2)=FL()2,2,1^$E(ISA2,1,10)=FL()10,10,1^$E(ISA3,1,2)=FL()2,2,1^$E(ISA4,1,10)=FL()10,10,1^$E(ISA5,1,2)=FL()2,2,1^$E("
 S A=A_$S($E($P(MESS(12),U,6))="@":$P(MESS(12),U,6),1:"ISA6")
 S A=A_",1,15)=FL()15,15,1^$E(ISA7,1,2)=FL()2,2,1^$E(ISA8,1,15)=FL()15,15,1"
 S A=A_"^ISA9=FL()6,6,1^ISA10=FL()4,4,1"
 S A=A_"^ISA11=FL()1,1,1^$E(ISA12,1,5)=FR(0)5,5,1"
 S A=A_"^$E(ISA13,1,9)=FR(0)9,9,1"
 ;ISA15's length includes ISA15, delim and subdelim=3
 S A=A_"^ISA14=FL()1,1,1^ISA15=FL()3,3,1"
 D L^INHSGZ1(1)
 ;-- Specify the GS segment
 S A=" SET GS1="_""""_$P(MESS(12),U,9)_"""" D L^INHSGZ1(1)
 S A=" SET GS2="_""""_$P(MESS(12),U,10)_"""" D L^INHSGZ1(1)
 S A=" SET GS3="_""""_$P(MESS(12),U,11)_"""" D L^INHSGZ1(1)
 S A=" SET GS4="_"$E(INTX(NOW,""TS""),1,8)" D L^INHSGZ1(1)
 S A=" SET GS5="_"$E(INTX(NOW,""TS""),9,12)" D L^INHSGZ1(1)
 S A=" SET GS6=@INSEQ" D L^INHSGZ1(1)
 S A=" SET GS7=""T""" D L^INHSGZ1(1)
 S A=" SET GS8="_""""_$P(MESS(12),U,13)_"""" D L^INHSGZ1(1)
 S A=" LINE ""GS"""
 S A=A_"^$E(GS1,1,2)=ML()2,2,1^GS2=ML()15,2,1^GS3=ML()15,2,1^GS4=ML()8,8,1^GS5=ML()8,4,1^$E(GS6,1,9)=MR(0)9,1,1^GS7=ML()2,1,1^GS8=ML()12,1,1"
 D L^INHSGZ1(1)
 ;-- Specify the ST segment
 S A=" ^N INST S INST=LCT" D L^INHSGZ1(1)
 S A=" SET ST1="_""""_$P(MESS(12),U,16)_"""" D L^INHSGZ1(1)
 S A=" SET ST2=@INSEQ" D L^INHSGZ1(1)
 S A=" LINE ""ST"""
 S A=A_"^$E(ST1,1,3)=ML()3,3,1^$E(ST2,1,9)=MR()9,4,1"
 D L^INHSGZ1(1)
 Q
 ;
