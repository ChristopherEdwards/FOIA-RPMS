GMPLO010	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",2534,1,4,0)
	;;=lists for this user; the view may be changed dynamically within the
	;;^UTILITY(U,$J,"PRO",2534,1,5,0)
	;;=Problem List application through the "Change View" action, but
	;;^UTILITY(U,$J,"PRO",2534,1,6,0)
	;;=it will not be stored as a new default unless updated here.
	;;^UTILITY(U,$J,"PRO",2534,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",2534,10,0)
	;;=^101.01PA^6^6
	;;^UTILITY(U,$J,"PRO",2534,10,1,0)
	;;=2792^AD^1
	;;^UTILITY(U,$J,"PRO",2534,10,1,"^")
	;;=GMPL UP ADD ITEM
	;;^UTILITY(U,$J,"PRO",2534,10,2,0)
	;;=2793^RM^2
	;;^UTILITY(U,$J,"PRO",2534,10,2,"^")
	;;=GMPL UP REMOVE ITEM
	;;^UTILITY(U,$J,"PRO",2534,10,3,0)
	;;=2794^SV^13
	;;^UTILITY(U,$J,"PRO",2534,10,3,"^")
	;;=GMPL UP SAVE VIEW
	;;^UTILITY(U,$J,"PRO",2534,10,4,0)
	;;=2357^^4
	;;^UTILITY(U,$J,"PRO",2534,10,4,"^")
	;;=GMPLX BLANK1
	;;^UTILITY(U,$J,"PRO",2534,10,5,0)
	;;=2803^VW^3
	;;^UTILITY(U,$J,"PRO",2534,10,5,"^")
	;;=GMPL UP SWITCH
	;;^UTILITY(U,$J,"PRO",2534,10,7,0)
	;;=2805^DV^11
	;;^UTILITY(U,$J,"PRO",2534,10,7,"^")
	;;=GMPL UP DELETE VIEW
	;;^UTILITY(U,$J,"PRO",2534,26)
	;;=D KEY^GMPLMGR1,SHOW^VALM
	;;^UTILITY(U,$J,"PRO",2534,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",2534,99)
	;;=56018,41304
	;;^UTILITY(U,$J,"PRO",2539,0)
	;;=GMPL EDIT SP^Special Exposure^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2539,1,0)
	;;=^^6^6^2930811^
	;;^UTILITY(U,$J,"PRO",2539,1,1,0)
	;;=This action allows editing the special exposures associated with the
	;;^UTILITY(U,$J,"PRO",2539,1,2,0)
	;;=current problem; if exposures related to this problem were previously
	;;^UTILITY(U,$J,"PRO",2539,1,3,0)
	;;=unknown, it may be entered here.  Data will only be asked for if the
	;;^UTILITY(U,$J,"PRO",2539,1,4,0)
	;;=patient is indicated for Agent Orange, Ionizing Radiation, or Persian
	;;^UTILITY(U,$J,"PRO",2539,1,5,0)
	;;=Gulf exposures in the Patient file.  MCCR will be using this data
	;;^UTILITY(U,$J,"PRO",2539,1,6,0)
	;;=for billing.
	;;^UTILITY(U,$J,"PRO",2539,15)
	;;=D CK^GMPLEDT3
	;;^UTILITY(U,$J,"PRO",2539,20)
	;;=D SP^GMPLEDT1 I 'GMPAGTOR,'GMPION,'GMPGULF W !!,"This patient has no special exposures on file.",! H 2
	;;^UTILITY(U,$J,"PRO",2539,99)
	;;=55908,59537
	;;^UTILITY(U,$J,"PRO",2540,0)
	;;=GMPL OE PROBLEM LIST^Patient Problem List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2540,1,0)
	;;=^^3^3^2930811^
	;;^UTILITY(U,$J,"PRO",2540,1,1,0)
	;;=This action will allow entry to the Problem List application from
	;;^UTILITY(U,$J,"PRO",2540,1,2,0)
	;;=the OE/RR Clinician and Nurse menus.  The variable ORVP is checked
	;;^UTILITY(U,$J,"PRO",2540,1,3,0)
	;;=for the current patient, and then control is passed to the PL.
	;;^UTILITY(U,$J,"PRO",2540,20)
	;;=S DFN=+$G(ORVP) D:DFN DEM^VADPT S:DFN GMPDFN=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID") D EN^GMPL
	;;^UTILITY(U,$J,"PRO",2540,99)
	;;=55908,59624
	;;^UTILITY(U,$J,"PRO",2546,0)
	;;=GMPL OE DATA ENTRY^Patient Problem List^^A^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"PRO",2546,1,0)
	;;=^^3^3^2930811^^
	;;^UTILITY(U,$J,"PRO",2546,1,1,0)
	;;=This action will allow entry to the Problem List application from
	;;^UTILITY(U,$J,"PRO",2546,1,2,0)
	;;=the OE/RR Ward Clerk menu.  The variable ORVP is checked for the
	;;^UTILITY(U,$J,"PRO",2546,1,3,0)
	;;=current patient, and then control is passed to the PL.
	;;^UTILITY(U,$J,"PRO",2546,20)
	;;=S DFN=+$G(ORVP) D:DFN DEM^VADPT S:DFN GMPDFN=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID") D DE^GMPL
	;;^UTILITY(U,$J,"PRO",2546,99)
	;;=55908,59624
	;;^UTILITY(U,$J,"PRO",2554,0)
	;;=GMPL HIDDEN MENU^Problem List Hidden Actions^^M^^^^^^^^PROBLEM LIST
