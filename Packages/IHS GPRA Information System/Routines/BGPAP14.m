BGPAP14 ; IHS/CMI/LAB - print ind 14 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I14 ;EP ; 
 ;Q:'$D(BGPIND(19))
 D HEADER^BGPAPH
 W !,"Indicator 14:  Oral Health-Improve Oral Health Status of Patients with Diabetes"
 W !!,"Denominator is all patients in the active user population diagnoses with",!,"diabetes (Indicator 1)."
 W !,"Increase the proportion of the AI/AN population diagnosed with diabetes ",!,"who obtain access to dental services.",!
 I $Y>(IOSL-5) D HEADER^BGPAPH Q:BGPQUIT
 D H
 S BGPRPT=0 F  S BGPRPT=$O(BGPSUL(BGPRPT)) Q:BGPRPT'=+BGPRPT!(BGPQUIT)  D
 .S BGPCYD=$P($$V(BGPRPT,10,10),"!",1)+$P($$V(BGPRPT,10,10),"!",2)
 .S BGPCYN=$$V(BGPRPT,15,17),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 .S BGP98D=$P($$V(BGPRPT,80,10),"!",1)+$P($$V(BGPRPT,80,10),"!",2)
 .S BGP98N=$$V(BGPRPT,85,17),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 .S BGPPRD=$P($$V(BGPRPT,40,10),"!",1)+$P($$V(BGPRPT,40,10),"!",2)
 .S BGPPRN=$$V(BGPRPT,45,17),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 .D LOCW Q:BGPQUIT
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
H ;write header
 W !?44,"% CHANGE",?62,"% CHANGE",!?44,"FROM BASE YR",?62,"FROM PREV YR"
 Q
LOCW ;
 I $Y>(IOSL-3) D HEADER^BGPDPH Q:BGPQUIT
 W !?3,$P(^BGPD(BGPRPT,0),U,5)
 S X=$P(^BGPD(BGPRPT,0),U,5)
 I X="" W ?11,"?????" Q
 S X=$O(^AUTTLOC("C",X,0))
 I X="" W ?11,"?????" Q
 W ?11,$E($P(^DIC(4,X,0),U),1,20)
 S BGPX=$J($$CALC(BGPCYP,BGP98P),6),$E(BGPX,20)=$J($$CALC(BGPCYP,BGPPRP),6)
 W ?46,BGPX
 Q
WLOC ;
 I $Y>(IOSL-3) D HEADER^BGPDPH Q:BGPQUIT
 W !?3,$P(^BGPD(BGPRPT,0),U,5)
 S X=$P(^BGPD(BGPRPT,0),U,5)
 I X="" W ?11,"?????" Q
 S X=$O(^AUTTLOC("C",X,0))
 I X="" W ?11,"?????" Q
 W ?11,$E($P(^DIC(4,X,0),U),1,20)
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
