AUPNSICH ; IHS/CMI/LAB - Screen Purpose of Visit/ICD9 codes 24-MAY-1993 ; 
 ;;2.0;IHS PCC SUITE;**2,10,11,16**;MAY 14, 2009;Build 9
 ;IHS/TUCSON/LAB - added checks for filegram and CHS, do not
 ;
HELP ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 S %="Enter an active "_$S(I=1:"ICD-9-CM",1:"ICD-10-CM")_" diagnosis code or descriptive text.  "
 D EN^DDIOL(%)
 I I=1 D
 .D EN^DDIOL("DO NOT enter a code that begins with E (these are External cause of"),EN^DDIOL("Morbidity codes).")
 .;D EN^DDIOL("  ")
 I I=30 D
 .D EN^DDIOL("DO NOT enter a code that begins with V, W, X or Y (these are External"),EN^DDIOL("cause of Morbidity codes).")
 .;D EN^DDIOL("  ")
 ;Q:X="?"
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
 .I I=30,$E($P(%,U,2),1)="V" Q
 .I I=30,$E($P(%,U,2),1)="W" Q
 .I I=30,$E($P(%,U,2),1)="X" Q
 .I I=30,$E($P(%,U,2),1)="Y" Q
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,4)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
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
HELPFH ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 ;S %="Enter a valid "_$$VAL^XBDIQ1(80.4,I,.01)_" Family History Diagnosis code.  "
 ;D EN^DDIOL(%)
 D EN^DDIOL(" ")
 I I=1 D
 .D EN^DDIOL("Enter the Family History ICD that best describes the diagnosis."),EN^DDIOL("Select an active code, must be V16*, V17*, V18* or V19*.")
 .D EN^DDIOL("  ")
 I I=30 D
 .D EN^DDIOL("Enter the Family History ICD that best describes the diagnosis."),EN^DDIOL("Select an active code in the Z80 to Z84 range.")
 .D EN^DDIOL("  ")
 ;Q:X="?"
 Q:X="?BAD"
 Q:'$$ASKLIST()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(I,80,$S(I=1:"V16-V19.Z",1:"Z80-Z84.ZZZZ"),"CODE",AUPNC)
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
HELPE ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 I I=1 D  Q
 .D EN^DDIOL("Enter a cause of injury ""E"" code.")
 .D EN^DDIOL("  ")
 .;Q:X="?"
 .Q:X="?BAD"
 .Q:'$$ASKLIST()
 .NEW AUPNC
 .K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 .D LST^ATXAPI(1,80,"E*","CODE",AUPNC)
 .;display to screen until "^"
 .NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 .S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 ..I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 ..;CHECK FOR ACTIVE STATUS
 ..S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 ..Q:'$P(%,U,10)  ;inactive on this date
 ..S X=AUPNX,$E(X,12)=$P(%,U,4)
 ..D EN^DDIOL(X)
 ..S AUPNF=1
 .K ^TMP($J,"APCDCODE")
 I I=30 D  Q
 .D EN^DDIOL("Must be an external cause of morbidity code.  The code range is V00-Y99.")
 .D EN^DDIOL("  ")
 .;Q:X="?"
 .Q:X="?BAD"
 .Q:'$$ASKLIST()
 .NEW AUPNC
 .K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 .D LST^ATXAPI(30,80,"V01-Y99.Z","CODE",AUPNC)
 .;display to screen until "^"
 .NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 .S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 ..I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 ..;CHECK FOR ACTIVE STATUS
 ..S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 ..Q:'$P(%,U,10)  ;inactive on this date
 ..S X=AUPNX,$E(X,12)=$P(%,U,4)
 ..D EN^DDIOL(X)
 ..S AUPNF=1
 .K ^TMP($J,"APCDCODE")
 Q
EOP ;
 S AUPNQ=0
 NEW DIR
 NEW DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR K DIR
 I $D(DUOUT) S AUPNQ=1 Q
 W:$D(IOF) @IOF
 Q
 ;
HELPPL ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 S %="Enter a valid "_$$VAL^XBDIQ1(80.4,I,.01)_" Place of Occurrence code.  "
 I I=30 D EN^DDIOL(%)
 I I=1 D  Q
 .D EN^DDIOL("Enter a Place or Occurrence code in the range E849.0-E849.9.")
 .D EN^DDIOL("  ")
 .;Q:X="?"
 .Q:X="?BAD"
 .Q:'$$ASKLIST()
 .NEW AUPNC
 .K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 .D LST^ATXAPI(1,80,"E849-E849.ZZ","CODE",AUPNC)
 .;display to screen until "^"
 .NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 .S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 ..I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 ..;CHECK FOR ACTIVE STATUS
 ..S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 ..Q:'$P(%,U,10)  ;inactive on this date
 ..S X=AUPNX,$E(X,12)=$P(%,U,4)
 ..D EN^DDIOL(X)
 ..S AUPNF=1
 .K ^TMP($J,"APCDCODE")
 I I=30 D  Q
 .D EN^DDIOL("Must be in the code range Y92-Y92.9.")
 .D EN^DDIOL(" ")
 .;Q:X="?"
 .Q:X="?BAD"
 .Q:'$$ASKLIST()
 .NEW AUPNC
 .K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 .D LST^ATXAPI(30,80,"Y92-Y92.ZZ","CODE",AUPNC)
 .;display to screen until "^"
 .NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 .S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 ..I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 ..;CHECK FOR ACTIVE STATUS
 ..S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 ..Q:'$P(%,U,10)  ;inactive on this date
 ..S X=AUPNX,$E(X,12)=$P(%,U,4)
 ..D EN^DDIOL(X)
 ..S AUPNF=1
 .K ^TMP($J,"APCDCODE")
 Q
HELPOP ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80.1,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMPOP^AUPNSICD(D)  ;get ien of coding system
 S %="Enter an active "_$S(I=2:"ICD-9",1:"ICD-10")_" Procedure Code or descriptive text.  "
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
HELPRFB ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 ;S %="Enter a valid "_$$VAL^XBDIQ1(80.4,I,.01)_" Place of Occurrence code.  "
 ;D EN^DDIOL(%)
 I I=1 Q
 I I=30 D  Q
 .D EN^DDIOL("Must be in the code range Z18-Z18.9.")
 .D EN^DDIOL(" ")
 .;Q:X="?"
 .Q:X="?BAD"
 .Q:'$$ASKLIST()
 .NEW AUPNC
 .K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 .D LST^ATXAPI(30,80,"Z18-Z18.Z","CODE",AUPNC)
 .;display to screen until "^"
 .NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 .S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 ..I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 ..;CHECK FOR ACTIVE STATUS
 ..S %=$$ICDDX^ICDEX($P(^TMP($J,"APCDCODE",AUPNX),U,1),D,,"I")
 ..Q:'$P(%,U,10)  ;inactive on this date
 ..S X=AUPNX,$E(X,12)=$P(%,U,4)
 ..D EN^DDIOL(X)
 ..S AUPNF=1
 .K ^TMP($J,"APCDCODE")
 Q
HELPLEX ;EP
 NEW D,I,%
 S D=""
 I '$O(^ICDS("F",80,0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="" S D=DT
 S I=$$IMP^AUPNSICD(D)  ;get ien of coding system
 ;Q:X="?"
 Q:X="?BAD"
 Q:'$$ASKLIST()
 NEW AUPNC
 K ^TMP($J,"APCDCODE") S AUPNC=$NA(^TMP($J,"APCDCODE"))
 D LST^ATXAPI(I,80,"*","CODE",AUPNC)
 ;display to screen until "^"
 NEW AUPNX,AUPNY,AUPNQ,AUPNF,X
 S AUPNX="",AUPNQ=0,AUPNF=0 F  S AUPNX=$O(^TMP($J,"APCDCODE",AUPNX)) Q:AUPNX=""!($G(AUPNQ))  D
 .I AUPNF,$Y>(IOSL-2) D EOP Q:AUPNQ
 .;CHECK FOR ACTIVE STATUS
 .I I=1 Q:$E(AUPNX)="E"
 .I I=30,$E($P(%,U,2),1)="V" Q
 .I I=30,$E($P(%,U,2),1)="W" Q
 .I I=30,$E($P(%,U,2),1)="X" Q
 .I I=30,$E($P(%,U,2),1)="Y" Q
 .S %=$$ICDDX^ICDEX($P(AUPNC(AUPNX),U,1),D)
 .Q:'$P(%,U,10)  ;inactive on this date
 .S X=AUPNX,$E(X,12)=$P(%,U,4)
 .D EN^DDIOL(X)
 .S AUPNF=1
 K ^TMP($J,"APCDCODE")
 Q
