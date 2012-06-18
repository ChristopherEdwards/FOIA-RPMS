IBINI023	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.71)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.71,0,"GL")
	;;=^IBE(350.71,
	;;^DIC("B","AMBULATORY SURG. CHECK-OFF SHEET PRINT FIELDS",350.71)
	;;=
	;;^DIC(350.71,"%",0)
	;;=^1.005^0^0
	;;^DIC(350.71,"%D",0)
	;;=^^6^6^2940214^^^^
	;;^DIC(350.71,"%D",1,0)
	;;=Contains the Sub-headers and Procedures associated with each ambulatory
	;;^DIC(350.71,"%D",2,0)
	;;=surgery check-off sheet.  Defines the relationship between check-off sheets,
	;;^DIC(350.71,"%D",3,0)
	;;=Sub-headers, and Procedures.  Also defines the print order of each entry on 
	;;^DIC(350.71,"%D",4,0)
	;;=the check-off sheet.
	;;^DIC(350.71,"%D",5,0)
	;;= 
	;;^DIC(350.71,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.71,0)
	;;=FIELD^^.08^7
	;;^DD(350.71,0,"DDA")
	;;=N
	;;^DD(350.71,0,"DT")
	;;=2920128
	;;^DD(350.71,0,"IX","AG",350.71,.02)
	;;=
	;;^DD(350.71,0,"IX","AG1",350.71,.04)
	;;=
	;;^DD(350.71,0,"IX","AP",350.71,.06)
	;;=
	;;^DD(350.71,0,"IX","AP1",350.71,.05)
	;;=
	;;^DD(350.71,0,"IX","AS",350.71,.02)
	;;=
	;;^DD(350.71,0,"IX","AS1",350.71,.05)
	;;=
	;;^DD(350.71,0,"IX","B",350.71,.01)
	;;=
	;;^DD(350.71,0,"IX","G",350.71,.04)
	;;=
	;;^DD(350.71,0,"IX","P",350.71,.06)
	;;=
	;;^DD(350.71,0,"IX","S",350.71,.05)
	;;=
	;;^DD(350.71,0,"NM","AMBULATORY SURG. CHECK-OFF SHEET PRINT FIELDS")
	;;=
	;;^DD(350.71,0,"PT",350.71,.05)
	;;=
	;;^DD(350.71,.01,0)
	;;=NAME^RFX^^0;1^S:$D(DA) IBCPX=DA D FFMT^IBEFUNC2 S IBLNGX=$S(IBLNGX=""!'$D(DA):59,$P(^IBE(350.71,DA,0),U,3)="P":$P(IBLNGX,U,3),1:$P(IBLNGX,U,2)) K:$L(X)<3!($L(X)>IBLNGX) X K IBLNGX,IBCPX
	;;^DD(350.71,.01,1,0)
	;;=^.1^^-1
	;;^DD(350.71,.01,1,1,0)
	;;=350.71^B
	;;^DD(350.71,.01,1,1,1)
	;;=S ^IBE(350.71,"B",$E(X,1,30),DA)=""
	;;^DD(350.71,.01,1,1,2)
	;;=K ^IBE(350.71,"B",$E(X,1,30),DA)
	;;^DD(350.71,.01,3)
	;;=Enter the text to be printed on the CPT list for this entry. Maximum length depends on number of columns and if charge is printed.  DELETING A SUB-HEADER DELETES ALL THE SUB-HEADER'S PROCEDURES.
	;;^DD(350.71,.01,4)
	;;=I $D(DA) S IBCPX=DA D FFMT^IBEFUNC2 W !,?5,"Maximum length for this entry is now ",$S(IBLNGX="":59,$P(^IBE(350.71,DA,0),U,3)="P":$P(IBLNGX,U,3),1:$P(IBLNGX,U,2))," characters.",! K IBLNGX,IBCPX
	;;^DD(350.71,.01,21,0)
	;;=^^1^1^2920327^^^^
	;;^DD(350.71,.01,21,1,0)
	;;=Text printed on the check-off sheet for this entry.
	;;^DD(350.71,.01,"DEL",1,0)
	;;=I '$D(IBERSCE)
	;;^DD(350.71,.01,"DT")
	;;=2920327
	;;^DD(350.71,.02,0)
	;;=PRINT ORDER^RNJ4,0X^^0;2^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X I $D(X),$D(DA) D FPO^IBEFUNC2 I 'X K X
	;;^DD(350.71,.02,1,0)
	;;=^.1
	;;^DD(350.71,.02,1,1,0)
	;;=350.71^AS^MUMPS
	;;^DD(350.71,.02,1,1,1)
	;;=I $P(^IBE(350.71,DA,0),"^",5) S ^IBE(350.71,"AS",$P(^(0),"^",5),X,DA)=""
	;;^DD(350.71,.02,1,1,2)
	;;=I $P(^IBE(350.71,DA,0),"^",5) K ^IBE(350.71,"AS",$P(^(0),"^",5),X,DA)
	;;^DD(350.71,.02,1,1,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.02,1,1,"%D",0)
	;;=^^1^1^2920128^
	;;^DD(350.71,.02,1,1,"%D",1,0)
	;;=Quick index for sub-header members (procedures) and their print orders.
	;;^DD(350.71,.02,1,1,"DT")
	;;=2920128
	;;^DD(350.71,.02,1,2,0)
	;;=350.71^AG^MUMPS
	;;^DD(350.71,.02,1,2,1)
	;;=I $P(^IBE(350.71,DA,0),"^",4) S ^IBE(350.71,"AG",$P(^(0),"^",4),X,DA)=""
	;;^DD(350.71,.02,1,2,2)
	;;=I $P(^IBE(350.71,DA,0),"^",4) K ^IBE(350.71,"AG",$P(^(0),"^",4),X,DA)
	;;^DD(350.71,.02,1,2,3)
	;;=DO NOT DELETE
	;;^DD(350.71,.02,1,2,"%D",0)
	;;=^^1^1^2920128^^^^
	;;^DD(350.71,.02,1,2,"%D",1,0)
	;;=Quick cross-reference for all members (sub-header's) and their print orders, within a sheet.
	;;^DD(350.71,.02,1,2,"DT")
	;;=2911121
