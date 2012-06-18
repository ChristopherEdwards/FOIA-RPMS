XUINEND2 ;SFISC/RWF - CLEAN UP OLD SPOOL DATA ;6/29/92  11:26
 ;;7.0;Kernel;;Jul 17, 1992
A S U="^"
 F ZISDA=0:0 S ZISDA=$O(^XMB(3.51,ZISDA)) Q:ZISDA'>0  D CHK
 Q
CHK ;
 S Z0=$G(^XMB(3.51,ZISDA,0)),DA=$P(Z0,U,10)
 Q:DA'>0  I $D(^XMBS(3.519,DA,0)) Q
 Q:'$D(^XMB(3.9,DA,0))
 ;MOVE
 S X=ZISDA,DIC="^XMBS(3.519,",DIC(0)="",DLAYGO=3.519 D FILE^DICN S XS=+Y
 S %X="^XMB(3.9,"_DA_",2,",%Y="^XMBS(3.519,"_XS_",2," D %XY^%RCR
 S $P(^XMB(3.51,ZISDA,0),U,10)=XS,^XMB(3.51,"AM",XS,ZISDA)="" K ^XMB(3.51,"AM",DA,ZISDA)
 S XMDUZ=$P(Z0,U,5),XMZ=DA D KLQ^XMA1B ;Move to waste basket
 Q
F4 ;Clean-up Institution file fields .04 and 6 both use 0;7 to store data
 S X=$G(^DD(4,6,0)) Q:X'["AMIS"
 S DIK="^DD(4,",DA=6,DA(1)=4 D ^DIK
 Q
F200 ;Clean-up DUP X-ref in file 200
 I $G(^DD(200,2,1,3,0))["A^MUMPS" S DIK="^DD(200,2,1,",DA=3,DA(1)=2,DA(2)=200 D ^DIK
 Q
F6 ;Build .01 field of provider file.
 F I=1:2 S X=$E($T(Q+I),4,999) Q:X=""  S Y=$E($T(Q+I+1),4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DIC(6,0,"GL")
 ;;=^DIC(6,
 ;;^DIC("B","PROVIDER",6)
 ;;=
 ;;^DD(6,0)
 ;;=FIELD^^100^15
 ;;^DD(6,0,"NM","PROVIDER")
 ;;=
 ;;^DD(6,.01,0)
 ;;=NAME^RP16X^DIC(16,^0;1^S DINUM=X
 ;;^DD(6,.01,1,0)
 ;;=^.1
 ;;^DD(6,.01,1,1,0)
 ;;=6^B
 ;;^DD(6,.01,1,1,1)
 ;;=S ^DIC(6,"B",$E(X,1,30),DA)=""
 ;;^DD(6,.01,1,1,2)
 ;;=K ^DIC(6,"B",$E(X,1,30),DA)
 ;;^DD(6,.01,1,2,0)
 ;;=6^AC^MUMPS
 ;;^DD(6,.01,1,2,1)
 ;;=S ^DIC(16,+X,"A6")=DA
 ;;^DD(6,.01,1,2,1.1)
 ;;=S X=DIV S X=$S('$D(D0):"",D0<0:"",1:D0)
 ;;^DD(6,.01,1,2,1.4)
 ;;=S DIH=$S($D(^DIC(16,DIV(0),"A6")):^("A6"),1:""),DIV=X I $D(^(0)) S %=$P(DIH,U,2,999),DIU=$P(DIH,U,1),^("A6")=DIV_$S(%]"":U_%,1:""),DIH=16,DIG=30.006 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(6,.01,1,2,2)
 ;;=K ^DIC(16,+X,"A6")
 ;;^DD(6,.01,1,2,9.2)
 ;;=S I(0,0)=$S($D(D0):D0,1:""),D0=X S:'$D(^DIC(16,+D0,0)) D0=-1 S DIV(0)=D0 S I(100,0)=$S($D(D0):D0,1:""),Y(101)=$S($D(^DIC(16,D0,"A6")):^("A6"),1:"")
 ;;^DD(6,.01,1,2,"CREATE VALUE")
 ;;=NUMBER
 ;;^DD(6,.01,1,2,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(6,.01,1,2,"FIELD")
 ;;=NAME:PROVIDER
 ;;^DD(6,.01,1,3,0)
 ;;=6^AK^MUMPS
 ;;^DD(6,.01,1,3,1)
 ;;=G F6S^XUA4A7
 ;;^DD(6,.01,1,3,2)
 ;;=G F6K^XUA4A7
 ;;^DD(6,.01,1,3,3)
 ;;=Used to link providers to new person keys.
 ;;^DD(6,.01,1,3,"%D",0)
 ;;=^^2^2^2910916^
 ;;^DD(6,.01,1,3,"%D",1,0)
 ;;=This X-ref will see that the provider also has the 'VA Provider'
 ;;^DD(6,.01,1,3,"%D",2,0)
 ;;=key in the New Person file.
 ;;^DD(6,.01,1,3,"DT")
 ;;=2910916
 ;;^DD(6,.01,3)
 ;;=
 ;;^DD(6,.01,5,1,0)
 ;;=16010^30.006^1
 ;;^DD(6,.01,"DT")
 ;;=2910916
 ;;
