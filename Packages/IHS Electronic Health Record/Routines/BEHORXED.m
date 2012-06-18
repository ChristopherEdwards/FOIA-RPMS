BEHORXED ;MSC/IND/PLS - PharmED Component Support ;01-Feb-2008 08:37;DKM
 ;;1.1;BEH COMPONENTS;**044002**;Mar 20, 2007
 ;=========================================================
 ; Return list of selectable POVs
POVLST(DATA) ;EP
 N TMP,LP,POV,NTMP
 D GETLST^XPAR(.TMP,"ALL","BEHORXED POV LIST","B")
 D GETLST^XPAR(.NTMP,"ALL","BEHORXED POV NARR TEXT","I")
 S LP=0 F  S LP=$O(TMP(LP)) Q:'LP  D
 .S POV=$G(TMP(LP,"V"))
 .Q:'POV
 .S DATA(LP)=POV_U_$$GET1^DIQ(80,+POV,3)_U_$G(NTMP(LP))
 Q
 ; Return list of selectable Education Topics
EDLST(DATA) ;EP
 N TMP,LP,ED
 D GETLST^XPAR(.TMP,"ALL","BEHORXED EDUCATION TOPICS LIST","B")
 S LP=0 F  S LP=$O(TMP(LP)) Q:'LP  D
 .S ED=$G(TMP(LP,"V"))
 .Q:'ED
 .S DATA(LP)=ED
 Q
COMPLST(DATA) ;EP
 N TMP,VAL,SET
 D FIELD^DID(9000010.16,.06,"","POINTER","TMP")
 S SET=$G(TMP("POINTER"))
 I $L(SET) D
 .S LP=1 F  S VAL=$P(SET,";",LP) Q:'VAL  D  S LP=LP+1
 ..S DATA(LP)=VAL
 Q
 ; Store PED data
STORE(DATA,DFN,VSTR,PCCARY) ;EP
 ; PED^Code^Cat^Nar^Com^prv^level of understanding^refused^elapsed^setting^goals^outcome
 D SAVE^BEHOENPC(.DATA,.PCCARY)
 D:DATA=0 XTMPSET(DFN,DT)
 Q
 ; Provider Narrative RPC
PRVNRPC(DATA,TXT) ;
 S DATA=$$PRVNARR(TXT)
 Q
 ; Return Provider Narrative IEN
PRVNARR(TXT) ; EP
 N IEN,FDA,IENS,ERR,TRC
 Q:'$L(TXT) ""
 S TXT=$E(TXT,1,80),TRC=$E(TXT,1,30),IEN=0
 F  S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=TXT
 I 'IEN D
 .S FDA(9999999.27,"+1,",.01)=TXT
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $G(ERR) S IEN=""
 .E  S IEN=$G(IENS(1))
 Q IEN
 ; Return use status of PharmEd component
CANUSE(DATA,DFN) ;EP
 S DATA='$G(^XTMP("BEHORXED",DT,DFN))
 D CLEANUP(DT)
 Q
 ;
XTMPSET(DFN,DATE) ;EP
 I '$D(^XTMP("BEHORXED",DATE)) D
 .S ^XTMP("BEHORXED",0)=$$FMADD^XLFDT(DT,+7)_U_DT_U_"PharmED component"
 S ^XTMP("BEHORXED",DATE,DFN)=1
 D BRDCAST^CIANBEVT("PCC.PHARMED."_DFN)
 Q
 ; Cleanup the XTMP global
CLEANUP(DATE) ;
 N LP,EDT
 Q:$D(^XTMP("BEHORXED",DATE))  ; already purged
 S EDT=$$FMADD^XLFDT(DATE,-1)
 S LP=0 F  S LP=$O(^XTMP("BEHORXED",LP)) Q:'LP!(LP>EDT)  D
 .K ^XTMP("BEHORXED",LP)
 Q
 ; Return list of available visits
VSTLST(DATA,DFN,SDT,CAT) ;EP
 N EDT,IN,VST,IDT,IDT2,VIEN,NODE0,CNT,LOCNAM,LOCIEN,VDATE,VSTR,STS
 S:'$G(SDT) SDT=DT
 S EDT=SDT+.9
 S CAT=$G(CAT,"A")  ;Default to Ambulatory visits
 S DATA=$$TMPGBL^CIAVMRPC
 S IDT2=9999999-(SDT\1)+.9,IDT=9999999-(EDT\1)
 S CNT=0
 F  Q:'IDT!(IDT>IDT2)  D  S IDT=$O(^AUPNVSIT("AA",DFN,IDT))
 .S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AA",DFN,IDT,VIEN)) Q:'VIEN  D
 ..N PRV
 ..S NODE0=^AUPNVSIT(VIEN,0)
 ..Q:$P(NODE0,U,11)      ; Ignore visits that are logically deleted
 ..Q:$P(NODE0,U,7)'=CAT  ; Compare Service Category
 ..Q:$$ISLOCKED^BEHOENCX(VIEN)  ; Ignore logically deleted visits
 ..S VDATE=+NODE0,LOCIEN=$P(NODE0,U,22),LOCNAM=$$GET1^DIQ(44,LOCIEN,.01)
 ..S VSTR=LOCIEN_";"_VDATE_";"_CAT_";"_VIEN
 ..S STS=$$SET^CIAU(CAT,$P($G(^DD(9000010,.07,0)),U,3))
 ..D GETPRV2^BEHOENCX(.PRV,VIEN,1)
 ..S PRV=$P($G(PRV(+$O(PRV(0)))),U,1,2)
 ..S CNT=CNT+1,@DATA@(-VDATE,CNT)=VSTR_U_LOCNAM_U_VDATE_U_STS_U_U_PRV
 Q
