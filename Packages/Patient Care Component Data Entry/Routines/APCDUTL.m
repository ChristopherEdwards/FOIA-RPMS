APCDUTL ; IHS/CMI/LAB - DATA ENTRY UTILITIES ; 
 ;;2.0;IHS PCC SUITE;**2,7,10**;MAY 14, 2009;Build 88
 ;
 ;
NR ;EP - called from APCD NRS (ADD) input template
 NEW A,B,C,D
 D EN^DDIOL("Nutritional Risk Screening Factors",,"!!")
 D EN^DDIOL("","","!")
 I $P(^AUPNVNTS(DA,0),U,4) D EN^DDIOL("- Age 70+",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,5) D EN^DDIOL("- Nutrition Support",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,6) D EN^DDIOL("- High Risk Weight Issue",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,7) D EN^DDIOL("- High Risk Diagnosis",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,8) D EN^DDIOL("- Poor Appetite",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,9) D EN^DDIOL("- Difficulty Chewing",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,10) D EN^DDIOL("- Food Allergies/Intolerances",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,11) D EN^DDIOL("- Recent Vomiting or Diarrhea",,"!?5")
 I $P(^AUPNVNTS(DA,0),U,12) S B=$P(^AUPNVNTS(DA,0),U,13)
 I $P(^AUPNVNTS(DA,0),U,12) D EN^DDIOL("- Other:  "_B,,"!?5")
 D EN^DDIOL("","","!!")
 Q
MSRSCR ;EP - called from pcc input templates to check age/sex
 I $P(^AUTTMSR(APCDTX,0),U,5)]"",$P(^DPT(APCDPAT,0),U,2)'=$P(^AUTTMSR(APCDTX,0),U,5) D  S APCDTQ=1 Q
 .W !,"That measurement can only be entered for ",$$VAL^XBDIQ1(9999999.07,APCDTX,.05)," patients.",!
 I $P(^AUTTMSR(APCDTX,0),U,6),$$AGE^AUPNPAT(APCDPAT,$S($G(APCDDATE):APCDDATE,1:DT))<$P(^AUTTMSR(APCDTX,0),U,6) D  S APCDTQ=1 Q
 .W !,"That measurement can only be entered for patients over the age of ",$$VAL^XBDIQ1(9999999.07,APCDTX,.06)," and under ",!,"the age of ",$$VAL^XBDIQ1(9999999.07,APCDTX,.07),".",!
 I $P(^AUTTMSR(APCDTX,0),U,7),$$AGE^AUPNPAT(APCDPAT,$S($G(APCDDATE):APCDDATE,1:DT))>$P(^AUTTMSR(APCDTX,0),U,7) D  S APCDTQ=1 Q
 .W !,"That measurement can only be entered for patients over the age of ",$$VAL^XBDIQ1(9999999.07,APCDTX,.06)," and under ",!,"the age of ",$$VAL^XBDIQ1(9999999.07,APCDTX,.07),".",!
 Q
 ;
GETMEAS(PATDFN,VSTDATE) ;EP - GET MEASUREMENT TYPE AND APPLY SCREEN FOR HMSR AND MEAS MNEMONICS
 S APCDLOOK=""
 D EN^XBNEW("GETMEAS1^APCDUTL","APCDLOOK;PATDFN;VSTDATE")
 Q
GETMEAS1 ;
 ;GET MEASUREMENT TYPE WITH READER CALL
 NEW APCDTX,APCDDATE,APCDPAT,APCDTQ
 S APCDPAT=PATDFN
 S APCDDATE=VSTDATE
 K DIC
 S DIC="^AUTTMSR(",DIC("A")="Enter MEASUREMENT Type: ",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U)'[""BMI""" D ^DIC
 I Y=-1 Q
 NEW APCDTX
 S APCDTX=+Y
 D MSRSCR
 I $G(APCDTQ) G GETMEAS1
 S APCDLOOK=$P(^AUTTMSR(APCDTX,0),U,1)
 Q
