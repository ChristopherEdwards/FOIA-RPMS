BGPDP3 ; IHS/CMI/LAB - print ind 3 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I3A ;EP ; 
 ;Q:'$D(BGPIND(6))
 D HEADER^BGPDPH
 W !,"Indicator 3A:  Diabetes-Reduce Diabetic Complications - BP control"
 W !,"Denominator is all patients with a DM diagnosis ever."
 W !,"Continue the trend of improved blood pressure control in the proportion of I/T/U"
 W !,"clients with diagnosed diabetes.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,10),"!",1)+$P($$V(BGPRPT,10,10),"!",2),BGPCYN=$$V(BGPRPT,13,2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,10),"!",1)+$P($$V(BGPRPT,80,10),"!",2),BGP98N=$$V(BGPRPT,83,2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,10),"!",1)+$P($$V(BGPRPT,40,10),"!",2),BGPPRN=$$V(BGPRPT,43,2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# diagnosed w/diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Mean BP <130/80",!?2," Controlled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Blood Pressure Control",! D H1^BGPDPH
I3A3 ;ideal control
 S BGPP2=3 D SET22
 W !!,"# w/Mean BP >=130/80",!?2," Uncontrolled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
I3A4 ;
 S BGPP2=4 D SET22
 W !!,"# w/Mean Blood Pressure",!?2," undetermined in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 Q
I3B ;EP ; 
 ;Q:'$D(BGPIND(7))
 D HEADER^BGPDPH
 W !,"Indicator 3B:  Diabetes-Reduce Diabetic Complications - BP control"
 W !,"Denominator is all patients with a DM diagnosis ever, with at least",!,"2 visits in the year prior to the end of the time period and the first",!,"ever recorded diagnosis of Diabetes > 1year prior to the end of the time period."
 W !,"Continue the trend of improved glycemic control in the proportion of I/T/U"
 W !,"clients with diagnosed diabetes.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,12,5),BGPCYN=$$V(BGPRPT,13,7),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,82,5),BGP98N=$$V(BGPRPT,83,7),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,42,5),BGPPRN=$$V(BGPRPT,43,7),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# in denominator",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Mean BP <130/80",!?2," Controlled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Blood Pressure Control",! D H1^BGPDPH
I3B3 ;ideal control
 S BGPP2=8 D SET22
 W !!,"# w/Mean BP >=130/80",!?2," Uncontrolled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
I3B4 ;
 S BGPP2=9 D SET22
 W !!,"# w/Mean Blood Pressure",!?2," undetermined in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 Q
I3C ;EP ; 
 ;Q:'$D(BGPIND(8))
 D HEADER^BGPDPH
 W !,"Indicator 3C:  Diabetes-Reduce Diabetic Complications - BP control"
 W !,"Denominator is all patients with a DM diagnosis ever, who are 19 or older",!,"who had at least 2 diabetes related encounters ever, at least one",!,"encounter in a primary clinic with a primary provider for diabetes,"
 W !,"and an absence of a creatinine value of 5.0 or greater."
 W !!,"Continue the trend of improved glycemic control in the proportion of I/T/U"
 W !,"clients with diagnosed diabetes.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,12,10),BGPCYN=$$V(BGPRPT,13,12),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,82,10),BGP98N=$$V(BGPRPT,83,12),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,42,10),BGPPRN=$$V(BGPRPT,43,12),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# diagnosed w/diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Mean BP <130/80",!?2," Controlled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Blood Pressure Control",! D H1^BGPDPH
I3C3 ;ideal control
 S BGPP2=13 D SET22
 W !!,"# w/Mean BP >=130/80",!?2," Uncontrolled",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
I3C4 ;
 S BGPP2=14 D SET22
 W !!,"# w/Mean Blood Pressure",!?2," undetermined in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 Q
SET22 ;
 S BGPCYN=$$V(BGPRPT,13,BGPP2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98N=$$V(BGPRPT,83,BGPP2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRN=$$V(BGPRPT,43,BGPP2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
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
