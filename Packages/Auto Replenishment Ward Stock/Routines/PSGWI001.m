PSGWI001 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(50)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(50,0,"GL")
 ;;=^PSDRUG(
 ;;^DIC("B","DRUG",50)
 ;;=
 ;;^DIC(50,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(50,"%",1,0)
 ;;=PS
 ;;^DIC(50,"%","B","PS",1)
 ;;=
 ;;^DIC(50,"%D",0)
 ;;=^^9^9^2920518^^^^
 ;;^DIC(50,"%D",1,0)
 ;;=This file holds the information related to each drug that can be used
 ;;^DIC(50,"%D",2,0)
 ;;=to fill a prescription.  It is pointed to from several other files and
 ;;^DIC(50,"%D",3,0)
 ;;=should be handled carefully, usually only by special individuals in the
 ;;^DIC(50,"%D",4,0)
 ;;=pharmacy service.  Entries are not typically deleted, but rather made
 ;;^DIC(50,"%D",5,0)
 ;;=inactive by entering an inactive date.
 ;;^DIC(50,"%D",6,0)
 ;;= 
 ;;^DIC(50,"%D",7,0)
 ;;=This file must be built by Pharmacy Service BEFORE going on-line.  It is
 ;;^DIC(50,"%D",8,0)
 ;;=common to use another centers file and edit it to match your center's
 ;;^DIC(50,"%D",9,0)
 ;;=unique formulary.
 ;;^DD(50,0)
 ;;=FIELD^NL^623008^78
 ;;^DD(50,0,"DDA")
 ;;=N
 ;;^DD(50,0,"DT")
 ;;=2920716
 ;;^DD(50,0,"ID",2)
 ;;=W ""
 ;;^DD(50,0,"ID",6)
 ;;=W ""
 ;;^DD(50,0,"ID",25)
 ;;=S %I=Y,Y=$S('$D(^("ND")):"",$D(^PS(50.605,+$P(^("ND"),U,6),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(50.605,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
 ;;^DD(50,0,"ID",51)
 ;;=W:$P(^(0),"^",9) "   N/F"
 ;;^DD(50,0,"ID",101)
 ;;=W:$P(^(0),"^",10)]"" "   ",$P(^(0),U,10),*7
 ;;^DD(50,0,"ID",102)
 ;;=W:$D(^(2)) "   ",$P(^(2),U,2)
 ;;^DD(50,0,"IX","AB",50.0441,.01)
 ;;=
 ;;^DD(50,0,"IX","AC",50,2)
 ;;=
 ;;^DD(50,0,"IX","ACLOZ",50,17.5)
 ;;=
 ;;^DD(50,0,"IX","AD",50,201)
 ;;=
 ;;^DD(50,0,"IX","AE",50,202)
 ;;=
 ;;^DD(50,0,"IX","AEXP",50,17.1)
 ;;=
 ;;^DD(50,0,"IX","AF",50,201.3)
 ;;=
 ;;^DD(50,0,"IX","AFA",50.065,.01)
 ;;=
 ;;^DD(50,0,"IX","AI",50,100)
 ;;=
 ;;^DD(50,0,"IX","AIU",50,63)
 ;;=
 ;;^DD(50,0,"IX","AIUU",50,.01)
 ;;=
 ;;^DD(50,0,"IX","AP",50,64)
 ;;=
 ;;^DD(50,0,"IX","APC",50,64)
 ;;=
 ;;^DD(50,0,"IX","APCC",50,2)
 ;;=
 ;;^DD(50,0,"IX","APN",50,64)
 ;;=
 ;;^DD(50,0,"IX","APN1",50,20)
 ;;=
 ;;^DD(50,0,"IX","APN2",50,22)
 ;;=
 ;;^DD(50,0,"IX","AR",50,100)
 ;;=
 ;;^DD(50,0,"IX","AUDAP",50,.01)
 ;;=
 ;;^DD(50,0,"IX","AV1",50,200)
 ;;=
 ;;^DD(50,0,"IX","AV2",50,201)
 ;;=
 ;;^DD(50,0,"IX","B",50,.01)
 ;;=
 ;;^DD(50,0,"IX","C",50.1,.01)
 ;;=
 ;;^DD(50,0,"IX","IU",50,63)
 ;;=
 ;;^DD(50,0,"IX","IV",50.03,.01)
 ;;=
 ;;^DD(50,0,"IX","IV1",50,204)
 ;;=
 ;;^DD(50,0,"IX","IV2",50,201.1)
 ;;=
 ;;^DD(50,0,"IX","VAC",50,25)
 ;;=
 ;;^DD(50,0,"IX","XATC",50,212.2)
 ;;=
 ;;^DD(50,0,"IX","ZATC",50,212.2)
 ;;=
 ;;^DD(50,0,"NM","DRUG")
 ;;=
 ;;^DD(50,0,"PT",2.55,.01)
 ;;=
 ;;^DD(50,0,"PT",50,62.05)
 ;;=
 ;;^DD(50,0,"PT",50.065,.01)
 ;;=
 ;;^DD(50,0,"PT",52,6)
 ;;=
 ;;^DD(50,0,"PT",58.11,.01)
 ;;=
 ;;^DD(50,0,"PT",58.3,.01)
 ;;=
 ;;^DD(50,0,"PT",58.52,.01)
 ;;=
 ;;^DD(50,0,"PT",58.8001,.01)
 ;;=
 ;;^DD(50,0,"PT",58.81,4)
 ;;=
 ;;^DD(50,0,"PT",58.85,3)
 ;;=
 ;;^DD(50,0,"PT",58.86,1)
 ;;=
 ;;^DD(50,0,"PT",58.87,4)
 ;;=
 ;;^DD(50,0,"PT",59,.52)
 ;;=
 ;;^DD(50,0,"PT",59.7,70)
 ;;=
 ;;^DD(50,0,"PT",100.1,.01)
 ;;=
 ;;^DD(50,.01,0)
 ;;=GENERIC NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>40!($L(X)<1)!'(X'?1P.E)!(X'?.ANP) X
 ;;^DD(50,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(50,.01,1,1,0)
 ;;=50^B
 ;;^DD(50,.01,1,1,1)
 ;;=S ^PSDRUG("B",$E(X,1,40),DA)=""
 ;;^DD(50,.01,1,1,2)
 ;;=K ^PSDRUG("B",$E(X,1,40),DA)
 ;;^DD(50,.01,1,3,0)
 ;;=50^AUDAP^MUMPS
 ;;^DD(50,.01,1,3,1)
 ;;=I '$D(PSGINITF) S ^PSDRUG("AUDAP")=$S($D(^PS(59.7,1,20)):$P(^(20),"^"),1:"")
 ;;^DD(50,.01,1,3,1.1)
 ;;=S X=Y(0) S Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$P(Y(1),U,1) S XMB(1)=X
 ;;^DD(50,.01,1,3,1.2)
 ;;=S X=Y(0) S Y(2)=$C(59)_$S($D(^DD(50,51,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,9)_":",2),$C(59),1) S XMB(2)=X
 ;;^DD(50,.01,1,3,1.3)
 ;;=S X=Y(0) S Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$S('$D(^PS(50.5,+$P(Y(1),U,2),0)):"",1:$P(^(0),U,1)) S XMB(3)=X
 ;;^DD(50,.01,1,3,1.4)
 ;;=S X=Y(0) S Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$P(Y(1),U,10) S XMB(4)=X
 ;;^DD(50,.01,1,3,2)
 ;;=Q
 ;;^DD(50,.01,1,3,2.2)
 ;;=S X=Y(0) S Y(2)=$C(59)_$S($D(^DD(50,51,0)):$P(^(0),U,3),1:""),Y(1)=$S($D(^PSDRUG(D0,0)):^(0),1:"") S X=$P($P(Y(2),$C(59)_$P(Y(1),U,9)_":",2),$C(59),1) S XMB(2)=X
