BKMVQCRA ;PRXM/HC/BWF - BKMV Quality of Care Report; [ 1/19/2005  7:16 PM ] ; 13 Jun 2005  3:41 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Quality of Care Audit Report
PRINT ; EP - Print report.
 N TOTPTS,EXDT,INST,HEEXT,PAGE,CONFS,CONFE,HDRST,BKMRTN
 S CONFS="****    CONFIDENTIAL PATIENT INFORMATION    ****"
 S CONFE="****  END CONFIDENTIAL PATIENT INFORMATION  ****"
 U IO
 D NOW^%DTC
 S EXDT=$$FMTE^XLFDT(X)
 S INST=$$GET1^DIQ(4,$G(DUZ(2)),.01,"E")
 S HEEXT=$P($$FMTE^XLFDT(EDATE),"@",1)
 S PAGE=1
 I IOST["C-" W @IOF
 D HDR
 S TOTPTS=+$G(^TMP("BKMVQCR",$J,"HIVTOT1"))
 I TOTPTS=0 W !!,"No Data to Report",!! G PRINT1
 W ?1,"Total Patients Reviewed: "_TOTPTS,!!
 W ?50,"#",?60,"%",!!
 W ?1,"Gender: Male" D WC("MALE")
 W ?1,"        Female" D WC("FEMALE")
 I ^TMP("BKMVQCR",$J,"UNSPEC") W "        Unspecified" D WC("UNSPEC")
 W !
 W ?1,"Age     <15 yrs" D WC("AGE1")
 W ?1,"        15-44 yrs" D WC("AGE2")
 W ?1,"        45-64 yrs" D WC("AGE3")
 W ?1,"        >64 yrs" D WC("AGE4")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"LABORATORY EXAMS",!
 W ?1,"# w/ CD4 count in last six months" D WP("CD4T","TOTAL")
 W ?1,"        most recent<50" D WP("CD4T","LT50")
 W ?1,"        most recent 50-199" D WP("CD4T","BET50/200")
 W ?1,"        most recent=>200" D WP("CD4T","GTE200")
 W ?1,"        Undetermined" D WP("CD4T","UND")
 W !
 W ?1,"# w/ Viral Load in last six months" D WP("VRLT","TOTAL")
 W ?1,"        <100,000 copies/ml" D WP("VRLT","LT100K")
 W ?1,"        =>100,000 copies/ml" D WP("VRLT","GTE100K")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"# w/ RPR (Syphilis Test) in the last 12 months" D WP("RPRT","TOTAL")
 W ?1,"        Reactive" D WP("RPRT","REAC")
 W ?1,"        Non-Reactive" D WP("RPRT","NONREAC")
 W ?1,"        Refused" D WP("RPRT","REF")
 W ?1,"        NMI" D WP("RPRT","REFNMI")
 W ?1,"        Undetermined" D WP("RPRT","UND")
 W !
 W ?1,"# w/ Chlamydia Screen in the last 12 months" D WP("CHLAMT","TOTAL")
 W ?1,"        Positive" D WP("CHLAMT","POS")
 W ?1,"        Negative" D WP("CHLAMT","NEG")
 W ?1,"        Refused" D WP("CHLAMT","REF")
 W ?1,"        NMI" D WP("CHLAMT","REFNMI")
 W ?1,"        Undetermined" D WP("CHLAMT","UND")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"# w/ Gonorrhea Screen in the last 12 months" D WP("GONT","TOTAL")
 W ?1,"        Positive" D WP("GONT","POS")
 W ?1,"        Negative" D WP("GONT","NEG")
 W ?1,"        Refused" D WP("GONT","REF")
 W ?1,"        NMI" D WP("GONT","REFNMI")
 W ?1,"        Undetermined" D WP("GONT","UND")
 ;PRXM/HC/BHS - 05/10/2006 - only add blank line to terminal
 I IOST["C-" W !
 I IOST'["C-" W @IOF D HDR
 W ?1,"# w/ Tuberculosis test needed" D WP("TUBT","NEEDPPD")
 W ?1,"        PPD Received" D WP("TUBT","PY")
 W ?1,"        PPD+" D WP("TUBT","POSPY")
 W ?1,"          w/ Treatment Given" D WP("TUBT","MED")
 W ?1,"        PPD-" D WP("TUBT","NEGPY")
 W ?1,"        PPD Refused" D WP("TUBT","REF")
 W ?1,"        PPD Status Unknown" D WP("TUBT","UND")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"VACCINATION",!
 W ?1,"# w/ Pneumovax in last 5 years (or 2 ever)" D WP("PNEUMOT","TOTAL")
 W ?1,"# w/ Tetanus in past 10 years" D WP("TETT","TOTAL")
 W !
 W ?1,"EXAMS - Yearly",!
 W ?1,"Dilated Eye Exam" D WP("EYET","TOTAL")
 W ?1,"Dental Exam" D WP("DENTT","TOTAL")
 W ?1,"Pap Smear" D WP("PAPT","TOTAL")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"TREATMENT (past 6 months)",!
 W ?1,"ARV Therapy given" D WP("ARVT","TOTAL")
 W ?1,"    HAART" D WP("ARVT","HAART")
 W ?1,"    Mono Therapy" D WP("ARVT","MONO")
 W ?1,"    Other Combination" D WP("ARVT","OTHER")
 W !
 W ?1,"PCP Prophylaxis given if ANY CD4 =>50 and <200 in last six months",!
 D WP("PCPT","TOTAL")
 W ?1,"MAC Prophylaxis given if ANY CD4 <50 in last six months",!
 D WP("MACT","TOTAL")
 W !
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF D HDR
 W ?1,"RISK FACTORS",!
 W ?1,"Tobacco Use Screening" D WP("TOBT","SCREEN")
 W ?1,"    Current Tobacco User" D WP("TOBT","USER")
 W ?1,"    If Yes, Counseled" D WP("TOBT","ED")
 W ?1,"    Not a Current User" D WP("TOBT","NON")
 W ?1,"    Not Documented" D WP("TOBT","UNK")
 W !
 W ?1,"Substance Abuse Screening" D WP("SUBST","TOTAL")
 W ?1,"    Current User" D WP("SUBST","CURRENT")
 ;"IV" and "NOT" cannot be calculated so they are displayed as "Unavailable".
 W ?1,"         I/V - Yes"
 W ?49,"Unavailable",! ;D WP("SUBST","IV") if IV can be calculated
 W "    Not a Current User" ;If D WP is reinstated add ?1, before the quote
 W ?49,"Unavailable",! ;D WP("SUBST","NOT") if NOT can be calculated
 W "    Not Documented" D WP("SUBST","UNK") ;If D WP is reinstated add ?1, before the quote
 W !
 ;PRXM/HC/BHS - 04/19/2006 - Added report logic description as last page(s)
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 W @IOF D HDR ;Force a form feed
 ;I IOST["C-" W @IOF D HDR
 W !
 D HDR^BKMIMRP1("HMS Quality of Care Report","")
 W !
 W ?1,"This report includes all patients who meet the following criteria:"
 W !!
 W ?5,"* Register Status = Active"
 W !
 W ?5,"* Current Diagnosis =",$S($P(DENPOP,":",2)=" All":" HIV and AIDS",1:$P(DENPOP,":",2))
 W !
 W ?5,"* First (oldest) Diagnosis Date is at least 182 days (6 months) prior to"
 W !
 W ?5,"  Report End Date"
 W !!
 ;PRXM/HC/BHS - 06/28/2006 - Force page break following report logic removed per IHS
 ;PRXM/HC/BHS - 06/13/2006 - Force page break following report logic
 ;I IOST["C-",$$PAUSE^BKMIXX3 Q
 ;W @IOF D HDR
 W ?1,"Total Patients Reviewed: "_TOTPTS,!!
 W ?1,"The following patients are included in this report: "
 W !!
 ;PRXM/HC/BHS - 06/13/2006 - Patient list column header
 ;PRXM/HC/BHS - 06/28/2006 - Check for sufficient space before displaying patient list header
 S BKMRTN=""
 I IOSL-$Y<6 D  Q:BKMRTN="^"
 . I IOST["C-",$$PAUSE^BKMIXX3 S BKMRTN="^" Q
 . W @IOF D HDR
 D PATHDR
 ;PRXM/HC/BHS - 05/10/2006 - Force page break before patient list
 ;I IOST["C-" W @IOF D HDR,PATHDR
 ;W @IOF D HDR,PATHDR
 ; Loop through patient list
 S BKMDFN=""
 F  S BKMDFN=$O(^TMP("BKMVQCR",$J,"HIVCHK",BKMDFN)) Q:BKMDFN=""!('+BKMDFN)  D
 . S BKMPATN=$$GET1^DIQ(2,BKMDFN,".01","E")
 . I BKMPATN="" S BKMPATN="{MISSING NAME}"
 . S ^TMP("BKMVQCR",$J,"HIVCHK","SORTED BY NAME",BKMPATN,BKMDFN)=""
 ; Loop through patient list sorted by name
 S BKMPATN="",BKMRTN=""
 F  S BKMPATN=$O(^TMP("BKMVQCR",$J,"HIVCHK","SORTED BY NAME",BKMPATN)) Q:BKMPATN=""  D  Q:BKMRTN="^"
 . S BKMDFN="",BKMRTN=""
 . F  S BKMDFN=$O(^TMP("BKMVQCR",$J,"HIVCHK","SORTED BY NAME",BKMPATN,BKMDFN)) Q:BKMDFN=""!('+BKMDFN)  D  Q:BKMRTN="^"
 . . I IOSL-$Y<6 D  Q:BKMRTN="^"
 . . . I IOST["C-",$$PAUSE^BKMIXX3 S BKMRTN="^" Q
 . . . W @IOF D HDR,PATHDR
 . . D PAT(BKMPATN,BKMDFN)
 W !
 D HDR^BKMIMRP1(CONFE,"")
 W !
PRINT1 ;
 I IOST["C-",$$PAUSE^BKMIXX3 Q
 I IOST["C-" W @IOF
 Q
WC(TYPE) ;
 N VAL
 I TYPE="" Q
 S VAL=+$G(^TMP("BKMVQCR",$J,TYPE))
 W ?47,$J(VAL,3)
 W ?55,$J(VAL/TOTPTS*100,5,1),"%",!
 Q
WP(CAT,TYPE) ;
 N VAL,PERC
 I TYPE="" Q
 S VAL=+$G(^TMP("BKMVQCR",$J,CAT,TYPE,"CNT"))
 W ?47,$J(VAL,3)
 S PERC=$G(^TMP("BKMVQCR",$J,CAT,TYPE,"PERC"))
 W ?55,$J(PERC,5,1),"%",!
 Q
PAT(BKMPATN,BKMDFN) ;
 N BKMIEN,BKMREG
 Q:$G(BKMPATN)=""!($G(BKMDFN)="")
 ;W ?1,$$GET1^DIQ(2,BKMDFN,".01","E")
 W ?1,$G(BKMPATN)
 W ?32,$$HRN^BKMVA1(BKMDFN)
 W ?39,$$GET1^DIQ(2,BKMDFN,".033","E")
 W ?43,$$GET1^DIQ(2,BKMDFN,".02","I")
 S BKMIEN=$$BKMIEN^BKMIXX3(BKMDFN)
 Q:BKMIEN=""
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 Q:BKMREG=""
 W ?47,$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","2.3","E")
 W ?52,$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","5","I"),"5Z")
 W ?64,$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",","5.5","I"),"5Z")
 W !
 Q
PATHDR ;
 N BKMHDR
 S $P(BKMHDR,"-",79)=""
 W ?1,"Patient Name"
 W ?32,"HRN"
 W ?39,"Age"
 W ?43,"Sex"
 W ?47,"Dx"
 W ?52,"Init HIV Dx"
 W ?64,"Init AIDS Dx"
 W !
 W ?1,$E(BKMHDR,1,30)
 W ?32,$E(BKMHDR,1,6)
 W ?39,$E(BKMHDR,1,3)
 W ?43,$E(BKMHDR,1,3)
 W ?47,$E(BKMHDR,1,4)
 W ?52,$E(BKMHDR,1,11)
 W ?64,$E(BKMHDR,1,12)
 W !
 ;D HDR3^BKMIMRP1
 Q
HDR ;
 S HDRST=$$PAD^BKMIXX4($$GET1^DIQ(200,DUZ_",","1","E"),">"," ",35)_$$PAD^BKMIXX4(EXDT,">"," ",35)_"Page: "_PAGE
 D HDR^BKMIMRP1(HDRST,"")
 D HDR^BKMIMRP1(INST,"")
 D HDR^BKMIMRP1("*** HMS CUMULATIVE AUDIT REPORT -- HIV QUALITY OF CARE ***","")
 D HDR^BKMIMRP1("Denominator Population - "_DENPOP,"")
 D HDR^BKMIMRP1("Period Ending: "_HEEXT,"")
 I IOST'["C-",PAGE=1 D DISP
 E  D HDR^BKMIMRP1(CONFS,"")
 D HDR3^BKMIMRP1
 S PAGE=PAGE+1
 Q
 ;
DISP ;
 W !!,?30,"***WARNING***",!
 W ?21,"***RESTRICTED INFORMATION***",!
 W ?1,"* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *",!
 W ?1,"* All information in this system is protected by the Privacy Act of     *",!
 W ?1,"* 1974. If you elect to proceed, you will be required to prove you have *",!
 W ?1,"* a need to know. Access of data in this system is tracked, and your    *",!
 W ?1,"* station Security Officer may contact you for your justification.      *",!
 W ?1,"* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *",!
 Q
