ORIN1006 ;IHS/CIA/PLS - KIDS Inits for OR patch 1006 ;12-Aug-2010 10:03;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**1006**;Dec 17, 1997
 ;=================================================================
EC ;EP - Environment check
 Q
PRE ;EP - Preinit
 Q
POST ;EP - Postinit
 N PKG
 F PKG="HERBAL/OTC/NON-VA MEDS" D
 .D ADDPMT("OR GTX HM LAST DOSE TAKEN",PKG,"Last Dose Taken:","last dose taken",12.1,12.1,"5Z")
 .D ADDPMT("OR GTX HM LOCATION OF MEDICATION",PKG,"Medication Location:","medication location",12.2,12.2)
 .D ADDPMT("OR GTX HM LIST SOURCE",PKG,"Home Medication Source:","home medication source",12.3,12.3)
 .D ADDPMT("OR GTX HM REASON",PKG,"Reason for Medication:","reason for medication",12.4,12.4)
 D ADDRDIV
 ;D ADDCHILD("BEHOEN VISIT SUMMARY1")
 ;D ADDCHILD("BEHOEN VISIT SUMMARY2")
 ;D ADDCHILD("BEHOEN VISIT SUMMARIES")
 ;D CHGMXNM("OUTPATIENT MEDICATIONS","Outpt. Meds")
 ;I $$REGRPC^CIAURPC("ORWDXC MANUAL","CIAV VUECENTRIC")
 ;I $$REGRPC^CIAURPC("ORWDXC RENEW","CIAV VUECENTRIC")
 Q
 ; Add a report to the ORRPW ADT VISITS report header.
ADDCHILD(RPT) ;
 N X,Y,FDA
 S X=$$FIND1^DIC(101.24,,"X","ORRPW ADT VISITS")
 S Y=$$FIND1^DIC(101.24,,"X",RPT)
 I X,Y D
 .S:'$O(^ORD(101.24,X,10,"B",Y,0)) FDA(101.241,"+1,"_X_",",.01)="`"_Y
 .S FDA(101.24,Y_",",.13)="ORWRP REPORT TEXT"
 .D UPDATE^DIE("E","FDA")
 Q
 ; Add prompt to selected order and quick order dialogs
ADDPMT(PMT,PKG,LBL,DX,SEQ,OTS,FMT,REQ) ;
 N DLG,TYP,ITM,QO,X,Y
 S REQ=$G(REQ,1)
 S:PMT'=+PMT PMT=$$FIND1^DIC(101.41,,"XQ",PMT)
 S:PKG'=+PKG PKG=$$FIND1^DIC(9.4,,"XQ",PKG)
 Q:'PMT!'PKG
 S QO='OTS,TYP=$S(QO:"Q",1:"D"),ITM=0,FMT=$G(FMT)
 F DLG=0:0 S DLG=$O(^ORD(101.41,DLG)) Q:'DLG  S X=$G(^(DLG,0)) D
 .N FDA,IEN,NAM,SUB,SFN
 .Q:$P(X,U,4)'=TYP
 .S Y=$P(X,U,7)
 .I 'Y,QO D
 ..S Y=$P(X,U,5)
 ..S:Y Y=$P($G(^ORD(100.98,Y,0)),U,4)
 ..S:Y Y=$P($G(^ORD(101.41,Y,0)),U,7)
 .Q:Y'=PKG
 .S SUB=$S(QO:6,1:10),SFN=$S(QO:101.416,1:101.412)
 .Q:'$O(^ORD(101.41,DLG,SUB,"D",0))
 .S IEN=$O(^ORD(101.41,DLG,SUB,"D",PMT,0))
 .S NAM=$$GET1^DIQ(101.41,DLG,.01)
 .S FDA=$NA(FDA(SFN,$S(IEN:IEN,1:"+1")_","_DLG_","))
 .D ADDQO:QO,ADDDG:'QO
 .D UPDATE^DIE("","FDA","IEN")
 .S X=$S(IEN:IEN,1:+$G(IEN(1)))
 .S:'ITM ITM=X
 .D BMES^XPDUTL($S(IEN:"Updated ",X:"Added ",1:"Unable to add ")_DX_" prompt "_$S(IEN:"in ",1:"to ")_NAM_".")
 I 'QO,ITM D ADDPMT(PMT,PKG,LBL,DX,ITM,0)
 Q
ADDDG S @FDA@(.01)=SEQ
 S @FDA@(2)=PMT
 S @FDA@(6)=REQ  ;required field
 S @FDA@(9)="*"
 S @FDA@(17)="S Y="""""
 S:OTS>0 @FDA@(21)=OTS
 S:$L(FMT) @FDA@(22)=FMT
 S @FDA@(24)=LBL
 Q
ADDQO S @FDA@(.01)=SEQ
 S @FDA@(.02)=PMT
 S @FDA@(.03)=1
 Q
 ; Change Mixed Name field value for Display Group
CHGMXNM(DSPGRP,MXNM) ;
 N FDA,IEN
 Q:'$L($G(DSPGRP))!('$L($G(MXNM)))
 S IEN=$$FIND1^DIC(100.98,,"XQ",DSPGRP)
 Q:'IEN
 S FDA(100.98,IEN_",",2)=MXNM
 D FILE^DIE("","FDA")
 Q
 ; Remove ORPF GRACE DAYS BEFORE PURGE parameter from
 ; ORP ORDER MISC parameter template
REMPRG N PAR,TPL,LP,FDA
 S PAR=$$FIND1^DIC(8989.51,,"XQ","ORPF GRACE DAYS BEFORE PURGE")
 S TPL=$$FIND1^DIC(8989.52,,"XQ","ORP ORDER MISC")
 Q:'PAR!'TPL
 F LP=0:0 S LP=$O(^XTV(8989.52,TPL,10,LP)) Q:'LP  D:$P($G(^(LP,0)),U,2)=PAR
 .S FDA(8989.521,LP_","_TPL_",",.01)="@"
 D:$D(FDA) FILE^DIE("","FDA")
 Q
 ;
 ; File entry
STORE(FDA) ;EP
 N MSG
 D UPDATE^DIE(,"FDA",,"MSG")
 I $D(MSG) D
 .W !,"The following error occurred:"
 .W !,$G(MSG("DIERR",1,"TEXT",1))
 .S XPDQUIT=1
 K FDA
 Q
 ;
TRAN(VAL) ;EP - Check for entry inclusion
 I "^OR GTX HM LIST SOURCE^OR GTX HM LAST DOSE TAKEN^OR GTX HM LOCATION OF MEDICATION^OR GTX HM REASON^"[X Q 1
 Q 0
 ;
ADDRDIV ;
 Q:$$FIND1^DIC(100.22,,,"REQUESTING DIVISION")  ; Already exists
 N FDA,FN,IEN
 S IEN=$P(^ORD(100.22,0),U,3)  ; Check next ien value. Set to 1 if not between 1 and 999
 S:IEN>999 $P(^ORD(100.22,0),U,3)=0  ; Move range of new entries to start with 1(or the next valid ien)
 S FN=100.22,IEN="+1,"
 S FDA(FN,IEN,.01)="REQUESTING DIVISION"
 S FDA(FN,IEN,.02)="DIV:"
 S FDA(FN,IEN,.03)="TEST LOCATION"
 S FDA(FN,IEN,.04)="ORPRDIV"
 S FDA(FN,IEN,1)="S ORPRDIV="""" I $P($G(^OR(100,+$G(ORIFN),0)),U,10) S ORPRDIV=$P(^SC(+$P(^(0),U,10),0),U,15) I ORPRDIV'="""" S ORPRDIV=$P($G(^DG(40.8,ORPRDIV,0)),U,1)"
 D STORE(.FDA)
 Q
 ;
