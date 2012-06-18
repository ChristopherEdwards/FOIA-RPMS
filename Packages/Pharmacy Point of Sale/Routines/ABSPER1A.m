ABSPER1A ; IHS/FCS/DRS - JWS 10:23 AM 17 Jul 1996 ;   [ 09/12/2002  10:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Pharmacy Claim Rejection Report (by Tran Date, Sorted by Insurer)
 ;----------------------------------------------------------------------
HEADER1 S PAGE=$G(PAGE)+1
 I $Y>0 W @IOF ; D ^XBCLS
 W $$LJBF^ABSPOSU9(SCRNTXT,IOM-10)_$$LJBF^ABSPOSU9("PAGE "_PAGE,10),!
 W $TR($J("",IOM)," ","-"),!
 Q
 ;----------------------------------------------------------------------
HEADER2 I '$D(PSIEN) S PSIEN=1
 W !
 W "Insurer:",?11,$$LJBF^ABSPOSU9(INSNAME,46)
 W ?61,"Help #:",?70,$$LJBF^ABSPOSU9($G(^TMP($J,RPTNAME,INSNAME)),20)
 W ?92,"Transmission Dates:"
 W ?113,$$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(SDATE),8)_" - "
 W $$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(EDATE),8),!
 W !
 D WCOLUMNS^ABSPOSU9(0,2,"Trans On:8,Claim ID:17,"_$P($G(^ABSP(9002313.99,PSIEN,2)),U,1)_" #:12,Patient Name:20,Cardholder ID:15,NDC #:13,Rejection Reason(s):36",1)
 Q
 ;----------------------------------------------------------------------
PRINT ;EP - from ABSPER10
 N FLAG,INSNAME,TDATE,ANS,RESPIEN,MEDIEN,DATA,TRANSON,CLAIMID,PCN
 N PATNAME,CARDID,NDC,RJCTCNT,RJCTN,RJCTTEXT
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
 ....S PCN=$P(DATA,U,2)
 ....S PATNAME=$P(DATA,U,3)
 ....S CARDID=$P(DATA,U,4)
 ....S NDC=$P(DATA,U,5)
 ....S RJCTCNT=$P(DATA,U,6)
 ....F RJCTN=1:1:$S(RJCTCNT:RJCTCNT,1:1) D  Q:FLAG
 .....S RJCTTEXT=$G(^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN,RJCTN))
 .....S:RJCTTEXT="" RJCTTEXT="" ;"Undefined Error"
 .....I ($Y+2)>IOSL,'(IO=$P) D HEADER1,HEADER2
 .....I ($Y+2)>IOSL,(IO=$P) D
 ......S ANS=$$ENDPAGE^ABSPOSU5(0,DTIME)
 ......S:ANS=-1!(ANS="^") FLAG=1
 ......I 'FLAG D HEADER1,HEADER2
 .....D:'FLAG&(RJCTN=1) WDATA^ABSPOSU9(0,2,"TRANSON:8,CLAIMID:17,PCN:12,PATNAME:20,CARDID:15,NDC:13,RJCTTEXT:36")
 .....D:'FLAG&(RJCTN>1) WDATA^ABSPOSU9(96,0,"RJCTTEXT:36")
 Q:FLAG
 D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 Q
