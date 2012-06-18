BGPAPB ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
IB ;EP
 D HEADER^BGPDPH Q:BGPQUIT
 W !,"Indicator B:  Reduce the Colorectal Cancer Rate."
 W !,"Increase the proportion of AI/AN who have had screening and early detection.",!
 W !,"Denominator is all active patients over the age of 50."
 D H
 S BGPRPT=0 F  S BGPRPT=$O(BGPSUL(BGPRPT)) Q:BGPRPT'=+BGPRPT!(BGPQUIT)  D
 .S BGPCYD=$P($$V(BGPRPT,15,19),"!",1)+$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,20),"!",1)+$P($$V(BGPRPT,15,20),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 .S BGP98D=$P($$V(BGPRPT,85,19),"!",1)+$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,20),"!",1)+$P($$V(BGPRPT,85,20),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 .S BGPPRD=$P($$V(BGPRPT,45,19),"!",1)+$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,20),"!",1)+$P($$V(BGPRPT,45,20),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 .D LOCW Q:BGPQUIT
 .Q
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0)!(O="")!(N="") Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 I +O=0 Q "**"
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
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
 ;
