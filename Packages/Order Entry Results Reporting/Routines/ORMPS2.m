ORMPS2 ;SLC/MKB - Process Pharmacy ORM msgs cont;10:53 AM  16 May 2001 [9/28/01 1:50pm]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**94,116,129,134,186,190**;Dec 17, 1997
 ;
FINISHED()      ; -- new order [SN^ORMPS] due to finishing?
 N Y,ORIG,TYPE,ORIG4 S Y=0
 S ORIG=+$P(ZRX,"|",2),TYPE=$P(ZRX,"|",4),ORIG4=$G(^OR(100,ORIG,4))
 I ORIG,TYPE="E",ORIG4?1.N1"P"!(ORIG4?1.N1"S") S ORIFN=+ORIG,Y=1
 Q Y
 ;
WPX() ; -- Compare comments in @ORMSG@(NTE) with order ORIFN
 ;     Returns 1 if different, or 0 if same
 N NTE,SPINST,Y,I,J,X,X1 S Y=0
 S NTE=+$$NTE^ORMPS1(21),SPINST=$S(NTE:$P(@ORMSG@(NTE),"|",4),1:"")
 S I=+$O(^OR(100,+ORIFN,4.5,"ID","COMMENT",0)) I I'>0 S:$L(SPINST) Y=1 G WQ
 S X=$G(^OR(100,+ORIFN,4.5,I,2,1,0)) ;1st line
 I '$O(^OR(100,+ORIFN,4.5,I,2,1)) S:X'=SPINST Y=1 G WQ
 S J=1 F  S J=$O(^OR(100,+ORIFN,4.5,I,2,J)) Q:J'>0  S X1=$G(^(J,0)) D  Q:$L(X)'<240
 . I ($L(X)+$L(X1)+1)'>240 S X=X_" "_X1 Q
 . S X=X_" "_$E(X1,1,239-$L(X))
 S:X'=SPINST Y=1 ;changed
WQ Q Y
 ;
IVX() ; -- Compare ORMSG to Inpt order ORIFN if IV, return 0 if 'diff or 'IV
 N Y,RXC,DG,OI,PSOI,XC,RATE,ORA,ORB,ORX,I,J,OI0,INST,VOL,STR,UNT
 S RXC=$$RXC^ORMPS,Y=0 I RXC'>0 Q Y  ;not IV of any kind
 S DG=+$P($G(^OR(100,+ORIFN,0)),U,11),DG=$P($G(^ORD(100.98,DG,0)),U,3)
 I DG'="IV RX",DG'="TPN" D  Q Y  ;not fluid
 . I $P(ZRX,"|",7)'="" S Y=1 Q
 . I $$NUMADDS^ORMPS1>1 S Y=1 Q
 . S OI=$$VALUE("ORDERABLE"),PSOI=+$P($G(^ORD(101.43,+OI,0)),U,2)
 . S XC=@ORMSG@(RXC) I PSOI'=$P(XC,U,4) S Y=1 Q
 . N X1,X2,X3 S X1=$P(XC,"|",4),X2=$P($P(XC,"|",5),U,5)
 . S X3=$$VALUE("INSTR") I (X1_X2)'=X3,(X1_" "_X2)'=X3 S Y=1 Q
IV1 S RATE=$$FIND^ORM(+RXE,24),UNT=$P($$FIND^ORM(+RXE,25),U,5)
 S:$L(UNT) RATE=RATE_" "_UNT I RATE'=$$VALUE("RATE") S Y=1 Q Y
 S ORB=+$$PTR("ORDERABLE ITEM"),ORA=+$$PTR("ADDITIVE"),I=+RXC
 F  S XC=@ORMSG@(I) Q:$E(XC,1,3)'="RXC"  D  S I=$O(@ORMSG@(I)) Q:I'>0
 . S ORX($P(XC,"|",2),+$P(XC,U,4))=$P(XC,"|",4)_U_$P($P(XC,"|",5),U,5)
 . ;ORX("A",PSOI)=str^units or ORX("B",PSOI)=volume^units
 F I="STRENGTH","UNITS","VOLUME" D  ;ORX(I,inst)=value
 . S J=0 F  S J=$O(^OR(100,+ORIFN,4.5,"ID",I,J)) Q:J'>0  D
 .. S INST=+$P($G(^OR(100,+ORIFN,4.5,J,0)),U,3)
 .. S:INST ORX(I,INST)=$G(^OR(100,+ORIFN,4.5,J,1))
 S I=0 F  S I=$O(^OR(100,+ORIFN,4.5,"ID","ORDERABLE",I)) Q:I'>0  D  Q:Y
 . S OI0=$G(^OR(100,+ORIFN,4.5,I,0)),OI=+$G(^(1))
 . S PSOI=+$P($G(^ORD(101.43,OI,0)),U,2)
 . I $P(OI0,U,2)=ORA,$G(ORX("A",PSOI)) D  Q
 .. S INST=$P(OI0,U,3),STR=+ORX("A",PSOI),UNT=$P(ORX("A",PSOI),U,2)
 .. I STR'=$G(ORX("STRENGTH",INST)) S Y=1 Q
 .. I UNT'=$G(ORX("UNITS",INST)) S Y=1 Q
 .. K ORX("A",PSOI) ;same
 . I $P(OI0,U,2)=ORB,$G(ORX("B",PSOI)) D  Q
 .. S INST=$P(OI0,U,3),VOL=+$G(ORX("B",PSOI))
 .. I VOL'=$G(ORX("VOLUME",INST)) S Y=1 Q
 .. K ORX("B",PSOI) ;same
 . S Y=1
 I $O(ORX("A",0))!$O(ORX("B",0)) S Y=1 ;leftover items - changed
 Q Y
 ;
CHANGED()       ; -- Compare ORMSG to order ORIFN, return 1 if different
 N X,Y,X1,ZSC,NTE,SIG,PI S Y=0
 I $G(ORCAT)="I" D  G CHQ
 . I $$WPX S Y=1 Q  ;Special Instructions
 . ;S X=$$VALUE("DAYS") ;duration
 . ;I X S X1=$$DURATION^ORMPS1($P($G(ORQT(1)),U,3)) I X'=X1 S Y=1 Q
 . I $$IVX S Y=1 Q  ;IV fields
 S X=$P($P(RXE,"|",3),U,4) I X'=$$VALUE("DRUG") S Y=1 G CHQ
 I $P(RXE,"|",11)'=$$VALUE("QTY") S Y=1 G CHQ
 I $P(RXE,"|",13)'=$$VALUE("REFILLS") S Y=1 G CHQ
 S X=$P(RXE,"|",23) S:$E(X)="D" X=+$E(X,2,99) I X'=$$VALUE("SUPPLY") S Y=1 G CHQ
 I $P(ZRX,"|",5)'=$$VALUE("PICKUP") S Y=1 G CHQ
 S NTE=$$NTE^ORMPS1(21),SIG=+$O(^OR(100,+ORIFN,4.5,"ID","SIG",0)) ;verb
 I NTE,SIG,$P($P(@ORMSG@(NTE),"|",4)," ")'=$P($G(^OR(100,+ORIFN,4.5,SIG,2,1,0))," ") S Y=1 G CHQ
 S NTE=$$NTE^ORMPS1(7),PI=+$O(^OR(100,+ORIFN,4.5,"ID","PI",0))
 I (NTE&'PI)!('NTE&PI) Q 1 ;added or deleted
 I NTE,PI,$P(@ORMSG@(NTE),"|",4)'=$G(^OR(100,+ORIFN,4.5,PI,2,1,0)) S Y=1 G CHQ
 Q:'$P($G(^OR(100,+ORIFN,8,0)),U,3)
 N LSTACT,PREPRV,CURPRV S LSTACT="?",(PREPRV,CURPRV)=0
 F  S LSTACT=$O(^OR(100,+ORIFN,8,LSTACT),-1) Q:LSTACT
 S PREPRV=$P($G(^OR(100,+ORIFN,8,LSTACT,0)),U,3)
 S CURPRV=$P($G(ORC),"|",13)
 I (PREPRV'=CURPRV) S Y=1 G CHQ
CHQ Q Y
 ;
VALUE(ID)       ; -- Return value of ID in ^OR(100,+ORIFN,4.5,"ID")
 N I,Y I '$L($G(ID)) Q ""
 S I=+$O(^OR(100,+ORIFN,4.5,"ID",ID,0))
 S Y=$G(^OR(100,+ORIFN,4.5,I,1))
 Q Y
 ;
PTR(X) ; -- Return ptr to prompt OR GTX X
 Q +$O(^ORD(101.41,"AB","OR GTX "_X,0))
 ;
RO ; -- Replacement order (finished)
 ;
 N RXO,RXC,ORDIALOG,ORDG,ORPKG,ORDA,ORX,ORSIG,ORP,ZSC,NEWSTS
 K ^TMP("ORWORD",$J)
 I '$D(^VA(200,ORNP,0)) S ORERR="Missing or invalid ordering provider" Q
 I 'RXE S ORERR="Missing or invalid RXE segment" Q
 S RXO=$$RXO^ORMPS,RXC=$$RXC^ORMPS,ORIFN=+$G(ORIFN)
 I ORIFN'>0 S ORERR="Missing or invalid order number" Q
 D @($S(RXC:"IV",$G(ORCAT)="I":"UDOSE",1:"OUT")_"^ORMPS1") Q:$D(ORERR)
 S ORDA=$$ACTION^ORCSAVE("XX",ORIFN,ORNP,"",ORNOW,ORWHO)
 I ORDA'>0 S ORERR="Cannot create new order action" Q
RO1 ; -Update sts of order to active, last action to dc/edit:
 S ORX=ORDA F  S ORX=+$O(^OR(100,ORIFN,8,ORX),-1) Q:ORX'>0  I $D(^(ORX,0)),$P(^(0),U,15)="" Q  ;ORX=last released action
 S:ORX $P(^OR(100,ORIFN,8,ORX,0),U,15)=12 ;dc/edit
 S $P(^OR(100,ORIFN,3),U,7)=ORDA,NEWSTS=$S('$G(ORSTS):0,ORSTS=$P(^(3),U,3):0,1:1) K ^(6)
 D STATUS^ORCSAVE2(ORIFN,ORSTS):NEWSTS,SETALL^ORDD100(ORIFN):'NEWSTS
 D DATES^ORCSAVE2(ORIFN,ORSTRT,ORSTOP)
 D RELEASE^ORCSAVE2(ORIFN,ORDA,ORNOW,ORWHO,ORNATR)
 ; -If unsigned edit, leave XX unsigned & mark ORX as Sig Not Req'd
 S ORSIG=$S($P($G(^OR(100,ORIFN,8,ORX,0)),U,4)'=2:1,1:0)
 D SIGSTS^ORCSAVE2(ORIFN,ORDA):ORSIG,SIGN^ORCSAVE2(ORIFN,,,5,ORX):'ORSIG
RO2 ; -Update responses, get/save new order text:
 K ^OR(100,ORIFN,4.5) D RESPONSE^ORCSAVE,ORDTEXT^ORCSAVE1(ORIFN_";"_ORDA)
 S $P(^OR(100,ORIFN,0),U,5)=ORDIALOG_";ORD(101.41,",$P(^(0),U,14)=ORPKG
 I $P(^OR(100,ORIFN,0),U,11)'=ORDG D  ;update DG,xrefs
 . N DA,DR,DIE
 . S DA=ORIFN,DR="23////"_ORDG,DIE="^OR(100," D ^DIE
 S ^OR(100,ORIFN,4)=PKGIFN,$P(^(8,ORDA,0),U,14)=ORDA
 S ORIFN=ORIFN_";"_ORDA,ORDCNTRL="SN" ;to send NA msg back
 I $G(ORL) S ORP(1)=ORIFN_"^1" D PRINTS^ORWD1(.ORP,+ORL)
 I $G(ORCAT)="O" S ZSC=$$ZSC^ORMPS1 I ZSC,$P(ZSC,"|",2)'?2.3U S ^OR(100,+ORIFN,5)=$TR($P(ZSC,"|",2,7),"|","^") ;1 or 0 instead of [N]SC in #100
 Q
