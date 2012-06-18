BGPAP22B ; IHS/CMI/LAB - print ind 22 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
MAGE ;
 ;Q:'$D(BGPIND(22))
 D HEADER^BGPAPH
 W !,"Indicator 24:   Public Health Nursing",!
 W "Demonimator is ALL MALE active users."
 W !,"Increase the total number of Public Health Nursing services (both primary",!,"and secondary treatment and preventive services) provided to individuals",!,"in all settings and the total number of home visits.",!
 W !,"Public Health Nursing",!
 D H
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1),BGPCYN=$P($$V(BGPRPT,18,1),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1),BGPPRN=$P($$V(BGPRPT,48,1),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1),BGP98N=$P($$V(BGPRPT,88,1),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 W !,"# active users",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of Males served by PHN's",!?2,"in any setting"
 D H2^BGPAPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1),BGPCYN=$P($$V(BGPRPT,18,3),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1),BGPPRN=$P($$V(BGPRPT,48,3),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1),BGP98N=$P($$V(BGPRPT,88,3),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of Males served by PHN's",!?2,"in a home setting"
 D H2^BGPAPH
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," any Setting",?21,$$C($P($$V(BGPRPT,88,2),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,2),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,2),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,2),"!",1),Y=$P($$V(BGPRPT,18,2),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,2),"!",1),Y=$P($$V(BGPRPT,18,2),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," in a Home Setting",?21,$$C($P($$V(BGPRPT,88,4),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,4),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,4),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,4),"!",1),Y=$P($$V(BGPRPT,18,4),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,4),"!",1),Y=$P($$V(BGPRPT,18,4),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," any Setting",!?2,"Neonate 0-28 days",?21,$$C($P($$V(BGPRPT,88,5),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,5),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,5),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,5),"!",1),Y=$P($$V(BGPRPT,18,5),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,5),"!",1),Y=$P($$V(BGPRPT,18,5),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," any Setting",!?2,"Infants 28d - 12m",?21,$$C($P($$V(BGPRPT,88,6),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,6),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,6),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,6),"!",1),Y=$P($$V(BGPRPT,18,6),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,6),"!",1),Y=$P($$V(BGPRPT,18,6),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," any Setting",!?2,"Pats 1-64 yrs",?21,$$C($P($$V(BGPRPT,88,7),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,7),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,7),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,7),"!",1),Y=$P($$V(BGPRPT,18,7),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,7),"!",1),Y=$P($$V(BGPRPT,18,7),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," any Setting",!?2,"Elders >65 yrs old",?21,$$C($P($$V(BGPRPT,88,8),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,8),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,8),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,8),"!",1),Y=$P($$V(BGPRPT,18,8),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,8),"!",1),Y=$P($$V(BGPRPT,18,8),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
HAGE ;
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," in Home Setting",!?2,"Neonate 0-28 days",?21,$$C($P($$V(BGPRPT,88,9),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,9),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,9),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,9),"!",1),Y=$P($$V(BGPRPT,18,9),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,9),"!",1),Y=$P($$V(BGPRPT,18,9),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," in Home Setting",!?2,"Infants 28d - 12m",?21,$$C($P($$V(BGPRPT,88,10),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,10),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,10),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,10),"!",1),Y=$P($$V(BGPRPT,18,10),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,10),"!",1),Y=$P($$V(BGPRPT,18,10),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," in Home Setting",!?2,"Pats 1-64 yrs",?21,$$C($P($$V(BGPRPT,88,11),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,11),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,11),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,11),"!",1),Y=$P($$V(BGPRPT,18,11),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,11),"!",1),Y=$P($$V(BGPRPT,18,11),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 W !!,"# of PHN Visits by Males -",!?2," in Home Setting",!?2,"Elders >65 yrs old",?21,$$C($P($$V(BGPRPT,88,12),"!",1),0,9),?37,$$C($P($$V(BGPRPT,48,12),"!",1),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,12),"!",1),0,9)
 S X=$P($$V(BGPRPT,88,12),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,12),"!",1),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
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
H ;
 W !?1,"DX",?8,"ICD NARRATIVE",?42,"PERIOD",?52," %"
 W !?1,"--",?8,"---------------------------------",?42,"--------",?52,"-----"
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
