BTIULO13 ;IHS/MSC/MGH - IHS OBJECTS ADDED IN PATCHES ;05-Jan-2012 13:53;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006,1009**;NOV 04, 2004;Build 22
TMORDER(DFN,TARGET) ;EP Med Orders for today
 NEW X,I,CNT,RESULT
 S CNT=0
 D GETORD(.RESULT,DFN)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .I $G(RESULT(I))'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 Q "~@"_$NA(@TARGET)
GETORD(RETURN,DFN) ;Get list of orders
 K RETURN
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C,GROUP,GROUPIEN,ORDER,OLDOR
 S C=0,OLDOR=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 S GROUP="OUTPATIENT MEDICATIONS",GROUPIEN=""
 S GROUPIEN=$O(^ORD(100.98,"B",GROUP,""))
 D EN^ORQ1(DFN_";DPT(",GROUPIEN,2,"",VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . S ORDER=+ORD
 . Q:ORDER=OLDOR
 . S ORDER=OLDOR
 . S C=C+1
 . F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. ;I $E(ORD("TX",Y),1,3)="to " Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;I
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
TOBACCO(DFN,TARGET) ;EP for new tobacco object
 NEW CTGN,HF,HFDT,LIST,RESULT,X,BTIU,CNT,CTG,X1
 I '$G(DFN) Q ""
 S CNT=0
 F BTIU=1:1 D  Q:CTG=""
 .S CTG=$P($T(TOBU+BTIU),";;",2)
 .Q:CTG=""
 .S CTGN=$O(^AUTTHF("B",CTG,0)) I 'CTGN Q    ;ien of category passed
 .;
 .S HF=0
 .F  S HF=$O(^AUTTHF("AC",CTGN,HF))  Q:'+HF  D        ;find health factors in category
 ..Q:'$D(^AUPNVHF("AA",DFN,HF))                     ;quit if patient doesn't have health factor
 ..S HFDT=$O(^AUPNVHF("AA",DFN,HF,"")) Q:'HFDT      ;get visit date for health factor
 ..S LIST(CTG,HFDT)=$O(^AUPNVHF("AA",DFN,HF,HFDT,""))   ;store iens by date
 ;
 S X1=0 F  S X1=$O(LIST(X1)) Q:X1=""  D
 .S HFDT=$O(LIST(X1,0))
 .Q:HFDT=""                    ;find latest date (inverse dates)
 .S RESULT=$S($G(CAP)=1:"Last "_CTG_" HF: ",1:"")
 .S RESULT=RESULT_$$GET1^DIQ(9000010.23,LIST(X1,HFDT),.01)
 .S X=$$GET1^DIQ(9000010.23,LIST(X1,HFDT),.04)    ;severity level
 .S RESULT=RESULT_$S(X]"":" ( "_X_")",1:"")
 .S RESULT=RESULT_" - "_$$FMTE^XLFDT(9999999-HFDT)
 .S CNT=CNT+1 S @TARGET@(CNT,0)=RESULT
 I 'CNT S @TARGET@(1,0)="No Tobacco health factors."
 Q "~@"_$NA(@TARGET)
TOBU ;;
 ;;TOBACCO (EXPOSURE)
 ;;TOBACCO (SMOKELESS - CHEWING/DIP)
 ;;TOBACCO (SMOKING)
 ;
ACTIVITY(DFN,VISIT) ;EP; returns # of activity minutes for visit in V Activity file
 I '$G(VISIT) D  I $G(VISIT)<1 Q "Invalid visit"
 . I $T(GETVAR^CIAVMEVT)="" Q
 . NEW VST
 . S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 . I VST="" Q
 . S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 Q
 . ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 . S VISIT=VST
 ;
 NEW IEN,X S IEN=$O(^AUPNVTM("AD",VISIT,0)) I 'IEN Q " "
 S X=$$GET1^DIQ(9000010.19,IEN,.01)
 Q $S(X]"":X_" minutes",1:"")
 ;
TRAVEL(DFN,VISIT) ;EP; returns # of travel minutes for visit in V Activity file
 I '$G(VISIT) D  I $G(VISIT)<1 Q "Invalid visit"
 . I $T(GETVAR^CIAVMEVT)="" Q
 . NEW VST
 . S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 . I VST="" Q
 . S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 Q
 . ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 . S VISIT=VST
 ;
 NEW IEN,X S IEN=$O(^AUPNVTM("AD",VISIT,0)) I 'IEN Q ""
 S X=$$GET1^DIQ(9000010.19,IEN,.04)
 Q $S(X]"":X_" minutes",1:"")
 ;
TOTTIME(DFN,VISIT) ;EP; returns total # of minutes (activity & travel)
 NEW A,T
 I '$G(VISIT) D  I $G(VISIT)<1 Q "Invalid visit"
 . I $T(GETVAR^CIAVMEVT)="" Q
 . NEW VST
 . S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 . I VST="" Q
 . S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 Q
 . S VISIT=VST
 ;
 S A=$$ACTIVITY($G(DFN),$G(VISIT)),T=$$TRAVEL($G(DFN),$G(VISIT))
 Q (A+T)_" minutes"
 ;
