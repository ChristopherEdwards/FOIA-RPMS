INHUTSRD(DIR,DIRH,DIRT,DICHCS) ; ESS,JSH; 11 Apr 94 13:58; scrolling reader routine without key control - non SAIC-CARE version 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;This routine is saved as UTSRD for pre version 4.2 & DHCP systems
 ;
 N Q,DX,DY,%,Z,K
 N DIRA,DIRB,DIRBS,DIRER,DIRHI,DIRLO,DIRTC,DIRF,DIRECHO,DIRL1,DIRL2,DIRWRAP
 S:'$D(DTIME) DTIME=300 K DTOUT
A ;
 N:$P(DIR,";",10)'="" X S Q=$P(DIR,";",14) S:Q]"" @Q=0
 I $P(DIR,";",12) N DTIME S DTIME=$P(DIR,";",12)
 S DIRF=$P(DIR,";",5),DIRECHO=$P(DIR,";",11)
 ;
 S DIRL1=+$P(DIR,";",4),DIRL2=+$P($P(DIR,";",4),",",2),DIRL2=$S(DIRL2=0:254,DIRL2'?1.3N:254,1:DIRL2),DIRL3=+$P($P(DIR,";",4),",",3)
 D:$P(DIR,";",13) FLUSH
I W $P(DIR,";") W:DIRF'="" DIRF_"// "
 S DIRER=0 X:DIRECHO ^%ZOSF("EOFF")
 R X#DIRL2+('DIRL3):DTIME E  G TO
R1 G:X="^" Q1 G:X="^^" Q2
 I X="" S X=DIRF W X G:DIRF'=""!'($P(DIR,";",8)) Q S DIRER=6 D ER G I
 I $E(X)="?" G:$G(DIRH)=1 Q D  D:DIRER ER G I
 .I '$D(DIRH) S DIRER=8 D ER Q  ;because of level can't just G ER
 .I $E(DIRH)=U X $P(DIRH,U,2,99) W ! Q
 .I $D(DIRH)<9 W !,$S($G(DIRH)]"":DIRH,1:"NO HELP AVAILABLE")
 .F Z=1:1 Q:'$D(DIRH(Z))#2  W !,DIRH(Z)
 .W !
 X $P($G(DIR),";",9) I '$D(X) S DIRER=1 D ER G I
 I $P(DIR,";",2)'="" X "I X?"_$P(DIR,";",2) E  S DIRER=1 D ER G I
 I $P(DIR,";",6)'="" S DIRLO=$P(DIR,";",6),DIRHI=+$P(DIRLO,",",2),DIRLO=+DIRLO I DIRLO>+X!(DIRHI<+X) S DIRER=2 D ER G I
 S DIRER=$S(DIRL2<$L(X):3,DIRL1>$L(X):4,1:0) I DIRER=3,DIRL3 G Q
 I DIRER D ER G I
 ;
Q ;
 X:$P(DIR,";",10)]"" "S ("_$P(DIR,";",10)_")=X"
 X:DIRECHO ^%ZOSF("EON")
 Q
Q1 S:Q]"" @Q=1 G Q
Q2 S:Q]"" @Q=3 G Q
TO S:Q]"" @Q=2 S DTOUT=1 G Q
 ;
 ;
 ;returns 1 for YES, 0 for NO, 0^0=^, 0^1=TIMED OUT
YN(DIR,DIRH) N D,P,X,DIRA,DIRB,DIRBS,DIRER,DIRHI,DIRLO,DIRTC,DIRF,DIRECHO,DX,DY
 S P=$P(DIR,";"),DIRI=1 I P="",$P(DIR,";",2)["^" S P="Enter (Y/N):"
YN0 S D=$P(DIR,";",2),D=$S(D="":0,1:D#2+1),DIRMAX=3,DIRF=$S(D:$P("N^Y",U,D),1:""),DIRCP=1
YNA W:P]"" ! W P_$J("",4-$L(P)) W:DIRF]"" DIRF_"// " R X#3:DTIME Q:'$T "0^1"
 ;X ^%ZOSF("TRMRD") I Y'=0,Y'=13 S DIRER=1 D ER,FLUSH G YNA
YN1 I $E(X)="^" Q "0^0"
 I $E(X)="?" Q:$G(DIRH) "0^?" S DIRER=9 D @$S($G(DIRH)]"":"H1",1:"ER") G YNA
 S:X="" X=DIRF
 S X=$E(X),X=$S("YyNn^"'[X:0,X=""&D:D,X="":0,"Yy"[X:2,"Nn"[X:1,1:0)
 I 'X S DIRER=9 D ER G YNA
 W " ",$P("(No)^(Yes)",U,X) Q X-1
H1 I $E($G(DIRH))=U X:$G(DIRECHO) ^%ZOSF("EON") X $P(DIRH,U,2,99) X:$G(DIRECHO) ^%ZOSF("EOFF") Q
 W !,$S($G(DIRH)]"":$E(DIRH,1,78),1:"NO HELP AVAILABLE") Q
FLUSH N X X ^%ZOSF("EOFF") F  R *X:0 Q:X=-1
 X ^%ZOSF("EON") Q
 ;
CR() ;
CR0 R !,"Press <RETURN> to continue:",X#200:DTIME Q $E($G(X))="^"!'$T
 ;
MESS1(DIR) ;
 N I,L S L=$L(DIR,"|")
 F I=1:1:L W $P(DIR,"|",I) W:I<L !
 W *7 R L#100:DTIME Q $E(L)="^"
 ;
ER W:$T(ER+DIRER)]"" !,$P($T(ER+DIRER),";",3),! W *7 Q
 ;;INVALID
 ;;ENTRY OUT OF RANGE
 ;;INPUT TOO LONG
 ;;INPUT TOO SHORT
 ;;TIMED OUT
 ;;THIS FIELD REQUIRED
 ;;HALT NOT ALLOWED
 ;;NO HELP AVAILABLE
 ;;ENTER YES OR NO
 Q
