ACMMSR ; IHS/TUCSON/TMJ - EDITS FOR ACMVMSR ; [ 05/11/06  2:34 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**6**;JAN 10, 1996
 ;EP;ENTRY POINT
 S ACMMTYP=$P(^ACM(57,DA,0),U,1),ACMMTYP=$P(^AUTTMSR(ACMMTYP,0),U,1)
 D @ACMMTYP
 K ACMMTYP
 Q
 ;
AUD ; (AUDIOMETRY)
 I $L(X,"/")'=17 K X Q
 F ACMUI=1:1:16 S ACMUX=$P(X,"/",ACMUI) I ACMUX'="" I ACMUX'?1.3N!(+ACMUX>110) K X Q
 K ACMUI,ACMUX
 Q
BP ; (BLOOD PRESSURE)
 I $L(X)>7!($L(X)<5)!'(X?2.3N1"/"2.3N) K X Q
 S ACMBPS=+$P(X,"/",1),ACMBPD=+$P(X,"/",2)
 I ACMBPS<20!(ACMBPS>275) K X G BPX
 I ACMBPD<20!(ACMBPD>200) K X G BPX
 I ACMBPS'>ACMBPD K X G BPX
 S X=ACMBPS_"/"_ACMBPD
BPX K ACMBPS,ACMBPD
 Q
HC ; (HEAD CIRCUMFERENCE)
 D:X?.E.A.E MHT
 Q:'$D(X)
 D HTHCC
 S:$P(X,".",2)?4N.N X=X+.0005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,3)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>30)!(X<10)!(X?.E1"."4N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.125 X
 Q
HE ; (HEARING)
 K:X'="A"&(X'="N") X
 Q
HT ; (HEIGHT)
 D:X?.E.A.E MHT
 Q:'$D(X)
 D HTHCC
 S:$P(X,".",2)?4N.N X=X+.0005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,3)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>80)!(X<10)!(X?.E1"."4N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.125 X
 Q
HTHCC Q:X'["/"
 Q:X'?2N1" "1N1"/"1N
 S X=$P(X," ",1)_+("."_($P($P(X," ",2),"/",1)*1000\$P($P(X," ",2),"/",2)))
 Q
 ;
MHT ;
 S ACMJ=$L(X) F ACMI=1:1:ACMJ S ACMC=$E(X,ACMI) I ACMC?1A S ACMC=$S(ACMC?1L:$C($A(ACMC)-32),1:ACMC)
 S (ACMI,ACMC)="" F ACMI=1:1:ACMJ S ACMC=$E(X,ACMI) Q:"C"[ACMC
 I ACMC="C" D @ACMC
 K ACMC,ACMI,ACMJ
 Q
PU ; (PULSE)
 K:+X'=X!(X>250)!(X<30)!(X?.E1"."1N.N) X
 Q
TMP ; (TEMPERATURE)
 K:+X'=X!(X>109.9)!(X<94)!(X?.E1"."2N.N) X
 Q
TON ; (TONOMETRY)
 I $L(X,"/")'=7 K X Q
 S ACMURR=$P(X,"/",1),ACMURP=$P(X,"/",2),ACMURI=$P(X,"/",3)
 S ACMULR=$P(X,"/",4),ACMULP=$P(X,"/",5),ACMULI=$P(X,"/",6)
 I ACMURR'="" I ACMURR'?1.2N1"."1N!(+ACMURR>99) K X G TONX
 I ACMURP'="" I ACMURP'="5.5"&(ACMURP'="7.5")&(ACMURP'="10.0")&(ACMURP'="15.0") K X G TONX
 I ACMURI'="" I ACMURI'?1.3N1"."1N!(+ACMURI>999.9) K X G TONX
 I ACMULR'="" I ACMULR'?1.2N1"."1N!(+ACMULR>99) K X G TONX
 I ACMULP'="" I ACMULP'="5.5"&(ACMULP'="7.5")&(ACMULP'="10.0")&(ACMULP'="15.0") K X G TONX
 I ACMULI'="" I ACMULI'?1.3N1"."1N!(+ACMULI>999.9) K X G TONX
 I ACMURR="" I ACMURP=""!(ACMURI="") K X G TONX
 I ACMURR'="" I ACMURP'=""!(ACMURI'="") K X G TONX
 I ACMULR="" I ACMULP=""!(ACMULI="") K X G TONX
 I ACMURR'="" I ACMURP'=""!(ACMURI'="") K X G TONX
TONX ;
 K ACMURR,ACMURP,ACMURI,ACMULR,ACMULP,ACMULI
 Q
VC ; (VISION CORRECTED)
VU ; (VISION UNCORRECTED)
 I $L(X)>7!($L(X)<2)!'((X?2.3N)!(X?1"/"2.3N)!(X?2.3N1"/"2.3N)) K X Q
 I $P(X,"/",1)'="" I $P(X,"/",1)<10!($P(X,"/",1)>999) K X Q
 I $P(X,"/",2)'="" I $P(X,"/",2)<10!($P(X,"/",2)>999) K X Q
 Q
WT ; (WEIGHT)
 D:X?.E.A.E MWT
 Q:'$D(X)
 D WTC
 S:$P(X,".",2)?5N.N X=X+.00005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,4)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>750)!(X<2)!(X?.E1"."5N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.0625 X
 Q
WTC Q:+X=X!(X'[" ")
 Q:'(X?1.3N1" "1.2N!(X?1.3N1" "1.2N1"/"1.2N))
 I X'["/" Q:+$P(X," ",2)>16  S X=+X+(+$P(X," ",2)/16) Q
 Q:+$P($P(X," ",2),"/",1)'<+$P($P(X," ",2),"/",2)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
 ;
MWT ;
 S ACMJ=$L(X) F ACMI=1:1:ACMJ S ACMC=$E(X,ACMI) I ACMC?1A S ACMC=$S(ACMC?1L:$C($A(ACMC)-32),1:ACMC)
 S (ACMI,ACMC)="" F ACMI=1:1:ACMJ S ACMC=$E(X,ACMI) Q:"GK"[ACMC
 I "GK"[ACMC D @ACMC
 K ACMC,ACMI,ACMJ
 Q
MWTC ;
 Q:+X=X!(X'[" ")!(X'["/")
 K:'(X?1.6N1" "1.2N1"/"1.2N) X
 Q:'$D(X)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
K ;
 I X["/" S X=$P(X,ACMC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*2.2046226)
 Q
G ;
 I X["/" S X=$P(X,ACMC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.0022046226)
 Q
C ;
 I X["/" S X=$P(X,ACMC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.393701)
 Q
AG ; (ABDOMINAL GIRTH)
 K:+X'=X!(X>150)!(X<0)!(X?.E1"."1N.N) X
 Q
FH ; Fundal Height
 K:+X'=X!(X>50)!(X<10)!(X?.E1"."1N.N) X
 Q
FT ; Fetal Heart Tones
 K:+X'=X!(X>250)!(X<50)!(X?.E1"."1N.N) X
 Q
HELP ;EP; HELP FOR VARIOUS TYPES ;IHS/CMI/TMJ PATCH #6
 D ^ACMMS2
 Q
DIC ;EP; IHS/CMI/TMJ PATCH #6
 N X S X=ACMVAL
 S DIC=$$DIC^XBDIQ1(ACMFN)
 Q:'$L(DIC)
 S DIC(0)="M"
 D ^DIC
 S:+Y>0 ACMVALI=$P(Y,U,2)
 Q
CXD ;;CERVIX DILATATION ;IHS/CMI/TMJ PATCH #6
 K:X<0!(X>10) X
 Q
ED ; (EDEMA) ;IHS/CMI/TMJ PATCH #6
 I $L(X)>2!($L(X)<1) K X Q
 I +X>4 K X Q
 Q:X=0
 I X'?1N1"+" K X Q
 Q
EF ;EFFACEMENT; IHS/CMI/TMJ PATCH #6
 K:X<0!(X>100) X
 Q
WC ;  (WAIST CIRCUMFERENCE) ;IHS/CMI/TMJ PATCH #6
 I X'=+X K X Q
 K:+X'=X!(X>99)!(X<20)!(X?.E1"."3N.N) X
 Q
PA ;EP (PAIN) ;IHS/CMI/TMJ PATCH #6
 I X'=+X K X Q
 K:(X<0)!(X>10) X
 Q
PR ; (PRESENTATION)RS ;EP ;IHS/CMI/TMJ PATCH #6
 ;IHS/CMI/LAB - up'ed value to 100 pre Madonna Long aberdeen
 I X'?1.2N!(X<8)!(X>100) K X Q
 Q
 ;IHS/CMI/LAB - aupn9320 patch 8 added O2 and PF subroutines
O2 ;EP called from input te ;IHS/CMI/TMJ PATCH #6mplate
 I X'?1.3N!(X<50)!(X>100) K X
 Q
PF ;EP called from input te ;IHS/CMI/TMJ PATCH #6mplate
 I X'?1.3N!(X<50)!(X>900) K X
 Q
BS ;EP -per dina in billings ;IHS/CMI/TMJ PATCH #6
 Q
CEF ;EP called from input tx, per Terry Cullen 3-17-04 ;IHS/CMI/TMJ PATCH #6
 Q:'$D(X)
 K:(X<5)!(X>99) X
 Q
OUT ;IHS/CMI/TMJ PATCH #6
 NEW ACMFN,ACMVAL
 S ACMVAL=X,ACMFN=9999999.87
 S %=$$PRLK(ACMFN,ACMVAL)
 I %="" K X Q
 S X=%
 Q:$D(ZTQUEUED)
 Q:$D(APCDATMP)  ;don't talk if in APCDALVR mode
 W "   ",X
 Q
PRLK(ACMFN,ACMVAL) ;
 NEW ACMVALI
 S ACMVALI=""
 D EN^XBNEW("DIC^AUPNVMSR","ACMFN,ACMVAL,ACMVALI")
 Q ACMVALI
SN ;STATION
 K:X<-6!(X>4) X
 Q
