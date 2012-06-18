BARRHD ; IHS/SD/LSL - Report Header Generator ; 07/28/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,6,10,19**;OCT 26, 2005
 ;
 ; TMM 07/25/2010 V1.8*19
 ;     - Modify A/R Statitical Report to allow user to
 ;     filter specific (Employer) Group Plans when
 ;     BILLING ENTITY/6)SELECT A SPECIFIC A/R ACCOUNT
 ;      - Allow user to select report to print in printer OR delimited file format
 ;
 ; *********************************************************************
 ;
HD ;EP for setting Report Header
 I $D(BARY("ALL")) D ALLOW
 E  D BIL                   ; Billing entity parameters and A/R Account
 D CHK                      ; Build header level array
 D LOC      ; Location parameters
 D:$D(BARY("DT")) DT        ; Date parameters
 D:$D(BARY("PRV")) PRV      ; Provider parameter
 I BAR("OPT")="IPDR" D
 . D DSCHG   ; Discharge service
 . D DX        ; Diagnosis Range
 Q
 ; *********************************************************************
 ;
BIL ; EP
 ; Billing entity parameters
 S BAR("LVL")=0
 S BAR("CONJ")="for "
 ;---BEGIN ADD(1)--->  ;M819*ADD*TMM*201007259
 ;I $D(BARY("ACCT")) S BAR("TXT")=BARY("ACCT","NM") Q     ;M819*DEL*TMM*20100729
 ;M819*DEL*TMM*20100816  I $D(BARY("ACCT")) D  Q
 I $G(BAR("OPT"))="STA",$D(BARY("ACCT")) D  Q           ;M819*ADD*TMM*20100816
 . S BARTMPG=$S($G(BARY("GRP PLAN"))>0:"GROUPS: ",1:"GROUP: ")
 . S BAR("TXT")=BARY("ACCT","NM")_"     "_BARTMPG
 . I '$D(BARY("GRP PLAN")) S BAR("TXT")=BAR("TXT")_"ALL GROUPS"
 . I $D(BARY("GRP PLAN")) D
 .. S BARGPCNT=0
 .. S BARGRP="" F  S BARGRP=$O(BARY("GRP PLAN",BARGRP)) Q:BARGRP=""  D
 ... S BARGPCNT=BARGPCNT+1
 ... I BARGPCNT'=1 S BAR("TXT")=BAR("TXT")_","
 ... S BAR("TXT")=BAR("TXT")_$G(BARY("GRP PLAN",BARGRP))
 ;-----END ADD(1)--->  ;M819*ADD*TMM*20100725
 S BAR("TXT")="ALL"
 I $D(BARY("PAT")) S BAR("TXT")=$P(^DPT(BARY("PAT"),0),U) Q
 I $D(BARY("TYP")) D
 . ;I BARY("TYP")="R" S BAR("TXT")="MEDICARE" Q
 . ;I BARY("TYP")="D" S BAR("TXT")="MEDICAID" Q
 . ;I BARY("TYP")="W" S BAR("TXT")="WORKMEN'S COMP" Q
 . ;I BARY("TYP")["W" S BAR("TXT")="PRIVATE+WORKMEN'S COMP" Q
 . ;I BARY("TYP")["P" S BAR("TXT")="PRIVATE INSURANCE" Q
 . ;I BARY("TYP")="N" S BAR("TXT")="NON-BENEFICIARY PATIENTS" Q
 . ;I BARY("TYP")="I" S BAR("TXT")="BENEFICIARY PATIENTS" Q
 . ;I BARY("TYP")="K" S BAR("TXT")="CHIP" Q
 . ;BEGIN NEW CODE BAR*1.8*6  DD 4.1.1 IM21585
 . I BARY("TYP")=(U_"R"_U_"MD"_U_"MH"_U) S BAR("TXT")="MEDICARE" Q
 . I BARY("TYP")=(U_"D"_U) S BAR("TXT")="MEDICAID" Q
 . I BARY("TYP")=(U_"W"_U) S BAR("TXT")="WORKMEN'S COMP" Q
 . I BARY("TYP")[(U_"W"_U)&(BARY("TYP")[(U_"P"_U)) S BAR("TXT")="PRIVATE+WORKMEN'S COMP" Q
 . I BARY("TYP")[(U_"P"_U)&(BARY("TYP")'[(U_"W"_U)) S BAR("TXT")="PRIVATE INSURANCE" Q
 . I BARY("TYP")=(U_"N"_U) S BAR("TXT")="NON-BENEFICIARY PATIENTS" Q
 . I BARY("TYP")=(U_"I"_U) S BAR("TXT")="BENEFICIARY PATIENTS" Q
 . I BARY("TYP")=(U_"K"_U) S BAR("TXT")="CHIP" Q
 . I BARY("TYP")=(U_"G"_U) S BAR("TXT")="OTHER" Q
 . ;END NEW CODE
 . S BAR("TXT")="UNSPECIFIED"
 S BAR("TXT")=BAR("TXT")_" BILLING SOURCE(S)"
 Q
 ; *********************************************************************
 ;
LOC ; EP
 ; Location
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 E  S BAR("TXT")="ALL"
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK
 Q
 ; *********************************************************************
 ;
DT ; EP
 ; Date
 S BAR("CONJ")="with "
 S BAR("TXT")=$S(BARY("DT")="A":"APPROVAL DATES",BARY("DT")="V":"VISIT DATES",BARY("DT")="X":"EXPORT DATES",1:"TRANSACTION DATES")
 I BAR("OPT")="IPDR",BARY("DT")="V" S BAR("TXT")="ADMISSION DATES"
 I BARY("DT")="B" S BAR("TXT")="COLLECTION BATCH DATES"  ;MRS:BAR*1.8*10 IM30590
 D CHK
 S BAR("CONJ")="from "
 S BAR("TXT")=$$SDT^BARDUTL(BARY("DT",1))
 D CHK
 S BAR("CONJ")="to "
 S BAR("TXT")=$$SDT^BARDUTL(BARY("DT",2))
 D CHK
 Q
 ; *********************************************************************
 ;
PRV ;
 ; Providers
 S BAR("CONJ")="provided by "
 S BAR("TXT")=$P(^VA(200,BARY("PRV"),0),U)
 D CHK
 Q
 ; *********************************************************************
 ;
XIT ;
 K BAR("CONJ"),BAR("TXT"),BAR("LVL")
 Q
 ; *********************************************************************
 ;
CHK ; EP
 I ($L(BAR("HD",BAR("LVL")))+1+$L(BAR("CONJ"))+$L(BAR("TXT")))<($S($D(BAR(132)):104,1:52)+$S(BAR("LVL")>0:28,1:0)) S BAR("HD",BAR("LVL"))=BAR("HD",BAR("LVL"))_" "_BAR("CONJ")_BAR("TXT")
 ;E  S BAR("LVL")=BAR("LVL")+1,BAR("HD",BAR("LVL"))=BAR("CONJ")_BAR("TXT")      ;M819*DEL*TMM*20100731
 E  S BAR("LVL")=BAR("LVL")+1,BAR("HD",BAR("LVL"))=BAR("CONJ")_BAR("TXT")_$$TEXTCK^BARDRST()   ;M819*ADD*TMM*20100731
 Q
 ; *********************************************************************
 ;
WHD ;EP for writing Report Header
 ;W $$EN^BARVDF("IOF"),!   ;M819*DEL*TMM*20100731
 ;I $D(BAR("PRIVACY")) W ?($S($D(BAR(132)):34,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!
 ;I $D(BAR("PRIVACY")) W ?($S($D(BAR(132)):34,$D(BAR(180)):68,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!  ;BAR*1.8*6 ITEM 2  ;M819*DEL*TMM*20100731
 ; ---BEGIN ADD(1)--->  ;M819*ADD*TMM*20100731
 W $$EN^BARVDF("IOF"),!             ;not a delimited file
 I $D(BAR("PRIVACY")),$G(BARTEXT)'=1 W ?($S($D(BAR(132)):34,$D(BAR(180)):68,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!  ;BAR*1.8*6 ITEM 2
 I $D(BAR("PRIVACY")),$G(BARTEXT)=1 W "^","WARNING: Confidential Patient Information, Privacy Act Applies",!  ;BAR*1.8*6 ITEM 2
 ; -----END ADD(1)--->  ;M819*ADD*TMM*20100731
 K BAR("LINE")
 ;S $P(BAR("LINE"),"=",$S($D(BAR(133)):132,1:81))=""
 S $P(BAR("LINE"),"=",$S($D(BAR(133)):132,$D(BAR(180)):181,1:81))=""  ;BAR*1.8*6 ITEM 2  ;M819*DEL*TMM*20100731
 W BAR("LINE"),!
 ;W BAR("HD",0),?$S($D(BAR(132)):102,1:51)
 ;W BAR("HD",0),?$S($D(BAR(132)):102,$D(BAR(180)):150,1:51)  ;BAR*1.8*6 ITEM 2  ;M819*DEL*TMM*20100731
 I $G(BARTEXT)'=1 W BAR("HD",0),?$S($D(BAR(132)):102,$D(BAR(180)):150,1:51)  ;BAR*1.8*6 ITEM 2  ;M819*DEL*TMM*20100731
 I $G(BARTEXT)=1 W BAR("HD",0),"^^^^"  ;BAR*1.8*6 ITEM 2  ;M819*ADD*TMM*20100731  adv to column 6
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 W $P(Y,":",1,2),"   Page ",BAR("PG")
 I $G(BARTEXT)=1 W "^"     ;M819*ADD*TMM*20100731
 ;F I=1:1:BAR("LVL") W:$G(BAR("HD",BAR("LVL")))]"" !,BAR("HD",I)
 ;BEGIN BAR*1.8*1 SRS ADDENDUM
 ;CHANGE MADE TO ACCOMODATE DECIMALS IN THE HEADER LEVELS. EASIER TO ADD LEVELS
 S BAR("TMPLVL")=0
 F  S BAR("TMPLVL")=$O(BAR("HD",BAR("TMPLVL"))) Q:'BAR("TMPLVL")&(BAR("TMPLVL")'=0)  W:$G(BAR("HD",BAR("TMPLVL")))]"" !,BAR("HD",BAR("TMPLVL"))
 ;END BAR*1.8*1 SRS ADDENDUM
 W !,BAR("LINE")
 K BAR("LINE")
 Q
 ; *********************************************************************
 ;
ALLOW ; EP
 ; Allowance Category Parameters
 S BAR("LVL")=0
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL"
 I $D(BARY("ALL")) D
 . I BARY("ALL")=1!(BARY("ALL")="R") S BAR("TXT")="MEDICARE" Q
 . I BARY("ALL")=2!(BARY("ALL")="D") S BAR("TXT")="MEDICAID" Q
 . I BARY("ALL")=3!(BARY("ALL")="P") S BAR("TXT")="PRIVATE INSURANCE" Q
 . ;I BARY("ALL")=4!(BARY("ALL")="K") S BAR("TXT")="CHIP" Q
 . I BARY("ALL")=4!(BARY("ALL")="O") S BAR("TXT")="OTHER" Q  ;BAR*1.8*6 DD 4.1.1 IM21585
 . S BAR("TXT")="OTHER"
 S BAR("TXT")=BAR("TXT")_" ALLOWANCE CATEGORY(S)"
 S BAR("TXT")=BAR("TXT")_$$TEXTCK^BARDRST()   ;formatting if delimited file M819*ADD*TMM*20100731
 Q
 ;
 ; ********************************************************************
 ;
DSCHG ;
 ; Discharge Service
 S BAR("TXT")="ALL"
 S:$D(BARY("DSVC")) BAR("TXT")=BARY("DSVC","NM")
 S BAR("TXT")=BAR("TXT")_" Discharge Services"
 S BAR("CONJ")="for "
 D CHK
 Q
 ; ********************************************************************
 ;
DX ;
 ; Diagnosis Range
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL Primary Diagnosis"
 I $D(BARY("DX")) D
 . S BAR("CONJ")="for "
 . S BAR("TXT")="Primary Diagnosis"
 . D CHK
 . S BAR("CONJ")="from "
 . S BAR("TXT")=BARY("DX",1)
 . D CHK
 . S BAR("CONJ")="to "
 . S BAR("TXT")=BARY("DX",2)
 D CHK
 Q
 ; ********************************************************************
 ;
ITYP ; EP
 S BAR("LVL")=0
 S BAR("CONJ")="for "
 S BAR("TXT")="ALL"
 S:$D(BARY("ITYP")) BAR("TXT")=BARY("ITYP","NM")
 S BAR("TXT")=BAR("TXT")_" INSURER TYPE(S)"
 Q
