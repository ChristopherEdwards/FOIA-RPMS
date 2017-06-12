AUPNSICA ; IHS/CMI/LAB - Screen Purpose of Visit/ICD9 codes 24-MAY-1993 ; 
 ;;2.0;IHS PCC SUITE;**2,10,11**;MAY 14, 2009;Build 58
 ;IHS/TUCSON/LAB - added checks for filegram and CHS, do not
 ;execute screen if in chs or filegrams 03/18/96 PATCH 4
 I $$CHK(Y)
 Q:$D(^ICD9(Y))
 Q
IMP(D) ;PEP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 I '$D(^ICDS(0)) Q 1
 S Y=""
 S X=0 F  S X=$O(^ICDS("F",80,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
IMPOP(D) ;PEP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 I '$D(^ICDS(0)) Q 2
 S Y=""
 S X=0 F  S X=$O(^ICDS("F",80.1,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
 ;
CHK(Y) ;EP - SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $D(DIFGLINE) Q 1   ;in filegrams so take code and accept it
 I $D(ACHSDIEN) Q 1   ;in CHS so take code and accept it
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 ;I $G(APCDINPE) S APCDTNQP=$G(INP)
 S D=""
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="",$G(BDGV),$D(^AUPNVSIT(BDGV,0)) D
 .S D=$P($P(^AUPNVSIT(BDGV,0),U),".")
 I D="" S D=DT
 S I=$$IMP(D)  ;get ien of coding system
 S %=$$ICDDX^ICDEX(Y,+D)
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKDX"_I
 G @I
 ;Q
CHKDX1 ;CODING SYSTEM 1 - ICD9
 ;S %=$$ICDDATA^ICDXCODE("DIAG",Y,D)
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes
 I $$VERSION^XPDUTL("BCSV")]"",'$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 I $$VERSION^XPDUTL("BCSV")]"" G CSEX
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 ;
CSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 ;I $P(^ICD9(Y,0),U,10)]"",$P(^ICD9(Y,0),U,10)'=AUPNSEX Q 0
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKDX30 ;coding system 30 - ICD10
 ;S %=$$ICDDATA^ICDXCODE("DIAG",Y,D)
 I $E($P(%,U,2),1)="V" Q 0  ;no codes V00-Y99 per Leslie Racine.
 I $E($P(%,U,2),1)="W" Q 0
 I $E($P(%,U,2),1)="X" Q 0
 I $E($P(%,U,2),1)="Y" Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
CSEX30 ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
HELPADX ;EP
 NEW D,I,%
 S D=""
 I '$D(^ICDS(0)) Q
 I $T(LST^ATXAPI)="" Q
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$P($G(APCDDATE),".")
 I D="",$G(BDGV),$D(^AUPNVSIT(BDGV,0)) D
 .S D=$P($P(^AUPNVSIT(BDGV,0),U),".")
 I D="" S D=DT
 S I=$$IMP(D)  ;get ien of coding system
 S %="Enter an active "_$$VAL^XBDIQ1(80.4,I,.01)_" diagnosis code or descriptive text.  "
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
EOP ;
 S AUPNQ=0
 NEW DIR
 NEW DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR K DIR
 I $D(DUOUT) S AUPNQ=1 Q
 W:$D(IOF) @IOF
 Q
 ;
