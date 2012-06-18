BEHORXEI ;MSC/IND/PLS - PharmED Component KIDS Support ;15-Apr-2010 12:05;DKM
 ;;1.1;BEH COMPONENTS;**044002,044003**;Mar 20, 2007
 ;=========================================================
PREINIT ;EP - Preinitialization
 ;D FIXNAR
 D FIXTOPIC
 Q
POSTINIT ;EP - Postinitialization
 Q
 N LST,ITM,INST,LP
 S INST=0
 F LP="V65.49 ","V65.19 " D
 .S ITM=$$FIND1^DIC(80,,,LP,"BA")
 .I ITM D
 ..S INST=INST+1
 ..S LST(INST)="`"_ITM
 D:$D(LST) SETPAR("BEHORXED POV LIST",.LST)
 D REGNMSP^CIAURPC("BEHORXED","CIAV VUECENTRIC")
 D REGMENU^BEHUTIL("BEHORXED MAIN",,"MEC","BEHORX MAIN")
 D EDITPAR^XPAREDIT("BEHORXED DEF HOSP LOCATION")
 Q
 ; Fix bad narrative entries
FIXNAR N NAR,POV,LP,DAT,VIEN,VPOV,CNT
 F LP="DIV","SYS" D
 .N TMP,IEN,IEN2,I
 .D GETLST^XPAR(.TMP,LP,"BEHORXED POV LIST","I")
 .F I=0:0 S I=$O(TMP(I)) Q:'I  S POV(+TMP(I))=""
 .K TMP
 .D GETLST^XPAR(.TMP,LP,"BEHORXED POV NARR TEXT","I")
 .F I=0:0 S I=$O(TMP(I)) Q:'I  D
 ..S NAR=TMP(I),IEN=0
 ..Q:'$L(NAR)
 ..F  S IEN=$$FNDNAR(NAR,IEN) Q:'IEN  D
 ...S IEN2=$$FNDNAR(IEN,0)
 ...S:IEN2 NAR(IEN2)=IEN
 Q:$D(NAR)<10
 D BMES^XPDUTL("Searching for bad med counseling VPOV entries...")
 S DAT=3070600,CNT=0
 F  S DAT=$O(^AUPNVSIT("B",DAT)) Q:'DAT  D
 .F VIEN=0:0 S VIEN=$O(^AUPNVSIT("B",DAT,VIEN)) Q:'VIEN  D
 ..F VPOV=0:0 S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D
 ...N X
 ...S X=$G(^AUPNVPOV(VPOV,0))
 ...Q:'$D(POV(+X))
 ...S NAR=+$P(X,U,4)
 ...Q:'$D(NAR(NAR))
 ...S $P(^AUPNVPOV(VPOV,0),U,4)=NAR(NAR),CNT=CNT+1
 ...D MES("Repaired VPOV record #"_VPOV)
 D MES("Bad entries detected and repaired: "_CNT)
 Q
 ; Find next narrative entry
FNDNAR(NAR,IEN) ;
 N TRC
 S TRC=$E(NAR,1,30)
 F  S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=NAR
 Q IEN
 ; Build parameter values
SETPAR(PARAM,ARY) ;EP
 N ENT,VAL,INST
 D MES("Setting up default site parameters...")
 S INST=0 F  S INST=$O(ARY(INST)) Q:'INST  S VAL=ARY(INST) D
 .S ENT=$$ENT^CIAVMRPC(PARAM),ENT=$P(ENT,U,$L(ENT,U))
 .D:$L(ENT) ADD^XPAR(ENT,PARAM,INST,.VAL)
 Q
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ; EP
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
 ; Fix bad Education Topic entries
FIXTOPIC ; EP -
 N VIEN,DAT,CNT,VPED,TOP
 D BMES^XPDUTL("Searching for bad med counselling VPOV entries...")
 S DAT=3070600,CNT=0
 F  S DAT=$O(^AUPNVSIT("B",DAT)) Q:'DAT  D
 .F VIEN=0:0 S VIEN=$O(^AUPNVSIT("B",DAT,VIEN)) Q:'VIEN  D
 ..F VPED=0:0 S VPED=$O(^AUPNVPED("AD",VIEN,VPED)) Q:'VPED  D
 ...N X
 ...S X=$G(^AUPNVPED(VPED,0))
 ...Q:$P(X,U,12)'="MEDICATIONS"
 ...S $P(^AUPNVPED(VPED,0),U,12)=$$PEDTOPIC^BEHOENPC("MEDICATIONS"),CNT=CNT+1
 ...D MES("Repaired VPED record #"_VPED)
 D MES("Bad entries detected and repaired: "_CNT)
 Q
