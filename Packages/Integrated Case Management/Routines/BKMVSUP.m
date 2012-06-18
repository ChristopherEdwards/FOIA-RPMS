BKMVSUP ;PRXM/HC/WOM - HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:02 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
EP(DFN) ;EP - Called by Health Summary Supplement
 ; Value for APCHSPAT is passed to identify the patient (DFN)
 ; IO variables will already have been set
 N X,BKMIEN,DIR,DIRUT
 S DFN=$G(DFN)
 Q:DFN=""
 K ^TMP("BKMSUPP",$J),^TMP("BKMVSUP",$J)
 S X=$O(^BKM(90451,"B",DFN,"")) ;Q:X=""
 I X="" D:'$D(ZTQUEUED)  Q
 . W !!?5,"HMS Patient Care Summary is not available.  This patient does not"
 . W !?5,"have an active HIV diagnostic tag and/or is not in the HMS Register.",!
 . ;W !!?5,"HMS Patient Care Summary cannot be generated as selected patient"
 . ;W !?5,"is not in the HMS Register.",!
 ;
 ; Comment out the security check in the event that IHS reconsiders
 ; I '$$PRIV(DUZ) D   Q
 ; . I $E(IOST)="C" D
 ; .. W !!,"Sorry, you are currently not an authorized HMS user."
 ; .. W !,"Please see your Security Administrator for access.",! H 2
 ;
 S BKMIEN=X_U_DFN,^TMP("BKMSUPP",$J,"IENS")=BKMIEN
 I $E(IOST)="C",IO=IO(0) D  Q:$G(APCHSQIT)
 . W !!
 . S DIR("A")="HMS PATIENT CARE SUMMARY WILL NOW BE DISPLAYED (^ TO EXIT, RETURN TO CONTINUE)"
 . S DIR(0)="E" D ^DIR
 . I $D(DIRUT) S APCHSQIT=1 Q
 N LINE,PGCNT,LNCNT
 S (PGCNT,LNCNT)=1
 D EP2(DFN)
 D PRINT
 W @IOF K Y
 K ^TMP("BKMSUPP",$J),^TMP("BKMVSUP",$J)
 Q
 ;
EP2(DFN) ; Get data and report for one patient
 ; Store lines to print in ^TMP("BKMVSUP",$J)
 N NOW,X,DA,Y,HLDBKM,AUPNPAT,AUDT,AUDATA,PTNAME,HRECNO,PAGES,BKMDT
 S X=$O(^BKM(90451,"B",DFN,""))
 I X="" D:'$D(ZTQUEUED)  Q
 . W !!?5,"HMS Patient Care Summary is not available.  This patient does not"
 . W !?5,"have an active HIV diagnostic tag and/or is not in the HMS Register.",!
 . ;W !!?5,"HMS Patient Care Summary cannot be generated as selected patient"
 . ;W !?5,"is not in the HMS Register.",!
 S (DA,Y)=X,HLDBKM=X_U_DFN
 K LOCAL,DIC,ICD9S
 D NOW^%DTC S NOW=X
 I +Y'<0 D GET^BKMVSRP1($P(HLDBKM,U)),GETDATA
 K LOCAL,ICD9S,^TMP("BKMSUPP",$J)
 Q
 ;
PRINT ; Print report from ^TMP("BKMVSUP",$J)
 N PAGE,CNT,XNOW,QUIT
 U IO
 S PAGE="",CNT=""
 S QUIT="" ; Used to identify if user wants to quit display if run to the screen
 D NOW^%DTC S XNOW=$$FMTE^XLFDT(X,"5Z")
 F  S PAGE=$O(^TMP("BKMVSUP",$J,PAGE)) Q:'PAGE  D  Q:QUIT
 . D HEADER^BKMVSUP6(PAGE,XNOW)
 . F  S CNT=$O(^TMP("BKMVSUP",$J,PAGE,CNT)) D  Q:'CNT!QUIT
 .. I 'CNT S QUIT=$$PAUSE^BKMVSUP3() Q
 .. W !,^TMP("BKMVSUP",$J,PAGE,CNT)
 I QUIT S APCHSQIT=1
 Q
 ;
GETDATA ; Load data in ^TMP
 ;
 N A,DPTIEN,BKMIEN,CLCL,RDIAG,GETSIENS,BKMREG,LSTDXDT,A1,I,J,K,L,BKMDT,TEMP,MAXCT,BKM,BKMT
 N BMI,%H,DR,STCAT,STIEN,AGE,GLOBAL,CPRDT,CNT,CDDT,Y,CDTST,TYPE,BKMHAART,HIVDXDT,TMPDT
 N HPRV,HCSM
 S MAXCT=IOSL-7
 ;
 S DPTIEN=$P(^TMP("BKMSUPP",$J,"IENS"),U,2),BKMIEN=$P(^TMP("BKMSUPP",$J,"IENS"),U)
 S GETSIENS=BKMIEN,DFN=DPTIEN
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 ;
 ; Array LOCAL is set up with the following subscripts:
 ; LOCAL(2,DPTIEN,.01,"I")=name
 ; LOCAL(2,DPTIEN,.01,"E")=name
 ; LOCAL(2,DPTIEN,.02,"I")=sex...e.g. F for female
 ; LOCAL(2,DPTIEN,.03,"I")=date of birth in internal format
 ; LOCAL(9000001,BKMIEN,1102.98)=age
 ; LOCAL(9000001,BKMIEN,1118)=community
 ; LOCAL(90451,BKMIEN,.02,"E")=name
 ; LOCAL(90451,BKMIEN,.02,"I")=DPTIEN
 ; LOCAL(90451.01,"1,"_BKMIEN_",",.5,"E")=STATUS
 ; LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"E")=DIAGNOSIS CATEGORY
 ; LOCAL(90451.01,"1,"_BKMIEN_",",4.1,"E")=STATE HIV CONFIRMATION STATUS
 ; LOCAL(90451.01,"1,"_BKMIEN_",",4.2,"E")=STATE HIV CONFIRMATION DATE
 ; LOCAL(90451.01,"1,"_BKMIEN_",",4.51,"E")=STATE AIDS ACKNOWLEDGEMENT STATUS
 ; LOCAL(90451.01,"1,"_BKMIEN_",",4.52,"E")=STATE AIDS ACKNOWLEDGEMENT DATE
 ; LOCAL("HRECNO")=HEALTH RECORD NUMBER
 ; LOCAL(90451.01,"1,"_BKMIEN_",",.015,"E")=FACILITY(WHERE FOLLOWS)
 ;
 S LINE=" Patient's Name: "_$E($G(LOCAL(2,DPTIEN,.01,"E")),1,30)
 S LINE=$$LINE(LINE,"HRN: ",46)_$E($G(LOCAL("HRECNO")),1,8)
 D UPD
 S LINE=" Sex: "_$G(LOCAL(2,DPTIEN,.02,"I"))
 S LINE=$$LINE(LINE,"DOB: ",19)
 S Y=LOCAL(2,DPTIEN,.03,"I") S LINE=LINE_$$FMTE^XLFDT(Y,"5Z")
 S AGE=$E($P($G(LOCAL(9000001,DPTIEN,1102.98))," "),1,3)
 S LINE=$$LINE(LINE,"Age: ",46)_AGE_$E($P($G(LOCAL(9000001,DPTIEN,1102.98))," ",2),1)
 D UPD
 S RDIAG=$P($$DPCP^BQIULPT(DFN),U,2)
 ;S RDIAG=$$GET1^DIQ(9000001,DFN,.14,"E")
 S LINE=" Designated Primary Care Provider: "_RDIAG
 D UPD
 K TEMP D GETS^DIQ(90451.01,1_","_+BKMIEN_",",".02;.5;.75;2;2.5;3;3.5;5;5.5;6;6.5","IE","TEMP")
 S LINE=" HIV Provider: "
 S HPRV=$$HPRV^BQIVFDEF(DFN) I HPRV S HPRV=$$GET1^DIQ(200,HPRV_",",.01,"E")
 S LINE=LINE_HPRV
 D UPD
 S LINE=" HIV Case Manager: "
 S HCSM=$$HCSM^BQIVFDEF(DFN) I HCSM S HCSM=$$GET1^DIQ(200,HCSM_",",.01,"E")
 S LINE=LINE_HCSM
 D UPD
 S RDIAG=$$HTWT^BKMVSUP2(DFN)
 S LINE=" Last Height: "_$P(RDIAG,U)_"  "_$P(RDIAG,U,2)
 N POS,LEN
 S POS=30,LEN=$L(LINE) I LEN>28 S POS=LEN+2
 S LINE=$$LINE(LINE," Last Weight: ",POS)_$P(RDIAG,U,3)_"  "_$P(RDIAG,U,4)
 D UPD
 ; Determine BMI
 S BMI=$$BMI(DFN,$P(RDIAG,U),$$DT($P(RDIAG,U,2)),$P(RDIAG,U,3),$$DT($P(RDIAG,U,4)),AGE)
 ; if BMI cannot be set display the following
 I BMI="" S BMI="BMI cannot be calculated with current data."
 S LINE=" BMI: "_BMI
 D UPD,BLANK(1)
 S LINE=" Register Diagnosis: "_$G(LOCAL(90451.01,1_","_+BKMIEN_",",2.3,"E"))
 ; Retrieve diagnosis date from diag cat history
 S LSTDXDT=$O(^BKM(90451,BKMIEN,1,BKMREG,10,"B",""),-1)
 I LSTDXDT S LINE=LINE_"  "_$$FMTE^XLFDT(LSTDXDT\1,"5Z")
 D UPD
 S LINE=" Register Status: "_$$LOWER^VALM1($G(TEMP(90451.01,1_","_+BKMIEN_",",.5,"E")))
 I $G(TEMP(90451.01,1_","_+BKMIEN_",",.75,"I")) S LINE=LINE_"  "_$P($$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",.75,"I"),"5Z"),"@")
 D UPD
 S LINE=" HIV/ AIDS Diagnostic Tag Status: "_$$HIVTAG^BKMVSUP6(DFN)
 D UPD
 S LINE=" HIV Clinical Classification (A1-C3): "_$G(TEMP(90451.01,1_","_+BKMIEN_",",3,"E"))
 I $G(TEMP(90451.01,1_","_+BKMIEN_",",3.5,"I")) S LINE=LINE_"  "_$P($$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",3.5,"I"),"5Z"),"@")
 D UPD
 S LINE=" Diagnosis Comments: "_$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",",2.7,"I")
 D UPD
 S LINE=" Initial HIV Diagnosis: "
 S HIVDXDT=$G(TEMP(90451.01,1_","_+BKMIEN_",",5,"I"))
 I HIVDXDT]"" S TMPDT=$$FMTE^XLFDT(HIVDXDT,"5Z") S:$P(TMPDT,"/",2)="00" TMPDT=$P(TMPDT,"/",1)_"/"_$P(TMPDT,"/",3) S LINE=LINE_TMPDT
 ; The default value for this field, if not populated, is yet to be worked out but will be displayed as value,"[**]",!
 D UPD
 S LINE=" Initial AIDS Diagnosis: "
 I $G(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I")) S TMPDT=$$FMTE^XLFDT(TEMP(90451.01,1_","_+BKMIEN_",",5.5,"I"),"5Z") S:$P(TMPDT,"/",2)="00" TMPDT=$P(TMPDT,"/",1)_"/"_$P(TMPDT,"/",3) S LINE=LINE_TMPDT
 ; The default value for this field, if not populated, is yet to be worked out but will be displayed as value,"[**]",!
 K TEMP
 ;
OI ; Opportunistic Infections
 D UPD,BLANK(1)
 S LINE=" Opportunistic infections and AIDS Defining Illnesses"
 D UPD
 ; Modified code to use new structure for ICD9S array from BKMVC6.
 N DIC,DIQ,DR,DA,STDT,ICD9S,ICDDSC,PNARR,ICD,NAR,DASH,ENTDT
 S DASH="",$P(DASH,"-",79)=""
 D GETALL^BKMVSUP6(DFN)   ; Returns the Opportunistic infections in local array ICD9S(ACTDATE,INDEX,"ICD9")=ICD
 ; Only look at opportunistic infections since initial HIV diagnosis date.
 ; If there is none look at last 6 months.
 ; *** Removed date check at request of IHS ***
 ; S STDT=$S(HIVDXDT]"":HIVDXDT,1:$$FMADD^XLFDT(DT,-183)),STDT=9999999-STDT
 I $D(ICD9S) D
 . S A1="",L=0
 . F  S A1=$O(ICD9S(A1)) Q:A1=""  D
 .. S BKMDT=$P($$FMTE^XLFDT(9999999-A1,"5Z"),"@")
 .. S K=""
 .. F  S K=$O(ICD9S(A1,K)) Q:K=""  D
 ... I 'L D
 .... I LNCNT>(MAXCT-2) D NEWPG
 .... S LINE="  Onset",LINE=$$LINE(LINE,"Entry",15),LINE=$$LINE(LINE,"ICD",27)
 .... S LINE=$$LINE(LINE,"ICD",35),LINE=$$LINE(LINE,"Provider",49)
 .... S LINE=$$LINE(LINE,"Status of",69) D UPD
 .... S LINE="   Date",LINE=$$LINE(LINE," Date",15),LINE=$$LINE(LINE,"Code",27)
 .... S LINE=$$LINE(LINE,"Narrative",35),LINE=$$LINE(LINE,"Narrative",49)
 .... S LINE=$$LINE(LINE," Problem",69) D UPD
 .... ;S LINE="     [Date]",LINE=$$LINE(LINE,"[ICD9]",20)
 .... ;S LINE=$$LINE(LINE,"[Description]",28),LINE=$$LINE(LINE,"[Status]",60)
 .... ;S LINE=$$LINE(LINE,"[Provider Narrative]",70)
 .... ;S LINE=$$LINE(LINE,"[Description]",28),LINE=$$LINE(LINE,"[Provider Narrative]",55)
 .... S LINE=DASH D UPD
 ... K ICD,NAR
 ... I $T(ICDD^ICDCODE)'="" S ICDDSC=$$ICDD^BKMUL3("ICD9",K,9999999-A1) ; csv
 ... I $T(ICDD^ICDCODE)="" S ICDDSC=$$GET1^DIQ(80,K,10,"E")
 ... D PARSE(ICDDSC,12,"ICD")
 ... S PNARR=$P($G(ICD9S(A1,K)),U,2) D PARSE(PNARR,18,"NAR")
 ... S LINE="  "_BKMDT,ENTDT=$P(ICD9S(A1,K),U,3)
 ... I ENTDT'="" S LINE=$$LINE(LINE,$$FMTE^XLFDT(ENTDT,"5Z"),15)
 ... I $T(ICDDX^ICDCODE)'="" S LINE=$$LINE(LINE,$$ICD9^BKMUL3(K,9999999-A1,2),27) ; csv
 ... I $T(ICDDX^ICDCODE)="" S LINE=$$LINE(LINE,$$GET1^DIQ(80,K,.01,"E"),27)
 ... ;S LINE=$$LINE(LINE,BKMDT,5),LINE=$$LINE(LINE,$$ICD9^BKMUL3(K,9999999-A1,2),20) ; csv
 ... S LINE=$$LINE(LINE,$G(ICD(1)),35),LINE=$$LINE(LINE,$G(NAR(1)),49)
 ... ;S LINE=$$LINE(LINE,$E($$ICDD^BKMUL3("ICD9",K,9999999-A1),1,25),28) ; csv
 ... ; S LINE=$$LINE(LINE,BKMDT,5),LINE=$$LINE(LINE,$$GET1^DIQ(80,K,.01,"E"),20)
 ... ; S LINE=$$LINE(LINE,$E($$GET1^DIQ(80,K,10,"E"),1,25),28)
 ... S LINE=$$LINE(LINE,$P($G(ICD9S(A1,K)),U),69)
 ... ;S LINE=$$LINE(LINE,$P($G(ICD9S(A1,K)),U),60),LINE=$$LINE(LINE,$P($G(ICD9S(A1,K)),U,2),70)
 ... ;S LINE=$$LINE(LINE,$$G(ICD9S(A1,K)),55)
 ... D UPD
 ... S L=1
 ... I LNCNT>MAXCT D NEWPG
 ... I $O(ICD(1))!$O(NAR(1)) D
 .... N IX
 .... F IX=2:1 Q:'$D(ICD(IX))&'$D(NAR(IX))  D
 ..... S LINE=""
 ..... I $D(ICD(IX)) S LINE=$$LINE(LINE,ICD(IX),35)
 ..... I $D(NAR(IX)) S LINE=$$LINE(LINE,NAR(IX),49)
 ..... D UPD
 ; PRXM/HC/ALA Modified 9/22/2005
 D GETS^DIQ(90451.01,"1,"_+BKMIEN_",","4;4.1;4.2;4.3;4.5;4.51;4.52;4.53","EI","STCAT")
 D UPD S LINE=" State Notification(s): "
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.3","E"))'="" D
 . S LINE=$$LINE(LINE,"HIV  ",23)_$G(STCAT(90451.01,"1,"_+BKMIEN_",","4.3","E"))
 . I $G(STCAT(90451.01,"1,"_+BKMIEN_",","4","I")) S LINE=LINE_"  "_$$FMTE^XLFDT(STCAT(90451.01,"1,"_+BKMIEN_",","4","I"),"5Z")
 . D UPD
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.53","E"))'="" D
 . S LINE=$$LINE(LINE,"AIDS  ",23)_$G(STCAT(90451.01,"1,"_+BKMIEN_",","4.53","E"))
 . I $G(STCAT(90451.01,"1,"_+BKMIEN_",","4.5","I")) S LINE=LINE_"  "_$$FMTE^XLFDT(STCAT(90451.01,"1,"_+BKMIEN_",","4.5","I"),"5Z")
 . D UPD
 . I LNCNT>MAXCT D NEWPG
 I $G(STCAT("90451.01","1,"_+BKMIEN_",","4.3","E"))="",$G(STCAT("90451.01","1,"_+BKMIEN_",","4.53","E"))="" D UPD ;W !
 I LNCNT>MAXCT D NEWPG
 S LINE=" Partner Notification: "
 S BKM=$$GET1^DIQ(90451.01,"1,"_+BKMIEN_",",15,"E") S LINE=LINE_BKM
 S BKM=$$FMTE^XLFDT($$GET1^DIQ(90451.01,"1,"_+BKMIEN_",",16,"I"),"5Z") S LINE=LINE_" "_BKM
 ;S BKM=$$GET1^DIQ(90451.01,"1,"_+BKMIEN_",",15,"E") S LINE=LINE_BKM
 D UPD
 I LNCNT>MAXCT D NEWPG
 ;
 ; Begin LAB RESULTS
 ; Variable QUIT is initialized in ONEY/ONE and reset based on user's response to press enter to continue
 ; Variable MAXCT is set by PRINT to IOSL-4
 I LNCNT>(MAXCT-2) D NEWPG
 D UPD S LINE=" RECENT LABORATORY RESULTS: "
 D UPD,BLANK(1) ;,!,!
 I LNCNT>MAXCT D NEWPG
 D CD4^BKMVSUP1(DFN)
 D VIRAL^BKMVSUP1(DFN)
 D LIPID^BKMVSUP6(DFN)
 D RPR^BKMVSUP1(DFN)
 D PAP^BKMVSUP1(DFN)
 D CHL^BKMVSUP1(DFN)
 D GON^BKMVSUP1(DFN)
 D HEP^BKMVSUP4(DFN)
 D HEPA^BKMVSUP4(DFN)
 D HEPB^BKMVSUP4(DFN)
 D HEPC^BKMVSUP4(DFN)
 D CMV^BKMVSUP1(DFN)
 D TOX^BKMVSUP1(DFN)
 D COC^BKMVSUP1(DFN)
 D PPD^BKMVSUP1(DFN)
 D PHENO^BKMVSUP1(DFN)
 D GENO^BKMVSUP1(DFN)
 ; Immunizations
 D IMM^BKMVSUP2(DFN)
 ; Medications
 D DRUGS^BKMVSUP3(DFN)
 ; Screenings
 D SCREENS^BKMVSUP2(DFN)
 ; Eye exam
 D RET^BKMVSUP3(DFN)
 ; Print Dental exam date
 D DEN^BKMVSUP3(DFN)
 ; Print Mammogram date
 D MAM^BKMVSUP3(DFN)
 ; Print HIV Education
 D ED^BKMVSUP5(DFN)
 ; Print Reminders
 D REM^BKMVSUP5(DFN)
 ; Print Flow Sheet
 D FLOW^BKMVSUP5(DFN)
 D BLANK(2)
 S LINE=" "_$E($$CONF^BKMVSUP6(1),1,78) D UPD ;Write end confidential message
 Q
 ;
BMI(PT,HT,HTD,WT,WTD,AGE) ; Calculate BMI
 ;
 ; PT = patient's DFN
 ; HT = patient's height
 ; HTD = date patient's height was recorded
 ; WT = patient's weight
 ; WTD = date patient's weight was recorded
 ; AGE = patient's age (taken from 9000001,1102.98)
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
 ; S WT=WT*.45359,HT=HT*.0254 ;Convert to metric
 ; Q $J(WT/(HT*HT),0,1)
 ;
LINE(TEXT,STR,POS) ; Set text to match HMS Supplement formatting
 I $L(TEXT)>POS Q TEXT_STR
 S $E(TEXT,POS)=STR
 Q TEXT
 ;
UPD ; Update global with line of text; update page and total line count
 I LNCNT>MAXCT D NEWPG
 S ^TMP("BKMVSUP",$J,PGCNT,LNCNT)=LINE,LINE="",LNCNT=LNCNT+1
 Q
 ;
NEWPG ; Print new page
 S PGCNT=PGCNT+1,LNCNT=1
 Q
 ;
BLANK(CNT) ; Add blank line(s) to output global
 S CNT=$G(CNT,1)
 F I=1:1:CNT S ^TMP("BKMVSUP",$J,PGCNT,LNCNT)="",LNCNT=LNCNT+1
 Q
 ;
DT(FDT)  ; Date conversion
 N %DT,X,Y
 S %DT="TS",X=FDT D ^%DT
 Q Y
 ;
PRIV(BKMDUZ) ; EP - Determine if user has access rights in HMS
 ; Extrinsic function - returns 1 (ability to access HMS data) or
 ;                              0 (no HMS security access established)
 ; Input:
 ;  BKMDUZ - DUZ, IEN for File 200
 ; Output: n/a
 ;
 N BKMHIV,BKMPRV,BKMPRIV
 S BKMPRIV=""
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I BKMHIV'="",$G(BKMDUZ)'="" D
 . S BKMPRV=$O(^BKM(90450,BKMHIV,11,"B",$G(BKMDUZ),0))
 . I BKMPRV'="" S BKMPRIV=$P(^BKM(90450,BKMHIV,11,BKMPRV,0),"^",2)
 S BKMPRIV=$S(BKMPRIV="":0,1:1)
 Q BKMPRIV
 ;
PARSE(STR,LEN,TARGET) ; Break up text by length and store in provided TARGET
 ;
 I $G(STR)="" Q
 I '$G(LEN) Q
 I $G(TARGET)="" Q
 N I,PC,STR1,CNT
 S CNT=0,STR1=""
 F I=1:1:$L(STR," ") S PC=$P(STR," ",I) I PC'="" D
 . I STR1="",$L(PC)>LEN S CNT=CNT+1,@TARGET@(CNT)=$E(PC,1,LEN),STR1=$E(PC,LEN+2,999)_" " Q
 . I $L(STR1_PC)>LEN S CNT=CNT+1,@TARGET@(CNT)=$$TKO^BQIUL1(STR1," "),STR1=PC_" " Q
 . S STR1=STR1_PC_" "
 I STR1'="" S CNT=CNT+1,@TARGET@(CNT)=$$TKO^BQIUL1(STR1," ")
 Q
 ;
XIT ; Exit from routine
 Q
