BARRSEL1  ;IHS/SD/PKD - Selective Report Parameters CON'T ; 12/30/10
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,19,20,21,23,24**;OCT 26, 2005;Build 69
 ;routine BARRSEL grew too big for SAC requirements
 ;Code moved here and called from original tags (ie, called from BARRSEL)
 ;IHS/SD/POT JUN 2013 - MOD FOR ICD9/10 DX - BAR*1.8*.24
 ;IHS/SD/POT JAN 2014 - MOD FOR ICD9/10 DX - BAR*1.8*.24
DISP ;
 W !!?3,"INCLUSION PARAMETERS in Effect for ",BARMENU,":"
 W !?3,"====================================================================="
 I $D(BARY("LOC")) W !?3,"- Visit Location........: ",BARY("LOC","NM")
 I $D(BARY("ACCT")) W !?3,"- Billing Entity........: ",BARY("ACCT","NM")
 I $D(BARY("PAT")) W !?3,"- Billing Entity........: ",BARY("PAT","NM")
 I $D(BARY("TYP")) W !?3,"- Billing Entity........: ",BARY("TYP","NM")
 I $D(BARY("ALL")) W !?3,"- Allowance Category....: ",BARY("ALL","NM")
 I $D(BARY("ITYP")) W !?3,"- Insurer Type...........: ",BARY("ITYP","NM")
 I $D(BARY("PTYP")) W !?3,"- Eligbility Status......: ",BARY("PTYP","NM")
 I $D(BARY("CLIN"))&($G(BAR("OPT"))="PAY") W !,?3,"- Clinic................: ",BARY("CLIN","NM")
 I $D(BARY("ADJ CAT")) W !?3,"- Adjustment Type.......: ",BARY("ADJ CAT","NM")
 I $G(BARY("ADJTYP")) W !,?3,"Adjustment.............: ",$P(^BAR(90052.01,BARY("ADJTYP"),0),U)
 I $D(BARY("DATA SRC")) W !?3,"- Data Source........: ",BARY("DATA SRC")  ;bar*1.8*20 REQ10
 I $D(BARY("TRANS TYPE")) D
 .N TT S TT=0
 .F  S TT=$O(BARY("TRANS TYPE",TT)) Q:'TT  D
 ..W !?3,"- Transaction Type.....: ",$P($G(BARY("TRANS TYPE",TT)),U)
 I $D(BARY("TRANS TYPE","ADJ CAT")) D
 .N TT S TT=0
 .F  S TT=$O(BARY("TRANS TYPE","ADJ CAT",TT)) Q:'TT  D
 ..W !?10,"- Adjustment Category...: ",$P($G(BARY("TRANS TYPE","ADJ CAT",TT)),U)
 I $D(BARY("TRANS TYPE","ADJ TYPE")) D
 .N TT S TT=0
 .F  S TT=$O(BARY("TRANS TYPE","ADJ TYPE",TT)) Q:'TT  D
 ..W !?10,"- Adjustment Type.......: ",$P($G(BARY("TRANS TYPE","ADJ TYPE",TT)),U)
 I $D(BARY("TDN")) D
 . W !?3,"- TDN Selected..........: "
 . N TDN S TDN=0
 . F  S TDN=$O(BARY("TDN",TDN)) Q:TDN=""  D
 . . W ?29,TDN,!
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
 I $D(BARY("AR")),BAR("OPT")="CXL" W !?3,"- Cancelling Official...: ",$P(^VA(200,BARY("AR"),0),U)
 I $D(BARY("AR")) W !?3,"- A/R Entry Clerk.......: ",$P(^VA(200,BARY("AR"),0),U)
 I $D(BARY("APPR")) W !,?3,"- Approving Official....: ",BARY("APPR","NM")
 I $D(BARY("CANC")) W !?3,"- Cancelling Official...: ",$P(^VA(200,BARY("CANC"),0),U)
 I $D(BARY("PRV")) W !?3,"- Provider..............: ",$P(^VA(200,BARY("PRV"),0),U)
 I $D(BARY("DSVC")) W !?3,"- Discharge Service.....: ",BARY("DSVC","NM")
 D DX
 I $G(BARY("RTYP")) W !?3,"- Report Type...........: ",BARY("RTYP","NM")
 I +$G(BARY("LBL")) W !?3,"- Large Balance.........: $",$FN(BARY("LBL"),",",2)
 I +$G(BARY("SBL")) W !?3,"- Small Balance.........: $",$FN(BARY("SBL"),",",2)
 ;
 ;IHS/SD/TMM 1.8*19 7/20/10
 I $D(BARY("GRP PLAN")) D
 .N TT S TT=0
 .F  S TT=$O(BARY("GRP PLAN",TT)) Q:'TT  D
 ..W !?3,"- Group Plan...........: ",$P($G(BARY("GRP PLAN",TT)),U)
 Q
 ; *********
CLIN ; EP
 ; Select clinics to sort by
 K BARY("CLIN")
 K DIC,DIE,DR,DA  ;
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
 K DIC,DIE,DR,DA  ;
 Q
 ; ***********
 ;
VTYP ; EP
 ; Select Vitst Types to sort by
 K BARY("VTYP")
 K DIC,DIE,DR,DA  ;
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
 K DIC,DIE,DR,DA  ;
 Q
DX ;LIST SELECTED DX - BAR*1.8*.24
 N BARICD,BARICDX,BARDX
 F BARICD=9,10 D DX01(BARICD)
 I $D(BARY("DXTYPE")) D  ;
 . S BARTMP1=0
 . I $G(BARY("DXTYPE"))="P" S BARTMP1=1
 . I $G(BARY("DXTYPE"))="O" S BARTMP1=2
 . I $G(BARY("DXTYPE"))="A" S BARTMP1=3
 . W !?3,"- Search "_$P("Primary;Primary Only;Other Only;ALL (Primary + Other);",";",BARTMP1+1)_" Diagnosis"
 ;LINES ADDED IN P24 TO SELECT ALL DXs
 I $G(BARY("DX9"))="ALL" I $G(BARY("DX9_ALL"))="ALL" I $G(BARY("DX10"))="ALL" I $G(BARY("DX10_ALL"))="ALL" D  Q
 . W !?3,"- ALL Primary Diagnosis (ICD-9 and ICD-10)"  ;;- BAR*1.8*.24 3/13/2014
 I $G(BARY("DX9"))="ALL" I $G(BARY("DX9_ALL"))="ALL" W !?3,"- ALL Primary ICD-9 Diagnosis"
 I $G(BARY("DX10"))="ALL" I $G(BARY("DX10_ALL"))="ALL" W !?3,"- ALL Primary ICD-10 Diagnosis"
 Q
DX01(BARICD) ;
 S BARICDX="DX"_BARICD
 I $D(BARY(BARICDX,1)) W !?3,"- Diagnosis Range ICD",BARICD," from: ",$G(BARY(BARICDX,1))," to: ",$G(BARY(BARICDX,2)) ;P.OTT
 I $D(BARY(BARICDX,3)) D
 . W !?3,"- Individual Diagnosis ICD",BARICD,": "
 . S BARDX="" F  S BARDX=$O(BARY(BARICDX,3,BARDX)) Q:BARDX=""  W ! D DXINFO^BARRSL1(BARDX) I $O(BARY(BARICDX,3,BARDX))]"" ;W !
 I $D(BARY(BARICDX,4)) D
 . W !?3,"- Diagnosis ICD",BARICD," begins: "
 . S BARDX="" F  S BARDX=$O(BARY(BARICDX,4,BARDX)) Q:BARDX=""  W !?12,BARDX I $O(BARY(BARICDX,3,BARDX))]""  ;W !
 Q
