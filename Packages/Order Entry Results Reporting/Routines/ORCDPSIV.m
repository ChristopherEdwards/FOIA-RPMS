ORCDPSIV ;SLC/MKB-Pharmacy IV dialog utilities ;11/25/02  09:47
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**4,38,48,158**;Dec 17, 1997
PROVIDER ; -- Check provider, if authorized to write med orders
 I $D(^XUSEC("OREMAS",DUZ)),'$$GET^XPAR("ALL","OR OREMAS MED ORDERS") W $C(7),!!,"OREMAS key holders may not enter medication orders." S ORQUIT=1 Q
 N PS,NAME S PS=$G(^VA(200,+$G(ORNP),"PS")),NAME=$P($G(^(20)),U,2)
 I '$L(NAME) S NAME=$P(^VA(200,+$G(ORNP),0),U)
 I '$P(PS,U) W $C(7),!!,NAME_" is not authorized to write medication orders!" S ORQUIT=1
 I $P(PS,U,4),$$NOW^XLFDT>$P(PS,U,4) W $C(7),!!,NAME_" is no longer authorized to write medication orders!" S ORQUIT=1
 I $G(ORQUIT) W !,"You must select another provider to continue.",! S PS=$$MEDPROV I PS S ORXNP=ORNP,ORNP=PS K ORQUIT
 Q
 ;
MEDPROV() ; -- Return ordering med provider
 N X,Y,D,DIC
 S DIC=200,DIC(0)="AEQ",DIC("A")="Select PROVIDER: ",D="AK.PROVIDER"
 S DIC("S")="I $P($G(^(""PS"")),U),'$P(^(""PS""),U,4)!($P(^(""PS""),U,4)>$$NOW^XLFDT)"
 D IX^DIC S:Y>0 Y=+Y I Y'>0 S Y="^"
 Q Y
 ;
CHANGED(TYPE) ; -- Kill dependent values when OI changes
 N PROMPTS,NAME,PTR,P,I
 Q:'$L($G(TYPE))  S PROMPTS=""
 S:TYPE="B" PROMPTS="VOLUME"
 S:TYPE="A" PROMPTS="STRENGTH PSIV^UNITS"
 F P=1:1:$L(PROMPTS,U) S NAME=$P(PROMPTS,U,P) D
 . S PTR=$O(^ORD(101.41,"AB","OR GTX "_NAME,0)) Q:'PTR
 . S I=0 F  S I=$O(ORDIALOG(PTR,I)) Q:I'>0  K ORDIALOG(PTR,I)
 . K ORDIALOG(PTR,"LIST")
 Q
 ;
INACTIVE(TYPE) ; -- Check OI inactive date
 N OI,X,I,PSOI,DEA S:$G(TYPE)'="A" TYPE="S"
 S OI=+$G(ORDIALOG(PROMPT,INST)) Q:OI'>0
 I $G(^ORD(101.43,OI,.1)),^(.1)'>$$NOW^XLFDT D  Q  ;inactive
 . S X=$S(TYPE="A":"additive",1:"solution"),ORQUIT=1
 . W $C(7),!,"This "_X_" may not be ordered anymore.  Please select another."
 S I=$S(TYPE="A":4,1:3) I '$P($G(^ORD(101.43,OI,"PS")),U,I) D  Q
 . S X=$S(TYPE="A":"an additive",1:"a solution"),ORQUIT=1
 . W $C(7),!,"This item may not be ordered as "_X_"."
 Q:'$$INPT^ORCD  Q:'$L($T(IVDEA^PSSUTIL1))  ;DBIA #3784
 S PSOI=+$P($G(^ORD(101.43,OI,0)),U,2)
 S DEA=$$IVDEA^PSSUTIL1(PSOI,TYPE) I DEA>0 D  Q:$G(ORQUIT)
 . I $G(ORNP),'$L($P($G(^VA(200,+ORNP,"PS")),U,2)),'$L($P($G(^("PS")),U,3)) W $C(7),!,$P($G(^(0)),U)_" must have a DEA# or VA# to order this drug!" S ORQUIT=1 Q
 . I DEA=1 W $C(7),!,"This order will require a wet signature!"
 Q
 ;
VOLUME ; -- get allowable volumes for solution
 N PSOI,ORY,CNT,I K ORDIALOG(PROMPT,"LIST")
 S PSOI=+$P($G(^ORD(101.43,+$$VAL^ORCD("SOLUTION",INST),0)),U,2)_"B"
 D ENVOL^PSJORUT2(PSOI,.ORY) Q:'ORY
 S (I,CNT)=0 F  S I=$O(ORY(I)) Q:I'>0  S CNT=CNT+1,ORDIALOG(PROMPT,"LIST",+ORY(I))=+ORY(I)
 S ORDIALOG(PROMPT,"LIST")=CNT_"^1"
 Q
 ;
UNITS ; -- get allowable units for current additive
 N PSOI,ORY,I,UNITS
 S PSOI=+$P(^ORD(101.43,+ORDIALOG($$PTR^ORCD("OR GTX ADDITIVE"),INST),0),U,2)_"A"
 D ENVOL^PSJORUT2(PSOI,.ORY)
 S I=$O(ORY(0)) Q:'I  S UNITS=$P($G(ORY(I)),U,2)
 S ORDIALOG($$PTR^ORCD("OR GTX UNITS"),INST)=UNITS
 W !," (Units for this additive are "_UNITS_")"
 Q
 ;
PREMIX() ; -- Returns 1 or 0, if IV base is a premix solution
 N BASE,PS,I,Y
 S BASE=$$PTR^ORCD("OR GTX ORDERABLE ITEM"),Y=0
 S I=0 F  S I=$O(ORDIALOG(BASE,I)) Q:I'>0  D  Q:Y
 . S PS=$G(^ORD(101.43,+$G(ORDIALOG(BASE,I)),"PS"))
 . I $P(PS,U,3)&($P(PS,U,4)) S Y=1
 Q Y
 ;
VALIDAYS(X) ; -- Validate IV duration
 N UNITS,X1,X2,Y,I
 I X'?1.N." "1.A Q 0 ; invalid format
 S UNITS="^MIN^HOURS^DAYS^M^H^D^",(X1,X2)=""
 F I=1:1:$L(X) S Y=$E(X,I) S:Y?1N X1=X1_Y S:Y?1A X2=X2_$$UP^XLFSTR(Y)
 I 'X1 Q 0
 I UNITS'[(U_X2_U) Q 0
 Q 1
