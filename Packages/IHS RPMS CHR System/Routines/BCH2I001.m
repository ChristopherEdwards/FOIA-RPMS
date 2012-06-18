BCH2I001 ; ; 26-JUN-1997
 ;;1.0;IHS RPMS CHR SYSTEM;**3**;JUN 26, 1997
 Q:'DIFQ(90002.01)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(90002.01,0,"GL")
 ;;=^BCHRPROB(
 ;;^DIC("B","CHR POV",90002.01)
 ;;=
 ;;^DIC(90002.01,"%D",0)
 ;;=^^1^1^2950201^
 ;;^DIC(90002.01,"%D",1,0)
 ;;=This file contains one record for each assessment on the CHR PCC Form.
 ;;^DD(90002.01,0)
 ;;=FIELD^^.07^7
 ;;^DD(90002.01,0,"DT")
 ;;=2970626
 ;;^DD(90002.01,0,"ID",.02)
 ;;=W ""
 ;;^DD(90002.01,0,"ID",.03)
 ;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^BCHR(+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(90002,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
 ;;^DD(90002.01,0,"IX","AC",90002.01,.02)
 ;;=
 ;;^DD(90002.01,0,"IX","AD",90002.01,.03)
 ;;=
 ;;^DD(90002.01,0,"IX","AY9",90002.01,.01)
 ;;=
 ;;^DD(90002.01,0,"IX","B",90002.01,.01)
 ;;=
 ;;^DD(90002.01,0,"NM","CHR POV")
 ;;=
 ;;^DD(90002.01,.01,0)
 ;;=PROBLEM CODE^RP90002.53'^BCHTPROB(^0;1^Q
 ;;^DD(90002.01,.01,1,0)
 ;;=^.1
 ;;^DD(90002.01,.01,1,1,0)
 ;;=90002.01^B
 ;;^DD(90002.01,.01,1,1,1)
 ;;=S ^BCHRPROB("B",$E(X,1,30),DA)=""
 ;;^DD(90002.01,.01,1,1,2)
 ;;=K ^BCHRPROB("B",$E(X,1,30),DA)
 ;;^DD(90002.01,.01,1,2,0)
 ;;=90002.01^AY9^MUMPS
 ;;^DD(90002.01,.01,1,2,1)
 ;;=S:$D(BCHLOOK) DIC("DR")=""
 ;;^DD(90002.01,.01,1,2,2)
 ;;=Q
 ;;^DD(90002.01,.01,1,2,"%D",0)
 ;;=^^1^1^2950201^
 ;;^DD(90002.01,.01,1,2,"%D",1,0)
 ;;=Sets DIC("DR") to prevent the asking of identifiers when file shifting.
 ;;^DD(90002.01,.01,1,2,"DT")
 ;;=2940916
 ;;^DD(90002.01,.01,3)
 ;;=
 ;;^DD(90002.01,.01,"DT")
 ;;=2940916
 ;;^DD(90002.01,.05,0)
 ;;=SERVICE MINUTES^RNJ4,0^^0;5^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(90002.01,.05,1,0)
 ;;=^.1
 ;;^DD(90002.01,.05,1,1,0)
 ;;=^^TRIGGER^90002^.27
 ;;^DD(90002.01,.05,1,1,1)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(90002.01,.05,1,1,89.2) S X=$P(Y(101),U,27) S D0=I(0,0) S DIU=X K Y S X=DIV S X=DIU+DIV X ^DD(90002.01,.05,1,1,1.4)
 ;;^DD(90002.01,.05,1,1,1.4)
 ;;=S DIH=$S($D(^BCHR(DIV(0),0)):^(0),1:""),DIV=X I $D(^(0)) S $P(^(0),U,27)=DIV,DIH=90002,DIG=.27 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(90002.01,.05,1,1,2)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(90002.01,.05,1,1,89.2) S X=$P(Y(101),U,27) S D0=I(0,0) S DIU=X K Y S X=DIV S X=DIU-X X ^DD(90002.01,.05,1,1,2.4)
 ;;^DD(90002.01,.05,1,1,2.4)
 ;;=S DIH=$S($D(^BCHR(DIV(0),0)):^(0),1:""),DIV=X I $D(^(0)) S $P(^(0),U,27)=DIV,DIH=90002,DIG=.27 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(90002.01,.05,1,1,89.2)
 ;;=S I(0,0)=$S($D(D0):D0,1:""),Y(1)=$S($D(^BCHRPROB(D0,0)):^(0),1:""),D0=$P(Y(1),U,3) S:'$D(^BCHR(+D0,0)) D0=-1 S DIV(0)=D0 S Y(101)=$S($D(^BCHR(D0,0)):^(0),1:"")
 ;;^DD(90002.01,.05,1,1,"CREATE VALUE")
 ;;=TOTAL SERVICE TIME+SERVICE MINUTES
 ;;^DD(90002.01,.05,1,1,"DELETE VALUE")
 ;;=TOTAL SERVICE TIME-OLD SERVICE MINUTES
 ;;^DD(90002.01,.05,1,1,"DT")
 ;;=2950112
 ;;^DD(90002.01,.05,1,1,"FIELD")
 ;;=#.03:#.27
 ;;^DD(90002.01,.05,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits
 ;;^DD(90002.01,.05,"DT")
 ;;=2970626
