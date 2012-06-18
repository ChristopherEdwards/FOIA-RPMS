BGPDP6 ; IHS/CMI/LAB - print ind 6 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I6 ;EP ; 
 ;Q:'$D(BGPIND(15))
 D HEADER^BGPDPH
 W !,"Indicator 6:  Women's Health-Reduce Cervical Cancer Mortality"
 W !!,"Denominator is all female patients ages 18-70 w/o History of Hysterectomy."
 W !,"Increase the proportion of women 18-70 years old, who have had a Pap Smear",!,"in the year prior to the end of the time period.",!
 I $Y>(IOSL-7) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,15,5),BGPCYN=$$V(BGPRPT,15,6),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,85,5),BGP98N=$$V(BGPRPT,85,6),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,45,5),BGPPRN=$$V(BGPRPT,45,6),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Women 18-70 yrs",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Pap Smear recorded",!?2,"w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 Q
I6A ;EP ; 
 ;Q:'$D(BGPIND(16))
 D HEADER^BGPDPH
 W !,"Indicator 6A:  Women's Health-Reduce Cervical Cancer Mortality"
 W !!,"Denominator is all female patients ages 18-70 w/o History of Hysterectomy."
 W !,"Increase the proportion of women 18-70 years old, who have had a Pap Smear",!,"in the 3 years prior to the end of the time period.",!
 I $Y>(IOSL-7) D HEADER^BGPDPH Q:BGPQUIT
 D H1^BGPDPH
 S BGPCYD=$$V(BGPRPT,15,5),BGPCYN=$$V(BGPRPT,15,7),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$$V(BGPRPT,85,5),BGP98N=$$V(BGPRPT,85,7),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$$V(BGPRPT,45,5),BGPPRN=$$V(BGPRPT,45,7),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# Women 18-70 yrs",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/Pap Smear recorded",!?2,"w/in 3 yr of",!?2,"end of time period"
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
