BHSAAP2 ;IHS/MSC/MGH  - Health summmary for asthma action plan;06-May-2010 10:55;MGH
 ;;1.0;HEALTH SUMMARY COMONENTS;**4**;March 17, 2006;Build 13
 ;===============================================================
 ;copy of APCHAAP2 to print an asthma action plan
 ; IHS/CMI/LAB - 2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
PRINT ;EP
 N BHSB,BHSC,BHSCRN,BHSD,BHSDC,BHSDTM,BHSDYS,BHSEXP,BHSF,BHSG,BHSRXN,BHSSIG,BHSSP,BHSSSGY,BHSQ,BHSREF
 S BHSQ=0
 D CKP^GMTSUP Q:$D(GMTSQIT)
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
 S BHSG=0 K APCHSX
 S BHSC=$O(^AUTTHF("B","ASTHMA TRIGGERS",0))
 G:'BHSC AAP
 S BHSF=0 F  S BHSF=$O(^AUTTHF("AC",BHSC,BHSF)) Q:BHSF'=+BHSF  D
 .Q:'$D(^AUPNVHF("AA",DFN,BHSF))
 .S D=$O(^AUPNVHF("AA",DFN,BHSF,""))
 .S X="  "_$P(^AUTTHF(BHSF,0),U),$E(X,40)="Documented on "_$$FMTE^XLFDT((9999999-D)) W ?5,X,! S BHSG=1
 I 'BHSG W "No Triggers identified.",!
AAP ;
 ;I $Y>(IOSL-5) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"ASTHMA ACTION PLAN",!!
 S BHSB=$$PBPF^APCHSAST(DFN,"B")
 I $P(BHSB,U,2)]"" D
 .W "Do your peak flow today.  What is your number?  What Zone are you in?",!
 .;I $Y>(IOSL-3) D HEAD Q:APCHQ
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .NEW R,Y,G
 .S R=$$REDH($P(BHSB,U,2)) I R]"" S R="0-"_R
 .W ?2,$$STRIP^XLFSTR(R," "),?11,"RED ZONE [0-49% of Best Peak Flow]",!
 .S Y=$$YELLOW($P(BHSB,U,2),2)
 .W ?2,$$STRIP^XLFSTR(Y," "),?11,"YELLOW ZONE [50-79% of Best Peak Flow]",!
 .;I $Y>(IOSL-3) D HEAD Q:APCHQ
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .S G=$$GREEN($P(BHSB,U,2),2)
 .W ?2,$$STRIP^XLFSTR(G," "),?11,"GREEN ZONE [80-100% of Best Peak Flow]",!!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 I $P(BHSB,U)="" W ?3,"Your Personal Best Peak Flow:  None documented; please discuss with your",!,"provider at your next clinic visit.",!
 I $P(BHSB,U)]"" W ?3,"Your Personal Best Peak Flow: ",$P(BHSB,U,2)," liters/minute on ",$$FMTE^XLFDT($P(BHSB,U,1)),!
 ;I $Y>(IOSL-4) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"Follow these steps to control your asthma.",!
 W $$REPEAT^XLFSTR("*",79),!
 W !,"RED ZONE "_$S($P(BHSB,U)]"":"[49-0%]",1:"")_" - Need Medical Help!!   ",!
 ;I $Y>(IOSL-4) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 I $P(BHSB,U)]"" W "Peak Flow less than ",$$RED($P(BHSB,U,2),.50,2)," liters/minute",!,"  OR",!
 W "You are coughing, short of breath, and wheezing.",!
 W "You have trouble walking or talking.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "Your rescue medicine doesn't work.",!
 I BHSRELM="" W !,"________________________________________________________________",!
 I BHSRELM]"" D  Q:$D(GMTSQIT)
 .;attempt to wrap directions 70 characters
 .K ^UTILITY($J,"W") S X=BHSRELM,DIWL=0,DIWR=70 D ^DIWP
 .;S X=$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 .F F=1:1:$G(^UTILITY($J,"W",0)) S X=$G(^UTILITY($J,"W",0,F,0)) Q:$D(GMTSQIT)  D
 ..;I $Y>(IOSL-3) D HEAD Q:APCHQ
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,X
 .K ^UTILITY($J,"W")
 .W !
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"Ask someone to bring you to the Emergency Room, call 911, or call your doctor.",!
 W $$REPEAT^XLFSTR("*",79),!
 ;I $Y>(IOSL-4) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "YELLOW ZONE "_$S($P(BHSB,U)]"":"[50-79%]",1:""),"- Asthma is Getting Worse   ",!
 I $P(BHSB,U)]"" W "Peak Flow is ",$$YELLOW^APCHSAST($P(BHSB,U,2))," liters/minute",!,"  OR",!
 W "You are coughing or wheezing.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "You are waking at night from your asthma.",!
 W "You have some trouble doing usual activities.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 I BHSRESM="" W !,"________________________________________________________________",! I 1
 I BHSRESM]"" D  Q:$D(GMTSQIT)
 .;attempt to wrap directions 70 characters
 .K ^UTILITY($J,"W") S X=BHSRESM,DIWL=0,DIWR=70 D ^DIWP
 .;S X=$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 .F F=1:1:$G(^UTILITY($J,"W",0)) S X=$G(^UTILITY($J,"W",0,F,0)) Q:$D(GMTSQIT)  D
 ..;I $Y>(IOSL-3) D HEAD Q:APCHQ
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,X
 .K ^UTILITY($J,"W")
 .W !
 W !,"Keep taking your green zone medications.  Check your peak flow readings ",!,"every few hours.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"CALL YOUR DOCTOR or care provider IF:",!
 W "1. You are in your yellow zone for more than 24-48 hours.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "2. OR You need to use your reliever medication more than every 4 hours.",!
 W "3. OR Your symptoms are getting worse.",!
 W $$REPEAT^XLFSTR("*",79),!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"GREEN ZONE "_$S($P(BHSB,U)]"":"[100-80%]",1:"")_" - You Are Doing Well   ",!
 I $P(BHSB,U)]"" W "Peak Flow is ",$$GREEN^APCHSAST($P(BHSB,U,2)),!,"  OR",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "You have no coughing, wheezing, or chest tightness during the day or night.",!
 W "You sleep through the night without coughing, wheezing, or chest tightness.",!
 ;I $Y>(IOSL-3) D HEAD Q:APCHQ
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "You can do usual activities.",!
 W !,"Take your long-term control medication every day.",!
MEDS ;
RELMEDS ;
 K BHSL,BHSREL,BHSCONT
 D LAST1YRR
 D LAST1YRC
 ;
CONTMEDS ;
 W !!,"Active Controller Medications",!
 K BHSL
 M BHSL=BHSCONT
 D DISPMEDS
 W !,"Active Reliever Medications",!
 K BHSL
 M BHSL=BHSREL
 D DISPMEDS
 Q
HEAD ;
 ;I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ=1 Q
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
 ;D EN^XBVK("APCH")
 ;D ^XBFMK
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
YELLOW(V,F) ;
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
 N D,E,N,BHSMED,BHSMFX,BHSDC,BHSDYS,BHSCRN,BHSQTY,BHSSIG,BHSDTM,BHSEX,X
 N BHSORTS,BHSRX,BHSRFL,BHSSTAT
 I '$O(BHSL(0)) W !,"None documented; please discuss with your provider at your next",!,"clinic visit.",! Q
 S D=0 F  S D=$O(BHSL(D)) Q:D'=+D  D
 .S E=0 F  S E=$O(BHSL(D,E)) Q:E'=+E  S N=^AUPNVMED(E,0) D
 ..S BHSD=$$FMTE^XLFDT($P(^AUPNVSIT($P(N,U,3),0),U),"5D")
 ..S BHSDC=$P(N,U,8),BHSDYS=$P(N,U,7),BHSMFX=$S($P(N,U,4)="":+N,1:$P(N,U,4)) S:BHSDYS="" BHSDYS=30 S BHSRX=$S($D(^PSRX("APCC",E)):$O(^(E,0)),1:0)
 ..S BHSCRN=$S(+BHSRX:$D(^PS(55,DFN,"P","CP",BHSRX)),1:0)
 ..S BHSQTY=$P(N,U,6),BHSSIG=$P(N,U,5)
 ..S BHSDTM=$P($P(^AUPNVSIT($P(N,U,3),0),U),"."),BHSEXP=""
 ..S X=$$FMDIFF^XLFDT(DT,BHSDTM)
 ..I X>BHSDYS S Y=$$FMADD^XLFDT(BHSDTM,BHSDYS) S BHSEXP="-- Ran out "_$$FMTE^XLFDT(Y,"2D")
 ..S BHSMED=$S($P(N,U,4)="":$P(^PSDRUG(BHSMFX,0),U),1:$P(N,U,4))
 ..I BHSDC S Y=$$FMTE^XLFDT(BHSDC) S BHSEXP="-- D/C "_Y
 ..S BHSORTS=$G(^AUPNVMED(E,11))
 ..I BHSORTS["RETURNED TO STOCK",BHSDC S BHSEXP="--RTS "_Y
 ..D SIG S BHSSIG=BHSSSGY
 ..D REF I BHSREF S BHSSIG=BHSSIG_" "_BHSREF_$S(BHSREF=1:" refill",1:" refills")_" left."
 ..;I $Y>(IOSL-4) D HEAD Q:APCHQ
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..S X=BHSD,$E(X,13)=BHSMED_" #"_BHSQTY_" ("_BHSDYS_" days) "_BHSEXP W ?1,X,!
 ..S X="",$E(X,14)=$E(BHSSIG,1,65) W X,!
 ..I $L(BHSSIG)>65 S X="",$E(X,14)=$E(BHSSIG,66,999) W X,!
 ..Q
 .Q
 Q
 ;
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S BHSSSGY="" F BHSSP=1:1:$L(BHSSIG," ") S X=$P(BHSSIG," ",BHSSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(BHSSIG," ",BHSSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S BHSSSGY=BHSSSGY_X_" "
 Q
 ;
REF ;DETERMINE THE NUMBER OF REFILLS REMAINING
 I 'BHSRX S BHSREF=0 Q
 S BHSRFL=$P(^PSRX(BHSRX,0),U,9) S BHSREF=0 F  S BHSREF=$O(^PSRX(BHSRX,1,BHSREF)) Q:'BHSREF  S BHSRFL=BHSRFL-1
 S BHSREF=BHSRFL
 Q
 ;
LAST1YRR ;EP
 NEW T,E,D,Y,M,G,C,N
 S BHSREL=0
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
 ..S BHSRXN=$O(^PSRX("APCC",M,0))
 ..S G=1 I BHSRXN D
 ...S BHSSTAT=$P($G(^PSRX(BHSRXN,"STA")),U,1)
 ...I BHSSTAT'=0 S G=0
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
 S BHSREL(D,M)="",BHSREL=BHSREL+1
 Q
 ;
LAST1YRC ;EP
 NEW T,E,D,Y,M,G,C,N
 S BHSCONT=0
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
 ..S BHSRXN=$O(^PSRX("APCC",M,0))
 ..S G=1 I BHSRXN D
 ...S BHSSTAT=$P($G(^PSRX(BHSRXN,"STA")),U,1)
 ...I BHSSTAT'=0 S G=0
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
 S BHSCONT(D,M)="",BHSCONT=BHSCONT+1
 Q
 ;
