BARPST1 ; IHS/SD/LSL - Posting and Adjustments ; 07/10/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,21**;OCT 26, 2005
 ;
 ;
 ; IHS/SD/TMM 06/18/2010 1.8*19 Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      819_1. Display prepayments not assigned to a batch (^BARCLU)
 ;      819_2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      819_3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      819_4. Display prepayments matching payment type selected (^BARCLU)
 ;      819_5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      819_6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ; *********************************************************************
 ;
EN() ; EP
 ; Batch Posting entry
 K BARPAT,BARZ
 D SELBILL^BARPUTL
 I $G(BARZ) Q BARZ
 D ASKPAT^BARPUTL
 I $G(BARZ) Q BARZ
 D GETBIL^BARPUTL
 I $G(BARZ) Q BARZ
 Q 0
 ; *********************************************************************
 ;
TOP(BARV) ; EP
 ; Select Batch 
 W !!!
 W "Select Batch: "_$P(BARCOL(0),U,1)
 S Y=+BARCOL
 D BATW^BARPST
 D BBAL^BARPST(BARCOL)
 W !!,"Select Item: "_BARITM
 S Y=+BARITM
 D DICW^BARPST
 D IBAL^BARPST(BARITM)
 I $G(BAREOB) D
 .N DA
 .W !!
 .W "Select Visit Location: "
 .S DA=BAREOB
 .S DA(1)=+BARITM
 .S DA(2)=+BARCOL
 .W $$VAL^XBDIQ1(90051.1101601,.DA,.01)
 .D EBAL^BARPST(BAREOB)
 Q:'BARV
 W !!
 W "Select Patient: "_$P(BARPAT(0),U,1)
 Q
 ;
EN1(DICB,DICB2,DICB3) ; EP
 ;--->NEW TAG EN1--->  ;M819*ADD*TMM*20100711 (819_4)
 ; (Same as EN^BARPST1 but passes default DIC("B") values to ^BARPUTL
 ;
 ; Batch Posting entry
 K BARPAT,BARZ
 D SELBILLB^BARPUTL(DICB2)
 I $G(BARZ) Q BARZ
 D ASKPATB^BARPUTL(DICB)
 I $G(BARZ) Q BARZ
 D GETBILB^BARPUTL(DICB3)
 I $G(BARZ) Q BARZ
 Q 0
