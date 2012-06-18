BKMSUPP ;PRXM/HC/WOM - HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:02 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
ONE(YY) ; EP - Entry point from Health Summary
 N NOW,X,Y,HLDBKM,AUPNPAT,AUDT,AUDATA,PTNAME,HRECNO,PAGES,BKMDT,QUIT
 S (Y,HLDBKM)=""
 K LOCAL,DIC,ICD9S
 D NOW^%DTC S NOW=X
 S X=$O(^BKM(90451,"B",YY,"")) Q:X=""  S Y=X_"^"_YY,HLDBKM=Y,^TMP("BKMSUPP",$J,"IENS")=Y
 S PAGES=1
 S QUIT="" ; Used to identify if user wants to quit display if run to the screen
 I +Y'<0 D
 .W @IOF
 .I IOST["C-" D CLEAR^VALM1
 .D GET^BKMVSRP1($P(Y,U)),PRINT(.PAGES)
 W !!,$$CONF^BKMSUPP1(1) ;Write end confidential message
 I IOST["C-" S QUIT=$$PAUSE^BKMSUPP3()
 D ^%ZISC
 K LOCAL,ICD9S,^TMP("BKMSUPP",$J)
 G XIT
FRONT ; EP - Entry point for individual print
 N DFN
FR0 N X,BKMIEN,OPT,HS,ZT,BOTH
 K ^TMP("BKMSUPP",$J),ASKOPT
 ; Identify which reports to print
 ; OPT=1 - supplement only
 ; OPT=2 - summary only
 ; OPT=3 - summary and supplement
 ; PRXM/HC/BHS - 05/10/2006 - Replaced call to OPT with OPTA for partial matching on code and desc
 ;S OPT=$$OPT()
 S OPT=$$OPTA()
 I 'OPT Q
 I $G(ASKPAT) G FR2 ;Do not prompt for patient if called from within Review/Edit Pt
PAT ; Select patient from registry
 W @IOF S DFN="" D RLK^BKMPLKP() Q:$G(DFN)=""
 S ASKOPT=1 G FR2
FR1 ;EP - Called by SUPP^BKMSUPP (HS) and REPORTS^BKMVA1 (REP) from Review/Edit Pt
 N ASKPAT,ASKOPT
 S (ASKOPT,ASKPAT)=1
FR2 ;EP - Called by REPORTS^BKMVA1
 S X=$O(^BKM(90451,"B",DFN,"")) Q:X=""
 S BKMIEN=X_U_DFN,^TMP("BKMSUPP",$J,"IENS")=BKMIEN
 I OPT'=1 S BOTH=(OPT=3) D HS^BKMIHSM(DFN,,BOTH) K ^TMP("BKMSUPP",$J,"IENS") W @IOF G FR0:$G(ASKPAT),FRONT:$G(ASKOPT) Q  ;both reports
 ;I OPT'=1 S BOTH=(OPT=3) D HS^BKMIHSM(DFN,,BOTH) K ^TMP("BKMSUPP",$J,"IENS",Y) W @IOF G FR0:$G(ASKPAT),FRONT:$G(ASKOPT) Q  ;both reports
 K %ZIS,IOP,IOC,ZTIO S %ZIS="MQ" D ^%ZIS Q:POP
 I $D(IO("Q")) D  Q
 .S ZTRTN="ONEY^BKMSUPP("_DFN_")",ZT=""
 .S ZTSAVE("BKMIEN")="",ZTSAVE("BKMVSUPP*")="",ZTSAVE("^TMP(""BKMSUPP"",$J,")=""
 .K IO("Q") D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED" H 2
 .D ^%ZISC
 D ONEY(DFN)
 W @IOF K Y
 G FR0:$G(ASKPAT),FRONT:$G(ASKOPT)
 Q
 ;
SUPP(DFN) ;EP - Called from Review/Edit Patient HMS Record Data, HS action
 N OPT
 ; PRXM/HC/BHS - 05/10/2006 - Replaced call to OPT with OPTA for partial matching on code and desc
 ;D CLEAR^VALM1 S OPT=$$OPT()
 D CLEAR^VALM1 S OPT=$$OPTA()
 I 'OPT Q
 D FR1
 Q
ONEY(DFN) ; Get data and report for one patient
 N NOW,X,DA,Y,HLDBKM,AUPNPAT,AUDT,AUDATA,PTNAME,HRECNO,PAGES,BKMDT,QUIT
 S X=$O(^BKM(90451,"B",DFN,"")) Q:X=""
 S (DA,Y)=X,HLDBKM=X_U_DFN
 K LOCAL,DIC,ICD9S
 D NOW^%DTC S NOW=X
 S PAGES=1
 U IO
 S QUIT="" ; Used to identify if user wants to quit display if run to the screen
 I +Y'<0 D GET^BKMVSRP1($P(HLDBKM,U)),PRINT(.PAGES)
 W !!?1,$E($$CONF^BKMSUPP1(1),1,78) ;Write end confidential message
 I IOST["C-" S QUIT=$$PAUSE^BKMSUPP3()
 D ^%ZISC
 K LOCAL,ICD9S,^TMP("BKMSUPP",$J)
 Q
PRINT(PAGE) ;
 ; PAGE is assumed to be >0
 ;
 ;
 N A,DPTIEN,BKMIEN,XNOW,CLCL,RDIAG,GETSIENS,BKMREG,LSTDXDT,A1,I,J,K,L,BKMDT,TEMP,MAXCT,BKM,BKMT
 N BMI,%H,DR,STCAT,STIEN,AGE,GLOBAL,CPRDT,CNT,CDDT,Y,CDTST,TYPE,BKMHAART,HIVDXDT,TMPDT
 S MAXCT=IOSL-4
 ;
 D NOW^%DTC S XNOW=$$FMTE^XLFDT(X,"5Z")
 S DPTIEN=$P(^TMP("BKMSUPP",$J,"IENS"),U,2),BKMIEN=$P(^TMP("BKMSUPP",$J,"IENS"),U)
 S GETSIENS=BKMIEN,DFN=DPTIEN
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 ;
 D HEADER^BKMSUPP1(.PAGE,XNOW)
 ;
 ; Array LOCAL is set up with the following subscripts:
 ;LOCAL(2,DPTIEN,.01,"I")=name
 ;LOCAL(2,DPTIEN,.01,"E")=name
 ;LOCAL(2,DPTIEN,.02,"I")=sex...e.g. F for female
 ;LOCAL(2,DPTIEN,.03,"I")=date of birth in internal format
 ;LOCAL(9000001,BKMIEN,1102.98)=age
 ;LOCAL(9000001,BKMIEN,1118)=community
 ;LOCAL(90451,BKMIEN,.02,"E")=name
 ;LOCAL(90451,BKMIEN,.02,"I")=DPTIEN
 ;LOCAL(90451.01,"1,"_BKMIEN_",",.5,"E")=STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"E")=DIAGNOSIS CATEGORY
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.1,"E")=STATE HIV CONFIRMATION STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.2,"E")=STATE HIV CONFIRMATION DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.51,"E")=STATE AIDS ACKNOWLEDGEMENT STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.52,"E")=STATE AIDS ACKNOWLEDGEMENT DATE
 ;LOCAL("HRECNO")=HEALTH RECORD NUMBER
 ;LOCAL(90451.01,"1,"_BKMIEN_",",.015,"E")=FACILITY(WHERE FOLLOWS)
 ;
 W ?1,"Patient's Name: ",$E($G(LOCAL(2,DPTIEN,.01,"E")),1,30),?46,"HRN: ",$E($G(LOCAL("HRECNO")),1,8),!
 W ?1,"Sex: ",$G(LOCAL(2,DPTIEN,.02,"I")),?19,"DOB: " S Y=LOCAL(2,DPTIEN,.03,"I") W $$FMTE^XLFDT(Y,"5Z")
 S AGE=$E($P($G(LOCAL(9000001,DPTIEN,1102.98))," "),1,3)
 W ?46,"Age: ",AGE,$E($P($G(LOCAL(9000001,DPTIEN,1102.98))," ",2),1),!
 ;S AGE=$$UP^XLFSTR($$AGE^BKMIMRP1(DFN))
 ;W ?46,"Age: ",AGE W:AGE?1.N "Y" W !
 S RDIAG=$$GET1^DIQ(9000001,DFN,.14,"E")
 W ?1,"Designated Primary Care Provider: ",RDIAG,!
 S RDIAG=$$HTWT^BKMSUPP2(DFN)
 W ?1,"Last Height: ",$P(RDIAG,U),"  ",$P(RDIAG,U,2),?30," Last Weight: ",$P(RDIAG,U,3),"  ",$P(RDIAG,U,4),!
 ; Determine BMI
 S BMI=$$BMI(DFN,$P(RDIAG,U),$$DT($P(RDIAG,U,2)),$P(RDIAG,U,3),$$DT($P(RDIAG,U,4)),AGE)
 ; if BMI cannot be set display the following
 I BMI="" S BMI="BMI cannot be calculated with current data."
 W ?1,"BMI: ",BMI,!!
 ; Get Register Diagnosis, Clinical Classification, Initial HIV diagnosis date,Initial AIDS diagnosis date
 K TEMP D GETS^DIQ(90451.01,1_","_+BKMIEN_",",".02;2;2.5;3;3.5;5;5.5","IE","TEMP")
 W ?1,"Register Diagnosis: ",$G(LOCAL(90451.01,1_","_+BKMIEN_",",2.3,"E"))
 ;Retrieve diagnosis date from diag cat history
 S LSTDXDT=$O(^BKM(90451,BKMIEN,1,BKMREG,10,"B",""),-1)
 I LSTDXDT W "  ",$$FMTE^XLFDT(LSTDXDT\1,"5Z")
 ;I $G(TEMP(90451.01,1_","_+BKMIEN_",",2.5,"I")) W "  ",$P($$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",2.5,"I"),"5Z"),"@")
 W !?1,"HIV Clinical Classification (A1-C3): ",$G(TEMP(90451.01,1_","_+BKMIEN_",",3,"E"))
 I $G(TEMP(90451.01,1_","_+BKMIEN_",",3.5,"I")) W "  ",$P($$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",3.5,"I"),"5Z"),"@")
 W !?1,"Diagnosis Comments: ",$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",",2.7,"I")
 W !?1,"Initial HIV Diagnosis: "
 S HIVDXDT=$G(TEMP(90451.01,1_","_+BKMIEN_",",5,"I"))
 ;I HIVDXDT]"" W $$FMTE^XLFDT(HIVDXDT,"5Z")
 I HIVDXDT]"" S TMPDT=$$FMTE^XLFDT(HIVDXDT,"5Z") S:$P(TMPDT,"/",2)="00" TMPDT=$P(TMPDT,"/",1)_"/"_$P(TMPDT,"/",3) W TMPDT
 ;The default value for this field, if not populated, is yet to be worked out but will be displayed as value,"[**]",!
 W !?1,"Initial AIDS Diagnosis: "
 ;I $G(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I")) W $$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I"),"5Z")
 I $G(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I")) S TMPDT=$$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I"),"5Z") S:$P(TMPDT,"/",2)="00" TMPDT=$P(TMPDT,"/",1)_"/"_$P(TMPDT,"/",3) W TMPDT
 ;The default value for this field, if not populated, is yet to be worked out but will be displayed as value,"[**]",!
 K TEMP
OI ;
 W !!?1,"Opportunistic infections and AIDS Defining Illnesses Ever",!
 ; Modified code to use new structure for ICD9S array from BKMVC6.
 N DIC,DIQ,DR,DA,STDT,ICD9S
 D GETALL^BKMVC6(DFN)   ; Returns the Opportunistic infections in local array ICD9S(ACTDATE,INDEX,"ICD9")=ICD
 ;Only look at opportunistic infections since initial HIV diagnosis date.
 ;If there is none look at last 6 months.
 ;*** Removed date check at request of IHS ***
 ;S STDT=$S(HIVDXDT]"":HIVDXDT,1:$$FMADD^XLFDT(DT,-183)),STDT=9999999-STDT
 I $D(ICD9S) D  Q:QUIT
 .S A1="",L=0
 .F  S A1=$O(ICD9S(A1)) Q:A1=""  D  Q:QUIT  ;!(A1>STDT)  D  Q:QUIT
 ..S BKMDT=$P($$FMTE^XLFDT(9999999-A1,"5Z"),"@")
 ..S K=""
 ..F  S K=$O(ICD9S(A1,K)) Q:K=""  D  Q:QUIT
 ...I 'L D  Q:QUIT
 ....I $Y>(MAXCT-2) S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 ....W ?5,"[Date]",?20,"[ICD9]",?28,"[Description]",?55,"[Provider Narrative]",!
 ...I $T(ICDDX^ICDCODE)'="" W ?5,BKMDT,?20,$$ICD9^BKMUL3(K,9999999-A1,2) ; csv
 ...I $T(ICDDX^ICDCODE)="" W ?5,BKMDT,?20,$$GET1^DIQ(80,K,.01,"E")
 ...I $T(ICDD^ICDCODE)'="" W ?28,$E($$ICDD^BKMUL3("ICD9",K,9999999-A1),1,25) ; csv
 ...I $T(ICDD^ICDCODE)="" W ?28,$E($$GET1^DIQ(80,K,10,"E"),1,25)
 ...W ?55,$G(ICD9S(A1,K)),!
 ...S L=1
 ...I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 ;Determine State Reporting Categories and related data
 ;PRXM/HC/ALA Modified 9/22/2005
 D GETS^DIQ(90451.01,"1,"_+BKMIEN_",","4;4.1;4.2;4.3;4.5;4.51;4.52;4.53","EI","STCAT")
 W !?1,"State Notification(s): "
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.3","E"))'="" D
 . W ?23,"HIV  ",$G(STCAT(90451.01,"1,"_+BKMIEN_",","4.3","E"))
 . I $G(STCAT(90451.01,"1,"_+BKMIEN_",","4","I")) W "  ",$$FMTE^XLFDT(STCAT(90451.01,"1,"_+BKMIEN_",","4","I"),"5Z")
 . W !
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.53","E"))'="" D  Q:QUIT
 . W ?23,"AIDS  ",$G(STCAT(90451.01,"1,"_+BKMIEN_",","4.53","E"))
 . I $G(STCAT(90451.01,"1,"_+BKMIEN_",","4.5","I")) W "  ",$$FMTE^XLFDT(STCAT(90451.01,"1,"_+BKMIEN_",","4.5","I"),"5Z")
 . W ! I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.3","E"))="",$G(STCAT("90451.01","1,"_+BKMIEN_",","4.53","E"))="" W !
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 W ?1,"Partner Notification: "
 S BKM=$$GET1^DIQ(90451.01,"1,"_+BKMIEN_",",15,"E") W BKM,!
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 ;
 ;Begin LAB RESULTS
 ;Variable QUIT is initialized in ONEY/ONE and reset based on user's response to press enter to continue
 ;Variable MAXCT is set by PRINT to IOSL-4
 I $Y>(MAXCT-2) S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 W !?1,"RECENT LABORATORY RESULTS: ",!,!
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 D CD4^BKMSUPP1(DFN) Q:QUIT
 D VIRAL^BKMSUPP1(DFN) Q:QUIT
 D RPR^BKMSUPP1(DFN) Q:QUIT
 D PAP^BKMSUPP1(DFN) Q:QUIT
 D CHL^BKMSUPP1(DFN) Q:QUIT
 D GON^BKMSUPP1(DFN) Q:QUIT
 D HEP^BKMSUPP4(DFN) Q:QUIT
 D HEPB^BKMSUPP4(DFN) Q:QUIT
 D HEPC^BKMSUPP4(DFN) Q:QUIT
 D CMV^BKMSUPP1(DFN) Q:QUIT
 D TOX^BKMSUPP1(DFN) Q:QUIT
 D COC^BKMSUPP1(DFN) Q:QUIT
 D PPD^BKMSUPP1(DFN) Q:QUIT
 D PHENO^BKMSUPP1(DFN) Q:QUIT
 D GENO^BKMSUPP1(DFN) Q:QUIT
 ;Immunizations
 D IMM^BKMSUPP2(DFN) Q:QUIT
 ;Medications
 D DRUGS^BKMSUPP3(DFN) Q:QUIT
 ;Screenings
 D SCREENS^BKMSUPP2(DFN) Q:QUIT
 ;Eye exam
 D RET^BKMSUPP3(DFN) Q:QUIT
 ;Print Dental exam date
 D DEN^BKMSUPP3(DFN) Q:QUIT
 ;Print Mammogram date
 D MAM^BKMSUPP3(DFN) Q:QUIT
 ;Print HIV Education
 D ED^BKMSUPP2(DFN) Q:QUIT
 ;Print Reminders
 D REM^BKMSUPP5(DFN) Q:QUIT
 ;Print Flow Sheet
 D FLOW^BKMSUPP5(DFN)
 Q
 ;
BMI(PT,HT,HTD,WT,WTD,AGE) ;Calculate BMI
 ;
 ;PT = patient's DFN
 ;HT = patient's height
 ;HTD = date patient's height was recorded
 ;WT = patient's weight
 ;WTD = date patient's weight was recorded
 ;AGE = patient's age (taken from 9000001,1102.98)
 ;
 N BMI,WDIFF,HDIFF
 I PT=""!(HT="")!(WT="")!(AGE="") Q ""
 ; Patients younger than 19 must have both measurements on the same day
 I AGE<19,HTD'=WTD Q ""
 S WDIFF=$$FMDIFF^XLFDT(DT,WTD,1)
 S HDIFF=$$FMDIFF^XLFDT(DT,HTD,1)
 ; Patients older than 50 must have both measurements in the last two years
 I AGE>50,WDIFF>(2*365)!(HDIFF>(2*365)) Q ""
 ; Patients between 19 and 50 must have both measurements in the last five years
 I AGE<50,AGE>18,WDIFF>(5*365)!(HDIFF>(5*365)) Q ""
 S BMI=$$BMI^APCHS2A3(PT,WT,DT)
 Q $$STRIP^XLFSTR($P(BMI,U,1)," ")
 ;S WT=WT*.45359,HT=HT*.0254 ;Convert to metric
 ;Q $J(WT/(HT*HT),0,1)
 ;
OPT() ;Select reports to print
 N DIR,X,Y,DTOUT,DUOUT
 ;
 S DIR(0)="S^SUPP:HMS Supplement Only;HS:Health Summary Only;BOTH:Both Summary and Supplement"
 S DIR("A")="Select the report option"
 ;S DIR("B")="BOTH"
 S DIR("?")=" "
 S DIR("?",1)="  Enter SUPP to select the HMS Supplement Report"
 S DIR("?",2)="  Enter HS to select the Health Summary Report"
 S DIR("?",3)="  Enter BOTH to select both the Health Summary and the HMS Supplement reports."
 S DIR("?",4)=" "
 S DIR("?",5)="  The HMS Supplement will display after the"
 S DIR("?",6)="  Health Summary has completed."
 D ^DIR K DIR
 I $D(DUOUT)!$D(DTOUT) Q ""
 S Y=$S(Y="SUPP":1,Y="HS":2,1:3)
 I Y'=2 D
 .NEW Y
 .; Check taxonomies
 .NEW DFLAG
 .S DFLAG=1 D EN^BKMVC1
 Q Y
 ;
OPTA() ;Select reports to print
 N DIR,X,Y,DTOUT,DUOUT,BKMCHK
 ;
OPTA1 ;
 S BKMCHK=0
 S DIR(0)="FO"
 K DIR("A")
 S DIR("A")="Select the report option"
 S DIR("A",1)=" "
 S DIR("A",2)="     Select one of the following:"
 S DIR("A",3)=" "
 S DIR("A",4)="          SUPP       HMS Supplement Only"
 S DIR("A",5)="          HS         Health Summary Only"
 S DIR("A",6)="          BOTH       Both Summary and Supplement"
 S DIR("A",7)=" "
 ;S DIR("B")="BOTH"
 S DIR("?")=" "
 S DIR("?",1)="  Enter SUPP to select the HMS Supplement Report"
 S DIR("?",2)="  Enter HS to select the Health Summary Report"
 S DIR("?",3)="  Enter BOTH to select both the Health Summary and the HMS Supplement reports."
 S DIR("?",4)=" "
 S DIR("?",5)="  The HMS Supplement will display after the"
 S DIR("?",6)="  Health Summary has completed."
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!(Y="") Q ""
 S Y=$$UP^XLFSTR(Y)
 ; Special case where user enters 'H' or 'h' redisplay as ambiguous
 I Y="H" D  I Y="" G OPTA1
 .S DIR(0)="SO^1:HMS Supplement Only;2:Health Summary Only"
 .K DIR("A")
 .S DIR("A")="Select the report option"
 .K DIR("B"),DIR("?")
 .S DIR("?")=" "
 .S DIR("?",1)="  Enter 1 to select the HMS Supplement Report"
 .S DIR("?",2)="  Enter 2 to select the Health Summary Report"
 .D ^DIR K DIR
 .I $D(DUOUT)!$D(DTOUT)!(Y="") S Y="" Q
 .S Y=$S(Y=1:"SUPP",1:"HS"),BKMCHK=1
 .;
 I '$F("^SUPP^HS^BOTH^",U_Y_U) D
 .I $L(Y)<4,$E("SUPP",1,$L(Y))=Y S Y="SUPP" Q
 .I $L(Y)<4,$E("HS",1,$L(Y))=Y S Y="HS" Q
 .I $L(Y)<4,$E("BOTH",1,$L(Y))=Y S Y="BOTH" Q
 .I $L(Y)>0,$E("HMS SUPPLEMENT ONLY",1,$L(Y))=Y S Y="SUPP" Q
 .I $L(Y)>0,$E("HEALTH SUMMARY ONLY",1,$L(Y))=Y S Y="HS" Q
 .I $L(Y)>0,$E("BOTH SUMMARY AND SUPPLEMENT",1,$L(Y))=Y S Y="BOTH" Q
 I '$F("^SUPP^HS^BOTH^",U_Y_U) W !!?2,"Please enter a code or description from the list.",!! G OPTA1
 I 'BKMCHK W " ",$S(Y="SUPP":"HMS Supplement Only",Y="HS":"Health Summary Only",1:"Both Summary and Supplement")
 S Y=$S(Y="SUPP":1,Y="HS":2,1:3)
 I Y'=2 D
 .NEW Y
 .; Check taxonomies
 .NEW DFLAG
 .S DFLAG=1 D EN^BKMVC1
 Q Y
 ;
DT(FDT)  ;
 N %DT,X,Y
 S %DT="TS",X=FDT D ^%DT
 Q Y
 ;
QUE ;Queue report
 S ZTRTN="ONEY^BKMSUPP("_DFN_")",ZT=""
 S ZTSAVE("BKMIEN")="",ZTSAVE("BKMVSUPP*")="",ZTSAVE("^TMP(""BKMSUPP"",$J,")=""
 K IO("Q") D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED" H 2
 Q
 ;
XIT ;Exit from routine
 Q
