IBINI02S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,4.05,3)
	;;=Answer must be 3-45 characters in length.
	;;^DD(350.9,4.05,21,0)
	;;=^^10^10^2930903^
	;;^DD(350.9,4.05,21,1,0)
	;;=The MCCR Program Office has recently requested that the results from
	;;^DD(350.9,4.05,21,2,0)
	;;=the report Rank Insurance Carriers By Amount Billed be transmitted
	;;^DD(350.9,4.05,21,3,0)
	;;=centrally for nation-wide compilation.  This field contains the
	;;^DD(350.9,4.05,21,4,0)
	;;=mail group on Forum to which these reports will be sent.
	;;^DD(350.9,4.05,21,5,0)
	;;= 
	;;^DD(350.9,4.05,21,6,0)
	;;=The field is being exported with the value G.MCCR DATA@DOMAIN.NAME.
	;;^DD(350.9,4.05,21,7,0)
	;;=It is anticipated that future reports may be sent to this group for
	;;^DD(350.9,4.05,21,8,0)
	;;=compilation.  If it becomes necessary to change the mail group name
	;;^DD(350.9,4.05,21,9,0)
	;;=or domain, this field may be edited using Fileman.  Do not edit this
	;;^DD(350.9,4.05,21,10,0)
	;;=field without receiving instructions from your supporting ISC.
	;;^DD(350.9,4.05,"DT")
	;;=2930903
	;;^DD(350.9,4.06,0)
	;;=INSURANCE COMPANY^*P36'^DIC(36,^4;6^S DIC("S")="I '$P(^(0),U,5)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.9,4.06,12)
	;;=Only Active Companies may be selected!
	;;^DD(350.9,4.06,12.1)
	;;=S DIC("S")="I '$P(^(0),U,5)"
	;;^DD(350.9,4.06,"DT")
	;;=2940119
	;;^DD(350.9,5.01,0)
	;;=ADMISSION SHEET HEADER LINE 1^F^^5;1^K:$L(X)>50!($L(X)<3) X
	;;^DD(350.9,5.01,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(350.9,5.01,21,0)
	;;=^^3^3^2930826^
	;;^DD(350.9,5.01,21,1,0)
	;;=Enter the text that your facility would like to have printed as the
	;;^DD(350.9,5.01,21,2,0)
	;;=first line of the header on the admission sheet.  This is generally
	;;^DD(350.9,5.01,21,3,0)
	;;=the name of your medical center.
	;;^DD(350.9,5.01,"DT")
	;;=2930826
	;;^DD(350.9,5.02,0)
	;;=ADMISSION SHEET HEADER LINE 2^F^^5;2^K:$L(X)>50!($L(X)<3) X
	;;^DD(350.9,5.02,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(350.9,5.02,21,0)
	;;=^^3^3^2930826^
	;;^DD(350.9,5.02,21,1,0)
	;;=Enter the text that your facility would like to have printed as the
	;;^DD(350.9,5.02,21,2,0)
	;;=second line of the header on the admission sheet.  This is generally
	;;^DD(350.9,5.02,21,3,0)
	;;=the street address of your medical center.
	;;^DD(350.9,5.02,"DT")
	;;=2930826
	;;^DD(350.9,5.03,0)
	;;=ADMISSION SHEET HEADER LINE 3^F^^5;3^K:$L(X)>50!($L(X)<3) X
	;;^DD(350.9,5.03,3)
	;;=Answer must be 3-50 characters in length.
	;;^DD(350.9,5.03,21,0)
	;;=^^3^3^2930826^
	;;^DD(350.9,5.03,21,1,0)
	;;=Enter the text that your facility would like to have printed as the
	;;^DD(350.9,5.03,21,2,0)
	;;=third line of the header on the admission sheet.  This is generally
	;;^DD(350.9,5.03,21,3,0)
	;;=the city, state and zip code of your medical center.
	;;^DD(350.9,5.03,"DT")
	;;=2930826
	;;^DD(350.9,6.01,0)
	;;=CLAIMS TRACKING START DATE^D^^6;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,6.01,21,0)
	;;=^^9^9^2940209^^^
	;;^DD(350.9,6.01,21,1,0)
	;;=If you choose to run the claims tracking module and populate the files
	;;^DD(350.9,6.01,21,2,0)
	;;=with past episodes of care, this is the date that the routine will use
	;;^DD(350.9,6.01,21,3,0)
	;;=to start.
	;;^DD(350.9,6.01,21,4,0)
	;;= 
	;;^DD(350.9,6.01,21,5,0)
	;;=This is the main parameter that contro what past care can be entered
	;;^DD(350.9,6.01,21,6,0)
	;;=into claims tracking.  At no time does the software automatically add
	;;^DD(350.9,6.01,21,7,0)
	;;=entires older than this date.  The one exception is that this parameter
