BPXRMSEO ;IHS/MSC/MGH - Reminder Reports lookup for IHS;31-May-2013 10:57;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;
 ; Called by label from PXRMXSE
 ;
TMP(DFN,NAM,FACILITY,INP) ;Update ^TMP("PXRMX"
 I PXRMFCMB="Y" S FACILITY="COMBINED FACILITIES"
 I PXRMLCMB="Y" S NAM="COMBINED LOCATIONS"
 S ^TMP("PXRMX",$J,FACILITY,NAM,DFN)=INP
 Q
 ;
 ;Mark location as found
MARK(IC) ;
 S ^XTMP(PXRMXTMP,"MARKED AS FOUND",IC)=""
 Q
 ;
 ;IHS designated provider selected (PXRMPRV)
IHS N SCDT,LIST,SCERR,SCLIST,II,PCP,NAM,PNAM,OK,BUSY,CNT
 N DCLN,DBDOWN,DLAST,DDUE,DDAT,DNEXT,ITEM,LIT,PX,TODAY
 S DBDOWN=0
 I '(PXRMQUE!$D(IO("S"))) D INIT^PXRMXBSY(.BUSY)
 ;S SCDT("BEGIN")=9999999-PXRMBDT
 ;S SCDT("END")=9999999-PXRMEDT
 S SCDT("BEGIN")=PXRMSDT,SCDT("END")=PXRMSDT
 ;Include patient if on any day in range
 S SCDT("INCL")=0
 S II=""
 ;Get patient list for each PROVIDER
 F  S II=$O(PXRMPRV(II)) Q:II=""  D
 .S PCP=$P(PXRMPRV(II),U),NAM=$P(PXRMPRV(II),U,2)
 .;Get patients for practs. roles - excluding assoc clinics
 .N SCTEAM D PTPR(PCP)
 .I $O(^TMP($J,"PCP",0))="" Q
 .;Save in ^TMP in alpha order within team number (internal)
 .S CNT=0 F  S CNT=$O(^TMP($J,"PCP",CNT)) Q:CNT'>0  D
 ..S DFN=$P(^TMP($J,"PCP",CNT),U)
 ..I ('(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")))&(DBDOWN=0) D SPIN^PXRMXBSY("Collecting pts from Designated Provider list",.BUSY)
 ..;For detailed provider report get assoc clinic
 ..I PXRMREP="D" S DCLN=$P(^TMP($J,"PCP",CNT),U,7) I +$G(DCLN)>0 D
 ...S FACILITY=$$HFAC^PXRMXSL1(DCLN)
 ...S NAM=$P(^SC(DCLN,0),U)
 ...S ^XTMP(PXRMXTMP,"HLOC",DCLN)=FACILITY_U_NAM
 ..I $G(DCLN)'="" S PXRMDCLN(DCLN)=""
 ..D UPD1(DFN,NAM,"FACILITY",+$G(DCLN))
 .D MARK(PCP)
 K ^TMP($J,"PCP")
 I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D DONE^PXRMXBSY("Done")
 I PXRMREP="D",$D(^TMP($J,"PXRM PATIENT EVAL"))>0 D SDAM301^PXRMXSL2(DT,"",PXRMSEL,PXRMFD,PXRMREP)
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
UPD1(DFN,NAM,FACILITY,INP) ;
 ;Remove test patients.
 I 'PXRMTPAT,$$TESTPAT^VADPT(DFN)=1 Q
 ;Remove patients that are deceased.
 I 'PXRMDPAT,$P($G(^DPT(DFN,.35)),U,1)>0 Q
 S ^TMP($J,"PXRM PATIENT LIST",DFN)=""
 S ^TMP($J,"PXRM PATIENT EVAL",DFN)=""
 D TMP(DFN,NAM,FACILITY,INP)
 Q
 ;
 ;Detailed report
SDET I $G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB))="" D
 .S ^XTMP(PXRMXTMP,PX,FACILITY,@SUB)=NAM
 ;Applicable
 N APPL,STATUS S APPL=0,STATUS=""
 ;Check if due and/or applicable (active reminder for live patient)
 I $P($G(^PXD(811.9,ITEM,0)),U,6)'=1 D
 .D MAIN^PXRM(DFN,ITEM,0)
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
PTPR(BSDPRV) ;Find the lisZTt of this provider's primary care pts
 N DFN,NAME,COMM
 S DFN=0 F  S DFN=$O(^AUPNPAT("AK",+BSDPRV,DFN)) Q:'DFN  D
 . S NAME=$$GET1^DIQ(2,DFN,.01)
 . S ^TMP($J,"PCP",DFN)=DFN_"^"_NAME
 Q
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
