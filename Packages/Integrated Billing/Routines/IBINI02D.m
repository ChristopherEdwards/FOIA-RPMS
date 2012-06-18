IBINI02D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.9,0,"GL")
	;;=^IBE(350.9,
	;;^DIC("B","IB SITE PARAMETERS",350.9)
	;;=
	;;^DIC(350.9,"%D",0)
	;;=^^12^12^2940214^^^^
	;;^DIC(350.9,"%D",1,0)
	;;=This file contains the data necessary to run the IB package, and to
	;;^DIC(350.9,"%D",2,0)
	;;=manage the IB background filer.  The menu IB SITE MANAGER MENU provides
	;;^DIC(350.9,"%D",3,0)
	;;=options that allow display and editing of
	;;^DIC(350.9,"%D",4,0)
	;;=data in this file, in addition to options to manage the
	;;^DIC(350.9,"%D",5,0)
	;;=IB background filer, for the site manager.  
	;;^DIC(350.9,"%D",6,0)
	;;= 
	;;^DIC(350.9,"%D",7,0)
	;;=The Billing Site Parameters are also found in this file.  
	;;^DIC(350.9,"%D",8,0)
	;;=The option to edit these parameters is on the Billing Supervisor menu.
	;;^DIC(350.9,"%D",9,0)
	;;= 
	;;^DIC(350.9,"%D",10,0)
	;;=This file should always be edited by use of the provided options.
	;;^DIC(350.9,"%D",11,0)
	;;= 
	;;^DIC(350.9,"%D",12,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.9,0)
	;;=FIELD^^4.06^106
	;;^DD(350.9,0,"DDA")
	;;=N
	;;^DD(350.9,0,"DT")
	;;=2940125
	;;^DD(350.9,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DIC(4,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(4,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(350.9,0,"IX","B",350.9,.01)
	;;=
	;;^DD(350.9,0,"NM","IB SITE PARAMETERS")
	;;=
	;;^DD(350.9,.01,0)
	;;=NAME^RNJ1,0X^^0;1^K:+X'=X!(X>1)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(350.9,.01,1,0)
	;;=^.1
	;;^DD(350.9,.01,1,1,0)
	;;=350.9^B
	;;^DD(350.9,.01,1,1,1)
	;;=S ^IBE(350.9,"B",$E(X,1,30),DA)=""
	;;^DD(350.9,.01,1,1,2)
	;;=K ^IBE(350.9,"B",$E(X,1,30),DA)
	;;^DD(350.9,.01,3)
	;;=Type a Number between 1 and 1, 0 Decimal Digits
	;;^DD(350.9,.01,21,0)
	;;=^^2^2^2910227^
	;;^DD(350.9,.01,21,1,0)
	;;=You may only have one site parameter entry.  Its internal number must be
	;;^DD(350.9,.01,21,2,0)
	;;=1 and its name must be the same.
	;;^DD(350.9,.01,"DEL",1,0)
	;;=I 1 W !,"Deleting site parameters not allowed!"
	;;^DD(350.9,.02,0)
	;;=FACILITY NAME^R*P4'^DIC(4,^0;2^S DIC("S")="I $S('$D(^(99)):0,+^(99)<1:0,1:1)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.9,.02,12)
	;;=Institution must have a facility number defined
	;;^DD(350.9,.02,12.1)
	;;=S DIC("S")="I $S('$D(^(99)):0,+^(99)<1:0,1:1)"
	;;^DD(350.9,.02,21,0)
	;;=^^3^3^2910227^
	;;^DD(350.9,.02,21,1,0)
	;;=This is the name of your facility from the institution file.  There must
	;;^DD(350.9,.02,21,2,0)
	;;=be a station number associated with this entry.  This value will be used
	;;^DD(350.9,.02,21,3,0)
	;;=by IFCAP in determining the bill number.
	;;^DD(350.9,.02,"DT")
	;;=2910221
	;;^DD(350.9,.03,0)
	;;=FILE IN BACKGROUND^S^1:YES;0:NO;^0;3^Q
	;;^DD(350.9,.03,21,0)
	;;=^^7^7^2910227^
	;;^DD(350.9,.03,21,1,0)
	;;=Set this field to 'YES' to cause the IB Background Filer to run as a 
	;;^DD(350.9,.03,21,2,0)
	;;=background job.  If it is set to 'NO' or left blank, filing will occur
	;;^DD(350.9,.03,21,3,0)
	;;=as applications pass data to Integrated Billing.  Sites may wish to
	;;^DD(350.9,.03,21,4,0)
	;;=experiment with running the filer in the foreground (answer 'NO') or
	;;^DD(350.9,.03,21,5,0)
	;;=filing in the background.  For Pharmacy Co-Pay, it is expected that
	;;^DD(350.9,.03,21,6,0)
	;;=some sites will experience significant delays in Outpatient Pharmacy
	;;^DD(350.9,.03,21,7,0)
	;;=label printing if filing is not done in the background.
	;;^DD(350.9,.03,"DT")
	;;=2910225
	;;^DD(350.9,.04,0)
	;;=FILER STARTED^D^^0;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
