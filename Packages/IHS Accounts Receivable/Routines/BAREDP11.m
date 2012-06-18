BAREDP11 ; IHS/SD/LSL - NEW REPORT ERA CLAIMS (2) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,5,20**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 10/14/03 - V1.7 Patch 4 - HIPAA
 ;      Routine Created
 ;
 ; ********************************************************************
 ;
COMPUTE ;EP
 ; Compute line tag required by BARDBQUE but all processing
 ; is done under PRINT so just quit here
 Q
 ; ********************************************************************
 ;
PRINT ; EP
 ; PRINT the report (Browse or Print)
 S BAR("PG")=0
 I (BARTYP="D"!(BARTYP="B")) D DETAIL
 I BARTYP="S" D SUMMARY
 I $G(BAR("F1"))="" D
 . W !,$$CJ^XLFSTR("* * E N D   O F   R E P O R T * *",IOM)
 . D PAZ^BARRUTL
 D CLEANUP
 Q
 ; ********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ; -------------------------------
 ;
HDB ; EP
 S BAR("PG")=BAR("PG")+1
 I BAR("PG")>1 S BAR("LVL")=4
 D WHD^BARRHD
 I BARTYP="S" D
 . X BAR("COL")
 . W !,BARDASH,!
 Q
 ; ********************************************************************
 ;
DETAIL ;
 ; Print report in brief and detail format
 D HDB
 K BARFLG  ;bar*1.8*20
 F XI=1:1:$L(BARINDX) S IND=$E(BARINDX,XI) D INDEX Q:$G(BAR("F1"))
 ;start new code bar*1.8*20
 I $D(^XTMP("BAR-ERARPT",$J,DUZ(2))) D
 .W !!,$$EN^BARVDF("RVN"),$$CJ^XLFSTR(BARZ("W","HDR"),IOM),!
 .W $$EN^BARVDF("RVF")
 .S CLMDA=0,BARFLG=1,(BARXBLC,BARXBLT,BARXPYT,BARXADJT)=0
 .F  S CLMDA=$O(^XTMP("BAR-ERARPT",$J,DUZ(2),CLMDA)) Q:CLMDA'>0  D CLAIM  Q:$G(BAR("F1"))
 .Q:$G(BAR("F1"))
 .K ^XTMP("BAR-ERARPT",$J)
 .I BARXBLC=0 W !!,$$CJ^XLFSTR("* * * NO DATA TO PRINT * * *",IOM),! Q
 .I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 .W !,BARSTAR
 .W !,"TOTALS FOR ",BARZ("W")
 .W !?2,"AMOUNT BILLED.........."
 .W $J($FN(BARXBLC,","),6)," BILLS(S)"
 .W "     $",$J($FN(BARXBLT,",",2),15)
 .W !?2,"PAYMENTS..............."
 .W $J($FN(BARXPYC,","),6)," BILLS(S)"
 .W "     $",$J($FN(BARXPYT,",",2),15)
 .W !?2,"ADJUSTMENTS............"
 .W $J($FN(BARXADJC,","),6)," BILLS(S)"
 .W ?58,"$",$J($FN(BARXADJT,",",2),15)
 .W !
 ;end new code bar*1.8*20
 Q
 ; *********************************************************************
 ;
INDEX ; EP
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !!,$$EN^BARVDF("RVN"),$$CJ^XLFSTR(BARZ(IND,"HDR"),IOM),!
 W $$EN^BARVDF("RVF")
 S (BARXPYT,BARXBLT,BARXADJT)=0
 S (BARXPYC,BARXBLC,BARXADJC)=0
 S BARFIRST=1
 S CLMDA=0
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC",IND,CLMDA)) Q:CLMDA'>0  D CLAIM  Q:$G(BAR("F1"))
 Q:$G(BAR("F1"))
 I BARXBLC=0 W !!,$$CJ^XLFSTR("* * * NO DATA TO PRINT * * *",IOM),! Q
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !,BARSTAR
 W !,"TOTALS FOR ",BARZ(IND)
 W !?2,"AMOUNT BILLED.........."
 W $J($FN(BARXBLC,","),6)," BILLS(S)"
 W "     $",$J($FN(BARXBLT,",",2),15)
 W !?2,"PAYMENTS..............."
 W $J($FN(BARXPYC,","),6)," BILLS(S)"
 W "     $",$J($FN(BARXPYT,",",2),15)
 W !?2,"ADJUSTMENTS............"
 W $J($FN(BARXADJC,","),6)," BILLS(S)"
 W ?58,"$",$J($FN(BARXADJT,",",2),15)
 W !
 I $G(INDSAVE)'="" S IND=INDSAVE K INDSAVE  ;bar*1.8*20
 Q
 ; ********************************************************************
 ;
CLAIM ; EP
 ; WORK THE CLAIM
 K CLM
 I $P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)'=BARCHK Q
 I '$G(BARFLG),IND="M",$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4)) S ^XTMP("BAR-ERARPT",$J,DUZ(2),CLMDA)="" Q  ;bar*1.8*20
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01:.09","CLM(")
 ;S BARERRC=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U,4)  ;OLD 'CLAIM STATUS #204'  ;bar*1.8*20
 S BARERRC=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,2)  ;bar*1.8*20
 S BARERRCD=""
 I +BARERRC S BARERRCD=$$GET1^DIQ(90056.21,BARERRC,.02)  ;ERROR CODE FROM 'A/R EDI EDI ERROR CODES'
 ; Billed amount totals for this index
 I +CLM(.05) D
 . S BARXBLC=BARXBLC+1
 . S BARXBLT=BARXBLT+CLM(.05)
 ; Payment amount totals for this index
 I +CLM(.04) D
 . S BARXPYC=BARXPYC+1
 . S BARXPYT=BARXPYT+CLM(.04)
 ; Write RA patient data
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 I BARTYP="D",'BARFIRST W !,BARDASH
 S BARFIRST=0
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !,$E(CLM(.01),1,18)  ;RA bill number
 W ?19,$E(CLM(.06),1,29)  ;RA patient name
 W ?49,CLM(.08)  ;RA dos begin
 W ?62,"- ",$E($P(CLM(.07)," ",3,999),1,15)  ;RA HRN/HIC
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 ;W !,"  ** BILL NOT MATCHED TO RPMS "
 ;I BARERRCD]"" W "- ",BARERRCD," "
 ;IHS/SD/TPF BAR*1.8*3 UFMS SESSION 
 ;I BARERRCD]"",(BARERRCD'="MATCHED") W !,"-  ** BILL NOT MATCHED TO RPMS ",!,"(OLD) REASON: ",BARERRCD
 ;E  W !,"- Matched: "
 ;END IHS/SD/TPF BAR*1.8*3 UFMS SESSION
 ;BEGIN BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008 NEW ERRORS CAN BE MULTIPLE
 ;start old bar*1.8*20
 ;I $O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,0)),(BARERRCD'="MATCHED") D
 ;.N REASDA,REASIENS,REASON
 ;.W !,"-  ** BILL NOT MATCHED TO RPMS "
 ;.W !?4,"REASON NOT MATCHED: "
 ;.S REASDA=0
 ;.F  S REASDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,REASDA)) Q:'REASDA  D
 ;..S REASIENS=REASDA_","_CLMDA_","_IMPDA_","
 ;..S REASON=$$GET1^DIQ(90056.0205401,REASIENS,.01,"I")
 ;..S REASON=$$GET1^DIQ(90056.21,REASON_",",.02,"E")
 ;..W !?6,REASON
 ;.K REASDA,REASIENS,REASON
 ;.W !,"-  **"
 ;E  W !,"- Matched: "
 ;end old start new bar*1.8*20
 I BARERRC'="M",BARERRC'="P" D
 .W !,"-  ** BILL NOT MATCHED TO RPMS "
 N REASDA,REASIENS,REASON
 I (BARERRC'="P"),$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4)) D
 .W !?4,"REASON NOT POSTABLE: "
 .S REASDA=0
 .F  S REASDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,REASDA)) Q:'REASDA  D
 ..S REASIENS=REASDA_","_CLMDA_","_IMPDA_","
 ..S REASON=$$GET1^DIQ(90056.0205401,REASIENS,.01,"I")
 ..S REASON=$$GET1^DIQ(90056.21,REASON_",",.02,"E")
 ..W !?6,REASON
 K REASDA,REASIENS,REASON
 ;W !,"-  **"  ;bar*1.8*20
 I BARERRC="M" S BARMIEN=CLMDA_","_IMPDA_"," W !,"- Matched: "_$$GET1^DIQ(90056.0205,BARMIEN,"1.01","E")
 ;end new bar*1.8*20
 ;W "**"
 ;END 
 I BARTYP="D" D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !!,"AMOUNT BILLED.............................................$",$J($FN(CLM(.05),",",2),15)
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !,"PAYMENT...................................................$",$J($FN(CLM(.04),",",2),15)
 D ADJ
 Q
 ; ********************************************************************
 ;
ADJ ;
 ; Loop adjustment data on claim
 K ADJ
 Q:'+$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,0))    ; No adjustments
 S BARXADJC=BARXADJC+1
 I BARTYP="D" D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !,"ADJUSTMENTS"
 S ADJDA=0
 F  S ADJDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA)) Q:'+ADJDA  D ADJ2 Q:$G(BAR("F1"))
 Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
ADJ2 ;
 ; 
 Q:'$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA,0))
 D ENP^XBDIQ1(90056.0208,"IMPDA,CLMDA,ADJDA,",".01:.05","ADJ(")
 S BARADJ(0)=$G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA,0))
 S BARXADJT=BARXADJT+ADJ(.02)
 I BARTYP="D" D  Q:$G(BAR("F1"))       ; If detail, write specifics
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !?2,$J($P(ADJ(.01)," "),2)        ; Standard adj code
 . D PAD
 . W ?6,ADJ(.03)                       ; Standard adj description
 . W ?53,"$",$J($FN(ADJ(.02),",",2),10)    ; Adj amount
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !?6,$J($P(BARADJ(0),U,4),3)       ; RPMS Category
 . W ?10,$E(ADJ(.04),1,19)             ; RPMS Category Description
 . W ?30,"/"
 . W ?32,$J($P(BARADJ(0),U,5),3)       ; RPMS Reason Code
 . W ?36,$E(ADJ(.05),1,30)             ; RPMS Reason Description
 Q
 ; ********************************************************************
 ;
PAD ;
 ; Standard Adj Description must be 47 characters
 K L,I,K
 S K=$P(ADJ(.03)," ",3,999)
 S L=$L(K)
 I L>45 S K=$E(K,1,46)
 I L<46 D
 . F I=L:1:46 S K=K_"."
 S ADJ(.03)=K
 K L,I,K
 Q
 ; ********************************************************************
 ;
SUMMARY ;
 D SUMDATA
 I '$D(BARX) D  Q
 . D HDB
 . W !!!,$$CJ^XLFSTR("* * * NO DATA TO PRINT * * *",IOM)
 . D PAZ^BARRUTL
 D SUMPRINT
 Q
 ; ********************************************************************
 ;
SUMDATA ;
 ;
 S BAR("COL")="W !,""CLAIM STATUS"",?26,""BILL COUNT"",?40,""PAYMENTS"",?51,""COPAY/DEDUCT"",?66,""ADJUSTMENTS"""
 K BARA
 F XI=1:1:$L(BARINDX) S BARX($E(BARINDX,XI))=0
 S BARX=0
 F XI=1:1:$L(BARINDX) S IND=$E(BARINDX,XI) D SUMDATA2
 Q
 ; ********************************************************************
 ;
SUMDATA2 ;
 ;
 S CLMDA=0
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC",IND,CLMDA)) Q:CLMDA'>0  D SUMDATA3
 Q
 ; ********************************************************************
 ;
SUMDATA3 ;
 K CLM
 Q:'$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0))    ; No data
 I $P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)'=BARCHK Q
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01:.09","CLM(")
 S $P(BARX(IND),U)=$P($G(BARX(IND)),U)+1        ; Bill count per index
 S $P(BARX(IND),U,2)=$P($G(BARX(IND)),U,2)+CLM(.04)   ; Payment
 S $P(BARX,U)=$P($G(BARX),U)+1              ; Total bill count
 S $P(BARX,U,2)=$P($G(BARX),U,2)+CLM(.04)   ; Total payments
 S ADJDA=0
 F  S ADJDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA)) Q:'+ADJDA  D SUMDATA4
 Q
 ; ********************************************************************
 ;
SUMDATA4 ;
 ;
 Q:'$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA,0))    ; No data
 S BARADJ0=$G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA,0))
 I ($P(BARADJ0,U,4)=13!($P(BARADJ0,U,4)=14)) D
 . S $P(BARX(IND),U,3)=$P($G(BARX(IND)),U,3)+$P(BARADJ0,U,2)
 . S $P(BARX,U,3)=$P($G(BARX),U,3)+$P(BARADJ0,U,2)
 E  D
 . S $P(BARX(IND),U,4)=$P($G(BARX(IND)),U,4)+$P(BARADJ0,U,2)
 . S $P(BARX,U,4)=$P($G(BARX),U,4)+$P(BARADJ0,U,2)
 ;S BARA($P(BARADJ0,U,4))=$G(BARA($P(BARADJ0,U,4)))+$P(BARADJ0,U,2)
 I $P(BARADJ0,U,4)'="" S BARA($P(BARADJ0,U,4))=$G(BARA($P(BARADJ0,U,4)))+$P(BARADJ0,U,2)  ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008 FOUND DURING DEVELOPMENT
 S BARA=$G(BARA)+$P(BARADJ0,U,2)
 Q
 ; ********************************************************************
 ;
SUMPRINT ;
 ;
 D HDB
 S IND=""
 F  S IND=$O(BARX(IND)) Q:IND=""  D  Q:$G(BAR("F1"))
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . W !,BARZ(IND)
 . W ?26,$J($P(BARX(IND),U),6)
 . W ?35,$J($FN($P(BARX(IND),U,2),",",2),12)
 . W ?50,$J($FN($P(BARX(IND),U,3),",",2),12)
 . W ?65,$J($FN($P(BARX(IND),U,4),",",2),12)
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !?26,"------",?35,"------------",?50,"------------",?65,"------------"
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !?3,"GRAND TOTALS"
 W ?26,$J($P(BARX,U),6)
 W ?35,$J($FN($P(BARX,U,2),",",2),12)
 W ?50,$J($FN($P(BARX,U,3),",",2),12)
 W ?65,$J($FN($P(BARX,U,4),",",2),12)
 I '$D(BARA) W !! Q
 ; Adjustment summary
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !!?10,"ADJUSTMENT Totals:",!
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))  W !
 ; List copay AND deduct first
 F I=13,14 D  Q:$G(BAR("F1"))
 . I $D(BARA(I)) D  Q:$G(BAR("F1"))
 . . W ?15,$$GET1^DIQ(90052.01,I,.01)
 . . W ?50,$J($FN(BARA(I),",",2),12)
 . . W !
 . . K BARA(I)
 . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 ; loop the rest
 S I=0
 F  S I=$O(BARA(I)) Q:'+I  D
 . W ?15,$$GET1^DIQ(90052.01,I,.01)
 . W ?50,$J($FN(BARA(I),",",2),12)
 . W !
 . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W ?50,"============",!
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W ?50,$J($FN(BARA,",",2),12),!
 Q
 ; ********************************************************************
 ;
CLEANUP ;
 K IMPDA,CLMDA,ADJDA,TRDA,I,J,K,DA,DR,DIC,DIE,CLM,ADJ
 Q
