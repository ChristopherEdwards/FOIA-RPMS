BTIULO5 ; IHS/ITSC/LJF - STILL MORE OBJECTS FOR EHR ;01-Jun-2010 09:22;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1001,1002,1004,1005,1006**;NOV 04, 2004
 ;IHS/ITSC/LJF 12/10/2004 PATCH 1001 V Orders object was not displaying a modified order
 ;             04/08/2005 PATCH 1002 Indented display of medication sig
 ;                        PATCH 1004 Changed to EHR 1.1 visit selection
 ;                        PATCH 1005 change V ED to include comments if multi-line option used
 ;                        PATCH 1006 changes to create error message if no visit found
VORD(TARGET) ; returns orders for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW X,I,VST,CNT,RESULT
 I $G(TARGET)="" Q " "
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 I VST<1 Q " "
 D GETORD(.RESULT,VST)
 ;
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 Q "~@"_$NA(@TARGET)
 ;
GETORD(RETURN,VSIT) ;
 K RETURN
 NEW DAT,DFN,ORLIST,ORD,HDR,HLF,LOC,X,Y,C
 S C=0
 S X=$G(^AUPNVSIT(VSIT,0)),DAT=X\1 Q:'DAT
 S DFN=$P(X,U,5),LOC=$P(X,U,22)_";SC("
 K ^TMP("ORR",$J)
 ;
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",,1,1,DAT,DAT,1)
 Q:'$D(ORLIST)
 ;
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S C=C+1
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $L(Y),Y'=LOC Q
 . I $P(ORD,U,7)="canc" Q
 . F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. ;I $E(ORD("TX",Y),1,3)="to " Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;IHS/ITSC/LJF 12/10/2004 PATCH 1001
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
 ;
VPOV(TARGET,MULTI) ; returns diagnoses for current vuecentric visit context
 ; MULTI=0 return one line of diagnosis names; MULTI=1 return 1 line per diagnosis
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1  S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETPOV(.RESULT,VST,MULTI)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Diagnoses Found"
 Q "~@"_$NA(@TARGET)
 ;
GETPOV(RETURN,VIEN,MULTI) ;return every diagnosis for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,BTIU,LINE
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:'IEN  D
 . I 'MULTI S RETURN(1)=$G(RETURN(1))_$$GET1^DIQ(9000010.07,IEN,.04)_"; " Q
 . S CNT=$G(CNT)+1
 . K BTIU D ENP^XBDIQ1(9000010.07,IEN,".01:.13","BTIU(")
 . S LINE=""
 . I (BTIU(.12)="PRIMARY")!(CNT=1) S LINE=" [P] "         ;mark if primary dx
 . F I=.06,.05,.09,.13,.11 D                   ;check for other fields
 .. I (I=.09),BTIU(.09)]"" S LINE=LINE_"; "_$$ECODE(IEN) Q
 .. I BTIU(I)]"" S LINE=LINE_"; "_BTIU(I)
 . S RETURN(CNT)=$J(CNT,2)_") "_BTIU(.04)_LINE
 Q
 ;
ECODE(IEN) ; return narrative for e-code
 NEW X
 S X=$$GET1^DIQ(9000010.07,IEN,.09,"I") I 'X Q ""
 Q $$GET1^DIQ(80,X,3)
 ;
VPTED(TARGET,MULTI) ; returns patient education topics for current vuecentric visit context
 ; MULTI=0 return one line of education topic names; MULTI=1 return 1 line per topic
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 ;I VST="" Q " "
 I VST="" S @TARGET@(1,0)="No visit selected" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="A visit was not created." Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETPTED(.RESULT,VST,MULTI)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Patient Education Found"
 Q "~@"_$NA(@TARGET)
 ;
GETPTED(RETURN,VIEN,MULTI) ;return every edcuation topic for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,BTIU,LINE,NUM
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPED("AD",VIEN,IEN)) Q:'IEN  D
 . I 'MULTI S RETURN(1)=$G(RETURN(1))_$$GET1^DIQ(9000010.16,IEN,.01)_"; " Q
 . S CNT=$G(CNT)+1,NUM=$G(NUM)+1
 . K BTIU D ENP^XBDIQ1(9000010.16,IEN,".01;.05:.08;.11","BTIU(","I")
 . S LINE="  "_$$EDABBRV(BTIU(.01,"I"))_": "_BTIU(.08)_" min.; "
 . S LINE=LINE_BTIU(.07)_"; Understanding-"_BTIU(.06)
 . S RETURN(CNT)=$J(NUM,2)_LINE
 . S CNT=$G(CNT)+1
 . S RETURN(CNT)="  Comment: "_$E(BTIU(.11),1,60)
 Q
 ;
EDABBRV(X) ; -- returns education topic abbreviation
 Q $$GET1^DIQ(9999999.09,X,1)
 ;
VMED(TARGET,SIG) ;EP; returns medications for current vuecentric visit context
 ; If SIG is set to 1, include medication sig
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 I $G(SIG) D GETSIG(.RESULT,VST) I 1
 E  D GETMED(.RESULT,VST)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Medications Found for Visit"
 Q "~@"_$NA(@TARGET)
 ;
GETMED(RETURN,VIEN) ;EP returns all medications given for a visit
 NEW TIUX,TIUY,COUNT
 K RETURN
 S TIUX=0,TIUY="" F  S TIUX=$O(^AUPNVMED("AD",VIEN,TIUX)) Q:'TIUX  D
 . S TIUY=TIUY_$$GET1^DIQ(9000010.14,TIUX,.01)_"; "
 S:TIUY]"" TIUY=$$WRAP^TIULS(TIUY,73)
 F COUNT=1:1 Q:$P(TIUY,"|",COUNT)=""  S RETURN(COUNT)=$P(TIUY,"|",COUNT)
 Q
 ;
GETSIG(RETURN,VIEN) ;EP returns all medications given for a visit plus sig
 NEW TIUX,TIUY,TIUCNT
 K RETURN
 S (TIUCNT,TIUX)=0,TIUY=""
 F  S TIUX=$O(^AUPNVMED("AD",VIEN,TIUX)) Q:'TIUX  D
 . NEW BTIU D ENP^XBDIQ1(9000010.14,TIUX,".01;.05:.07","BTIU(")
 . ;
 . ;IHS/ITSC/LJF PATCH 1002 indent sig and place extra line between meds
 . ;S TIUY=BTIU(.01)_" #"_BTIU(.06)_" ("_BTIU(.07)_" days)" D VMSET
 . S TIUY=BTIU(.01)_" #"_BTIU(.06)_" ("_BTIU(.07)_" days)" D VMSET(0)
 . ;S TIUY=$$SIG(TIUX,BTIU(.05)) D VMSET
 . S TIUY=$$SIG(TIUX,BTIU(.05)) D VMSET(4)
 . S TIUCNT=TIUCNT+1,RETURN(TIUCNT)=""   ;new line
 . ;end of PATCH 1002 mods
 Q
 ;
VMSET(SPACES) ; -- set string into wrapped line;IHS/ITSC/LJF 4/22/2005 PATCH 1002 - added parameter
 NEW COUNT
 S:TIUY]"" TIUY=$$WRAP^TIULS(TIUY,73)
 F COUNT=1:1 Q:$P(TIUY,"|",COUNT)=""  D
 . S TIUCNT=TIUCNT+1
 . ;S RETURN(TIUCNT)=$P(TIUY,"|",COUNT)
 . S RETURN(TIUCNT)=$$SP(SPACES)_$P(TIUY,"|",COUNT)   ;IHS/ITSC/LJF 4/22/2005 PATCH 1002
 Q
 ;
SIG(VMED,SSIG) ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 ; VMED=ien in v med file; SSIG=short sig
 NEW SIG,PIECE,Y,X
 S SIG="" F PIECE=1:1:$L(SSIG," ") S X=$P(SSIG," ",PIECE) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),U,2) I $D(^(9)) S Y=$P(SSIG," ",PIECE-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),U,1)
 . S SIG=SIG_X_" "
 Q SIG
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
