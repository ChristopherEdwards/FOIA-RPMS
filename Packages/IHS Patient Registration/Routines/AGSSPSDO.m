AGSSPSDO ; IHS/ADC/CRG -FILLING PSEUDO SSNS INTO BLANK SSNS ; 
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
 I (AGSSI#100)=0 W "."
 N AGSSDATA,AGSSN,AGLOC,AGHRN,AGPSEUDO,DIC,DIE,DA,DR
 S AGSSDATA=$G(^AUPNPAT(AGSSI,0))
 S AGSSN=$$VAL^XBDIQ1(2,AGSSI,.09)
 S AGLOC=$$VAL^XBDIQ1(9999999.06,DUZ(2),.31)
 I AGSSN[AGLOC S ^TMP("AG",$J,AGSSI)=AGSSI_"^"_AGSSN
 S AGHRN=$P($G(^AUPNPAT(AGSSI,41,DUZ(2),0)),"^",2)
 ;If an HRN exists compose a PSEUDO SSN made of Location code and HRN
 I AGHRN'="" D PSSN
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
RESULTS ;Results
 W !,"NAME                           IEN      PSEUDO SSN"
 W !,"==================================================",!
 S AGSSJ=0 F  S AGSSJ=$O(^TMP("AG",$J,AGSSJ)) Q:+AGSSJ=0  D
 .S AGSSNAME=$P(^DPT(AGSSJ,0),"^",1)
 .S AGSSIEN=$P(^TMP("AG",$J,AGSSJ),"^",1)
 .S AGSSPSSN=$P(^TMP("AG",$J,AGSSJ),"^",2)
 .W !,AGSSNAME,?30,AGSSIEN,?40,AGSSPSSN
 K AGSSJ,AGSSNAME,AGSSIEN,AGSSPSSN,^TMP("AG",$J)
 Q
