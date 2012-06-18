AGGRFCRQ ;VNGT/HS/ALA-Face Sheet Missing Required fields ; 28 Apr 2010  11:43 AM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
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
 NEW NLN K AGG
 ;W:$D(^DPT(DFN,0)) "PATIENT: ",$P(^DPT(DFN,0),U),!
 I $D(^DPT(DFN,0)) S AGG(1)="PATIENT: "_$P(^DPT(DFN,0),U)
 ;W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) "CHART #: ",$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 I $D(^AUPNPAT(DFN,41,DUZ(2),0)) S AGG(2)="CHART #: "_$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 ;W !!,"This patient does not have a complete set of mandatory data."
 S AGG(3)="  "
 S AGG(4)="This patient does not have a complete set of mandatory data."
 S AGG(5)="The missing or invalid data fields are...."
 S AGG(6)="  ",NLN=6
 ;W !,"The missing or invalid data fields are....",!!
 F I=1:1:13 D
 . I $D(AG("ER",I)) S NLN=NLN+1,AGG(NLN)="** "_AG(I)
 . ;W:$D(AG("ER",I)) !,"** ",AG(I)
 I $D(AG("ER",14)) D
 . S NLN=NLN+1,AGG(NLN)="** "_AG(14)_" at: "
 . ;W !,"** ",AG(14)," at: "
 . N I
 . S I=0
 . F  S I=$O(AG("ER",14,I)) Q:'I  D
 .. S NLN=NLN+1,AGG(NLN)="                                        "_$P($G(^AUTTLOC(I,0)),"^",2)
 .. ;W $P($G(^AUTTLOC(I,0)),"^",2),!,?40
 S NLN=NLN+1,AGG(NLN)="  "
 S NLN=NLN+1,AGG(NLN)="Copy down the information above in order to make corrections."
 ;W !!,"Copy down the information above in order to make corrections."
 S NLN=NLN+1,AGG(NLN)="  "
 ;W !!
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
