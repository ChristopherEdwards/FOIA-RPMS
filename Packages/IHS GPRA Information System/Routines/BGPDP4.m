BGPDP4 ; IHS/CMI/LAB -print ind 4 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I4A ;EP ; 
 ;Q:'$D(BGPIND(9))
 D HEADER^BGPDPH
 W !,"Indicator 4A:  Diabetes-Reduce Diabetic Complications-Assessed for Dyslipidemia"
 W !,"Denominator is all patients with a DM diagnosis ever."
 W !,"Continue the trend of increasing the proportion of I/T/U clients with"
 W !,"diagnosed diabetes who have been assessed for dyslipidemia using LDL as",!,"the screening test.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,10),"!",1)+$P($$V(BGPRPT,10,10),"!",2),BGPCYN=$$V(BGPRPT,14,1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,10),"!",1)+$P($$V(BGPRPT,80,10),"!",2),BGP98N=$$V(BGPRPT,84,1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,10),"!",1)+$P($$V(BGPRPT,40,10),"!",2),BGPPRN=$$V(BGPRPT,44,1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# diagnosed w/diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Lipid Profile OR",!?2," TG & HDL & LDL",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Assessed for Dyslipidemia",! D H1^BGPDPH
I4A2 ;ideal control
 S BGPP2=2 D SET22
 W !!,"# w/LDL & HDL/TG",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4A3 ;
 S BGPP2=3 D SET22
 W !!,"# w/TG only or ",!?2," HDL & TG in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4A4 ;
 S BGPP2=4 D SET22
 W !!,"# w/LDL Only",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4A5 ;
 S BGPP2=5 D SET22
 W !!,"# with No Tests",!?2," w/in 1 year of",!?2," end of time perid"
 D H2^BGPDPH
I4A6 ;
 S BGPP2=6 D SET22
 W !!,"# w/ LDL done",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4A7 ;
 S BGPP2=7 D SET22
 W !!,"# w/ LDL Results",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4A8 ;
 S BGPP2=8 D SET22
 W !!,"# of patients w/LDL",!?2," result < 130",!?2," w/in 1 year of ",!?2," end of time period"
 D H2^BGPDPH
 Q
I4B ;EP ; 
 ;Q:'$D(BGPIND(10))
 D HEADER^BGPDPH
 W !,"Indicator 4B:  Diabetes-Reduce Diabetic Complications-Assessed for Dyslipidemia"
 W !,"Denominator is all patients with a DM diagnosis ever, with at least",!,"2 visits in the year prior to the end of the time period and the first",!,"ever recorded diagnosis of Diabetes > 1year prior to the end of the time period."
 W !,"Continue the trend of increasing the proportion of I/T/U clients with"
 W !,"diagnosed diabetes who have been assessed for dyslipidemia using LDL as",!,"the screening test.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,12,5),BGPCYN=$$V(BGPRPT,14,9),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,82,5),BGP98N=$$V(BGPRPT,84,9),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,42,5),BGPPRN=$$V(BGPRPT,44,9),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# diagnosed w/diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Lipid Profile OR",!?2," TG & HDL & LDL",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Assessed for Dyslipidemia",! D H1^BGPDPH
I4B2 ;ideal control
 S BGPP2=10 D SET22
 W !!,"# w/LDL & HDL/TG",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4B3 ;
 S BGPP2=11 D SET22
 W !!,"# w/TG only or ",!?2," HDL & TG in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4B4 ;
 S BGPP2=12 D SET22
 W !!,"# w/LDL Only",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4B5 ;
 S BGPP2=13 D SET22
 W !!,"# with No Tests",!?2," w/in 1 year of",!?2," end of time perid"
 D H2^BGPDPH
I4B6 ;
 S BGPP2=14 D SET22
 W !!,"# w/ LDL done",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4B7 ;
 S BGPP2=15 D SET22
 W !!,"# w/ LDL Results",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4B8 ;
 S BGPP2=16 D SET22
 W !!,"# of patients w/LDL",!?2," result < 130",!?2," w/in 1 year of ",!?2," end of time period"
 D H2^BGPDPH
 Q
I4C ;EP ; 
 ;Q:'$D(BGPIND(11))
 D HEADER^BGPDPH
 W !,"Indicator 4C:  Diabetes-Reduce Diabetic Complications-Assessed for Dyslipidemia"
 W !,"Denominator is all patients with a DM diagnosis ever, who are 19 or older",!,"who had at least 2 diabetes related encounters ever, at least one",!,"encounter in a primary clinic with a primary provider for diabetes,"
 W !,"and an absence of a creatinine value of 5.0 or greater."
 W !,"Continue the trend of increasing the proportion of I/T/U clients with"
 W !,"diagnosed diabetes who have been assessed for dyslipidemia using LDL as",!,"the screening test.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,12,10),BGPCYN=$$V(BGPRPT,14,17),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,82,10),BGP98N=$$V(BGPRPT,84,17),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,42,10),BGPPRN=$$V(BGPRPT,44,17),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# diagnosed w/diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Lipid Profile OR",!?2," TG & HDL & LDL",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Assessed for Dyslipidemia",! D H1^BGPDPH
I4C2 ;ideal control
 S BGPP2=18 D SET22
 W !!,"# w/LDL & HDL/TG",!?2,"recorded w/in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4C3 ;
 S BGPP2=19 D SET22
 W !!,"# w/TG only or ",!?2," HDL & TG in 1 yr of",!?2," end of time period"
 D H2^BGPDPH
I4C4 ;
 S BGPP2=20 D SET22
 W !!,"# w/LDL Only",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4C5 ;
 S BGPP2=21 D SET22
 W !!,"# with No Tests",!?2," w/in 1 year of",!?2," end of time perid"
 D H2^BGPDPH
I4C6 ;
 S BGPP2=22 D SET22
 W !!,"# w/ LDL done",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4C7 ;
 S BGPP2=23 D SET22
 W !!,"# w/ LDL Results",!?2," w/in 1 year of",!?2," end of time period"
 D H2^BGPDPH
I4C8 ;
 S BGPP2=24 D SET22
 W !!,"# of patients w/LDL",!?2," result < 130",!?2," w/in 1 year of ",!?2," end of time period"
 D H2^BGPDPH
 Q
 ;
SET22 ;
 S BGPCYN=$$V(BGPRPT,14,BGPP2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98N=$$V(BGPRPT,84,BGPP2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRN=$$V(BGPRPT,44,BGPP2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 Q
CALC(N,O) ;ENTRY POINT
 NEW Z
 I O=0!(N=0)!(O="")!(N="") Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 I +O=0 Q "**"
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
 Q
V(R,N,P) ;
 NEW Y
 I $G(BGPAREAA),'$G(BGPSUMR) G VA
 Q $P($G(^BGPD(R,N)),U,P)
VA ;
 NEW X,C,V,MT,FT,M,F,B S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .S V=$P($G(^BGPD(X,N)),U,P)
 .I C="" S C=V Q
 .S MT=$P(C,"!"),FT=$P(C,"!",2),M=$P(V,"!"),F=$P(V,"!",2)
 .F B=1:1:6 S $P(MT,"~",B)=$P(MT,"~",B)+$P(M,"~",B)
 .F B=1:1:6 S $P(FT,"~",B)=$P(FT,"~",B)+$P(F,"~",B)
 .S C=MT_"!"_FT
 .Q
 Q C
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
