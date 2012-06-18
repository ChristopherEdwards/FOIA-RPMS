DGPREBJ1 ;ALB/SCK - PreRegistration Background job cont. ; 12/13/96
 ;;5.3;Registration;**109**;Aug 13, 1993
 Q
 ;
EN ; Interactive entry (from option)
 ; Variables
 ;    DGPTOD   - Todays date from DT  
 ;    DGPNL    - No. of lines in message array
 ;    DGPTXT   - Message array from ADDNEW procedure 
 ;    DGPP     - Default date to look for appointments
 ;    I1,X1-2  - Local variables  for counters and date manipulation
 ;
 N DGPTOD,DGPNL,DGPTXT,DGPP,I1,X1,X2
 ;
 I '$D(^XUSEC("DGPRE SUPV",DUZ)) D  G ENQ
 . W !!,"You do not have the DG PREREGISTRATION Key allocated, contact your MAS ADPAC."
 ;
 S X1=$P($$NOW^XLFDT,"."),X2=$P($G(^DG(43,1,"DGPRE")),U,5) S:X2']"" X2=14
 S DGPP=$$FMADD^XLFDT(X1,X2)
 S DIR("B")=$$FMTE^XLFDT(DGPP,1)
 S DIR(0)="DA^::EX",DIR("A")="Enter Appointment date to search: "
 D ^DIR K DIR
 G:$D(DIRUT) ENQ
 S DGPNL=0,DGPTOD=DT
 D WAIT^DICD
 D ADDNEW(1,Y)
 I $D(DGPTXT) W !!,"Results of updating the Call List with new entries",!
 S I1=0 F  S I1=$O(DGPTXT(I1)) Q:'I1  W !,DGPTXT(I1)
ENQ K DIRUT,DUOUT,DTOUT,DIROUT
 Q
 ;
ADDNEW(DGPREI,DGPDT1) ;  Searches for appointments to add to the Call List
 ;   Variables
 ;     Input:
 ;        DGPREI  -  Flag indicating how the procedure was called.
 ;                   0 - called by background job
 ;                   1 - called by option (interactive)
 ;        DGPDT1  -  Date to look for appointments, Required when
 ;                   DGPREI = 1
 ;
 ;     DGPDW   - Day of the week
 ;     DGPNDY  - Number of days ahead to look for appt.
 ;     DGPDT   - Date to look for appt. ( DT + DGPNDY)
 ;     DGPTOT  - Counter, total records scanned
 ;     DGPPT   - Pointer to patient file, #2
 ;     DGPTDTH - Counter for patient alias's found
 ;     DGPEXCL - Exclude flag
 ;     DGPTCE  - Counter of appts. excluded because of clinic
 ;     DGPTPE  - Counter of appts. excluded because of eligibility 
 ;     DGPINP  - counter of appts. excluded because of inpatient
 ;     DGPTNC  - Counter of appts. excluded because next appt. is within
 ;               DAYS BETWEEN CALLS entry in the MAS PARAMETER File
 ;     DGPADD  - Counter, entries added to call list
 ;     DGPAPT  - Date and time off appointment
 ;     DGPPRDT - Date pre-registration audit file last updated for patient
 ;     DGPNDTW - DAYS BETWEEN CALLS value
 ;     DGPSV   - Medical Service code
 ;     DGPPN   - Patients Name
 ;     DGPPH   - Patients Phone number
 ;     DGPSN   - Patients last four
 ;     DGPN1-5 - Temporary variables for $O
 ;
 N DGPDT,DGPADD,DGPTOT,DGPTCE,DGPTPE,DGPTNC,DGPTDTH,DGPINP,DGPN1,DGPN2,DGPAPT,DGPPH,DGPDW,DGPEXCL,DGPN3,DGPN5,DGPNDTW,DGPNDY,DGPPRDT,DGPPT,DGPUPD,DGINPCHK
 ;
 S DGPNDY=$P($G(^DG(43,1,"DGPRE")),U,5)
 I DGPNDY']"" D  G EXIT
 . W:DGPREI !!,$P($T(MSG1),";;",2)
 . D:'DGPREI SETTEXT^DGPREBJ($P($T(MSG1),";;",2)),SETTEXT^DGPREBJ("  ")
 ;
 I DGPREI S DGPDT=DGPDT1
 E  S DGPDT=$$FMADD^XLFDT(DGPTOD,DGPNDY)
 ;
 S DGPDW=$$DOW^XLFDT(DGPDT,1)
 I $P($G(^DG(43,1,"DGPRE")),U,6)'=1&((DGPDW=6)!(DGPDW=0)) D  G EXIT
 . W:DGPREI !!,$P($T(MSG2),";;",2)
 . D:'DGPREI SETTEXT^DGPREBJ($P($T(MSG2),";;",2)),SETTEXT^DGPREBJ("  ")
 ;
 D SETTEXT^DGPREBJ("Running: Add New Patients to Call List for "_$$FMTE^XLFDT(DGPDT,2)),SETTEXT^DGPREBJ(" ")
 ;
 S (DGPN1,DGPADD,DGPTOT,DGPTCE,DGPTPE,DGPTNC,DGPTDTH,DGPINP,DGPUPD)=0
 ;
 F  S DGPN1=$O(^SC(DGPN1)) Q:'DGPN1  D
 . S DGPN2=DGPDT F  S DGPN2=$O(^SC(DGPN1,"S",DGPN2)) Q:'DGPN2!($P(DGPN2,".")>DGPDT)  D
 .. S DGPN3=0 F  S DGPN3=$O(^SC(DGPN1,"S",DGPN2,1,DGPN3)) Q:'DGPN3  D
 ... S DGPTOT=DGPTOT+1
 ... S DGPPT=$P(^SC(DGPN1,"S",DGPN2,1,DGPN3,0),U)
 ... I $P($G(^DPT(DGPPT,.35)),U)]"" S DGPTDTH=DGPTDTH+1 Q
 ... S DGPEXCL=0
 ... ; ***  Check for clinic exclusions in MAS PARAMETER File
 ... S DGPN5=0 F  S DGPN5=$O(^DG(43,1,"DGPREC",DGPN5)) Q:'DGPN5!(DGPEXCL)  D
 .... S:$P(^DG(43,1,"DGPREC",DGPN5,0),U)=DGPN1 DGPEXCL=1
 ... I DGPEXCL S DGPTCE=DGPTCE+1 Q
 ... S DGPEXCL=0
 ... ; *** Check for eligibility exclusions inthe MAS PARAMETER File 
 ... N DGPAELG
 ... S DGPN5=0 F  S DGPN5=$O(^DG(43,1,"DGPREE",DGPN5)) Q:'DGPN5!(DGPEXCL)  D
 .... S DGPAELG=$S($P($G(^SC(DGPN1,"S",DGPN2,1,DGPN3,0)),U,10)]"":$P($G(^SC(DGPN1,"S",DGPN2,1,DGPN3,0)),U,10),1:$P($G(^DPT(DGPPT,.36)),U))
 .... S:$P(^DG(43,1,"DGPREE",DGPN5,0),U)=DGPAELG DGPEXCL=1
 ... I DGPEXCL S DGPTPE=DGPTPE+1 Q
 ... ; ***  Check for inpatient status
 ... ; I $P($G(^DPT(DGPPT,.1)),U)]""!($P($G(^DPT(DGPPT,.101)),U)]"") S DGPINP=DGPINP+1 Q
 ... K DFN S DFN=DGPPT
 ... D INP^VADPT
 ... I $G(VAIN(1))]"" S DGPINP=DGPINP+1 Q 
 ... ; *** Check for last update in Pre-Registration Audit file
 ... S DGPPRDT=DGPTOD+.9999,DGPPRDT=$O(^DGS(41.41,"ADC",DGPPT,DGPPRDT),-1)
 ... S DGPNDTW=$P($G(^DG(43,1,"DGPRE")),U,2)
 ... I DGPPRDT]""&(DGPNDTW]"") I $$FMDIFF^XLFDT(DGPDT,DGPPRDT,1)<DGPNDTW S DGPTNC=DGPTNC+1 Q 
 ... ; *** Set up entries for adding to Pre-Registration Call List file
 ... K DFN S DFN=DGPPT
 ... D DEM^VADPT
 ... S DGPPH=$P($P($G(^DPT(DGPPT,.13)),U),"~")
 ... I DGPPH=""!(DGPPH["NO") D
 .... S DGPPH=$P($G(^DPT(DGPPT,.33)),U,9)
 .... I DGPPH]"" S DGPPH=$P(DGPPH,"~")_"(E)"
 .... E  S DGPPH="NO PHONE"
 ... ;
 ... I '$D(^DGS(41.42,"B",DFN)) D
 .... K DD,DO
 .... S DIC="^DGS(41.42,",DIC(0)="ML"
 .... S X=DFN,DGPAPT=$P($G(^SC(DGPN1,"S",DGPN2,0)),U)
 .... S DIC("DR")=$P($T(FIELDS),";;",2)
 .... D FILE^DICN
 .... S DGPADD=DGPADD+1
 ... E  D
 .... S DA="",DA=$O(^DGS(41.42,"B",DFN,DA),-1)
 .... Q:$P($G(^DGS(41.42,DA,0)),U,6)="Y"
 .... S DIE="^DGS(41.42,"
 .... S DGPAPT=$P($G(^SC(DGPN1,"S",DGPN2,0)),U)
 .... S DR=$P($T(FIELDS),";;",2)
 .... D ^DIE
 .... S DGPUPD=DGPUPD+1
 ... K DA,DR,DIE,DIC,VADM,VA,DFN,VAERR,VAIN
 ;
 D SETTEXT^DGPREBJ("      Total Entries Scanned: "_DGPTOT)
 D SETTEXT^DGPREBJ("  Called within Time Window: "_DGPTNC)
 D SETTEXT^DGPREBJ("                 Inpatients: "_DGPINP)
 D SETTEXT^DGPREBJ("       Exclusions by Clinic: "_DGPTCE)
 D SETTEXT^DGPREBJ("  Exclusions by Eligibility: "_DGPTPE)
 D SETTEXT^DGPREBJ("        Exclusion for Death: "_DGPTDTH)
 D SETTEXT^DGPREBJ(" ")
 D SETTEXT^DGPREBJ("    Total Entries Added to Call List: "_DGPADD)
 D SETTEXT^DGPREBJ("Total Entries Updated with New Appt.: "_DGPUPD)
 D SETTEXT^DGPREBJ(" ")
EXIT ;
 Q
 ;
FIELDS ;;.1///^S X=$P($G(^SC(DGPN1,0)),U,15);1///^S X=$E(VADM(1))_VA("BID");2///^S X=DGPPH;3///^S X=$G(DGPPRDT);5////^S X=DGPN1;6///^S X=DGPAPT;7///^S X=$P(^SC(DGPN1,0),U,8)
 ;
MSG1 ;;The 'DAYS TO PULL' is not filled in, unable to determine appoinment date.
MSG2 ;;The call list is currently not being generated for weekends.
