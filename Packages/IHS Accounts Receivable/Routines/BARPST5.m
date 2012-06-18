BARPST5 ; IHS/SD/LSL - LIST TRANSACTION HISTORY OF A BILL ; 03/31/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,4,5,6,20**;OCT 26,2005
 ;
 ; IHS/SD/SDR - 03/11/2002 - V1.6 Patch 2 - NOIS HQW-0801-100024
 ;     Modified routine to output insurer field as well as Entry By,
 ;     Complete entry for Transaction Type, and A/R Account.  Also fixed
 ;     line in CHKLINE to fix unrelated <DPARM> error if "^" out of bill
 ;
 ; IHS/SD/SDR - 4/4/2002 - V1.6 Patch 2 - NOIS HQW-0302-100166
 ;     Modified so it won't display any of the following transaction
 ;     types.  They are causing confusion and are not necessary to 
 ;     display.
 ;          COL BAT TO ACC POST - 115
 ;          COL BAT TO ACC UN-DIST -116 
 ;          COL BAT TO FACILITY -117 
 ;          COL BAT TO UN-DIST -118
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Display PENDING and GENERAL INFORMATION (2 new Adjustment
 ;     Categories) on the Transaction History.  These categories
 ;     should not affect the balance.
 ;
 ; IHS/SD/LSL - 10/17/03 - V1.7 Patch 4 - HIPAA
 ;      Display "e" next to transactions that were posted via Post
 ;      ERA Claims.
 ;
 ; IHS/SD/LSL - 02/13/04 - V1.7 Patch 5 - Remark Codes
 ;       Display Remark Code and NCPDP Reject/Payment codes
 ;       on Transaction on history
 ;       
 ;IHS/SD/RLT - 02/15/05 - V1.8 Patch 1 - IM15887
 ;       balances should not be affected by transaction
 ;       types of PENDING or GENERAL INFORMATION but should always
 ;       be displayed
 ; *********************************************************************
 ;
 ;** List Detail command from posting command prompt
 ;** lists details from a single bill
 ;
EN(BARBLDA) ; EP - Display bill history
 ;
EN1 ;
 N DIC,DR,BARCL,BARHLP,BARCLV,BARCLIT,BARITV,BARPSAT,BARSITE,BARSPAR,BARUSR
 N BARVSIT,BAREOV,BARBL,BARTRX,BARTR,BARBAL,BARX,BARQ,BARTRDA,BARBAL,BARPTA
 S DR=".01;3;14;15;101;102;103;104;108"
 S DIC=$$DIC^XBSFGBL(90050.01)
 D ENP^XBDIQ1(DIC,BARBLDA,DR,"BARBL(","")
 S BARBL(101,"I")=$$GET1^DIQ(90050.01,BARBLDA,101,"I")
 ; -------------------------------
 ;
GETPT ;
 I 'BARBL(101,"I") S BARBL(101,"I")=$G(BARPAT)
 I 'BARBL(101,"I") D  G GETTX
 .F BARJ=.111,.114,.115,.116,.131 S BARPTA(BARJ)=""
 S DIC="^DPT("
 S DR=".111;.114;.115;.116;.131"
 D ENP^XBDIQ1(DIC,BARBL(101,"I"),DR,"BARPTA(","")
 ; -------------------------------
 ;
GETTX ;
 ;S DR="2;3;6;13;14;15;101;102;103;107;108"
 S DR="2;3;6;13;14;15;101;102;103;107;108;110;111;112"  ;BAR*1.8*4 SCR56,SCR58
 ; End coding change V1.7 Patch 5
 S DIC=$$DIC^XBSFGBL(90050.03)
 S BARTRDA=0
 F  S BARTRDA=$O(^BARTR(DUZ(2),"AC",BARBLDA,BARTRDA)) Q:'BARTRDA  D
 .I '$D(^BARTR(DUZ(2),BARTRDA)) K ^BARTR(DUZ(2),"AC",BARBLDA,BARTRDA) Q
 .S BARTEST=","_$P($G(^BARTR(DUZ(2),BARTRDA,1)),U)_","
 .Q:BARTEST=",,"               ; No transaction type
 .I ",115,116,117,118,"[BARTEST Q
 .W "."
 .D ENP^XBDIQ1(DIC,BARTRDA,DR,"BARTRX(","1")
 .S BARTRX(BARTRDA,12)=$$GET1^DIQ(90050.03,BARTRDA,12,"I")
 .S BARTRX(BARTRDA,13)=$$GET1^DIQ(90050.03,BARTRDA,13,"I")
 .S BARTRX(BARTRDA,14,"I")=$$GET1^DIQ(90050.03,BARTRDA,14,"I") ;BAR*1.8*4 SCR56,SCR58
 .S BARTRX(BARTRDA,15,"I")=$$GET1^DIQ(90050.03,BARTRDA,15,"I") ;BAR*1.8*4
 .S BARTRX(BARTRDA,106)=$$GET1^DIQ(90050.03,BARTRDA,106,"I")
 .S BARTRX(BARTRDA,110)=$$GET1^DIQ(90050.03,BARTRDA,110,"I")  ;REVERSAL DATE;BAR*1.8*4 SCR56,SCR58
 .;S BARTRX(BARTRDA,111)=$$GET1^DIQ(90050.03,BARTRDA,111,"I")  ;SCHEDULE NUMBER/IPAC;BAR*1.8*4 SCR56,SCR58  ;IHS/SD/SDR BAR*1.8*6 4.2.3
 .S BARTRX(BARTRDA,111)=$$GET1^DIQ(90050.03,BARTRDA,111,"E")  ;SCHEDULE NUMBER/IPAC;BAR*1.8*4 SCR56,SCR58  ;IHS/SD/SDR BAR*1.8*6 4.2.3
 .S BARTRX(BARTRDA,112)=$$GET1^DIQ(90050.03,BARTRDA,112,"E")  ;IGNORE FLAG;BAR*1.8*4 SCR80 4.1.1
 .S BARTRX(BARTRDA,501)=$$GET1^DIQ(90050.03,BARTRDA,501,"E")  ;PAYMENT CREDIT APPLIED TO ;BAR*1.8*5 IHS/SD/TPF 6/17/2008
 .S BARTRX(BARTRDA,502)=$$GET1^DIQ(90050.03,BARTRDA,502,"E")  ;PAYMENT CREDIT APPLIED FROM ;BAR*1.8*5 IHS/SD/TPF 6/17/2008
 W !
 D HEAD
 S BARTRDA=0,BARBAL=0,BARQ=0
 F  S BARTRDA=$O(BARTRX(BARTRDA)) Q:'BARTRDA  D  Q:BARQ
 .S BARQ=$$CHKLINE()
 .Q:BARQ
 .W !
 .W $$SDT^BARDUTL($G(BARTRX(BARTRDA,12)))
 .I $G(BARTRX(BARTRDA,13))'="" W ?11,$P($G(^VA(200,BARTRX(BARTRDA,13),0)),U,2)
 .S BARBATCH=$S($L($G(BARTRX(BARTRDA,14))):BARTRX(BARTRDA,14),1:"NO BATCH")
 .S BARITEM=$S($L($G(BARTRX(BARTRDA,15))):BARTRX(BARTRDA,15),1:"")
 .;S:$G(BARTRX(BARTRDA,102))'="" BARTRX(BARTRDA,102)=BARTRX(BARTRDA,102)_"/"_$G(BARTRX(BARTRDA,103))  ;bar*1.8*20
 .S:$G(BARTRX(BARTRDA,102))'="" BARTRX(BARTRDA,102)=$E(BARTRX(BARTRDA,102),1,19)_"/"_$E($G(BARTRX(BARTRDA,103)),1,19)  ;bar*1.8*20
 .S BARTT=$S($G(BARTRX(BARTRDA,101))["REFUND":BARTRX(BARTRDA,101),$L($G(BARTRX(BARTRDA,102))):BARTRX(BARTRDA,102),1:$G(BARTRX(BARTRDA,101)))
 . S BARPRE=""
 . I BARTRX(BARTRDA,106)="e" S BARPRE="e "
 . I BARTT["PENDING" S BARPRE="* "
 . I BARTRX(BARTRDA,106)="e",BARTT["PENDING" S BARPRE="*e "
 . S BARTT=BARPRE_BARTT
 .W ?15,BARTT
 . I BARTT["REMARK" W ?45,BARTRX(BARTRDA,107)
 . I BARTT["NCPDP" W ?45,BARTRX(BARTRDA,108)
 .S (BARX,X)=$S($G(BARTRX(BARTRDA,2)):-BARTRX(BARTRDA,2),1:$G(BARTRX(BARTRDA,3)))
 .S X2=2
 .S X3=11
 .D COMMA^%DTC
 .I BARTT["PENDING" S X="**"_X_"**"
 .W ?54,X
 .N X
 .;I BARTT'["PENDING" D         ;IM15887 BAR*1.8*1
 .I BARTT'["PENDING"&(BARTT'["GENERAL") D
 .. S BARBAL=BARBAL+BARX
 . S X=BARBAL,X2=2,X3=11 D COMMA^%DTC
 . W ?68,X
 .;END IM15887
 .W !
 .W ?15,BARTRX(BARTRDA,6)          ; A/R Account
 .W ?45,BARBATCH
 .W ?67,$J(BARITEM,3,0)
 .;BEGIN BAR*1.8*SCR56,SCR58
 .I BARTRX(BARTRDA,14,"I")'="",(BARTRX(BARTRDA,15,"I")'="") D
 ..N IENS
 ..S IENS=BARTRX(BARTRDA,15,"I")_","_BARTRX(BARTRDA,14,"I")_","
 ..W !?15,$$GET1^DIQ(90051.1101,IENS,20,"E")  ;SCHEDULE #\IPAC
 ..K IENS
 ..;END BAR*1.8*SCR56,SCR58
 . I BARTT["REMARK" D
 . . S BARMKDSC=$$GET1^DIQ(90050.03,BARTRDA,"107:.02")
 . . W !?15,$E(BARMKDSC,1,40)
 . . I $L(BARMKDSC)>40 W !?15,$E(BARMKDSC,41,80)
 . I BARTT["NCPDP" D
 . . S BARNCPDP=$$GET1^DIQ(90050.03,BARTRDA,"108:.02")
 . . W !?15,$E(BARNCPDP,1,40)
 . . I $L(BARNCPDP)>40 W !?15,$E(BARNCPDP,41,80)
 .I $G(BARTRX(BARTRDA,110)) D
 ..S Y=BARTRX(BARTRDA,110) X ^DD("DD")
 ..W !?5,"REVERSAL DATE: ",Y  ;BAR*1.8*4 SCR56,SCR58
 ..W !?5,"REV TREASURY DEPOSIT NUMBER/IPAC: ",$G(BARTRX(BARTRDA,111))
 .I $G(BARTRX(BARTRDA,112))]"" W !?15,BARTRX(BARTRDA,112) ;MRS:BAR*1.8*4 SCR80 4.1.1
 .I BARTRX(BARTRDA,501)'="" W !?15,"PAYMENT CREDIT APPLIED TO: ",BARTRX(BARTRDA,501)    ;BAR*1.8*5 IHS/SD/TPF 6/17/2008
 .I BARTRX(BARTRDA,502)'="" W !?15,"PAYMENT CREDIT APPLIED FROM: ",BARTRX(BARTRDA,502)  ;BAR*1.8*5 IHS/SD/TPF 6/17/2008 
 Q:BARQ
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
HEAD ;
 W $$EN^BARVDF("IOF"),!
 S X="List of Transactions for Bill "_BARBL(.01)
 W ?80-$L(X)\2,X
 W !!,"Patient: "_BARBL(101),?45,"Beg DOS : "_BARBL(102)
 W !,"Address: "_$G(BARPTA(.111)),?45,"End DOS : "_BARBL(103)
 W !,$G(BARPTA(.114))_", "_$G(BARPTA(.115))_" "_$G(BARPTA(.116))
 W ?45,"LST STMT: "
 W !!,"Phone #: "_$G(BARPTA(.131)),?45,"Insurer: "_$G(BARBL(3))
 W !?45,"Balance: "_$J(BARBL(15),0,2)
 W !!,"Trans Dt",?11,"By",?15,"Trans Type",?57,"Amount",?70,"Balance"
 W !?15,"A/R Account",?45,"Batch",?67,"Item",!
 S BARDSH="",$P(BARDSH,"-",IOM)="" W BARDSH
 Q
 ; *********************************************************************
 ;
CHKLINE() ;
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+4)<IOSL Q 0
 I $E(IOST,1)="C" D  I 'Y Q 1
 .W !?(IOM-15),"continued==>"
 .D EOP^BARUTL(0)
 D HEAD
 Q 0
