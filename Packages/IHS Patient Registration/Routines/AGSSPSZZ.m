AGSSPSZZ ; IHS/ADC/CRG -FILLING PSEUDO SSNS INTO BLANK SSNS ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EN ;EP -
 ;This program stuffs PSEUDO SSNs into blank Patient SSNs fields.
 ;The Pseudo SSN is a combination of .31 of the Location file
 ;9999999.06 and the Health Record Number
 ;
LOOP ;Loop through all Patients checking SSN field
 S AGSSI=0 F  S AGSSI=$O(^AUPNPAT(AGSSI)) Q:+AGSSI=0  D IEN
 K AGSSI
 Q
IEN ;EP--Get IEN in pat file, Use data puller to get SSN, Location and HRN
 N AGSSDATA,AGSSN,AGLOC,AGHRN,AGPSEUDO,DIC,DIE,DA,DR
 I (AGSSI#100)=0 W "*"
 S AGSSN=$$VAL^XBDIQ1(2,AGSSI,.09)
 I AGSSN["QAA" W !,"AGSSI:",AGSSI,"SSN: ",AGSSN
 Q
PSSN ;Make sure HRN is 6 digits by packing 0s in leading positions
 I $L(AGHRN)<6 D
 .S AGHRN="00000"_AGHRN
 .S AGHRN=$E(AGHRN,($L(AGHRN)-5),$L(AGHRN))
 S AGPSEUDO=AGLOC_AGHRN
 ;Find all missing SSNs and stuff PSEUDO SSNs into Pat Records
 I AGSSN="" D
 .S DIC="^DPT("
 .S DIE=DIC
 .S DA=AGSSI
 .S DR=".09////^S X=AGPSEUDO"
 .D ^DIE
 Q
