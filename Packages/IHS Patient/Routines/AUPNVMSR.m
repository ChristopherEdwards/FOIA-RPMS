AUPNVMSR ; IHS/CMI/LAB - EDITS FOR AUPNVMSR (MEASUREMENTS:9000010.04) 24-MAY-1993 ; 30 Sep 2010  2:16 PM
 ;;2.0;IHS PCC SUITE;**2,5,7**;MAY 14, 2009
 ;;
 ;;BJPC patch 1
 ;; - PF changed to 50-1000
 ;; - added ASFD
 ;; - added BPF - Best Peak Flow
 ;; 
 ;S AUPNMTYP=$P(^AUPNVMSR(DA,0),U,1),AUPNMTYP=$P(^AUTTMSR(AUPNMTYP,0),U,1)
 ;I $T(@AUPNMTYP)="" Q
 ;D @AUPNMTYP
 NEW AUPNMTYP
 S AUPNMTYP=$P(^AUPNVMSR(DA,0),U,1)
 X ^AUTTMSR(AUPNMTYP,12)
 K AUPNMTYP
 Q
 ;
BHM ;PEP - called from BH measurements dd
 NEW AUPNMTYP
 S AUPNMTYP=$P(^AMHRMSR(DA,0),U,1)
 X ^AUTTMSR(AUPNMTYP,12)
 K AUPNMTYP
 Q
 ;S AUPNMTYP=$P(^AMHRMSR(DA,0),U,1),AUPNMTYP=$P(^AUTTMSR(AUPNMTYP,0),U,1)
 ;I $T(@AUPNMTYP)="" Q
 ;D @AUPNMTYP
 ;K AUPNMTYP
 Q
 ;
AUD ; (AUDIOMETRY)
 NEW %AUI,%AUX
 I $L(X,"/")'=17 K X Q
 F %AUI=1:1:16 S %AUX=$P(X,"/",%AUI) I %AUX'="" I %AUX'?1.3N!(+%AUX>110) K X Q
 Q
AKBP ;EP - ANKLE BLOOD PRESSURE
BP ;EP (BLOOD PRESSURE)
 NEW AUPNBPS,AUPNBPD
 I $L(X)>7!($L(X)<5)!'(X?2.3N1"/"2.3N) K X Q
 S AUPNBPS=+$P(X,"/",1),AUPNBPD=+$P(X,"/",2)
 I AUPNBPS<20!(AUPNBPS>275) K X G BPX
 I AUPNBPD<20!(AUPNBPD>200) K X G BPX
 I AUPNBPS'>AUPNBPD K X G BPX
 S X=AUPNBPS_"/"_AUPNBPD
BPX ;
 Q
CXD ;;CERVIX DILATATION
 K:X<0!(X>10) X
 Q
ED ; (EDEMA)
 I $L(X)>2!($L(X)<1) K X Q
 I +X>4 K X Q
 Q:X=0
 I X'?1N1"+" K X Q
 Q
EF ;EFFACEMENT
 K:X<0!(X>100) X
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
WC ;  (WAIST CIRCUMFERENCE)
 I X'=+X K X Q
 K:+X'=X!(X>99)!(X<20)!(X?.E1"."3N.N) X
 Q
PA ;EP (PAIN)
 I X'=+X K X Q
 K:(X<0)!(X>10) X
 Q
FI24 ;EP (PAIN)
 I X'=+X K X Q
 K:(X<0)!(X>10000) X
 Q
FO24 ;EP (PAIN)
 I X'=+X K X Q
 K:(X<0)!(X>10000) X
 Q
FBPN ;EP (PAIN)
 I X'=+X K X Q
 K:(X<-10000)!(X>10000) X
 Q
HT ; (HEIGHT)
 D:X?.E.A.E MHT
 Q:'$D(X)
 D HTHCC
 S:$P(X,".",2)?4N.N X=X+.0005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,3)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>90)!(X<10)!(X?.E1"."4N.N) X
 Q:'$D(X)
 ;K:X-(X\1)#.125 X
 Q
HTHCC Q:X'["/"
 Q:X'?2N1" "1N1"/"1N
 S X=$P(X," ",1)_+("."_($P($P(X," ",2),"/",1)*1000\$P($P(X," ",2),"/",2)))
 Q
 ;
MHT ;
 NEW AUPNC,AUPNI,AUPNJ
 S AUPNJ=$L(X) F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) I AUPNC?1A S AUPNC=$S(AUPNC?1L:$C($A(AUPNC)-32),1:AUPNC)
 S (AUPNI,AUPNC)="" F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) Q:"C"[AUPNC
 I AUPNC="C" D @AUPNC
 K AUPNC,AUPNI,AUPNJ
 Q
PR ; (PRESENTATION)
 NEW AUTFN,AUTVAL
 I X="U" S X="UNKNOWN"
 S AUTVAL=X,AUTFN=9999999.87
 S %=$$PRLK(AUTFN,AUTVAL)
 I %="" K X Q
 S X=%
 Q:$D(ZTQUEUED)
 Q:$D(APCDATMP)  ;don't talk if in APCDALVR mode
 W "   ",X
 Q
PRLK(AUTFN,AUTVAL) ;
 NEW AUTVALI
 S AUTVALI=""
 D EN^XBNEW("DIC^AUPNVMSR","AUTFN,AUTVAL,AUTVALI")
 Q AUTVALI
PU ;EP (PULSE)
 K:+X'=X!(X>250)!(X<30)!(X?.E1"."1N.N) X
 Q
SN ;STATION
 K:X<-6!(X>4) X
 Q
TMP ; (TEMPERATURE)
 K:+X'=X!(X>120)!(X<70)!(X?.E1"."2N.N) X
 Q
TON ; (TONOMETRY)
 NEW %AURR,%AURP,%AURI,%AULR,%AULP,%AULI
 I $L(X)>5!($L(X)<3)!'((X?1.3N1"/")!(X?1"/"1.3N)!(X?1.3N1"/"1.3N)) K X Q
 I $P(X,"/",1)'="" I $P(X,"/",1)<0!($P(X,"/",1)>80) K X Q
 I $P(X,"/",2)'="" I $P(X,"/",2)<0!($P(X,"/",2)>80) K X Q
 I $P(X,"/",1)]"" S X="R"_X
 I $P(X,"/",2)]"" S X=$P(X,"/",1)_"/L"_$P(X,"/",2)
TONX ;
 K %AURR,%AURP,%AURI,%AULR,%AULP,%AULI
 Q
VC ; (VISION CORRECTED)
VU ; (VISION UNCORRECTED)
 I $D(DIFGLINE) Q  ;IHS/ASDST/GTH AUPN*99.1*7 02/15/2002 - do not do edit if in filegrams (mfi)
 I $L(X)>7!($L(X)<2) K X Q
 I '((X?2.3AN)!(X?1"/"2.3AN)!(X?2.3AN1"/"2.3AN)) K X Q
 I $P(X,"/",1)'="",+($P(X,"/",1)) I $P(X,"/",1)<10!($P(X,"/",1)>999) K X Q
 I $P(X,"/",1)'="",'($P(X,"/",1)) I $P(X,"/")'="HM"&($P(X,"/")'="LP")&($P(X,"/")'="NLP") K X Q
 I $P(X,"/",2)'="",+($P(X,"/",2)) I $P(X,"/",2)<10!($P(X,"/",2)>999) K X Q
 I $P(X,"/",2)'="",'($P(X,"/",2)) I $P(X,"/",2)'="HM"&($P(X,"/",2)'="LP")&($P(X,"/",2)'="NLP") K X Q  ;IHS/CMI/LAB - patch 1 changed 3 to 2
 Q
WT ;EP (WEIGHT)
 D:X?.E.A.E MWT
 Q:'$D(X)
 D WTC
 S:$P(X,".",2)?5N.N X=X+.00005,X=$P(X,".",1)_"."_$E($P(X,".",2),1,4)
 S X=+X
 Q:'$D(X)
 K:+X'=X!(X>1000)!(X<2)!(X?.E1"."5N.N) X
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
 NEW AUPNC,AUPNI,AUPNJ
 S AUPNJ=$L(X) F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) I AUPNC?1A S AUPNC=$S(AUPNC?1L:$C($A(AUPNC)-32),1:AUPNC)
 S (AUPNI,AUPNC)="" F AUPNI=1:1:AUPNJ S AUPNC=$E(X,AUPNI) Q:"GK"[AUPNC
 I "GK"[AUPNC D @AUPNC
 K AUPNC,AUPNI,AUPNJ
 Q
MWTC ;
 Q:+X=X!(X'[" ")!(X'["/")
 K:'(X?1.6N1" "1.2N1"/"1.2N) X
 Q:'$D(X)
 S X=+X+((+$P(X," ",2)/$P($P(X," ",2),"/",2)))
 Q
K ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*2.2046226)
 Q
G ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.0022046226)
 Q
C ;
 I X["/" S X=$P(X,AUPNC,1) D MWTC
 Q:'$D(X)
 S X=+X
 S X=(X*.393701)
 Q
AG ; (ABDOMINAL GIRTH)
 K:+X'=X!(X>150)!(X<10)!(X?.E1"."3N.N) X
 Q
FH ; Fundal Height
 K:+X'=X!(X>100)!(X<0)!(X?.E1"."3N.N) X
 Q
FT ; Fetal Heart Tones
 K:+X'=X!(X>400)!(X<0)!(X?.E1"."1N.N) X
 Q
RS ;EP
 ;IHS/CMI/LAB - up'ed value to 100 pre Madonna Long aberdeen
 I X'?1.3N!(X<0)!(X>100) K X Q
 Q
 ; 
O2 ;EP called from input template
 I X'?1.3N!(X<50)!(X>100) K X
 Q
PF ;EP called from input template
 I X'?1.4N!(X<50)!(X>1000) K X  ;IHS/CMI/LAB 1-25-08; values 5-1000 CR #85  
 Q
BS ;EP -per dina in billings
 Q
CEF ;EP called from input tx, per Terry Cullen 3-17-04
 Q:'$D(X)
 K:(X<5)!(X>99) X
 Q
ASQM ; EP - ASQ questionnaire (Mos)
 I '$D(^VEN(7.14,"B",X)) K X
 Q
 ; 
PHQ2 ; EP - PHQ2
 I X'?1N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>6) X
 Q
 ;
PHQ9 ; EP - PHQ9
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>27) X
 Q
 ;
AUDT ; EP - AUDT
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>40) X
 Q
 ;
AUDC ; EP - AUDT
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>12) X
 Q
 ;
CRFT ; EP - CRFT
 I X'?1N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>6) X
 Q
 ;
ASFD ; EP - ASFD
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>14) X
 Q
 ;
ADM ; EP - ADM
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>14) X
 Q
 ;
BPF ;EP called from input template
 I X'?1.4N!(X<50)!(X>1000) K X  ;IHS/CMI/LAB 1-25-08; values 5-1000 CR #85  
 Q
 ;
FEF ;EP - FEF 25-75
 S X=$$STRIP^XLFSTR(X," ")
 I X'=+X K X Q
 K:(X<0)!(X>150) X
 Q
 ;
FEV1 ;EP - FEV1
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>10) X
 Q
 ;
FV1P ;EP - FEV1 %
 S X=$$STRIP^XLFSTR(X," ")
 ;I X'?1.3N!(X'?1.3N1"%") K X
 I X'=+X K X Q
 K:(X<0)!(X>150) X
 Q
 ;
FVC ;EP - forced vital capacity
 I X'?1.2N K X Q
 I X'=+X K X Q
 K:(X<0)!(X>10) X
 Q
 ;
FVCP ;EP - FEV1 %
 S X=$$STRIP^XLFSTR(X," ")
 I X'=+X K X Q
 K:(X<0)!(X>150) X
 Q
 ;
FVFC ;EP - FEV1/FVC
 I $L(X)>11!($L(X)<2)!'(X?0.2N0.1"."0.2N1"/"0.2N0.1"."0.2N) K X Q
 NEW F,S
 S F=$P(X,"/",1),S=$P(X,"/",2)
 I F="" K X Q
 I S="" K X Q
 S F=+F
 S S=+S
 I F<0!(F>10) K X Q
 I S<0!(S>10) K X Q
 Q
LKW ;EP - LKW
 I X'="WELL" K X Q
 Q
EGA ;EP - EGA
 I X?1.2N D  Q
 .I +X<4 K X Q
 .I +X>44 K X Q
 I X'?1.2N1" "1N1"/"1"7" K X Q
 NEW %
 S %=$P(X," ")
 I %<4 K X Q
 I %>44 K X Q
 S %=$E($P(X," ",2))
 I %<1 K X Q
 I %>6 K X Q
 Q
 ;
ASQF ; EP - ASQ development score: FINE MOTOR
ASQG ; EP - ASQ development score: GROSS MOTOR
ASQL ; EP - ASQ development score: LANGUAGE
ASQS ; EP - ASQ development score: SOCIAL
ASQP ; EP - ASQ development score: PROBLEM SOLVING
 I $P(X," ")'?1.2N K X Q
 I +X#5 K X
 Q
BL ;EP - called from birth length of Birth measurement file
 Q:X=""
 I $E(X)="C" S X=$E(X,2,9999),X=X*.3937008
 I X'=+X K X Q
 I X<6 K X Q
 I X>30 K X Q
 Q
 ;
OUT(IEN,VAL) ;EP called from output transform
 I 'IEN Q VAL
 I '$D(^AUPNVMSR(IEN,0)) Q VAL
 NEW % S %=$P(^AUPNVMSR(IEN,0),U)
 I $P(^AUTTMSR(%,0),U)="FEF" Q $S(VAL["%":VAL,1:VAL_"%")
 I $P(^AUTTMSR(%,0),U)="FV1P" Q $S(VAL["%":VAL,1:VAL_"%")
 I $P(^AUTTMSR(%,0),U)="FVCP" Q $S(VAL["%":VAL,1:VAL_"%")
 I $P(^AUTTMSR(%,0),U)'="VC"&($P(^AUTTMSR(%,0),U)'="VU") Q VAL
 S VAL=$S($P(^AUPNVMSR(IEN,0),U,6):$P(^AUPNVMSR(IEN,0),U,6),1:"20")_"/"_$P(VAL,"/")_"-"_$S($P(^AUPNVMSR(IEN,0),U,6):$P(^AUPNVMSR(IEN,0),U,6),1:"20")_"/"_$P(VAL,"/",2)
 Q VAL
HELP ;EP - HELP FOR VARIOUS TYPES
 D ^AUPNVMS2
 Q
DIC ;EP
 N X S X=AUTVAL
 S DIC=$$DIC^XBDIQ1(AUTFN)
 Q:'$L(DIC)
 S DIC(0)="M"
 D ^DIC
 S:+Y>0 AUTVALI=$P(Y,U,2)
 Q
 ;
OUTBH(IEN,VAL) ;EP called from output transform
 I 'IEN Q VAL
 I '$D(^AMHRMSR(IEN,0)) Q VAL
 NEW % S %=$P(^AMHRMSR(IEN,0),U)
 I $P(^AUTTMSR(%,0),U)'="VC"&($P(^AUTTMSR(%,0),U)'="VU") Q VAL
 S VAL=$S($P(^AMHRMSR(IEN,0),U,6):$P(^AMHRMSR(IEN,0),U,6),1:"20")_"/"_$P(VAL,"/")_"-"_$S($P(^AMHRMSR(IEN,0),U,6):$P(^AMHRMSR(IEN,0),U,6),1:"20")_"/"_$P(VAL,"/",2)
 Q VAL
EN1(Y,DA) ;EP -  INPUT TRANSFORM FOR NAME (.01) FIELD OF QUALIFIER
 ; SUB-FILE OF V MEASUREMENT  FILE.
 ;   Input variables:  Y is entry in 120.52 being looked up
 ;                     DA is entry in V MEASUREMENT where Qualifier data
 ;                        is being selected.
 ;   Function value: 1 if can select this Qualifier, else 0.
 ;
 N GMRVFXN,GMRVTYP S GMRVFXN=0
 S GMRVTYP=$P($G(^AUPNVMSR(DA,0)),"^",1)
 I GMRVTYP>0,$D(^GMRD(120.52,"C",GMRVTYP,+Y)) S GMRVFXN=1
 Q GMRVFXN
 ;
