ABSPER3A ; IHS/FCS/DRS - JWS 10:27 AM 17 Jul 1996 ;   [ 09/12/2002  10:02 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Transmission STATUS Report (Claim Summary)
 ;----------------------------------------------------------------------
HEADER1 S PAGE=$G(PAGE)+1
 W @IOF ; D ^AUCLS
 W $$LJBF^ABSPOSU9(SCRNTXT,IOM-10)_$$LJBF^ABSPOSU9("PAGE "_PAGE,10),!
 W $TR($J("",IOM)," ","-"),!
 Q
 ;----------------------------------------------------------------------
HEADER2 I '$D(PSIEN) N PSIEN S PSIEN=1
 W !
 W "Insurer:",?11,$$LJBF^ABSPOSU9(INSNAME,46)
 W ?92,"Transmission Dates:"
 W ?113,$$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(SDATE),8)_" - "
 W $$LJBF^ABSPOSU9($$FM2MDY^ABSPOSU1(EDATE),8),!
 W !
 D WCOLUMNS^ABSPOSU9(0,2,"Trans On:8,Claim ID:18,"_$P($G(^ABSP(9002313.99,PSIEN,2)),U,1)_" #:12,Patient Name:20,Vst Date:8,NDC #:13,RX #:8,STATUS:9",1)
 Q
 ;----------------------------------------------------------------------
PRINT ;EP - from ABSPER30
 N FLAG,INSNAME,TDATE,ANS,RESPIEN,MEDIEN,DATA,TRANSON,CLAIMID,PCN
 N PATNAME,NDC,RX,STATUS,FDATE
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
 ....S FDATE=$P(DATA,U,4)
 ....S NDC=$P(DATA,U,5)
 ....S RX=$P(DATA,U,6)
 ....S STATUS=$P(DATA,U,7)
 ....I ($Y+2)>IOSL,'(IO=$P) D HEADER1,HEADER2
 ....I ($Y+2)>IOSL,(IO=$P) D
 .....S ANS=$$ENDPAGE^ABSPOSU5(0,DTIME)
 .....S:ANS=-1!(ANS="^") FLAG=1
 .....I 'FLAG D HEADER1,HEADER2
 ....D:'FLAG WDATA^ABSPOSU9(0,2,"TRANSON:8,CLAIMID:19,PCN:12,PATNAME:20,FDATE:8,NDC:13,RX:8,STATUS:9")
 Q:FLAG
 D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 Q
