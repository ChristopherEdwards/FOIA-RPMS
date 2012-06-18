IBINI0CB	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.96)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(409.96,0,"GL")
	;;=^SD(409.96,
	;;^DIC("B","PRINT MANAGER DIVISION SETUP",409.96)
	;;=
	;;^DIC(409.96,"%D",0)
	;;=^^7^7^2940307^^^^
	;;^DIC(409.96,"%D",1,0)
	;;= 
	;;^DIC(409.96,"%D",2,0)
	;;= 
	;;^DIC(409.96,"%D",3,0)
	;;=This file allows the user to specify reports or forms that should print in
	;;^DIC(409.96,"%D",4,0)
	;;=addition to the encounter forms for the entire division . Only reports
	;;^DIC(409.96,"%D",5,0)
	;;=contained in the Package Interface file can be specified. The user can
	;;^DIC(409.96,"%D",6,0)
	;;=also specify the conditions under which the report should print. The
	;;^DIC(409.96,"%D",7,0)
	;;=intent is to print packets of forms that do not require manual collation.
	;;^DD(409.96,0)
	;;=FIELD^^1^2
	;;^DD(409.96,0,"DDA")
	;;=N
	;;^DD(409.96,0,"IX","A",409.961,.01)
	;;=
	;;^DD(409.96,0,"IX","A1",409.961,.02)
	;;=
	;;^DD(409.96,0,"IX","B",409.96,.01)
	;;=
	;;^DD(409.96,0,"NM","PRINT MANAGER DIVISION SETUP")
	;;=
	;;^DD(409.96,.01,0)
	;;=DIVISION^RP40.8'^DG(40.8,^0;1^Q
	;;^DD(409.96,.01,1,0)
	;;=^.1
	;;^DD(409.96,.01,1,1,0)
	;;=409.96^B
	;;^DD(409.96,.01,1,1,1)
	;;=S ^SD(409.96,"B",$E(X,1,30),DA)=""
	;;^DD(409.96,.01,1,1,2)
	;;=K ^SD(409.96,"B",$E(X,1,30),DA)
	;;^DD(409.96,.01,3)
	;;=Enter the division for which you want to specify forms.
	;;^DD(409.96,.01,21,0)
	;;=^^2^2^2930623^^^^
	;;^DD(409.96,.01,21,1,0)
	;;= 
	;;^DD(409.96,.01,21,2,0)
	;;=The division the setup is for.
	;;^DD(409.96,.01,"DT")
	;;=2930518
	;;^DD(409.96,1,0)
	;;=REPORT^409.961IP^^1;0
	;;^DD(409.96,1,12)
	;;=Allows only package interfaces that print reports and that are available.
	;;^DD(409.96,1,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1"
	;;^DD(409.96,1,21,0)
	;;=^^2^2^2930528^
	;;^DD(409.96,1,21,1,0)
	;;= 
	;;^DD(409.96,1,21,2,0)
	;;=The reports that should print.
	;;^DD(409.96,1,"DT")
	;;=2930520
	;;^DD(409.961,0)
	;;=REPORT SUB-FIELD^^.02^2
	;;^DD(409.961,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(357.92,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(357.92,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(409.961,0,"IX","B",409.961,.01)
	;;=
	;;^DD(409.961,0,"NM","REPORT")
	;;=
	;;^DD(409.961,0,"UP")
	;;=409.96
	;;^DD(409.961,.01,0)
	;;=REPORT^M*P357.6'^IBE(357.6,^0;1^S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.961,.01,1,0)
	;;=^.1
	;;^DD(409.961,.01,1,1,0)
	;;=409.961^B
	;;^DD(409.961,.01,1,1,1)
	;;=S ^SD(409.96,DA(1),1,"B",$E(X,1,30),DA)=""
	;;^DD(409.961,.01,1,1,2)
	;;=K ^SD(409.96,DA(1),1,"B",$E(X,1,30),DA)
	;;^DD(409.961,.01,1,2,0)
	;;=409.96^A^MUMPS
	;;^DD(409.961,.01,1,2,1)
	;;=I $P(^SD(409.96,DA(1),1,DA,0),U,2) S ^SD(409.96,"A",$P(^SD(409.96,DA(1),0),U),$P(^SD(409.96,DA(1),1,DA,0),U,2),X,DA(1),DA)=""
	;;^DD(409.961,.01,1,2,2)
	;;=I $P(^SD(409.96,DA(1),1,DA,0),U,2) K ^SD(409.96,"A",$P(^SD(409.96,DA(1),0),U),$P(^SD(409.96,DA(1),1,DA,0),U,2),X,DA(1),DA)
	;;^DD(409.961,.01,1,2,"%D",0)
	;;=^^7^7^2940216^
	;;^DD(409.961,.01,1,2,"%D",1,0)
	;;= 
	;;^DD(409.961,.01,1,2,"%D",2,0)
	;;= 
	;;^DD(409.961,.01,1,2,"%D",3,0)
	;;=Allows all of the reports that should print under certain conditons for
	;;^DD(409.961,.01,1,2,"%D",4,0)
	;;=the division to be found. The subscripts are ^SD(409.96,"A",<division
	;;^DD(409.961,.01,1,2,"%D",5,0)
	;;=ien>,<print condition ien >, <package interface ien>, <division setup
	;;^DD(409.961,.01,1,2,"%D",6,0)
	;;=ien>, <report multiple ien>). It is not necessary to re-index the A1
	;;^DD(409.961,.01,1,2,"%D",7,0)
	;;=cross-reference on the PRINT CONDITION field if this field is re-indexed.
