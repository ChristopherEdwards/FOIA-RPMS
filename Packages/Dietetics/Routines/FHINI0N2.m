FHINI0N2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.9,100,21,6,0)
	;;=not have a diet pattern which is related to the tray tickets.
	;;^DD(119.9,100,21,7,0)
	;;=If the answer is No, you will not be asked the question and
	;;^DD(119.9,100,21,8,0)
	;;=receive the message.
	;;^DD(119.9,100,"DT")
	;;=2941028
	;;^DD(119.9001,0)
	;;=LAB TEST SUB-FIELD^^4^5
	;;^DD(119.9001,0,"IX","B",119.9001,.01)
	;;=
	;;^DD(119.9001,0,"NM","LAB TEST")
	;;=
	;;^DD(119.9001,0,"UP")
	;;=119.9
	;;^DD(119.9001,.01,0)
	;;=LAB TEST^M*P60'^LAB(60,^0;1^S DIC("S")="I $P(^(0),U,5)[""CH"",""BO""[$P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(119.9001,.01,1,0)
	;;=^.1
	;;^DD(119.9001,.01,1,1,0)
	;;=119.9001^B
	;;^DD(119.9001,.01,1,1,1)
	;;=S ^FH(119.9,DA(1),"L","B",$E(X,1,30),DA)=""
	;;^DD(119.9001,.01,1,1,2)
	;;=K ^FH(119.9,DA(1),"L","B",$E(X,1,30),DA)
	;;^DD(119.9001,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.9001,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the LAB TEST field.
	;;^DD(119.9001,.01,3)
	;;=
	;;^DD(119.9001,.01,12)
	;;=Can only select Chemistry tests
	;;^DD(119.9001,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)[""CH"",""BO""[$P(^(0),U,3)"
	;;^DD(119.9001,.01,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.9001,.01,21,1,0)
	;;=This field is a pointer to File 60, Lab Tests, and is a test
	;;^DD(119.9001,.01,21,2,0)
	;;=of interest to clinicians.
	;;^DD(119.9001,.01,"DT")
	;;=2890629
	;;^DD(119.9001,1,0)
	;;=SPECIMEN^RFXO^^0;2^K:$L(X)>10!($L(X)<1) X I $D(X) S P60=+^FH(119.9,1,"L",DA,0),DIC="^LAB(60,P60,1,",DIC(0)="QEM" D ^DIC S X=+Y K:Y<1 X K P60
	;;^DD(119.9001,1,2)
	;;=S Y(0)=Y S Y=$S($D(^LAB(61,+Y,0)):$P(^(0),"^",1),1:Y)
	;;^DD(119.9001,1,2.1)
	;;=S Y=$S($D(^LAB(61,+Y,0)):$P(^(0),"^",1),1:Y)
	;;^DD(119.9001,1,3)
	;;=
	;;^DD(119.9001,1,4)
	;;=S P60=+^FH(119.9,1,"L",DA,0),DIC="^LAB(60,P60,1,",DIC(0)="Q",D="B" K DO D DQ^DICQ K DIC,DO,D,P60 S DIC=DIE
	;;^DD(119.9001,1,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.9001,1,21,1,0)
	;;=This field points to the specimen/typology file and indicates which
	;;^DD(119.9001,1,21,2,0)
	;;=specimen of the selected lab test is desired.
	;;^DD(119.9001,1,"DT")
	;;=2890628
	;;^DD(119.9001,2,0)
	;;=PRINT ON ASSESSMENT?^S^Y:YES;N:NO;^0;3^Q
	;;^DD(119.9001,2,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.9001,2,21,1,0)
	;;=This field, when answered YES, will permit printing of the lab
	;;^DD(119.9001,2,21,2,0)
	;;=results on the Nutrition Assessment form.
	;;^DD(119.9001,2,"DT")
	;;=2890709
	;;^DD(119.9001,3,0)
	;;=PRINT ON SCREENING?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(119.9001,3,21,0)
	;;=^^2^2^2890709^
	;;^DD(119.9001,3,21,1,0)
	;;=This field, when answered YES, will permit printing of the lab
	;;^DD(119.9001,3,21,2,0)
	;;=results on the Nutrition Screening form.
	;;^DD(119.9001,3,"DT")
	;;=2890709
	;;^DD(119.9001,4,0)
	;;=IDENT GROUP^NJ2,0^^0;5^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.9001,4,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(119.9001,4,21,0)
	;;=^^4^4^2901015^
	;;^DD(119.9001,4,21,1,0)
	;;=This number, called the identification group, will allow either
	;;^DD(119.9001,4,21,2,0)
	;;=(a) specification of a particular laboratory test with a known
	;;^DD(119.9001,4,21,3,0)
	;;=number, or (b) allow selection of only the latest value from
	;;^DD(119.9001,4,21,4,0)
	;;=among a group of tests with the same number.
	;;^DD(119.9001,4,"DT")
	;;=2901015
	;;^DD(119.93,0)
	;;=LABEL PRINTERS SUB-FIELD^^1^2
	;;^DD(119.93,0,"DT")
	;;=2911129
	;;^DD(119.93,0,"IX","B",119.93,.01)
	;;=
	;;^DD(119.93,0,"NM","LABEL PRINTERS")
	;;=
	;;^DD(119.93,0,"UP")
	;;=119.9
	;;^DD(119.93,.01,0)
	;;=LABEL PRINTERS^MP3.5'X^%ZIS(1,^0;1^I $D(X) S DINUM=X
	;;^DD(119.93,.01,1,0)
	;;=^.1
	;;^DD(119.93,.01,1,1,0)
	;;=119.93^B
	;;^DD(119.93,.01,1,1,1)
	;;=S ^FH(119.9,DA(1),"D","B",$E(X,1,30),DA)=""
	;;^DD(119.93,.01,1,1,2)
	;;=K ^FH(119.9,DA(1),"D","B",$E(X,1,30),DA)
	;;^DD(119.93,.01,21,0)
	;;=^^3^3^2911204^
	;;^DD(119.93,.01,21,1,0)
	;;=This field is a pointer to the Device File and indicates a printer used
	;;^DD(119.93,.01,21,2,0)
	;;=for printing diet labels, tubefeeding labels, supplemental feeding labels
	;;^DD(119.93,.01,21,3,0)
	;;=or other labels.
	;;^DD(119.93,.01,"DT")
	;;=2911129
	;;^DD(119.93,1,0)
	;;=SIZE OF LABELS^S^1:3-1/2 x 15/16;2:4 x 1-7/16;^0;2^Q
	;;^DD(119.93,1,21,0)
	;;=^^1^1^2930520^^
	;;^DD(119.93,1,21,1,0)
	;;=This field indicates the size of label stock on the printer.
	;;^DD(119.93,1,"DT")
	;;=2911129
	;;^DD(119.985,0)
	;;=DRUG CLASSIFICATIONS SUB-FIELD^^.01^1
	;;^DD(119.985,0,"IX","B",119.985,.01)
	;;=
	;;^DD(119.985,0,"NM","DRUG CLASSIFICATIONS")
	;;=
	;;^DD(119.985,0,"UP")
	;;=119.9
	;;^DD(119.985,.01,0)
	;;=DRUG CLASSIFICATIONS^MP50.605'^PS(50.605,^0;1^Q
