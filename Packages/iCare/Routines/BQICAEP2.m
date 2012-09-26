BQICAEP2 ;GDIT/HS/ALA-Dept of EPI Comm Alert Logic ; 03 Oct 2011  12:26 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
MEAS(BQDFN,RESULT) ;EP - Measles
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 F TAX="BQI MEASLES QUAL TEST LOINC","BQI MEASLES QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI MEASLES ID SPEC TEST LOINC","BQI MEASLES ID SPEC TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-30",0,BQDFN,"","POS","","","",.TREF)
 I X D LB^BQICAEP1(X,CT) K @TREF Q
 K @TREF
 F TAX="BQI MEASLES QUAN TEST LOINC","BQI MEASLES QUAN TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-30",0,BQDFN,"",1.09,">","","",.TREF)
 I X D LB^BQICAEP1(X,CT)
 K @TREF
 Q
 ;F TAX="BQI MEASLES QUAL TEST LOINC","BQI MEASLES QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-30",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI MEASLES ID SPEC TEST LOINC","BQI MEASLES ID SPEC TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-30",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI MEASLES QUAN TEST LOINC","BQI MEASLES QUAN TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-30",0,BQDFN,"",1.09,">","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;Q
 ;
MEN(BQDFN,RESULT) ;EP - Meningitis
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 F TAX="BQI MENINGITIS QUAL TEST LOINC","BQI MENINGITIS QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI MENINGITIS ID SPEC LOINC","BQI MENINGITIS ID SPEC TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI MENINGITIS GRAM STAIN LNC","BQI MENINGITIS GRAM STAIN TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 I X D LB^BQICAEP1(X,CT) K @TREF Q
 K @TREF
 F TAX="BQI MENINGITIS QUAN LOINC","BQI MENINGITIS QUAN TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 I X D LB^BQICAEP1(X,CT)
 K @TREF
 Q
 ;F TAX="BQI MENINGITIS QUAL TEST LOINC","BQI MENINGITIS QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI MENINGITIS ID SPEC LOINC","BQI MENINGITIS ID SPEC TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI MENINGITIS GRAM STAIN LNC","BQI MENINGITIS GRAM STAIN TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI MENINGITIS QUAN LOINC","BQI MENINGITIS QUAN TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;Q
 ;
FLU(BQDFN,VISIT,RESULT) ;EP - Influenza
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S RESULT(1)=$$MEAS^BQICAUTL(BQDFN,3,VISIT,"100",">") I RESULT(1)=0 Q
 S CT=CT+1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"SURVEILLANCE RAPID FLU LOINC","POS","","","",.TREF)
 I X D LB^BQICAEP1(X,CT) Q
 K @TREF
 F TAX="BQI INFLUENZA TEST 3 LOINC","BQI INFLUENZA TEST 3 TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 I X D LB^BQICAEP1(X,CT) Q
 K @TREF
 Q
 ;
TUB ; EP - Tuberculosis
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 S X=$$TAX^BQITRUTL("T-60","SURVEILLANCE TUBERCULOSIS",1,BQDFN,9000010.07,"","",.TREF)
 F TAX="BKM PPD LOINC CODES","BKM PPD TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","=","","",.TREF)
 I X D LB^BQICAEP1(X) Q
 K @TREF
 F TAX="BQI PPD DIAMETER LOINC","BQI PPD DIAMETER TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","=","","",.TREF)
 I X D LB^BQICAEP1(X) Q
 K @TREF
 F TAX="BQI TB GAMMA REL QUAL TEST LNC","BQI TB GAMMA REL QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","=","","",.TREF)
 I X D LB^BQICAEP1(X) Q
 K @TREF
 F TAX="BQI TB GAMMA REL QUANT TEST LC","BQI GAMMA REL QUANT TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 I X D LB^BQICAEP1(X) Q
 K @TREF
 F TAX="BQI TB RNA DNA QUAL TEST LOINC","BQI TB RNA DNA QUAL TEST TAX"
 F TAX="BQI TB RNA DNA QUANT TEST LNC","BQI TB RNA DNA QUANT TEST TAX"
 F TAX="BQI TB SPECIFIC AFB TEST LOINC","BQI TB SPECIFIC AFB TEST TAX"
 F TAX="BQI TB NONSPEC AFB TEST LOINC","BQI TB NONSPEC AFB TEST TAX"
 Q
 ;
SYP(BQDFN,RESULT) ;EP - Syphilis
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 F TAX="BKM RPR LOINC CODES","BKM RPR TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI SYPH DARK FIELD TEST LOINC","BQI SYPH DARK FIELD TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI SYPHILIS QUAL TEST LOINC","BQI SYPHILIS QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 I X D LB^BQICAEP1(X,CT) K @TREF Q
 K @TREF
 F TAX="BQI SYPHILIS QUANT TEST LOINC","BQI SYPHILIS QUANT TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 I X D LB^BQICAEP1(X,CT)
 K @TREF
 Q
 ;F TAX="BQI SYPH DARK FIELD TEST LOINC","BQI SYPH DARK FIELD TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI SYPHILIS QUAL TEST LOINC","BQI SYPHILIS QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI SYPHILIS QUANT TEST LOINC","BQI SYPHILIS QUANT TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;Q
 ;
HIB(BQDFN,RESULT) ;EP - HIB Flu
 NEW UID,TREF,TAX,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S RESULT(1)=0,CT=1
 S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 F TAX="BQI HIB QUAL TEST LOINC","BQI HIB QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 F TAX="BQI HIB CULTURE TEST LOINC","BQI HIB CULTURE TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 I X D LB^BQICAEP1(X,CT) K @TREF Q
 K @TREF
 F TAX="BQI HIB QUANT TEST LOINC ","BQI HIB QUANT TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 I X D LB^BQICAEP1(X,CT)
 K @TREF
 Q
 ;F TAX="BQI HIB QUAL TEST LOINC","BQI HIB QUAL TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI HIB CULTURE TEST LOINC","BQI HIB CULTURE TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"","POS","","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;F TAX="BQI HIB QUANT TEST LOINC ","BQI HIB QUANT TEST TAX" D BLD^BQITUTL(TAX,.TREF)
 ;S X=$$LAB^BQITRUTL("T-60",0,BQDFN,"",0,">","","",.TREF)
 ;I X D LB^BQICAEP1(X,CT) Q
 ;K @TREF
 ;Q
