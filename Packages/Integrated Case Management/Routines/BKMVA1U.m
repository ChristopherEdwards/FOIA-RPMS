BKMVA1U ;PRXM/HC/ALA - HMS PATIENT REGISTER UTILITIES ; 21 Jul 2005  10:16 AM
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 ;
HIVDT ; EP - Input Transform for the Initial HIV DX Date
 NEW Y,AIDSDT,DOB,DFN
 S AIDSDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5.5,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EPX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I AIDSDT'="",X>AIDSDT K X Q
 Q
 ;
AIDDT ; EP - Input Transform for the Initial AIDS DX Date
 NEW Y,HIVDT,DOB,DFN
 S HIVDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EPX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I HIVDT'="",X<HIVDT K X Q
 Q
 ;
HHLP ; EP - HIV Diagnosis Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The HIV Diagnosis Date must be previous to the AIDS Diagnosis Date and/or"
 . S HELP(1,"F")="?5"
 . S HELP(2)="not previous to the Date of Birth or a future date."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please re-enter the date."
 . S HELP(3,"F")="!?5"
 . S HELP(4)=""
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
AHLP ; EP - AIDS Diagnosis Special Help
 ; PRX/DLS 4/6/2006 Added 'future date' to message & move 'Please re-enter...' to line 3.
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S DV=""
 . S HELP(1)="The AIDS Diagnosis Date must be on or after the HIV Diagnosis Date and"
 . S HELP(1,"F")="?5"
 . S HELP(2)="not previous to the Date of Birth or a future date."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please re-enter the date."
 . S HELP(3,"F")="!?5"
 . S HELP(4)=""
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
ITAX ; EP - Initialize taxonomies for compile diagnosis and initial dates
 NEW CPT,BCPTR,LAB
 K ^TMP("BKMAIDS",$J),^TMP("BKMHIV",$J),^TMP("BKMCD4",$J),^TMP("BKMTST",$J),^TMP("BCMCD4AB")
 D BLDTAX^BKMIXX5("BKMV AIDS DEF ILL DXS","^TMP(""BKMAIDS"",$J)")
 D BLDTAX^BKMIXX5("BGP HIV/AIDS DXS","^TMP(""BKMHIV"",$J)")
 D BLDTAX^BKMIXX5("BGP CD4 LOINC CODES","^TMP(""BKMCD4"",$J)")
 D BLDTAX^BKMIXX5("BGP CD4 TAX","^TMP(""BKMCD4"",$J)")
 D BLDTAX^BKMIXX5("BGP CD4 CPTS","^TMP(""BKMTST"",$J)")
 ; PRX/DLS 4/14/06 Added 'CD4 ABS' Taxonomy build to get proper Diag Cat for Add to Register.
 D BLDTAX^BKMIXX5("BKMV CD4 ABS CPTS","^TMP(""BKMCD4AB"",$J)")
 D BLDTAX^BKMIXX5("BKMV CD4 ABS LOINC CODES","^TMP(""BKMCD4AB"",$J)")
 S CPT="" F  S CPT=$O(^TMP("BKMTST",$J,CPT)) Q:CPT=""  D
 . S BCPTR=0 F  S BCPTR=$O(^BLRCPT(BCPTR)) Q:'BCPTR  D
 .. I $D(^BLRCPT(BCPTR,11,"B",CPT)) D
 ... S LAB=$P($G(^BLRCPT(BCPTR,1)),U,1)
 ... Q:LAB=""
 ... I $G(^LAB(60,LAB,0))'="" S ^TMP("BKMCD4",$J,LAB)=$P(^LAB(60,LAB,0),U,1)
 ;
 Q
