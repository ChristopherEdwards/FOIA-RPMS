ORY141ED ; SLC/MKB - EDO inits for patch OR*3*141 ;8/19/02  10:45
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**141**;Dec 17, 1997
 ;
PRE ; -- preinit: remove old DD's
 Q:$O(^ORD(101,"B","ORC DELAYED ORDERS",0))  ;not 1st install
 N DIU,ORNOW,XMDUZ,XMDUN,XMY,X,XMOUT
 S DIU="^OR(100.2,",DIU(0)="DST" D EN^DIU2 ;remove old DD
 D DELIX^DDMOD(100,.02,4),DELIX^DDMOD(100,15,1) ;remove old AEVNT xrefs
 S ORNOW=$$NOW^XLFDT K ^XTMP("ORYED")
 S ^XTMP("ORYED",0)=$$FMADD^XLFDT(ORNOW,90)_U_ORNOW_"^OR*3*141 Delay Event Conversion"
 W !!,"A mail message will be generated when the post-init conversion has completed."
 S XMDUZ=DUZ,XMDUN=$P($G(^VA(200,DUZ,0)),U) D DEST^XMA21
 I $D(XMOUT) W !!,$C(7),"Only the installer of this patch will receive the conversion bulletin!" S XMY(DUZ)=""
 M ^XTMP("ORYED","XMY")=XMY
 Q
 ;
DLGSEND(X) ; -- Send order dialog X?
 I X="LR OTHER LAB TESTS" Q 1
 I X="RA OERR EXAM" Q 1
 I X="PS MEDS" Q 1
 I X="PSJ OR PAT OE" Q 1
 I X="PSO OERR" Q 1
 I X="PSO SUPPLY" Q 1
 I X="OR GXMOVE ADMIT PATIENT" Q 1
 I X="OR GXMOVE DISCHARGE" Q 1
 I X="OR GXMOVE TRANSFER" Q 1
 I X="OR GXMOVE TREATING SPECIALTY" Q 1
 Q 0
 ;
POST ; -- postinit: convert orders, remove old parameters
 S ^ORD(100.01,10,.1)="dly"
 S ^ORD(100.01,13,1,1,0)="Orders that have been rejected by the ancillary service without being"
 S ^ORD(100.01,13,1,2,0)="acted on, or terminated while still delayed."
 K ^DIC(100.5,0,"RD"),^DIC(100.6,0,"RD") ;remove read access
 D 101,AEVNT,PARAMS,DLGS,C
 Q
 ;
AEVNT ; -- postinit: convert Event field #15 of Orders file #100
 ;    from code (A/D/T) to pointer to #100.2
 ;    (incl a report of bad data, lapsed orders)
 ;
 Q:'$D(^XTMP("ORYED","XMY"))  ;not 1st install
 N ORPARAM,ORLAPSE,ORSITE,ORVP,ORDIED,OREVT,ORIFN,OR0,OR3,ORTS,ORL,ORDIV,ORX,ORNOW,ORPTEVT
 S ORPARAM=+$$GET^XPAR("ALL","OR DELAYED ORDERS LAPSE DAYS"),ORLAPSE=0
 S:ORPARAM ORLAPSE=$$FMADD^XLFDT(DT,(0-ORPARAM)) ;=0 or cutoff date
 S ORNOW=$$NOW^XLFDT,ORSITE=+$$SITE^VASITE ;[primary] division
 S ORVP="" F  S ORVP=$O(^OR(100,"AEVNT",ORVP)) Q:ORVP=""  D
 . S ORL="",ORDIED=+$G(^DPT(+ORVP,.35)) I $L($G(^(.1))) S ORL=+$O(^DIC(42,"B",^(.1),0)),ORL=$G(^DIC(42,ORL,44))
 . F OREVT="A","T","D" S ORIFN=0 D
 .. F  S ORIFN=+$O(^OR(100,"AEVNT",ORVP,OREVT,ORIFN)) Q:ORIFN<1  D
 ... S OR0=$G(^OR(100,ORIFN,0)),OR3=$G(^(3)) I '$L($P(OR0,U,17)) D CLEAR Q
 ... S ORX=$P(OR0,U,10) S:'ORX ORX=ORL
 ... S ORDIV=$$DIV^OREVNTX(ORX) S:ORDIV<1 ORDIV=ORSITE
 ... I $P(OR3,U,3)'=10 D CLEAR,ERR(1) Q  ;discharge meds
 ... S ORTS=+$P(OR0,U,13) I OREVT'="D",ORTS<1 D STATUS^ORCSAVE2(ORIFN,13),CLEAR,ERR(2) Q  ;error
 ... I $P(OR0,U,7)<ORLAPSE D STATUS^ORCSAVE2(ORIFN,14),CLEAR,ERR(3) Q
 ... I ORDIED D CANCEL,CLEAR,ERR(4) Q
 ... S ORX=OREVT_U_$S(OREVT'="D":ORTS,1:"")_U_ORDIV
 ... S ^XTMP("ORYED","EVT",ORX)="",^(ORX,ORVP)="",^(ORVP,ORIFN)=""
 Q:'$L($O(^XTMP("ORYED","EVT","")))  ;no delayed orders to convert
AE1 S ORX="" F  S ORX=$O(^XTMP("ORYED","EVT",ORX)) Q:ORX=""  D
 . S OREVT=$$EVENT(ORX) Q:OREVT<1  S ^XTMP("ORYED","EVT",ORX)=OREVT
 . S ORVP="" F  S ORVP=$O(^XTMP("ORYED","EVT",ORX,ORVP)) Q:ORVP=""  D
 .. S ORPTEVT=$$NEW^OREVNT(+ORVP,+OREVT) Q:ORPTEVT<1
 .. S ^XTMP("ORYED","EVT",ORX,ORVP)=ORPTEVT D SET(ORVP,ORX,OREVT)
 .. S ORIFN=0 F  S ORIFN=+$O(^XTMP("ORYED","EVT",ORX,ORVP,ORIFN)) Q:ORIFN<1  D
 ... S $P(^OR(100,ORIFN,0),U,17)=ORPTEVT
 ... K ^OR(100,"AEVNT",ORVP,$P(ORX,U),ORIFN)
 ... S ^OR(100,"AEVNT",ORVP,ORPTEVT,ORIFN)=""
 D BULLETIN K ^XTMP("ORYED","XMY")
 Q
 ;
CANCEL ; -- Cancel order for deceased patient
 S ^OR(100,ORIFN,6)=$O(^ORD(100.02,"C","A",0))_U_U_ORNOW_U_+$O(^ORD(100.03,"C","ORDEATH",0))
 D STATUS^ORCSAVE2(ORIFN,13) S $P(^OR(100,ORIFN,8,1,0),U,15)=13
 Q
 ;
CLEAR ; -- Clear Event code field
 S $P(^OR(100,ORIFN,0),U,17)="" S:$P($G(^(8,1,0)),U,15)=10 $P(^(0),U,15)=""
 K ^OR(100,"AEVNT",ORVP,OREVT,ORIFN)
 Q
 ;
EVENT(X) ; -- Find (or create) event in #100.5 for
 ;    X = A/D/T ^ [TS] ^ DIV ptr
 N I,Y,TS,DIV,ORY,X0,MVT,ORGLOB
 S TS=+$P(X,U,2),DIV=+$P(X,U,3),X=$P(X,U),Y=0 K ORY
 S I=0 F  S I=+$O(^ORD(100.5,"ADT",X,I))  Q:I<1  D  ;find matches
 . S X0=$G(^ORD(100.5,I,0)) Q:DIV'=$P(X0,U,3)
 . I TS Q:'$O(^ORD(100.5,I,"TS","B",TS,0))
 . S MVT=+$P(X0,U,7) I MVT Q:$S(X="A":MVT'=15,X="T":MVT'=4,1:MVT'=16)
 . S ORY(+$G(^ORD(100.5,I,1)),MVT,I)="" ;=ORY(InactDt,MvtType,IEN)
 S I="ORY",I=$Q(@I),Y=+$P(I,",",3)
 I Y<1 D  ;create new inactive event
 . N I,HDR,LAST,TOTAL,DA,NAME
 . F I=1:1:10 L +^ORD(100.5,0):1 Q:$T  H 2
 . I '$T S Y="" Q
 . S HDR=$G(^ORD(100.5,0)),TOTAL=$P(HDR,U,4),LAST=$O(^ORD(100.5,"?"),-1)
 . S I=LAST F I=(I+1):1 Q:'$D(^ORD(100.5,I,0))
 . S Y=I,$P(HDR,U,3,4)=Y_U_(TOTAL+1)
 . S ^ORD(100.5,0)=HDR L -^ORD(100.5,0)
 . S NAME=$S(X="A":"ADMIT",X="T":"TRANSFER",X="D":"DISCHARGE",1:"")_$S(TS:" TO "_$P($G(^DIC(45.7,+TS,0)),U),1:"")_" ("_DIV_")"
 . S ^ORD(100.5,Y,0)=NAME_U_X_U_DIV_"^^^"_ORPARAM_"^^"_NAME,^(1)=ORNOW
 . S ^ORD(100.5,"B",$E(NAME,1,30),Y)="",^ORD(100.5,"ADT",X,Y)=""
 . I TS S ^ORD(100.5,Y,"TS",0)="^100.51P^1^1",^(1,0)=TS,^ORD(100.5,Y,"TS","B",TS,1)=""
 . S ORGLOB="^ORD(100.5," D AUDIT^OREV(Y,"N") ;Set edit history for new rule
 Q Y
 ;
ERR(X) ; -- Track orders unable to convert
 N MSG,STS S X=+$G(X),STS=$P(OR3,U,3)
 S MSG=$S(X=2:"<Missing or invalid specialty>",X=3!(STS=14):"<Lapsed>",STS=12:"<Changed>",STS=1!(STS=13):"<Cancelled>",1:"<Already released>")
 S ^XTMP("ORYED","ERR",ORVP,ORIFN)=OREVT_U_$G(ORTS)_U_MSG
 ; Include missing TS, newly lapsed orders in bulletin:
 ;D:X>1 SET(ORVP,OREVT_U_$G(ORTS)_U_ORDIV,MSG)
 Q
 ;
SET(PAT,OLD,NEW) ; -- set xref nodes in XTMP for bulletin
 N PNM,EVT,DIV,DIVNM,TS,NEWNM
 S PNM=$P($G(^DPT(+PAT,0)),U)_" ("_$P($G(^(.36)),U,4)_")"
 S EVT=$P(OLD,U) S:EVT="D" TS="none" I "AT"[EVT D
 . S TS=$P(OLD,U,2),X0=$S(TS:$G(^DIC(45.7,+TS,0)),1:"unk")
 . S TS=$S($L($P(X0,U,5)):$P(X0,U,5),1:$E($P(X0,U),1,5))
 S DIV=+$P(OLD,U,3),DIVNM=$S(DIV:$P($G(^DIC(4,DIV,0)),U),1:"UNKNOWN")
 S NEWNM=$S(NEW:$P($G(^ORD(100.5,+NEW,0)),U),1:NEW) ;EvtNm or ErrMsg
 S ^XTMP("ORYED","B",DIVNM,EVT,TS)=NEWNM,^(TS,PNM)=OLD_"~"_PAT
 Q
 ;
BULLETIN ; -- send bulletin when finished
 N DIFROM,XMSUB,XMTEXT,XMDUZ,XMY,XMZ,XMMG,I,J,ORZ,DIV,EVT,TS,NEWEVT,X,PAT,ORX,ORVP,ORIFN,ORDERS,MAX
 S XMDUZ="PATCH OR*3*141 CONVERSION",XMY(.5)="" S:$G(DUZ) XMY(DUZ)=""
 I $D(^XTMP("ORYED","XMY")) M XMY=^XTMP("ORYED","XMY") ;recipients
 S ^TMP("ORTXT",$J,1)="The Delayed Order conversion of patch OR*3*141 has completed."
B1 S I=1 I $D(^XTMP("ORYED","B")) D
 . S I=I+1,^TMP("ORTXT",$J,I)="   "
 . S I=I+1,^TMP("ORTXT",$J,I)="The following patients had delayed orders at the time of installation."
 . S I=I+1,^TMP("ORTXT",$J,I)="For each, any event codes and treating specialties formerly in use are"
 . S I=I+1,^TMP("ORTXT",$J,I)="listed on the left, with the new entry it was mapped to in the OE/RR"
 . S I=I+1,^TMP("ORTXT",$J,I)="RELEASE EVENTS file #100.5, if possible, on the right:"
 . S DIV="" F  S DIV=$O(^XTMP("ORYED","B",DIV)) Q:DIV=""  D
 .. S I=I+1,^TMP("ORTXT",$J,I)="   "
 .. S I=I+1,^TMP("ORTXT",$J,I)=DIV_":",ORZ=$$REPEAT^XLFSTR("-",$L(DIV))
 .. F EVT="A","T","D" S TS="" F  S TS=$O(^XTMP("ORYED","B",DIV,EVT,TS)) Q:TS=""  S NEWEVT=$G(^(TS)) D
 ... S I=I+1,^TMP("ORTXT",$J,I)=ORZ,ORZ="   "
 ... S X=$S(EVT="D":"DISCHARGE",1:EVT_"/"_TS)
 ... S I=I+1,^TMP("ORTXT",$J,I)=$$LJ^XLFSTR(X,9)_" => "_NEWEVT
 ... S PAT="" F  S PAT=$O(^XTMP("ORYED","B",DIV,EVT,TS,PAT)) Q:PAT=""  S ORX=$G(^(PAT)) D
 .... S ORVP=$P(ORX,"~",2),ORX=$P(ORX,"~"),MAX=68-$L(PAT)
 .... S (ORIFN,ORDERS)=0,X="#"
 .... F  S ORIFN=+$O(^XTMP("ORYED","EVT",ORX,ORVP,ORIFN)) Q:ORIFN<1  D
 ..... I $L(X)+$L(ORIFN)+1'>MAX S X=X_$S($L(X)>1:",",1:"")_ORIFN Q
 ..... S ORDERS=ORDERS+1,ORDERS(ORDERS)=X_",",X=ORIFN
 .... S ORDERS=ORDERS+1,ORDERS(ORDERS)=X,X=" "_PAT_": "
 .... F J=1:1:ORDERS S I=I+1,^TMP("ORTXT",$J,I)=X_ORDERS(J),X="   "
 S XMSUB="PATCH OR*3*141 CONVERSION COMPLETED"
 S XMTEXT="^TMP(""ORTXT"","_$J_"," D ^XMD
 K ^TMP("ORTXT",$J)
 Q
 ;
PARAMS ; -- Remove old parameters, template
 ;
 N DA,DIK,ORI
 S DIK="^XTV(8989.52,",DA=+$O(^XTV(8989.52,"B","ORP AUTODC ORDERS",0)) D:DA ^DIK
 F ORI="OR DC GEN ORD ON ADMISSION","ORPF DC OF GENERIC ORDERS","OR DC ON SPEC CHANGE","OR DELAYED ORDERS LAPSE DAYS" D
 . S DIK="^XTV(8989.51,",DA=+$O(^XTV(8989.51,"B",ORI,0))
 . D:DA ^DIK
 Q
 ;
DLGS ; -- Send bulletin re modified dialogs
 N I,ORD
 F I="LR OTHER LAB TESTS","RA OERR EXAM","PS MEDS","PSJ OR PAT OE","PSO OERR","PSO SUPPLY","OR GXMOVE ADMIT PATIENT","OR GXMOVE DISCHARGE","OR GXMOVE TRANSFER","OR GXMOVE TREATING SPECIALTY" S ORD(I)=""
 D EN^ORYDLG(141,.ORD)
 Q
 ;
101 ; -- replace items on protocol menus
 N ORI,ORX,ORMENU,OROLD,ORNEW,ORMNEM,DA,DR,DIE,X,Y
 F ORI=1:1 S ORX=$T(PRTCLS+ORI) Q:ORX["ZZZZZ"  D
 . S ORMENU=+$O(^ORD(101,"B",$P(ORX,";",3),0)) Q:ORMENU<1
 . S OROLD=+$O(^ORD(101,"B",$P(ORX,";",4),0)) Q:OROLD<1
 . S DA=+$O(^ORD(101,ORMENU,10,"B",OROLD,0)) Q:DA<1  ;already fixed
 . S ORNEW=$P(ORX,";",5),ORMNEM=$P(ORX,";",6)
 . S DIE="^ORD(101,"_ORMENU_",10,",DA(1)=ORMENU
 . S DR=".01///^S X=ORNEW;2///^S X=ORMNEM;5///@;6///@" D ^DIE
 Q
 ;
PRTCLS ;;MENU;REPL;WITH;MNEMONIC
 ;;ORCHART ORDERS MENU;ORB BLANK LINE1;ORC DELAYED ORDERS;TD
 ;;ORC ADD ORDERS MENU;ORC EVENT MENU;VALM PREVIOUS SCREEN;-
 ;;ZZZZZ
 ;
C ; -- Rebuild C index on #100.5 to uppercase
 N X,X1,DA K ^TMP($J,"ORD100.5C")
 S X="" F  S X=$O(^ORD(100.5,"C",X)) Q:X=""  D
 . S X1=$$UP^XLFSTR(X),DA=0
 . F  S DA=$O(^ORD(100.5,"C",X,DA)) Q:DA<1  S ^TMP($J,"ORD100.5C",X1,DA)=""
 K ^ORD(100.5,"C") M ^ORD(100.5,"C")=^TMP($J,"ORD100.5C")
 K ^TMP($J,"ORD100.5C")
 Q
