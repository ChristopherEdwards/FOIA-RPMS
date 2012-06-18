ADGSRVP ; IHS/ADC/PDW/ENM - HSA-202 PRINT ; [ 11/01/2000  1:00 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**5,6**;MAR 25, 1999
 ;
 S DGLINE="",$P(DGLINE,"-",80)=""
A ; -- driver
 D HD,P1,LS,P2 Q
 ;
HD N X,Y S X="MONTHLY REPORT OF INPATIENT SERVICES IHS HOSPITALS"
 W @IOF W ?80-$L(X)/2,X,!,DGLINE,!,"Name and Location of Hospital"
 W ?64,"Month and Year",!!?5,$P($G(^DIC(4,+DUZ(2),0)),U)
 S X=$G(^AUTTLOC(+DUZ(2),0))
 ;IHS/ITSC/ENM 11/01/2000 NEXT LINE COPIED/MOD
 ;W "    ",$P(X,U,13)_", "_$P($G(^DIC(5,+$P(+X,U,14),0)),U)
 W "    ",$P(X,U,13)_", "_$P($G(^DIC(5,+$P(X,U,14),0)),U)
 S Y=$E(DGMON,1,3)+1700,X=$E(DGMON,4,5)
 W ?64,$P($P($T(MON),";;",2)," ",X)_" "_Y,!,DGLINE Q
 ;
P1 S X="Part I - Service and Census" W !?80-$L(X)/2,X,!,DGLINE
 W !?31,"Bom",?48,"Discharges",?64,"Eom",?70,"Inpatient"
 W !?1,"Medical Services Provided",?30,"Census",?40,"Adm"
 W ?48,"Death",?55,"Other",?63,"Census",?72,"Days",!,DGLINE,! Q
 ;
LS N S,I,J F S=1,2,3,5,6,7 D WS
 D TOT Q
 ;                            
 ;IHS/ASDST/LJF/ENM 09/25/00 NEXT 3 LINES DISABLED, 4TH LINE NEW
WS ;I S=1 W:DGA(3,8) ?40,DGA(3,8)_"t" W:DGA(3,7) ?55,DGA(3,7)_"t"
 ;I S=2 W:DGA(4,8) ?40,DGA(4,8)_"t" W:DGA(4,7) ?54,DGA(4,7)_"t"
 ;I S=3 W:DGA(3,7) ?40,DGA(3,7)_"t" W:DGA(3,8) ?54,DGA(3,8)_"t"
 ;IHS/ITSC/ENM 11/01/2000 NEXT LINE COPIED/MOD
 ;W:DSA(S,7) ?40,DGA(S,7)_"t" W:DGA(S,8) ?54,DGA(S,8)_"t" ;IHS/ANMC/LJF/ENM 09/25/00
 W:DGA(S,7) ?40,DGA(S,7)_"t" W:DGA(S,8) ?54,DGA(S,8)_"t" ;IHS/ANMC/LJF/ENM 09/25/00
 W !,$P($T(SRV+S),";;",2)
 W ?32,$J(DGA(S,1),3),?40,$J(DGA(S,2),3),?48,$J(DGA(S,3),3)
 W ?55,$J(DGA(S,4),3),?64,$J(DGA(S,5),3),?72,$J(DGA(S,6),4),! Q
 ;
TOT ; -- totals
 W ?30,"-----",?38,"-----",?46,"-----",?53,"-----",?62,"-----"
 W ?70,"------" F I=1:1:6 S DGX(I)=0
 F I=1,2,3,5,6,7 F J=1:1:6 S DGX(J)=DGX(J)+DGA(I,J)  ;totals
 W !?10,"TOTAL",?32,$J(DGX(1),3),?40,$J(DGX(2),3),?48,$J(DGX(3),3)
 W ?55,$J(DGX(4),3),?64,$J(DGX(5),3),?72,$J(DGX(6),4),!,DGLINE
 ; -- newborn
 W ! W:DGA(4,7) ?40,DGA(4,7)_"t" W:DGA(4,8) ?54,DGA(4,8)_"t"
 W !,"NEWBORN"
 W ?32,$J(DGA(4,1),3),?40,$J(DGA(4,2),3),?48,$J(DGA(4,3),3)
 W ?55,$J(DGA(4,4),3),?64,$J(DGA(4,5),3),?72,$J(DGA(4,6),4),!,DGLINE
 Q
 ;
P2 W !?26,"Part II - Special Information",!,DGLINE
 W !!,"Peak Census, Excluding Newborn................................."
 W ?64,DGMAX
 W !!,"Minimum Census, Excluding Newborn..............................."
 W ?64,DGMIN Q
 ;
MON ;;JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC
SRV ;;
 ;;MEDICAL & SURGICAL (Adult)
 ;;MEDICAL & SURGICAL (Ped.)
 ;;OBSTETRIC
 ;;NEWBORN
 ;;TUBERCULOSIS
 ;;ALCOHOLISM/SUBSTANCE ABUSE
 ;;MENTAL HEALTH
