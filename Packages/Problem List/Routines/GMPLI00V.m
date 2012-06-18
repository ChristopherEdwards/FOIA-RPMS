GMPLI00V	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",7340,31)
	;;=
	;;^UTILITY(U,$J,"OPT",7340,50)
	;;=
	;;^UTILITY(U,$J,"OPT",7340,51)
	;;=
	;;^UTILITY(U,$J,"OPT",7340,99)
	;;=55677,50942
	;;^UTILITY(U,$J,"OPT",7340,99.1)
	;;=55727,32519
	;;^UTILITY(U,$J,"OPT",7340,"U")
	;;=EDIT PL SITE PARAMETERS
	;;^UTILITY(U,$J,"OPT",7350,0)
	;;=GMPL USER VIEW^Problem List Preferred View^^R^^^^^^^^PROBLEM LIST^^
	;;^UTILITY(U,$J,"OPT",7350,1,0)
	;;=^^7^7^2940126^^^
	;;^UTILITY(U,$J,"OPT",7350,1,1,0)
	;;=This option allows an individual user to define his/her own default
	;;^UTILITY(U,$J,"OPT",7350,1,2,0)
	;;=view of patient problem lists.  Rather than displaying all active
	;;^UTILITY(U,$J,"OPT",7350,1,3,0)
	;;=problems for a patient, the application will show active problems
	;;^UTILITY(U,$J,"OPT",7350,1,4,0)
	;;=associated with only selected servicesor clinics, as defined here.
	;;^UTILITY(U,$J,"OPT",7350,1,5,0)
	;;=A user may choose to see a different view of the problem list from
	;;^UTILITY(U,$J,"OPT",7350,1,6,0)
	;;=within the application by selecting the "Change View" action,
	;;^UTILITY(U,$J,"OPT",7350,1,7,0)
	;;=including all problems.
	;;^UTILITY(U,$J,"OPT",7350,20)
	;;=
	;;^UTILITY(U,$J,"OPT",7350,25)
	;;=EN^GMPLPREF
	;;^UTILITY(U,$J,"OPT",7350,99)
	;;=55894,52855
	;;^UTILITY(U,$J,"OPT",7350,"U")
	;;=PROBLEM LIST PREFERRED VIEW
	;;^UTILITY(U,$J,"OPT",7351,0)
	;;=GMPL USER SCREEN^Problem Look-up Defaults^^R^^^^^^^^PROBLEM LIST^^1^1
	;;^UTILITY(U,$J,"OPT",7351,1,0)
	;;=^^4^4^2930723^^^
	;;^UTILITY(U,$J,"OPT",7351,1,1,0)
	;;=This option allows an individual user to define his/her own default
	;;^UTILITY(U,$J,"OPT",7351,1,2,0)
	;;=screens for use when looking up a problem in the Clinical Lexicon
	;;^UTILITY(U,$J,"OPT",7351,1,3,0)
	;;=for the Problem List application.  Specific kinds of terms may be
	;;^UTILITY(U,$J,"OPT",7351,1,4,0)
	;;=included or excluded from the search, if defined here.
	;;^UTILITY(U,$J,"OPT",7351,15)
	;;=K GMPTAP
	;;^UTILITY(U,$J,"OPT",7351,20)
	;;=S GMPTAP="GMPL"
	;;^UTILITY(U,$J,"OPT",7351,25)
	;;=GMPTDUSR
	;;^UTILITY(U,$J,"OPT",7351,99.1)
	;;=55727,32519
	;;^UTILITY(U,$J,"OPT",7351,"U")
	;;=PROBLEM LOOK-UP DEFAULTS
	;;^UTILITY(U,$J,"OPT",7352,0)
	;;=GMPL USER PREFS MENU^Problem List User Preferences Menu^^M^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7352,1,0)
	;;=^^2^2^2930811^
	;;^UTILITY(U,$J,"OPT",7352,1,1,0)
	;;=This menu contains defaults each user can define for him/herself,
	;;^UTILITY(U,$J,"OPT",7352,1,2,0)
	;;=controlling the behaviour of the Problem List application.
	;;^UTILITY(U,$J,"OPT",7352,10,0)
	;;=^19.01PI^3^3
	;;^UTILITY(U,$J,"OPT",7352,10,1,0)
	;;=7350^1^1
	;;^UTILITY(U,$J,"OPT",7352,10,1,"^")
	;;=GMPL USER VIEW
	;;^UTILITY(U,$J,"OPT",7352,10,2,0)
	;;=7351^2^2
	;;^UTILITY(U,$J,"OPT",7352,10,2,"^")
	;;=GMPL USER SCREEN
	;;^UTILITY(U,$J,"OPT",7352,10,3,0)
	;;=7523^3^3
	;;^UTILITY(U,$J,"OPT",7352,10,3,"^")
	;;=GMPL USER LIST
	;;^UTILITY(U,$J,"OPT",7352,99)
	;;=55984,32309
	;;^UTILITY(U,$J,"OPT",7352,99.1)
	;;=55741,26413
	;;^UTILITY(U,$J,"OPT",7352,"U")
	;;=PROBLEM LIST USER PREFERENCES 
	;;^UTILITY(U,$J,"OPT",7483,0)
	;;=GMPL PATIENT LISTING^List Patients with Problem List data^^R^^^^^^^^PROBLEM LIST
	;;^UTILITY(U,$J,"OPT",7483,1,0)
	;;=^^2^2^2930824^^
	;;^UTILITY(U,$J,"OPT",7483,1,1,0)
	;;=This option will generate a listing of all patients having data
	;;^UTILITY(U,$J,"OPT",7483,1,2,0)
	;;=in the Problem file #9000011.
	;;^UTILITY(U,$J,"OPT",7483,25)
	;;=PAT^GMPLRPTS
	;;^UTILITY(U,$J,"OPT",7483,"U")
	;;=LIST PATIENTS WITH PROBLEM LIS
	;;^UTILITY(U,$J,"OPT",7484,0)
	;;=GMPL PROBLEM LISTING^Search for Patients having selected Problem^^R^^^^^^^^PROBLEM LIST
