PXRMXTA ; SLC/PJH - Reminder Reports Template Edit ;01/02/2002 
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ; 
 ; Called from PXRMYD,PXRMXD
 ;
 ;Edit selected template or run report
 ;-------------------------------------
START(ROUTINE) ;
 N PXRMASK,PXRMEDIT,PXRMCOPY,MSG,DIC,NLOC
 S PXRMASK="N",PXRMCOPY="N",PXRMEDIT="N"
 ;Option to edit/copy template
USE I 'PXRMUSER D ASK(.PXRMASK) Q:$D(DUOUT)!$D(DTOUT)
 ;Option to edit template
 I PXRMASK="Y" D  Q:$D(DUOUT)!$D(DTOUT)
 .;Template edit and redisplay
 .D LOCK Q:$D(DUOUT)
 .D EDIT,UNLOCK
 .;Rollback changes on exit
 .I $D(DUOUT)!$D(DTOUT) D  Q
 ..D ROLL^PXRMXTF
 .;If all the templates have been deleted exit report
 .I '$$FIND^PXRMXT(PXRMTYP) S DTOUT=1 Q
 .;Check if template has been deleted 
 .I '$D(DA) S DUOUT=1 Q
 .;Sort out the filing
 .D ^PXRMXTF I $D(MSG) S DUOUT=1 Q
 ;
FAC ;Option to combine multifacility report
 I "IPO"'[PXRMSEL,NFAC>1 D  Q:$D(DTOUT)  I $D(DUOUT) Q:PXRMUSER  G USE
 .D COMB^PXRMXSD(.PXRMFCMB,"Facilities","N")
 ;
 ;Date range input (location only)
DAT I PXRMSEL="L" D  Q:$D(DTOUT)  I $D(DUOUT) Q:PXRMUSER  G USE
 .I PXRMFD="P" D PDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"ENCOUNTER")
 .I PXRMFD="F" D FDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"APPOINTMENT")
 .I PXRMFD="A" D PDR^PXRMXDUT(.PXRMBDT,.PXRMEDT,"ADMISSION")
 .I PXRMFD="C" S PXRMBDT=DT,PXRMEDT=DT
 ;Due Effective Date
EFF D SDR^PXRMXDUT(.PXRMSDT) Q:$D(DTOUT)
 I $D(DUOUT) G:PXRMSEL="L" DAT Q:PXRMUSER  G USE
 ;
 ;Check if combined location report is required
LCOMB S NLOC=0
 I PXRMREP="D",PXRMSEL="L" D  G:$D(DTOUT) EXIT G:$D(DUOUT) EFF
 .N DEFAULT,TEXT
 .D NLOC^PXRMXD
 .I NLOC>1 D COMB^PXRMXSD(.PXRMLCMB,TEXT,DEFAULT)
 ;
 ;Reminders Due sort and appointment date options
APPT I PXRMREP="D" D FUT Q:$D(DTOUT)  I $D(DUOUT) G:(PXRMSEL="L")&(NLOC>1) LCOMB G EFF
 ;
 ;
 ;Option to print full SSN
SSN I PXRMREP="D" D  G:$D(DTOUT) EXIT G:$D(DUOUT) APPT
 .D SSN^PXRMXSD(.PXRMSSN)
 ;
 ;Option to print without totals, with totals or totals only
TOT I PXRMREP="S" D  Q:$D(DTOUT)  I $D(DUOUT) G EFF
 .;Default is normal report
 .S PXRMTOT="I"
 .;Only prompt if more than one location, team or provider is selected
 .I PXRMSEL="P",'$O(PXRMPRV(1)) Q
 .I PXRMSEL="O",'$O(PXRMOTM(1)) Q
 .I PXRMSEL="T",'$O(PXRMPCM(1)) Q
 .;Ignore reports for all locations
 .I PXRMSEL="L",PXRMLCMB="Y" Q
 .I PXRMSEL="L" N DEFAULT,TEXT D NLOC^PXRMXD Q:NLOC<2
 .;Prompt for options
 .N LIT1,LIT2,LIT3
 .D LIT^PXRMXD,TOTALS^PXRMXSD(.PXRMTOT,LIT1,LIT2,LIT3)
 ;
 ;Option to print delimiter separated output
TABS D  G:$D(DTOUT) EXIT I $D(DUOUT) G:PXRMREP="D" SSN G TOT
 .D TABS^PXRMXSD(.PXRMTABS)
 ;
 ;Select chracter
TCHAR I PXRMTABS="Y" D  G:$D(DTOUT) EXIT G:$D(DUOUT) TABS
 .D TABSEL^PXRMXSD(.PXRMTABC)
 ;
 ;Initiate report
 D @ROUTINE
EXIT Q
 ;
 ;File locking
 ;------------
UNLOCK L -^PXRMPT(810.1,$P(PXRMTMP,U)) Q
LOCK L +^PXRMPT(810.1,$P(PXRMTMP,U)):0
 E  W !!?5,"Another user is editing this entry" S DUOUT=1
 Q
 ;
 ;Option to Edit
 ;--------------
EDIT N DIDEL,DIE,DR K DTOUT,DUOUT
 ;Edit report name, title and PXRMSEL (patient sample)
 S DIE=810.1,DA=$P(PXRMTMP,U),DR=".01T;1.9T;1.2T",DIDEL=810.1
 D ^DIE I $D(Y) S DUOUT=1 Q
 ;Check if template has been deleted
 I '$D(DA) Q
 ;Get updated value of PXRMXSEL
 N PXRMSEL S PXRMSEL=X
 ;Needed for 1.6T validation - Prior/Future or Current/Admissions
 N PXRMINP
 ;Further fields depend on value in PXRMXSEL
 I PXRMSEL="I" S DR="6T",PXRMINP=0
 I PXRMSEL="L" D  Q:$D(DUOUT)
 .;Get location report type 
 .S DR="3T;1.5T" D ^DIE I $D(Y) S DUOUT=1 Q
 .N PXRMLCSC S PXRMLCSC=X,DR=""
 .;All location reports - prompt for prior/future/current/admissions
 .I PXRMLCSC="HAI" S PXRMINP=1,DR="1.6T" Q
 .I PXRMLCSC="HA" S PXRMINP=0,DR="1.6T"
 .I PXRMLCSC="CA" S PXRMINP=0,DR="1.6T"
 .;Selected Location/Stop Code/Clinic Group fields 
 .I PXRMLCSC="HS" D  Q:$D(DUOUT)
 ..S DR="10T"
 ..D ^DIE I $D(Y) S DUOUT=1 Q
 ..;Determine if locations input are all wards
 ..S PXRMINP=$$INP^PXRMXAP(PXRMLCSC,.PXRMLOCN)
 ..;Select Prior/Future or Current Inpatient/Admissions
 ..S DR="1.6T"
 .;Clinic Stop input and prior/future
 .I PXRMLCSC="CS" S PXRMINP=0,DR="11T;1.6T"
 .;Clinic Group input and prior/future
 .I PXRMLCSC="GS" S PXRMINP=0,DR="12T;1.6T"
 .;Service categories (except for inpatient reports)
 .I PXRMINP=0 S DR=DR_";9T"
 ;OE/RR teams
 I PXRMSEL="O" S DR="7T"
 ;PCMM Provider and Primary care/All
 I PXRMSEL="P" S DR="4T;1.3T"
 ;PCMM teams
 I PXRMSEL="T" S DR="3T;8T"
 ;Report type (detail or summary)
 S DR=DR_";1.4T"
 ;Reminder Categories
 S DR=DR_";13T"
 ;Reminders
 S DR=DR_";2T"
 ;
 ;Strip of any leading semi-colons
 I $E(DR)=";" S DR=$P(DR,";",2,99)
 ;
 D ^DIE I $D(Y) S DUOUT=1 Q
 ;
 ;If all reminders have been deleted from the template disallow save
 I +$P($G(^PXRMPT(810.1,DA(1),1,0)),U,4)=0 D  S DUOUT=1 Q
 .W !,"This template is incomplete - no reminders defined"
 Q
 ;
 ;Option to use report template
 ;-----------------------------
ASK(YESNO) ;
 N X,Y,TEXT
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="WANT TO EDIT '"_$P(PXRMTMP,U,2)_"' TEMPLATE: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXTA(1)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
 ;General help text routine. Write out the text in the HTEXT array
 ;----------------------------------------------------------------
HELP(CALL) ;
 N HTEXT
 N DIWF,DIWL,DIWR,IC
 S DIWF="C70",DIWL=0,DIWR=70
 ;
 I CALL=1 D
 .S HTEXT(1)="Enter 'N' to run the report using the parameters from "
 .S HTEXT(2)="the existing template. Enter 'Y' to copy/edit the "
 .S HTEXT(3)="template."
 ;
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(HTEXT(IC)) Q:IC=""  D
 . S X=HTEXT(IC)
 . D ^DIWP
 W !
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 . W !,^UTILITY($J,"W",0,IC,0)
 K ^UTILITY($J,"W")
 W !
 Q
 ;
 ;Reminders Due specific prompts
 ;------------------------------
FUT ;For detailed report give option to display future appointments
 S PXRMFUT="N"
 I PXRMREP="D" D  Q:$D(DTOUT)!$D(DUOUT)
 .D FUTURE^PXRMXSD(.PXRMFUT)
 ;
SRT ;For detailed report give option to sort by appointment date
 S PXRMSRT="N"
 I PXRMREP="D",(PXRMSEL'="I") D  G:$D(DUOUT) FUT
 .;Inpatient report
 .S PXRMINP=$$INP^PXRMXD
 .;Option to sort by bed
 .I PXRMINP D BED^PXRMXSD(.PXRMSRT) Q
 .;Option to sort by appt date
 .D SRT^PXRMXSD(.PXRMSRT)
 ;
 Q
 ;
 ;Input validation for file #810.1
 ;
 ;If detail report allow only one reminder
PXRMREM I $P(^PXRMPT(810.1,DA(1),0),U,6)'="D" Q
 ;If template has no reminders ignore
 I +$P($G(^PXRMPT(810.1,DA(1),1,0)),U,4)=0 Q
 ;If this a new entry
 I $G(Y)=-1 K X W !,"Only one reminder allowed for detailed report."
 Q
 ;
 ;If changing from Summary to Detail report
PXRMREP Q:$G(X)'="D"
 Q:$P($G(^PXRMPT(810.1,DA,0)),U,6)'="S"
 Q:+$G(NREM)<2
 W !,"Only the first reminder on this template will be evaluated"
 Q
