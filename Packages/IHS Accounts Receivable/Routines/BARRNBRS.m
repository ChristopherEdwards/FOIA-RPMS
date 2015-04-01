BARRNBRS ;  IHS/SD/POT - Non Ben Payment Report PART5
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**24**;OCT 26, 2005;Build 69
 ; IHS/SD/POT 07/15/13 HEAT114352 NEW REPORT BAR*1.8*24
 ;
 ; *********************************************************************
 ;
 Q
ASKAGAIN ;EP - 
 K BARY
ASKAGAI1 ;KEEP PREV SELECTION
 K DIC,DIR
 S BARY("X")="W $$SDT^BARDUTL(X)"
 S (BARASK,BARDONE)=0
 S BARMENU=$S($D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 S BAR("OPT")="NBP"          ; Default
 S BAR("RTYP")=1,BAR("RTYP","NM")="Summary"
 D MSG
ASK1 F  D  Q:+BARDONE2!(+BARDONE)
 . D DISP                     ; Display current parameters
 . D PARM                     ; Select additional parameters
 I +BARDONE D ^BARVKL0 Q
 I '$D(BARY("DT")) D  G ASK1
 . W !!,"This is a required response. Enter '^' to exit."
 . W !," A Date Range must be entered for the report.",!
 . Q
 D TYP^BARRNBRC
 D RTYP
 Q
 ; *********************************************************************
 ;
MSG ; EP      
 N X S X=$G(BAR("OPT")) Q:(X="PAY"!(X="TDN"))&($I(BARMSGPT)>1)  ;
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
PARM ;
 ; Choose additional inclusion parameters
 S (BARDONE2,BARDONE3)=0
 K DIR
 S DIR(0)="SO^1:LOCATION;2:DATE RANGE;3:SPECIFIC PATIENT"
 S DIR("A")="Select ONE or MORE of the above INCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 I $E(X)="^" S BARDONE=1 Q
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S BARDONE2=1 Q
 S BARSEL=Y
 K BARTAG
 ;
 S BARTAG=$P("LOC^DT^PAT",U,BARSEL)
 I "123"[BARSEL S BARTAG=BARTAG_"^BARRNBRC"  ; 
 D @BARTAG
 I BARSEL=1 W:'$D(BARY("LOC")) "ALL"
 ;D TYP^BARRNBRC
 ;D RTYP
 Q
RTYP ; EP
 ; Select Report Type Inclusion Parameter
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail;2:Summary"
 S DIR("A")="Select TYPE of REPORT "
 S DIR("B")=1
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1 Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ;
 ; *********************************************************************
 ;
DISP ; Display current inclusion parameters
 W !!?3,"INCLUSION PARAMETERS in Effect for ",BARMENU,":"
 W !?3,"====================================================================="
 I $D(BARY("LOC")) W !?3,"- Visit Location........: ",BARY("LOC","NM")
 I '$D(BARY("LOC")) W !?3,"- Visit Location........: ALL"
 I $D(BARY("PAT")) W !?3,"- Billing Entity........: ",BARY("PAT","NM")
 I '$D(BARY("PAT")) I $D(BARY("TYP")) W !?3,"- Billing Entity........: ",BARY("TYP","NM")
 I $D(BARY("TRANS TYPE","ADJ CAT")) D
 . N TT S TT=0 F  S TT=$O(BARY("TRANS TYPE","ADJ CAT",TT)) Q:'TT  D
 . . W !?10,"- Adjustment Category...: ",$P($G(BARY("TRANS TYPE","ADJ CAT",TT)),U)
 ;K TT
 I $D(BARY("TRANS TYPE","ADJ TYPE")) D
 . N TT S TT=0 F  S TT=$O(BARY("TRANS TYPE","ADJ TYPE",TT)) Q:'TT  D
 . . W !?10,"- Adjustment Type.......: ",$P($G(BARY("TRANS TYPE","ADJ TYPE",TT)),U)
 ;K TT
 I $D(BARY("TDN")) D
 . W !?3,"- TDN Selected..........: "
 . N TDN S TDN=0 F  S TDN=$O(BARY("TDN",TDN)) Q:TDN=""   W ?29,TDN,!
 ;END NEW CODE
 I $D(BARY("DT")) D
 . W !?3,"- "
 . W:BARY("DT")="A" "Approval Dates from...: "
 . W:BARY("DT")="CB" "Batch Open Dates......: "
 . I BARY("DT")="V" D
 . . W:BAR("OPT")'="IPDR" "Visit Dates from........: "
 . . W:BAR("OPT")="IPDR" "Admission Dates from..: "
 . W:BARY("DT")="X" "Export Dates from.......: "
 . W:BARY("DT")="T" "Transaction Dates from..: "
 . S X=BARY("DT",1)
 . X BARY("X")
 . W "  to: "
 . S X=BARY("DT",2)
 . X BARY("X")
 I $D(BARY("COLPT")) W !?3,"- Collection Point......: ",BARY("COLPT","NM")
 I $D(BARY("BATCH")) W !?3,"- Collection Batch......: ",BARY("BATCH","NM")
 I $D(BARY("ITEM")) W !?3,"- Collection Batch Item.: ",BARY("ITEM","NM")
 ;BEGIN BAR*1.8.19 IHS/SD/PKD 5/05/10
 I $D(BARY("AR")),BAR("OPT")="CXL" W !?3,"- Cancelling Official...: ",$P(^VA(200,BARY("AR"),0),U)
 I $D(BARY("AR")) W !?3,"- A/R Entry Clerk.......: ",$P(^VA(200,BARY("AR"),0),U)
 I $D(BARY("APPR")) W !,?3,"- Approving Official....: ",BARY("APPR","NM")
 ; BAR*1.8*16 IHS/SD/PKD 5/7/10 
 I $D(BARY("CANC")) W !?3,"- Cancelling Official...: ",$P(^VA(200,BARY("CANC"),0),U)
 I $D(BARY("PRV")) W !?3,"- Provider..............: ",$P(^VA(200,BARY("PRV"),0),U)
 I $D(BARY("DSVC")) W !?3,"- Discharge Service.....: ",BARY("DSVC","NM")
 I $D(BARY("DX")) W !?3,"- Primary Diagnosis from: ",BARY("DX",1)," to: ",BARY("DX",2)
 I $G(BARY("RTYP")) W !?3,"- Report Type...........: ",BARY("RTYP","NM")
 I +$G(BARY("LBL")) W !?3,"- Large Balance.........: $",$FN(BARY("LBL"),",",2)
 I +$G(BARY("SBL")) W !?3,"- Small Balance.........: $",$FN(BARY("SBL"),",",2)
 ;
 ;IHS/SD/TMM 1.8*19 7/20/10
 I $D(BARY("GRP PLAN")) D
 . N TT S TT=0 F  S TT=$O(BARY("GRP PLAN",TT)) Q:'TT  D
 . . W !?3,"- Group Plan...........: ",$P($G(BARY("GRP PLAN",TT)),U)
 Q
 ; *********
CLIN ; EP
 ; Select clinics to sort by
 K BARY("CLIN")
 K DIC,DIE,DR,DA  ;IHS/SD/TPF BAR*1.8*21 HEAT48289
 S DIC="^DIC(40.7,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Clinic: ALL// "
 F  D  Q:+Y<0  Q:$G(BAR("OPT"))="PAY"
 . I $D(BARY("CLIN")) S DIC("A")="Select Another Clinic: "
 . D ^DIC
 . Q:+Y<0
 . S BARY("CLIN",+Y)=""
 . I $G(BAR("OPT"))="PAY" S BARY("CLIN","NM")=$P(Y,U,2)
 I '$D(BARY("CLIN")) D
 . I $D(DUOUT) K BARY("SORT") Q
 . W "ALL"
 K DIC,DIE,DR,DA
 Q
 ; ***********
 ;
VTYP ; EP
 ; Select Vitst Types to sort by
 K BARY("VTYP")
 K DIC,DIE,DR,DA
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Visit Type: ALL// "
 F  D  Q:+Y<0
 . I $D(BARY("VTYP")) S DIC("A")="Select Another Visit Type: "
 . D ^DIC
 . Q:+Y<0
 . S BARY("VTYP",+Y)=""
 I '$D(BARY("VTYP")) D
 . I $D(DUOUT) K BARY("SORT") Q
 . W "ALL"
 K DIC,DIE,DR,DA
 Q
