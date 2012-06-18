BGPDPB ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
IB ;EP
 D HEADER^BGPDPH Q:BGPQUIT
 W !,"Indicator B:  Reduce the Colorectal Cancer Rate."
 W !,"Increase the proportion of AI/AN who have had screening and early detection.",!
 W !,"Denominator is all active patients over the age of 50.",!
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1)+$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,20),"!",1)+$P($$V(BGPRPT,15,20),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1)+$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,20),"!",1)+$P($$V(BGPRPT,85,20),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1)+$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,20),"!",1)+$P($$V(BGPRPT,45,20),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# patients over 50",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"# w/FOB test",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1)+$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,23),"!",1)+$P($$V(BGPRPT,15,23),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1)+$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,23),"!",1)+$P($$V(BGPRPT,85,23),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1)+$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,23),"!",1)+$P($$V(BGPRPT,45,23),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"# w/DRE or Rectal Exam",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1)+$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,21),"!",1)+$P($$V(BGPRPT,15,21),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1)+$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,21),"!",1)+$P($$V(BGPRPT,85,21),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1)+$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,21),"!",1)+$P($$V(BGPRPT,45,21),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"# w/DRE and SIG",!?2,"recorded w/in 5 yrs of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1)+$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,22),"!",1)+$P($$V(BGPRPT,15,22),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1)+$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,22),"!",1)+$P($$V(BGPRPT,85,22),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1)+$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,22),"!",1)+$P($$V(BGPRPT,45,22),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"# w/DRE & Colonoscopy test",!?2,"recorded w/in 5 yrs of",!?2,"end of time period"
 D H2^BGPDPH
MALES ;
 D HEADER^BGPDPH Q:BGPQUIT
 W !,"Indicator B:  Reduce the Colorectal Cancer Rate."
 W !,"Increase the proportion of AI/AN who have had screening and early detection.",!
 W !,"Denominator is all MALE active patients over the age of 50.",!
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1),BGPCYN=$P($$V(BGPRPT,15,20),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1),BGP98N=$P($$V(BGPRPT,85,20),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1),BGPPRN=$P($$V(BGPRPT,45,20),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# MALES over 50 ",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"w/FOB test",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1),BGPCYN=$P($$V(BGPRPT,15,23),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1),BGP98N=$P($$V(BGPRPT,85,23),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1),BGPPRN=$P($$V(BGPRPT,45,23),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE or Rectal Exam",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1),BGPCYN=$P($$V(BGPRPT,15,21),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1),BGP98N=$P($$V(BGPRPT,85,21),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1),BGPPRN=$P($$V(BGPRPT,45,21),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE & SIG test",!?2,"recorded w/in 5 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",1),BGPCYN=$P($$V(BGPRPT,15,22),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",1),BGP98N=$P($$V(BGPRPT,85,22),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",1),BGPPRN=$P($$V(BGPRPT,45,22),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE & Colonoscopy test",!?2,"recorded w/in 5 yr of",!?2,"end of time period"
 D H2^BGPDPH
FEMALES ;
 D HEADER^BGPDPH Q:BGPQUIT
 W !,"Indicator B:  Reduce the Colorectal Cancer Rate."
 W !,"Increase the proportion of AI/AN who have had screening and early detection.",!
 W !,"Denominator is all FEMALE active patients over the age of 50.",!
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,20),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,20),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,20),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# FEMALES over 50 ",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !!,"w/FOB test",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,23),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,23),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,23),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE or Rectal Exam",!?2,"recorded w/in 1 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,21),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,21),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,21),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE & SIG test",!?2,"recorded w/in 5 yr of",!?2,"end of time period"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  W !,"Colorectal Cancer Screening",! D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,15,19),"!",2),BGPCYN=$P($$V(BGPRPT,15,22),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,85,19),"!",2),BGP98N=$P($$V(BGPRPT,85,22),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,45,19),"!",2),BGPPRN=$P($$V(BGPRPT,45,22),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!,"w/DRE & Colonoscopy test",!?2,"recorded w/in 5 yr of",!?2,"end of time period"
 D H2^BGPDPH
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
