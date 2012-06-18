AQAOAUD ; IHS/ORDC/LJF - QAI AUDIT UTILITY ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;PEP >> PRIVATE ENTRY POINT (Called by QI LINKAGES-RPMS pkg.)
 ;This utility is called to create an entry in the QI Audit file
 ;each time data is added or changed in the QI Occurrence file and
 ;QI Action Plan file.
 ;
 ;REQUIRED INPUTS:  AQAOUDIT("DA")=OCCURRENCE INTERNAL NUMBER
 ;                  AQAOUDIT("ACTION")=ACTION CODE
 ;                  AQAOUDIT("COMMENT")=ACTION COMMENT
 ;                  DUZ=USER'S NUMBER
 ;OPTIONAL INPUT:   AQAOUDIT("REV")=OCC REVIEW INTERNAL NUMBER
 ;
ADD ; >> add entry to audit file
 S %H=$H D YMD^%DTC S AQAOUDIT("DT")=X_% ;date/time created
 K DD,DO,DIC S DIC="^AQAGU(",DIC(0)="",X=AQAOUDIT("DT") D FILE^DICN
 L -(^AQAGU(0)) ;original locks in calling programs
 I Y=-1 G END
 ;
 ; >> edit fields
 K DIC,DIE S DIE="^AQAGU(",DA=+Y
 S DR=".02////"_AQAOUDIT("DA")_";.03////"_DUZ_";.04////"_AQAOUDIT("ACTION")_";.05////"_AQAOUDIT("COMMENT")
 I $D(AQAOUDIT("REV")) S DR=DR_";.06////"_AQAOUDIT("REV")
 ;no lock required; edit only when first entered; never again
 D ^DIE
 ;
 ;
END ; >> eoj
 K DIC,DIE,DR,AQAOUDIT Q
