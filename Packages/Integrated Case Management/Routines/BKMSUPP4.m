BKMSUPP4 ;PRXM/HC/WOM - Continuation of BKMSUPP1, HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:31 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
HEP(DFN) ;EP - Retrieve Hepatitis Panel taxonomies
 N LAST,GLOBAL
 W !?1,"Hepatitis: ",!?5,"Hepatitis Panel:"
 K BKMT("HPNL")
 S GLOBAL="BKMT(""HPNL"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM HEPATITIS PANEL TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BKM HEP PANEL LOINC CODES","","",GLOBAL)
 ;Retrieve labs for CPT and store in BKMT("HPNL")
 S LAST=$$GETLAB("BKM HEPATITIS PANEL CPTS",DFN)
 I LAST S BKMT("HPNL",+LAST,$P(LAST,U,2),"LAB")=$P(LAST,U,3)
 ;
 ;Find most recent lab test from BKMT("HPNL") and process panel 
 D PANEL
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("HPNL")) D
 .S GLOBAL="BKMT(""HPNL"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEP PANEL LOINC CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEPATITIS PANEL TAX","","",GLOBAL)
 .;Print results
 .D LTAXPRT^BKMSUPP1("HPNL",1,1,1)
 ;Retain array for comparison with Hep B and C
 Q
HEPB(DFN) ;EP - Retrieve Hep B taxonomies
 N RESULT,VDT,TST,LABT,GLOBAL,LDT
 W !?5,"Hep B: "
 K BKMT("HEPB")
 S GLOBAL="BKMT(""HEPB"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM HEP B TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BKM HEP B LOINC CODES","","",GLOBAL)
 D MULT("HEPB")
 S GLOBAL="LABT(""HEPB"",LSTDT\1,TEST)"
 S RESULT=$$GETLAB^BKMSUPP4("BKM HEP B TESTS CPTS",DFN,GLOBAL)
 I RESULT]"" D
 . S VDT=+RESULT,TST=$P(RESULT,U,2),RESULT=$P(RESULT,U,3)
 . I TST]"" S BKMT("HEPB",VDT,TST,"LAB")=RESULT
 D HEPCMP("HEPB") ;Compare BKMT("HEPB" with BKMT("HPNL" and delete overlaps
 ;Only print results if last HEP B is more recent than last Hep Panel
 I $D(BKMT("HEPB")) D
 . S LDT=$O(BKMT("HEPB",""),-1)\1
 . I LDT'>($O(BKMT("HPNL",""),-1)\1) Q
 . ;Print results
 . D PRTHEP(LDT,"HEPB")
 . ;D LTAXPRT^BKMSUPP1("HEPB",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("HEPB")) D
 . S GLOBAL="BKMT(""HEPB"",VSTDT,TEST,""LAB"")"
 . D REFUSAL^BKMIXX2(DFN,60,"BKM HEP B LOINC CODES","","",GLOBAL)
 . D REFUSAL^BKMIXX2(DFN,60,"BKM HEP B TAX","","",GLOBAL)
 . S LDT=$O(BKMT("HEPB",""),-1)\1
 . I LDT'>($O(BKMT("HPNL",""),-1)\1) Q
 . ;Print results
 . D LTAXPRT^BKMSUPP1("HEPB",1,1,1)
 K BKMT("HEPB")
 Q
HEPC(DFN) ;EP - Retrieve Hep C taxonomies
 N LAST,TYP,GLOBAL1,GLOBAL2,LABT,LDT,VDT,TST,RESULT,Y,TEST,END
 W !?5,"Hep C: "
 K BKMT("HEPC"),BKMT("HEPC-EIA"),BKMT("HEPC-RIBA")
 S GLOBAL1="BKMT(""HEPC-EIA"",VSTDT,TEST,""LAB"")"
 S GLOBAL2="BKMT(""HEPC-RIBA"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM HEP C SCREENING TAX","","",GLOBAL1)
 D LABTAX^BKMIXX(DFN,"BKM HEP C CONFIRMATORY TAX","","",GLOBAL2)
 D LOINC^BKMIXX(DFN,"BKM HEP C SCREEN LOINC CODES","","",GLOBAL1)
 D LOINC^BKMIXX(DFN,"BKM HEP C CONFIRM LOINC CODES","","",GLOBAL2)
 F TYP="HEPC-EIA","HEPC-RIBA" D MULT(TYP)
 S GLOBAL1="LABT(""HEPC-EIA"",LSTDT\1,TEST)"
 S GLOBAL2="LABT(""HEPC-RIBA"",LSTDT\1,TEST)"
 S RESULT=$$GETLAB("BKM HEP C SCREEN TESTS CPTS",DFN,GLOBAL1)
 I RESULT]"" D
 . S VDT=+RESULT,TST=$P(RESULT,U,2),RESULT=$P(RESULT,U,3)
 . I TST]"" S BKMT("HEPC-EIA",VDT,TST,"LAB")=RESULT
 S RESULT=$$GETLAB("BKM HEP C CONFIRM TESTS CPTS",DFN,GLOBAL2)
 I RESULT]"" D
 . S VDT=+RESULT,TST=$P(RESULT,U,2),RESULT=$P(RESULT,U,3)
 . I TST]"" S BKMT("HEPC-RIBA",VDT,TST,"CPT")=RESULT
 ;BKMT("HEPC") is consolidated list of results
 M BKMT("HEPC")=BKMT("HEPC-EIA")
 M BKMT("HEPC")=BKMT("HEPC-RIBA")
 D HEPCMP("HEPC") ;Compare BKMT("HEPC" with BKMT("HPNL" and delete overlaps
 ;Determine if result (last test) is EIA or RIBA
 I $D(BKMT("HEPC")),$O(BKMT("HEPC",""),-1) D
 . S LAST=$Q(BKMT("HEPC",""),-1)
 . ;Only print results if last HEP C is more recent than last Hep Panel
 . S LDT=$O(BKMT("HEPC",""),-1)\1
 . I LDT'>($O(BKMT("HPNL",""),-1)\1) Q
 . I $D(@("BKMT(""HEPC-EIA"","_$P(LAST,",",2)_")")) W "[EIA] " D
 .. D PRTHEP(LDT,"HEPC-EIA")
 .. I '$D(@("BKMT(""HEPC-RIBA"","_$P(LAST,",",2)_")")) Q
 .. ; If EIA and Confirm on same day print both
 .. W !?5,"Hep C: "
 . I $D(@("BKMT(""HEPC-RIBA"","_$P(LAST,",",2)_")")) W "[Confirm] " D PRTHEP(LDT,"HEPC-RIBA") ;K LABT("HEPC-EIA")
 K BKMT("HEPC-EIA"),BKMT("HEPC-RIBA")
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("HEPC")) D
 .S GLOBAL1="BKMT(""HEPC-EIA"",VSTDT,TEST,""LAB"")"
 .S GLOBAL2="BKMT(""HEPC-RIBA"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEP C SCREEN LOINC CODES","","",GLOBAL1)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEP C CONFIRM LOINC CODES","","",GLOBAL2)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEP C SCREENING TAX","","",GLOBAL1)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM HEP C CONFIRMATORY TAX","","",GLOBAL2)
 .;BKMT("HEPC") is consolidated list of results
 .M BKMT("HEPC")=BKMT("HEPC-EIA")
 .M BKMT("HEPC")=BKMT("HEPC-RIBA")
 .;Is refusal EIA or RIBA
 .I $D(BKMT("HEPC")),$O(BKMT("HEPC",""),-1) D
 .. S LAST=$Q(BKMT("HEPC",""),-1)
 .. S LDT=$O(BKMT("HEPC",""),-1)\1
 .. I LDT'>($O(BKMT("HPNL",""),-1)\1) Q
 .. I $D(@("BKMT(""HEPC-EIA"","_$P(LAST,",",2,9999))) W "[EIA] " Q
 .. W "[Confirm] "
 .K BKMT("HEPC-EIA"),BKMT("HEPC-RIBA")
 .;Print results
 .D LTAXPRT^BKMSUPP1("HEPC",1,1,1)
 K BKMT("HEPC")
 Q
PANEL ;EP - Get panel of tests associated with lab and print
 N PDT,REVDT,TEST,LAB,PNL,LABIEN,OLABIEN,OLAB,VISIT,VSTDT
 K ^TMP("BKMSUPP",$J,"LAB"),^TMP("BKMSUPP",$J,"PANEL"),^TMP("BKMSUPP",$J,"HPNL")
 ;
 ;Get most recent lab test
 S PDT=$O(BKMT("HPNL",""),-1) Q:PDT=""
 S REVDT=9999999-$P(PDT,"."),TEST=""
 F  S TEST=$O(BKMT("HPNL",PDT,TEST)) Q:TEST=""  D
 . I $D(BKMT("HPNL",PDT,TEST,"LAB")) D  Q:LAB]""
 .. S LAB=$$GET1^DIQ(9000010.09,TEST,.01,"I") Q:LAB=""
 .. S ^TMP("BKMSUPP",$J,"LAB",LAB)=BKMT("HPNL",PDT,TEST,"LAB")
 Q:'$D(^TMP("BKMSUPP",$J,"LAB"))  ;No lab tests found
 ;
 ; get panels associated with lab tests
 S (LAB,PNL)=""
 F  S LAB=$O(^TMP("BKMSUPP",$J,"LAB",LAB)) Q:LAB=""  D
 . F  S PNL=$O(^LAB(60,"AB",LAB,PNL)) Q:PNL=""  D
 .. ;Check if patient has lab panel on lab date
 .. S LABIEN=$O(^AUPNVLAB("AA",DFN,PNL,REVDT,"")) Q:'LABIEN
 .. S ^TMP("BKMSUPP",$J,"PANEL",PNL,LAB)=^TMP("BKMSUPP",$J,"LAB",LAB)
 .. ;
 .. ;Check other lab tests in panel
 .. D PANLD(PNL,DFN,REVDT,LAB)
 . I $D(^LAB(60,LAB,2)) D PANLD(LAB,DFN,REVDT) ;Test is itself a panel
 ;
 ;If no panel of tests for most recent lab do not print Hep Panel info
 I '$D(^TMP("BKMSUPP",$J,"PANEL")) K BKMT("HPNL"),^TMP("BKMSUPP",$J,"HPNL") Q
 ;
 ;Print panel of tests associated with most recent lab
 S PNL=""
 F  S PNL=$O(^TMP("BKMSUPP",$J,"PANEL",PNL)) Q:PNL=""  D  Q:QUIT
 . W ?24,"Date: ",$P($$FMTE^XLFDT(PDT,"5Z"),"@")
 . I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 . W !?5,$$GET1^DIQ(60,PNL,.01,"E")
 . S LAB=""
 . F  S LAB=$O(^TMP("BKMSUPP",$J,"PANEL",PNL,LAB)) Q:LAB=""  D  Q:QUIT
 .. I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 .. W !?7,$$GET1^DIQ(60,LAB,.01,"E"),?43,"Result: ",^TMP("BKMSUPP",$J,"PANEL",PNL,LAB)
 ;
 ;Copy related lab tests into BKMT("HPNL") for HEPCMP to ensure
 ;that any tests printed here will not be duplicated in the Hep B or C sections
 I $D(^TMP("BKMSUPP",$J,"HPNL")) D
 . M BKMT("HPNL")=^TMP("BKMSUPP",$J,"HPNL") K ^TMP("BKMSUPP",$J,"HPNL")
 Q
 ;
PANLD(PANEL,DFN,REVDT,OTHER) ; EP
 ;Load lab tests associated with panel in ^TMP
 ;If lab test in taxonomy is part of a panel, OTHER is the original lab test 
 N LABTST,LAB,LABIEN,VISIT,VSTDT
 S OTHER=$G(OTHER)
 S LABTST=0
 F  S LABTST=$O(^LAB(60,PANEL,2,LABTST)) Q:'LABTST  D
 . S LAB=$G(^LAB(60,PANEL,2,LABTST,0)) Q:LAB=""!(LAB=OTHER)
 . S LABIEN=$O(^AUPNVLAB("AA",DFN,LAB,REVDT,"")) Q:'LABIEN
 . S ^TMP("BKMSUPP",$J,"PANEL",PANEL,LAB)=$$GET1^DIQ(9000010.09,LABIEN,.04,"I")
 . S VISIT=$$GET1^DIQ(9000010.09,LABIEN,.03,"I")
 . S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 . I VSTDT]"" S ^TMP("BKMSUPP",$J,"HPNL",VSTDT,LABIEN,"LAB")=""
 Q
 ;
GETLAB(TAX,DFN,TARGET) ; EP
 ;Get most recent lab result associated with a CPT taxonomy for a patient
 ;To return all lab tests for most recent date, TARGET (Target root - global or local)
 ;   can be passed and will return this data; this is an optional parameter
 N CPT,BCPTR,LAB,LAST,LSTDT,TEST,VISIT,VSTDT,RESULT
 K ^TMP("BKMCPT",$J)
 S (LAST,LSTDT,RESULT)=""
 D BLDTAX^BKMIXX5(TAX,"^TMP(""BKMCPT"",$J)")
 S CPT="" F  S CPT=$O(^TMP("BKMCPT",$J,CPT)) Q:CPT=""  D
 . S BCPTR=0 F  S BCPTR=$O(^BLRCPT(BCPTR)) Q:'BCPTR  D
 .. Q:'$D(^BLRCPT(BCPTR,11,"B",CPT))
 .. S LAB=$P($G(^BLRCPT(BCPTR,1)),U) Q:LAB=""
 .. S LAB(LAB)=""
 I $O(LAB("")) D
 . N LABR
 . S TEST=""
 . F  S TEST=$O(^AUPNVLAB("AC",DFN,TEST),-1) Q:TEST=""  D  Q:LAST]""
 .. S LAB=$$GET1^DIQ(9000010.09,TEST,.01,"I") Q:LAB=""  Q:'$D(LAB(LAB))
 .. S VISIT=$$GET1^DIQ(9000010.09,TEST,.03,"I")
 .. S VSTDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 .. I VSTDT>LSTDT S LAST=TEST,LSTDT=VSTDT,LABR(LSTDT\1,TEST)=""
 . I $G(TARGET)]"" D
 .. Q:'$D(LABR)
 .. S TEST="" F  S TEST=$O(LABR(LSTDT\1,TEST)) Q:TEST=""  D
 ... S @TARGET=$$GET1^DIQ(9000010.09,TEST,.04,"I")_U_$$GET1^DIQ(9000010.09,TEST,.01,"E")
 . I LAST S RESULT=$$GET1^DIQ(9000010.09,LAST,.04,"I")
 Q LSTDT_U_LAST_U_RESULT
 ;
MULT(TYP) ; Load multiple results in LABT array
 N HEPDT,HEPIEN
 S HEPDT=$O(BKMT(TYP,""),-1) I HEPDT  D
 . S HEPIEN=""
 . F  S HEPIEN=$O(BKMT(TYP,HEPDT,HEPIEN)) Q:'HEPIEN  D
 .. S LABT(TYP,HEPDT\1,HEPIEN)=$$GET1^DIQ(9000010.09,HEPIEN,.04,"I")_U_$$GET1^DIQ(9000010.09,HEPIEN,.01,"E")
 Q
 ;
HEPCMP(TYPE) ;Compare Hep Panel results with Hep B or Hep C (TYPE determines which one)
 N STOP,OTHER,PANEL
 S STOP="BKMT("""_TYPE_"""",OTHER=STOP_")",PANEL="BKMT(""HPNL"","
 F  S OTHER=$Q(@OTHER) Q:$P(OTHER,",")'=STOP  I $D(@(PANEL_$P(OTHER,",",2,99))) K @OTHER
 Q
 ;
PRTHEP(LDT,TYP) ; For Hep B and C print all results for last date using LABT array
 S Y=$$FMTE^XLFDT(LDT,"5Z")
 W ?24,"Date: ",Y
 I TYP]"" D
 . S END="LABT("""_TYP_""","_LDT,TEST=END_")"
 . F  S TEST=$Q(@TEST) Q:$P(TEST,",",1,2)'=END  W !?7,$P(@TEST,U,2),?42," Result: ",$P(@TEST,U)
 Q
XIT ;QUIT POINT
 Q
