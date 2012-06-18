BGPDP14 ; IHS/CMI/LAB - print ind 14 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I14 ;EP ; 
 ;Q:'$D(BGPIND(19))
 D HEADER^BGPDPH
 W !,"Indicator 14:  Oral Health-Improve Oral Health Status of Patients with Diabetes"
 W !!,"Denominator is all patients in the active user population diagnoses with",!,"diabetes (Indicator 1)."
 W !,"Increase the proportion of the AI/AN population diagnosed with diabetes ",!,"who obtain access to dental services.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,10),"!",1)+$P($$V(BGPRPT,10,10),"!",2)
 S BGPCYN=$$V(BGPRPT,15,17),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,10),"!",1)+$P($$V(BGPRPT,80,10),"!",2)
 S BGP98N=$$V(BGPRPT,85,17),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,10),"!",1)+$P($$V(BGPRPT,40,10),"!",2)
 S BGPPRN=$$V(BGPRPT,45,17),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Active Users",!?3,"with Diabetes",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# With ADA Code 0000",!?2,"documented by the",!?2,"end of time period"
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
