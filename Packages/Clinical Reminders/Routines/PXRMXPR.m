PXRMXPR ; SLC/PJH - Print Reminder Due report. ;03-Nov-2005 13:29;MGH
 ;;1.5;CLINICAL REMINDERS;**2,6,1004**;Jun 19, 2000
 ;IHS/CIA/MGH Modified to use HRCN instead of SSN
 ;Modifications also made for displaying reports for IHS providers
 ; Called/Jobbed after PXRMXSE
 ;
START N BMARG,CRITERIA,C1S,C2S,C3S,C1HS,C2HS,C3HS,DONE,HEAD
 N INDENT,PAGE,MOD,DES,ADES,CDES,RDES,SDES,MATCH,MISSED,SEP
 ;
 N PXRMOPT,PXRMFLD,PXRMHDR,PXRMHDRS,PXRMT,PXRMH
 N BD,ED,SD,RD
 ;
 N PXRMTX
 S PXRMTX="due"
 ;
 I PXRMREP="D" D
 .S EMPCHK=$P($G(^PXRM(800,1,"TRUNCATE EMPLOYEE SSN")),U)
 .I EMPCHK="" S EMPCHK="Y"
 ;
 ; Format Date Range
 ;IHS/CIA/MGH added dates for primary care lookup
 I PXRMSEL="L"!(PXRMSEL="D") D
 .S BD=$$FMTE^XLFDT(PXRMBDT,"5D")
 .S ED=$$FMTE^XLFDT(PXRMEDT,"5D")
 ; Format due effective date
 S SD=$$FMTE^XLFDT(PXRMSDT,"5D")
 ; Format run date
 S RD=$$FMTE^XLFDT(PXRMXST,"5P")
 ;
 U IO
 S DONE=0,MATCH=0,SEP=" "
 ;
 ;Condensed report
 I PXRMTABS="Y" D
 .I PXRMTABC="C" S SEP=","
 .I PXRMTABC="M" S SEP=";"
 .I PXRMTABC="S" S SEP=" "
 .I PXRMTABC="T" S SEP=$C(9)
 .I PXRMTABC="U" S SEP="^"
 ;
 ;Setup initial formatting parameters.
 S INDENT=3
 S BMARG=2,PAGE=0,HEAD=1
 ;
 ;
 I +$G(XQY)>0 N XQOPT D OP^XQCHK
 S PXRMOPT=$P($G(XQOPT),U,2)
 I ($L(PXRMOPT)>0)&(PXRMOPT'["Clinical") S PXRMOPT="Clinical "_PXRMOPT
 I PXRMREP="D" D
 .S RDES=$P(REMINDER(1),U,2)
 .S PXRMOPT=PXRMOPT_" - Detailed Report"
 .N IC F IC=0,3,4 S PXRMH(IC)="",PXRMT(IC)=0
 .S PXRMH(1)="Date Due    Last Done   Next Appt"
 .S PXRMH(2)="--------    ---------   ---------"
 .I $G(PXRMINP) D
 ..S PXRMH(1)="Date Due    Last Done   Ward/Bed"
 ..S PXRMH(2)="--------    ---------   --------"
 .F IC=1,2 S PXRMT(IC)=40
 .S ADES="Next Appointment only"
 .I PXRMFUT="Y" S ADES="All Future Appointments"
 .S SDES="Sorted by Patient Name"
 .I PXRMSRT="Y" S SDES="Sorted by Appointment Date"
 I PXRMREP="S" D
 .S PXRMOPT=PXRMOPT_" - Summary Report"
 .S PXRMH(0)="# Patients with Reminders",PXRMT(0)=50
 .S PXRMH(1)="Applicable           Due"
 .S PXRMH(2)="----------           ---"
 .N IC F IC=1,2 S PXRMT(IC)=50
 .S PXRMH(3)="Denominator"
 .S PXRMH(4)="-----------"
 .F IC=3,4 S PXRMT(IC)=0
 ;
 ;Print Criteria Page if normal report
 S CRITERIA=0 I PXRMTABS="N" S CRITERIA=1
 ;or delimited report with notemplate
 I PXRMTABS="Y",PXRMTMP="" S CRITERIA=1
 ;
 ;Build array of locations/providers with no patients selected
 D NOPATS^PXRMXGPR
 ;
 ;Print either criteria page or summary header
 I CRITERIA D  G:DONE EXIT
 .D PAGE^PXRMXGPR Q:DONE
 .D CRIT^PXRMXGPR(10) Q:DONE
 ;Header if delimited output from a template
 I 'CRITERIA D
 .N HDR1,HDR2,HDR3
 .S HDR1="",HDR2="",HDR3=""
 .I PXRMTMP]"" S HDR1="TITLE:"_$P(PXRMTMP,U,2)_U_"TEMPLATE:"_$P(PXRMTMP,U,3)
 .I PXRMTMP="" D
 ..N PXRMFLD,DES,CDES D LITS^PXRMXGPR S HDR1=PXRMFLD_U_$G(DES)_U_$G(CDES)
 .I PXRMSEL="L" S HDR2="START:"_BD_U_"END:"_ED
 .S HDR2=HDR2_U_"RUN:"_RD
 .I PXRMFCMB="Y" S HDR3="COMBINED FACILITY"
 .I PXRMLCMB="Y" S $P(HDR3,SEP,2)="COMBINED LOCATION"
 .I PXRMREP="S" D
 ..N LIT1,LIT2,LIT3
 ..D LIT^PXRMXD
 ..I PXRMTOT="I" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT1)
 ..I PXRMTOT="R" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT2)
 ..I PXRMTOT="T" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT3)
 .W !,HDR1,!,HDR2,!,HDR3,!
 ;
 ;Kill items marked as found
 K ^XTMP(PXRMXTMP,"MARKED AS FOUND")
 ;
 ;Setup the final formatting parameters.
 S C1HS=INDENT+3
 S C1S=0
 S C2HS=C1S+2
 S C2S=C2HS
 S C3HS=C2HS+5
 S C3S=C3HS
 S HEAD=1
 S INDENT=10
 ;
 ; Update last run date
 I $G(PXRMTMP)'="" D UPD^PXRMXTU
 ;
 ; Get report detail from ^XTMP
 N PNAM,SUB,DFN,BID,NAM,FAC,MOD,SRT,TOTAL,APPL,FACPNAME,PX
 ; Set subroutine label from report format
 S MOD="SUMARY" I PXRMREP="D" S MOD="DETAIL"
 ;
 S FAC=0,PX="PXRM"
 F  S FAC=$O(^XTMP(PXRMXTMP,PX,FAC)) Q:FAC=""  Q:DONE  D
 .;Get facility name for Location and PCMM team report
 .I "TL"[PXRMSEL,PXRMFCMB="N" D
 ..S FACPNAME=$P(PXRMFACN(FAC),U,1)_"  "_$P(PXRMFACN(FAC),U,2)
 .;Report from ^XTMP - label MOD is DETAIL/SUMARY
 .S (PNAM,SUB,NAM,SRT)=""
 .I PXRMSEL="I" S SUB="PATIENT" D @MOD Q:DONE
 .I PXRMSEL'="I" D
 ..;Sort internal IENs into alpha order
 ..D XSORT
 ..F  S SRT=$O(^TMP($J,"SORT",SRT)) Q:SRT=""  Q:DONE  D
 ...S SUB=$G(^TMP($J,"SORT",SRT)) D @MOD
 ..I MOD="SUMARY","RT"[PXRMTOT S SUB="TOTAL" D @MOD
 ;
 ; Null report if no patients selected
 I ('DONE),$O(^XTMP(PXRMXTMP,PX,""))="" D NULL^PXRMXGPR G EXIT
 ; Report selected patient sample with no patients
 I MATCH D MATCH^PXRMXGPR(0)
 ;
EXIT D EXIT^PXRMXGUT
 ;
 ;Allow the task to be cleaned up upon successful completion.
 S ZTREQ="@"
 ;
 D EOR^PXRMXGUT
 Q
 ;
 ;Report by Patient
DETAIL N JJ,VA,DATE,COUNT,DDAT,EMP
 ;
 N BED,DDUE,DDONE,DNEXT,FDAT1,FDAT2,FDAT3,FNAM,FTXT
 ;
 S NAM=$G(^XTMP(PXRMXTMP,PX,FAC,SUB)),HEAD=1
 S COUNT=$P(NAM,U,2),TOTAL=$P(NAM,U,3),APPL=$P(NAM,U,4),NAM=$P(NAM,U,1)
 S DDAT="",JJ=0
 ; Get list of patients for each appointment date
 F  S DDAT=$O(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT)) Q:DDAT=""  Q:DONE  D PAT
 ;
 ; No patients due
 I JJ=0 D:'DONE NONE^PXRMXGPR
 ; Total patients
 D:'DONE TOTAL^PXRMXGPR
 Q
 ;
 ;Extract and print patient detail
PAT F  S PNAM=$O(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM)) Q:PNAM=""  Q:DONE  D
 .S JJ=JJ+1
 .;Format print line
 .S (BID,FDAT1,FDAT2,FDAT3)="" I PNAM'["No patients found" D
 ..S FDAT2="N/A",FDAT3="None"
 ..S DFN=$G(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM))
 ..S DDUE=$P(DFN,U,2),DDONE=$P(DFN,U,3),DNEXT=$P(DFN,U,4)
 ..I $G(PXRMINP) S BED=$P(DFN,U,5)
 ..S DFN=$P(DFN,U)
 ..;IHS/CIA/MGH Modified to use HRCN instead of SSN
 ..S BID=$G(^XTMP("PXRMDFN"_DFN,"HRCN"))
 ..;S BID=$p($G(^XTMP("PXRMDFN"_DFN,"SSN")),U,2)
 ..I BID="" N VA,VAERR D PID^VADPT S BID=$G(VA("PID"))
 ..;I PXRMSSN="N" S BID=$P(BID,"-",3)
 ..I PXRMHRCN="N" S BID=$E(BID,$L(BID)-3,$L(BID))
 ..I PXRMHRCN="Y",EMPCHK="Y" D EMP S:EMP BID=$E(BID,$L(BID)-4,$L(BID))
 ..S BID="("_BID_")"
 ..;End modifications
 ..S FDAT1=$$FMTE^XLFDT(DDUE,"5D")
 ..I DDONE S FDAT2=$$FMTE^XLFDT(DDONE,"5D")
 ..I DNEXT S FDAT3=$$FMTE^XLFDT(DNEXT,"5D")
 .;Print
 .D CHECK Q:DONE
 .;Normal output
 .I PXRMTABS="N" D
 ..W !,JJ,?5,$E(PNAM,1,33-$L(BID))," ",BID,?40,FDAT1,?52,FDAT2
 ..I ('$G(PXRMINP)),PXRMFUT'="Y" W ?64,FDAT3
 ..I $G(PXRMINP) W ?64,BED
 .;Condensed report
 .I PXRMTABS="Y" D
 ..N FNAM
 ..S FNAM=PNAM
 ..I FNAM'["No patients found" S FNAM=$E(FNAM,1,33-$L(BID))_" "_BID
 ..I "CES"[PXRMTABC S FNAM=$TR(FNAM,SEP,"_"),FDAT1=$TR(FDAT1,SEP,"_")
 ..W !,JJ_SEP_FNAM_SEP_FDAT1_SEP_FDAT2 I $G(PXRMINP) W SEP_BED
 ..I ('$G(PXRMINP)),PXRMFUT'="Y" W SEP_FDAT3
 .;---
 .; Future Appointments
 .I PXRMFUT="Y" D
 ..D SDA^VADPT
 ..N SUB,ADAT,ALOC,ATYP,FIRST,NONE
 ..S SUB=0,NONE=1,FIRST=1
 ..F  S SUB=$O(^UTILITY("VASD",$J,SUB)) Q:SUB=""  D
 ...S ADAT=$P(^UTILITY("VASD",$J,SUB,"I"),U)
 ...S ALOC=$P(^UTILITY("VASD",$J,SUB,"E"),U,2)
 ...S ATYP=$P(^UTILITY("VASD",$J,SUB,"E"),U,3)
 ...S ADAT=$$FMTE^XLFDT(ADAT,"5")
 ...I FIRST,PXRMTABS="N" D  S FIRST=0,NONE=0
 ....I PXRMTABS="N" W ?64,"See Below"
 ....I PXRMTABS="Y",PXRMTABC="U" W SEP_"See Below"
 ....I PXRMTABS="Y","CES"[PXRMTABC W SEP_"See_Below"
 ...D CHECK
 ...I PXRMTABS="N" W !,ADAT,?18,$E(ALOC,1,25),?58,$E(ATYP,1,21)
 ...I PXRMTABS="Y" W !,ADAT_SEP_$E(ALOC,1,25)_SEP_$E(ATYP,1,21)
 ..I NONE,PXRMTABS="N" W ?64,FDAT3
 ..I NONE,PXRMTABS="Y" W SEP_FDAT3
 ..K ^UTILITY("VASD",$J)
 Q
 ;
 ;Summary by Reminder
SUMARY N JJ,EVAL,DUE,RNAM,RNUM,ITEM,COUNT,FTXT
 ;
 S NAM=$G(^XTMP(PXRMXTMP,PX,FAC,SUB)),HEAD=1
 S TOTAL=$P(NAM,U,3),COUNT=$P(NAM,U,2),NAM=$P(NAM,U,1)
 S RNUM=$O(REMINDER(""),-1)
 ;Get reminders in alpha order
 F JJ=1:1:RNUM D  Q:DONE
 .S ITEM=$P(REMINDER(JJ),U,1),RNAM=$P(REMINDER(JJ),U,4)
 .S:RNAM="" RNAM=$P(REMINDER(JJ),U,2)
 .; zero lines will be printed
 .S DUE=$G(^XTMP(PXRMXTMP,PX,FAC,SUB,ITEM))
 .S EVAL=+$P(DUE,U,1),DUE=+$P(DUE,U,2)
 .;Print
 .D CHECK Q:DONE
 .;Normal Report
 .I PXRMTABS="N" W !,JJ,?5,RNAM,?48,$J(EVAL,10),?63,$J(DUE,10)
 .;Condensed Report
 .I PXRMTABS="Y" D
 ..I "CES"[PXRMTABC S RNAM=$TR(RNAM,SEP,"_")
 ..W !,JJ_SEP_RNAM_SEP_EVAL_SEP_DUE_SEP_$TR(SUB,SEP,"_")
 D:'DONE TOTAL^PXRMXGPR
 Q
 ;
 ;Check line count before writing line
CHECK I ((PXRMTABS="N")&($Y>(IOSL-BMARG-3)))!(HEAD=1) D COL^PXRMXGPR(1)
 Q
 ;
 ;Check if employee
EMP N VAEL
 D ELIG^VADPT
 ;Check TYPE (#391) field
 I $P($G(VAEL(6)),U,2)="EMPLOYEE" S EMP=1 Q
 ;Check PATIENT ELIGABILITY (#361) field
 N ELIG
 S ELIG=0,EMP=0
 F  S ELIG=$O(VAEL(1,ELIG)) Q:'ELIG  D  Q:EMP
 .I $P($G(VAEL(1,ELIG)),U,2)="EMPLOYEE" S EMP=1
 Q
 ;
 ;Sort internal numbers into Alpha order
XSORT N SUB,NAM
 K ^TMP($J,"SORT")
 S SUB=""
 F  S SUB=$O(^XTMP(PXRMXTMP,PX,FAC,SUB)) Q:SUB=""  D
 .Q:SUB="TOTAL"
 .S NAM=$P(^XTMP(PXRMXTMP,PX,FAC,SUB),U)
 .I NAM="" S NAM=SUB
 .S ^TMP($J,"SORT",NAM)=SUB
 Q
