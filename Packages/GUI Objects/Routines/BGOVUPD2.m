BGOVUPD2 ; IHS/MSC/MGH - Manage V UPDATE/REVIEWED file ;06-May-2011 16:04;PLS
 ;;1.1;BGO COMPONENTS;**8**;Mar 20, 2007;Build 1
 ; Get latest entries for a visit and user
 ;  INP = Visit string [1] ^User IEN [2] ^Type [3] ^ DFN [4]
 ; .RET returned as a list of records in the format:
 ;   Type[1] ^ IEN [2] ^ Text [3]  ^ Yes/no if pt has entries in file [4]
REVIEW(RET,INP) ;EP
 N CODE,CNT,USER,VIEN,IEN,RESULT,DFN,VSTR
 S RET=0,CNT=0
 S VSTR=$P(INP,U,1)
 S USER=$P(INP,U,2)
 S DFN=$P(INP,U,4)
 S CODE=$P(INP,U,3)
 I 'DFN S RET(1)="-1^No patient entered" Q
 I 'USER S RET(1)="-1^No user entered" Q
 ;Find the visit
 S VIEN=$$VSTR2VIS^BEHOENCX(DFN,VSTR,0,USER)
 S CODE=$P(INP,U,3)
 I 'DFN S RET(1)="-1^No patient entered" Q
 I 'USER S RET(1)="-1^No user entered" Q
 I CODE["P" S RESULT=$$PROB(DFN) D LIST("P",USER,RESULT)
 I CODE["A" S RESULT=$$ALLER(DFN) D LIST("A",USER,RESULT)
 I CODE["M" S RESULT=$$MEDS(DFN) D LIST("M",USER,RESULT)
 Q
LIST(TYPE,USER,RESULT) ;
 N IEN,STOP
 S STOP=0
 I VIEN=0 D
 .S CNT=CNT+1
 .S STR=$S(TYPE="P":"PROBLEMS",TYPE="A":"ALLERGIES",TYPE="M":"MEDICATIONS",1:"")
 .S RET(CNT)=TYPE_"^0^"_STR_" NEED REVIEW"_U_RESULT
 E  D
 .S IEN="" F  S IEN=$O(^AUPNVRUP("AD",VIEN,IEN),-1) Q:IEN=""!(STOP=1)  D CNT(IEN,TYPE,USER,RESULT)
 .I STOP=0 D
 ..S CNT=CNT+1
 ..S STR=$S(TYPE="P":"PROBLEMS",TYPE="A":"ALLERGIES",TYPE="M":"MEDICATIONS",1:"")
 ..S RET(CNT)=TYPE_"^0^"_STR_" NEED REVIEW"_U_RESULT
 Q
CNT(IEN,TYPE,USER,RESULT) ;Put the data in to array for return
 N UTYP,VDATE,VISIT,ETYPE,ATYP,PRV,X
 Q:$D(^AUPNVRUP(IEN,2))   ;Skip entries that are in error
 S UTYP=$P($G(^AUPNVRUP(IEN,0)),U,1)
 S ETYPE=$$GET1^DIQ(9000010.54,IEN,.01)
 S PRV=$P($G(^AUPNVRUP(IEN,1)),U,2)
 S ATYP=$S(ETYPE["ALLERG":"A",ETYPE["PROBLEM":"P",ETYPE["MEDICATION":"M",1:"")
 I (ATYP=TYPE)&(PRV=USER) D
 .S CNT=CNT+1,STOP=1
 .S RET(CNT)=TYPE_U_IEN_U_ETYPE_U_RESULT
 Q
GETTYP(RET,CODE) ; EP Returns a list of the types of clinical review actions to selct based on type
 N CNT,ABB,TYPE,IEN,NAME
 S CNT=0
 S ABB="" F  S ABB=$O(^AUTTCRA("C",ABB)) Q:ABB=""  D
 .I (ABB="ALR")!(ABB="ALU")!(ABB="NAA") S TYPE="A"
 .I (ABB="MLR")!(ABB="MLU")!(ABB="NAM") S TYPE="M"
 .I (ABB="PLR")!(ABB="PLU")!(ABB="NAP") S TYPE="P"
 .I CODE[TYPE D
 ..S IEN=$O(^AUTTCRA("C",ABB,"")) Q:IEN=""  D
 ...S NAME=$P($G(^AUTTCRA(IEN,0)),U)
 ...S CNT=CNT+1
 ...S RET(CNT)=IEN_U_NAME
 Q
PROB(DFN) ;Find if patient has any problems
 N PLST,RET
 S RET=0
 D LIST^GMPLUTL2(.PLST,DFN,"A")
 I PLST(0)>0 S RET=1
 Q RET
ALLER(DFN) ;Find if patient has any allergies
 N DAT,LP,CNT,X
 D LIST^BEHOARCV(.DAT,DFN,1,1)
 S (LP,CNT)=0
 F  S LP=$O(@DAT@(LP)) Q:'LP  D
 .S X=@DAT@(LP)
 .I $P(X,U),'$P(X,U,7) S CNT=CNT+1
 Q CNT>0
 ;
 N GMRAL,RET
 S RET=0
 D EN1^GMRADPT
 I GMRAL=1 S RET=1
 Q RET
MEDS(DFN) ;Find if pt has active meds
 N MED,RET,RXN,X,QUIT,CNT
 S RET=0,CNT=0,QUIT=0
 D LIST^BEHORXCV(.DATA,DFN)
 F  S CNT=$O(^TMP("CIAVMRPC",$J,CNT)) Q:CNT=""!(QUIT=1)  D
 .S DATA=$G(^TMP("CIAVMRPC",$J,CNT))
 .I $P(DATA,U,9)="ACTIVE" S RET=1,QUIT=1
 Q RET
