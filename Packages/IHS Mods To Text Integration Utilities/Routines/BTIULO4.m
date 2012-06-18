BTIULO4 ; IHS/ITSC/LJF - MORE VISIT OBJECTS FOR EHR ;07-Jun-2010 16:14;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002,1004,1005,1006**;NOV 04, 2004
 ;IHS/ITSC/LJF 02/25/2005 PATCH 1002 added code for VITALS FOR VISIT CONTEXT object
 ;Added EHR 1.1 calls for visit selection
 ;Patch 6 added text for visit not selected
 ;
VCC(TARGET) ; returns chief complaint for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW X,VST,CNT,RESULT
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid routine" Q "~@"_$NA(@TARGET)
 D GETCC(.RESULT,VST)
 ;
 K @TARGET
 S (I,CNT)=0 F  S I=$O(RESULT(I)) Q:'I  D
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)=$S(CNT=1:"Chief Complaint: ",1:$$SP(5))_RESULT(CNT)
 I 'CNT S @TARGET@(1,0)="No Chief Complaint."
 Q "~@"_$NA(@TARGET)
 ;
GETCC(RETURN,VST) ;Returns Chief Complaint array for visit
 ; VST=Visit IEN
 ;
 NEW VIEN,IEN,I,N,CNT
 K RETURN
 I $G(VST)="" S RETURN(1)="-1^Missing Input Data" Q
 S VIEN=$P(VST,"|",1) I 'VIEN S RETURN(1)="-1^No Visit IEN" Q
 I '$D(^AUPNVSIT(VIEN,0)) S RETURN(1)="-1^Visit does not exist" Q
 ;
 S CNT=0
 S IEN=0 F  S IEN=$O(^AUPNVNT("AD",VIEN,IEN)) Q:'IEN  D
 . I $$GET1^DIQ(9000010.34,IEN,.01)'="CHIEF COMPLAINT" Q
 . S N=0 F  S N=$O(^AUPNVNT(IEN,11,N)) Q:'N  D
 ..I $G(^AUPNVNT(IEN,11,N,0))'="" S CNT=CNT+1,RETURN(CNT)=$G(^AUPNVNT(IEN,11,N,0))
 I '$D(RETURN(1)) S X=$$GET1^DIQ(9000010,VST,1401) I X]"" S RETURN(1)="Visit CC: "_X
 I $D(RETURN(1)) S CNT=CNT+1 S X=$$GET1^DIQ(9000010,VST,1401) I X]"" S RETURN(CNT)="Visit CC: "_X
 Q
 ;
 ;
VCPT(TARGET) ; returns CPT codes for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW X,I,VST,CNT,RESULT,LINE
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid VISIT" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid routine" Q "~@"_$NA(@TARGET)
 D GETCPT(.RESULT,VST)
 ;
 K @TARGET
 S (I,CNT)=0,LINE="" F  S I=$O(RESULT(I)) Q:'I  D
 . S CNT=CNT+1
 . S LINE=LINE_$S(CNT=1:"CPT codes: ",1:"; ")_RESULT(CNT)
 I CNT S @TARGET@(1,0)=LINE
 I 'CNT S @TARGET@(1,0)="No CPT codes found"
 Q "~@"_$NA(@TARGET)
 ;
GETCPT(RETURN,VST) ;Returns all CPT codes for visit (short name & code)
 ; VST=Visit IEN
 ;
 NEW VIEN,IEN,I,N,CNT,QTY,MODIFR
 K RETURN
 I $G(VST)="" S RETURN(1)="-1^Missing Input Data" Q
 S VIEN=$P(VST,"|",1) I 'VIEN S RETURN(1)="-1^No Visit IEN" Q
 I '$D(^AUPNVSIT(VIEN,0)) S RETURN(1)="-1^Visit does not exist" Q
 ;
 S (IEN,CNT)=0 F  S IEN=$O(^AUPNVCPT("AD",VIEN,IEN)) Q:'IEN  D
 . K BTIU D ENP^XBDIQ1(9000010.18,IEN,".01:.16","BTIU(")
 . S CNT=CNT+1
 . S MODIFR=$$CPTMOD(.BTIU)                 ;get modifiers if any
 . S QTY="" I BTIU(.16)>1 S QTY=" Qty="_BTIU(.16)
 . S RETURN(CNT)=BTIU(.019)_MODIFR_QTY_" ("_BTIU(.01)_")"
 Q
 ;
CPTMOD(ARRAY) ; return CPT modifiers for entry IEN
 NEW X
 S X="" I ARRAY(.08)]"" S X=ARRAY(.08)                        ;modifier 1
 I ARRAY(.09)]"" S X=$S(X="":ARRAY(.09),1:X_"; "_ARRAY(.09))  ;modifier 2
 Q $S(X="":"",1:" ["_X_"]")
 ;
 ;
 ;IHS/ITSC/LJF 02/25/2005 PATCH 1002 adding subroutine for detailed display
VMSRD(TARGET) ;EP; returns msr for current vuecentric visit context in a single string
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,X
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid routine" Q "~@"_$NA(@TARGET)
 ;D GETMSR(.VST,VST_"|"_1)
 D GETMSRD(.RESULT,VST)
 ;
 K @TARGET S CNT=0
 N I,J,K
 S I="" F  S I=$O(RESULT(I)) Q:I=""  D
 .S J="" F  S J=$O(RESULT(I,J)) Q:J=""  D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=$G(RESULT(I,J))
 I 'CNT S @TARGET@(1,0)="No Measurements Found"
 Q "~@"_$NA(@TARGET)
 ;
GETMSRD(RETURN,VISIT) ; loop through visit measurements and get results
 NEW MIEN,CNT
 K RETURN
 S MIEN=0 F  S MIEN=$O(^AUPNVMSR("AD",VISIT,MIEN)) Q:'MIEN  D
 . K TIU D ENP^XBDIQ1(9000010.01,MIEN,".01;.04;2;1201","TIU(","I")
 . Q:TIU(2,"I")=1     ;SKIP ENTERED IN ERROR VITALS
 . S CNT=$G(CNT)+1
 . I TIU(.01)="WT" S TIU(.04)=$J(TIU(.04),5,2)_" ("_$J((TIU(.04)*.454),5,2)_" kg)"
 . I ((TIU(.01)="HT")!(TIU(.01)="HC")!(TIU(.01)="WC")!(TIU(.01)="AG")) S TIU(.04)=$J(TIU(.04),5,2)_" ("_$J((TIU(.04)*2.54),5,2)_" cm)"
 . I TIU(.01)="TMP" S TIU(.04)=TIU(.04)_" ("_($J((10*((TIU(.04)-32)/1.8)),5,2)/10)_" C)"
 . S RETURN(TIU(1201),TIU(.01))=$$NAME(TIU(.01,"I"))_": "_TIU(.04)_$$LSTDATE^BTIUPCC1(VISIT,TIU(1201,"I"),1)
 Q
NAME(X) ; return full name for measurement
 Q $$GET1^DIQ(9999999.07,X,.02)
 ;IHS/ITSC/LJF 02/25/2005 ned of new code for PATCH 1002
 ;
 ;
VMSR() ;EP; returns msr for current vuecentric visit context in a single string
 I $T(GETVAR^CIAVMEVT)="" Q "Invalid context variables"
 NEW X,VST
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" Q "Invalid visit"
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 Q "Invalid visit"
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETMSR(.VST,VST_"|"_1)
 Q $G(VST)
 ;
GETMSR(BTRRET,BTRIN) ; Returns common measurements for visit context
 ; input = Vien|format(0-multi-line array,1-tiu string)
 ; Return value is TYPE^VALUE^D/T^VMIEN^VIEN
 NEW DAT,TYP,C,X,TYPNM,VMIEN,VIEN,FORMAT,MSRSTR
 S C=0
 K BTRRET
 S VIEN=$P(BTRIN,"|",1) I 'VIEN S BTRRET(1)="-1^No Visit"
 S FORMAT=$P(BTRIN,"|",2) I FORMAT="" S FORMAT=0
 S VMIEN=0 F  S VMIEN=$O(^AUPNVMSR("AD",VIEN,VMIEN)) Q:'VMIEN  D
 . S X=$G(^AUPNVMSR(VMIEN,0)),DAT=+$G(^(12)) Q:X=""
 . S X2=$G(^AUPNVMSR(VMIEN,2))
 . Q:$P(X2,U,1)=1                ;SKIP ENTERED IN ERROR VITALS
 . S TYP=$P(X,U)
 . S TYPNM=$P($G(^AUTTMSR(TYP,0)),U) Q:TYPNM=""
 . S:'DAT DAT=+$G(^AUPNVSIT(VIEN,0))
 . S C=C+1
 . I FORMAT=1 D  Q
 .. S MSRSTR=TYPNM_":"_$P(X,U,4)
 .. I TYPNM="WT" S MSRSTR=TYPNM_":"_$J($P(MSRSTR,":",2),5,2)_" ("_$J(($P(X,U,4)*.454),5,2)_" kg)"
 .. I ((TYPNM="HT")!(TYPNM="WC")!(TYPNM="HC")!(TYPNM="AG")) S MSRSTR=TYPNM_":"_$J($P(MSRSTR,":",2),5,2)_" ("_$J(($P(X,U,4)*2.54),5,2)_" cm)"
 .. I TYPNM="TMP" S MSRSTR=TYPNM_":"_$J($P(MSRSTR,":",2),5,2)_" ("_(((10*(($P(X,U,4)-32)/1.8))\1)/10)_" C)"
 .. S BTRRET=$S($G(BTRRET)="":"",1:BTRRET_", ")_MSRSTR
 . S BTRRET(C)=TYPNM_U_$P(X,U,4)_U_$$CDT(DAT)_U_VMIEN_U_$P(X,U,3)
 I C=0 S BTRRET(1)="-2^No Data"
 Q
 ;
CDT(X) ;EP - Y= date/time ##/##/####@##:## from X (fm date) for display in claim editor
 N Y,ABMTIME
 I '+X S Y="" Q Y
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)  ;Y2000
 I '$P(X,".",2) Q Y
 S ABMTIME=$P(X,".",2)
 S ABMTIME=ABMTIME_"00"
 S Y=Y_"@"_$E(ABMTIME,1,2)_":"_$E(ABMTIME,3,4)
 Q Y
 ;
 ;
PAD(DATA,LENGTH) ; pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; pad spaces
 Q $$PAD(" ",NUM)
 ;
