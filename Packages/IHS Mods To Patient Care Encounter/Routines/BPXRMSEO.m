BPXRMSEO ;IHS/CIA/MGH - Reminder Reports lookup for IHS;25-Sep-2006 14:14;MGH
 ;;1.5;CLINICAL REMINDERS;**6,1004**;Jun 19, 2000
 ;
 ; Called by label from PXRMXSE
IHS ; EP IHS designated provider selected (PXRMPRV)
 N SCDT,LIST,SCERR,SCLIST,II,PCP,NAM,PNAM,OK
 S SCDT("BEGIN")=9999999-PXRMBDT
 S SCDT("END")=9999999-PXRMEDT
 ;Include patient if on any day in range
 S SCDT("INCL")=0
 S II=""
 ;Get patient list for each PROVIDER
 F  S II=$O(PXRMPRV(II)) Q:II=""  D
 .S PCP=$P(PXRMPRV(II),U),NAM=$P(PXRMPRV(II),U,2)
 .;Get patients for practs. roles - excluding assoc clinics
 .N SCTEAM D PTPR(PCP)
 .I $O(^TMP($J,"PCP",0))="" Q
 .D VISIT(PCP) ; Did they have a visit in the time frame?
 .;Save in ^TMP in alpha order within team number (internal)
 .D UPD("PCP","PCP")
 .D MARK
 Q
 ;
VISIT(PCP) ;
 N CNT,DFN,FOUND,SUB,IEN,PIEN,PROV
 S CNT=0,FOUND=0
 K ^TMP($J,"BPXRMPIEN")
 F  S CNT=$O(^TMP($J,"PCP",CNT)) Q:'CNT  D
 .S SUB="" F  S SUB=$O(^AUPNVSIT("AA",CNT,SUB)) Q:SUB=""!(SUB>SCDT("END"))!(FOUND=1)  D
 ..;Loop through the visit file using the start and end dates
 ..;Find visits for this patient in the date range
 ..;If there is one there, use this visit number to see if this provider
 ..;saw the patient,  If so include it in the list to evaluate
 ..S IEN="" F  S IEN=$O(^AUPNVSIT("AA",CNT,SUB,IEN)) Q:IEN=""  D
 ...S PIEN="" F  S PIEN=$O(^AUPNVPRV("AD",IEN,PIEN)) Q:PIEN=""  D
 ....S PROV=$P($G(^AUPNVPRV(PIEN,0)),U,1)
 ....I PROV=PCP S ^TMP($J,"BPXRMPIEN",CNT)="" S FOUND=1
 Q
 ;
 ;
 ;Transfer patient lists in ^TMP into ^XTMP
UPD(SUB,SUB1) ;
 N JJ,DFN,PNAM,PAT,FACILITY,PX
 N DDUE,DLAST,DNEXT,DDAT,DCLN
 ;Ignore facilities
 S FACILITY="FACILITY",DDAT="N/A"
 ;
 S PAT="0",PX="PXRM"
 F JJ=1:1 S PAT=$O(^TMP($J,SUB1,PAT)) Q:'PAT  D
 .I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D
 ..D SPIN^PXRMXBSY("Evaluating reminders",.BUSY)
 .S DFN=$P(^TMP($J,SUB1,PAT),U),PNAM=$P(^TMP($J,SUB1,PAT),U,2)
 .;Ignore test patients SSN=000-00-...
 .I (PXRMSEL'="I"),$P($G(^XTMP("PXRMDFN"_DFN,"SSN")),"-",2,3)="000-00" Q
 .;For detailed provider report get assoc clinic
 .I PXRMSEL="D",PXRMREP="D" S DCLN=$P(^TMP($J,SUB1,PAT),U,7)
 .D:PXRMREP="D" SDET
 .D:PXRMREP="S" SSUM
 K ^TMP($J,SUB1)
 Q
 ;
 ;
 ;Detailed report
SDET I $G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB))="" D
 .S ^XTMP(PXRMXTMP,PX,FACILITY,@SUB)=NAM
 ;Applicable
 N APPL,STATUS S APPL=0,STATUS=""
 ;Check if due and/or applicable (active reminder for live patient)
 I $P($G(^PXD(811.9,ITEM,0)),U,6)'=1 D
 .D DATE^PXRM(DFN,ITEM,5,1,PXRMSDT)
 .;Quit if nothing returned
 .S STATUS=$P($G(^TMP("PXRHM",$J,ITEM,LIT)),U) Q:STATUS=""
 .;Exclude dead patients from applicable
 .I $G(^XTMP("PXRMDFN"_DFN,"DOD"))'="" Q
 .;Add any that aren't N/A, Ignore on N/A or NEVER to applicable total
 .I (STATUS'=" ")&(STATUS'["NEVER")&(STATUS'["N/A")&(STATUS'="ERROR") S APPL=1
 ;
 ;If DUE NOW save details
 I STATUS["DUE NOW" D
 .S DDUE=$P($G(^TMP("PXRHM",$J,ITEM,LIT)),U,2)
 .S DLAST=$P($G(^TMP("PXRHM",$J,ITEM,LIT)),U,3)
 .;Next appointment for location or clinic
 .I PXRMSEL="L" D
 ..I $E(PXRMLCSC,2)'="A" D DNEXT($G(^TMP("PXRMX",$J,FACILITY,NAM,DFN)))
 ..I $E(PXRMLCSC,2)="A" D DNEXT("")
 ..S PNAM=$G(^XTMP("PXRMDFN"_DFN,"PATIENT"))
 ..; Allow for cache being rebuilt for another user
 ..I PNAM="" S PNAM=" "
 .;Next appointment date at any location
 .I PXRMSEL'="L" D
 ..;For detailed provider report get next appoint. for assoc. clinic
 ..I PXRMREP="D",PXRMSEL="P" S DNEXT="" D:DCLN'="" DNEXT(DCLN) Q
 ..;Otherwise get next appointment for centre
 ..D DNEXT("")
 .;Sort by next appointment date
 .I PXRMSRT="Y" S DDAT=$P(DNEXT,".") S:DDAT="" DDAT="NONE"
 .;Patient ward/bed used only for inpatient reports
 .N BED,TXT S BED=""
 .S TXT=DFN_U_DDUE_U_DLAST_U_DNEXT
 .I $G(PXRMINP) D
 ..S BED=$G(^DPT(DFN,.101)) S:BED="" BED="NONE"
 ..S TXT=TXT_U_BED
 ..;Sort by bed
 ..I PXRMSRT="B" S DDAT=BED
 .;Duplicate check for combined report
 .I PXRMFCMB="Y",'$$NEW(SUB,DDAT,PNAM) Q
 .;Save entry in ^XTMP
 .S ^XTMP(PXRMXTMP,PX,FACILITY,@SUB,DDAT,PNAM)=TXT
 .;Total of reminders overdue
 .N CNT
 .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,2)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,2)=CNT+1
 ;Total of patients checked/applicable
 N CNT,NEW
 S NEW=1 I PXRMFCMB="Y" S NEW=$$NEWP(SUB,DFN)
 I NEW D
 .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,3)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,3)=CNT+1
 .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,4)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,4)=CNT+APPL
 K ^TMP("PXRM",$J),^TMP("PXRHM",$J)
 Q
 ;
 ;Find next appointment date
DNEXT(IEN) ;
 N FOUND
 S DNEXT=TODAY,FOUND=0
 F  S DNEXT=$O(^DPT(DFN,"S",DNEXT)) Q:DNEXT=""  D  Q:FOUND  ; DBIA 1301
 .;Ignore cancelled appointments
 .I $P($G(^DPT(DFN,"S",DNEXT,0)),U,2)["C" Q
 .I (IEN>0),(+$P($G(^DPT(DFN,"S",DNEXT,0)),U)'=IEN) Q
 .S FOUND=1
 Q
 ;
 ;Summary report
SSUM N CNT,INAM
 S (ITEM,CNT)=""
 ;Check each reminder in the list
 F  S CNT=$O(REMINDER(CNT)) Q:CNT=""  D
 .S ITEM=$P(REMINDER(CNT),U,1)
 .S LIT=$P(REMINDER(CNT),U,4)
 .S:LIT="" LIT=$P(REMINDER(CNT),U,2)
 .D SSUMX
 ;Total of patients
 I "IR"[PXRMTOT D
 .I $G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB))="" D
 ..S ^XTMP(PXRMXTMP,PX,FACILITY,@SUB)=NAM
 .N CNT
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB)),U,3)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,3)=CNT+1
 ;Total reports
 I "TR"[PXRMTOT D
 .I '$$NEWT(FACILITY,DFN) Q
 .I $G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"))="" D
 ..S ^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")=NAM
 .N CNT
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")),U,3)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"),U,3)=CNT+1
 Q
 ;
 ;Evaluate reminders for patient
SSUMX N DUE,EVAL S DUE=0,EVAL=0
 ;Check if due (active reminders only)
 I $P($G(^PXD(811.9,ITEM,0)),U,6)'=1 D
 .;Evaluate reminder
 .D DATE^PXRM(DFN,ITEM,5,1,PXRMSDT)
 .;Quit if nothing returned
 .I $G(^TMP("PXRHM",$J,ITEM,LIT))="" Q
 .;Exclude dead patients from applicable
 .I $G(^XTMP("PXRMDFN"_DFN,"DOD"))'="" Q
 .;Extract status
 .N STATUS S STATUS=$P($G(^TMP("PXRHM",$J,ITEM,LIT)),U)
 .;Add dues to totals of reminders due and reminders applicable
 .I STATUS["DUE NOW" S DUE=1,EVAL=1 Q
 .;Add any that aren't N/A, Ignore on N/A,ERROR or NEVER to applicable total
 .I (STATUS'=" ")&(STATUS'["NEVER")&(STATUS'="N/A")&(STATUS'="ERROR") S EVAL=1
 ;
 ;Update XTMP - Total of reminders due
 I "IR"[PXRMTOT D
 .;Combined facility duplicate check
 .I PXRMFCMB="Y",'$$NEW(SUB,DFN,ITEM) Q
 .N CNT
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB,ITEM)),U,1)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB,ITEM),U,1)=CNT+EVAL
 .;Total of reminders evaluated
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB,ITEM)),U,2)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB,ITEM),U,2)=CNT+DUE
 ;
 ;Totals
 I "RT"[PXRMTOT D
 .;Check for duplicate patient at FACILITY level
 .I $D(^TMP("PXRMDUP",$J,FACILITY,DFN,ITEM)) Q
 .;Set duplicate check
 .S ^TMP("PXRMDUP",$J,FACILITY,DFN,ITEM)=""
 .I $G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"))="" D
 ..S ^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")=NAM
 .N CNT
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM)),U,1)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM),U,1)=CNT+EVAL
 .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM)),U,2)
 .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM),U,2)=CNT+DUE
 ;
 K ^TMP("PXRM",$J),^TMP("PXRHM",$J)
 Q
 ;
 ;
 ;Mark selected item as found
MARK S ^XTMP(PXRMXTMP,"MARKED AS FOUND",II)=""
 Q
 ;
 ;Combined report duplicate check (Summary report)
NEW(SUB,SUB1,SUB2) ;
 ;Existing entry
 I $D(^TMP("PXRMCMB",$J,@SUB,SUB1,SUB2)) Q 0
 ;New entry
 S ^TMP("PXRMCMB",$J,@SUB,SUB1,SUB2)=""
 Q 1
 ;
 ;Combined report duplicate check (Detail report)
NEWP(SUB,DFN) ;
 ;Existing entry
 I $D(^TMP("PXRMCMB1",$J,@SUB,DFN)) Q 0
 ;New entry
 S ^TMP("PXRMCMB1",$J,@SUB,DFN)=""
 Q 1
 ;
 ;Combined report duplicate check (Patient totals)
NEWT(FACILITY,DFN) ;
 ;Existing entry
 I $D(^TMP("PXRMCMB2",$J,FACILITY,DFN)) Q 0
 ;New entry
 S ^TMP("PXRMCMB2",$J,FACILITY,DFN)=""
 Q 1
PTPR(BSDPRV) ;Find the list of this provider's primary care pts
 N DFN,NAME,COMM
 S DFN=0 F  S DFN=$O(^AUPNPAT("AK",+BSDPRV,DFN)) Q:'DFN  D
 . S NAME=$$GET1^DIQ(2,DFN,.01)
 . S ^TMP($J,"PCP",DFN)=DFN_"^"_NAME
 Q
