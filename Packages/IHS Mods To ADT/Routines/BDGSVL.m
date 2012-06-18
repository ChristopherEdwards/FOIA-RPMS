BDGSVL ; IHS/ANMC/LJF - SCHED VISITS LIST ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW BDGBD,BDGED,BDGVT,BDGRT,BDGS1,BDGS2,BDGA,X,I,BDGEX
 ;
 ; aks user for date range
 S BDGBD=$$READ^BDGF("DO^::EX","Select Earliest Date Expected")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Latest Date Expected")
 Q:BDGED<1
 ;
 ; ask user for visit type
 S BDGVT=$$READ^BDGF("SO^1:Admissions;2:Day Surgeries;3:Outpatient Visits;4:All Types","Select Visit Type for Report") Q:'BDGVT
 S BDGVT=$S(BDGVT=1:"A",BDGVT=2:"D",BDGVT=3:"O",1:BDGVT)
 ;
 S BDGEX=$$READ^BDGF("Y","Include No-Shows and Cancellations","NO")
 Q:BDGEX=U
 ;
 ; set up main sort
 K BDGA W !
 I BDGVT="A" F I=1,2,4,5,6,7,8,9 D GETSORT(I)   ;admissions
 I BDGVT="D" F I=1,2,4,5,6,7,8 D GETSORT(I)     ;day surgeries
 I BDGVT="O" F I=1,2,3,4,5,6,8 D GETSORT(I)     ;outpatient visits
 I BDGVT=4 F I=1,2,4,5,6,8 D GETSORT(I)       ;all
 S I=0 F  S I=$O(BDGA(I)) Q:'I  S X=I W !,$J(I,2),". ",$P(BDGA(I),U,2)
 S Y=$$READ^BDGF("N^1:"_X,"Sort Report By") Q:'Y
 S BDGS1=BDGA(Y)
 ;
 ; set up subsort
 K BDGA W !
 I BDGVT="A" F I=1,2,4,5,6,7,8,9 D GETSORT(I)   ;admissions
 I BDGVT="D" F I=1,2,4,5,6,7,8 D GETSORT(I)     ;day surgeries
 I BDGVT="O" F I=1,2,3,4,5,6,8 D GETSORT(I)     ;outpatient visits
 I BDGVT=4 F I=1,2,4,5,6,8 D GETSORT(I)       ;all
 S I=0 F  S I=$O(BDGA(I)) Q:'I  S X=I W !,$J(I,2),". ",$P(BDGA(I),U,2)
 S Y=$$READ^BDGF("N^1:"_X,"Within "_$P(BDGS1,U,2)_" Sort Report By")
 Q:'Y  S BDGS2=BDGA(Y)
 ;
 ; get report type
 I $D(^XUSEC("DGZNOCLN",DUZ)) S BDGRT="B"
 E  S BDGRT=$$READ^BDGF("S^B:Brief;D:Detailed","Select Report Type","B")
 Q:BDGRT=U  Q:BDGRT=""
 ;
 ; call print device
 I $$BROWSE^BDGF="B" D EN^BDGSVL1 Q
 D ZIS^BDGF("QP","EN^BDGSVL1","SCHEDULED VISITS LIST","BDGBD;BDGED;BDGVT;BDGS1;BDGS2;BDGRT;BDGEX")
 Q
 ;
 ;
GETSORT(X) ; build BDGA array for sort questions
 ; don't repeat sort item under subsort if already selected
 I $D(BDGS1),$P(BDGS1,U)=$P($T(SORT+X),";;",3) Q
 ;
 NEW Y S Y=$O(BDGA(99),-1)+1
 S BDGA(Y)=$P($T(SORT+X),";;",3)_U_$P($T(SORT+X),";;",2)
 Q
 ;
SORT ;;
 ;;Authorizing Provider;;.04;;
 ;;Case Manager;;.05;;
 ;;Clinic;;.11;;
 ;;Community;;.013;;
 ;;Date Expected;;.02;;
 ;;Patient Name;;.01;;
 ;;Service;;.08;.121;;
 ;;Visit Disposition;;.16;;
 ;;Ward;;.09;;
