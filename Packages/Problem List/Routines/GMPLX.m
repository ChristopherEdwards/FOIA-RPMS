GMPLX ; ISL/MKB,AJB,JER -- Problem List Problem Utilities ;06/08/12  17:01
 ;;2.0;Problem List;**7,23,26,28,27,36**;Aug 25, 1994;Build 65
 ;
 ; External References
 ;  DBIA   446 ^AUTNPOV(
 ;  DBIA  3990  $$ICDDX^ICDCODE & $$CODEN^ICDCODE
 ;  DBIA 10060 ^VA(200
 ;  DBIA 10006 ^DIC
 ;  DBIA 10009 FILE^DICN
 ;  DBIA 10013 EN^DIK
 ;  DBIA 10013 IX1^DIK
 ;  DBIA 10026 ^DIR
 ;  DBIA  1609 CONFIG^LEXSET
 ;  DBIA 10103 $$FMTE^XLFDT
 ;  DBIA 10104 $$UP^XLFSTR
 ;  DBIA  2742 GMPLX
 ;  DBIA  3991 $$STATCHK^ICDAPIU
 ;
SEARCH(X,Y,PROMPT,UNRES,VIEW) ; Search Lexicon for Problem X
 N DIC S:'$L($G(VIEW)) VIEW="PLS" D CONFIG^LEXSET("GMPX",VIEW,DT)
 S DIC("A")=$S($L($G(PROMPT)):PROMPT,1:"Select PROBLEM: ")
 S DIC="^LEX(757.01,",DIC(0)=$S('$L($G(X)):"A",1:"")_"EQM"
 S:'$G(UNRES) LEXUN=0 D ^DIC
 I +Y>1 D
 .N CODE,SRC
 .S X=$P(Y,U,2)
 .D EXP2CODE(+Y,.SRC,.CODE)
 .I (SRC["SNOMED")!(SRC["VHAT") S (X,$P(Y,U,2))=X_" ("_$S(SRC["SNOMED":"SCT",1:"VHAT")_" "_CODE_")",Y(1)=$$GETDX(CODE,SRC)
 Q
 ;
PROVNARR(X,CL) ; Returns IFN ^ Text of Narrative (#9999999.27)
 N DIC,Y,DLAYGO,DD,DO,DA S:$L(X)>245 X=$E(X,1,245)
 S DIC="^AUTNPOV(",DIC(0)="L",DLAYGO=9999999.27,(DA,Y)=0
 F  S DA=$O(^AUTNPOV("B",$E(X,1,30),DA)) Q:DA'>0  I $P(^AUTNPOV(DA,0),U)=X S Y=DA_U_X Q
 I '(+Y) K DA,Y D FILE^DICN S:Y'>0 Y=U_X I Y>0,CL>1 S ^AUTNPOV(+Y,757)=CL
 Q $P(Y,U,1,2)
 ;
PROBTEXT(IFN) ; Returns Display Text
 N X,Y,ICD,SCTC,GMPL0,GMPL800,GMPLEXP,GMPLPOV,GMPLSO,GMPLTXT
 S GMPL0=$G(^AUPNPROB(IFN,0)),GMPL800=$G(^(800))
 I '$L(GMPL0) S X="" G PROBTX
 S ICD=$P($$ICDDX^ICDCODE(+GMPL0),U,2),SCTC=$P(GMPL800,U)
 S Y=$P($G(^AUPNPROB(+IFN,0)),U,5),X=$P($G(^AUTNPOV(+Y,0)),U)
 S GMPLEXP=$$EP(IFN),GMPLSO=$$CS(X),GMPLPOV=$$PT(X,GMPLSO)
 S GMPLTXT=GMPLPOV S:$L(GMPLEXP) GMPLTXT=GMPLTXT_" ("_GMPLEXP_")"
 ;S:$L(GMPLSO)&(GMPLSO'["SNOMED") GMPLTXT=GMPLTXT_" "_GMPLSO
 S:GMPLTXT["*" GMPLTXT=$TR(GMPLTXT,"*","")
 ;S:$L(GMPLTXT) GMPLTXT=GMPLTXT_" ("_$$HFP^GMPLUTL4_","_$$PTR^GMPLUTL4_")"
 S:$L(GMPLTXT) GMPLTXT=GMPLTXT_$S($L($G(ICD))&('$L($G(SCTC))):" (ICD-9-CM "_$G(ICD)_")",$L($G(SCTC)):" (SCT "_$G(SCTC)_")",1:"")
 S:$L(GMPLTXT) X=GMPLTXT
PROBTX Q X
PROBNARR(IFN) ; Returns Provider Narrative
 N X,Y S Y=$P($G(^AUPNPROB(+IFN,0)),U,5),X=$P($G(^AUTNPOV(+Y,0)),U)
 Q X
CS(X) ; Problem Codes
 N GMPLSAB,GMPLSO S GMPLSO="" S X=$G(X) Q:X'["(" ""
 F GMPLSAB="ICD-","CPT-","DSM-","HCPCS","NANDA","NIC","NOC","LOINC","SNOMED","OMAHA","SCT" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 F GMPLSAB="ACR","AI/RHEUM","CONGRESS","COSTAR","COSTART","CRISP","DODFAC" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 F GMPLSAB="DORLAND","DXPLAIN","HHCC","MCMASTER","META","MTF","MeSH","RVC","TITLE 38","UMDNS","UWA" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 Q ""
EP(X) ; Exposures
 N GMPLSC S X=+($G(X)) D SCS^GMPLX1(+X,.GMPLSC) S X=$G(GMPLSC(1)) Q X
PT(X,C) ; Problem Text (only)
 N GMPLTERM,GMPLSO S GMPLTERM=$G(X),GMPLSO=$G(C)
 S:$L(GMPLSO)&(GMPLTERM[GMPLSO) GMPLTERM=$P(GMPLTERM,GMPLSO,1) S GMPLTERM=$$TRIM(GMPLTERM)
 S:$L(GMPLTERM) X=GMPLTERM Q X
TRIM(X) ; Trim Spaces and "*"
 S X=$G(X) F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,$L(X))'="*"  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 Q X
WRAP(PROB,MAX,TEXT) ; Splits Text into TEXT array
 N I,J S J=0 K TEXT I $L(PROB)'>MAX S J=J+1,TEXT(J)=PROB G WRQ
WR0 ;   Loop for Remaining Text
 S I=$F(PROB," ") I ('I)!(I>(MAX+2)) S J=J+1,TEXT(J)=$E(PROB,1,MAX),PROB=$E(PROB,MAX+1,999)
 I $L(PROB)>MAX F I=(MAX+1):-1:1 I $E(PROB,I)=" " S J=J+1,TEXT(J)=$E(PROB,1,I-1),PROB=$E(PROB,I+1,999) Q
 G:$L(PROB)>MAX WR0
 S:$L(PROB) J=J+1,TEXT(J)=PROB
WRQ ;   Quit Wrap
 S TEXT=J
 Q
 ;
NOS() ; Return PTR ^ 799.9 ICD code
 Q +$$CODEN^ICDCODE("799.9",80)_"^799.9"
 ;
SEL(HELP) ; Select List of Problems
 N X,Y,DIR,MAX S MAX=+$G(^TMP("GMPL",$J,0)) I MAX'>0 Q "^"
 S DIR(0)="LAO^1:"_MAX,DIR("A")="Select Problem(s)"
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 S DIR("?")="Enter the problems you wish to "
 S DIR("?")=DIR("?")_$S($L(HELP):HELP,1:"act on")_", as a range or list of numbers"
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
SEL1(HELP) ; Select 1 Problem
 N X,Y,DIR,MAX S MAX=+$G(^TMP("GMPL",$J,0)) I MAX'>0 Q "^"
 S DIR(0)="NAO^1:"_MAX_":0",DIR("A")="Select Problem"
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 S DIR("?")="Enter the number of the problem you wish to "
 S DIR("?")=DIR("?")_$S($L(HELP):HELP,1:"act on")
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
DUPL(DFN,TERM,TEXT) ; Check for Duplicates
 N DA,IFN S DA=0,TEXT=$$UP^XLFSTR($S(TEXT["SCT":$P(TEXT," (SCT"),1:TEXT))
 I '$D(^AUPNPROB("AC",DFN)) G DUPLX
 F IFN=0:0 S IFN=$O(^AUPNPROB("AC",DFN,IFN)) Q:IFN'>0  D  Q:DA>0
 .N PICDOLD,PICDNEW,NODE0,NODE1,NODE800,NODE803,SCTD,PROVNAR,EXPTXT,GMPSRC,GMPCODE
 .S NODE0=$G(^AUPNPROB(IFN,0)),NODE1=$G(^(1)),NODE800=$G(^(800)),NODE803=$G(^(803,0)) Q:$P(NODE1,U,2)="H"
 .D EXP2CODE(TERM,.GMPSRC,.GMPCODE)
 .;Problem has SNOMED CT concept code & term is SNOMED CT concept
 .I +NODE800,(GMPSRC="SNOMED CT"),(+$G(GMPCODE)>0) D  Q
 ..;if SCT concepts match => dup
 .. I +NODE800=GMPCODE S DA=IFN Q
 .;if Exprs match => dup
 .I TERM>1&(+NODE1=TERM) S DA=IFN Q
 .;if Text matches Expr from old => dup
 .D LOOK^LEXA("`"_+NODE1)
 .S EXPTXT=$P($G(LEX("LIST",1)),U,2)
 .I LEX>1&(TEXT=$$UP^XLFSTR($S(EXPTXT["*":$P(EXPTXT," *"),1:EXPTXT))) S DA=IFN Q
 .;if Text matches Prov Narr of old => dup
 .S PROVNAR=$P(^AUTNPOV($P(NODE0,U,5),0),U)
 .I TEXT=$$UP^XLFSTR($S(PROVNAR["SNOMED":$P(PROVNAR," (SN"),PROVNAR[" *":$P(PROVNAR,"*"),1:PROVNAR)) S DA=IFN Q
 .;if prim ICD of new = prim/sec ICD of old => dup
 .S PICDOLD=$P($$ICDDX^ICDCODE(+NODE0),U,2)
 .S PICDNEW=$S(GMPSRC="SNOMED CT":$P($$GETDX(GMPCODE,GMPSRC),"/",1),1:GMPCODE)
 .;if prim ICD of new = prim ICD of old => dup
 .I PICDNEW=PICDOLD&(PICDOLD'="799.9"!(PICDNEW'="799.9")) S DA=IFN Q
 .I $L($G(NODE803))>0!($L($$GETDX(GMPCODE,GMPSRC),"/")>1) D
 ..N I,J,SICDNEW S J=0 F I=2:1:$L($$GETDX(GMPCODE,GMPSRC),"/") D
 ...S J=J+1,SICDNEW(J)=$P($$GETDX(GMPCODE,GMPSRC),"/",I)
 ..;if prim ICD of new = sec ICD of old => dup
 ..N IEN S IEN=0 F  S IEN=$O(^AUPNPROB(IFN,803,IEN)) Q:'+IEN  D
 ...I PICDNEW=$P($G(^AUPNPROB(IFN,803,IEN,0)),U) S DA=IFN Q
 ..N T F T=1:1:J D
 ...N IEN S IEN=0 F  S IEN=$O(^AUPNPROB(IFN,803,IEN)) Q:'+IEN  D
 ....;if sec ICD of new = prim ICD of old => dup
 ....I SICDNEW(T)=PICDOLD S DA=IFN Q
 ....;if sec ICD of new = sec ICD of old => dup
 ....I SICDNEW(T)=$P($G(^AUPNPROB(IFN,803,IEN,0)),U) S DA=IFN Q
DUPLX Q DA
 ;
DUPLOK(IFN) ; Ask if Dup OK
 N DIR,X,Y,GMPL0,GMPL1,DATE,PROV S DIR(0)="YA",GMPL0=$G(^AUPNPROB(IFN,0)),GMPL1=$G(^(1))
 S DIR("A")="Are you sure you want to continue? ",DIR("B")="NO"
 S DIR("?",1)="Enter YES if you want to duplicate this problem on this patient's list;",DIR("?")="press <return> to re-enter the problem name."
 W $C(7),!!,">>>  "_$$PROBTEXT(IFN),!?5,"is already an "
 W $S($P(GMPL0,U,12)="I":"IN",1:"")_"ACTIVE problem on this patient's list!",!
 S PROV=+$P(GMPL1,U,5) W:PROV !?5,"Provider: "_$P($G(^VA(200,PROV,0)),U)_" ("_$P($$SERVICE^GMPLX1(PROV),U,2)_")"
 I $P(GMPL0,U,12)="A" W !?8,"Onset: " S DATE=$P(GMPL0,U,13)
 I $P(GMPL0,U,12)="I" W !?5,"Resolved: " S DATE=$P(GMPL1,U,7)
 W $S(DATE>0:$$FMTE^XLFDT(DATE),1:"unspecified"),!
 D ^DIR W !
 Q +Y
 ;
LOCKED() ; Return Lock Msg
 Q "This problem is currently being edited by another user!"
 ;
SURE() ; Ask to Delete
 ;   Returns 1 if YES, else 0
 N DIR,X,Y S DIR(0)="YA",DIR("B")="NO"
 S DIR("?")="Enter YES to remove this value or NO to leave it unchanged."
 S DIR("A")="Are you sure you want to remove this value? " D ^DIR
 Q +Y
 ;
EXTDT(DATE) ; Format Date as MM/DD/YY
 N X,MM,DD,YY,YYY S X="",DATE=$P(DATE,".") Q:'DATE ""
 S MM=+$E(DATE,4,5),DD=+$E(DATE,6,7),YY=$E(DATE,2,3),YYY=$E(DATE,1,3)
 S:MM X=MM_"/" S:DD X=X_DD_"/" S X=$S($L(X):X_YY,1:1700+YYY)
 Q X
 ;
AUDIT(DATA,OLD) ; Make Entry in Audit File
 ; DATA = string for 0-node
 ; OLD  = string for 1-node
 ;      = 0-node from reform/react problem
 N DA,DD,DO,DIC,X,Y,DIK,DLAYGO
 S DIC="^GMPL(125.8,",DIC(0)="L",X=$P(DATA,U),DLAYGO=125.8
 D FILE^DICN Q:+Y'>0  S DA=+Y,DIK="^GMPL(125.8,"
 S ^GMPL(125.8,DA,0)=DATA D IX1^DIK
 S:$L(OLD) ^GMPL(125.8,DA,1)=OLD
 Q
 ;
DTMOD(DA) ; Update Date Modified
 N DIE,DR
 S DR=".03///TODAY",DIE="^AUPNPROB("
 D ^DIE
 ; broadcast problem change events
 N GMPIFN,DFN,X
 S GMPIFN=DA,DFN=+$P($G(^AUPNPROB(DA,0)),U,2)
 S X=+$O(^ORD(101,"B","GMPL EVENT",0))_";ORD(101," D:X EN1^XQOR
 Q
 ;
MSG() ; ListMan Msg Bar
 Q "+ Next Screen  - Prev Screen  ?? More actions"
 ;
KILL ; Clean-Up Vars
 K X,Y,DIC,DIE,DR,DA,DUOUT,DTOUT,GMPQUIT,GMPRT,GMPSAVED,GMPIFN,GMPLNO,GMPLNUM,GMPLSEL,GMPREBLD,GMPI,GMPLSLST,GMPLJUMP
 Q
 ;
CODESTS(PROB,ADATE) ;check status of ICD
 ; Input:
 ;  PROB  = pointer to the PROBLEM (#9000011) file
 ;  ADATE = FM date on which to check the status (opt.)
 ;
 ; Output:
 ;  1 = ACTIVE on the date passed or current date
 ;  0 = INACTIVE on the date passed or current date
 ;
 I '$G(ADATE) S ADATE=DT
 I '$D(^AUPNPROB(PROB,0)) Q 0
 S PROB=$P(^AUPNPROB(PROB,0),U)
 Q +$$STATCHK^ICDAPIU($P($$ICDDX^ICDCODE(+PROB),U,2))
EXP2CODE(X,GMPSRC,GMPCODE) ; Resolve SOURCE and CODE from Expression
 N LEX,SRCCODE,GMI S GMI=0,(GMPSRC,GMPCODE)=""
 D INFO^LEXA(X,DT)
 F  S GMI=$O(LEX("SEL","SRC",GMI)) Q:+GMI'>0  D  Q:($G(GMPSRC)]"")
 . S SRCCODE=$P($G(LEX("SEL","SRC",GMI)),U,1,2)
 . I $P(SRCCODE,U)["SNOMED"!($P(SRCCODE,U)["VHAT") S GMPSRC=$P(SRCCODE,U),GMPCODE=$P(SRCCODE,U,2)
 Q
GETDX(CODE,CODESYS) ; Get ICD associated with SCT or VHAT Code
 N LEX,GMPI,GMPY S GMPY=0
 I CODESYS["VHAT" S GMPY=$$GETASSN^LEXTRAN1(CODE,"VHAT2ICD") I 1
 E  S GMPY=$$GETASSN^LEXTRAN1(CODE,"SCT2ICD")
 I $S(+GMPY'>0:1,+$P(GMPY,U,2)'>0:1,+LEX'>0:1,1:0) S GMPY=799.9 G GETDXX
 S (GMPI,GMPY)=0
 F  S GMPI=$O(LEX(GMPI)) Q:+GMPI'>0  D
 .N ICD
 .S ICD=$O(LEX(GMPI,""))
 .I ICD]"" S GMPY=$S(GMPY'=0:GMPY_"/",1:"")_ICD
 I GMPY'["." S GMPY=GMPY_"."
GETDXX Q GMPY
PAD(GMPX,GMPL) ; Pads string to specified length
 N GMPY
 S GMPY="",$P(GMPY," ",(GMPL-$L(GMPX))+1)=""
 Q GMPY
