PXRMXSEO ; SLC/PJH - Build Patient list SUBROUTINES;01/15/2002
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
 ; Called by label from PXRMXSE
 ;
 ;OE/RR team selected (PXRMOTM)
OERR N II,NAM,OTM
 S II=""
 ;Get patient list for each team
 F  S II=$O(PXRMOTM(II)) Q:II=""  D
 .S OTM=$P(PXRMOTM(II),U),NAM=$P(PXRMOTM(II),U,2)
 .;Build list of patients for OE/RR team ; DBIA 2692
 .D TEAMPTS^ORQPTQ1("^TMP($J,""OTM"",",OTM,1)
 .I $G(^TMP($J,"OTM",1))["No patients found" Q
 .D UPD("OTM","OTM")
 .D MARK
 Q
 ; 
 ;PCMM team selected (PXRMPCM)
PCMMT N SCDT,LIST,SCERR,SCLIST,II,PCM,NAM,PNAM,OK
 S SCDT("BEGIN")=PXRMSDT,SCDT("END")=PXRMSDT
 ;Include patient if in team on any day in range
 S SCDT("INCL")=0
 S II=""
 ;Get patient list for each team
 F  S II=$O(PXRMPCM(II)) Q:II=""  D
 .S PCM=$P(PXRMPCM(II),U),NAM=$P(PXRMPCM(II),U,2)
 .S OK=$$PTTM^PXRMXAP(PCM,.SCERR) Q:'OK
 .I $O(^TMP($J,"PCM",0))="" Q
 .D DUP ; Remove duplicate entries
 .D UPD("PCM","PCM")
 .D MARK
 Q
 ;
 ;PCMM provider selected (PXRMPRV)
PCMMP N SCDT,LIST,SCERR,SCLIST,II,PCM,NAM,PNAM,OK
 S SCDT("BEGIN")=PXRMSDT,SCDT("END")=PXRMSDT
 ;Include patient if in team on any day in range
 S SCDT("INCL")=0
 S II=""
 ;Get patient list for each PROVIDER
 F  S II=$O(PXRMPRV(II)) Q:II=""  D
 .S PCM=$P(PXRMPRV(II),U),NAM=$P(PXRMPRV(II),U,2)
 .;Get patients for practs. roles - excluding assoc clinics
 .N SCTEAM D PTPR^PXRMXAP(PCM,PXRMREP)
 .I $O(^TMP($J,"PCM",0))="" Q
 .D DUP ; Remove duplicate entries
 .;Save in ^TMP in alpha order within team number (internal)
 .D UPD("PCM","PCM")
 .D MARK
 Q
 ;
 ;Individual Patients selected (PXRMPAT)
IND N DUMMY,LIST,NAM
 S (DUMMY,NAM)="PATIENT"
 M ^TMP($J,"PAT")=PXRMPAT
 D UPD("DUMMY","PAT")
 Q
 ;
 ;Process ^TMP patients for PXRMSEL="L"
XTMP N SUB,TEMP,PX
 S SUB="NAM",TEMP=0,PX="PXRM"
 N DFN,PNAM,FACILITY,NAM,DDUE,DNEXT,DLAST,DDAT
 S FACILITY="",DDAT="N/A"
 F  S FACILITY=$O(^TMP(PXRMRT,$J,FACILITY)) Q:FACILITY=""  D
 .S NAM=""
 .F  S NAM=$O(^TMP(PXRMRT,$J,FACILITY,NAM)) Q:NAM=""  D
 ..S DFN=""
 ..F  S DFN=$O(^TMP(PXRMRT,$J,FACILITY,NAM,DFN)) Q:DFN=""  D
 ...;Ignore test patients SSN=000-00-...
 ...I $P($G(^XTMP("PXRMDFN"_DFN,"SSN")),"-",2,3)="000-00" Q
 ...S TEMP=TEMP+1
 ...I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D
 ....D SPIN^PXRMXBSY("Evaluating Reminders",.BUSY)
 ...I PXRMREP="D" D SDET
 ...I PXRMREP="S" D SSUM
 Q
 ;
 ;
 ;Transfer patient lists in ^TMP into ^XTMP
UPD(SUB,SUB1) ;
 N JJ,DFN,PNAM,PAT,FACILITY,PX
 N DDUE,DLAST,DNEXT,DDAT,DCLN
 ;Ignore facilities
 S FACILITY="FACILITY",DDAT="N/A"
 ;Except for PCMM team report
 I PXRMSEL="T" S FACILITY=$$FAC^PXRMXAP(@SUB1)
 ;
 S PAT="0",PX="PXRM"
 F JJ=1:1 S PAT=$O(^TMP($J,SUB1,PAT)) Q:'PAT  D
 .I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D
 ..D SPIN^PXRMXBSY("Evaluating reminders",.BUSY)
 .S DFN=$P(^TMP($J,SUB1,PAT),U),PNAM=$P(^TMP($J,SUB1,PAT),U,2)
 .;Ignore test patients SSN=000-00-...
 .I (PXRMSEL'="I"),$P($G(^XTMP("PXRMDFN"_DFN,"SSN")),"-",2,3)="000-00" Q
 .;For provider reports check if assigned as primary
 .I PXRMSEL="P",PXRMPRIM="P",($$PCASSIGN^PXRMXAP(DFN)'=1) Q
 .;For detailed provider report get assoc clinic
 .I PXRMSEL="P",PXRMREP="D" S DCLN=$P(^TMP($J,SUB1,PAT),U,7)
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
 ;Remove duplicate patient entries
DUP N CNT,DFN,SUB
 S CNT=0,SUB="PXRMSEO"
 K ^TMP($J,SUB)
 F  S CNT=$O(^TMP($J,"PCM",CNT)) Q:'CNT  D
 .S DFN=$P(^TMP($J,"PCM",CNT),U)
 .I $D(^TMP($J,SUB,DFN)) K ^TMP($J,"PCM",CNT) Q
 .S ^TMP($J,SUB,DFN)=""
 Q
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
