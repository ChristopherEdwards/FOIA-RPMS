FHINI0M1	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(117.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,117.4)
	;;=^FH(117.4,
	;;^UTILITY(U,$J,117.4,0)
	;;=DIETETIC REPORT CATEGORIES^117.4^43^38
	;;^UTILITY(U,$J,117.4,1,0)
	;;=Renal Dialysis^S^RENAL DIALYSIS
	;;^UTILITY(U,$J,117.4,2,0)
	;;=Traumatic Brain Injury^S^TRAUMATIC BRAIN INJURY
	;;^UTILITY(U,$J,117.4,3,0)
	;;=Spinal Cord Injury^S^SPINAL CORD INJURY
	;;^UTILITY(U,$J,117.4,4,0)
	;;=Nutrition Support Team^S^NUTRITION SUPPORT TEAM
	;;^UTILITY(U,$J,117.4,5,0)
	;;=HBHC  Program^S^HBHC  PROGRAM
	;;^UTILITY(U,$J,117.4,6,0)
	;;=Cardiac Rehabilitation^S^CARDIAC REHABILITATION
	;;^UTILITY(U,$J,117.4,7,0)
	;;=AIDS (Medicine)^S^AIDS (MEDICINE)
	;;^UTILITY(U,$J,117.4,8,0)
	;;=Cancer Treatment Center^S^CANCER TREATMENT CENTER
	;;^UTILITY(U,$J,117.4,9,0)
	;;=Lipid/cardio Risk Clinic^S^LIPID/CARDIO RISK CLINIC
	;;^UTILITY(U,$J,117.4,10,0)
	;;=GREC^S^GREC
	;;^UTILITY(U,$J,117.4,11,0)
	;;=Geriatric Eval. & Mgmt. Unit^S^GERIATRIC EVAL. & MGMT. UNIT
	;;^UTILITY(U,$J,117.4,12,0)
	;;=Substance Abuse Program^S^SUBSTANCE ABUSE PROGRAM
	;;^UTILITY(U,$J,117.4,13,0)
	;;=Wellness Clinic for Patients^S^WELLNESS CLINIC FOR PATIENTS
	;;^UTILITY(U,$J,117.4,14,0)
	;;=Wellness for Employees^S^WELLNESS FOR EMPLOYEES
	;;^UTILITY(U,$J,117.4,15,0)
	;;=Medical Center Research^S^MEDICAL CENTER RESEARCH
	;;^UTILITY(U,$J,117.4,16,0)
	;;=Liver Transplant^S^LIVER TRANSPLANT
	;;^UTILITY(U,$J,117.4,17,0)
	;;=Other Specialized Programs^S^OTHER SPECIALIZED PROGRAMS
	;;^UTILITY(U,$J,117.4,20,0)
	;;=Pellet^D^PELLET
	;;^UTILITY(U,$J,117.4,21,0)
	;;=Insulated Tray^D^INSULATED TRAY
	;;^UTILITY(U,$J,117.4,22,0)
	;;=Advanced (Retherm)^D^ADVANCED (RETHERM)
	;;^UTILITY(U,$J,117.4,23,0)
	;;=Advanced (Boost)^D^ADVANCED (BOOST)
	;;^UTILITY(U,$J,117.4,24,0)
	;;=Hot/Cold Cart^D^HOT/COLD CART
	;;^UTILITY(U,$J,117.4,25,0)
	;;=Cafeteria^D^CAFETERIA
	;;^UTILITY(U,$J,117.4,26,0)
	;;=Other Delivery System^D^OTHER DELIVERY SYSTEM
	;;^UTILITY(U,$J,117.4,30,0)
	;;=Advanced Delivery^E^ADVANCED DELIVERY
	;;^UTILITY(U,$J,117.4,31,0)
	;;=Agitating Kettle^E^AGITATING KETTLE
	;;^UTILITY(U,$J,117.4,32,0)
	;;=Automatic Transport^E^AUTOMATIC TRANSPORT
	;;^UTILITY(U,$J,117.4,33,0)
	;;=Blast Chiller^E^BLAST CHILLER
	;;^UTILITY(U,$J,117.4,34,0)
	;;=Circular Trayline^E^CIRCULAR TRAYLINE
	;;^UTILITY(U,$J,117.4,35,0)
	;;=Comb. Conv Oven/Stmr^E^COMB. CONV OVEN/STMR
	;;^UTILITY(U,$J,117.4,36,0)
	;;=Cook Tank^E^COOK TANK
	;;^UTILITY(U,$J,117.4,37,0)
	;;=Ice Builder^E^ICE BUILDER
	;;^UTILITY(U,$J,117.4,38,0)
	;;=Pump Fill Station^E^PUMP FILL STATION
	;;^UTILITY(U,$J,117.4,39,0)
	;;=Rethermalization Oven^E^RETHERMALIZATION OVEN
	;;^UTILITY(U,$J,117.4,40,0)
	;;=Vacumn Packer^E^VACUMN PACKER
	;;^UTILITY(U,$J,117.4,41,0)
	;;=Pulper/Waste Disposal^E^PULPER/WASTE DISPOSAL
	;;^UTILITY(U,$J,117.4,42,0)
	;;=Dishmachine-Circular^E^DISHMACHINE-CIRCULAR
	;;^UTILITY(U,$J,117.4,43,0)
	;;=Dishmachine-Flight^E^DISHMACHINE-FLIGHT
