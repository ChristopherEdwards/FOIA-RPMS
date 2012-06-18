FHINI0N1	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.9,0,"GL")
	;;=^FH(119.9,
	;;^DIC("B","FH SITE PARAMETERS",119.9)
	;;=
	;;^DIC(119.9,"%D",0)
	;;=^^5^5^2880717^^
	;;^DIC(119.9,"%D",1,0)
	;;=This file contains an extensive set of site parameters designed
	;;^DIC(119.9,"%D",2,0)
	;;=to indicate common time periods, such as early and late tray
	;;^DIC(119.9,"%D",3,0)
	;;=delivery times, as well as characteristics of the Dietetic
	;;^DIC(119.9,"%D",4,0)
	;;=Service and/or different methods by which the Service wishes
	;;^DIC(119.9,"%D",5,0)
	;;=the program to perform.
	;;^DD(119.9,0)
	;;=FIELD^^100^10
	;;^DD(119.9,0,"DT")
	;;=2941027
	;;^DD(119.9,0,"IX","B",119.9,.01)
	;;=
	;;^DD(119.9,0,"NM","FH SITE PARAMETERS")
	;;=
	;;^DD(119.9,.01,0)
	;;=SITE^RNJ1,0X^^0;1^K:+X'=X!(X>1)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(119.9,.01,1,0)
	;;=^.1
	;;^DD(119.9,.01,1,1,0)
	;;=119.9^B
	;;^DD(119.9,.01,1,1,1)
	;;=S ^FH(119.9,"B",$E(X,1,30),DA)=""
	;;^DD(119.9,.01,1,1,2)
	;;=K ^FH(119.9,"B",$E(X,1,30),DA)
	;;^DD(119.9,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.9,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the SITE field.
	;;^DD(119.9,.01,3)
	;;=Type the Number 1
	;;^DD(119.9,.01,21,0)
	;;=^^1^1^2940926^^^^
	;;^DD(119.9,.01,21,1,0)
	;;=This value is always 1.
	;;^DD(119.9,.01,"DT")
	;;=2890604
	;;^DD(119.9,3,0)
	;;=LABEL PRINTERS^119.93P^^D;0
	;;^DD(119.9,3,21,0)
	;;=^^1^1^2911129^
	;;^DD(119.9,3,21,1,0)
	;;=This is a list of printers using label stock.
	;;^DD(119.9,70,0)
	;;=ASSESSMENT DEFAULT UNITS^S^E:ENGLISH;M:METRIC;^3;1^Q
	;;^DD(119.9,70,21,0)
	;;=^^2^2^2910612^^
	;;^DD(119.9,70,21,1,0)
	;;=This field contains the default unit of measurement to be used
	;;^DD(119.9,70,21,2,0)
	;;=in performing Nutrition Assessments
	;;^DD(119.9,70,"DT")
	;;=2890604
	;;^DD(119.9,71,0)
	;;=# OF DAYS TO OBTAIN LAB DATA^NJ3,0^^3;2^K:+X'=X!(X>500)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.9,71,3)
	;;=Type a Number between 1 and 500, 0 Decimal Digits
	;;^DD(119.9,71,21,0)
	;;=^^3^3^2890604^
	;;^DD(119.9,71,21,1,0)
	;;=This field contains the number of days backward for which a search
	;;^DD(119.9,71,21,2,0)
	;;=of laboratory data will be made. That is, only data obtained within
	;;^DD(119.9,71,21,3,0)
	;;=the last # of days will be displayed.
	;;^DD(119.9,71,"DT")
	;;=2890604
	;;^DD(119.9,74,0)
	;;=PRINT PROFILE AFTER SCREENING?^S^Y:YES;N:NO;A:ASK USER;^3;3^Q
	;;^DD(119.9,74,21,0)
	;;=^^4^4^2901015^
	;;^DD(119.9,74,21,1,0)
	;;=This parameter determines whether the Nutrition Profile is printed
	;;^DD(119.9,74,21,2,0)
	;;=immediately following the printing of a screening form. If 'A' is
	;;^DD(119.9,74,21,3,0)
	;;=selected, the user will be asked to make a selection at the time
	;;^DD(119.9,74,21,4,0)
	;;=of printing screening forms.
	;;^DD(119.9,74,"DT")
	;;=2901015
	;;^DD(119.9,75,0)
	;;=OPTIONAL SCREENING LINE^F^^3;5^K:$L(X)>74!($L(X)<3) X
	;;^DD(119.9,75,3)
	;;=Answer must be 3-74 characters in length.
	;;^DD(119.9,75,21,0)
	;;=^^3^3^2891106^
	;;^DD(119.9,75,21,1,0)
	;;=This field may contain a line of text which will be printed as
	;;^DD(119.9,75,21,2,0)
	;;=the last line of the S portion of the Nutrition Screening
	;;^DD(119.9,75,21,3,0)
	;;=form.
	;;^DD(119.9,75,"DT")
	;;=2891105
	;;^DD(119.9,80,0)
	;;=LAB TEST^119.9001P^^L;0
	;;^DD(119.9,80,21,0)
	;;=^^2^2^2890709^^^^
	;;^DD(119.9,80,21,1,0)
	;;=This multiple contains a list of laboratory tests which
	;;^DD(119.9,80,21,2,0)
	;;=are of interest to clinicians.
	;;^DD(119.9,85,0)
	;;=DRUG CLASSIFICATIONS^119.985P^^P;0
	;;^DD(119.9,85,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.9,85,21,1,0)
	;;=This multiple contains drug classifications of interest
	;;^DD(119.9,85,21,2,0)
	;;=to clinicians.
	;;^DD(119.9,99,0)
	;;=HEADING ON BOTTOM OF TICKET?^S^Y:YES;N:NO;^4;1^Q
	;;^DD(119.9,99,21,0)
	;;=^^3^3^2940926^
	;;^DD(119.9,99,21,1,0)
	;;=This field is optional and it is used to indicate whether the
	;;^DD(119.9,99,21,2,0)
	;;=heading should be printed on the bottom of the tray tickets and
	;;^DD(119.9,99,21,3,0)
	;;=diet cards.
	;;^DD(119.9,99,"DT")
	;;=2940926
	;;^DD(119.9,100,0)
	;;=WILL YOU USE TRAY TICKETS?^S^Y:YES;N:NO;^4;2^Q
	;;^DD(119.9,100,21,0)
	;;=^^8^8^2941028^^^^
	;;^DD(119.9,100,21,1,0)
	;;=This field is optional and it is used to indicate whether the user
	;;^DD(119.9,100,21,2,0)
	;;=wants to use the Tray Tickets or not.  If the answer is Yes, you will
	;;^DD(119.9,100,21,3,0)
	;;=be asked whether you want the heading for the Tray Tickets to
	;;^DD(119.9,100,21,4,0)
	;;=be printed on the bottom or not and also you will be receiving a
	;;^DD(119.9,100,21,5,0)
	;;=no diet pattern message on diet activity for patients that do
