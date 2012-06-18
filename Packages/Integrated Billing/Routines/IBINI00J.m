IBINI00J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.06,21,0)
	;;=^^6^6^2940209^^^
	;;^DD(36,.06,21,1,0)
	;;=This field determines whether this insurance company will accept multiple
	;;^DD(36,.06,21,2,0)
	;;=bedsections on one claim form.  If answered 'YES' then selection of the
	;;^DD(36,.06,21,3,0)
	;;=PRIMARY INSURANCE CARRIER in MCCR will trigger revenue codes for all
	;;^DD(36,.06,21,4,0)
	;;=bedsections within the STATEMENT COVERS FROM and STATEMENT COVERS TO dates.
	;;^DD(36,.06,21,5,0)
	;;=If this is answered 'NO' or left blank then only the first bedsection in
	;;^DD(36,.06,21,6,0)
	;;=the date range will be used.
	;;^DD(36,.06,"DT")
	;;=2900515
	;;^DD(36,.07,0)
	;;=DIFFERENT REVENUE CODES TO USE^FX^^0;7^K:$L(X)>40!($L(X)<3) X I $D(X) X "F DGII=1:4:$L(X) S DGINX=$E(X,DGII,DGII+3) I $S(DGINX?3N:0,DGINX?3N1"","":0,1:1) K X Q" K DGII,DGINX
	;;^DD(36,.07,3)
	;;=Answer must be 3-40 characters in length.  Enter the 3 digit revenue codes separated by commas to set up for bills with this insurance company.  Answer must be 3 numerics separated by commas.
	;;^DD(36,.07,21,0)
	;;=^^5^5^2900515^^
	;;^DD(36,.07,21,1,0)
	;;=If this field contains revenue codes that have matching entries in the
	;;^DD(36,.07,21,2,0)
	;;=Billing Rates file for the bedsection being billed.  The revenue codes
	;;^DD(36,.07,21,3,0)
	;;=listed in this field, separated by commas, will be automatically set up
	;;^DD(36,.07,21,4,0)
	;;=for this insurance company rather than the standard revenue codes that
	;;^DD(36,.07,21,5,0)
	;;=are Standard Rates set up in the Billing Rates file.
	;;^DD(36,.07,"DT")
	;;=2900703
	;;^DD(36,.08,0)
	;;=ONE OPT. VISIT ON BILL ONLY^S^0:NO;1:YES;^0;8^Q
	;;^DD(36,.08,3)
	;;=Enter whether or not claom form's to this Insurance Company should allow only 1 outpatient visit per bill.
	;;^DD(36,.08,21,0)
	;;=^^4^4^2940209^^^^
	;;^DD(36,.08,21,1,0)
	;;=If this field is answered 'YES' then only one outpatient visit will be
	;;^DD(36,.08,21,2,0)
	;;=allowed per claim form for this Insurance Company.  If it is
	;;^DD(36,.08,21,3,0)
	;;=unanswered or answered 'NO' then multiple (up to 10) outpatient bills will
	;;^DD(36,.08,21,4,0)
	;;=be allowed per claim form.
	;;^DD(36,.08,"DT")
	;;=2900515
	;;^DD(36,.09,0)
	;;=AMBULATORY SURG. REV. CODE^*P399.2'^DGCR(399.2,^0;9^S DIC("S")="I $P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.09,3)
	;;=Enter the default revenue code for ambulatory surgical codes.  This will automatically be used when creating a bill.
	;;^DD(36,.09,12)
	;;=Only Activated Revenue Codes can be selected!
	;;^DD(36,.09,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)"
	;;^DD(36,.09,21,0)
	;;=^^3^3^2940207^^^
	;;^DD(36,.09,21,1,0)
	;;=This is the Revenue Code that will automatically be generated for this
	;;^DD(36,.09,21,2,0)
	;;=insurance company if a billable Ambulatory Surgical Code is listed as
	;;^DD(36,.09,21,3,0)
	;;=a procedure in this this bill.
	;;^DD(36,.09,"DT")
	;;=2911120
	;;^DD(36,.1,0)
	;;=ATTENDING PHYSICIAN ID.^F^^0;10^K:$L(X)>22!($L(X)<3) X
	;;^DD(36,.1,3)
	;;=Answer must be 3-22 characters in length.
	;;^DD(36,.1,21,0)
	;;=^^5^5^2940209^^^^
	;;^DD(36,.1,21,1,0)
	;;=Enter in this field the Attending Physician ID (UPIN) number.  Currently
	;;^DD(36,.1,21,2,0)
	;;=several insurance companies require a UPIN of VAD000.  If the entry for
	;;^DD(36,.1,21,3,0)
	;;=this insurance company is completed, this field will print on the UB-82
	;;^DD(36,.1,21,4,0)
	;;=in form locator 92 and in form locator 82 of the UB-92 for all bills 
	;;^DD(36,.1,21,5,0)
	;;=where this insurance company is the primary insurer.
