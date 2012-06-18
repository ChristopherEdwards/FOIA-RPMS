PXRMXD ; SLC/PJH - Reminder Due reports DRIVER ;03-Nov-2005 13:16;MGH
 ;;1.5;CLINICAL REMINDERS;**6,11,1004**;August 16, 2002
 ;IHS/CIA/MGH Modified to add HRN data
 ;Also modified to allow use of primary care providers for reports
START ; Arrays and strings
 N PXRMIOD,PXRMXJB,PXRMXST,PXRMOPT,PXRMQUE,PXRMXTMP,PXRMSEL
 N PXRMFAC,PXRMFACN,PXRMSCAT,PXRMSRT
 N REMINDER,PXRMINP,PXRMFCMB,PXRMTOT
 ; Addenda
 N PXRMOTM,PXRMPAT,PXRMPCM,PXRMPRV,PXRMTMP,PXRMRCAT,PXRMREM
 N PXRMCS,PXRMCSN,PXRMLOCN,PXRMLCHL,PXRMLCSC,PXRMCGRP,PXRMCGRN
 ; Counters
 N NCAT,NFAC,NLOC,NPAT,NPCM,NOTM,NPRV,NREM,NCS,NHL,NCGRP
 ; Flags and Dates
 N PXRMFD,PXRMLCMB,PXRMSDT,PXRMBDT,PXRMEDT,PXRMREP,PXRMPRIM,PXRMFUT
 ;IHS/CIA/MGH Modified to add variable for health record number
 N PXRMRT,PXRMHCRN,PXRMTABC,PXRMTABS,PXRMTMP,PXRMTYP,TITLE
 N DUOUT,DTOUT
 ;
 S PXRMRT="PXRMX",PXRMTYP="X",PXRMFCMB="N",PXRMLCMB="N"
 ;
 I '$D(PXRMUSER) N PXRMUSER S PXRMUSER=0
 ;
 S PXRMXJB=$J
 S PXRMXST=$$NOW^XLFDT
 S PXRMXTMP=PXRMRT_PXRMXJB_PXRMXST
 S ^XTMP(PXRMXTMP,0)=$$FMADD^XLFDT(DT,7)_U_DT_U_"PXRM Reminder Due Report"
 ;
 ;
 ;Check for existing report templates
REP D:PXRMUSER ^PXRMXTB D:'PXRMUSER ^PXRMXT I $D(DTOUT)!$D(DUOUT) G EXIT
 ;Run report from template details
 I PXRMTMP'="" D  G:$D(DUOUT)&'$D(DTOUT) REP Q
 .D START^PXRMXTA("JOB^PXRMXD")
 ;
 ;Select sample criteria
SEL D SELECT^PXRMXSD(.PXRMSEL) I $D(DTOUT) G EXIT
 I $D(DUOUT) G:PXRMTMP="" EXIT G REP
 ;
FAC ;Get the facility list.
 I "IPO"'[PXRMSEL D  G:$D(DTOUT) EXIT G:$D(DUOUT) SEL
 .D FACILITY^PXRMXSU(.PXRMFAC) Q:$D(DTOUT)!$D(DUOUT)
 ;
 ;Check if combined facility report is required
COMB I "IPO"'[PXRMSEL,NFAC>1 D  G:$D(DTOUT) EXIT G:$D(DUOUT) FAC
 .D COMB^PXRMXSD(.PXRMFCMB,"Facilities","N")
 ;
OPT ;Variable prompts
 ;
 ;Get Patient list
 I PXRMSEL="I" K PXRMPAT D PAT^PXRMXSU(.PXRMPAT)
 ;Get OE/RRteam list
 I PXRMSEL="O" K PXRMOTM D OERR^PXRMXSU(.PXRMOTM)
 ;Get PCMM team
 I PXRMSEL="T" K PXRMPCM D PCMM^PXRMXSU(.PXRMPCM)
 ;Get provider list
 I PXRMSEL="P" K PXRMPRV D PROV^PXRMXSU(.PXRMPRV)
 ;IHS/CIA/MGH added in patch 1004
 ;Get procider list for IHS
 I PXRMSEL="D" K PXRMPRV D PROV^PXRMXSU(.PXRMPRV)
 ;Get the location list.
 I PXRMSEL="L" K PXRMCS,PXRMCSN,PXRMLOCN,PXRMLCHL,PXRMCGRP,PXRMCGRN D
 .D LOC^PXRMXSU("Determine encounter counts for","HS")
 I $D(DTOUT) G EXIT
 I $D(DUOUT) G:"IPO"[PXRMSEL SEL G:NFAC>1 COMB G FAC
 ;
 ;Check if inpatient location report
 S PXRMINP=$$INP
 ;
 ; Primary Provider or All (PCMM Provider only)
PRIME I PXRMSEL="P" D  G:$D(DTOUT) EXIT G:$D(DUOUT) OPT
 .D PRIME^PXRMXSD(.PXRMPRIM)
 ;
IHSDT ;CIA/IHS/MGH  Added in patch 1004 for primary care providers
 ;Get a date range for IHS
 I PXRMSEL="D" D PDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"ENCOUNTER")
 ;End addition
DR ; Get the date range.
 S PXRMFD="P"
 ; No prompt if individual patients selected
 ; Single dates only if PCMM teams/providers and OE/RR teams selected
 ; Choice of previous/future date range if location selected
 ;
 ; Prior encounters/future appointments (location only)
PREV I PXRMSEL="L" D PREV^PXRMXSD(.PXRMFD) G:$D(DTOUT) EXIT G:$D(DUOUT) OPT
 ; Date range input (location only)
 I PXRMSEL="L" D  G:$D(DTOUT) EXIT G:$D(DUOUT) PREV
 .I PXRMFD="P" D PDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"ENCOUNTER")
 .I PXRMFD="F" D FDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"APPOINTMENT")
 .I PXRMFD="A" D PDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"ADMISSION")
 .I PXRMFD="C" S PXRMBDT=DT,PXRMEDT=DT
 ; Due Effective Date
DUE D SDR^PXRMXDUT(.PXRMSDT) G:$D(DTOUT) EXIT
 I $D(DUOUT) G:PXRMSEL="L" PREV G OPT
 ;
SCAT ;Get the service categories.
 I PXRMSEL="L",PXRMFD="P" D
 .D SCAT^PXRMXSC
 .I $D(DTOUT)!$D(DUOUT) Q
 I $D(DTOUT) G EXIT
 I $D(DUOUT) G DUE
 ;
TYP ;Determine type of report (detail/summary)
 S PXRMREP="S"
 D REP^PXRMXSD(.PXRMREP) I $D(DTOUT) G EXIT
 I $D(DUOUT) G SCAT
 ;
 ;
 ;Check if combined location report is required
LCOMB S NLOC=0
 I PXRMREP="D",PXRMSEL="L" D  G:$D(DTOUT) EXIT G:$D(DUOUT) TYP
 .N DEFAULT,TEXT
 .D NLOC
 .I NLOC>1 D COMB^PXRMXSD(.PXRMLCMB,TEXT,DEFAULT)
 ;
FUT ;For detailed report give option to display future appointments
 S PXRMFUT="N"
 I PXRMREP="D",'PXRMINP D  G:$D(DTOUT) EXIT I $D(DUOUT) G:(PXRMSEL="L")&(NLOC>1) LCOMB G TYP
 .D FUTURE^PXRMXSD(.PXRMFUT)
 ;
SRT ;For detailed report give option to sort by appointment date
 S PXRMSRT="N"
 I PXRMREP="D",(PXRMSEL'="I") D  G:$D(DTOUT) EXIT I $D(DUOUT) G:(PXRMSEL="L")&(PXRMINP)&(NLOC>1) LCOMB G:PXRMINP TYP G FUT
 .;Option to sort by Bed for inpatients
 .I PXRMSEL="L",PXRMINP D BED^PXRMXSD(.PXRMSRT) Q
 .;Otherwise option to sort by appt. date
 .D SRT^PXRMXSD(.PXRMSRT)
 ;
 ;Option to print full SSN
SSN I PXRMREP="D" D  G:$D(DTOUT) EXIT I $D(DUOUT) G:PXRMSEL="I" FUT G SRT
 .;IHS/CIA/MGH Modified to use health record number
 .D SSN^PXRMXSD(.PXRMHRCN)
 ;
 ;Option to print without totals, with totals or totals only
TOT I PXRMREP="S" D  G:$D(DTOUT) EXIT I $D(DUOUT) G TYP
 .;Default is normal report
 .S PXRMTOT="I"
 .;Only prompt if more than one location, team or provider is selected
 .I PXRMSEL="P",NPRV<2 Q
 .I "OT"[PXRMSEL,NOTM<2 Q
 .;Ignore reports for all locations
 .I PXRMSEL="L",PXRMLCMB="Y" Q
 .I PXRMSEL="L" N DEFAULT,TEXT D NLOC Q:NLOC<2
 .;Prompt for options
 .N LIT1,LIT2,LIT3
 .D LIT,TOTALS^PXRMXSD(.PXRMTOT,LIT1,LIT2,LIT3)
 ;
 ;Reminder Category/Individual Reminder Selection
RCAT D RCAT^PXRMXSU(.PXRMRCAT,.PXRMREM) I $D(DTOUT) G EXIT
 I $D(DUOUT) G:PXRMREP="D" SSN G TOT
 ;
 ;Create combined reminder list
 D MERGE^PXRMXS1
 ;
SAV ;Option to create a new report template
 I PXRMTMP="" D ^PXRMXTU G:$D(DTOUT) EXIT I $D(DUOUT) G RCAT
 ;
 ;Option to print delimiter separated output
TABS D  G:$D(DTOUT) EXIT I $D(DUOUT) G SAV
 .D TABS^PXRMXSD(.PXRMTABS)
 ;
 ;Select chracter
TCHAR I PXRMTABS="Y" D  G:$D(DTOUT) EXIT G:$D(DUOUT) TABS
 .D TABSEL^PXRMXSD(.PXRMTABC)
 ;
 ;Determine whether the report should be queued.
JOB N POP,%ZIS S %ZIS="QM"
 W !
 D ^%ZIS
 I POP G EXIT
 S PXRMIOD=ION_";"_IOST_";"_IOM_";"_IOSL
 S PXRMQUE=$G(IO("Q"))
 ;
 I PXRMQUE D  Q
 . ;Queue the report.
 . N DESC,IODEV,ROUTINE,ZTDTH
 . S DESC="Reminder Due Report - sort"
 . S IODEV=""
 . S ROUTINE="^PXRMXSE"
 . M ^TMP("PXRM-MESS",$J)=^TMP("XM-MESS",$J)
 . S ^XTMP(PXRMXTMP,"SORTZTSK")=$$QUE^PXRMXQUE(DESC,IODEV,ROUTINE,"SAVE^PXRMXD")
 . M ^TMP("XM-MESS",$J)=^TMP("PXRM-MESS",$J)
 . K ^TMP("PXRM-MESS",$J)
 .;
 . S DESC="Reminder Due Report - print"
 . S IODEV=PXRMIOD
 . S ROUTINE="^PXRMXPR"
 . S ZTDTH="@"
 . S ^XTMP(PXRMXTMP,"PRZTSK")=$$QUE^PXRMXQUE(DESC,IODEV,ROUTINE,"SAVE^PXRMXD")
 I 'PXRMQUE D ^PXRMXSE
 Q
 ;
 ;Option PXRM REMINDERS DUE (USER)
USER N PXRMUSER
 S PXRMUSER=+$G(DUZ)
 G START
 ;
 ;
EXIT ;Clean things up.
 D EXIT^PXRMXGUT
 Q
 ;
 ;Check if inpatient report
INP() ;Applies to location reports only
 I PXRMSEL'="L" Q 0
 ;For all inpatient locations default is automatic
 I $P(PXRMLCSC,U)="HAI" Q 1
 ;For selected locations check if all locations are wards
 I $P(PXRMLCSC,U)="HS" Q $$INP^PXRMXAP(PXRMLCSC,.PXRMLOCN)
 ;Otherwise
 Q 0
 ;
 ;Prompt text
LIT N LIT
 S LIT=$S(PXRMSEL="P":"Provider","OT"[PXRMSEL:"Team",1:"Location")
 I PXRMFCMB="N" D
 .S LIT1="Individual "_LIT_"s only"
 .S LIT2="Individual "_LIT_"s plus Totals by Facility"
 .S LIT3="Totals by Facility only"
 I PXRMFCMB="Y" D
 .S LIT1="Individual "_LIT_"s only"
 .S LIT2="Individual "_LIT_"s plus Overall Total"
 .S LIT3="Overall Total only"
 Q
 ;
 ;Check if multiple locations
NLOC S DEFAULT="N",NLOC=1,TEXT="Locations"
 I $P(PXRMLCSC,U)["HA" S DEFAULT="Y",NLOC=999
 I $P(PXRMLCSC,U)="CA" S DEFAULT="Y",NCS=999
 I $E(PXRMLCSC)="C" S TEXT="Clinic Stops",NLOC=NCS
 I $E(PXRMLCSC)="G" S TEXT="Clinic Groups",NLOC=NCGRP
 I $P(PXRMLCSC,U)="HS" S NLOC=NHL S:$$INP TEXT="Inpatient Locations"
 ;Special coding if more than one facility and location
 I $P(PXRMLCSC,U)="HS",NFAC>1,NLOC>1 D
 .N FAC,HLOCIEN,HLNAME,IC,MULT
 .S IC=0 S:PXRMFCMB="Y" FAC="COMBINED"
 .;Build list of locations by facility
 .F  S IC=$O(PXRMLCHL(IC)) Q:'IC  D
 ..S HLOCIEN=$P(PXRMLCHL(IC),U,2),FAC=$$FACL^PXRMXAP(HLOCIEN) Q:'FAC
 ..S HLNAME=$P(PXRMLCHL(IC),U) Q:HLNAME=""
 ..S MULT(FAC,HLNAME)=""
 .S MULT=0,FAC=0
 .;Count locations in each facility
 .F  S FAC=$O(MULT(FAC)) Q:'FAC  D  Q:MULT
 ..S IC=0,HLNAME=""
 ..F  S HLNAME=$O(MULT(FAC,HLNAME)) Q:HLNAME=""  S IC=IC+1
 ..I IC>1 S MULT=1
 .;If only one location per facility suppress combined location option
 .I 'MULT S NLOC=1
 Q
 ;
SAVE ;Save the variables for queing.
 S ZTSAVE("PXRMBDT")="",ZTSAVE("PXRMEDT")="",ZTSAVE("PXRMSDT")=""
 S ZTSAVE("PXRMCS(")="",ZTSAVE("NCS")=""
 S ZTSAVE("PXRMCGRP(")="",ZTSAVE("NCGRP")=""
 S ZTSAVE("PXRMFAC(")="",ZTSAVE("NFAC")=""
 S ZTSAVE("PXRMFACN(")=""
 S ZTSAVE("PXRMFCMB")=""
 S ZTSAVE("PXRMFUT")=""
 S ZTSAVE("PXRMFD")=""
 S ZTSAVE("PXRMINP")=""
 S ZTSAVE("PXRMIOD")=""
 S ZTSAVE("PXRMLCHL(")="",ZTSAVE("NHL")=""
 S ZTSAVE("PXRMLCMB")=""
 S ZTSAVE("PXRMLCSC")=""
 S ZTSAVE("PXRMPRIM")=""
 S ZTSAVE("PXRMQUE")=""
 S ZTSAVE("PXRMREP")=""
 S ZTSAVE("PXRMRT")=""
 S ZTSAVE("PXRMSCAT")=""
 S ZTSAVE("PXRMSEL")=""
 S ZTSAVE("PXRMSRT")=""
 S ZTSAVE("PXRMSSN")=""
 ;IHS/CIA/MGH - HRCN variable added to save
 S ZTSAVE("PXRMHRCN")=""
 S ZTSAVE("PXRMTABC")=""
 S ZTSAVE("PXRMTABS")=""
 S ZTSAVE("PXRMTMP")=""
 S ZTSAVE("PXRMTOT")=""
 S ZTSAVE("PXRMXTMP")=""
 ; Time initiated
 S ZTSAVE("PXRMXST")=""
 ; New selection criteria
 S ZTSAVE("PXRMOTM(")="",ZTSAVE("NOTM")=""
 S ZTSAVE("PXRMPRV(")="",ZTSAVE("NPRV")=""
 S ZTSAVE("PXRMPAT(")="",ZTSAVE("NPAT")=""
 S ZTSAVE("PXRMPCM(")="",ZTSAVE("NPCM")=""
 S ZTSAVE("PXRMREM(")="",ZTSAVE("NREM")=""
 S ZTSAVE("PXRMRCAT(")="",ZTSAVE("NCAT")=""
 S ZTSAVE("PXRMUSER")=""
 ;Reminder list
 S ZTSAVE("REMINDER(")=""
 ; Arrays by IEN
 S ZTSAVE("PXRMLOCN(")=""
 S ZTSAVE("PXRMCSN(")=""
 S ZTSAVE("PXRMCGRN(")=""
 Q
