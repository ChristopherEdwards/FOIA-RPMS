IBINI01W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.6,0,"GL")
	;;=^IBE(350.6,
	;;^DIC("B","IB ARCHIVE/PURGE LOG",350.6)
	;;=
	;;^DIC(350.6,"%D",0)
	;;=^^15^15^2940214^^
	;;^DIC(350.6,"%D",1,0)
	;;=This file will be used to track the archiving and purging operations
	;;^DIC(350.6,"%D",2,0)
	;;=of the following three data files used in billing:
	;;^DIC(350.6,"%D",3,0)
	;;= 
	;;^DIC(350.6,"%D",4,0)
	;;=  #350  INTEGRATED BILLING ACTION
	;;^DIC(350.6,"%D",5,0)
	;;=  #351  CATEGORY C BILLING CLOCK
	;;^DIC(350.6,"%D",6,0)
	;;=  #399  BILL/CLAIMS
	;;^DIC(350.6,"%D",7,0)
	;;= 
	;;^DIC(350.6,"%D",8,0)
	;;=A log entry will be filed when an archival "search" is initiated for
	;;^DIC(350.6,"%D",9,0)
	;;=one of these files.  Once the search end date is logged, archiving
	;;^DIC(350.6,"%D",10,0)
	;;=will be permitted, and subsequently purging will be allowed when the
	;;^DIC(350.6,"%D",11,0)
	;;=archive end date is logged.  The log entry is thus used to assure that
	;;^DIC(350.6,"%D",12,0)
	;;=all the necessary steps for archiving and purging are performed in
	;;^DIC(350.6,"%D",13,0)
	;;=their entirety in the correct order.
	;;^DIC(350.6,"%D",14,0)
	;;= 
	;;^DIC(350.6,"%D",15,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.6,0)
	;;=FIELD^^3.03^14
	;;^DD(350.6,0,"DDA")
	;;=N
	;;^DD(350.6,0,"DT")
	;;=2920408
	;;^DD(350.6,0,"ID",.03)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DIC(+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(1,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(350.6,0,"ID",.05)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(350.6,.05,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,5)_"":"",2),$C(59),1)")
	;;^DD(350.6,0,"ID",1.01)
	;;=W:$D(^(1)) "   ",$E($P(^(1),U,1),4,5)_"-"_$E($P(^(1),U,1),6,7)_"-"_$E($P(^(1),U,1),2,3)
	;;^DD(350.6,0,"IX","AF",350.6,.03)
	;;=
	;;^DD(350.6,0,"IX","AF1",350.6,1.01)
	;;=
	;;^DD(350.6,0,"IX","B",350.6,.01)
	;;=
	;;^DD(350.6,0,"IX","C",350.6,.02)
	;;=
	;;^DD(350.6,0,"IX","D",350.6,.03)
	;;=
	;;^DD(350.6,0,"IX","E",350.6,.05)
	;;=
	;;^DD(350.6,0,"NM","IB ARCHIVE/PURGE LOG")
	;;=
	;;^DD(350.6,.01,0)
	;;=ARCHIVE LOG #^RNJ15,0^^0;1^K:+X'=X!(X>999999999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.6,.01,1,0)
	;;=^.1
	;;^DD(350.6,.01,1,1,0)
	;;=350.6^B
	;;^DD(350.6,.01,1,1,1)
	;;=S ^IBE(350.6,"B",$E(X,1,30),DA)=""
	;;^DD(350.6,.01,1,1,2)
	;;=K ^IBE(350.6,"B",$E(X,1,30),DA)
	;;^DD(350.6,.01,3)
	;;=Type a Number between 1 and 999999999999999, 0 Decimal Digits
	;;^DD(350.6,.01,21,0)
	;;=^^3^3^2920427^^^
	;;^DD(350.6,.01,21,1,0)
	;;=The Log # number is used to identify a unique archive/purge operation
	;;^DD(350.6,.01,21,2,0)
	;;=for a single file.  The number will be equal to the internal entry
	;;^DD(350.6,.01,21,3,0)
	;;=number of the Log entry.
	;;^DD(350.6,.01,"DT")
	;;=2920408
	;;^DD(350.6,.02,0)
	;;=SEARCH TEMPLATE^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>33!($L(X)<6) X
	;;^DD(350.6,.02,1,0)
	;;=^.1
	;;^DD(350.6,.02,1,1,0)
	;;=350.6^C
	;;^DD(350.6,.02,1,1,1)
	;;=S ^IBE(350.6,"C",$E(X,1,30),DA)=""
	;;^DD(350.6,.02,1,1,2)
	;;=K ^IBE(350.6,"C",$E(X,1,30),DA)
	;;^DD(350.6,.02,1,1,"DT")
	;;=2920408
	;;^DD(350.6,.02,3)
	;;=Answer must be 6-33 characters in length.
	;;^DD(350.6,.02,21,0)
	;;=^^7^7^2920427^
	;;^DD(350.6,.02,21,1,0)
	;;=This field contains the name of the Search Template used to contain the
	;;^DD(350.6,.02,21,2,0)
	;;=list of entries to be archived/purged.  This name is the .01 field for
	;;^DD(350.6,.02,21,3,0)
	;;=the template entry in the SORT TEMPLATE file (#.401).  The name of the
	;;^DD(350.6,.02,21,4,0)
	;;=template is stored instead of a hard pointer to the SORT TEMPLATE file
