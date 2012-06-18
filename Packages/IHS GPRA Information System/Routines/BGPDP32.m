BGPDP32 ; IHS/CMI/LAB - print ind 32 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I32 ;EP ; 
 ;Q:'$D(BGPIND(30))
 D HEADER^BGPDPH
 W !,"Indicator 32:  HIV Testing"
 W !!,"Denominator is all patients with a positive value in the year prior",!," to the end of the time period for any of the following lab tests:"
 S BGPX=0 F  S BGPX=$O(^BGPILAB(BGPX)) Q:BGPX'=+BGPX  D
 .I $Y>(IOSL-2) D HEADER^BGPDPH Q:BGPQUIT
 .W !?5,$P(^LAB(60,BGPX,0),U),?38," "
 .S Y=0 F  S Y=$O(^BGPILAB(BGPX,11,Y)) Q:Y'=+Y  W " ",$P(^BGPILAB(BGPX,11,Y,0),U)," ;"
 W !!,"Increase the percentage of high-risk sexually active persons who have been",!,"tested for HIV.",!
 I $Y>(IOSL-7) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,20,1),BGPCYN=$$V(BGPRPT,20,2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,90,1),BGP98N=$$V(BGPRPT,90,2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,50,1),BGPPRN=$$V(BGPRPT,50,2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Patients w/Positive",!?2,"result",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/HIV Test recorded",!?2,"w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 Q
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
