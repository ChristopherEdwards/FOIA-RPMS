BGPDPC ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
IC ;EP - diabetes prevalence
 D HEADER^BGPDPH
 W !!,"Indicator C:  Increase the quality, availability, and effectiveness of ",!,"educational services designed to prevent disease and improve the health and",!,"quality of life."
 W !,"Increase the proportion of persons who are provided patient education",!,"on diet and exercise.",!
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !,"Provision of Diet and Exercise Education",!
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1)+$P($$V(BGPRPT,10,1),"!",2),BGPCYN=$P($$V(BGPRPT,29,10),"!",1)+$P($$V(BGPRPT,29,10),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1)+$P($$V(BGPRPT,80,1),"!",2),BGP98N=$P($$V(BGPRPT,99,10),"!",1)+$P($$V(BGPRPT,99,10),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1)+$P($$V(BGPRPT,40,1),"!",2),BGPPRN=$P($$V(BGPRPT,59,10),"!",1)+$P($$V(BGPRPT,59,10),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !,"# active users",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !,"# w/ Education provided w/in 1 yr of",!,"end of time period"
 D H2^BGPDPH
FEMP ;
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",2),BGPCYN=$P($$V(BGPRPT,29,10),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",2),BGP98N=$P($$V(BGPRPT,99,10),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",2),BGPPRN=$P($$V(BGPRPT,59,10),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# FEMALE active users",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !,"# w/ Education provided w/in 1 yr of",!,"end of time period"
 D H2^BGPDPH
MALEP ;
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT  D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1),BGPCYN=$P($$V(BGPRPT,29,10),"!",1),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1),BGP98N=$P($$V(BGPRPT,99,10),"!",1),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1),BGPPRN=$P($$V(BGPRPT,59,10),"!",1),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 W !!!,"# MALE active users",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 W !,"# w/ Education provided w/in 1 yr of",!,"end of time period"
 D H2^BGPDPH
C5A ;
AGE11 ;EP
 S BGPHD1="TOTAL ACTIVE USERS"
 D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !,"CURRENT REPORTING PERIOD"
 W !,"Total # active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,29,X) S V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,29,X),V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 K BGPX
 S BGPNODE=10 D CHG1
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,"Total # active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,59,X) S V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,59,X),V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 S BGPNODE=40 D CHG1
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"BASELINE REPORTING PERIOD"
 W !,"Total # active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,99,X) S V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,99,X),V=$P(Y,"!")+$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 S BGPNODE=80 D CHG1
 D CHG
FAGEP ;
 S BGPHD1="FEMALE ACTIVE USERS"
 D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !,"CURRENT REPORTING PERIOD"
 W !,"# FEMALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,29,X) S V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,29,X),V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 K BGPX W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,29,X),D=$$V(BGPRPT,29,(X-9)),N1=$P(N,"!",2),D1=$P(D,"!",2),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U)=%
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,"# FEMALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,59,X) S V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,59,X),V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,59,X),D=$$V(BGPRPT,59,(X-9)),N1=$P(N,"!",2),D1=$P(D,"!",2),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U,3)=%
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"BASELINE REPORTING PERIOD"
 W !,"# FEMALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,99,X) S V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,99,X),V=$P(Y,"!",2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,99,X),D=$$V(BGPRPT,99,(X-9)),N1=$P(N,"!",2),D1=$P(D,"!",2),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U,2)=%
 D CHG
MAGEP ;
 S BGPHD1="MALE ACTIVE USERS"
 D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !,"CURRENT REPORTING PERIOD"
 W !,"# MALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,29,X) S V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,29,X),V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 K BGPX W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,29,X),D=$$V(BGPRPT,29,(X-9)),N1=$P(N,"!",1),D1=$P(D,"!",1),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U)=%
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,"# MALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,59,X) S V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,59,X),V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,59,X),D=$$V(BGPRPT,59,(X-9)),N1=$P(N,"!",1),D1=$P(D,"!",1),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U,3)=%
 I $Y>(IOSL-8) D HEADER^BGPDPH Q:BGPQUIT  D H6^BGPDPH
 W !!,"BASELINE REPORTING PERIOD"
 W !,"# MALE active users"
 S T=23 F X=2:1:9 S Y=$$V(BGPRPT,99,X) S V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/Education"
 S T=23 F X=11:1:18 S Y=$$V(BGPRPT,99,X),V=$P(Y,"!",1) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,99,X),D=$$V(BGPRPT,99,(X-9)),N1=$P(N,"!",1),D1=$P(D,"!",1),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 S $P(BGPX(X),U,2)=%
 D CHG
 Q
CHG1 ;
 W !,"% w/Education" S T=23 F X=11:1:18 S N=$$V(BGPRPT,BGPNODE,X),D=$$V(BGPRPT,BGPNODE,(X-9)),N1=$P(N,"!")+$P(N,"!",2),D1=$P(D,"!")+$P(D,"!",2),%=$S('D1:"",1:(N1/D1)*100) W ?T,$S(%="":"    .",1:$J(%,5,1)) S T=T+7 D
 .S A=$S(BGPNODE=10:1,BGPNODE=40:3,BGPNODE=80:2,1:"") S $P(BGPX(X),U,A)=%
 Q
CHG ;
 S T=23 W !!,"% Change from prev yr" S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S N=$P(BGPX(X),U),O=$P(BGPX(X),U,3) W ?T,$J($$CALC(N,O),6) S T=T+7
 S T=23 W !!,"% Change from base yr" S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S N=$P(BGPX(X),U),O=$P(BGPX(X),U,2) W ?T,$J($$CALC(N,O),6) S T=T+7
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
