GMPLI011	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PKG",219,4,15,0)
	;;=125.11
	;;^UTILITY(U,$J,"PKG",219,4,15,222)
	;;=y^y^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,16,0)
	;;=125.12
	;;^UTILITY(U,$J,"PKG",219,4,16,222)
	;;=y^y^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,"B",49,7)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125,13)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125.1,14)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125.11,15)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125.12,16)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125.8,3)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",125.99,6)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",200,8)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,"B",9000011,4)
	;;=
	;;^UTILITY(U,$J,"PKG",219,5)
	;;=SLC
	;;^UTILITY(U,$J,"PKG",219,7)
	;;=SLC^^I
	;;^UTILITY(U,$J,"PKG",219,9)
	;;=528
	;;^UTILITY(U,$J,"PKG",219,11)
	;;=125^9000011
	;;^UTILITY(U,$J,"PKG",219,22,0)
	;;=^9.49I^14^14
	;;^UTILITY(U,$J,"PKG",219,22,1,0)
	;;=1.0D1^2930413^2921104
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",0)
	;;=^^15^15^2930413^^^
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",1,0)
	;;=To install this package, first D ^GMPJINIT in programmer mode at the
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",2,0)
	;;=prompt; this will set-up the file DD's for the Clinical Term file.
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",3,0)
	;;=The post-init of this segment of the package will also install the
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",4,0)
	;;=Multi-Term Lookup Utility, which is used to facilitate the search
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",5,0)
	;;=for entries in the CT file; you must follow the instructions given
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",6,0)
	;;=for the MTLU to define the CT (#758) as an accessible file.
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",7,0)
	;;=   
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",8,0)
	;;=Second, D ^GMPINIT from the programmer prompt to install the Problem
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",9,0)
	;;=List application.  The post-init of this segment of the package will
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",10,0)
	;;=also install the protocols and list templates required by this
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",11,0)
	;;=application.  If the List Manager utility is not present, it will
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",12,0)
	;;=also be installed at this time.
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",13,0)
	;;=   
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",14,0)
	;;=You must also load the data to populate the Clinical Term file from
	;;^UTILITY(U,$J,"PKG",219,22,1,"I",15,0)
	;;=a separate VMS file containing the GMP global.
	;;^UTILITY(U,$J,"PKG",219,22,2,0)
	;;=1.0D2^2930528
	;;^UTILITY(U,$J,"PKG",219,22,3,0)
	;;=1.0T1^2930611^2930621
	;;^UTILITY(U,$J,"PKG",219,22,4,0)
	;;=1.0T2^2930708
	;;^UTILITY(U,$J,"PKG",219,22,5,0)
	;;=1.0T3^2930714
	;;^UTILITY(U,$J,"PKG",219,22,6,0)
	;;=1.0T4^2930826^2930831
	;;^UTILITY(U,$J,"PKG",219,22,7,0)
	;;=2.0T1^2930910
	;;^UTILITY(U,$J,"PKG",219,22,8,0)
	;;=2.0T3^2931013
	;;^UTILITY(U,$J,"PKG",219,22,9,0)
	;;=2.0T4^2931129
	;;^UTILITY(U,$J,"PKG",219,22,10,0)
	;;=2.0T5^2931215
	;;^UTILITY(U,$J,"PKG",219,22,11,0)
	;;=2.0V1^2940208^2940126
	;;^UTILITY(U,$J,"PKG",219,22,12,0)
	;;=2.0V2^2940418
	;;^UTILITY(U,$J,"PKG",219,22,13,0)
	;;=2.0V3^2940606
	;;^UTILITY(U,$J,"PKG",219,22,14,0)
	;;=2.0^2940825
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0D1",1)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0D2",2)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0T1",3)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0T2",4)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0T3",5)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","1.0T4",6)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","2.0",14)
	;;=
	;;^UTILITY(U,$J,"PKG",219,22,"B","2.0T1",7)
	;;=
