BKMCRS ;PRXM/HC/ALA-STI for CRS ; 01 Mar 2007  7:17 PM
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 ;
 Q
 ;
 ; This function cycles through the V-Lab file checking
 ; each lab, CPT4, ICD9, and LOINC associated with a DFN to
 ; see if each is in an appropriate taxonomy, old enough,
 ; and if required positive.
 ;
 ; DFN is the patient DFN from file 2 or 9000001.
 ;
 ; LABT is the text name of the lab taxonomy.
 ; LOINCT is the text name of the LOINC taxonomy.
 ; CPTT is the text name of the CPT taxonomy.
 ; ICDT is the text name of the ICD9 taxonomy.
 ;
 ; BDATE is the base (starting) date for the search.
 ;
 ; IDATE is the date of the last item (LAB, LOINC, CPT, or ICD) passed by reference.
 ;
 ; LDATE is the date of the last LAB passed by reference.
 ; LR if there is a LDATE then the LR will be equal to the result.
 ; LV if there is a LDATE then the LV is the V Lab IEN.
 ;
 ; PDATE is the date of the last positive LAB passed by reference.
 ; PR if there is a PDATE then the PR will be equal to the positive result.
 ; PV if there is a PDATE then the PV is the V Lab IEN.
 ;
 ; NDATE is the date of the last negative LAB passed by reference.
 ; NR if there is a NDATE then the NR will be equal to the negative result.
 ; NV if there is a NDATE then the NV is the V Lab IEN.
 ;
LABCODES(DFN,LABT,LOINCT,CPTT,ICDT,EDATE,BDATE,IDATE,LDATE,LR,PDATE,PR,NDATE,NR,LV) ;EP
 ; Retrieve lab codes.
 N QDATE,QV,TARGET,LABTEST,LAB,LABDT,RESULT
 S LABT=$G(LABT,""),LOINCT=$G(LOINCT,""),CPTT=$G(CPTT,""),ICDT=$G(ICDT,""),OFLG=$G(OFLG,""),LV=$G(LV,"")
 S BDATE=$G(BDATE,""),IDATE=$G(IDATE,""),LDATE=$G(LDATE,""),PDATE=$G(PDATE,""),NDATE=$G(NDATE,""),ODATE=$G(ODATE,"")
 S EDATE=$G(EDATE,"")
 S (LR,PR,NR,OR)=""
 S TARGET="LABTEST(VSTDT,TEST)"
 S QDATE="",QV=""
 D LABTAX^BKMIXX(DFN,LABT,EDATE,BDATE,TARGET,.QDATE,.QV)
 I QDATE="",$D(LABTEST) D
 . S QDATE=$O(LABTEST(""),-1),QV=$O(LABTEST(QDATE,""),-1)
 I QDATE'="" D
 . S LDATE=QDATE\1
 . I QV'="" S TVALN=$P(^AUPNVLAB(QV,0),U,1),PRNM=$P($G(^LAB(60,TVALN,.1)),U,1)
 . I '$D(VALUE(BKTY,"NUM",BKNMTY,BKDATE)) S VALUE(BKTY,"NUM",BKNMTY,BKDATE)=1_U_$$FMTE^XLFDT(LDATE,"2Z")_" Lab ["_$S(PRNM'="":PRNM,1:$P($G(^LAB(60,TVALN,0)),U,1))_"]"_U_QV
 S IDATE=QDATE,LDATE=QDATE,LV=QV
 K LABTEST
 S QDATE="",QV=""
 D LOINC^BKMIXX(DFN,LOINCT,EDATE,BDATE,TARGET,.QDATE,.QV)
 I QDATE="",$D(LABTEST) D
 . S QDATE=$O(LABTEST(""),-1),QV=$O(LABTEST(QDATE,""),-1)
 I QDATE'="" D
 . S LDATE=QDATE\1
 . I QV'="" S TVALN=$P(^AUPNVLAB(QV,0),U,1),PRNM=$P($G(^LAB(60,TVALN,.1)),U,1)
 . I '$D(VALUE(BKTY,"NUM",BKNMTY,BKDATE)) S VALUE(BKTY,"NUM",BKNMTY,BKDATE)=1_U_$$FMTE^XLFDT(LDATE,"2Z")_" Lab ["_$S(PRNM'="":PRNM,1:$P($G(^LAB(60,TVALN,0)),U,1))_"]"_U_QV
 ;I QDATE>IDATE S IDATE=QDATE,LDATE=QDATE,LV=QV
 K LABTEST
 S QDATE="",QV=""
 D CPTTAX^BKMIXX(DFN,CPTT,EDATE,BDATE,TARGET,.QDATE,.QV)
 I QDATE="",$D(LABTEST) D
 . S QDATE=$O(LABTEST(""),-1),QV=$O(LABTEST(QDATE,""),-1)
 I QDATE'="" D
 . S LDATE=QDATE\1
 . I QV'="" S TVALN=$P(^AUPNVCPT(QV,0),U,1) D
 .. I $$VERSION^XPDUTL("BCSV") S PRNM=$$ICPT^BKMUL3(TVALN,LDATE,2) Q  ; csv
 .. S PRNM=$P($G(^ICPT(TVALN,0)),U,1)
 . I '$D(VALUE(BKTY,"NUM",BKNMTY,BKDATE)) S VALUE(BKTY,"NUM",BKNMTY,BKDATE)=1_U_$$FMTE^XLFDT(LDATE,"2Z")_" CPT ["_PRNM_"]"_U_QV
 ;I QDATE>IDATE S IDATE=QDATE,LDATE=QDATE,LV=QV
 K LABTEST
 S QDATE="",QV=""
 D ICDTAX^BKMIXX1(DFN,ICDT,EDATE,BDATE,TARGET,.QDATE,.QV)
 I QDATE="",$D(LABTEST) D
 . S QDATE=$O(LABTEST(""),-1),QV=$O(LABTEST(QDATE,""),-1)
 I QDATE'="" D
 . S LDATE=QDATE\1
 . I QV'="" S TVALN=$P(^AUPNVPOV(QV,0),U,1) D
 .. I $$VERSION^XPDUTL("BCSV") S PRNM=$$ICD9^BKMUL3(TVALN,LDATE,2) Q  ; csv
 .. S PRNM=$P($G(^ICD9(TVALN,0)),U,1)
 . I '$D(VALUE(BKTY,"NUM",BKNMTY,BKDATE)) S VALUE(BKTY,"NUM",BKNMTY,BKDATE)=1_U_$$FMTE^XLFDT(LDATE,"2Z")_" POV ["_PRNM_"]"_U_QV
 Q
 ;
HREF ; HIV Refusals
 S GLOBAL="BKMT(""HIV"",VSTDT,TEST,""LAB"")" D REFUSAL^BKMIXX2(BKMDFN,60,"BGP HIV TEST TAX","","",GLOBAL)
 S GLOBAL="BKMT(""HIV"",VSTDT,TEST,""CPT"")" D REFUSAL^BKMIXX2(BKMDFN,81,"BGP CPT HIV TESTS","","",GLOBAL)
 Q
 ;
CLRF ; Chlamydia Refusals
 S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""LAB"")" D REFUSAL^BKMIXX2(BKMDFN,60,"BGP CHLAMYDIA TESTS TAX","","",GLOBAL)
 S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""CPT"")" D REFUSAL^BKMIXX2(BKMDFN,81,"BGP CHLAMYDIA CPTS","","",GLOBAL)
 Q
 ;
GRF ; Gonorrhea Refusals
 S GLOBAL="BKMT(""GC"",VSTDT,TEST,""LAB"")" D REFUSAL^BKMIXX2(BKMDFN,60,"BKM GONORRHEA TEST TAX","","",GLOBAL)
 S GLOBAL="BKMT(""GC"",VSTDT,TEST,""CPT"")" D REFUSAL^BKMIXX2(BKMDFN,81,"BKM GONORRHEA TESTS CPTS","","",GLOBAL)
 Q
