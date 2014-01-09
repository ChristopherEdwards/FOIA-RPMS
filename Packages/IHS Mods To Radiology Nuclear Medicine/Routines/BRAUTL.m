BRAUTL ;IHS/BJI/DAY - IHS Radiology Utility Routine ; 20 Apr 2011  4:18 PM
 ;;5.0;Radiology/Nuclear Medicine;**1003**;Nov 01, 2010;Build 3
 ;
RAZAGE ;EP - Called from IHS AGE OF PATIENT in LABEL PRINT FIELDS FILE
 ;
 N DFN,BRADAYS,BRADOB,BRAAGE
 ;
 I '$G(RADFN) S RAZAGE="" Q
 ;
 S DFN=RADFN
 ;
 D DEM^VADPT
 ;
 S X1=DT
 S X2=$P(VADM(3),U)
 D ^%DTC
 S BRADAYS=X
 ;
 D GETDOB
 ;
 D GETAGE
 ;
 S RAZAGE=BRADOB_" "_BRAAGE
 ;
 Q
 ;
 ;
RAZEXAGE ;EP - Called from IHS AGE OF PATIENT AT EXAM
 ;Entry in LABEL PRINT FIELDS file
 ;
 N DFN,BRADAYS,BRADOB,BRAAGE
 ;
 I '$D(RADFN) S RAZEXAGE="" Q
 ;
 S DFN=RADFN
 ;
 D DEM^VADPT
 ;
 ;Exam Date
 S X1=$P($P(RAY2,U),".")
 S X2=$P(VADM(3),U)
 D ^%DTC
 S BRADAYS=X
 ;
 D GETDOB
 ;
 D GETAGE
 ;
 S RAZEXAGE=BRADOB_" "_BRAAGE
 ;
 Q
 ;
 ;
GETDOB ;EP - Get DOB and format it
 ;
 S X=$P(VADM(3),U)
 ;
 S BRADOB=$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3))
 ;
 Q
 ;
 ;
GETAGE ;EP - Get AGE and format it
 ;
 S X=BRADAYS
 ;
 I X<60 S BRAAGE=X_" Days" Q
 ;
 I X<913 S BRAAGE=$J(X/30.44,0,0)_" Mos" Q
 ;
 S BRAAGE=$J(X/365.25,0,0)_" Yrs"
 ;
 Q
 ;
