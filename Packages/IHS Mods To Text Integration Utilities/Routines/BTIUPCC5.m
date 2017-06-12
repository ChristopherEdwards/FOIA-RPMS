BTIUPCC5 ; IHS/CIA/MGH - IHS PCC PERSONAL HEALTH OBJECTS ;06-Jan-2016 12:14;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1005,1006,1009,1012,1016**;NOV 04, 2004;Build 10
 ;This routine creates objects for the personal health
 ;data entered
 ;Patch 1006 changed the data in the V asthma lookup
 ;Patch 1009 changed the functional assessment to use entry date
 ;Patch 1012 changed for SNOMED
 ;==============================================================
INFANT(DFN,TARGET) ;EP
 ; Infant feeding data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY,ADD,IENS,IEN,X
 S FNUM=9000010.44,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.01;1201")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S IEN=$P(DATA,U,1)
 .S RESULT=$P($P(DATA,U,4),"|",1)
 .S DATE=$P($P(DATA,U,5),"|",1)
 .I DATE="" S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)=$P(DATE,"@",1)_" "_RESULT
 .;ADDITIONAL FEEDING CHOICES
 .S ADD=0 F  S ADD=$O(^AUPNVIF(IEN,13,ADD)) Q:ADD'=+ADD  D
 ..S IENS=ADD_","_IEN
 ..S X=$$GET1^DIQ(9000010.4413,IENS,.01)
 ..I X'="" D
 ...S CNT=CNT+1
 ...I $P($G(^AUPNVIF(IEN,13,ADD,0)),U,2)]""  S X=X_" COMMENT: "_$$GET1^DIQ(9000010.4413,IENS,.02)
 ...S @TARGET@(CNT,0)="   "_X
 I CNT=0 S @TARGET@(1,0)="No infant feeding data on file"
 Q "~@"_$NA(@TARGET)
FUNC(DFN,TARGET,ITEMS) ;EP
 ;Functional assessment
 N DATA,ARRAY,ARRAY2,IDATE,FNUM,CNT,RESULT,DATE,ENTRY,EDATE,FIEN,CHECK,LEN
 S FNUM=9000010.35,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;.13;.14;.15;.16;.17;.18")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0!(CNT>ITEMS)  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S FIEN=$P(DATA,U,1)
 .S EDATE=9999999-$P($G(^AUPNVELD(FIEN,12)),U,1)
 .S ARRAY2(EDATE)=DATA
 S CNT=0
 S IDATE="" F  S IDATE=$O(ARRAY2(IDATE)) Q:IDATE=""  D
 .S CNT=CNT+1
 .S DATA=$G(ARRAY2(IDATE))
 .S DATE=9999999-IDATE S DATE=$$FMTE^XLFDT(DATE)
 .S @TARGET@(CNT,0)="Assessment Date:"_DATE
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,16),"|",1)
 .S @TARGET@(CNT,0)=" Status Change: "_$$PAD(CHECK,17)_" Caregiver:   "_$P($P(DATA,U,17),"|",1)
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,4),"|",1)
 .S @TARGET@(CNT,0)=" Toileting:     "_$$PAD(CHECK,17)_" Finances:    "_$P($P(DATA,U,10),"|",1)
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,5),"|",1)
 .S @TARGET@(CNT,0)=" Bathing:       "_$$PAD(CHECK,17)_" Cooking:     "_$P($P(DATA,U,11),"|",1)
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,6),"|",1)
 .S @TARGET@(CNT,0)=" Dressing:      "_$$PAD(CHECK,17)_" Shopping:    "_$P($P(DATA,U,12),"|",1)
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,7),"|",1)
 .S @TARGET@(CNT,0)=" Transfers:     "_$$PAD(CHECK,17)_" Housework:   "_$P($P(DATA,U,13),"|",1)
 .S CNT=CNT+1
 .S CHECK=$P($P(DATA,U,8),"|",1)
 .S @TARGET@(CNT,0)=" Feeding:       "_$$PAD(CHECK,17)_" Medications: "_$P($P(DATA,U,14),"|",1)
 .S CHECK=$P($P(DATA,U,9),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Continence:    "_$$PAD(CHECK,17)_" Transportation: "_$P($P(DATA,U,15),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=""
 I CNT=0 S @TARGET@(1,0)="No functional assessment on file"
 Q "~@"_$NA(@TARGET)
BMEA(DFN,TARGET) ;EP
 ;Birth Measurement data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY,I
 S FNUM=9000024,CNT=0,ENTRY=""
 S DATA=""
 D GET^BGOBMSR(.DATA,DFN)
 I DATA="" S @TARGET@(1,0)="No birth measurement data" Q "~@"_$NA(@TARGET)
 F I=1:1:14 I $P(DATA,U,I)="" S $P(DATA,U,I)="Unknown"
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Birth Weight: "_$P(DATA,U,1)_" lbs "_$P(DATA,U,2)_" oz "_$P(DATA,U,4)_" grams"
 S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Apgar:  "_$P(DATA,U,5)_" 1 MIN "_$P(DATA,U,6)_" 5 MIN"
 ;S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Gestational Age: "_$P(DATA,U,7)_" Del Type: "_$P(DATA,U,8)
 ;S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Complications: "_$P(DATA,U,9)_" Birth Order: "_$P(DATA,U,10)
 ;S CNT=CNT+1
 S @TARGET@(CNT,0)="Formula Started: "_$P(DATA,U,11)_"     Solids Started: "_$P(DATA,U,13)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Breast Stopped: "_$P(DATA,U,12)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Mother: "_$P($P(DATA,U,14),"|",1)
 S CNT=CNT+1
 Q "~@"_$NA(@TARGET)
REF(DFN,TARGET,NUM) ;EP
 ;Refusals
 N REFIEN,CNT,TYPE,REASON
 S REFIEN="",CNT=0,ARRAY=""
 F  S REFIEN=$O(^AUPNPREF("AC",DFN,REFIEN),-1) Q:REFIEN=""  D
 .S ARRAY=$$REFGET1^BGOUTL2(REFIEN)
 .S CNT=CNT+1
 .S REASON=$P(ARRAY,U,13) I REASON="" S REASON=$P(ARRAY,U,11)
 .S @TARGET@(CNT,0)=$P(ARRAY,U,6)_" "_$P(ARRAY,U,9)_" Type: "_$P(ARRAY,U,4)_" Reason: "_REASON
 I CNT=0 S @TARGET@(1,0)="No refusals found on file"
 Q "~@"_$NA(@TARGET)
ASTHMA(DFN,TARGET) ;EP
 ;Asthma Data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY
 S FNUM=9000010.41,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.14;.08;.09;.11;")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)="Assessment Date: "_DATE
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Asthma Control: "_$P($P(DATA,U,4),"|",1)
 .S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" FEV 1: "_$P($P(DATA,U,5),"|",1)_" FEV 25-75: "_$P($P(DATA,U,6),"|",1)
 .;S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" Particulate Matter: "_$P($P(DATA,U,10),"|",1)_" Dust Mites: "_$P($P(DATA,U,11),"|",1)
 .;S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" Asthma Management Plan: "_$P($P(DATA,U,11),"|",1)
 I CNT=0 S @TARGET@(1,0)="No asthma data on file"
 Q "~@"_$NA(@TARGET)
PAIN(DFN,TARGET) ;EP
 ;Pain Contract
 N DATA,ARRAY,FNUM,CNT,TYPE,DATE,ENTRY,PROVIDER
 S FNUM=9000010.39,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.01;.04;.05")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S TYPE=$P($P(DATA,U,4),"|",1)
 .S DATE=$P($P(DATA,U,5),"|",1)
 .S PROVIDER=$P($P(DATA,U,6),"|",1)
 .S @TARGET@(CNT,0)="Contract Type: "_TYPE
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Date Initiated: "_DATE_" Provider: "_PROVIDER
 I CNT=0 S @TARGET@(1,0)="No pain contract on file"
 Q "~@"_$NA(@TARGET)
ER(DFN,TARGET) ;EP
 ;ER data
 N CNT,VST,ERIEN
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="No visit selected" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="A visit was not created." Q "~@"_$NA(@TARGET)
 S ERIEN="" S ERIEN=$O(^AMERVSIT("AD",VST,ERIEN)) D
 .I ERIEN'="" D GETDATA(ERIEN,.CNT,.TARGET)
 .I ERIEN="" S @TARGET@(1,0)="No ER visits for this encounter"
 Q "~@"_$NA(@TARGET)
LASTER(DFN,TARGET) ;EP
 N CNT,FOUND,IEN,VST
 S FOUND=0
 S CNT=0
 S IEN="" S IEN=$O(^AMERVSIT("AC",DFN,IEN),-1) D
 .I IEN'="" D GETDATA(IEN,.CNT,.TARGET)
 .I IEN="" S @TARGET@(1,0)="No ER visits on file"
 Q "~@"_$NA(@TARGET)
GETDATA(ERIEN,CNT,TARGET) ;Get the data for the visit
 N DATA,ARRAY,FNUM,RESULT,DATE,ENTRY,X,DEPART,TRANS,VST,X,INP,ERIENS
 N TRG,TRGNU,ACUITY,CLIN,INJ,TRANS,VST,FOUND
 S FNUM=9009080
 S ERIENS=ERIEN_","
 D GETS^DIQ(FNUM,ERIENS,"**","IE","ARRAY","ERR")
 ;Check in data
 S CNT=CNT+1
 S @TARGET@(CNT,0)="ADMISSION INFORMATION"
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Check-In: "_$G(ARRAY(FNUM,ERIENS,.01,"E"))
 ;Format the presenting complaint
 S COMM="Presenting Complaint: "_$G(ARRAY(FNUM,ERIENS,1,"E"))
 D COMMENTS(COMM)
 S TRG=$G(ARRAY(FNUM,ERIENS,12.1,"E"))
 S TRGNU=$G(ARRAY(FNUM,ERIENS,.07,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Triage Time: "_TRG_"    Triage Nurse: "_TRGNU
 S ACUITY=$G(ARRAY(FNUM,ERIENS,.24,"E"))
 S CLIN=$G(ARRAY(FNUM,ERIENS,.04,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Clinic: "_CLIN_"    Initial Acuity: "_ACUITY
 S CNT=CNT+1
 S @TARGET@(CNT,0)=$$STRING^BTIULO16()
 ;Injury data
 S CNT=CNT+1
 S @TARGET@(CNT,0)="INJURY INFORMATION"
 S CNT=CNT+1
 S INJ=$G(ARRAY(FNUM,ERIENS,3.1,"E"))
 S @TARGET@(CNT,0)="Was this visit caused by an injury: "_INJ
 I INJ="YES" D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Injury Occurered: "_$G(ARRAY(FNUM,ERIENS,3.4,"E"))_"   Work Related: "_$G(ARRAY(FNUM,ERIENS,2.1,"E"))
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Injury Cause: "_$G(ARRAY(FNUM,ERIENS,3.2,"E"))
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Where Injury Occurred: "_$G(ARRAY(FNUM,ERIENS,3.3,"E"))
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Safety Equipment: "_$G(ARRAY(FNUM,ERIENS,3.5,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)=$$STRING^BTIULO16()
 ;VISIT DATA
 S CNT=CNT+1
 S @TARGET@(CNT,0)="VISIT INFORMATION"
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Primary Nurse: "_$G(ARRAY(FNUM,ERIENS,6.4,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Medical Screening Exam Time: "_$G(ARRAY(FNUM,ERIENS,12.1,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="ED Provider: "_$G(ARRAY(FNUM,ERIENS,.06,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Decision to Admit Time: "_$G(ARRAY(FNUM,ERIENS,12.8,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="ER Consult Notified: "_$G(ARRAY(FNUM,ERIENS,.22,"E"))
 ;Get consults
 I $D(^AMERVSIT(ERIEN,19))>0 D CONSULT(ERIEN)
 ;Get procedures
 I $D(^AMERVSIT(ERIEN,4))>0 D PROC(ERIEN)
 ;Get Dxs
 I $D(^AMERVSIT(ERIEN,5))>0 D DXS(ERIEN)
 S CNT=CNT+1
 S @TARGET@(CNT,0)=$$STRING^BTIULO16()
 S CNT=CNT+1
 S @TARGET@(CNT,0)="DISPOSITION INFORMATION"
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Final Acuity: "_$G(ARRAY(FNUM,ERIENS,5.4,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Disposition: "_$G(ARRAY(FNUM,ERIENS,6.1,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Disch Prov: "_$G(ARRAY(FNUM,ERIENS,6.3,"E"))_"   Disch Nurse: "_$G(ARRAY(FNUM,ERIENS,6.4,"E"))
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Departure Time: "_$G(ARRAY(FNUM,ERIENS,6.2,"E"))
 S CNT=CNT+1
 S TRANS=$G(ARRAY(FNUM,ERIENS,6.6,"E"))
 I TRANS'="" D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Transferred to: "_TRANS
 S COMM="Disch Instruction: "_$G(ARRAY(FNUM,ERIENS,7,"E"))
 D COMMENTS(COMM)
 Q
COMMENTS(COMM) ;Add in fields that can be 245 characters
 N MAXLEN,TXT2,SUBCOUNT,SUBLINE
 S MAXLEN=62
 I $L(COMM)>MAXLEN D
 .S TXT2=$$WRAP^TIULS(COMM,MAXLEN)
 .F SUBCOUNT=1:1 S SUBLINE=$P(TXT2,"|",SUBCOUNT) Q:SUBLINE=""  D ADD2(SUBLINE)
 E  D ADD2(COMM)
 ;
ADD2(TXT) ;
 S CNT=CNT+1
 S @TARGET@(CNT,0)=TXT
 Q
CONSULT(ERIEN) ;Get the consults for this visit
 N SIEN,NODE,CONS,PRV
 S CNT=CNT+1
 S @TARGET@(CNT,0)="CONSULTS"
 S SIEN=0 F  S SIEN=$O(^AMERVSIT(ERIEN,19,SIEN)) Q:'+SIEN  D
 .S NODE=$G(^AMERVSIT(ERIEN,19,SIEN,0))
 .S CONS=$P($G(^AMER(2.9,$P(NODE,U,1),0)),U,1)
 .S PRV=$P($G(^VA(200,$P(NODE,U,3),0)),U,1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="   "_CONS_"   Provider: "_PRV
 Q
PROC(ERIEN) ;Get the procedures for this visit
 N SIEN,NODE,PROC
 S CNT=CNT+1
 S @TARGET@(CNT,0)="PROCEDURES"
 S SIEN=0 F  S SIEN=$O(^AMERVSIT(ERIEN,4,SIEN)) Q:'+SIEN  D
 .S PROC=$G(^AMERVSIT(ERIEN,4,SIEN,0))
 .S PROC=$$GET1^DIQ(9009083,PROC,.01)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="   "_PROC
 Q
DXS(ERIEN) ;Get the Dxs for this visit
 N SIEN,NODE,DX,NARR
 S CNT=CNT+1
 S @TARGET@(CNT,0)="DIAGNOSES"
 S SIEN=0 F  S SIEN=$O(^AMERVSIT(ERIEN,5,SIEN)) Q:'+SIEN  D
 .S DX=$G(^AMERVSIT(ERIEN,5,SIEN,0))
 .S NARR=$G(^AMERVSIT(ERIEN,5,SIEN,1))
 .S DX=$$GET1^DIQ(80,DX,.01)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="   "_DX_"   "_NARR
 Q
PAD(D,L,C) ;EP
 ;---> Pad the length of data to a total of L characters
 ;---> by adding spaces to the end of the data.
 ;     Example: S X=$$PAD("MIKE",7)  X="MIKE   " (Added 3 spaces.)
 ;---> Parameters:
 ;     1 - D  (req) Data to be padded.
 ;     2 - L  (req) Total length of resulting data.
 ;     3 - C  (opt) Character to pad with (default=space).
 ;
 Q:'$D(D) ""
 S:'$G(L) L=$L(D)
 S:$G(C)="" C=" "
 Q $E(D_$$REPEAT^XLFSTR(C,L),1,L)
