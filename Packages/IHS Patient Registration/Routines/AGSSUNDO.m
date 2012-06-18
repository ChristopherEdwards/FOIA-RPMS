AGSSUNDO ; IHS/ADC/CRG -UNDO PSEUDO SSNS ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EN ;EP -
 ;This program stuffs blanks into Pseudo Patient SSNs fields.
 ;
LOOP ;Loop through all Patients checking SSN field
 S AGSSI=0 F  S AGSSI=$O(^AUPNPAT(AGSSI)) Q:+AGSSI=0  D IEN
 K AGSSI
 Q
IEN ;EP - Get IEN in pat file, Use data puller to get SSN, Location and HRN
 I (AGSSI#100)=0 W "."
 N AGSSDATA,AGSSN,AGLOC,AGHRN,AGPSEUDO,DIC,DIE,DA,DR
 S AGSSDATA=$G(^AUPNPAT(AGSSI,0))
 S AGSSN=$$VAL^XBDIQ1(2,AGSSI,.09)
 S AGLOC=$$VAL^XBDIQ1(9999999.06,DUZ(2),.31)
 I AGSSN[AGLOC D CLEAR
 Q
CLEAR ;Find all PSEUDO SSNs in Pat Records and delete them.
 S DIC="^DPT("
 S DIE=DIC
 S DA=AGSSI
 S DR=".09////@"
 D ^DIE
 Q
