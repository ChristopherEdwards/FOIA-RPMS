BDGM202B ; IHS/ANMC/LJF - M202 PRINT ; [ 01/04/2005  5:03 PM ]
 ;;5.3;PIMS;**1001,1006,1008,1013**;MAY 28, 2004
 ;IHS/ITSC/WAR 09/27/2004 PATCH 1001 Shift transfers Rt 1 position
 ;IHS/ITSC/LJF 10/25/2004 PATCH 1001 remove blank lines to fit new info
 ;IHS/OIT/LJF  08/24/2006 PATCH 1006 added lines for swing beds & observations
 ;cmi/anch/maw 11/07/2007 PATCH 1008 set DGMIN and DGMAX = +$G, just in case they are not set when no data 
 ;ihs/cmi/maw  04/18/2011 PATCH 1013 RQMT155 added day surgery
 ;
 NEW DGLINE
 S DGLINE=$$REPEAT^XLFSTR("-",80)
 U IO
 D HD              ;print heading
 D PART1           ;print Part I - Service and Census
 D PART2           ;print Part II - Special Info
 D ^BDGM202C       ;print Part III - Beds Available and Comments
 Q                 ;returns to BDGM202A and EXIT subrtn
 ;
HD ; print heading
 NEW X,Y
 I BDGBM=BDGEM D
 . S X="MONTHLY REPORT OF INPATIENT SERVICES IHS HOSPITALS"  ;m202
 E  S X="RANGE OF MONTHS REPORT FOR INPATIENT SERVICES"      ;y202
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 remove form feed
 ;W @IOF W ?80-$L(X)/2,X,!,DGLINE,!,"Name and Location of Hospital"
 W ?80-$L(X)/2,X,!,DGLINE,!,"Name and Location of Hospital"
 ;
 ;W ?55,"Month and Year",!!,$$GET1^DIQ(4,+DUZ(2),.01)    ;facility
 W ?55,"Month and Year",!,$$GET1^DIQ(4,+DUZ(2),.01)  ;facility; IHS/ITSC/LJF 10/25/2004 PATHC 1001
 W "    ",$$GET1^DIQ(9999999.06,DUZ(2),.15)               ;city
 W ", ",$$GET1^DIQ(9999999.06,DUZ(2),.16)                 ;state
 W ?55,$$FMTE^XLFDT(BDGBM)
 I BDGBM'=BDGEM W " to ",$$FMTE^XLFDT(BDGEM)
 W !,DGLINE
 Q
 ;
PART1 ; Print Part I
 NEW X,S,I,J
 S X="Part I - Service and Census" W !?80-$L(X)/2,X,!,DGLINE
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 shortened "Inpatient" 
 W !?31,"Bom",?48,"Discharges",?64,"Eom",?70,"Inpatient"
 W !?31,"Bom",?48,"Discharges",?64,"Eom",?70,"Inpt"
 ;
 W !?1,"Medical Services Provided",?30,"Census",?40,"Adm"
 W ?48,"Death",?55,"Other",?63,"Census",?72,"Days",!,DGLINE,!
 ;
 ; for each service category, print columns of data
 F S=1,2,3,5,6,7 D COL
 ;
 ; now print column totals
 D TOT Q
 ;                            
COL ; -- columns
 ; start with transfers between service categories
 ;IHS/ITSC/WAR 9/27/04 PATCH #1001 Shift Rt 1 position
 ;W:DGA(S,7) ?40,DGA(S,7)_"t" W:DGA(S,8) ?54,DGA(S,8)_"t"
 W:DGA(S,7) ?40,DGA(S,7)_"t" W:DGA(S,8) ?55,DGA(S,8)_"t"
 ;
 ; then name of service category
 W !,$P($T(SRV+S),";;",2)
 ;   and then the columns
 W ?32,$J(DGA(S,1),3),?40,$J(DGA(S,2),3),?48,$J(DGA(S,3),3)
 W ?55,$J(DGA(S,4),3),?64,$J(DGA(S,5),3),?72,$J(DGA(S,6),4),!
 Q
 ;
TOT ; -- totals
 W ?30,"-----",?38,"-----",?46,"-----",?53,"-----",?62,"-----"
 W ?70,"------" F I=1:1:6 S DGX(I)=0
 F I=1,2,3,5,6,7 F J=1:1:6 S DGX(J)=DGX(J)+DGA(I,J)  ;totals
 W !?10,"TOTAL",?32,$J(DGX(1),3),?40,$J(DGX(2),3),?48,$J(DGX(3),3)
 W ?55,$J(DGX(4),3),?64,$J(DGX(5),3),?72,$J(DGX(6),4),!,DGLINE
 ; -- newborn
 ;IHS/ITSC/WAR 9/27/04 PATCH #1001 Shift Rt 1 position
 ;W ! W:DGA(4,7) ?40,DGA(4,7)_"t" W:DGA(4,8) ?54,DGA(4,8)_"t"
 W ! W:DGA(4,7) ?40,DGA(4,7)_"t" W:DGA(4,8) ?55,DGA(4,8)_"t"
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 add swing bed & observations
 ;F S=4,8,9 D
 F S=4,8,9,10 D  ;ihs/cmi/maw 04/18/2011 added day surgery
 . W $P($T(SRV+S),";;",2)
 . W ?32,$J(DGA(S,1),3),?40,$J(DGA(S,2),3) W:DGA(S,7) " ("_DGA(S,7)_"t)"
 . W ?48,$J(DGA(S,3),3),?55,$J(DGA(S,4),3) W:DGA(S,8) " ("_DGA(S,8)_"t)"
 . W ?64,$J(DGA(S,5),3),?72,$J(DGA(S,6),4),!
 W DGLINE
 Q
 ;
 W !,"NEWBORN"
 W ?32,$J(DGA(4,1),3),?40,$J(DGA(4,2),3),?48,$J(DGA(4,3),3)
 W ?55,$J(DGA(4,4),3),?64,$J(DGA(4,5),3),?72,$J(DGA(4,6),4),!,DGLINE
 Q
 ;
 ;IHS/OIT/LJF 08/24/2006 PATCH 1006 removed extra dotted line
PART2 ;W !?26,"Part II - Special Information",!,DGLINE
 W !?26,"Part II - Special Information"
 ;W !!,"Peak Census, Excluding Newborn................................."
 W !,"Peak Census, Excluding Newborn................................."  ;IHS/ITSC/LJF 10/25/2004 PATCH 1001
 ;W ?64,DGMAX  ;cmi/maw 11/7/2007 orig line  
 W ?64,+$G(DGMAX)  ;cmi/maw 11/7/2007 mod because PEAK^BDGM202A sometimes does not get set
 ;W !!,"Minimum Census, Excluding Newborn..............................."
 W !,"Minimum Census, Excluding Newborn..............................."  ;IHS/ITSC/LJF 10/25/2004 PATCH 1001
 ;W ?64,DGMIN  ;cmi/maw 11/7/2007 orig line
 W ?64,+$G(DGMIN)  ;cmi/maw 11/7/2007 mod because PEAK^BDGM202A sometimes does not get set
 Q
 ;
 ;IHS/OIT/LJF 08/24/2006 patch 1006 added Swing Beds & Observations to list below
SRV ;;
 ;;MEDICAL & SURGICAL (Adult)
 ;;MEDICAL & SURGICAL (Ped.)
 ;;OBSTETRIC
 ;;NEWBORN
 ;;TUBERCULOSIS
 ;;ALCOHOLISM/SUBSTANCE ABUSE
 ;;MENTAL HEALTH
 ;;SWING BEDS
 ;;OBSERVATIONS
 ;;DAY SURGERY
