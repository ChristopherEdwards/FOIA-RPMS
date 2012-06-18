APCHAAP2 ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
PRINT ;EP
 S APCHQ=0
 W !,$P(^DIC(4,DUZ(2),0),U),?53,"Today's Date: ",$$FMTE^XLFDT(DT),!
 W "Patient Name: ",$P(^DPT(DFN,0),U)
 W ?45,"Birth Date: ",$$DOB^AUPNPAT(DFN,"E")
 W ?71,"Age: ",$$AGE^AUPNPAT(DFN),!
 W $$REPEAT^XLFSTR("_",79),!
 W "My Doctor: " S X=$$DPCP^APCHPWH1(DFN) W:X $P(^VA(200,X,0),U) W "    Phone number: ",$$VAL^XBDIQ1(9999999.06,DUZ(2),.13),!
 W "   Address: ",$$VAL^XBDIQ1(9999999.06,DUZ(2),.14)_"  "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.15)_$S($$VAL^XBDIQ1(9999999.06,DUZ(2),.15)]"":", ",1:" ")
 W:$P(^AUTTLOC(DUZ(2),0),U,14) $P(^DIC(5,$$VALI^XBDIQ1(9999999.06,DUZ(2),.16),0),U,2) W "  "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.17),!
 W "My Pharmacy: ",$$PHARM(DUZ(2),"N"),"     Phone number: ",$$PHARM(DUZ(2),"P"),!
 W "My Contact person: ",$$EC(DFN,"N"),"     Phone number: ",$$EC(DFN,"P"),!
 W $$REPEAT^XLFSTR("_",79),!!
 W "Asthma Triggers",!
 S APCHG=0 K APCHSX
 S APCHC=$O(^AUTTHF("B","ASTHMA TRIGGERS",0))
 G:'APCHC AAP
 S APCHF=0 F  S APCHF=$O(^AUTTHF("AC",APCHC,APCHF)) Q:APCHF'=+APCHF  D
 .Q:'$D(^AUPNVHF("AA",DFN,APCHF))
 .S D=$O(^AUPNVHF("AA",DFN,APCHF,""))
 .S X="  "_$P(^AUTTHF(APCHF,0),U),$E(X,40)="Documented on "_$$FMTE^XLFDT((9999999-D)) W ?5,X,! S APCHG=1
 I 'APCHG W "No Triggers identified.",!
AAP ;
 I $Y>(IOSL-5) D HEAD Q:APCHQ
 W !,"ASTHMA ACTION PLAN",!!
 S APCHB=$$PBPF^APCHSAST(DFN,"B")
 I $P(APCHB,U,2)]"" D
 .W "Do your peak flow today.  What is your number?  What Zone are you in?",!
 .I $Y>(IOSL-3) D HEAD Q:APCHQ
 .NEW R,Y,G
 .S R=$$REDH($P(APCHB,U,2)) I R]"" S R="0-"_R
 .W ?2,$$STRIP^XLFSTR(R," "),?11,"RED ZONE [0-49% of Best Peak Flow]",!
 .S Y=$$YELLOW($P(APCHB,U,2),2)
 .W ?2,$$STRIP^XLFSTR(Y," "),?11,"YELLOW ZONE [50-79% of Best Peak Flow]",!
 .I $Y>(IOSL-3) D HEAD Q:APCHQ
 .S G=$$GREEN($P(APCHB,U,2),2)
 .W ?2,$$STRIP^XLFSTR(G," "),?11,"GREEN ZONE [80-100% of Best Peak Flow]",!!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 I $P(APCHB,U)="" W ?3,"Your Personal Best Peak Flow:  None documented; please discuss with your",!,"provider at your next clinic visit.",!
 I $P(APCHB,U)]"" W ?3,"Your Personal Best Peak Flow: ",$P(APCHB,U,2)," liters/minute on ",$$FMTE^XLFDT($P(APCHB,U,1)),!
 I $Y>(IOSL-4) D HEAD Q:APCHQ
 W !,"Follow these steps to control your asthma.",!
 W $$REPEAT^XLFSTR("*",79),!
 W !,"RED ZONE "_$S($P(APCHB,U)]"":"[49-0%]",1:"")_" - Need Medical Help!!   ",!
 I $Y>(IOSL-4) D HEAD Q:APCHQ
 I $P(APCHB,U)]"" W "Peak Flow less than ",$$RED($P(APCHB,U,2),.50,2)," liters/minute",!,"  OR",!
 W "You are coughing, short of breath, and wheezing.",!
 W "You have trouble walking or talking.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W "Your rescue medicine doesn't work.",!
 I APCHRELM="" W !,"________________________________________________________________",!
 I APCHRELM]"" D  Q:APCHQ
 .;attempt to wrap directions 70 characters
 .K ^UTILITY($J,"W") S X=APCHRELM,DIWL=0,DIWR=70 D ^DIWP
 .;S X=$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 .F F=1:1:$G(^UTILITY($J,"W",0)) S X=$G(^UTILITY($J,"W",0,F,0)) Q:APCHQ  D
 ..I $Y>(IOSL-3) D HEAD Q:APCHQ
 ..W !,X
 .K ^UTILITY($J,"W")
 .W !
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W !,"Ask someone to bring you to the Emergency Room, call 911, or call your doctor.",!
 W $$REPEAT^XLFSTR("*",79),!
 I $Y>(IOSL-4) D HEAD Q:APCHQ
 W "YELLOW ZONE "_$S($P(APCHB,U)]"":"[50-79%]",1:""),"- Asthma is Getting Worse   ",!
 I $P(APCHB,U)]"" W "Peak Flow is ",$$YELLOW^APCHSAST($P(APCHB,U,2))," liters/minute",!,"  OR",!
 W "You are coughing or wheezing.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W "You are waking at night from your asthma.",!
 W "You have some trouble doing usual activities.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 I APCHRESM="" W !,"________________________________________________________________",! I 1
 I APCHRESM]"" D  Q:APCHQ
 .;attempt to wrap directions 70 characters
 .K ^UTILITY($J,"W") S X=APCHRESM,DIWL=0,DIWR=70 D ^DIWP
 .;S X=$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 .F F=1:1:$G(^UTILITY($J,"W",0)) S X=$G(^UTILITY($J,"W",0,F,0)) Q:APCHQ  D
 ..I $Y>(IOSL-3) D HEAD Q:APCHQ
 ..W !,X
 .K ^UTILITY($J,"W")
 .W !
 W !,"Keep taking your green zone medications.  Check your peak flow readings ",!,"every few hours.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W !,"CALL YOUR DOCTOR or care provider IF:",!
 W "1. You are in your yellow zone for more than 24-48 hours.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W "2. OR You need to use your reliever medication more than every 4 hours.",!
 W "3. OR Your symptoms are getting worse.",!
 W $$REPEAT^XLFSTR("*",79),!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W !,"GREEN ZONE "_$S($P(APCHB,U)]"":"[100-80%]",1:"")_" - You Are Doing Well   ",!
 I $P(APCHB,U)]"" W "Peak Flow is ",$$GREEN^APCHSAST($P(APCHB,U,2)),!,"  OR",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W "You have no coughing, wheezing, or chest tightness during the day or night.",!
 W "You sleep through the night without coughing, wheezing, or chest tightness.",!
 I $Y>(IOSL-3) D HEAD Q:APCHQ
 W "You can do usual activities.",!
 W !,"Take your long-term control medication every day.",!
MEDS ;
RELMEDS ;
 K APCHL,APCHREL,APCHCONT
 D LAST1YRR
 D LAST1YRC
 ;
CONTMEDS ;
 W !!,"Active Controller Medications",!
 K APCHL
 M APCHL=APCHCONT
 D DISPMEDS
 W !,"Active Reliever Medications",!
 K APCHL
 M APCHL=APCHREL
 D DISPMEDS
 Q
HEAD ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,$P(^DIC(4,DUZ(2),0),U),?53,"Today's Date: ",$$FMTE^XLFDT(DT),!
 W "Patient Name: ",$P(^DPT(DFN,0),U)
 W ?45,"Birth Date: ",$$DOB^AUPNPAT(DFN,"E")
 W ?71,"Age: ",$$AGE^AUPNPAT(DFN),!
 W $$REPEAT^XLFSTR("_",79),!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EXIT ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
PHARM(L,I) ;
 NEW %
 S %=$O(^PS(59,"C",L,0))
 I '%,I="N" Q $P(^DIC(4,L,0),U)
 I '%,I="P" Q $$VAL^XBDIQ1(9999999.06,L,.13)
 I I="N" Q $P(^PS(59,%,0),U)
 I I="P" Q $P(^PS(59,%,0),U,4)
 Q ""
 ;
EC(L,I) ;
 NEW %
 S F=$S(I="N":.331,1:.3319)
 S %=$$VAL^XBDIQ1(2,L,F)
 I %]"" Q %
 S F=$S(I="N":.211,1:.219)
 Q $$VAL^XBDIQ1(2,L,F)
 ;
GREEN(V,F) ;
 NEW P,P1
 I $G(V)="" Q ""
 S P=(V*.80),P=$J(P,3,0),P1=V
 I F=1 Q P_"-"_V_" liters/minute"
 Q P_"-"_V
YELLOW(V,F)  ;
 NEW P,P1
 I $G(V)="" Q ""
 S P=(V*.50)
 S P=$J(P,3,0)
 S P1=(V*.80),P1=P1-1,P1=$J(P1,3,0)
 I F=1 Q P_"-"_P1_" liters/minute"
 I F=2 Q P_"-"_P1
RED(V,D,F) ;
 NEW P,P1
 I $G(V)="" Q ""
 I $G(D)="" S D=.50
 S P=(V*D)
 S P=P+.5,P=$J(P,3,0)
 I F=1 Q "<"_P_"   liters/minute"
 Q $TR(P," ")
 ;
REDH(V) ;
 NEW P
 S P=((.50*V)-1)
 Q $TR($J(P,3,0)," ")
 ;
 Q
 ;
DISPMEDS ;EP
 I '$O(APCHL(0)) W !,"None documented; please discuss with your provider at your next",!,"clinic visit.",! Q
 S D=0 F  S D=$O(APCHL(D)) Q:D'=+D  D
 .S E=0 F  S E=$O(APCHL(D,E)) Q:E'=+E  S N=^AUPNVMED(E,0) D
 ..S APCHD=$$FMTE^XLFDT($P(^AUPNVSIT($P(N,U,3),0),U),"5D")
 ..S APCHDC=$P(N,U,8),APCHDYS=$P(N,U,7),APCHMFX=$S($P(N,U,4)="":+N,1:$P(N,U,4)) S:APCHDYS="" APCHDYS=30 S APCHRX=$S($D(^PSRX("APCC",E)):$O(^(E,0)),1:0)
 ..S APCHCRN=$S(+APCHRX:$D(^PS(55,DFN,"P","CP",APCHRX)),1:0)
 ..S APCHQTY=$P(N,U,6),APCHSIG=$P(N,U,5)
 ..S APCHDTM=$P($P(^AUPNVSIT($P(N,U,3),0),U),"."),APCHEXP=""
 ..S X=$$FMDIFF^XLFDT(DT,APCHDTM)
 ..I X>APCHDYS S Y=$$FMADD^XLFDT(APCHDTM,APCHDYS) S APCHEXP="-- Ran out "_$$FMTE^XLFDT(Y,"2D")
 ..S APCHMED=$S($P(N,U,4)="":$P(^PSDRUG(APCHMFX,0),U),1:$P(N,U,4))
 ..I APCHDC S Y=$$FMTE^XLFDT(APCHDC) S APCHEXP="-- D/C "_Y
 ..S APCHORTS=$G(^AUPNVMED(E,11))
 ..I APCHORTS["RETURNED TO STOCK",APCHDC S APCHEXP="--RTS "_Y
 ..D SIG S APCHSIG=APCHSSGY
 ..D REF I APCHREF S APCHSIG=APCHSIG_" "_APCHREF_$S(APCHREF=1:" refill",1:" refills")_" left."
 ..I $Y>(IOSL-4) D HEAD Q:APCHQ
 ..S X=APCHD,$E(X,13)=APCHMED_" #"_APCHQTY_" ("_APCHDYS_" days) "_APCHEXP W ?1,X,!
 ..S X="",$E(X,14)=$E(APCHSIG,1,65) W X,!
 ..I $L(APCHSIG)>65 S X="",$E(X,14)=$E(APCHSIG,66,999) W X,!
 ..Q
 .Q
 Q
 ;
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S APCHSSGY="" F APCHSP=1:1:$L(APCHSIG," ") S X=$P(APCHSIG," ",APCHSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(APCHSIG," ",APCHSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S APCHSSGY=APCHSSGY_X_" "
 Q
 ;
REF ;DETERMINE THE NUMBER OF REFILLS REMAINING
 I 'APCHRX S APCHREF=0 Q
 S APCHRFL=$P(^PSRX(APCHRX,0),U,9) S APCHREF=0 F  S APCHREF=$O(^PSRX(APCHRX,1,APCHREF)) Q:'APCHREF  S APCHRFL=APCHRFL-1
 S APCHREF=APCHRFL
 Q
 ;
LAST1YRR ;EP
 NEW T,E,D,Y,M,G,C,N
 S APCHREL=0
 S T(1)=$O(^ATXAX("B","BAT ASTHMA SHRT ACT RELV MEDS",0))
 S T(2)=$O(^ATXAX("B","BAT ASTHMA SHRT ACT RELV NDC",0))
 S T(3)=$O(^ATXAX("B","BAT ASTHMA SHRT ACT INHLR MEDS",0))
 S T(4)=$O(^ATXAX("B","BAT ASTHMA SHRT ACT INHLR NDC",0))
 S T(5)=$O(^ATXAX("B","BGP RA GLUCOCORTIOCOIDS MEDS",0))
 S T(6)=$O(^ATXAX("B","BGP RA GLUCOCORTIOCOIDS CLASS",0))
 S E=9999999-$$FMADD^XLFDT(DT,-183)
 S D=0 F  S D=$O(^AUPNVMED("AA",DFN,D)) Q:D'=+D!(D>E)  D
 .S M=0 F  S M=$O(^AUPNVMED("AA",DFN,D,M)) Q:M'=+M  D
 ..Q:'$D(^AUPNVMED(M,0))
 ..S Y=$P(^AUPNVMED(M,0),U)
 ..Q:'Y
 ..;is it active?
 ..I $P(^AUPNVMED(M,0),U,8)]"",$P(^AUPNVMED(M,0),U,8)'>DT Q
 ..S APCHRXN=$O(^PSRX("APCC",M,0))
 ..S G=1 I APCHRXN D
 ...S APCHSTAT=$P($G(^PSRX(APCHRXN,"STA")),U,1)
 ...I APCHSTAT'=0 S G=0
 ..I 'G Q
 ..I T(1),$D(^ATXAX(T(1),21,"B",Y)) D SR Q
 ..I T(3),$D(^ATXAX(T(3),21,"B",Y)) D SR Q
 ..I T(5),$D(^ATXAX(T(5),21,"B",Y)) D SR Q
 ..S N=$P($G(^PSDRUG(Y,2)),U,4)
 ..Q:N=""
 ..I N]"",T(2),$D(^ATXAX(T(2),21,"B",N)) D SR Q
 ..I N]"",T(4),$D(^ATXAX(T(4),21,"B",N)) D SR Q
 ..S C=$P(^PSDRUG(Y,0),U,2)
 ..I C,T(6),$D(^ATXAX(T(6),21,"B",C)) D SR Q
 .Q
 Q
SR ;
 S APCHREL(D,M)="",APCHREL=APCHREL+1
 Q
 ;
LAST1YRC ;EP
 NEW T,E,D,Y,M,G,C,N
 S APCHCONT=0
 S T(1)=$O(^ATXAX("B","BAT ASTHMA CONTROLLER MEDS",0))
 S T(2)=$O(^ATXAX("B","BAT ASTHMA CONTROLLER NDC",0))
 S T(3)=$O(^ATXAX("B","BAT ASTHMA INHALED STEROIDS",0))
 S T(4)=$O(^ATXAX("B","BAT ASTHMA INHLD STEROIDS NDC",0))
 S T(5)=$O(^ATXAX("B","BAT ASTHMA LEUKOTRIENE MEDS",0))
 S T(6)=$O(^ATXAX("B","BAT ASTHMA LEUKOTRIENE NDC",0))
 S E=9999999-$$FMADD^XLFDT(DT,-183)
 S D=0 F  S D=$O(^AUPNVMED("AA",DFN,D)) Q:D'=+D!(D>E)  D
 .S M=0 F  S M=$O(^AUPNVMED("AA",DFN,D,M)) Q:M'=+M  D
 ..Q:'$D(^AUPNVMED(M,0))
 ..S Y=$P(^AUPNVMED(M,0),U)
 ..Q:'Y
 ..;is it active?
 ..I $P(^AUPNVMED(M,0),U,8)]"",$P(^AUPNVMED(M,0),U,8)'>DT Q
 ..S APCHRXN=$O(^PSRX("APCC",M,0))
 ..S G=1 I APCHRXN D
 ...S APCHSTAT=$P($G(^PSRX(APCHRXN,"STA")),U,1)
 ...I APCHSTAT'=0 S G=0
 ..I 'G Q
 ..I T(1),$D(^ATXAX(T(1),21,"B",Y)) D SC Q
 ..I T(3),$D(^ATXAX(T(3),21,"B",Y)) D SC Q
 ..I T(5),$D(^ATXAX(T(5),21,"B",Y)) D SC Q
 ..S N=$P($G(^PSDRUG(Y,2)),U,4)
 ..Q:N=""
 ..I T(2),$D(^ATXAX(T(2),21,"B",N)) D SC Q
 ..I T(4),$D(^ATXAX(T(4),21,"B",N)) D SC Q
 ..I T(6),$D(^ATXAX(T(6),21,"B",N)) D SC Q
 .Q
 Q
SC ;
 S APCHCONT(D,M)="",APCHCONT=APCHCONT+1
 Q
 ;
