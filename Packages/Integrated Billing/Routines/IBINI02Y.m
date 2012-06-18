IBINI02Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(351,0,"GL")
	;;=^IBE(351,
	;;^DIC("B","CATEGORY C BILLING CLOCK",351)
	;;=
	;;^DIC(351,"%D",0)
	;;=^^16^16^2940214^^^^
	;;^DIC(351,"%D",1,0)
	;;=DO NOT delete entries in this file.  DO NOT edit data in this file
	;;^DIC(351,"%D",2,0)
	;;=with VA File Manager.
	;;^DIC(351,"%D",3,0)
	;;= 
	;;^DIC(351,"%D",4,0)
	;;=This file was introduced with v1.5 of Integrated Billing in
	;;^DIC(351,"%D",5,0)
	;;=conjunction with the automation of bills for Means Test/Category C
	;;^DIC(351,"%D",6,0)
	;;=charges.  The file is used to create and maintain billing clocks in
	;;^DIC(351,"%D",7,0)
	;;=which Category C patients may be charged co-payment and per diem
	;;^DIC(351,"%D",8,0)
	;;=charges for Hospital or Nursing Home Care, as well as outpatient
	;;^DIC(351,"%D",9,0)
	;;=visits.  This file was initially populated by the Means Test data
	;;^DIC(351,"%D",10,0)
	;;=conversion that took place when v1.5 was installed.  Entries are
	;;^DIC(351,"%D",11,0)
	;;=subsequently updated and created by Integrated Billing.
	;;^DIC(351,"%D",12,0)
	;;= 
	;;^DIC(351,"%D",13,0)
	;;=Entries in this file should not be deleted.  Billing clocks which
	;;^DIC(351,"%D",14,0)
	;;=are not correct will be cancelled, and new clocks may be added.
	;;^DIC(351,"%D",15,0)
	;;= 
	;;^DIC(351,"%D",16,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(351,0)
	;;=FIELD^^15^15
	;;^DD(351,0,"DDA")
	;;=N
	;;^DD(351,0,"DT")
	;;=2920225
	;;^DD(351,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DPT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(2,.01,0),U,2) D Y^DIQ:Y]"" W ?16,$E(Y,1,25),@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(351,0,"ID",.03)
	;;=W ?44,$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)
	;;^DD(351,0,"ID",.04)
	;;=W ?55,@("$P($P($C(59)_$S($D(^DD(351,.04,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,4)_"":"",2),$C(59),1)")
	;;^DD(351,0,"IX","ACT",351,.02)
	;;=
	;;^DD(351,0,"IX","ACT1",351,.04)
	;;=
	;;^DD(351,0,"IX","AIVDT",351,.02)
	;;=
	;;^DD(351,0,"IX","AIVDT1",351,.03)
	;;=
	;;^DD(351,0,"IX","B",351,.01)
	;;=
	;;^DD(351,0,"IX","C",351,.02)
	;;=
	;;^DD(351,0,"NM","CATEGORY C BILLING CLOCK")
	;;=
	;;^DD(351,.01,0)
	;;=REFERENCE NUMBER^RNJ12,0^^0;1^K:+X'=X!(X>999999999999)!(X<1000)!(X?.E1"."1N.N) X
	;;^DD(351,.01,1,0)
	;;=^.1^^-1
	;;^DD(351,.01,1,1,0)
	;;=351^B
	;;^DD(351,.01,1,1,1)
	;;=S ^IBE(351,"B",$E(X,1,30),DA)=""
	;;^DD(351,.01,1,1,2)
	;;=K ^IBE(351,"B",$E(X,1,30),DA)
	;;^DD(351,.01,3)
	;;=Type a Number between 1000 and 999999999999, 0 Decimal Digits
	;;^DD(351,.01,21,0)
	;;=^^3^3^2911226^^^
	;;^DD(351,.01,21,1,0)
	;;=This field consists of the station number concatenated with the internal
	;;^DD(351,.01,21,2,0)
	;;=number of the entry.  The purpose of this number is to provide a unique
	;;^DD(351,.01,21,3,0)
	;;=reference for each billing clock which has been opened at each station.
	;;^DD(351,.01,"DT")
	;;=2911010
	;;^DD(351,.02,0)
	;;=PATIENT^RP2'^DPT(^0;2^Q
	;;^DD(351,.02,1,0)
	;;=^.1
	;;^DD(351,.02,1,1,0)
	;;=351^AIVDT^MUMPS
	;;^DD(351,.02,1,1,1)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",3) S ^IBE(351,"AIVDT",X,-$P(^(0),"^",3),DA)=""
	;;^DD(351,.02,1,1,2)
	;;=I $D(^IBE(351,DA,0)),$P(^(0),"^",3) K ^IBE(351,"AIVDT",X,-$P(^(0),"^",3),DA)
	;;^DD(351,.02,1,1,"%D",0)
	;;=^^5^5^2920415^^^^
	;;^DD(351,.02,1,1,"%D",1,0)
	;;=Cross-reference of all IB MT BILLING CYCLE entries by the patient (#.02)
	;;^DD(351,.02,1,1,"%D",2,0)
	;;=field and the minus (negative or inverse) cycle date (#.03) field.  The
	;;^DD(351,.02,1,1,"%D",3,0)
	;;=most current billing cycle for a patient may be found using this cross-
