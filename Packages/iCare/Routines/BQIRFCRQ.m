BQIRFCRQ ;PRXM/HC/ALA-Face Sheet Missing Required fields ; 12 Jan 2007  6:37 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Copied from AGBADATA
 ; IHS/ASDS/EFG - DISPLAY MISSING MANDATORY DATA;  
 ; 7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 Q:'$D(AG("DTOT"))
 Q:AG("DTOT")=0
 ;W $$S^AGVDF("IOF")
 D VAR
DISP ;
 W:$D(^DPT(DFN,0)) "PATIENT: ",$P(^DPT(DFN,0),U),!
 W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) "CHART #: ",$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 W !!,"This patient does not have a complete set of mandatory data."
 W !,"The missing or invalid data fields are....",!!
 F I=1:1:13 W:$D(AG("ER",I)) !,"** ",AG(I)
 I $D(AG("ER",14)) D
 . W !,"** ",AG(14)," at: "
 . N I
 . S I=0
 . F  S I=$O(AG("ER",14,I)) Q:'I  D
 .. W $P($G(^AUTTLOC(I,0)),"^",2),!,?40
 W !!,"Copy down the information above in order to make corrections."
 W !!
 ;  took out call to READ^AG since this is a non-interactive program
 Q
VAR ;EP
 S AG(1)="invalid NAME"
 S AG(2)="invalid CHART NUMBER"
 S AG(3)="missing DATE OF BIRTH"
 S AG(4)="invalid SEX"
 S AG(5)="missing or unspecified TRIBE"
 S AG(6)="missing INDIAN QUANTUM"
 S AG(7)="missing CURRENT COMMUNITY"
 S AG(8)="missing BENEFICIARY"
 S AG(9)="invalid ELIGIBILITY &/OR CLASS/TRIBE/QUANTUM DEMOGRAPHICS"
 S AG(10)="patient not eligible for BIC"
 S AG(11)="missing SOCIAL SECURITY NUMBER"
 S AG(12)="OLD (unused) TRIBE still in use"
 S AG(13)="no Official Registering Facility:Health Record Number"
 S AG(14)="Patient has been marked INACTIVE"
 Q
