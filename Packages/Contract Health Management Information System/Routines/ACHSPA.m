ACHSPA ; IHS/ITSC/PMF - DOCUMENT PAYMENT - DRIVER ;   [ 08/30/2004  2:28 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**4,5,11**;JUN 11, 2001
 ;3.1*4  loop through payment prompts until the user is done
 ;3.1*11 8.30.04 IHS/ITSC/FCJ TEST FOR LOCK OF NODE
 ;
A1 ;
 K ACHSBLKF,^UTILITY($J)
 ;
 ;CHECK IF THE REGISTER IS CLOSED HASN'T THIS BEEN DONE BEFORE?????
 ;
 ;The purpose of so many checks on the register is that once the
 ;register is closed, there can be no more money recording for the
 ;day.  So each function that might change the amount of money
 ;owed or paid is blocked this way.
 ;
 I $D(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",+ACHSFYWK(DUZ(2),ACHSCFY),0)),$P(^(0),U,2)=DT W !!,*7,"  The Register Has Been CLOSED -- Document Payment is cancelled.",!,"Please advise your supervisor!" I $$DIR^XBDIR("E","Press RETURN...") D END Q
 ;
 ;ACHS*3.1*4   3/29/02  pmf  add a loop here so that we continue
 ;             prompting until they are done
 N STOP S STOP=0 F  D A2 Q:STOP  ;  ACHS*3.1*4
 Q  ;  ACHS*3.1*4
 ;
 ;
A2 ;
 D ^ACHSUSC   ;DISPLAY DOCUMENT CANCEL/SUPPLEMENTAL INFO
 ;
 I '$D(ACHSDIEN) D END Q
 I $D(DTOUT) D END Q
 I $D(DUOUT) K DUOUT Q
 ;
 I $D(^ACHSF(DUZ(2),"D",ACHSDIEN,"PA")) W *7,!,"PAYMENT HAS ALREADY BEEN ENTERED.",!,"TRY ADJUSTMENT OPTION",!,"PAD    Payment Adjustment",!,"UNDER THE FACILITY MANAGEMENT MENU" G A2
        ;
 K ACHSBLKF,ACHSISAO
 ;
A3 ;EP - For automatic EOBR processing.
 K ACHSSET
 S ACHSX=+$P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,14)     ;FISCAL YEAR
 D FYCVT^ACHSFU                                      ;COMPUTE ACTUAL
                                                     ;FISCAL YEAR
 S ACHSACFY=ACHSY,ACHSACWK=+ACHSFYWK(DUZ(2),ACHSACFY)
 ;
 D CKB^ACHSUUP                                ;CHECK DCR BALANCE
                                              ;VS. TOTAL OBLIGATED FYTD
 ;
 ;IF REGS BALANCE OUT AND IS AREA OFFICE ERROR=REGISTERS OUT OF BAL;E  
 I $D(ACHSCNC),$D(ACHSISAO) S ACHSERRE=13,ACHSEDAT="" D ^ACHSEOBG S ACHSERRA=1
 ;
 I $D(ACHSCNC) D END Q        ;REGISTERS OUT OF BALANCE
 ;
 D SBTRN^ACHSPA0              ;SET NEW TRANS NODE, GET MAX, PAYMENTS ETC
 I $D(DUOUT) D END Q  ;ACHS*3.1*11 8.30.04 IHS/ITSC/FCJ TEST FOR LOCK OF NODE
 ;
 D ^ACHSPAZ:'$D(ACHSISAO)     ;ENTER SVDT,WKLD,FULP,3RDP,VAMT
 ;
 I $D(DTOUT) D END Q
 ;
 ;ACHS*3.1*4   3/29/02  pmf  no more GOing to the top.
 ;I $D(DUOUT)!'$D(ACHSSET),'$D(ACHSISAO) LOCK  G A1  ;  ACHS*3.1*4
 ;I $D(DUOUT)!'$D(ACHSSET),'$D(ACHSISAO) L  Q  ;  ACHS*3.1*4
 I $D(DUOUT)!'$D(ACHSSET),'$D(ACHSISAO) LOCK  Q  ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;
 I '$D(ACHSBLKF) D A6 Q               ;BYPASS INTERACTIVE
 I $D(ACHSISAO) D A6 Q                ;BYPASS INTERACTIVE
 ;
 ;ACHS*3.1*4   3/29/02  pmf  no more GOing to the top.  one
 ;             line changed, one line removed
 ;I '$D(ACHSISAO) D A6 W !! G A1  ;  ACHS*3.1*4
 I '$D(ACHSISAO) D A6 Q  ;  ACHS*3.1*4
 ;G A1  ;  ACHS*3.1*4
 Q
 ;
A6 ;
 ;
 D ^ACHSPA0                                  ;DOCUMENT PAYMENT CONTINUED
 ;
 D ENTER^ACHSPAM:'$D(ACHSISAO)&'$D(ACHSBLKF) ;DOCUMENT PAYMENT
                                             ;ENTER/EDIT MEDICAL DATA
 LOCK             ;UNLOCK ALL LOCKS THAT WE MAY HAVE FORGOT
 ;
 ;IF 'PRINT SUPPLEMENT DOCUMENTS' GO Update the P.O. document status
 ;in the RCIS REFERRAL file
 I $$DOC^ACHS(2,7) S ACHSREF=$$DOC^ACHS(2,7) D AUTH^ACHSBMC K ACHSREF
 I '$D(ACHSISAO) Q      ;W !! G A1      ;IF NOT AREA OFFIC
 ;
END ;
 LOCK
 K ACHSADDT,ACHSCONP,ACHSCAN,ACHSDIDT,ACHSDITY,ACHSDRG,ACHSSCC,ACHSCOPT,ACHSESDA,ACHSESDO,ACHSFDT,ACHSTDT,ACHSHON,ACHSORDN,ACHSBLKF,ACHSIPA,ACHSPROV,ACHSSIG,ACHSSVDT,ACHSWKLD,ACHSFULP,ACHS3RDP,ACHS3RDS,ACHSUSE,X,X1,X2
 K ACHSADJ
 I '$D(ACHSISAO) K ACHSDERR,ACHSEOBR,ACHSTDA,^UTILITY($J)
 ;
 ;  ACHS*3.1*4   3/29/02  pmf  add STOP var
 I $D(STOP) S STOP=1  ;  ACHS*3.1*4
 ;
 Q
 ;
