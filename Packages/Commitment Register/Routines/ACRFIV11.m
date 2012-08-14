ACRFIV11 ;IHS/OIRM/DSD/THL,AEF - CREATE PAYMENT RECORDS IN 1166 PACKAGE;  [ 05/03/2005  9:55 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**3,16,17**;JUL 31, 2001
 ;ACR*2.1*16.06 THIS ROUTINE IS REWRITTEN
 ;
 ;CREATE NEW 1166 BATCHES AND SEQUENCE NO. ENTRIES
 ;
 ;CALLED FROM THE TOP BY; ^ACRFIV13 ;^ACRFPRC3 ;^ACRFRR11 ;^ACRFTA
 ;CODES COMMONLY USED: IV - Invoice; VV - Travel voucher; 
 ; ACRTERMS IS SET ONLY WHEN THERE IS A PENALTY OR DISCOUNT
 ; SET IN ROUTINES: ACRFDT, ACRFIV41, ACRFIV42, ACRFIV43
 ; ACRTADD IS SET FOR ACH ADDENDUM
 ;
1166 ;EP;TO CREATE 1166 RECORD IN 1166 PROGRAM
 F ACR=0:1:125,"A","B","C","D","E" K @("ACR"_ACR)
 ;N ACRA,ACRB,ACRC,ACRD,ACRE,ACRTADD,ACRCANDA,ACROBJDA,ACRINT ;ACR*2.1*17.01 IM17097
 N ACRA,ACRB,ACRC,ACRD,ACRE,ACRTADD,ACRCANDA,ACROBJDA,ACRINT,ACRMSG ;ACR*2.1*17.01 IM17097
 K ACRT
 D 11661
EXIT ;EP;CALLED BY ACRFPAY TO INIT VARIABLES
 K ACR,ACRIVDC,ACRIVPAY,ACRIVDIS,ACRVDA,ACRLBDT,ACREND
 K ACRFYFUN,ACRDOC,ACRDOC2,ACRGTA,ACRINV,ACRDT,ACRDTDA,ACRIP,ACRIVACP
 K ACRIVACT,ACRIVD,ACRIVDAT,ACRIVDIS,ACRIVIT,ACRIVT,ACRIVTF
 K ACRIVTX,ACRIVUP,ACRMAX,ACRLBDA,ACRNOTES,ACRPCNT,ACRPDA,ACRPEN,ACRPODA
 K ACRRCD,ACRRDATE,ACRRRDA,ACRRRDAT,ACRRRDT,ACRSS0,ACRSSACP,ACRSSACT
 K ACRSSDA,ACRSSDSC,ACRSSDT,ACRSSIT,ACRSSMAX,ACRSSNMS,ACRSSNO,ACRSST
 K ACRTCODE,ACRUC,ACRTXDA,ACRTERMS,ACRSSUP,ACRV11,ACRV13,ACRBEG
 F ACR=0:1:125,"A","B","C","D","E","P" K @("ACR"_ACR)
 Q
11661 ;LOCAL ENTRY;
 ;Q:$P(^ACRSYS(1,"DT1"),U,9)<1  ;FMS SYSTEM DEFAULT says not use;ACR*2.1*17.01 IM17097
 ;Q:'$D(^AFSLAFP(0))#2    ;No data in payment file;ACR*2.1*17.01 IM17097
 ;Q:'$D(ACRIVPAY)            ;Nothing to pay     ;ACR*2.1*17.01 IM17097
 ;D BCHECK^ACRFIV12          ;Returns batch info ;ACR*2.1*17.01 IM17097
 ;Q:$G(ACRBATDA)=""          ;No batch           ;ACR*2.1*17.01 IM17097
 S ACRDOC=$G(ACRDOC)                             ;ACR*2.1*17.01 IM17097
 I $P(^ACRSYS(1,"DT1"),U,9)<1 D  Q               ;ACR*2.1*17.01 IM17097
 .S ACRMSG="FMS SYSTEM DEFAULT file set to **not* use 1166 Approval for Payment"  ; ACR*2.1*17.01 IM17097
 .D FIN(ACRDOC,"",ACRMSG)                      ;ACR*2.1*17.01 IM17097
 I '$D(^AFSLAFP(0))#2 D  Q                     ;ACR*2.1*17.01 IM17097
 .S ACRMSG="FMS SYSTEM DEFAULT file not set up for 1166 Approval for Payments"  ; ACR*2.1*17.01 IM17097
 .D FIN(ACRDOC,"",ACRMSG)                      ;ACR*2.1*17.01 IM17097
 I '$D(ACRIVPAY) D  Q                          ;ACR*2.1*17.01 IM17097
 .S ACRMSG="No payments for this document"     ;ACR*2.1*17.01 IM17097
 .D FIN(ACRDOC,"",ACRMSG)                      ;ACR*2.1*17.01 IM17097
 ;
 D BCHECK^ACRFIV12
 ;
N1166 ;EP;      NON-ARMS/AIRLINE ENTRY POINT        ;ACR*2.1*17.01 IM17097
 I $G(ACRBATDA)="" D  Q                        ;ACR*2.1*17.01 IM17097
 .S ACRMSG="Batch entry not created "          ;ACR*2.1*17.01 IM17097
 .D FIN($G(ACRDOC),ACRBATDA,ACRMSG)            ;ACR*2.1*17.01 IM17097
 ;
 S ACRCANDA=0
 F  S ACRCANDA=$O(ACRIVPAY(ACRCANDA)) Q:'ACRCANDA  D
 .S ACROBJDA=0
 .F  S ACROBJDA=$O(ACRIVPAY(ACRCANDA,ACROBJDA)) Q:'ACROBJDA  D
 ..;I ACROBJDA=$P($G(^ACRSYS(1,400)),U,2),'$P($G(^ACRSYS(1,400)),U,4) Q  ;TRAVEL MGT FEE PMT  ; ACR*2.1*17.01 IM17097
 ..I ACRBTYP="T",ACROBJDA=$P($G(^ACRSYS(1,400)),U,2),'$P($G(^ACRSYS(1,400)),U,4) Q  ;NO TRAVEL MGT FEE PMT ON VOUCHERS  ; ACR*2.1*17.01 IM17097
 ..S ACRIVTF=ACRIVPAY(ACRCANDA,ACROBJDA)
 ..I $D(ACRIVDIS(ACRCANDA,ACROBJDA,"D")) D
 ...S ACRIVTF=ACRIVDIS(ACRCANDA,ACROBJDA)
 ...S ACRIVDC=ACRIVDIS(ACRCANDA,ACROBJDA,"D")
 ..S ACRINT=$G(ACRIVDIS(ACRCANDA,ACROBJDA,"P"))   ; Possible interest
 ..Q:ACRIVTF'>0
 ..D S11661
 ..I $P(ACRTERMS,U,14)]"" D MORE(ACROBJDA)   ;Check for penalty/discount
 ;
 ;D FIN(ACRDOC,ACRBATNO)                     ;ACR*2.1*17.01 IM17097
 D FIN(ACRDOC,ACRBATNO,.ACRMSG)              ;ACR*2.1*17.01 IM17097
 Q
S11661 ;----- PUT PAYMENT IN BATCH 
 ;
 S ACRSEQNO=$$NEWSEQ(ACRFYDA,ACRBATDA,.ACRDOCDA)
 ;Q:ACRSEQNO=""                              ;ACR*2.1*17.01 IM17097
 I ACRSEQNO="" D  Q                          ;ACR*2.1*17.01 IM17097
 .S ACRMSG="No Sequence Number for Batch "_ACRBATNO  ;ACR*2.1*17.01 IM17097
 .D FIN($G(ACRDOC),ACRBATNO,ACRMSG)          ;ACR*2.1*17.01 IM17097
 S ACRSEQDA=+ACRSEQNO
 ;
 D EN^ACRFIV13(.ACRA,.ACRB,.ACRC,.ACRD,.ACRE)  ;Retrieve variables
 ;
 D SET(ACRA,ACRB,ACRC,ACRD,ACRE)          ;Set AFSLAFP & open doc file
 ;
 D PAY                                    ;Set ACRPAY file
 Q
MORE(ACROLDOB) ;Now look for needed extra sets for discount or penalties
 N ACRX,ACRX2,ACROBJ,ACRTCODE,ACRP,ACROBJDA,ACRIVP,ACRIVPT
 S ACRP=$P(ACRTERMS,U,2)                ;Amount
 I +ACRP'>0 S ACRTERMS="" Q
 S ACRTCODE=$P(ACRTERMS,U,8)            ;Tran code for penalty/discount 
 S ACROBJ=$P(ACRTERMS,U,13)
 S ACRT=$P(ACRTERMS,U,14)               ;Type penalty/discount
 S ACROBJDA=$$OBJDA^ACRFUTL1(ACROBJ)
 I ACROBJDA="" S ACROBJDA=ACROLDOB
 S ACRIVP=$S(ACRT=-2:"Discount Lost",ACRT=-1:"Interest Penalty",1:"Discount Taken")
 S ACRIVPT=$S(ACRT=-2:2,ACRT=-1:3,1:1)
 ;
 I ACRIVP["Taken" D  Q                   ;Discount node of ACRDOC file
 .D UPDIS
 .D SS(ACRIVP,ACRP,ACROBJDA)             ;Set FMS SUPPLIES AND SERVICES
 .D DP(ACRP,ACRIVPT,ACRSEQNO)
 ;
 ;  GET NEW SEQUENCE, ACH ADDENDUM, SET INTO FILES
 D SS(ACRIVP,ACRP,ACROBJDA)              ;Set FMS SUPPLIES AND SERVICES
 D SETACH(ACRCANDA,ACROBJDA,ACRTCODE,ACRP,.ACRSEQNO)
 D DP(ACRP,ACRIVPT,ACRSEQNO)
 ;
 Q
 ;FIN(ACRDOC,ACRBATNO)         ;OLD SUB-ROUTINE; CLOSING MESSAGE  ; ACR*2.1*17.01 IM17097
 ;W !!,"Document No. ",ACRDOC
 ;W !,"Has been placed in Batch No. ",ACRBATNO
 ;D PAUSE^ACRFWARN
 ;Q
FIN(ACRDOC,ACRBATNO,ACRMSG) ; CLOSING MESSAGE  ;NEW SUB-ROUTINE ACR*2.1*17.01 IM17097
 W !!,"Document No. ",ACRDOC
 I $D(ACRMSG) W !,ACRMSG K ACRT S ACRQUIT=""
 I $G(ACRBATNO)]"" D
 .W !,"Has been placed in Batch No. ",ACRBATNO
 I $G(ACRBATNO)']"" D
 .W !,"Has **not** been placed in Batch "
 D PAUSE^ACRFWARN
 Q
 ;
SETACH(ACRCANDA,ACROBJDA,ACRTCODE,ACRP,ACRSEQNO) ;LOCAL ENTRY
 ;CREATE ADDITIONAL ENTRY FOR INTEREST PENALTY PAYMENT
 S ACRIVTF=0
 S ACRSEQNO=$$NEWSEQ(ACRFYDA,ACRBATDA,ACRDOCDA)
 Q:ACRSEQNO=""                                  ;No sequence in AFSLAFP
 S ACRX=$$EN^ACRFACH(ACRDOCDA,ACRDOC,.ACRTERMS,ACRTCODE,ACRREF)
 S ACRSEQDA=+ACRSEQNO
 S ACRP=$$17^ACRFIV13(ACRP)
 S $P(ACRA,U)=ACRSEQNO                          ;Replace SEQ NO
 S $P(ACRA,U,8)=ACROBJDA
 S $P(ACRA,U,11)=ACRP                           ;Set payment amount
 S $P(ACRA,U,18)=ACRTCODE                       ;Replace trans code
 S $P(ACRB,U,6)=ACRP                            ;Set to interest amt
 S $P(ACRC,U,2)=ACRX                            ;Reset ACH Addendum
 S $P(ACRE,U,2)=ACRP
 D PAY:$G(ACRDOCDA)                             ;Set ACRPAY
 D SET(ACRA,ACRB,ACRC,ACRD,ACRE)                ;Set AFSLAFP
 S ACRTERMS=""                                  ;ONLY PROCESS ONCE
 Q
 ;
NEWSEQ(ACRFYDA,ACRBATDA,ACRDOCDA) ;LOCAL ENTRY 
 ;ADD NEW SEQUENCE ENTRY TO BATCH
 S ACRSEQNO=""
 D SEQNO^ACRFIV12(ACRFYDA,ACRBATDA,.ACRSEQNO)
 I $G(ACRSEQNO)="" Q ACRSEQNO
 S X=ACRSEQNO
 S DA(2)=ACRFYDA
 S DA(1)=ACRBATDA
 S DIC="^AFSLAFP("_ACRFYDA_",1,"_ACRBATDA_",1,"
 S DIC(0)="L"
 S DIC("DR")="2////"_DUZ
 S:$G(ACRDOCDA) DIC("DR")=DIC("DR")_";.02////"_ACRDOCDA
 I '$D(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,0)) D
 .S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,0)="^9002325.02"
 D FILE^ACRFDIC
 I Y<1 S ACRSEQNO=""
 Q ACRSEQNO
 ;
SET(ACRA,ACRB,ACRC,ACRD,ACRE)                           ;LOCAL ENTRY TO SET FILE
 S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,0)=ACRA
 S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,1)=ACRB
 S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,2)=ACRC
 S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,3)=ACRD
 S ^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,100)=ACRE
 K ACRBEG,ACREND
 S ACRDT=ACRA
 S DA(2)=ACRFYDA
 S DA(1)=ACRBATDA
 S DA=ACRSEQDA
 S DIK="^AFSLAFP("_DA(2)_",1,"_DA(1)_",1,"
 D IX1^ACRFDIC
 ;
 ;UPDATE THE OPEN DOCUMENT RECORD
 I '$D(ACRFY)#2 S ACRFY=$P(^AFSLAFP(ACRFYDA,0),U)
 D ODOC
 Q
 ;
PAY ;LOCAL ENTRY; CREATE ENTRY IN ARMS APPROVALS FOR PAYMENT FILE
 S X=$S($G(ACRPAYDA):ACRPAYDA,1:DT)
 S DIC="^ACRPAY("
 S DIC(0)="L"
 S DIC("DR")=".02////"_$G(ACRDOCDA)
 S DIC("DR")=DIC("DR")_";.05////"_DUZ
 S DIC("DR")=DIC("DR")_";.06////"_DT
 S DIC("DR")=DIC("DR")_";50////"_$G(ACR50)
 S DIC("DR")=DIC("DR")_";51////"_$G(ACR51)
 D FILE^ACRFDIC
 Q:+Y<1
 S (DA,ACRPDA)=+Y
 S ^ACRPAY(+Y,"DT")=$P(ACRDT,U,1,25)_U_U_U_$P(ACRDT,U,28)
 S ^ACRPAY(+Y,1)=ACRB
 S ^ACRPAY(+Y,2)=ACRC
 S ^ACRPAY(+Y,3)=ACRD
 S DIK="^ACRPAY("
 D IX1^ACRFDIC
 Q
 ;
DP(ACRTMP2,ACRTMP3,ACRSEQNO) ;LOCAL ENTRY
 ; CREATE ENTRY IN FMS PAYMENT DISCOUNT/PENALTIES FILE
 ; ENTERS WITH ACRTMP2=AMOUNT OF DISCOUNT, DISCOUNT LOST, INTEREST
 ;             ACRTMP3  1= DISCOUNT TAKEN
 ;                      2= DISCOUNT LOST
 ;                      3= INTEREST PENALTY
 S X=ACRSEQNO
 S DIC="^ACRDP("
 S DIC(0)="L"
 S ACRTMP=".02////"_$G(ACRDOCDA)
 S ACRTMP=ACRTMP_";.03////"_ACRPDA
 S ACRTMP=ACRTMP_";.04////"_$G(ACRPAYDA)
 S ACRTMP=ACRTMP_";.05////"_DUZ
 S ACRTMP=ACRTMP_";1////"_ACRTMP3
 S ACRTMP=ACRTMP_";2////"_ACRTMP2
 S DIC("DR")=ACRTMP
 D FILE^ACRFDIC
 Q
 ;
ODOC ;LOCAL ENTRY; UPDATE OPEN DOCUMENT RECORD
 N ACRDOCX
 S ACRDFYDA=$O(^AFSLODOC("B",ACRFYFUN,0))
 Q:'ACRDFYDA
 S X=+ACRSEQNO
 S DA(2)=ACRDFYDA
 S ACRDOCX=$E("0000000000",1,10-$L(ACRDOC))_ACRDOC
 S DA(1)=$$GETODOC(ACRDOCX)
 Q:'DA(1)
 S ACRODDA=DA(1)
 ;I '$D(^AFSLODOC(DA(1),1,DA(1),1,0)) D            ;ACR*2.1*3.04
 I '$D(^AFSLODOC(DA(2),1,DA(1),1,0)) D             ;ACR*2.1*3.04
 .S ^AFSLODOC(DA(2),1,DA(1),1,0)="^9002325.3111A"  ;ACR*2.1*3.04
 S DIC="^AFSLODOC("_DA(2)_",1,"_DA(1)_",1,"
 S DIC(0)="L"
 S DIC("DR")=".05////"_ACRBATNO
 S DIC("DR")=DIC("DR")_";1////"_ACRPAYDA
 S DIC("DR")=DIC("DR")_";2////"_$$DOL^ACRFUTL(ACRIVTF)
 S DIC("DR")=DIC("DR")_";3////"_ACR58
 S DIC("DR")=DIC("DR")_";5////"_$G(ACRPDFOR)
 S DIC("DR")=DIC("DR")_";6////A"
 S DIC("DR")=DIC("DR")_";8////"_ACRSEQNO
 D FILE^ACRFDIC
 ;I +Y>0 D UPDT(+Y,ACRFYDA,ACRODDA,ACRTCODE,ACR17) ;OPEN DOCUMENT INTERFACE  ;ACR*2.1*3.04
 I +Y>0 D UPDT(+Y,ACRDFYDA,ACRODDA,ACRTCODE,ACR17) ;OPEN DOCUMENT INTERFACE  ;ACR*2.1*3.04
 Q
 ;
UPDT(Y,ACRFYDA,ACRODDA,ACRTCODE,ACR17) ;
 ;----- UPDATE OPEN DOCUMENT DATABASE
 ;
 N DA,DIE,DR,X
 S DA(1)=ACRFYDA
 S DA=ACRODDA
 S DIE="^AFSLODOC("_DA(1)_",1,"
 S DR="17////"_DT_";18////"_$G(ACRTCODE)_";19////"_$$DOL^ACRFUTL($G(ACR17))
 D ^DIE
 D BAL^ACRFODOC(ACRFYDA,ACRODDA)
 Q
 ;
GETODOC(D) ;LOCAL ENTRY
 N X,Y,Z
 S X=0
 F  S X=$O(^AFSLODOC(ACRDFYDA,1,"B",D,X)) Q:'X  S Y=X
 K D
 Q $G(Y)
 ;
SS(ACRX,ACRY,ACROBJDA) ;LOCAL ENTRY; ENTER INTEREST PAYMENT INTO FMS SUPPLIES & SERVICES
 ;  ENTERS WITH ACRX = KEY WORD = "INTEREST PAYMENT"
 ;                           OR = "DISCOUNT TAKEN"
 ;                           OR = "DISCOUNT LOST"
 ;              ACRY = AMOUNT
 ;             ACROBJDA = OBJECT CLASS CODE IEN
 Q:$G(ACRDOCDA)=""
 S X=1
 S DIC="^ACRSS("
 S DIC(0)="L"
 S DIC("DR")=".02////"_ACRDOCDA
 S DIC("DR")=DIC("DR")_";.03////"_ACRDOCDA
 S DIC("DR")=DIC("DR")_";.04////"_ACROBJDA
 S DIC("DR")=DIC("DR")_";.05////"_ACRCANDA
 S DIC("DR")=DIC("DR")_";.06////"_ACRLBDA
 S DIC("DR")=DIC("DR")_";.07////"_ACRDOCDA
 S DIC("DR")=DIC("DR")_";.1///617"
 S DIC("DR")=DIC("DR")_";.2////"_ACRDOCDA
 S DIC("DR")=DIC("DR")_";5////"_ACRX            ;KEY WORD
 S DIC("DR")=DIC("DR")_";10////1"
 S DIC("DR")=DIC("DR")_";11///EA"
 S DIC("DR")=DIC("DR")_";12////"_ACRY
 S DIC("DR")=DIC("DR")_";13////"_ACRY
 S DIC("DR")=DIC("DR")_";14////1"
 S DIC("DR")=DIC("DR")_";15////1"
 S DIC("DR")=DIC("DR")_";16////"_ACRY
 S DIC("DR")=DIC("DR")_";16.1////"_ACRY
 D FILE^ACRFDIC
 Q
 ;
UPDIS ;LOCAL ENTRY; CREATE ENTRY IN FMS DOCUMENT FILE AT ,70 NODE (DISCOUNT)
 Q:ACRDOCDA'>0
 N ACRTMP,DA,ACRPCENT,ACRAMT,ACRRRNUM
 S DA(1)=ACRDOCDA
 S (DIE,DIC)="^ACRDOC("_DA(1)_",70,"
 S DIC("P")=$P(^DD(9002196,70,0),U,2)
 S DIC(0)="L"
 S X=+ACRTERMS
 D FILE^ACRFDIC
 Q:Y=-1
 S ACRPCENT=$P(ACRTERMS,U,3)
 S ACRAMT=$P(ACRTERMS,U,2)
 S ACRRRNUM=$P($G(ACRRR0),U,4)
 S DA=+Y
 S ACRTMP=".02////"_ACRPCENT
 S ACRTMP=ACRTMP_";.03////1"               ;HARDCODED 1=APPLIED DISCOUNT
 S ACRTMP=ACRTMP_";.04////"_ACRRRNUM       ;RECEIVING REPORT NUMBER
 S ACRTMP=ACRTMP_";.05////"_ACRAMT
 S DR=ACRTMP
 D DIE^ACRFDIC
 Q