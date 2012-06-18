BEHOXQPC ;MSC/IND/DKM - PCC-related notifications ;28-Jan-2008 13:08;DKM
 ;;1.1;BEH COMPONENTS;**002003**;Mar 20, 2007
 ;=================================================================
 ; RPC: Generate a missing POV alert
NOPOV(DATA,VSIT,PRI) ;EP
 N DFN,PRV
 S DATA=0,VSIT(0)=$G(^AUPNVSIT(+VSIT,0))
 S DFN=+$P(VSIT(0),U,5)
 I 'DFN S DATA="-1^Bad visit specifier" Q
 I $D(^AUPNVPOV("AD",VSIT)) S DATA="-2^Visit has POV" Q
 I '$D(^TIU(8925,"V",VSIT)) S DATA="-8^Visit has no note" Q
 S PRV=$$PRIPRV(VSIT)
 I PRV<0 S DATA=PRV Q
 D SEND(.DATA,"VPOV","Visit is missing a purpose of visit.",99001,VSIT,PRV,.PRI)
 Q
 ;EP - Returns true if POV notification is still valid
VALIDPOV(AID) ;
 N VSIT,PRV,DEL,RET,PPRV
 Q:$E(AID,1,4)'="VPOV" 0
 S VSIT=+$P(AID,",",2),PRV=+$P(AID,",",3),PPRV=$$PRIPRV(VSIT)
 I 'VSIT S RET=0,DEL=1
 E  I $D(^AUPNVPOV("AD",VSIT)) S RET=0,DEL=1
 E  I '$D(^TIU(8925,"V",VSIT)) S RET=0,DEL=1
 E  I PRV=PPRV!(PPRV<1) S RET=1,DEL=0
 E  D
 .; If primary provider changed, forward to new primary provider
 .D SEND(,"VPOV","Visit is missing a purpose of visit.",99001,VSIT,PPRV)
 .S (RET,DEL)=1
 D:DEL BEHDEL^BEHOXQ(AID,1)
 Q RET
 ; RPC: Generate missing E&M code alert
NOEMC(DATA,VSIT,PRI) ;EP
 N DFN,PRV,IEN,X
 S DATA=0,VSIT(0)=$G(^AUPNVSIT(+VSIT,0))
 S DFN=+$P(VSIT(0),U,5)
 I 'DFN S DATA="-1^Bad visit specifier" Q
 I '$D(^TIU(8925,"V",VSIT)) S DATA="-8^Visit has no note" Q
 S PRV=$$PRIPRV(VSIT)
 I PRV<0 S DATA=PRV Q
 S DATA=$$NEEDSEMC(VSIT,PRV)
 D:'DATA SEND(.DATA,"VEM","Visit is missing an E&M code.",99002,VSIT,PRV,.PRI)
 Q
 ;EP - Returns true if E&M notification is still valid
VALIDEMC(AID) ;
 N VSIT
 Q:$E(AID,1,3)'="VEM" 0
 S VSIT=+$P(AID,",",2)
 I $D(^TIU(8925,"V",VSIT)),'$$NEEDSEMC(+$P(AID,",",2),+$P(AID,",",3)) Q 1
 D BEHDEL^BEHOXQ(AID,1)
 Q 0
 ; Returns 0 if E&M code required
NEEDSEMC(VSIT,DUZ) ;
 N IEN,RTN,PAR,X
 S X=$G(^AUPNVSIT(VSIT,0))
 Q:"CTEDX"[$P(X,U,7) "-7^E&M code not required."
 S RTN=0,PAR="BEHOXQPC REQUIRES E&M CODE"
 F IEN=0:0 S IEN=$O(^AUPNVCPT("AD",VSIT,IEN)) Q:'IEN!RTN  D
 .S X=+$G(^AUPNVCPT(IEN,0))
 .I X'<99200,X<99500 S RTN="-2^Visit has E&M code"
 Q:RTN RTN
 S:'$$GET^XPAR($$ENT^CIAVMRPC(PAR),PAR) RTN="-5^Provider does not require E&M code"
 Q RTN
 ; Send the alert
SEND(DATA,AID,SUB,ORN,VSIT,PRV,PRI) ;
 N PAR,X
 I '$$ENABLED^BEHOXQ($G(ORN),PRV) S DATA="-6^Notification is disabled" Q
 S AID=AID_","_VSIT_","_PRV,X=$O(^XTV(8992,"AXQA",AID))
 I $P(X,";")=AID S DATA="-4^Notification exists" Q
 S PAR("LOC")="SEND",PAR("XQA,"_PRV)="",PAR("XQAID")=AID
 S PAR("XQADATA")="DFN="_DFN_"^PRI="_$G(PRI,3)_"^INF=0^VSIT="_VSIT
 S PAR("XQAMSG")=SUB
 D ENTRY^XQALGUI(,.PAR)
 S DATA="0^Notification was delivered"
 Q
 ; Get primary provider for a visit
PRIPRV(VSIT) ;
 N PRV
 D GETPRV2^BEHOENCX(.PRV,VSIT,1)
 S PRV=$O(PRV(0))
 S:'PRV PRV="-3^No primary provider"
 Q PRV
