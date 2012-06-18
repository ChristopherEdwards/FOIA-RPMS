BCHMSRE ; IHS/TUCSON/LAB - Edits for measurement values ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**16**;OCT 28, 1996
 ;
 ;called from input transform on measurement fields in chr record
 ;edits data value.
 ;
BP ;EP (BLOOD PRESSURE)
 NEW BCHBPS,BCHBPD
 I $L(X)>7!($L(X)<5)!'(X?2.3N1"/"2.3N) K X Q
 S BCHBPS=+$P(X,"/",1),BCHBPD=+$P(X,"/",2)
 I BCHBPS<20!(BCHBPS>275) K X G BPX
 I BCHBPD<20!(BCHBPD>200) K X G BPX
 I BCHBPS'>BCHBPD K X G BPX
 S X=BCHBPS_"/"_BCHBPD
BPX K BCHBPS,BCHBPD
 Q
HC ;EP (HEAD CIRCUMFERENCE)
 D:X?.E.A.E MHT
 Q:'$D(X)
 D HTHCC
 S:$P(X,".",2)?4N.N X=X+.0005,X=$P(X,".")_"."_$E($P(X,".",2),1,3)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>30)!(X<10)!(X?.E1"."4N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.125 X
 Q
HE ;EP (HEARING)
 K:X'="A"&(X'="N") X
 Q
HT ;EP (HEIGHT)
 D:X?.E.A.E MHT
 Q:'$D(X)
 D HTHCC
 S:$P(X,".",2)?4N.N X=X+.0005,X=$P(X,".")_"."_$E($P(X,".",2),1,3)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>80)!(X<10)!(X?.E1"."4N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.125 X
 Q
HTHCC Q:X'["/"
 Q:X'?2N1" "1N1"/"1N
 S X=$P(X," ")_+("."_($P($P(X," ",2),"/")*1000\$P($P(X," ",2),"/",2)))
 Q
 ;EP
MHT ;EP
 NEW BCHC,BCHI,BCHJ
 S BCHJ=$L(X) F BCHI=1:1:BCHJ S BCHC=$E(X,BCHI) I BCHC?1A S BCHC=$S(BCHC?1L:$C($A(BCHC)-32),1:BCHC)
 S (BCHI,BCHC)="" F BCHI=1:1:BCHJ S BCHC=$E(X,BCHI) Q:"C"[BCHC
 I BCHC="C" D @BCHC
 K BCHC,BCHI,BCHJ
 Q
PU ;EP (PULSE)
 K:+X'=X!(X>250)!(X<30)!(X?.E1"."1N.N) X
 Q
TMP ;EP (TEMPERATURE)
 K:+X'=X!(X>109.9)!(X<94)!(X?.E1"."2N.N) X
 Q
VC ;EP (VISION CORRECTED)
VU ;EP (VISION UNCORRECTED)
 I $L(X)>7!($L(X)<2)!'((X?2.3N)!(X?1"/"2.3N)!(X?2.3N1"/"2.3N)) K X Q
 I $P(X,"/")'="" I $P(X,"/")<10!($P(X,"/")>999) K X Q
 I $P(X,"/",2)'="" I $P(X,"/",2)<10!($P(X,"/",2)>999) K X Q
 Q
WT ;EP (WEIGHT)
 D:X?.E.A.E MWT
 Q:'$D(X)
 D WTC
 S:$P(X,".",2)?5N.N X=X+.00005,X=$P(X,".")_"."_$E($P(X,".",2),1,4)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>750)!(X<2)!(X?.E1"."5N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.0625 X
 Q
WTC Q:+X=X!(X'[" ")
 Q:'(X?1.3N1" "1.2N!(X?1.3N1" "1.2N1"/"1.2N))
 I X'["/" Q:+$P(X," ",2)>16  S X=+X+(+$P(X," ",2)/16) Q
 Q:+$P($P(X," ",2),"/")'<+$P($P(X," ",2),"/",2)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
 ;EP
MWT ;EP
 NEW BCHI,BCHJ,BCHC
 S BCHJ=$L(X) F BCHI=1:1:BCHJ S BCHC=$E(X,BCHI) I BCHC?1A S BCHC=$S(BCHC?1L:$C($A(BCHC)-32),1:BCHC)
 S (BCHI,BCHC)="" F BCHI=1:1:BCHJ S BCHC=$E(X,BCHI) Q:"GK"[BCHC
 I "GK"[BCHC D @BCHC
 K BCHC,BCHI,BCHJ
 Q
MWTC ;EP
 Q:+X=X!(X'[" ")!(X'["/")
 K:'(X?1.6N1" "1.2N1"/"1.2N) X
 Q:'$D(X)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
K ;EP
 I X["/" S X=$P(X,BCHC) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*2.2046226)
 Q
G ;EP
 I X["/" S X=$P(X,BCHC) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.0022046226)
 Q
C ;EP
 I X["/" S X=$P(X,BCHC) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.393701)
 Q
AG ;EP (ABDOMINAL GIRTH)
 K:+X'=X!(X>150)!(X<0)!(X?.E1"."1N.N) X
 Q
FH ;EP Fundal Height
 K:+X'=X!(X>50)!(X<10)!(X?.E1"."1N.N) X
 Q
FT ;EP Fetal Heart Tones
 K:+X'=X!(X>250)!(X<50)!(X?.E1"."1N.N) X
 Q
RS ;EP
 I X'?1.2N!(X<8)!(X>90) K X Q
 Q
HELP ;EP HELP FOR VARIOUS TYPES
 D ^BCHMSRH
 Q
