AUPNSIC9 ; IHS/CMI/LAB - Screen Purpose of Visit/ICD9 codes 24-MAY-1993 ; 
 ;;2.0;IHS PCC SUITE;**2,10,11**;MAY 14, 2009;Build 58
 ;
ASKLIST() ;
 NEW X,Y,%,I,D,DIR,DIE,DA,DIC,DIRUT,DUOUT
 S DIR(0)="Y",DIR("A")="Do you want the entire ICD DIAGNOSIS List",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q 0
 I 'Y Q 0
 Q 1
ASKLISTO() ;
 NEW X,Y,%,I,D,DIR,DIE,DA,DIC,DIRUT,DUOUT
 S DIR(0)="Y",DIR("A")="Do you want the entire ICD OPERATION/PROCEDURE List",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q 0
 I 'Y Q 0
 Q 1
EOP ;
 S AUPNQ=0
 NEW DIR,D
 NEW DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR K DIR
 I $D(DUOUT) S AUPNQ=1 Q
 W:$D(IOF) @IOF
 Q
CHK9 ;EP
 I $$CHK91(Y)
 Q:$D(^ICD9(Y))
 Q
CHK91(Y) ;EP
 NEW A,I,D,%
 S D=""
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=1
 S %=$$ICDDX^ICDEX(Y,D)
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKDX9"_I
 G @I
 ;Q
CHKDX91 ;CODING SYSTEM 1 - ICD9
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
CSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 ;I $P(^ICD9(Y,0),U,10)]"",$P(^ICD9(Y,0),U,10)'=AUPNSEX Q 0
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
HELP9 ;EP
 NEW D,I,%
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=1
 S %="Enter an active "_$$VAL^XBDIQ1(80.4,I,.01)_" diagnosis code or descriptive text.  "
 D EN^DDIOL(%)
 I I=1 D
 .D EN^DDIOL("DO NOT enter a code that begins with E (these are External cause of"),EN^DDIOL("Morbidity codes).")
 Q:X="?BAD"
 ;ASK FOR LIST
 Q:'$$ASKLIST()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(I,80,"*","CODE",AUPNC)
 ;display to screen until "^"
 NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 .I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 .;CHECK FOR ACTIVE STATUS
 .S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 .I I=1 Q:$E(AUPNX)="E"
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,4)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
CHKE9 ;EP
 I $$CHKE91(Y)
 Q:$D(^ICD9(Y))
 Q
CHKE91(Y) ;
 NEW A,I,D,%
 S D=""
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=1
 S %=$$ICDDX^ICDEX(Y,D)
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 ;
 I $E($P(%,U,2),1)'="E" Q 0  ;no E codes
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
HELPE9 ;EP
 NEW D,I,%
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 D EN^DDIOL("Enter a cause of injury ""E"" code.")
 D EN^DDIOL("  ")
 ;Q:X="?"
 Q:X="?BAD"
 Q:'$$ASKLIST()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(1,80,"E*","CODE",AUPNC)
 ;display to screen until "^"
 NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 .I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 .;CHECK FOR ACTIVE STATUS
 .S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,4)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
CHKPL9 ;EP
 I $$CHKPL91(Y)
 Q:$D(^ICD9(Y))
 Q
CHKPL91(Y) ;
 NEW A,I,D,%
 S D=""
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=1
 S %=$$ICDDX^ICDEX(Y,D)
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 ;
 I $E($P(%,U,2),1,4)'="E849" Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
HELPPL9 ;EP
 NEW D,I,%
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=1
 Q:X="?BAD"
 Q:'$$ASKLIST()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(1,80,"E849-E849.ZZ","CODE",AUPNC)
 ;display to screen until "^"
 NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 .I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 .;CHECK FOR ACTIVE STATUS
 .S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,4)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
HELPOP9 ;EP
 NEW D,I,%
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 S D=""
 S I=2  ;get ien of coding system
 S D=$S($T(IMP^ICDEX)]"":$$FMADD^XLFDT($$IMP^ICDEX(31),-2),1:DT)
 S %="Enter an active ICD-9 Procedure Code or descriptive text.  "
 D EN^DDIOL(%)
 ;D EN^DDIOL("Enter a Procedure name (2-245 characters in length), a Procedure")
 ;D EN^DDIOL("code, one or more keywords sufficient to select a Procedure name.")
 ;D EN^DDIOL("  ")
 ;Q:X="?"
 Q:X="?BAD"
 Q:'$$ASKLISTO()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(I,80.1,"*","CODE",AUPNC)
 ;display to screen until "^"
 NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 .I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 .;CHECK FOR ACTIVE STATUS
 .S %=$$ICDOP^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,5)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
CHKOP9 ;EP
 I $$CHKOP91(Y)
 Q:$D(^ICD9(Y))
 Q
CHKOP91(Y) ;
 NEW A,I,D,%
 S D=""
 S D=$$FMADD^XLFDT($$IMP^ICDEX(30),-2)
 S I=2
 S %=$$ICDOP^ICDEX(Y,,,"I")
 I $P(%,U,15)]"",$P(%,U,15)'=I Q 0   ;not correct coding system
 ;
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
