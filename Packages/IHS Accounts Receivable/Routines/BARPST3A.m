BARPST3A ; IHS/SD/LSL - PAYMENT COMMAND CNT. ; 05/07/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4**;OCT 26, 2005
 ;** A/R posting program
 ;   continuation of command processing
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Don't allow PENDING category to affect balance
 ;
 ; ********************************************************************
 Q
 ;
SETTMP(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP,BAROAMT) ;EP - store & check amounts; HEAVILY MODIFIED;BAR*1.8*4 DD 4.1.7.2
 ;SEE SETTMPO BELOW FOR ORIGINAL CODE
 K BARFLG("BARWARN")
 S BARSTOP=0
 S BARDA=$O(^BARTMP($J,"B",BARLIN,""))
 Q:BARDA=""
 ; -------------------------------
B1 ;
 S BARBBAL=$P(^BARTMP($J,BARDA,BARLIN),U,5)
 I BARCAT'=21&(BARCAT'=22) D
 .S BARBBAL=BARBBAL+BAROAMT
 .D CKNEG^BARPST4(BARBBAL,BAROAMT,BARAMT)      ;CHECK FOR NEGATIVE BALANCES
 Q:BARSTOP
 I BARTYP="P" D  Q:BARSTOP
 .S $P(^BARTMP($J,BARDA,BARLIN),U,6)=$P($G(^BARTMP($J,BARDA,BARLIN)),U,6)+BARAMT
 .S BARPMT=BARPMT+BARAMT
 I BARTYP="A" D  Q:BARSTOP
 .S $P(^BARTMP($J,BARDA,BARLIN),U,7)=$P($G(^BARTMP($J,BARDA,BARLIN)),U,7)+BARAMT
 .S BARADJ=BARADJ+BARAMT
 I BARCAT'=21&(BARCAT'=22) D                   ;IF PENDING DON'T CHANGE BALANCE
 .S $P(^BARTMP($J,BARDA,BARLIN),U,5)=$P(^BARTMP($J,BARDA,BARLIN),U,5)-BARAMT
 S BARJ=$O(BARTR(BARLIN,""),-1)
 S BARJ=BARJ+1
 S BARTR(BARLIN,BARJ)=BARTYP_U_BARAMT_U_BARCAT_U_$G(BARATYP)_U_$G(REVERSAL)_U_$G(REVSCHED)  ;IHS/SD/TPF BAR*1.8*4 UFMS SCR56,SCR58
 K BAROAMT,BARBBAL
 Q
 ; *********************************************************************
HELP ;
 W $$EN^BARVDF("IOF"),!!
 W "Select one of the following: ",!
 W !?5,"P - Post transactions to A/R."
 W !?5,"M - More transaction processing."
 W !?5,"C - Cancel all transactions and start over."
 W !!,"This is a required response - Please select one to proceed!"
 D EOP^BARUTL(1)
 D HIT1^BARPST2(BARPASS),EOP^BARUTL(2)
 Q
 ;
 ; *********************************************************************
WARN(BARLVL,BARDIF)       ;EP - warner
 I BARLVL=4,'$$IHS^BARUFUT(DUZ(2)) K BARFLG("BARWARN") Q  ;BAR*1.8*4 DD 4.1.7.2
 I '$G(BARFLG("BARWARN")) W !
 W *7,!,"Warning - Posted amount exceeds the "
 ;W $S(BARLVL=1:"batch",BARLVL=2:"item",1:"location")_" balance." ;BAR*1.8*4 DD 4.1.7.2
 W $S(BARLVL=1:"BATCH",BARLVL=2:"ITEM",BARLVL=3:"LOCATION",1:"BILL")_" balance" ;BAR*1.8*4 DD 4.1.7.2
 W " by "_BARDIF_" amount"              ;BAR*1.8*4 DD 4.1.7.2
 S BARFLG("BARWARN")=1
 Q
 ;
 ; *********************************************************************
SETTMPO(BARTYP,BARAMT,BARLIN,BARCAT,BARATYP,BAROAMT) ;EP - store & check amounts;ORIGINAL CODE;BAR*1.8*4
 K BARFLG("BARWARN")
 S BARSTOP=0
 S BARDA=$O(^BARTMP($J,"B",BARLIN,""))
 Q:BARDA=""
 ; -------------------------------
B1O ;
 S BARBBAL=$P(^BARTMP($J,BARDA,BARLIN),U,5)  ;BAR*1.8*4 DD 4.1.7.2
 I BARTYP="P" D  Q:BARSTOP
 .I (BARBBAL-BARAMT)<0 D WARN(4,(BARBBAL-BARAMT))                 ;BAR*1.8*4 SDD 4.1.7.2
 .I +$G(BAREOB),(BAREOV(4)-(BARPMT+BARAMT))<0 D WARN(3,(BAREOV(4)-(BARPMT+BARAMT)))
 .I (BARITV(19)-(BARPMT+BARAMT))<0 D WARN(2,(BARITV(19)-(BARPMT+BARAMT)))
 .I (BARCLV(17)-(BARPMT+BARAMT))<0 D WARN(1,(BARCLV(17)-(BARPMT+BARAMT)))
 .I $G(BARFLG("BARWARN")) D  Q:BARSTOP
 ..K BARFLG("BARWARN")
 ..K DIR
 ..S DIR(0)="Y"
 ..S DIR("A")="ARE YOU SURE"
 ..S DIR("B")="NO"
 ..D ^DIR
 ..K DIR
 ..I Y'=1 S BARSTOP=1
 .S $P(^BARTMP($J,BARDA,BARLIN),U,6)=$P($G(^BARTMP($J,BARDA,BARLIN)),U,6)+BARAMT
 .S BARPMT=BARPMT+BARAMT
 I BARTYP="A" D  Q:BARSTOP
 .I (BARBBAL-BARAMT)<0 D WARN(4,(BARBBAL-BARAMT))              ;BAR*1.8*4 SDD 4.1.7.2
 .S $P(^BARTMP($J,BARDA,BARLIN),U,7)=$P($G(^BARTMP($J,BARDA,BARLIN)),U,7)+BARAMT
 .S BARADJ=BARADJ+BARAMT
 S:BARCAT'=21 $P(^BARTMP($J,BARDA,BARLIN),U,5)=$P(^BARTMP($J,BARDA,BARLIN),U,5)-BARAMT
 S BARJ=$O(BARTR(BARLIN,""),-1)
 S BARJ=BARJ+1
 ;S BARTR(BARLIN,BARJ)=BARTYP_U_BARAMT_U_BARCAT_U_$G(BARATYP)
 ;S BARTR(BARLIN,BARJ)=BARTYP_U_BARAMT_U_BARCAT_U_$G(BARATYP)_U_$G(REVERSAL)  ;IHS/SD/TPF BAR*1.8*3 UFMS
 S BARTR(BARLIN,BARJ)=BARTYP_U_BARAMT_U_BARCAT_U_$G(BARATYP)_U_$G(REVERSAL)_U_$G(REVSCHED)  ;IHS/SD/TPF BAR*1.8*4 UFMS SCR56,SCR58
 Q
 ; *********************************************************************
