BKMQQCRA ;PRXM/HC/BWF - BKM Quality of Care Report ; 13 Jun 2005  3:41 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Quality of Care Audit Report
 ; Modified to write to a temporary file for iCare
 ;
PRINT ; EP - Print report.
 N TOTPTS,EXDT,INST,HEEXT,CONFS,CONFE,BKMRTN
 N LNLEN,LINE,X
 N APCHSPAT,APCHSTYP
 S DATA=$NA(^TMP("BQIQOC",UID)) K @DATA
 ;
 S LNLEN=80 ; 80 Character display - currently hardcoded - could be a parameter
 S LINE="",$P(LINE,"-",LNLEN-1)=""
 S CONFS="****    CONFIDENTIAL PATIENT INFORMATION    ****"
 S CONFE="****  END CONFIDENTIAL PATIENT INFORMATION  ****"
 ;D NOW^%DTC
 S EXDT=$$FMTE^XLFDT($$NOW^XLFDT())
 S INST=$$GET1^DIQ(4,$G(DUZ(2)),.01,"E")
 S HEEXT=$P($$FMTE^XLFDT(EDATE),"@",1)
 D COLHDR
 S TOTPTS=+$G(@GLOB@("HIVTOT1"))
 I TOTPTS=0,$D(NDA) S BMXSEC="RPC Call Failed: This report cannot be run. None of the patients selected for this report meet the criteria."_$C(30) Q
 I TOTPTS=0 D UPD("No Data to Report") G DONE
 D HDR
 D UPD(" Total Patients Reviewed: "_(TOTPTS+$G(NDA)))
 D UPD(" Number of Patient Included in this Report "_TOTPTS)
 ;D UPD(TOTPTS_" Included in this Report      .")
 D UPD("   (Eligible Population)")
 ;D UPD($$LINE("","#",50)_"         %")
 D UPD("")
 ;D UPD(" Total Number of Eligible Trimesters: 4")
 ;D UPD("")
 D UPD("                                             Number  Percentage")
 D WC(" Gender: Male","MALE")
 D WC("         Female","FEMALE")
 I @GLOB@("UNSPEC") D WC("        Unspecified","UNSPEC")
 D UPD("")
 D WC(" Age     <15 yrs","AGE1")
 D WC("         15-44 yrs","AGE2")
 D WC("         45-64 yrs","AGE3")
 D WC("         >64 yrs","AGE4")
 D UPD("")
 D UPD(" Visits and Related Labs ")
 D UPD("   Every 4 months")
 D WP("      Total # of Patients w/ Visits","V4M","TOTAL")
 D WP("        Patients w/ only a CD4 Count ","CD4M","TOTAL")
 D UPD("            every 4 months")
 D WP("        Patients w/ only a Viral Load ","VR4M","TOTAL")
 D UPD("            every 4 months")
 D WP("        Patients w/ both a CD4 Count & a Viral ","BT4M","TOTAL")
 D UPD("            Load every 4 months")
 D UPD("   Every 6 months")
 D WP("      Total # of Patients w/ Visits","V6M","TOTAL")
 D WP("        Patients w/ only a CD4 Count ","CD6M","TOTAL")
 D UPD("          every 6 months")
 D WP("        Patients w/ only a Viral Load ","VR6M","TOTAL")
 D UPD("          every 6 months")
 D WP("        Patients w/ both a CD4 Count & a Viral ","BT6M","TOTAL")
 D UPD("          Load every 6 months")
 D UPD("")
 D WC(" Number of CD4 counts in Last Time Period","LCD4M",1)
 D UPD("")
 D WC(" Number of Viral Loads in Last Time Period","LVR4M",1)
 ;D UPD("    Time Period")
 D UPD("")
 D UPD(" ARV Management")
 D UPD("        Stable")
 D WP("           Period 1","STCP1","TOTAL")
 D WP("           Period 2","STCP2","TOTAL")
 D WP("           Period 3","STCP3","TOTAL")
 D UPD("        Unstable")
 D WP("           Period 1","UNCP1","TOTAL")
 D WP("           Period 2","UNCP2","TOTAL")
 D WP("           Period 3","UNCP3","TOTAL")
 D UPD("        End Stage")
 D WP("           Period 1","ENCP1","TOTAL")
 D WP("           Period 2","ENCP2","TOTAL")
 D WP("           Period 3","ENCP3","TOTAL")
 ;D UPD("        No Other Therapeutic Option")
 ;D WP("           Period 1","NNCP1","TOTAL")
 ;D WP("           Period 2","NNCP2","TOTAL")
 ;D WP("           Period 3","NNCP3","TOTAL")
 D UPD("        Documentation Assessment")
 D WP("           Period 1","AHCP1","TOTAL")
 D WP("           Period 2","AHCP2","TOTAL")
 D WP("           Period 3","AHCP3","TOTAL")
 D UPD("")
 D WP("        Patients Managed Appropriately","APPMGT","TOTAL")
 D UPD("")
 D UPD(" HAART")
 D WP("    Total number of patients on HAART","HAART","TOTAL")
 D WP("      CD4 0-199","HCD4RES1","TOTAL")
 D WP("      CD4 200-349","HCD4RES2","TOTAL")
 D WP("      CD4 350-499","HCD4RES3","TOTAL")
 D WP("      CD4 greater than or equal to 500","HCD4RES4","TOTAL")
 D WP("      Viral Load less than 400","HVIRSUP","TOTAL")
 D WP("      Viral Load greater than or equal to 400","HVIRNOT","TOTAL")
 D WP("      Viral Load not assessed in past 6 months","HVIR6M","TOTAL")
 D UPD("")
 D UPD(" NO HAART")
 D WP("    Total # of patients","NOHAART","TOTAL")
 D WP("      CD4 0-199","NHCD4RES1","TOTAL")
 D WP("      CD4 200-349","NHCD4RES2","TOTAL")
 D WP("      CD4 350-499","NHCD4RES3","TOTAL")
 D WP("      CD4 greater than or equal to 500","NHCD4RES4","TOTAL")
 D UPD("")
 D UPD(" Prophylaxis")
 D WP("     PCP","PCPT","TOTAL")
 D WP("     MAC","MACT","TOTAL")
 D UPD("")
 D UPD(" Screening Indicators")
 D UPD("    Lipid Profile")
 D WP("        Total # received lipid profile","LIPT","TOTAL")
 D WP("        Total # on ARV Regimen","LIPT","LIPIDARV")
 D WP("        Total # refused Profile","LIPT","LIPIDREF")
 D UPD("    PPD Screening")
 D WP("        Total # of TB tests needed","TUBT","NEEDPPD")
 D WP("        PPD Received","TUBT","PY")
 D WP("        PPD+","TUBT","POSPY")
 D WP("           Treatment Provided","TUBT","MED")
 D WP("        PPD-","TUBT","NEGPY")
 D WP("        PPD Refused","TUBT","REF")
 D WP("        PPD Unknown","TUBT","UND")
 D UPD("    Hepatitis C Screening")
 D WP("        Total # screened","HEPCT","TOTAL")
 D UPD("    Syphilis Screening")
 D WP("        Total # screened ","RPRT","TOTAL")
 D WP("        Reactive","RPRT","REAC")
 D WP("        Non-Reactive","RPRT","NONREAC")
 D WP("        Refused","RPRT","REF")
 D WP("        NMI","RPRT","REFNMI")
 D WP("        Undetermined","RPRT","UND")
 D UPD("    Chlamydia Screening")
 D WP("        Total # screened","CHLAMT","TOTAL")
 D WP("        Total # of men screened","CHLAMT","MALE")
 D WP("        Total # of women screened","CHLAMT","FEMALE")
 D WP("        Total Positive","CHLAMT","POS")
 D WP("        Total Negative","CHLAMT","NEG")
 D WP("        Total Refused","CHLAMT","REF")
 D WP("        NMI","CHLAMT","REFNMI")
 D WP("        Undetermined","CHLAMT","UND")
 D UPD("    Gonorrhea Screening")
 D WP("        Total # screened","GONT","TOTAL")
 D WP("        Total # of men screened","GONT","MALE")
 D WP("        Total # of women screened","GONT","FEMALE")
 D WP("        Total Positive","GONT","POS")
 D WP("        Total Negative","GONT","NEG")
 D WP("        Total Refused","GONT","REF")
 D WP("        NMI","GONT","REFNMI")
 D WP("        Undetermined","GONT","UND")
 D UPD("    Colorectal Cancer Screening (CRC)")
 D WP("        Total # screenings needed","CRCT","TOTAL")
 D WP("        CRC screens performed w/in 10yrs","CRCT","CRC")
 D UPD("       prior to the report end date")
 D WP("        CRC screens refused w/in 10 yrs","CRCT","CRCR")
 D UPD("       prior to the report end date")
 D UPD("")
 D UPD(" General Medical Care Exams - Yearly")
 D WP("     Ophthalmology care","EYET","TOTAL")
 D WP("     Oral Health","DENTT","TOTAL")
 D WP("     Pap smear (women)","PAPT","TOTAL")
 D UPD("")
 D UPD(" Vaccination")
 D WP("     Pneumovax w/in 5 yrs of report end","PNEUMOT","TOTAL")
 D UPD("    date OR 2 ever ")
 D WP("     Tetanus w/in 10 yrs of report end date","TETT","TOTAL")
 D UPD("")
 D UPD(" Substance Use Screening and Mental Health Screening")
 D WP("     Tobacco Use Screening","TOBT","SCREEN")
 D WP("        Current Tobacco User","TOBT","USER")
 D WP("        If Yes, Counseled","TOBT","ED")
 D WP("        Not a Current User","TOBT","NON")
 D WP("        Not Documented","TOBT","UNK")
 D UPD("")
 D WP("     Substance Use Screening","SUBST","TOTAL")
 D UPD("")
 D UPD("     Mental Health Screening")
 D WP("        Total # Who Received All Components","MHSCRN","TOTAL")
 D WP("            Cognitive Function","MHCOG","TOTAL")
 D WP("            Depression","MHDEP","TOTAL")
 D WP("            Anxiety","MHANX","TOTAL")
 D WP("            Sleep","MHSLEEP","TOTAL")
 D WP("            Appetite","MHAPP","TOTAL")
 D WP("            Domestic Violence","MHDV","TOTAL")
 D WP("            Post-Traumatic Stress Disorder","MHPTSD","TOTAL")
 D WP("            Psychosocial Assessment","MHPSYC","TOTAL")
 D UPD("")
 D UPD("     Patient Education")
 D WP("        Safe Sex education","SSEX","TOTAL")
 D WP("        Family Planning education","FPLN","TOTAL")
 D WP("        HIV/AIDS related education","HIVED","TOTAL")
 D UPD("")
 ;PRXM/HC/BHS - 05/10/2006 - Force page break before patient list
 D UPD($C(12),1)
 D HDR
 D CTR("HMS Quality of Care Report"),UPD("")
 D UPD(" This report includes all patients who meet the criteria of the selected")
 D UPD(" denominator:"),UPD("")
 ;I $G(BKMRPOP)'="" D
 ;. D UPD("     * Register Status = Active") ;W !!
 ;. D UPD("     * Current Diagnosis ="_$S($P(DENPOP,":",2)=" All":" HIV and AIDS",1:$P(DENPOP,":",2))) ;W ?5,"* Current Diagnosis =",$S($P(DENPOP,":",2)=" All":" HIV and AIDS",1:$P(DENPOP,":",2))
 D UPD(" 1) HMS Register Status Active with HMS Dx Category values empty, HIV or AIDS")
 D UPD(" (i.e., no ""At Risk"" patients);"),UPD("")
 D UPD(" OR"),UPD("")
 D UPD(" 2) Proposed and/or Accepted Dx tag of HIV/AIDS (user selects either or both")
 D UPD(" Tag Status);"),UPD("")
 D UPD(" OR"),UPD("")
 D UPD(" 3) Specific patients on the grid."),UPD("")
 D UPD(" Any denominator is filtered automatically by the following logic: patients")
 D UPD(" must have at least one HIV/AIDS POV or Active Problem List or HMS Initial")
 D UPD(" HIV Dx Date or HMS Initial AIDS Dx Date 6 months or more prior to report")
 D UPD(" end date."),UPD("")
 ;D UPD("     * "_DENPOP),UPD("")
 D UPD(" Total patients reviewed (All patients in denominator): "_(TOTPTS+$G(NDA))),UPD("") ;,!!
 ;D UPD(" Total Patients Reviewed: "_(TOTPTS+$G(NDA))),UPD("") ;,!!
 D UPD(" Number of Patients included on Report (filtered denominator): "_TOTPTS),UPD("")
 D UPD(" Number of Patients NOT included on Report: "_+$G(NDA)),UPD("")
 D UPD($C(12),1)
 D HDR
 D UPD(" The following user selected patients are included on this report:")
 D UPD("")
 S BKMRTN=""
 D PATHDR
 ; Loop through patient list
 S BKMDFN=""
 F  S BKMDFN=$O(@GLOB@("HIVCHK",BKMDFN)) Q:BKMDFN=""!('+BKMDFN)  D
 . S BKMPATN=$$GET1^DIQ(2,BKMDFN,".01","E")
 . I BKMPATN="" S BKMPATN="{MISSING NAME}"
 . S @GLOB@("HIVCHK","SORTED BY NAME",BKMPATN,BKMDFN)=""
 ; Loop through patient list sorted by name
 S BKMPATN="",BKMRTN=""
 F  S BKMPATN=$O(@GLOB@("HIVCHK","SORTED BY NAME",BKMPATN)) Q:BKMPATN=""  D  Q:BKMRTN="^"
 . S BKMDFN="",BKMRTN=""
 . F  S BKMDFN=$O(@GLOB@("HIVCHK","SORTED BY NAME",BKMPATN,BKMDFN)) Q:BKMDFN=""!('+BKMDFN)  D  Q:BKMRTN="^"
 .. D PAT(BKMPATN,BKMDFN)
 I $D(NDA) D
 . D UPD("")
 . D UPD($C(12),1)
 . D HDR
 . ; Loop through patient list
 . ;D UPD(""),UPD(+$G(NDA)_" patients were reviewed and not included in this report because they did")
 . ;D UPD("not meet the first criteria listed above."),UPD("")
 . D UPD(" The following user selected patients are NOT included in the report:"),UPD("")
 . D PATHDR
 . S BKMPATN=""
 . F  S BKMPATN=$O(NDA(BKMPATN)) Q:BKMPATN=""  D
 .. S BKMDFN=""
 .. F  S BKMDFN=$O(NDA(BKMPATN,BKMDFN)) Q:BKMDFN=""  D
 ... D PAT(BKMPATN,BKMDFN)
 D UPD(""),UPD("")
 D CTR(CONFE)
 S BQII=BQII+1,@DATA@(BQII)=$C(30)
 G DONE
 ;
HDR ; Report header
 D UPD($$PAD^BKMIXX4($$GET1^DIQ(200,DUZ_",","1","E"),">"," ",55)_$$PAD^BKMIXX4($$FMTE^BQIUL1($$NOW^XLFDT()),">"," ",25)) ;***
 D CTR(INST)
 D CTR("HMS CUMULATIVE AUDIT REPORT")
 D CTR("HIV QUALITY OF CARE")
 ;D CTR("*** HMS CUMULATIVE AUDIT REPORT -- HIV QUALITY OF CARE ***")
 I PLNM'="" D CTR(PLNM)
 D CTR(DENPOP)
 ;D CTR("Denominator Population - "_DENPOP)
 D CTR("PERIOD ENDING: "_HEEXT)
 ;D CTR("Period Ending: "_HEEXT)
 D CTR(CONFS)
 D UPD(" "_LINE)
 Q
 ;
WC(STR,TYPE,PER) ;
 N VAL
 I TYPE="" Q
 I $G(PER)="" S PER=0
 S VAL=+$G(@GLOB@(TYPE))
 S STR=$$LINE(STR,$J(VAL,3),47)
 ;W ?47,$J(VAL,3)
 I 'PER S STR=$$LINE(STR,$J(VAL/TOTPTS*100,5,1)_"%",55)
 ;W ?55,$J(VAL/TOTPTS*100,5,1),"%",!
 D UPD(STR)
 Q
WP(STR,CAT,TYPE) ;
 N VAL,PERC
 I TYPE="" Q
 S VAL=+$G(@GLOB@(CAT,TYPE,"CNT"))
 S STR=$$LINE(STR,$J(VAL,3),47)
 ;W ?47,$J(VAL,3)
 S PERC=$G(@GLOB@(CAT,TYPE,"PERC"))
 S STR=$$LINE(STR,$J(PERC,5,1)_"%",55)
 D UPD(STR)
 ;W ?55,$J(PERC,5,1),"%",!
 Q
PAT(BKMPATN,BKMDFN) ;
 N BKMIEN,BKMREG,TEXT,DXCAT
 Q:$G(BKMPATN)=""!($G(BKMDFN)="")
 S TEXT=$G(BKMPATN)
 ;S TEXT=" "_$G(BKMPATN)
 S TEXT=$$LINE(TEXT,$$HRN^BKMVA1(BKMDFN),29)
 S TEXT=$$LINE(TEXT," "_$$GET1^DIQ(2,BKMDFN,".033","E"),36)
 S TEXT=$$LINE(TEXT," "_$$GET1^DIQ(2,BKMDFN,".02","I"),40)
 ;S DXCAT=$P($$ACT^BKMQUTL(BKMDFN,HMSIEN,""),U,2)
 ;I DXCAT'="" S TEXT=$$LINE(TEXT,"HIV/AIDS ("_DXCAT_")",45)
 S BKMIEN=$$BKMIEN^BKMIXX3(BKMDFN)
 I BKMIEN="" D UPD(TEXT) Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" D UPD(TEXT) Q
 ;S TEXT=$$LINE(TEXT,"  "_$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",",".5","E"),58)
 S TEXT=$$LINE(TEXT,$E($$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","2.3","E"),1,4),44)
 S TEXT=$$LINE(TEXT,$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","5","I"),"5Z"),49)
 S TEXT=$$LINE(TEXT,$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","5.5","I"),"5Z"),61)
 S DXCAT=$P($$ACT^BKMQUTL(BKMDFN,HMSIEN,""),U,2)
 I DXCAT'="" S TEXT=$$LINE(TEXT,DXCAT,76)
 D UPD(TEXT)
 Q
PATHDR ;
 N BKMHDR,TEXT
 S $P(BKMHDR,"-",79)=""
 S TEXT=" "
 S TEXT=$$LINE(TEXT,"REG",44)
 S TEXT=$$LINE(TEXT,"INITIAL HIV",49)
 S TEXT=$$LINE(TEXT,"INITIAL AIDS",61)
 S TEXT=$$LINE(TEXT,"TAG",74)
 D UPD(TEXT)
 S TEXT="PATIENT NAME"
 S TEXT=$$LINE(TEXT,"HRN",29)
 S TEXT=$$LINE(TEXT,"AGE",36)
 S TEXT=$$LINE(TEXT,"SEX",40)
 S TEXT=$$LINE(TEXT,"DX",45)
 S TEXT=$$LINE(TEXT,"DX DATE",52)
 S TEXT=$$LINE(TEXT,"DX DATE",65)
 S TEXT=$$LINE(TEXT,"STATUS",74)
 D UPD(TEXT)
 S TEXT=$E(BKMHDR,1,12)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,3),29)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,3),36)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,3),40)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,3),44)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,11),49)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,12),61)
 S TEXT=$$LINE(TEXT,$E(BKMHDR,1,6),74)
 D UPD(TEXT)
 Q
 ;
CTR(TEXT) ; EP - Center data.
 ;
 ; Input - TEXT   - Text (required)
 ;         LENGTH - Line length (default is 80)
 ; This utility will center the data before filing it to the RPC temporary global.
 ;
 N CENTER,CLINE,LEN,START
 S LEN=$L(TEXT)
 S CENTER=LEN/2,CLINE=LNLEN/2
 S START=CLINE-CENTER\1
 S TEXT=$$LINE("",TEXT,START)
 D UPD(TEXT)
 Q
  ;
LINE(TEXT,STR,POS) ; Set text to match Quality of Care report formatting
 I $L(TEXT)>POS Q TEXT_STR
 S $E(TEXT,POS)=STR
 Q TEXT
 ;
UPD(LINE,SUPP) ; Update global with line of text; update page and total line count
 ;SUPP - Suppress line feed carriage return
 S SUPP=$G(SUPP)
 S BQII=BQII+1,@DATA@(BQII)=LINE_$S(SUPP:"",1:$C(13)_$C(10))
 Q
 ;
DONE ;
 ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
COLHDR ;
 S @DATA@(BQII)="T00120REPORT_TEXT"_$C(30)
 ;S @DATA@(BQII)="T99999REPORT_TEXT"_$C(30)
 Q
