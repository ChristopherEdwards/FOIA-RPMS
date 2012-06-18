IBINI0C9	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.95)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(409.9501,.01,12)
	;;=Allows only reports installed in the Package Interface file.
	;;^DD(409.9501,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1"
	;;^DD(409.9501,.01,21,0)
	;;=^^4^4^2940216^
	;;^DD(409.9501,.01,21,1,0)
	;;= 
	;;^DD(409.9501,.01,21,2,0)
	;;= 
	;;^DD(409.9501,.01,21,3,0)
	;;=An entry in the Package Interface file that should identify a routine that
	;;^DD(409.9501,.01,21,4,0)
	;;=prints the desired form or report.
	;;^DD(409.9501,.01,"DT")
	;;=2930520
	;;^DD(409.9501,.02,0)
	;;=PRINT CONDITION^RP357.92'^IBE(357.92,^0;2^Q
	;;^DD(409.9501,.02,1,0)
	;;=^.1
	;;^DD(409.9501,.02,1,1,0)
	;;=409.95^A1^MUMPS
	;;^DD(409.9501,.02,1,1,1)
	;;=S ^SD(409.95,"A",$P(^SD(409.95,DA(1),0),U),X,$P(^SD(409.95,DA(1),1,DA,0),U),DA(1),DA)=""
	;;^DD(409.9501,.02,1,1,2)
	;;=K ^SD(409.95,"A",$P(^SD(409.95,DA(1),0),U),X,$P(^SD(409.95,DA(1),1,DA,0),U),DA(1),DA)
	;;^DD(409.9501,.02,1,1,"%D",0)
	;;=^^7^7^2940216^
	;;^DD(409.9501,.02,1,1,"%D",1,0)
	;;= 
	;;^DD(409.9501,.02,1,1,"%D",2,0)
	;;= 
	;;^DD(409.9501,.02,1,1,"%D",3,0)
	;;=Allows all of the reports that should print under certain conditons for
	;;^DD(409.9501,.02,1,1,"%D",4,0)
	;;=the clinic to be found. The subscripts are ^SD(409.95,"A",<clinic
	;;^DD(409.9501,.02,1,1,"%D",5,0)
	;;=ien>,<print condition ien >, <package interface ien>, <clinic setup ien>,
	;;^DD(409.9501,.02,1,1,"%D",6,0)
	;;=<report multiple ien>). It is not necessary to re-index the A
	;;^DD(409.9501,.02,1,1,"%D",7,0)
	;;=cross-reference on the REPORT field if this field is re-indexed.
	;;^DD(409.9501,.02,1,1,"DT")
	;;=2930518
	;;^DD(409.9501,.02,3)
	;;=Under what condition should the report be printed?
	;;^DD(409.9501,.02,4)
	;;=D HELP6^IBDFU5A
	;;^DD(409.9501,.02,21,0)
	;;=^^2^2^2930528^
	;;^DD(409.9501,.02,21,1,0)
	;;= 
	;;^DD(409.9501,.02,21,2,0)
	;;=The particular condition under which the form or report should print.
	;;^DD(409.9501,.02,"DT")
	;;=2930518
	;;^DD(409.9502,0)
	;;=EXCLUDED REPORT SUB-FIELD^^.01^1
	;;^DD(409.9502,0,"IX","B",409.9502,.01)
	;;=
	;;^DD(409.9502,0,"NM","EXCLUDED REPORT")
	;;=
	;;^DD(409.9502,0,"UP")
	;;=409.95
	;;^DD(409.9502,.01,0)
	;;=EXCLUDED REPORT^M*P357.6'^IBE(357.6,^0;1^S DIC("S")="I $P($G(^(0)),U,6)=4,$P($G(^(0)),U,9)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.9502,.01,.1)
	;;=
	;;^DD(409.9502,.01,1,0)
	;;=^.1
	;;^DD(409.9502,.01,1,1,0)
	;;=409.9502^B
	;;^DD(409.9502,.01,1,1,1)
	;;=S ^SD(409.95,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(409.9502,.01,1,1,2)
	;;=K ^SD(409.95,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(409.9502,.01,1,2,0)
	;;=409.95^AE^MUMPS
	;;^DD(409.9502,.01,1,2,1)
	;;=S ^SD(409.95,"AE",$P(^SD(409.95,DA(1),0),U),X,DA(1),DA)=""
	;;^DD(409.9502,.01,1,2,2)
	;;=K ^SD(409.95,"AE",$P(^SD(409.95,DA(1),0),U),X,DA(1),DA)
	;;^DD(409.9502,.01,1,2,"%D",0)
	;;=^^1^1^2930622^
	;;^DD(409.9502,.01,1,2,"%D",1,0)
	;;=Used to determine if a particular report is defined NOT to print for a clinic.
	;;^DD(409.9502,.01,1,2,"DT")
	;;=2930622
	;;^DD(409.9502,.01,3)
	;;=You may enter reports that you DO NOT want to print for this clinic. Entering an EXCLUDED REPORT will prevent it from printing even if it is defined to print for the entire division.
	;;^DD(409.9502,.01,12)
	;;=Allows only available package interfaces that print reports.
	;;^DD(409.9502,.01,12.1)
	;;=S DIC("S")="I $P($G(^(0)),U,6)=4,$P($G(^(0)),U,9)=1"
	;;^DD(409.9502,.01,21,0)
	;;=^^3^3^2940216^
	;;^DD(409.9502,.01,21,1,0)
	;;=Used to override repots defined to print for the division. Reports
	;;^DD(409.9502,.01,21,2,0)
	;;=defined to print for the division will not print if they are excluded
