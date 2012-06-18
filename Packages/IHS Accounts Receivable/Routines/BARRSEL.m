BARRSEL ; IHS/SD/LSL - Selective Report Parameters ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,16,19,20**;OCT 26,2005
 ;
 ; IHS/ASDS/LSL - 08/26/00 - Routine created
 ; IHS/ASDS/LSL - 01/16/01 - Add Allowance Category Parameter for Period
 ;     Summary Report at the request of Finance/AR group
 ; IHS/ASDS/SDH - 11/21/01 - A/R Statistical Report 
 ;     Modified to check if it is the statistical report and only
 ;     show related choices
 ; IHS/SD/LSL - 05/16/02 - V1.6 Patch 2
 ;     Modified to display message based on Location type for reports parameter.
 ; IHS/SD/LSL - 03/12/04 - V1.8 - Added reports to use inclusion parameters
 ; IHS/SD/SDR - v1.8 p6 - DD 4.1.3 - Added negative balance
 ; IHS/SD/PKD - 05/07/10 1.8*19 CXL;TDN;PAY reports- Added inclusion parameters  
 ; IHS/SD/TMM 07/20/2010 1.8*19 Add Group Plan.
 ; IHS/SD/PKD 1/26/11 1.8*20 Move code from tags: DISP; CLIN; VTYP to BARRSEL1
 ;
 ; *********************************************************************
 ;
ASKAGAIN ;EP - IHS/SD/TPF BAR*1.8*6 DD 4.1.5
 K DIC,DIR,BARY
 S BARY("X")="W $$SDT^BARDUTL(X)"
 S (BARASK,BARDONE)=0
 S BARMENU=$S($D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 S BAR("OPT")="LIST"          ; Default
 S:BARMENU["Negative" BAR("OPT")="NEG"  ;IHS/SD/SDR bar*1.8*6 DD 4.1.3
 S:BARMENU["Transaction" BAR("OPT")="TAR"
 S:BARMENU["Age Detail" BAR("OPT")="AGE"
 S:BARMENU["Statistical" BAR("OPT")="STA"
 S:BARMENU["Inpatient" BAR("OPT")="IPDR"
 S:BARMENU["Payment" BAR("OPT")="PRP"
 S:BARMENU["Transaction" BAR("OPT")="TAR"
 S:BARMENU["Days in AR" BAR("OPT")="DAYS"  ;BAR*1.8*16 IHS/SD/TPF 1/27/10
 ; BAR*1.8*19 IHS/SD/PKD 5/05/10
 I BARMENU["Cancelled Bills Report" D  ; Set Defaults
 . S BAR("OPT")="CXL"
 . I '$D(BARY("OBAL")) D OBAL^BARRCXL
 . I '$G(BARY("RTYP")) S BARY("RTYP")=1,BARY("RTYP","NM")="DETAIL"
 S:BARMENU="Payment Summary Report by TDN" BAR("OPT")="TDN"
 S:BARMENU="Top Payer Report" BAR("OPT")="PAY"
 I BAR("OPT")="TDN"!(BAR("OPT")="PAY") S BAR("RTYP")=1,BAR("RTYP","NM")="Summary"
 ; END BAR*1.8*19
 ;IHS/SD/TPF 5/22/08 BAR*1.8*6 DD 4.1.5
 I BARMENU["Transaction Statistical" D
 .S BAR("OPT")="TSR"
 .S BARY("RTYP")=1
 .S BARY("RTYP","NM")="DETAIL"
 .S BARY("TRANS TYPE",40)="PAYMENT"
 .S BARY("DATA SRC")="BOTH"  ;bar*1.8*20 REQ10
 ;END BAR*1.8*6 DD 4.1.5
 I BARMENU["Large" D
 . S BAR("OPT")="LBL"
 . S BARY("LBL")=5000
 I BARMENU["Small" D
 . S BAR("OPT")="SBL"
 . S BARY("SBL")=5
 I ",TAR,AGE,LIST,"[(","_BAR("OPT")_",") D
 . S BARY("RTYP")=1
 . S BARY("RTYP","NM")="Detail"
 D MSG
 F  D  Q:+BARDONE2!(+BARDONE)
 . D DISP                     ; Display current parameters
 . D PARM                     ; Select additional parameters
 I +BARDONE D ^BARVKL0 Q
 Q:BAR("OPT")="IPDR"!(BAR("OPT")="PRP")
 ;BEGIN BAR*1.8*16 IHS/SD/TPF 1/27/10
 I (BAR("OPT")="DAYS"),'$D(BARY("DT")) D  G ASKAGAIN
 .W !!,"The 'Days in AR' report requires you to enter"
 .W !,"a Visit date range."
 .W !!
 ;END BAR*1.8*16
 ; BEGIN BAR*1.8.19 PKD
 I BAR("OPT")="PAY"&('$D(BARY("DT"))) D  G ASKAGAIN
 . W !!,"This is a required response. Enter '^' to exit.",!,*7," A Date Range must be entered for the report."
 ; IHS/SD/PKD 1.8*19 6/28/10
TDNCHK I BAR("OPT")="TDN"&('$D(BARY("DT"))&('$D(BARY("TDN")))) D  G ASKAGAIN
 . W !!,"This is a required response. Enter '^' to exit."
 ; end BAR 1.8*19
 ;IHS/SD/TPF BEGIN BAR*1.8*6 DD 4.1.5
 I ((BAR("OPT")="TSR"))&('$D(BARY("TRANS TYPE"))) D  G ASKAGAIN
 .W !!,"The 'Transaction Statistical Report' requires you enter"
 .W !,"a transaction type."
 ;END BAR*1.8*6
 ;IHS/SD/AR BAR*1.8*19
 I "TSR"[BAR("OPT") S BARY("SORT")="N"
 ;I ",LBL,SBL,"[(","_BAR("OPT")_",") D  Q  ;IHS/SD/SDR bar*1.8*6 DD 4.1.3
 I ",LBL,SBL,NEG,"[(","_BAR("OPT")_",") D  Q  ;IHS/SD/SDR bar*1.8*6 DD 4.1.3
 . D ASKSORT
 . D:BARASK SORT
 D SORT
 Q
 ; *********************************************************************
 ;
MSG ; EP      
 N X S X=$G(BAR("OPT")) Q:(X="PAY"!(X="TDN"))&($I(BARMSGPT)>1)  ; IHS/BAR*1.8*19 PKD
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 I BAR("LOC")="BILLING" D MSG1
 E  D MSG2
 Q
 ; *********************************************************************
 ;
MSG1 ;
 ; Message if Site Parameter "Location type for Reports" is BILLING
 W ?7,"This report will contain data for the BILLING location you are logged "
 W !?7,"into.  Selecting a Visit Location will allow you to run the report for"
 W !?7,"a specific VISIT location under this BILLING location."
 Q
 ; *********************************************************************
 ;
MSG2 ;
 ; Message if Site Parameter "Location type for Reports" is VISIT
 W ?7,"This report will contain data for VISIT location(s) regardless of"
 W !?7,"BILLING location."
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
DISP ;
 ; Display current inclusion parameters
 ; IHS/SD/PKD 1.8*20 SAC size limitations: move code
 D DISP^BARRSEL1
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
PARM ;
 ; Choose additional inclusion parameters
 S (BARDONE2,BARDONE3)=0
 K DIR
 S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER;5:REPORT TYPE"
 S:BAR("OPT")="AGE" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:PROVIDER;4:REPORT TYPE"
 S:BAR("OPT")="TAR" DIR(0)="SO^1:LOCATION;2:TRANSACTION DATE RANGE;3:COLLECTION BATCH;4:COLLECTION BATCH ITEM;5:A/R ENTRY CLERK;6:PROVIDER;7:REPORT TYPE"
 S:BAR("OPT")="STA" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER"
 S:BAR("OPT")="IPDR" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:DATE RANGE;5:PROVIDER;6:DIAGNOSIS;7:DISCHARGE SERVICE"
 S:BAR("OPT")="LBL" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:LARGE BALANCE"
 S:BAR("OPT")="SBL" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY;4:SMALL BALANCE"
 S:BAR("OPT")="PRP" DIR(0)="SO^1:LOCATION;2:COLLECTION POINT;3:INSURER TYPE"
 S:BAR("OPT")="NEG" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:ALLOWANCE CATEGORY"  ;IHS/SD/SDR bar*1.8*6 DD 4.1.3
 ;IHS/SD/TPF BAR*1.8*6 DD 4.1.5
 I BAR("OPT")="TSR" D
 .;S DIR(0)="SO^1:DATE RANGE;2:BILLING ENTITY;3:COLLECTION BATCH;4:COLLECTION BATCH ITEM;5:POSTING CLERK;6:LOCATION;7:PROVIDER;8:ALLOWANCE CATEGORY;9:TRANSACTION TYPE;10:REPORT TYPE"  ;bar*1.8*20 REQ10
 .S DIR(0)="SO^1:DATE RANGE;2:BILLING ENTITY;3:COLLECTION BATCH;4:COLLECTION BATCH ITEM;5:POSTING CLERK;6:LOCATION;7:PROVIDER;8:ALLOWANCE CATEGORY;9:TRANSACTION TYPE;10:REPORT TYPE;11:DATA SOURCE"  ;bar*1.8*20 REQ10
 ;END
 ;BEGIN BAR*1.8*16 IHS/SD/TPF 1/2/7/10
 S:BAR("OPT")="DAYS" DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:PROVIDER"
 ;END
 ;BEGIN BAR*1.8.19 IHS/SD/PKD 5/05/10 
 I BAR("OPT")="CXL" D
 . S DIR(0)="SO^1:LOCATION;2:BILLING ENTITY;3:DATE RANGE;4:CANCELLING OFFICIAL;5:PROVIDER;6:ELIGIBILITY STATUS;7:REPORT TYPE"
 S:BAR("OPT")="TDN" DIR(0)="SO^1:LOCATION;2:One or more TDN's;3:DATE RANGE"
 S:BAR("OPT")="PAY" DIR(0)="SO^1:LOCATION;2:DATE RANGE;3:PROVIDER;4:CLINIC;5:APPROVING OFFICIAL;6:PRIMARY DIAGNOSIS;7:ADJUSTMENT;8:ALLOWANCE CATEGORY"
 ;END
 S DIR("A")="Select ONE or MORE of the above INCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 I $E(X)="^" S BARDONE=1 Q
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S BARDONE2=1 Q
 S BARSEL=Y
 K BARTAG
 ;
 ;BEGIN IHS/SD/TPF BAR*1.8*6 DD 4.1.5
 I BAR("OPT")="TSR" D  Q
 . S:BARSEL=1 BARTAG="DT"
 . S:BARSEL=2 BARTAG="TYP"
 . S:BARSEL=3 BARTAG="BATCH"
 . S:BARSEL=4 BARTAG="ITEM"
 . S:BARSEL=5 BARTAG="AR"
 . S:BARSEL=6 BARTAG="LOC"
 . S:BARSEL=7 BARTAG="PRV"
 . S:BARSEL=8 BARTAG="ALL"
 . S:BARSEL=9 BARTAG="TRANTYP"
 . S:BARSEL=10 BARTAG="RTYP"
 . S:BARSEL=11 BARTAG="DATASRC"  ;bar*1.8*20 REQ10
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;END NEW CODE
 ;BEGIN IHS/SD/PKD BAR*1.8*19  4/27/10
CXL I BAR("OPT")="CXL" D  Q
 . S BARTAG=$P("LOC^TYP^DT^CANC^PRV^PTYP^RTYP",U,BARSEL)
 . I BARSEL=4!(BARSEL=6) S BARTAG=BARTAG_"^BARRSL2"
 . E  S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
PAY I BAR("OPT")="PAY" D  Q
 . S BARTAG=$P("LOC^DT^PRV^CLIN^APPR^DX^ADJTYP^ALL",U,BARSEL)
 . I "12368"[BARSEL S BARTAG=BARTAG_"^BARRSL1"  ; 
 . I "5"[BARSEL S BARTAG=BARTAG_"^BARRSL2"  ; ApprOfficial
 . I BARSEL=7 S BARTAG=BARTAG_"^BARRPAY"  ;  AdjTyp
 . D @BARTAG
TDN I BAR("OPT")="TDN" D  Q
 . S:BARSEL=1 BARTAG="LOC^BARRSL1"
 . S:BARSEL=2 BARTAG="TDN^BARRSL2",BARSRT=2
 . S:BARSEL=3 BARTAG="DATES^BARRPTD",BARSRT=1
 . D @BARTAG
 ;END NEW CODE 1.8*19
 ;
 I BAR("OPT")="AGE" D  Q
 . S BARTAG="RTYP"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="TYP"
 . S:BARSEL=3 BARTAG="PRV"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;
 I BAR("OPT")="TAR" D  Q
 . S BARTAG="RTYP"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="DT"
 . S:BARSEL=3 BARTAG="BATCH"
 . S:BARSEL=4 BARTAG="ITEM"
 . S:BARSEL=5 BARTAG="AR"
 . S:BARSEL=6 BARTAG="PRV"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;
 I BAR("OPT")="IPDR" D  Q
 . S BARTAG="DSVC"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="TYP"
 . S:BARSEL=3 BARTAG="ALL"
 . S:BARSEL=4 BARTAG="DT"
 . S:BARSEL=5 BARTAG="PRV"
 . S:BARSEL=6 BARTAG="DX"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;
 I ",LBL,SBL,"[(","_BAR("OPT")_",") D  Q
 . S BARTAG="ALL"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="TYP"
 . I BARSEL=4,BAR("OPT")="LBL" S BARTAG="LBL"
 . I BARSEL=4,BAR("OPT")="SBL" S BARTAG="SBL"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;
 I BAR("OPT")="PRP" D  Q
 . S BARTAG="ITYP"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="COLPT"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;
 ;start new code IHS/SD/SDR bar*1.8*6 DD 4.1.3
 I BAR("OPT")="NEG" D  Q
 . S BARTAG="ALL"
 . S:BARSEL=1 BARTAG="LOC"
 . S:BARSEL=2 BARTAG="TYP"
 . S BARTAG=BARTAG_"^BARRSL1"
 . D @BARTAG
 ;end new code 4.1.3
 ;
 S BARTAG="RTYP"
 S:BARSEL=1 BARTAG="LOC"
 S:BARSEL=2 BARTAG="TYP"
 S:BARSEL=3 BARTAG="DT"
 S:BARSEL=4 BARTAG="PRV"
 S BARTAG=BARTAG_"^BARRSL1"
 D @BARTAG
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
ASKSORT ; EP
 W !
 K DIR
 S DIR(0)="Y^A"
 S DIR("A")="INCLUDE CLINIC OR VISIT TYPE? "
 S DIR("B")="N"
 D ^DIR
 S:Y BARASK=1
 K DIR
 Q
 ; *********************************************************************
 ;
SORT ; EP
 ; Sort criteria
 ; BAR*1.8*19 IHS/SD/PKD 6/9/10
 Q:BAR("OPT")="TDN"!(BAR("OPT")="PAY")  ; Sort by TDN or Date ; END
 W !
 K DIR
 S DIR(0)="SA^C:CLINIC;V:VISIT TYPE"
 S DIR("A")="Sort Report by [V]isit Type or [C]linic: "
 S DIR("B")="V"
 S DIR("?")="Enter 'V' to sort the report by Visit Type (inpatient, outpatient, etc.) or a 'C' to sort it by the Clinic associated with each visit."
 D ^DIR
 K DIR
 I $D(DIROUT)!$D(DIRUT) S BARDONE=1 Q
 S BARY("SORT")=Y
 I BARY("SORT")="C" D CLIN Q
 D VTYP
 Q
 ; *********************************************************************
 ;
CLIN ; EP
 ; Select clinics to sort by
 ; IHS/SD/PKD 1.8*20 Move Code SAC size
 D CLIN^BARRSEL1
 Q
 ; *********************************************************************
 ;
VTYP ; EP
 ; Select Vitst Types to sort by
 ; IHS/SD/PKD 1.8*20 SAC Size limits move code
 D VTYP^BARRSEL1
 Q
