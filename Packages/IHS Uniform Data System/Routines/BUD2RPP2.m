BUD2RPP2 ; IHS/CMI/LAB - UDS REPORT PRINT 30 Dec 2012 10:44 AM 22 Oct 2012 12:16 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
T4SH ;
 W !!,$$CTR("TABLE 4 - SELECTED PATIENT CHARACTERISTICS",80)
 W !!,BUD80L
 Q
 ;
T4 ;EP
 S BUDPG=0
 S BUDTABI=$O(^BUDRCNTL("B","TABLE 4 LINE LABELS",0))
 D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 ;print out each line
 ;
 I $Y>(IOSL-6) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 W !!,"CHARACTERISTIC",?60,"NUMBER OF PATIENTS",!?66,"(a)"
 W !,BUD80L
 W !,"INCOME AS PERCENT OF POVERTY LEVEL"
 W !,BUD80L
 F BUDX=1,2,3,4,5,6 Q:BUDQUIT  D
 .I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 .S BUDY=$O(^BUDRCNTL(BUDTABI,11,"B",BUDX,0))
 .W !?2,BUDX,".",?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,2),?63,$$C(BUDT4V(BUDX))
 .W !,BUD80L
 I $Y>(IOSL-22) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 W !!,"PRINCIPAL THIRD PARTY MEDICAL INSURANCE SOURCE",?50,"0-19 YEARS",?65,"20 AND OLDER",!?52,"OLD (a)",?70,"(b)"
 W !,BUD80L
 F BUDX=7,"8a","8b",8,9,"10a","10b",10,11,12 Q:BUDQUIT  D
 .I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 .S BUDY=$O(^BUDRCNTL(BUDTABI,11,"B",BUDX,0))
 .W !?2,BUDX,".",?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,2),?50,$$C($P(BUDT4V(BUDX),U,1)),?65,$$C($P(BUDT4V(BUDX),U,2))
 .W !,BUD80L
 D HEADER^BUD2RPTP Q:BUDQUIT
 D T4SH
 W !,"MANAGED CARE UTILIZATION",!,BUD80L
 W !,?50,"OTHER"
 W !,?50,"PUBLIC"
 W !,?50,"INCLUDING"
 W !,?2,"PAYOR CATEGORY",?30,"MEDICAID",?40,"MEDICARE",?50,"NON-",?60,"PRIVATE",?70,"TOTAL"
 W !?50,"MEDICAID"
 W !,?50,"CHIP"
 W !,?30,"  (a)",?40,"  (b)",?50,"(c)",?60,"  (d)",?70," (e)"
 W !,BUD80L
 F BUDX="13a","13b","13c" Q:BUDQUIT  D
 .I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 .S BUDY=$O(^BUDRCNTL(BUDTABI,11,"B",BUDX,0))
 .W !?2,BUDX,".",?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,2),!,?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,3) ;,?50,$$C($P(BUDT4V(BUDX),U,1)),?65,$$C($P(BUDT4V(BUDX),U,2))
 .W !,BUD80L
 I $Y>(IOSL-28) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 W !,"CHARACTERISTICS - SPECIAL POPULATIONS",?60,"NUMBER OF PATIENTS",!?65," - (a)"
 W !,BUD80L
 F BUDX=14:1:25 Q:BUDQUIT  D
 .I $Y>(IOSL-3) D HEADER^BUD2RPTP Q:BUDQUIT  D T4SH
 .S BUDY=$O(^BUDRCNTL(BUDTABI,11,"B",BUDX,0))
 .W !?2,BUDX,".",?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,2) W:$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,3)]"" !?7,$P(^BUDRCNTL(BUDTABI,11,BUDY,0),U,3) W ?63,$$C(BUDT4V(BUDX))
 .W !,BUD80L
 W !
 Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "*******"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
C9(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "**********"
 S X2=2,X3=14
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
T9SH ;
 W !!,$$CTR("TABLE 9D - PATIENT-RELATED REVENUE (SCOPE OF PROJECT ONLY)",80)
 W !!,BUD80L
 W !!?40," FULL",?60,"AMOUNT"
 W !?40,"CHARGES",?60,"COLLECTED"
 W !?40,"THIS PERIOD",?60,"THIS PERIOD"
 W !,"PAYOR CATEGORY",?42,"(a)",?61,"(b)"
 ;W !,BUD80L
 Q
 ;
T9 ;EP
 S BUDPG=0
 D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 ;print out each line
 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 W !,BUD80L
 W !?5,"Medicaid Non-Managed",!,"1.   Care"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICAID",!,"3.       (LINES 1+2A+2B)"
 W ?40,$$C9($P(BUDT9(3),U,1))
 W ?60,$$C9($P(BUDT9(3),U,2))
 ;W !,BUD80L
4 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 W !,BUD80L
 W !?5,"Medicare Non-Managed",!,"4.   Care"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICARE",!,"6.      (LINES 4+5A+5B)"
 W ?40,$$C9($P(BUDT9(6),U,1))
 W ?60,$$C9($P(BUDT9(6),U,2))
 ;W !,BUD80L
7 ;
 I $Y>(IOSL-13) D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"7.   Non-Medicaid CHIP (Non"
 W !?5,"Managed Care)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8a.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care Capitated)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8b.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care fee-for-service)"
 W !,BUD80L
 W !?5,"    TOTAL OTHER PUBLIC"
 W !,"9.        (LINES 7+8A+8B)"
 W ?40,$$C9($P(BUDT9(9),U,1))
 W ?60,$$C9($P(BUDT9(9),U,2))
 W !,BUD80L
10 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 W !,BUD80L
 W !?5,"Private Non-Managed",!,"10.  Care"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11a. (capitated)"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11b. (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL PRIVATE",!,"12.    (LINES 10+11A+11B)"
 W ?40,$$C9($P(BUDT9(12),U,1))
 W ?60,$$C9($P(BUDT9(12),U,2))
 ;W !,BUD80L
13 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T9SH
 W !,BUD80L
 W !,"13.",!?5,"Self Pay"
 W ?40,$$C9($P(BUDT9(13),U,1))
 W ?60,$$C9($P(BUDT9(13),U,2))
 W !,BUD80L
 W !,"14.",?5,"         TOTAL"
 W !?5,"(LINES 3+6+9+12+13)"
 S T=$P($G(BUDT9(3)),U,1)+$P($G(BUDT9(6)),U,1)+$P($G(BUDT9(9)),U,1)+$P($G(BUDT9(12)),U,1)+$P($G(BUDT9(13)),U,1)
 S V=$P($G(BUDT9(3)),U,2)+$P($G(BUDT9(6)),U,2)+$P($G(BUDT9(9)),U,2)+$P($G(BUDT9(12)),U,2)+$P($G(BUDT9(13)),U,2)
 W ?40,$$C9(T)
 W ?60,$$C9(V)
 W !,BUD80L
PAGE2 ;
 D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 ;print out each line
 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 W !,BUD80L
 W !?5,"Medicaid Non-Managed",!,"1.   Care"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICAID",!,"3.       (LINES 1+2A+2B)"
 ;W ?40,$$C9($P(BUDT9(3),U,1))
 ;W ?60,$$C9($P(BUDT9(3),U,2))
 ;W !,BUD80L
24 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 W !,BUD80L
 W !?5,"Medicare Non-Managed",!,"4.   Care"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICARE",!,"6.      (LINES 4+5A+5B)"
 ;W ?40,$$C9($P(BUDT9(6),U,1))
 ;W ?60,$$C9($P(BUDT9(6),U,2))
 ;W !,BUD80L
27 ;
 I $Y>(IOSL-13) D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"7.   Non-Medicaid CHIP (Non"
 W !?5,"Managed Care)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8a.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care Capitated)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8b.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care fee-for-service)"
 W !,BUD80L
 W !?5,"    TOTAL OTHER PUBLIC"
 W !,"9.        (LINES 7+8A+8B)"
 ;W ?40,$$C9($P(BUDT9(9),U,1))
 ;W ?60,$$C9($P(BUDT9(9),U,2))
 ;W !,BUD80L
210 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 W !,BUD80L
 W !?5,"Private Non-Managed",!,"10.  Care"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11a. (capitated)"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11b. (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL PRIVATE",!,"12.    (LINES 10+11A+11B)"
 ;W ?40,$$C9($P(BUDT9(12),U,1))
 ;W ?60,$$C9($P(BUDT9(12),U,2))
 ;W !,BUD80L
213 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T92SH
 W !,BUD80L
 W !,"13.",!?5,"Self Pay"
 ;W ?40,$$C9($P(BUDT9(13),U,1))
 ;W ?60,$$C9($P(BUDT9(13),U,2))
 W !,BUD80L
 W !,"14.",?5,"         TOTAL"
 W !?5,"(LINES 3+6+9+12+13)"
 ;S T=$P($G(BUDT9(3)),U,1)+$P($G(BUDT9(6)),U,1)+$P($G(BUDT9(9)),U,1)+$P($G(BUDT9(12)),U,1)+$P($G(BUDT9(13)),U,1)
 ;S V=$P($G(BUDT9(3)),U,2)+$P($G(BUDT9(6)),U,2)+$P($G(BUDT9(9)),U,2)+$P($G(BUDT9(12)),U,2)+$P($G(BUDT9(13)),U,2)
 ;W ?40,$$C9(T)
 ;W ?60,$$C9(V)
 W !,BUD80L
PAGE3 ;
 D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 ;print out each line
 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 W !,BUD80L
 W !?5,"Medicaid Non-Managed",!,"1.   Care"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicaid Managed Care",!,"2b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICAID",!,"3.       (LINES 1+2A+2B)"
 W ?35,$$C9($P(BUDT9(3),U,3))
 ;W ?60,$$C9($P(BUDT9(3),U,2))
 ;W !,BUD80L
34 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 W !,BUD80L
 W !?5,"Medicare Non-Managed",!,"4.   Care"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5a.  (capitated)"
 W !,BUD80L
 W !?5,"Medicare Managed Care",!,"5b.  (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL MEDICARE",!,"6.      (LINES 4+5A+5B)"
 W ?35,$$C9($P(BUDT9(6),U,3))
 ;W ?60,$$C9($P(BUDT9(6),U,2))
 ;W !,BUD80L
37 ;
 I $Y>(IOSL-13) D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"7.   Non-Medicaid CHIP (Non"
 W !?5,"Managed Care)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8a.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care Capitated)"
 W !,BUD80L
 W !?5,"Other Public including"
 W !,"8b.  Non-Medicaid CHIP"
 W !,?5,"(Managed Care fee-for-service)"
 W !,BUD80L
 W !?5,"    TOTAL OTHER PUBLIC"
 W !,"9.        (LINES 7+8A+8B)"
 W ?35,$$C9($P(BUDT9(9),U,3))
 ;W ?60,$$C9($P(BUDT9(9),U,2))
 W !,BUD80L
310 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 W !,BUD80L
 W !?5,"Private Non-Managed",!,"10.  Care"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11a. (capitated)"
 W !,BUD80L
 W !?5,"Private Managed Care",!,"11b. (fee-for-service)"
 W !,BUD80L
 W !?5,"       TOTAL PRIVATE",!,"12.    (LINES 10+11A+11B)"
 W ?35,$$C9($P(BUDT9(12),U,3))
 ;W ?60,$$C9($P(BUDT9(12),U,2))
 ;W !,BUD80L
313 ;
 I $Y>(IOSL-9) D HEADER^BUD2RPTP Q:BUDQUIT  D T93SH
 W !,BUD80L
 W !,"13.",!?5,"Self Pay"
 W ?35,$$C9($P(BUDT9(13),U,3))
 ;W ?60,$$C9($P(BUDT9(13),U,2))
 W !,BUD80L
 W !,"14.",?5,"         TOTAL"
 W !?5,"(LINES 3+6+9+12+13)"
 S T=$P($G(BUDT9(3)),U,3)+$P($G(BUDT9(6)),U,3)+$P($G(BUDT9(9)),U,3)+$P($G(BUDT9(12)),U,3)+$P($G(BUDT9(13)),U,3)
 ;S V=$P($G(BUDT9(3)),U,2)+$P($G(BUDT9(6)),U,2)+$P($G(BUDT9(9)),U,2)+$P($G(BUDT9(12)),U,2)+$P($G(BUDT9(13)),U,2)
 W ?35,$$C9(T)
 ;W ?60,$$C9(V)
 W !,BUD80L
 Q
T92SH ;
 W !!,$$CTR("TABLE 9D - PATIENT-RELATED REVENUE (SCOPE OF PROJECT ONLY)",80)
 W !!,BUD80L
 W !,$$CTR("RETROACTIVE SETTLEMENTS, RECEIPTS AND PAYPACKS (c)")
 W !?56,"COLLECTION OF"
 W !?43,"COLLECTION",?56,"OTHER"
 W !?30,"COLLECTION",?43,"OF RECONCIL",?56,"RETROACTIVE"
 W !?30,"RECONCILIA",?43,"IATION/WRAP",?56,"PAYMENTS",?69,"PENALTY/"
 W !?30,"TION/WRAP",?43,"AROUND",?56,"INCLUDING",?69,"PAYBACK"
 W !?30,"AROUND",?43,"PREVIOUS",?56,"RISK POOL/"
 W !?30,"CURRENT",?43,"YEARS",?56,"INCENTIVE/"
 W !?30,"YEAR",?56,"WITHHOLD"
 W !,"PAYOR CATEGORY",?33,"(c1)",?46,"(c2)",?59,"(c3)",?72,"(c4)"
 ;W !,BUD80L
 Q
 ;----------
T93SH ;
 W !!,$$CTR("TABLE 9D - PATIENT-RELATED REVENUE (SCOPE OF PROJECT ONLY)",80)
 W !!,BUD80L
 W !!?50,"SLIDING",?65,"BAD DEBT"
 W !?35,"ALLOWANCES",?50,"DISCOUNTS",?65,"WRITE OFF"
 W !,"PAYOR CATEGORY",?38,"(d)",?53,"(e)",?68,"(f)"
 ;W !,BUD80L
 Q
