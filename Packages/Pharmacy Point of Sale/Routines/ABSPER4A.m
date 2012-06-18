ABSPER4A ; IHS/FCS/DRS - JWS 10:29 AM 17 Jul 1996 ;  [ 09/12/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Pharmacy Claim Rejection Report - CODE 40 - (by Tran Date, Sorted by Insurer)
 ;----------------------------------------------------------------------
HEADER1 S PAGE=$G(PAGE)+1
 W @IOF ;D ^AUCLS
 W $$LJBF^ABSPOSU9(SCRNTXT,IOM-10)_$$LJBF^ABSPOSU9("PAGE "_PAGE,10),!
 W $TR($J("",IOM)," ","-"),!
 Q
 ;----------------------------------------------------------------------
HEADER2 I '$D(PSIEN) N PSIEN S PSIEN=1
 W !
 W "Insurer:",?11,$$LJBF^ABSPOSU9(INSNAME,46)
 W ?61,"Help #:",?70,$$LJBF^ABSPOSU9($G(^TMP($J,RPTNAME,INSNAME)),20)
 W ?92,"Transmission Dates:"
 W ?113,$$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(SDATE),8)_" - "
 W $$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(EDATE),8),!
 ;D WCOLUMNS^ABSPOSU9(0,2,"Trans On:8,Claim ID:16,"_$P($G(^ABSP(9002313.99,PSIEN,2)),U,1)_" #:12,Patient Name:20,Cardholder ID:15,NDC #:13,Rejection Reason(s):36",1)
 D WCOLUMNS^ABSPOSU9(0,2,"Patient Name:20,"_$P($G(^ABSP(9002313.99,PSIEN,2)),U,1)_" #:12,MCAID #:15,Date Filled:8,Presc.#:12,NDC #:13,QTY:3,Days Supply:11,Charge:8",1)
 Q
 ;----------------------------------------------------------------------
PRINT ;EP - from ABSPER40
 N FLAG,INSNAME,TDATE,ANS,RESPIEN,MEDIEN,DATA,TRANSON,CLAIMID,VCN
 N PATNAME,CARDID,NDC,RJCTCNT,RJCTN,RJCTTEXT,CHG,MCAID,QTY,SUP
 I IOM<132 D  Q
 .D HEADER1
 .W !,"Device selected does not support 132 column reports.",!
 .D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 S FLAG=0,INSNAME=""
 F  D  Q:INSNAME=""!(FLAG)
 .S INSNAME=$O(^TMP($J,RPTNAME,INSNAME))
 .Q:INSNAME=""
 .D HEADER1,HEADER2
 .S TDATE=""
 .F  D  Q:'+TDATE!(FLAG)
 ..S TDATE=$O(^TMP($J,RPTNAME,INSNAME,TDATE))
 ..Q:'+TDATE
 ..S RESPIEN=""
 ..F  D  Q:'+RESPIEN!(FLAG)
 ...S RESPIEN=$O(^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN))
 ...Q:'+RESPIEN
 ...S MEDIEN=""
 ...F  D  Q:'+MEDIEN!(FLAG)
 ....S MEDIEN=$O(^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN))
 ....Q:'+MEDIEN
 ....S DATA=$G(^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN))
 ....S TRANSON=$$FM2MDY^ABSPOSU1(TDATE)
 ....S CLAIMID=$P(DATA,U,1)
 ....S VCN=$P(DATA,U,2)
 ....S PATNAME=$P(DATA,U,3)
 ....S CARDID=$P(DATA,U,4)
 ....S MCAID=999999
 ....S QTY="TST"
 ....S SUP="TST"
 ....S CHG=500
 ....S NDC=$P(DATA,U,5)
 ....S RJCTCNT=$P(DATA,U,6)
 ....F RJCTN=1:1:RJCTCNT D  Q:FLAG
 .....S RJCTTEXT=$G(^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN,RJCTN))
 .....S:RJCTTEXT="" RJCTTEXT="Undefined Error"
 .....I ($Y+2)>IOSL,'(IO=$P) D HEADER1,HEADER2
 .....I ($Y+2)>IOSL,(IO=$P),($E(IOST,1,1)="C") D
 ......S ANS=$$ENDPAGE^ABSPOSU5(0,DTIME)
 ......S:ANS=-1!(ANS="^") FLAG=1
 ......I 'FLAG D HEADER1,HEADER2
 .....D:'FLAG&(RJCTN=1) WDATA^ABSPOSU9(0,2,"PATNAME:20,VCN:12,MCAID:15,TDATE:8,MEDIEN:12,NDC:13,QTY:3,SUP:11,CHG:8")
 .....D:'FLAG&(RJCTN>1) WDATA^ABSPOSU9(96,0,"RJCTTEXT:36")
 Q:FLAG
 D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 Q
