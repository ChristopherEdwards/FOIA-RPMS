ORWPS ; SLC/KCM/JLI/REV/CLA - Meds Tab; 05/22/03
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,116,132,141,173,203,190**;Dec 17, 1997
COVER(LST,DFN)  ; retrieve meds for cover sheet
 K ^TMP("PS",$J)
 D OCL^PSOORRL(DFN,"","")
 N ILST,ITMP,X S ILST=0
 S ITMP="" F  S ITMP=$O(^TMP("PS",$J,ITMP)) Q:'ITMP  D
 . S X=^TMP("PS",$J,ITMP,0)
 . I '$L($P(X,U,2)) S X="??"  ; show something if drug empty
 . S LST($$NXT)=$P(X,U,1,2)_U_$P(X,U,8,9)
 K ^TMP("PS",$J)
 Q
DT(X) ; -- Returns FM date for X
 N Y,%DT S %DT="T",Y="" D:X'="" ^%DT
 Q Y
 ;
ACTIVE(LST,DFN) ; retrieve active inpatient & outpatient meds
 K ^TMP("PS",$J)
 K ^TMP("ORACT",$J)
 N BEG,END,CTX
 S (BEG,END,CTX)=""
 S CTX=$$GET^XPAR("ALL","ORCH CONTEXT MEDS")
 S BEG=$$DT($P(CTX,";")),END=$$DT($P(CTX,";",2))
 D OCL^PSOORRL(DFN,BEG,END)
 N ITMP,FIELDS,INSTRUCT,COMMENTS,REASON,NVSDT,TYPE,ILST,J S ILST=0
 S ITMP="" F  S ITMP=$O(^TMP("PS",$J,ITMP),-1) Q:'ITMP  D
 . K INSTRUCT,COMMENTS,REASON
 . K ^TMP("ORACT",$J,"COMMENTS")
 . S COMMENTS="^TMP(""ORACT"",$J,""COMMENTS"")"
 . S (INSTRUCT,@COMMENTS)="",FIELDS=^TMP("PS",$J,ITMP,0)
 . I +$P(FIELDS,"^",8),$D(^OR(100,+$P(FIELDS,"^",8),8,"C","XX")) D
 . . S $P(^TMP("PS",$J,ITMP,0),"^",2)="*"_$P(^TMP("PS",$J,ITMP,0),"^",2) ;dan testing
 . S TYPE=$S($P($P(FIELDS,U),";",2)="O":"OP",1:"UD")
 . I TYPE="OP",$P(FIELDS,";")["N" S TYPE="NV"          ;non-VA med
 . I $O(^TMP("PS",$J,ITMP,"A",0))>0 S TYPE="IV"
 . I $O(^TMP("PS",$J,ITMP,"B",0))>0 S TYPE="IV"
 . I TYPE="UD" D UDINST(.INSTRUCT,ITMP)
 . I TYPE="OP" D OPINST(.INSTRUCT,ITMP)
 . I TYPE="IV" D IVINST(.INSTRUCT,ITMP)
 . I TYPE="NV" D NVINST(.INSTRUCT,ITMP),NVREASON(.REASON,.NVSDT,ITMP)
 . I (TYPE="UD")!(TYPE="IV")!(TYPE="NV") D SETMULT(COMMENTS,ITMP,"SIO")
 . M COMMENTS=@COMMENTS
 . I $D(COMMENTS(1)) S COMMENTS(1)="\"_COMMENTS(1)
 . S:TYPE="NV" $P(FIELDS,U,4)=$G(NVSDT)
 . S LST($$NXT)="~"_TYPE_U_FIELDS
 . S J=0 F  S J=$O(INSTRUCT(J)) Q:'J  S LST($$NXT)=INSTRUCT(J)
 . S J=0 F  S J=$O(COMMENTS(J)) Q:'J  S LST($$NXT)="t"_COMMENTS(J)
 . S J=0 F  S J=$O(REASON(J)) Q:'J  S LST($$NXT)="t"_REASON(J)
 K ^TMP("PS",$J)
 K ^TMP("ORACT",$J)
 Q
NXT() ; increment ILST
 S ILST=ILST+1
 Q ILST
 ;
UDINST(Y,INDEX) ; assembles instructions for a unit dose order
 N I,X,RST
 S X=^TMP("PS",$J,INDEX,0)
 S RST="^TMP(""ORACT"",$J,""INSTRUCT"")"
 S @RST@(1)=" "_$P(X,U,2),@RST=1
 S X=$S($L($P(X,U,6)):$P(X,U,6),1:$P(X,U,7))
 I $L(X) S @RST=2,@RST@(2)=X
 E  S @RST=1 D SETMULT(.RST,INDEX,"SIG")
 S @RST@(2)="\Give: "_$G(@RST@(2)),@RST=$G(@RST,2)
 D SETMULT(RST,INDEX,"MDR"),SETMULT(RST,INDEX,"SCH")
 F I=3:1:@RST S @RST@(I)=" "_@RST@(I)
 M Y=@RST K @RST
 Q
OPINST(Y,INDEX) ; assembles instructions for an outpatient prescription
 N I,X,RST
 S X=^TMP("PS",$J,INDEX,0)
 S RST="^TMP(""ORACT"",$J,""INSTRUCT"")"
 S @RST@(1)=" "_$P(X,U,2),@RST=1
 I $L($P(X,U,12)) S @RST@(1)=@RST@(1)_"  Qty: "_$P(X,U,12)
 I $L($P(X,U,11)) S @RST@(1)=@RST@(1)_" for "_$P(X,U,11)_" days"
 D SETMULT(RST,INDEX,"SIG")
 I @RST=1 D
 . D SETMULT(RST,INDEX,"SIO")
 . D SETMULT(RST,INDEX,"MDR")
 . D SETMULT(RST,INDEX,"SCH")
 S @RST@(2)="\ Sig: "_$G(@RST@(2))
 F I=3:1:@RST S @RST@(I)=" "_@RST@(I)
 M Y=@RST K @RST
 Q
IVINST(Y,INDEX) ; assembles instructions for an IV order
 N SOLN1,I,RST
 S RST="^TMP(""ORACT"",$J,""INSTRUCT"")"
 S @RST=0 D SETMULT(RST,INDEX,"A") S SOLN1=@RST+1
 D SETMULT(RST,INDEX,"B")
 I $D(@RST@(SOLN1)),$L($P(FIELDS,U,2)) S @RST@(SOLN1)="in "_@RST@(SOLN1)
 S SOLN1=@RST+1
 D SETMULT(RST,INDEX,"SCH") S:$D(@RST@(SOLN1)) @RST@(SOLN1)=" "_@RST@(SOLN1)
 F I=1:1:@RST S @RST@(I)="\"_$TR(@RST@(I),U," ")
 I $D(@RST@(1)) S @RST@(1)=" "_$E(@RST@(1),2,999)
 S @RST@(@RST)=@RST@(@RST)_" "_$P(^TMP("PS",$J,INDEX,0),U,3)
 M Y=@RST K @RST
 Q
NVINST(Y,INDEX) ; assembles instructions for a non-VA med
 N I,X,RST
 S X=^TMP("PS",$J,INDEX,0)
 S RST="^TMP(""ORACT"",$J,""INSTRUCT"")"
 S @RST@(1)=" "_$P(X,U,2),@RST=1
 D SETMULT(RST,INDEX,"SIG")
 I @RST=1 D
 . D SETMULT(RST,INDEX,"SIO")
 . D SETMULT(RST,INDEX,"MDR")
 . D SETMULT(RST,INDEX,"SCH")
 S @RST@(2)="\ "_$G(@RST@(2))
 F I=3:1:@RST S @RST@(I)=" "_@RST@(I)
 M Y=@RST K @RST
 Q
NVREASON(ORR,NVSDT,INDEX) ; assembles start date and reasons for a non-VA med
 N ORI,J,X,ORN,ORA
 S ORI=0 K ORR
 S X=^TMP("PS",$J,INDEX,0)
 S ORN=+$P(X,U,8)
 I $D(^OR(100,ORN,0)) D
 .S NVSDT=$P(^OR(100,ORN,0),U,8)
 .D WPVAL^ORWDXR(.ORA,ORN,"STATEMENTS") I $D(ORA) D
 ..S J=0 F  S J=$O(ORA(J)) Q:J<1  S ORI=ORI+1,ORR(ORI)=ORA(J)
 Q
SETMULT(Y,INDEX,SUB) ; appends the multiple at the subscript to Y
 N I,X,J
 S J=$G(@Y)
 S I=0 F  S I=$O(^TMP("PS",$J,INDEX,SUB,I)) Q:'I  S X=$G(^(I,0)) D
 . I SUB="B",$L($P(X,U,3)) S X=$P(X,U)_" "_$P(X,U,3)_"^"_$P(X,U,2)
 . S J=J+1,@Y@(J)=X
 S @Y=J
 Q
COMPRESS(Y) ; concatenate Y subscripts into smallest possible number
 N I,J,X S J=1,X(J)=""
 S I=0 F  S I=$O(Y(I)) Q:'I  D
 . I ($L(Y(I))+$L(X(J)))>245 S J=J+1,X(J)=""
 . S X(J)=X(J)_$S($L(X(J)):" ",1:"")_Y(I)
 K Y M Y=X
 Q
DETAIL(ROOT,DFN,ID) ; -- show details for a med order
 K ^TMP("ORXPND",$J)
 N LCNT,ORVP
 S LCNT=0,ORVP=DFN_";DPT("
 D MEDS^ORCXPND1
 S ROOT=$NA(^TMP("ORXPND",$J))
 Q
MEDHIST(ORROOT,DFN,ORIFN)       ; -- show admin history for a med  (RV)
 N ORPSID,ISIV,CKPKG,ORPHMID
 S ORPSID=+$P($$OI^ORX8(ORIFN),U,3),ISIV=0
 S ORROOT=$NA(^TMP("ORHIST",$J)) K @ORROOT
 S ISIV=$O(^ORD(100.98,"B","IV RX",ISIV))
 S CKPKG=$$PATCH^XPDUTL("PSB*2.0*19")
 I $P($G(^OR(100,+ORIFN,0)),U,11)=ISIV D  Q
 . I 'CKPKG S @ORROOT@(0)="Medication Administration History is not available at this time for IV fluids."
 . I CKPKG D
 . . S ORPHMID=$G(^OR(100,+ORIFN,4))  ;Pharmacy order number
 . . D RPC^PSBO(.ORROOT,"PM",DFN,"","","","","","","","","",ORPHMID)  ;DBIA #3955
 . . I '$D(@ORROOT) S @ORROOT@(0)="No Medication Administration History found for the IV order."
 I '$L($T(HISTORY^PSBMLHS)) D  Q
 . S @ORROOT@(0)="This report is only available using BCMA version 2.0."
 D HISTORY^PSBMLHS(.ORROOT,DFN,ORPSID)  ; DBIA #3459 for BCMA v2.0
 Q
 ;
REASON(ORY) ; -- Return Non-VA Med Statement/Reasons
 N ORE
 D GETLST^XPAR(.ORY,"ALL","ORWD NONVA REASON","E")
 Q
