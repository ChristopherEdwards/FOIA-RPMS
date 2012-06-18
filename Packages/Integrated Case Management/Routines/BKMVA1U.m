BKMVA1U ;PRXM/HC/ALA - HMS PATIENT REGISTER UTILITIES ; 21 Jul 2005  10:16 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
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
VSTDT ; EP - Input Transform for Visit Date/time
 S %DT="EST",%DT(0)="-NOW" D ^%DT K %DT(0) S X=Y
 I Y<1 K X Q
 NEW DOB,DOD
 I $G(DFN)="" Q
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S DOD=$$GET1^DIQ(2,DFN,.351,"I")\1
 I X<DOB K X Q
 I DOD'=0,X>DOD K X Q
 Q
 ;
FRCFILE ; Called by input template BKMV PATIENT RECORD to force the filing of
 ; the Initial HIV Diagnosis Date in order to ensure that the Initial AIDS
 ; Diagnosis Date input transform, subroutine AIDDT above, will always work
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
 ;
VXAM04 ;EP - called from input tx on .04 field of EXAM SUB-FILE 90459.1717
 ; Should be identical to VXAM04^AUPNCIX on .04 field of V EXAM FILE 9000010.13
 Q:'$D(X)
 Q:'$G(DA)
 NEW BKMXCOD,BKMXIEN
 S BKMXIEN=$$GET1^DIQ(90459.1717,DA_","_DA(1)_",",".02","I")
 S BKMXCOD=$$GET1^DIQ(9999999.15,BKMXIEN_",",".02","I")
 ;S C=$P(^AUTTEXAM($P(^AUPNVXAM(DA,0),U),0),U,2)
 I X="PA",BKMXCOD'=34 K X Q
 I X="PR",BKMXCOD'=34 K X Q
 I X="A",BKMXCOD=34 K X Q
 Q
 ;
AUPNVMSR ; EP - called from input tx on .04 field of MEASUREMENT SUB-FILE 90459.1919
 ; Should be identical to ^AUPNVMSR on .04 field of V MEASUREMENT 9000010.01
 Q:'$D(X)
 Q:'$G(DA)
 NEW BKMXIEN,BKMXTYP
 S BKMXIEN=$$GET1^DIQ(90459.1919,DA_","_DA(1)_",",".02","I")
 S BKMXTYP=$$GET1^DIQ(9999999.07,BKMXIEN_",",".01","I")
 Q:BKMXTYP=""
 S BKMXTYP=BKMXTYP_"^AUPNVMSR"
 D @BKMXTYP
 ;
 Q
 ;
HELPVMSR ; EP - called from input tx on .04 field of MEASUREMENT SUB-FILE 90459.1919
 ; Should be identical to ^AUPNVMSR on .04 field of V MEASUREMENT 9000010.01
 Q:'$D(X)
 Q:'$G(DA)
 NEW BKMXIEN,AUPNMTYP
 S BKMXIEN=$$GET1^DIQ(90459.1919,DA_","_DA(1)_",",".02","I")
 S AUPNMTYP=$$GET1^DIQ(9999999.07,BKMXIEN_",",".01","I")
 Q:AUPNMTYP=""
 S AUPNMTYP="H"_AUPNMTYP
 D HELP1^AUPNVMS2
 ;
 Q
 ;
PRC02 ; EP - Procedure Input Transform
 ; I X<0 K X Q
 ; I $P(^ICD0(X,0),U,9)'="" K X Q
 ; Q:$G(AUPNSEX)=""
 ; I $P(^ICD0(X,0),U,10)'="",$P(^(0),U,10)'=AUPNSEX K X Q
 ; Q
 ; csv changes below replaced the following code from MUMPS CODE THAT WILL SET 'DIC("S")' field
 ; S DIC("S")="I $P(^(0),U,9)="""" Q:'$D(AUPNSEX)  Q:$P(^(0),U,10)=""""  I $P(^(0),U,10)=AUPNSEX"
 N CSV,ICD0,ICDIEN,ACTDT,INACTDT
 ;S CSV=($$VERSION^XPDUTL("BCSV")]"")
 S CSV=($T(ICDOP^ICDCODE)'="")
 I CSV D  I 1
 . S ICD0=$$ICDOP^ICDCODE(Y),ICDIEN=$P(ICD0,U)
 . S ACTDT=$P(ICD0,U,13),INACTDT=$P(ICD0,U,12)
 . I INACTDT,DT>INACTDT K X Q
 . I ACTDT,DT<ACTDT K X Q
 E  D
 . I $P(^ICD0(Y,0),U,9)'="" K X Q
 I $D(X) Q:$G(AUPNSEX)=""
 I $D(X) D
 . I CSV D  Q
 .. I $$ICD0^BKMUL3(Y,,11)'="",$$ICD0^BKMUL3(Y,,11)'=AUPNSEX K X Q
 . I $P(^ICD0(X,0),U,10)'="",$P(^(0),U,10)'=AUPNSEX K X Q
 ;
 ; Preserve naked reference
 I $D(X),CSV,$D(^ICD0(ICDIEN,0)) Q
 I $D(X),$D(^ICD0(Y,0))
 Q
 ;
HF02 ; File 90459.1818, Field .02
 I X<0 K X Q
 I $$GET1^DIQ(9999999.64,X_",",".1","I")'="F" K X Q
 I $$GET1^DIQ(9999999.64,X_",",".13","I")=1 K X Q
 Q
 ;
XAM02 ; File 90459.1717, Field .02
 I X<0 K X Q
 I $$GET1^DIQ(9999999.15,X_",",".04","I")=1 K X Q
 Q
 ;
SKN02 ; File 90459.2222, Field .02
 I X<0 K X Q
 I $$GET1^DIQ(9999999.28,X_",",".03","I")=1 K X Q
 Q
 ;
SKN04 ; File 90459.2222, Field .04
 I X="N",$P(^BKM(90459,DA(1),22,DA,0),U,4)]"",$P(^BKM(90459,DA(1),22,DA,0),U,4)>10 K X Q
 I X'="P",$P(^BKM(90459,DA(1),22,DA,0),U,4)]"",$P(^BKM(90459,DA(1),22,DA,0),U,4)>15 K X Q
 Q
 ;
SKN05 ; EP - File 90459.2222, Field .05
 I +X'=X!(X>40)!(X<0)!(X?.E1"."1N.N) K X Q
 I X>15,$P(^BKM(90459,DA(1),22,DA,0),U,3)]"",$P(^BKM(90459,DA(1),22,DA,0),U,3)'="P" K X Q
 I X>10,$P(^BKM(90459,DA(1),22,DA,0),U,3)]"",$P(^BKM(90459,DA(1),22,DA,0),U,3)="N" K X Q
 ; If passes transform, indicates a change, wipe out .04 field
 I $$GET1^DIQ(90459.2222,DA_","_DA(1)_",",.04,"I")'="" D
 . K FDA,BKMERR
 . S FDA(90459.2222,DA_","_DA(1)_",",".04")="@"
 . D FILE^DIE("","FDA","BKMERR")
 . K FDA,BKMERR
 Q
 ;
IMM015 ; File 90459.2323, Field .015
 I X<0 K X Q
 I $$GET1^DIQ(9999999.14,X_",",".07","I")=1 K X Q
 Q
 ;I $P(^(0),U,3)=0,$D(^AUTTIML(""C"",+$P($G(^BKM(90459,DA(1),23,DA,0)),U,2),Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;
IMM05 ; File 90459.2323, Field .05
 I X<0 K X Q
 Q:'$G(DA)
 I $$GET1^DIQ(9999999.41,X_",",".03","I")'=0 K X Q
 I '$D(^AUTTIML("C",+$P($G(^BKM(90459,DA(1),23,DA,0)),U,2),X)) K X Q
 Q
