BGPDP13 ; IHS/CMI/LAB - print ind 13 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I13 ;EP ; 
 ;Q:'$D(BGPIND(20))
 D HEADER^BGPDPH
 W !,"Indicator 13:  Oral Health - Reduce Children's Dental Decay"
 W !!,"Denominator is all patients in the active user population ages 6-8 years",!,"old and ages 14-15 years old"
 W !,"Increase the percent of AI/AN children 6-8 and 14-15 years who have",!,"received protective dental sealants.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,15,13)
 S BGPCYN=$$V(BGPRPT,15,15),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,85,13)
 S BGP98N=$$V(BGPRPT,85,15),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,45,13)
 S BGPPRN=$$V(BGPRPT,45,15),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Active Users",!?3,"aged 6-8 yrs",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# Dental Sealant",!?2,"documented by the",!?2,"end of time period"
 D H2^BGPDPH
I13B ;
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT
 S BGPCYD=$$V(BGPRPT,15,14)
 S BGPCYN=$$V(BGPRPT,15,16),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,85,14)
 S BGP98N=$$V(BGPRPT,85,16),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,45,14)
 S BGPPRN=$$V(BGPRPT,45,16),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# Active Users",!?3,"aged 14-15 yrs",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# Dental Sealant",!?2,"documented by the",!?2,"end of time period"
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
