IBINI082	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.6,0,"GL")
	;;=^IBE(357.6,
	;;^DIC("B","PACKAGE INTERFACE",357.6)
	;;=
	;;^DIC(357.6,"%D",0)
	;;=^^22^22^2940121^
	;;^DIC(357.6,"%D",1,0)
	;;=This file contains a description of all of the interfaces with other packages.
	;;^DIC(357.6,"%D",2,0)
	;;=The form will invoke the proper interface routines by doing a lookup on
	;;^DIC(357.6,"%D",3,0)
	;;=this file and then calling the routine by indirection. The
	;;^DIC(357.6,"%D",4,0)
	;;=Data will be exchanged between the encounter form utilities and other
	;;^DIC(357.6,"%D",5,0)
	;;=packages by putting the data in a predefined location. The first part of
	;;^DIC(357.6,"%D",6,0)
	;;=the subscript is always ^TMP("IB",$J,"INTERFACES". For output routines,
	;;^DIC(357.6,"%D",7,0)
	;;=but not selection routines, the fourth subscript is be the patient DFN.
	;;^DIC(357.6,"%D",8,0)
	;;=The next subscript is the name of the Package Interface. For single valued
	;;^DIC(357.6,"%D",9,0)
	;;=data and record valued data there is no additional subscript. For
	;;^DIC(357.6,"%D",10,0)
	;;=interfaces returning a list there is one additional subscript level, the
	;;^DIC(357.6,"%D",11,0)
	;;=number of the item on the list. For word processing type data the data
	;;^DIC(357.6,"%D",12,0)
	;;=will be in FM word-processing format, i.e., the final subscripts will be
	;;^DIC(357.6,"%D",13,0)
	;;=...1,0),...2,0),...3,0), etc.
	;;^DIC(357.6,"%D",14,0)
	;;= 
	;;^DIC(357.6,"%D",15,0)
	;;=Note that multiple entries in this file can have the same entry points
	;;^DIC(357.6,"%D",16,0)
	;;=into routines. This is for efficiency purposes. For example, patient name,
	;;^DIC(357.6,"%D",17,0)
	;;=DOB and sex are all located on the same node of the Patient file. Each of
	;;^DIC(357.6,"%D",18,0)
	;;=these items of data can have its own entry in the Package Interface file,
	;;^DIC(357.6,"%D",19,0)
	;;=but by using the same entry point there is a savings because all of the
	;;^DIC(357.6,"%D",20,0)
	;;=data on that node can be obtained at once. The routine that invokes the
	;;^DIC(357.6,"%D",21,0)
	;;=entry points keeps track of those already invoked so that they are not
	;;^DIC(357.6,"%D",22,0)
	;;=repeated.
	;;^DD(357.6,0)
	;;=FIELD^^8.07^41
	;;^DD(357.6,0,"ACT")
	;;=D ASK^IBDFU9
	;;^DD(357.6,0,"DDA")
	;;=N
	;;^DD(357.6,0,"DT")
	;;=2931014
	;;^DD(357.6,0,"ID","WRITE")
	;;=W ?45,"Package=",$P($G(^(0)),"^",4)
	;;^DD(357.6,0,"IX","B",357.6,.01)
	;;=
	;;^DD(357.6,0,"IX","C",357.6,.04)
	;;=
	;;^DD(357.6,0,"IX","D",357.6,3)
	;;=
	;;^DD(357.6,0,"IX","E",357.6,.01)
	;;=
	;;^DD(357.6,0,"NM","PACKAGE INTERFACE")
	;;=
	;;^DD(357.6,0,"PT",357.2,.11)
	;;=
	;;^DD(357.6,0,"PT",357.5,.03)
	;;=
	;;^DD(357.6,0,"PT",409.9501,.01)
	;;=
	;;^DD(357.6,0,"PT",409.9502,.01)
	;;=
	;;^DD(357.6,0,"PT",409.961,.01)
	;;=
	;;^DD(357.6,.01,0)
	;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
	;;^DD(357.6,.01,1,0)
	;;=^.1
	;;^DD(357.6,.01,1,1,0)
	;;=357.6^B
	;;^DD(357.6,.01,1,1,1)
	;;=S ^IBE(357.6,"B",$E(X,1,30),DA)=""
	;;^DD(357.6,.01,1,1,2)
	;;=K ^IBE(357.6,"B",$E(X,1,30),DA)
	;;^DD(357.6,.01,1,2,0)
	;;=357.6^E^MUMPS
	;;^DD(357.6,.01,1,2,1)
	;;=S ^IBE(357.6,"E",$E(X,$F(X," "),40),DA)=""
	;;^DD(357.6,.01,1,2,2)
	;;=K ^IBE(357.6,"E",$E(X,$F(X," "),40),DA)
	;;^DD(357.6,.01,1,2,"%D",0)
	;;=^^4^4^2940224^
	;;^DD(357.6,.01,1,2,"%D",1,0)
	;;= 
	;;^DD(357.6,.01,1,2,"%D",2,0)
	;;=For package interfaces that are output routines the name has the custodial
	;;^DD(357.6,.01,1,2,"%D",3,0)
	;;=package's name space as a prefix. This cross-reference removes that
	;;^DD(357.6,.01,1,2,"%D",4,0)
	;;=prefix. It is used to improve the display of output routines for the user.
