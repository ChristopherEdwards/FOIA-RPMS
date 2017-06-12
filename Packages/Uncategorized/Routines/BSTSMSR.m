BSTSMSR ;GDIT/HS/BEE-Standard Terminology API Program - Return Measurements ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**6**;Sep 10, 2014;Build 20
 ;
 Q
 ;
 ;Adapted from BTIUPCC1 - Needed to put in BSTS so TIU application would not be required
 ;
LASTMSR(DFN,BSTSMSR,BSTSCAP,BSTSDAT) ;EP; -- returns last measurement for patient
 ; BSTSMSR=measurement name
 ; BSTSCAP=1 if caption with measurement name is to be returned
 ; BSTSDAT=1 return date measurement taken
 NEW LINE,X,VAIN
 ;Run different routine if patient is an inpatient
 ;Added in patch 4
 D INP^VADPT
 I $G(VAIN(1)) S LINE=$$ILSTMEAS(DFN,BSTSMSR,.VAIN)
 I '$G(VAIN(1)) S LINE=$$LSTMEAS(DFN,BSTSMSR)
 S X=$S($G(BSTSCAP):"Last "_BSTSMSR_": ",1:"")
 ;
 NEW Y,RET,VMIEN
 I $P(LINE,U,2)="" Q X_$P(LINE,U)
 I BSTSMSR="TMP" S Y=$P(LINE,U),Y=Y_" F ["_$J((Y-32)*(5/9),3,1)_" C]",$P(LINE,U)=Y
 I ((BSTSMSR="HT")!(BSTSMSR="HC")!(BSTSMSR="WC")!(BSTSMSR="AG")) S Y=$P(LINE,U),Y=$J(Y,5,2)_" in ["_$J((Y*2.54),5,2)_" cm]",$P(LINE,U)=Y
 I BSTSMSR="WT" S Y=$P(LINE,U),Y=$J(Y,5,2)_" lb ["_$J((Y*.454),5,2)_" kg]",$P(LINE,U)=Y
 I BSTSMSR="BMI" D
 .S VMIEN=$P(LINE,U,2)
 .S Y=$P(LINE,U),Y=$J(Y,5,2)
 .I $$PREG(DFN,VMIEN)=1 S Y=Y_"*"
 .S $P(LINE,U)=Y
 I $P(LINE,U,4)="" S RET=X_$P(LINE,U)_$$LSTDATE($P(LINE,U,2),$P(LINE,U,3),$G(BSTSDAT))
 I $P(LINE,U,4)'="" S RET=X_$P(LINE,U)_$$LSTDATE($P(LINE,U,2),$P(LINE,U,3),$G(BSTSDAT))_" Qualifiers: "_$P(LINE,U,4)
 Q RET
 ;
LSTMEAS(DFN,BSTSMSR) ; -- returns most current measurement (internal values)
 NEW MSR,VDT,IEN,X,Y,TIU,LINE,ARR,DATE,STOP,QUALIF
 S MSR=$O(^AUTTMSR("B",BSTSMSR,0)) I MSR="" Q ""
 ;
 S VDT=0
 S LINE=""
 F  S VDT=$O(^AUPNVMSR("AA",DFN,MSR,VDT)) Q:'VDT!(LINE'="")  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVMSR("AA",DFN,MSR,VDT,IEN)) Q:'IEN  D
 .. K TIU D ENP^XBDIQ1(9000010.01,IEN,".03;.04;2;1201","TIU(","I")
 .. ; value ^ visit ien ^ event date internal format
 .. Q:TIU(2,"I")=1                ;Quit if entered in error
 .. S LINE=$G(TIU(.04))_U_$G(TIU(.03,"I"))_U_$G(TIU(1201,"I"))
 .. S DATE=$S($G(TIU(1201,"I"))]"":TIU(1201,"I"),1:(9999999-$P(VDT,"."))_"."_$P(VDT,".",2))
 .. S QUALIF=$$QUAL(IEN)
 .. S ARR(DATE,IEN)=LINE_U_QUALIF_U_IEN
 ;
 I '$D(ARR) Q "None found"
 S DATE=$O(ARR(""),-1),IEN=$O(ARR(DATE,""),-1),LINE=ARR(DATE,IEN)
 Q $G(LINE)
 ;
LSTDATE(DATE1,DATE2,YES) ;EP -- returns event date or visit date;PATCH 1002 fixed typo
 I 'YES Q ""  ;no date asked for
 ;
 I $G(DATE2) Q "  ("_$$FMTE^XLFDT(DATE2)_")"  ;event date
 I 'DATE1 Q " "
 N Y S Y=$$GET1^DIQ(9000010,+DATE1,.01,"I") ;visit date from visit ien
 Q "  ("_$$FMTE^XLFDT(Y)_")"  ;visit date from visit ien
 ;
 ;Adapted from BTIUPCC4 - Needed to put in BSTS so TIU application would not be required
 ;
ILSTMEAS(DFN,TIUMSR,VAIN) ; -- returns most current measurement (internal values)
 ;Designed to return most recent vital signs for inpatients
 NEW MSR,VDT,IEN,X,TIU,LINE,ARR,DATE,STOP,ISINP,QUALIF
 S MSR=$O(^AUTTMSR("B",TIUMSR,0)) I MSR="" Q ""
 ;
 ;Check whether patient is an inpatient or not
 I $G(VAIN(1)) D
 .S STOP=(9999999-$P(VAIN(7),U,1)\1)+1
 I 'STOP Q "Patient is not an inpatient"         ;none to be found
 S VDT=0
 F  S VDT=$O(^AUPNVMSR("AE",DFN,MSR,VDT)) Q:'VDT!(VDT>STOP)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVMSR("AE",DFN,MSR,VDT,IEN)) Q:'IEN  D
 .. K TIU D ENP^XBDIQ1(9000010.01,IEN,".03;.04;1201;2","TIU(","I")
 .. ; value ^ visit ien ^ event date internal format
 .. Q:TIU(2,"I")=1    ;Quit if entered in error
 .. S QUALIF=$$QUAL(IEN)
 .. S LINE=$G(TIU(.04))_U_$G(TIU(.03,"I"))_U_$G(TIU(1201,"I"))_U_QUALIF
 .. S DATE=$S($G(TIU(1201,"I"))]"":TIU(1201,"I"),1:(9999999-$P(VDT,"."))_"."_$P(VDT,".",2))
 .. S ARR(DATE,IEN)=LINE
 ;
 I '$D(ARR)!($D(ARR)=0) S LINE="Not done while inpatient" Q LINE
 S DATE=$O(ARR(""),-1),IEN=$O(ARR(DATE,""),-1),LINE=ARR(DATE,IEN)
 K VAIN
 Q $G(LINE)
 ;
ILSTDATE(DATE1,DATE2,YES) ;EP -- returns event date or visit date;PATCH 1002 fixed typo
 I 'YES Q ""  ;no date asked for
 ;
 I $G(DATE2) Q "  ("_$$FMTE^XLFDT(DATE2)_")"  ;event date
 I 'DATE1 Q " "
 Q "  ("_$$GET1^DIQ(9000010,+DATE1,.01)_")"  ;visit date from visit ien
 ;
 ;Adapted from BTIULO7A - Needed to put in BSTS so TIU application would not be required 
 ;
QUAL(MEAS) ; Get qualifiers for a measurement
 N QUALS,QUALN,QUALIF,TYPE,TNAME,O2
 S (QUALIF,O2)=""
 S TYPE=$P($G(^AUPNVMSR(MEAS,0)),U,1)
 S TNAME=$P($G(^AUTTMSR(TYPE,0)),U,1)
 S QUALS=0 F  S QUALS=$O(^AUPNVMSR(MEAS,5,QUALS)) Q:QUALS=""  D
 .S QUALN=$P($G(^AUPNVMSR(MEAS,5,QUALS,0)),U,1)
 .I +QUALN S QUALN=$P($G(^GMRD(120.52,QUALN,0)),U,1)
 .I QUALIF="" S QUALIF=QUALN
 .E  I QUALN'="" S QUALIF=QUALIF_","_QUALN
 I TNAME="O2" D
 .S O2=$P($G(^AUPNVMSR(MEAS,0)),U,10)
 .S QUALIF=QUALIF_" "_O2
 Q QUALIF
 ;
 ;Adapted from BTIUPCC6 - Needed to put in BSTS so TIU application would not be required 
 ;
PREG(DFN,VIEN,VMIEN) ;Determine if BMI is for pregnant patient
 N DOB,X1,X1,TAGE,POV,CODE,TAX,RET
 S RET=0
 S VMIEN=$G(VMIEN),VIEN=$G(VIEN)
 I $$GET1^DIQ(2,DFN,.02,"I")'="F" Q RET    ;Wrong sex
 S TAGE=$$GET1^DIQ(2,DFN,.033)
 I TAGE<10!(TAGE>50) Q RET             ;Wrong age
 ;Find POVs on this visit and check if they are pregnancy POVs
 I VIEN="" D
 .S VIEN=$$GET1^DIQ(9000010.01,VMIEN,.03,"I")
 I '+VIEN Q RET
 S TAX=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 S POV="" F  S POV=$O(^AUPNVPOV("AD",VIEN,POV)) Q:POV=""!(RET=1)  D
 .S CODE=$$GET1^DIQ(9000010.07,POV,.01,"I")
 .I CODE="" Q
 .S RET=$$ICD^ATXCHK(CODE,TAX,9)
 Q RET
