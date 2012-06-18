BGPDP22 ; IHS/CMI/LAB - print ind 22 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I22 ;EP ; 
 ;Q:'$D(BGPIND(22))
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing",!
 W "Denomimator is ALL active users."
 W !,"Increase the total number of Public Health Nursing services (both primary",!,"and secondary treatment and preventive services) provided to individuals",!,"in all settings and the total number of home visits.",!
 W !,"Public Health Nursing",!
 D H1^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1)+$P($$V(BGPRPT,10,1),"!",2),BGPCYN=$P($$V(BGPRPT,18,1),"!",1)+$P($$V(BGPRPT,18,1),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1)+$P($$V(BGPRPT,40,1),"!",2),BGPPRN=$P($$V(BGPRPT,48,1),"!",1)+$P($$V(BGPRPT,48,1),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1)+$P($$V(BGPRPT,80,1),"!",2),BGP98N=$P($$V(BGPRPT,88,1),"!",1)+$P($$V(BGPRPT,88,1),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 W !,"# active users",?22,$$C(BGP98D,0,8),?37,$$C(BGPPRD,0,8),?52,$$C(BGPCYD,0,8)
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# of persons served by PHNs",!?2,"in any setting"
 D H2^BGPDPH
 S BGPCYD=$P($$V(BGPRPT,10,1),"!",1)+$P($$V(BGPRPT,10,1),"!",2),BGPCYN=$P($$V(BGPRPT,18,3),"!",1)+$P($$V(BGPRPT,18,3),"!",2),BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRD=$P($$V(BGPRPT,40,1),"!",1)+$P($$V(BGPRPT,40,1),"!",2),BGPPRN=$P($$V(BGPRPT,48,3),"!",1)+$P($$V(BGPRPT,48,3),"!",2),BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGP98D=$P($$V(BGPRPT,80,1),"!",1)+$P($$V(BGPRPT,80,1),"!",2),BGP98N=$P($$V(BGPRPT,88,3),"!",1)+$P($$V(BGPRPT,88,3),"!",2),BGP98P=$S(BGP98D:((BGP98N/BGP98D)*100),1:"")
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# of persons served by PHNs",!?2,"in a home setting"
 D H2^BGPDPH
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# of PHN Visits -",!?2," any Setting",?21,$$C($P($$V(BGPRPT,88,2),"!",1)+$P($$V(BGPRPT,88,2),"!",2),0,9),?37,$$C($P($$V(BGPRPT,48,2),"!",1)+$P($$V(BGPRPT,48,2),"!",2),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,2),"!",1)+$P($$V(BGPRPT,18,2),"!",2),0,9)
 S X=$P($$V(BGPRPT,88,2),"!",1)+$P($$V(BGPRPT,88,2),"!",2),Y=$P($$V(BGPRPT,18,2),"!",1)+$P($$V(BGPRPT,18,2),"!",2),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,2),"!",1)+$P($$V(BGPRPT,48,2),"!",2),Y=$P($$V(BGPRPT,18,2),"!",1)+$P($$V(BGPRPT,18,2),"!",2),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 I $Y>(IOSL-5) D HEADER^BGPDPH Q:BGPQUIT
 W !!,"# of PHN Visits -",!?2," in a Home Setting",?21,$$C($P($$V(BGPRPT,88,4),"!",1)+$P($$V(BGPRPT,88,4),"!",2),0,9),?37,$$C($P($$V(BGPRPT,48,4),"!",1)+$P($$V(BGPRPT,48,4),"!",2),0,9)
 W ?52,$$C($P($$V(BGPRPT,18,4),"!",1)+$P($$V(BGPRPT,18,4),"!",2),0,9)
 S X=$P($$V(BGPRPT,88,4),"!",1)+$P($$V(BGPRPT,88,4),"!",2),Y=$P($$V(BGPRPT,18,4),"!",1)+$P($$V(BGPRPT,18,4),"!",2),%=$S(X:((Y-X)/X)*100,1:"") W ?67,$J(%,5,1)
 S X=$P($$V(BGPRPT,48,4),"!",1)+$P($$V(BGPRPT,48,4),"!",2),Y=$P($$V(BGPRPT,18,4),"!",1)+$P($$V(BGPRPT,18,4),"!",2),%=$S(X:((Y-X)/X)*100,1:"") W ?74,$J(%,5,1)
 D AAGE^BGPDP22A
 D MAGE^BGPDP22B
 D FAGE^BGPDP22C
POV ;
 D POV^BGPDP221
PPOV ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"ALL PHN VISITS BASELINE PERIOD",!
 W !?42,"BASE" D H
 S BGPCYD=$P($$V(BGPRPT,18,2),"!",1)+$P($$V(BGPRPT,18,2),"!",2)
 S BGPPRD=$P($$V(BGPRPT,48,2),"!",1)+$P($$V(BGPRPT,48,2),"!",2)
 S BGP98D=$P($$V(BGPRPT,88,2),"!",1)+$P($$V(BGPRPT,88,2),"!",2)
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","ALLV","BL",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","ALLV","BL",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN ALL Visits Top Ten Diagnoses - ALL PHN VISITS BASELINE PERIOD",!!,?42,"BASE" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGP98D:(((9999999-BGPX)/BGP98D)*100),1:""),5,1) S BGPCNT=BGPCNT+1
PRAL ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"ALL PHN VISITS PREVIOUS PERIOD",!
 W !?42,"PREVIOUS" D H
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","ALLV","PR",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","ALLV","PR",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN ALL Visits Top Ten Diagnoses - ALL PHN VISITS PREVIOUS PERIOD",!!,?42,"PREVIOUS" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGPPRD:(((9999999-BGPX)/BGPPRD)*100),1:""),5,1) S BGPCNT=BGPCNT+1
CYAL ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"ALL PHN VISITS REPORTING PERIOD",!
 W !?42,"REPORT" D H
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","ALLV","CY",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","ALLV","CY",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN ALL Visits Top Ten Diagnoses - ALL PHN VISITS REPORTING PERIOD",!!,?42,"REPORT" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGPCYD:(((9999999-BGPX)/BGPCYD)*100),1:""),5,1) S BGPCNT=BGPCNT+1
PHV ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"PHN HOME VISITS BASELINE PERIOD",!
 W !?42,"BASE" D H
 S BGPCYD=$P($$V(BGPRPT,18,4),"!",1)+$P($$V(BGPRPT,18,4),"!",2)
 S BGPPRD=$P($$V(BGPRPT,48,4),"!",1)+$P($$V(BGPRPT,48,4),"!",2)
 S BGP98D=$P($$V(BGPRPT,88,4),"!",1)+$P($$V(BGPRPT,88,4),"!",2)
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","HOME","BL",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","HOME","BL",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN Home Visits Top Ten Diagnoses - PHN HOME VISITS BASELINE PERIOD",!!,?42,"BASE" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGP98D:(((9999999-BGPX)/BGP98D)*100),1:""),5,1) S BGPCNT=BGPCNT+1
PR ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"PHN HOME VISITS PREVIOUS PERIOD",!
 W !?42,"PREVIOUS" D H
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","HOME","PR",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","HOME","PR",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN Home Visits Top Ten Diagnoses - PHN HOME VISITS PREVIOUS PERIOD",!!,?42,"PREVIOUS" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGPPRD:(((9999999-BGPX)/BGPPRD)*100),1:""),5,1) S BGPCNT=BGPCNT+1
CY ;
 D HEADER^BGPDPH
 W !,"Indicator 22:  Public Health Nursing - TOP TEN PRIMARY DIAGNOSES",!,"PHN HOME VISITS REPORTING PERIOD",!
 W !?42,"REPORT" D H
 S BGPX=0,BGPCNT=0 F  S BGPX=$O(^TMP($J,"PHN","HOME","CY",BGPX)) Q:BGPX'=+BGPX!(BGPCNT>9)!(BGPQUIT)  D
 .S BGPY=""!(BGPQUIT) F  S BGPY=$O(^TMP($J,"PHN","HOME","CY",BGPX,BGPY)) Q:BGPY=""  D
 ..I $Y>(IOSL-4) D HEADER^BGPDPH Q:BGPQUIT  W !,"PHN HOME Visits Top Ten Diagnoses - PHN HOME VISITS REPORTING PERIOD",!!,?42,"REPORT" D H
 ..S BGPC=BGPY S BGPC1=+$$CODEN^ICDCODE(BGPC,80) S BGPC1=$S(BGPC1:$E($P($$ICDDX^ICDCODE(BGPC1),U,4),1,32),1:"??")
 ..W !,BGPC,?8,BGPC1,?42,$$C((9999999-BGPX),0,8),?52,$J($S(BGPCYD:(((9999999-BGPX)/BGPCYD)*100),1:""),5,1) S BGPCNT=BGPCNT+1
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
