BGPDP24 ; IHS/CMI/LAB - print ind 24 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I24 ;EP ; 
 ;Q:'$D(BGPIND(24))
 D HEADER^BGPDPH
 W !,"Indicator 24:  Adult Immunizations-Pneumovax and Flu Vaccine in Diabetics"
 W !!,"Denominator 1 is all active users age 65 and over."
 W !!,"Denominator 2 is all patients in the active user population diagnosed with",!,"diabetes (Indicator 1) who are aged 18 or older at the beginning of the ",!,"time period."
 W !,"Increase pneumococcal and influenza vaccination levels among adults ages 65",!,"and older and Diabetics ages 18 and older.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,17,1)
 S BGPCYN=$$V(BGPRPT,17,2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,87,1)
 S BGP98N=$$V(BGPRPT,87,2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,47,1)
 S BGPPRN=$$V(BGPRPT,47,2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Active Users",!?3,"ages 65 and over",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# With Pneumovax",!?2,"documented by the",!?2,"end of time period"
 D H2^BGPDPH
 S BGPCYD=$$V(BGPRPT,17,1)
 S BGPCYN=$$V(BGPRPT,17,3),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,87,1)
 S BGP98N=$$V(BGPRPT,87,3),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,47,1)
 S BGPPRN=$$V(BGPRPT,47,3),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# With Flu Vaccine",!?2,"documented by the",!?2,"end of time period"
 D H2^BGPDPH
DM ;
 S BGPCYD=$$V(BGPRPT,17,5)
 S BGPCYN=$$V(BGPRPT,17,6),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,87,5)
 S BGP98N=$$V(BGPRPT,87,6),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,47,5)
 S BGPPRN=$$V(BGPRPT,47,6),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# Active Users",!?3,"ages 18 and over",!?3,"with Diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# With Pneumovax",!?2,"documented by the",!?2,"end of time period"
 D H2^BGPDPH
 S BGPCYD=$$V(BGPRPT,17,5)
 S BGPCYN=$$V(BGPRPT,17,7),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,87,5)
 S BGP98N=$$V(BGPRPT,87,7),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,47,5)
 S BGPPRN=$$V(BGPRPT,47,7),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# With Flu Vaccine",!?2,"documented by the",!?2,"end of time period"
 D H2^BGPDPH
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
