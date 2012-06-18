IBINI00I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(36,0,"GL")
	;;=^DIC(36,
	;;^DIC("B","INSURANCE COMPANY",36)
	;;=
	;;^DIC(36,"%D",0)
	;;=^^6^6^2940307^^^^
	;;^DIC(36,"%D",1,0)
	;;=This file contains the names and addresses of insurance companies as needed
	;;^DIC(36,"%D",2,0)
	;;=by the local facility.  The data in this file is NOT EDITABLE USING VA
	;;^DIC(36,"%D",3,0)
	;;=FILEMANAGER.  If a new entry needs to be made or an existing entry
	;;^DIC(36,"%D",4,0)
	;;=changed the user must be assigned the appropriate MAS or IB module option.
	;;^DIC(36,"%D",5,0)
	;;= 
	;;^DIC(36,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(36,0)
	;;=FIELD^^.16^82
	;;^DD(36,0,"DDA")
	;;=N
	;;^DD(36,0,"DT")
	;;=2940228
	;;^DD(36,0,"ID",.111)
	;;=W:$D(^(.11)) "   ",$P(^(.11),U,1)
	;;^DD(36,0,"ID",.112)
	;;=W ""
	;;^DD(36,0,"ID",.113)
	;;=W ""
	;;^DD(36,0,"ID",.114)
	;;=W:$D(^(.11)) "   ",$P(^(.11),U,4)
	;;^DD(36,0,"ID",.115)
	;;=S %I=Y,Y=$S('$D(^(.11)):"",$D(^DIC(5,+$P(^(.11),U,5),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(5,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(36,0,"ID",.116)
	;;=W ""
	;;^DD(36,0,"ID",1)
	;;=W:$D(^("0")) "   ",$P(^("0"),U,2)
	;;^DD(36,0,"IX","B",36,.01)
	;;=
	;;^DD(36,0,"IX","C",36.03,.01)
	;;=
	;;^DD(36,0,"NM","INSURANCE COMPANY")
	;;=
	;;^DD(36,0,"PT",2.101,25)
	;;=
	;;^DD(36,0,"PT",2.312,.01)
	;;=
	;;^DD(36,0,"PT",36,.127)
	;;=
	;;^DD(36,0,"PT",36,.139)
	;;=
	;;^DD(36,0,"PT",36,.147)
	;;=
	;;^DD(36,0,"PT",36,.157)
	;;=
	;;^DD(36,0,"PT",36,.16)
	;;=
	;;^DD(36,0,"PT",36,.167)
	;;=
	;;^DD(36,0,"PT",36,.187)
	;;=
	;;^DD(36,0,"PT",36.02,6)
	;;=
	;;^DD(36,0,"PT",350.9,4.02)
	;;=
	;;^DD(36,0,"PT",350.9,4.06)
	;;=
	;;^DD(36,0,"PT",355.3,.01)
	;;=
	;;^DD(36,0,"PT",356.2,.08)
	;;=
	;;^DD(36,0,"PT",399,101)
	;;=
	;;^DD(36,0,"PT",399,102)
	;;=
	;;^DD(36,0,"PT",399,103)
	;;=
	;;^DD(36,0,"PT",412,.01)
	;;=
	;;^DD(36,0,"PT",430,19)
	;;=
	;;^DD(36,0,"PT",430,19.1)
	;;=
	;;^DD(36,0,"PT",513.85,11)
	;;=
	;;^DD(36,0,"PT",500015.01,.01)
	;;=
	;;^DD(36,.01,0)
	;;=NAME^RFX^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(36,.01,.1)
	;;=INSURANCE COMPANY FILE
	;;^DD(36,.01,1,0)
	;;=^.1
	;;^DD(36,.01,1,1,0)
	;;=36^B
	;;^DD(36,.01,1,1,1)
	;;=S ^DIC(36,"B",$E(X,1,30),DA)=""
	;;^DD(36,.01,1,1,2)
	;;=K ^DIC(36,"B",$E(X,1,30),DA)
	;;^DD(36,.01,3)
	;;=ANSWER MUST BE 3-30 CHARACTERS IN LENGTH
	;;^DD(36,.01,21,0)
	;;=^^5^5^2940209^^^
	;;^DD(36,.01,21,1,0)
	;;=Enter the name of the insurance carrier which at least one patient seen
	;;^DD(36,.01,21,2,0)
	;;=at your facility has.  This information must be updated using the 'Insurance
	;;^DD(36,.01,21,3,0)
	;;=Company Entry/Edit' option, NOT using VA FileMan.  Editing of this data
	;;^DD(36,.01,21,4,0)
	;;=through a filemanager option could cause negative impacts on the MAS and
	;;^DD(36,.01,21,5,0)
	;;=IB software modules in addition to other DHCP modules.
	;;^DD(36,.01,"DEL",1,0)
	;;=I '$D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ))!($O(^IBA(355.3,"B",DA,0))) W !!,"Deletion not allowed"
	;;^DD(36,.01,"DT")
	;;=2930226
	;;^DD(36,.05,0)
	;;=INACTIVE^SX^0:NO;1:YES;^0;5^Q
	;;^DD(36,.05,3)
	;;=ENTER 'YES' IF THIS COMPANY IS INACTIVE AND SHOULD NO LONGER BE ALLOWED FOR SELECTION.
	;;^DD(36,.05,21,0)
	;;=^^2^2^2911222^
	;;^DD(36,.05,21,1,0)
	;;=If this insurance company is no longer active in your area, enter INACTIVE
	;;^DD(36,.05,21,2,0)
	;;=here.  This will disallow users from selecting this insurance company entry.
	;;^DD(36,.05,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.05,"DT")
	;;=2930312
	;;^DD(36,.06,0)
	;;=ALLOW MULTIPLE BEDSECTIONS^S^0:NO;1:YES;^0;6^Q
	;;^DD(36,.06,3)
	;;=Enter whether or not this Insurance Company will accept multiple bedsections on a claim form.  If left blank a NO is assumed.
