BEHOPLCV ;MSC/IND/DKM - Cover Sheet: Problem List ;20-Aug-2007 14:53;DKM
 ;;1.1;BEH COMPONENTS;**034001**;Mar 20, 2007
 ;=================================================================
 ; Return pt's problem list.
LIST(DATA,DFN,STATUS) ;EP
 N CNT,LP,PLST
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 Q:'DFN
 I $L($T(LIST^GMPLUTL2)) D
 .S @DATA@(1)="^No problems found.",LP=0
 .D LIST^GMPLUTL2(.PLST,DFN,STATUS)
 .F  S LP=$O(PLST(LP)) Q:'LP  D ADD(PLST(LP))
 E  D ADD("^Problem list not available.")
 Q
 ; Return problem detail
DETAIL(DATA,DFN,IEN) ;EP
 N PLST,GMPDT,CNT,LP,X
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 I $L($T(DETAIL^GMPLUTL2)) D
 .D DETAIL^GMPLUTL2(IEN,.PLST)
 .Q:$D(PLST)'>1
 .D ADD(PLST("NARRATIVE")_" ("_PLST("DIAGNOSIS")_")"),ADD()
 .D ADD(PLST("ONSET"),"Onset:")
 .D ADD(PLST("STATUS")_"/"_PLST("PRIORITY"),"Status:")
 .D ADD(PLST("SC"),"SC Cond:")
 .D ADD($S($G(PLST("EXPOSURE"))>0:PLST("EXPOSURE",1),1:"None"),"Exposure:")
 .I $G(PLST("EXPOSURE"))>1 D
 ..F LP=2:1:PLST("EXPOSURE") D ADD(PLST("EXPOSURE",LP),"")
 .D ADD()
 .D ADD(PLST("PROVIDER"),"Provider:")
 .D ADD(PLST("CLINIC"),"Clinic:")
 .D ADD()
 .D ADD($P(PLST("RECORDED"),U)_", by "_$P(PLST("RECORDED"),U,2),"Recorded:")
 .D ADD($P(PLST("ENTERED"),U)_", by "_$P(PLST("ENTERED"),U,2),"Entered:")
 .D ADD(PLST("MODIFIED"),"Updated:")
 .D ADD()
 .I $G(PLST("COMMENT"))>0 D
 ..D ADD("----------- Comments -----------")
 ..F LP=1:1:PLST("COMMENT")  D
 ...S X=PLST("COMMENT",LP)
 ...D ADD($P(X,U)_" by "_$P(X,U,2)_": "_$P(X,U,3))
 .D:$D(^GMPL(125.8,"B",IEN)) HIST
 D:'CNT ADD("Problem detail not available.")
 Q
 ; Get audit history
HIST N IDT,AIFN,LBL,TXT,GMPDT,LCNT,X
 D ADD(),ADD("-------- Audit History ---------")
 S (LCNT,IDT)=0
 F  S IDT=$O(^GMPL(125.8,"AD",IEN,IDT)),AIFN=0 Q:'IDT  D
 .F  S AIFN=$O(^GMPL(125.8,"AD",IEN,IDT,AIFN)) Q:'AIFN  D DT^GMPLHIST
 S LP="",TXT=""
 F  S LP=$O(GMPDT(LP)) Q:LP=""  D
 .S X=GMPDT(LP,0)
 .I $L(X,": ")>1 D
 ..D:$L(TXT) ADD(TXT,LBL)
 ..S LBL=$$TRIM^CIAU($P(X,": "))_":",TXT=$$TRIM^CIAU($P(LBL,": ",2,999))                                    ; start new text string
 .E  S TXT=TXT_" "_$$TRIM^CIAU(X)                                            ; line does not begin with date, so add to existing text line
 D:$L(TXT) ADD(TXT,LBL)
 Q
 ; Add to output array
ADD(TXT,LBL) ;
 S CNT=CNT+1,@DATA@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_$G(TXT),LBL=""
 Q
