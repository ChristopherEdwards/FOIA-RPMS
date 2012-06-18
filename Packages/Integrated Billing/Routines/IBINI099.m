IBINI099	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.6,0,"GL")
	;;=^IBE(358.6,
	;;^DIC("B","IMP/EXP PACKAGE INTERFACE",358.6)
	;;=
	;;^DIC(358.6,"%D",0)
	;;=^^18^18^2940217^
	;;^DIC(358.6,"%D",1,0)
	;;=This file is nearly identical to file #357.6. It is used by the
	;;^DIC(358.6,"%D",2,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.6,"%D",3,0)
	;;=that is being imported or exported.
	;;^DIC(358.6,"%D",4,0)
	;;= 
	;;^DIC(358.6,"%D",5,0)
	;;=This file contains a description of all of the interfaces with other packages.
	;;^DIC(358.6,"%D",6,0)
	;;=The form will invoke the proper interface routines by doing a lookup on
	;;^DIC(358.6,"%D",7,0)
	;;=this file and then invoking the routine by indirection. The INPUT VARIABLE
	;;^DIC(358.6,"%D",8,0)
	;;=fields are for documentation purposes and to verify that the proper
	;;^DIC(358.6,"%D",9,0)
	;;=variables are defined. Data will be exchanged between the encounter form
	;;^DIC(358.6,"%D",10,0)
	;;=utilities and other packages by putting the data in a predefined location.
	;;^DIC(358.6,"%D",11,0)
	;;=The first part of the subscript is always be ^TMP("IB",$J,"INTERFACES".
	;;^DIC(358.6,"%D",12,0)
	;;=For output routines, but not selection routines, the fourth subscript is
	;;^DIC(358.6,"%D",13,0)
	;;=be the patient DFN. The next subscript is the name of the Package
	;;^DIC(358.6,"%D",14,0)
	;;=Interface. For single valued data and record valued data there is no
	;;^DIC(358.6,"%D",15,0)
	;;=additional subscript. For interfaces returning a list there is one
	;;^DIC(358.6,"%D",16,0)
	;;=additional subscript level, the number of the item on the list. For
	;;^DIC(358.6,"%D",17,0)
	;;=word processing type data the data will be in FM word-processing format,
	;;^DIC(358.6,"%D",18,0)
	;;=i.e., the final subscripts will be ...1,0),...2,0),...3,0), etc.
	;;^DD(358.6,0)
	;;=FIELD^^8.07^41
	;;^DD(358.6,0,"DT")
	;;=2931203
	;;^DD(358.6,0,"ID","WRITE")
	;;=W "Package=",$P($G(^(0)),"^",4)
	;;^DD(358.6,0,"IX","B",358.6,.01)
	;;=
	;;^DD(358.6,0,"IX","C",358.6,.04)
	;;=
	;;^DD(358.6,0,"IX","D",358.6,3)
	;;=
	;;^DD(358.6,0,"IX","E",358.6,.01)
	;;=
	;;^DD(358.6,0,"NM","IMP/EXP PACKAGE INTERFACE")
	;;=
	;;^DD(358.6,0,"PT",358.2,.11)
	;;=
	;;^DD(358.6,0,"PT",358.5,.03)
	;;=
	;;^DD(358.6,.01,0)
	;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.6,.01,1,0)
	;;=^.1
	;;^DD(358.6,.01,1,1,0)
	;;=358.6^B
	;;^DD(358.6,.01,1,1,1)
	;;=S ^IBE(358.6,"B",$E(X,1,30),DA)=""
	;;^DD(358.6,.01,1,1,2)
	;;=K ^IBE(358.6,"B",$E(X,1,30),DA)
	;;^DD(358.6,.01,1,2,0)
	;;=358.6^E^MUMPS
	;;^DD(358.6,.01,1,2,1)
	;;=S ^IBE(358.6,"E",$E(X,$F(X," "),40),DA)=""
	;;^DD(358.6,.01,1,2,2)
	;;=K ^IBE(358.6,"E",$E(X,$F(X," "),40),DA)
	;;^DD(358.6,.01,1,2,"DT")
	;;=2930409
	;;^DD(358.6,.01,3)
	;;=Answer must be 3-40 characters in length. All entries with Action Type other than PRINT REPORT must be be prefixed with the name space of the package that is responsible for the data.
	;;^DD(358.6,.01,21,0)
	;;=^^3^3^2930727^^
	;;^DD(358.6,.01,21,1,0)
	;;= 
	;;^DD(358.6,.01,21,2,0)
	;;=The name of the Package Interface. For interfaces returning data the name
	;;^DD(358.6,.01,21,3,0)
	;;=should be preceded with the name space of the package.
	;;^DD(358.6,.01,"DT")
	;;=2930409
	;;^DD(358.6,.02,0)
	;;=ENTRY POINT^RF^^0;2^K:$L(X)>8!($L(X)<1) X
	;;^DD(358.6,.02,3)
	;;=What entry point into the routine does this package interface use?
	;;^DD(358.6,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.6,.02,21,1,0)
	;;= 
	;;^DD(358.6,.02,21,2,0)
	;;=The entry point in the routine that should be called.
