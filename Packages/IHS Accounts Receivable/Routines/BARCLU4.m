BARCLU4 ; IHS/SD/LSL - COLLECTION BATCH PREPAYMENTS ;; 07/09/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;;
 ; 
 ; IHS/SD/TMM 06/18/2010 1.8*Patch 19 (M819), Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      BARCLU is a new routine adding Prepayment functionality to collection entry.
 ;      819_1. Display prepayments not assigned to a batch (^BARCLU,^BARCLU4)
 ;      819_2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      819_3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      819_4. Display prepayments matching payment type selected (^BARCLU,^BARCLU4)
 ;      819_5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU4,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      819_6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ; ********************************************************************* ;
 ;
 ;--->New Tag DISPPAY  ;M819*ADD*TMM*20100710 (819_1)
DISPPAY ;   Display all Prepayments not assigned to a collection batch
 D PPCLEAN
 I '$D(^BARPPAY(DUZ(2),"F","N")) Q    ;there are no unassigned prepayments
 W !!!!,"**PAYMENTS EXIST THAT HAVE NOT BEEN BATCHED. PLEASE REVIEW AND ADD TO A COLLECTION BATCH**"
 W !!
 I BARCLID(2,"I")'="A" Q     ;display only if Collection Point BATCH TYPE = ALL TYPES
 ; "F" = Index
 ; "N" = Prepayment BATCH FLAG 'N'ot Assigned to batch
 S BARCNTPP=0
 S BARPMTYP="" F  S BARPMTYP=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP)) Q:BARPMTYP=""  D
 . S BARPMTDT="" F  S BARPMTDT=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP,BARPMTDT)) Q:'BARPMTDT  D
 .. S BARPPIEN="" F  S BARPPIEN=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP,BARPMTDT,BARPPIEN)) Q:'BARPPIEN  D
 ... K BARPPAY            ;kill array so last DA is not used
 ... D BARPPAY^BARCLU1(BARPPIEN)    ;builds BARPPAY array
 ... S BARCNTPP=BARCNTPP+1
 ... S BARPPAMT=$J($FN(BARPPAY(.07),",",2),11) ;credit (payment amount)
 ... S BARPAYTY=$E(BARPPAY(.03),1,6)         ;payment type
 ... S BARPMTDI=BARPPAY(.02,"I")             ;payment date (FM format)
 ... S BARPMTMM=$E(BARPMTDI,4,5)
 ... S BARPMTDD=$E(BARPMTDI,6,7)
 ... S BARPMTYY=$E(BARPMTDI,1,3)+1700
 ... S BARPMTYY=$E(BARPMTYY,3,4)
 ... S BARPAYDT=BARPMTMM_"/"_BARPMTDD_"/"_BARPMTYY
 ... S BARECPT=$E(BARPPAY(.01),1,16)      ;receipt number
 ... S BARPTNM=$E(BARPPAY(.08),1,20)      ;patient name
 ... S BARPPCMT=$E($G(BARPPAY(101,1)),1,9)      ;comment line 1
 ... W !,BARCNTPP,".",?5,BARPPAMT,?17,BARPAYTY,?24,BARPAYDT,?33,BARECPT,?50,BARPTNM,?71,BARPPCMT
 W !
 D PAZ^BARRUTL    ;Press return to continue
 K BARPPAY
 Q
 ;
 Q
 ;
 ;--->New Tag SELPPAY  ;M819*ADD*TMM*20100710 (819_4)
SELPPAY ;	Display and select prepayments matching selected payment type
 ;----  51:EOB 52:CASH 53:CC 55:REFUND 81:CHECK
 D PPCLEAN
 ;M819*DEL*TMM*20100714***  K BARPP,BARPPAY
 S BARPMTYP=$S(BARX=52:"CA",BARX=53:"CC",BARX=81:"CK",1:"")
 I BARPMTYP="" Q    ;Payment Type not defined
 ;Stop prepayment processing if no unassigned prepayments
 I '$D(^BARPPAY(DUZ(2),"F","N",BARPMTYP)) D  Q:BARNOPP
 . ;Check for Debit Card entries in Prepayment file if batch payment type is Credit Card
 . S BARNOPP=1        ;no further checking if not a Credit Card payment type 
 . Q:BARPMTYP'="CC"
 . S BARNOPP=0
 . I '$D(^BARPPAY(DUZ(2),"F","N","DB")) S BARNOPP=1  ;check for debit prepayments
 I BARPMTYP'="CC" D
 . S BARCNTPP=0
 . S BARPMTDT="" F  S BARPMTDT=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP,BARPMTDT)) Q:'BARPMTDT  D
 .. D SELPPAY1  ;display matching prepayments (not Credits and Debits)
 I BARPMTYP="CC" D
 . S BARCNTPP=0
 . W !!
 . F BARPMTYP="CC","DB" D
 .. S BARPMTDT="" F  S BARPMTDT=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP,BARPMTDT)) Q:'BARPMTDT  D
 ... D SELPPAY1  ;display matching Credit and Debit prepayments
 . S BARPMTYP="CC"
 W !!
 ; Prompt for selection
 K DIR
 S DIR(0)="NAO^1:"_BARCNTPP
 S DIR("A")="Select Entry to batch or <Enter> to proceed:  "
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))
 Q:(Y="")
 S BARSELPP=Y         ;Line # of selected prepayment item
 ; 
 W !!
 S BARPPIEN=$G(BARPP(BARSELPP))
 S BARPPDAT=$G(BARPP(BARSELPP,BARPPIEN))
 S DIR("A",1)="You selected line "_BARSELPP
 S DIR("A",2)=" "
 S DIR("A",3)=BARSELPP_"."_BARPPDAT
 S DIR("A",4)=" "
 S DIR("A")="Are you sure this is what you want?  "
 S DIR("B")="YES"
 S DIR(0)="YA"
 D ^DIR
 I Y<1 G SELPPAY
 S BARPPSEL=1                   ;Prepayment item selected
 D BARPPAY^BARCLU1(BARPPIEN)    ;builds BARPPAY array
 Q
 ;
 ;--->New Tag SELPPAY1  ;M819*ADD*TMM*20100710 (819_4)
SELPPAY1 ;  Display and select prepayment for this batch item
 ; "F" = Index
 ; "N" = Prepayment BATCH FLAG 'N'ot Assigned to batch
 S BARPPIEN="" F  S BARPPIEN=$O(^BARPPAY(DUZ(2),"F","N",BARPMTYP,BARPMTDT,BARPPIEN)) Q:'BARPPIEN  D
 . K BARPPAY    ;kill array so last DA is not used
 . D BARPPAY^BARCLU1(BARPPIEN)    ;builds BARPPAY array
 . S BARCNTPP=BARCNTPP+1
 . S BARPPAMT=$J($FN(BARPPAY(.07),",",2),11) ;credit (payment amount)
 . S BARPAYTY=$E(BARPPAY(.03),1,6)         ;payment type
 . S BARPMTDI=BARPPAY(.02,"I")             ;payment date (FM format)
 . S BARPMTMM=$E(BARPMTDI,4,5)
 . S BARPMTDD=$E(BARPMTDI,6,7)
 . S BARPMTYY=$E(BARPMTDI,1,3)+1700
 . S BARPMTYY=$E(BARPMTYY,3,4)
 . S BARPAYDT=BARPMTMM_"/"_BARPMTDD_"/"_BARPMTYY
 . S BARECPT=$E(BARPPAY(.01),1,16)      ;receipt number
 . S BARPTNM=$E(BARPPAY(.08),1,20)      ;patient name
 . S BARPPCMT=$E($G(BARPPAY(101,1)),1,9)      ;comment line 1
 . W !,BARCNTPP,".",?5,BARPPAMT,?17,BARPAYTY,?24,BARPAYDT,?33,BARECPT,?50,BARPTNM,?71,BARPPCMT
 . S BARPP(BARCNTPP)=BARPPIEN
 . S BARPP(BARCNTPP,BARPPIEN)=BARPPAMT_" "_BARPAYTY_" "_BARPAYDT_" "_BARECPT_" "_BARPTNM_" "_BARPPCMT
 Q
 ;
PPUPDT ;  Update batch assignment fields in Prepayment file
 ;--->New Tag PPUPDT  ;M819*ADD*TMM*20100710 (819_4)
 K DIE,DR,DA
 S DR=".14////^S X=BARCLDA"      ;BATCH
 S DR=DR_";.15////^S X=BARITDA"      ;ITEM
 D NOW^%DTC
 S BARPPDTM=$P(%,".")
 S DR=DR_";.16////^S X=BARPPDTM"      ;ASSIGNED TO BATCH DT/TM
 S DR=DR_";.17////^S X=DUZ"      ;ASSIGNED TO BATCH BY USER
 ; .18 BATCH ASSIGNMENT field update is triggered when field 14 is updated
 ; Update Pre-Payment file
 S DA=BARPPIEN
 S DIE=$$DIC^XBDIQ1(90050.06)
 D ^DIE
 K DIE,DA,DR
 ;
PPUPDT1 ;Update Prepayment receipt # for batch item
 ;--->New Tag PPUPDT1  ;M819*ADD*TMM*20100710 (819_4)
 S BARDIC="^BARCOL(DUZ(2),"
 S DIE=BARDIC_BARCLDA_",1,"
 S DA=BARITDA
 S DA(1)=BARCLDA
 ;S DR="23////"_BARPPIEN
 S DR="23////^S X=BARPPIEN"
 D ^DIE
 D PPCLEAN
 Q
 ;
PPCLEAN ;  Clear Prepayment variables in Prepayment fields
 K BARCNTPP,BARECPT,BARNOPP,BARPAYDT,BARPAYTY,BARPMTDD,BARPMTDI,BARPMTDT
 K BARPMTMM,BARPMTYP,BARPMTYY,BARPP,BARPPAMT,BARPPAY,BARPPBDS,BARPPCMT,BARPPDTM
 K BARPPIEN,BARPPSEL,BARPTNM,BARSELPP,BARTMPBL,DICB,DICB2,DICB3
 Q
 ;
NEWITEM ;EP setup for auto adding a new item
 S X=BARCL(7)+1
 S BARCL(7)=X           ;last receipt #
 S DA(1)=BARCLDA
 S DIC="XL"
 S DIC("P")=$P(^DD(90051.01,101,0),U,2)
 S DIC="^BARCOL(DUZ(2),"_DA(1)_",1,"
 S DIC(0)="EXQML"
 ;
 ;   3 = Payment Type
 ;   4 = Date/time Stamp
 ;   20 = TDN/IPAC
 ;S DIC("DR")="3///NOW;4////^S X=DUZ"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S DIC("DR")="3///NOW;4////^S X=DUZ;20////"_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S DINUM=X
 K DD,DO
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO,DIC("P")
 I Y'>0 D  Q
 . W !!,"error in setting new entry",!!
 . D EOP^BARUTL(1)
 S BARITDA=+Y
 K DR,DIC,DIE,DA
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DIE=BARDIC_BARCLDA_",1,"
 Q
 ; *********************************************************************
