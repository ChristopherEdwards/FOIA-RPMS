ABSPER2A ; IHS/FCS/DRS - Payable claims report ;  [ 09/12/2002  10:02 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Pharmacy Claim Payable Report (by Tran Date, Sorted by Insurer)
 ;----------------------------------------------------------------------
HEADER1 S PAGE=$G(PAGE)+1
 W @IOF ;D ^AUCLS
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
 D WCOLUMNS^ABSPOSU9(0,2,"Trans On:8,Claim ID:17,"_$P($G(^ABSP(9002313.99,PSIEN,2)),U,1)_" #:12,Patient Name:20,NDC #:13,Ingr Pd:7,Disp Pd:7,Total Pd:9,Pat Pay Amt:11,Rem Dedct:11",1)
 Q
 ;----------------------------------------------------------------------
PRINT ;EP - from ABSPER20
 N FLAG,INSNAME,TDATE,ANS,RESPIEN,MEDIEN,DATA,TRANSON,CLAIMID,PCN
 N PATNAME,NDC,INGRPD,DISPPD,TOTPD,PATPAY,REMDED
 N TINGRPD,TDISPPD,TTOTPD,TPATPAY,TREMDED
 ;
 ;I IOM<132 D  Q
 ;.D HEADER1
 ;.W !,"Device selected does not support 132 column reports.",!
 ;.D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 ;
 ;
 ;
 S FLAG=0,INSNAME=""
 F  D  Q:INSNAME=""!(FLAG)
 .S INSNAME=$O(^TMP($J,RPTNAME,INSNAME))
 .Q:INSNAME=""
 .S (TINGRPD,TDISPPD,TTOTPD,TPATPAY,TREMDED)=0
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
 ....S NDC=$P(DATA,U,4)
 ....S INGRPD=$P(DATA,U,5),TINGRPD=TINGRPD+$$CLIP^ABSPOSU9(INGRPD)
 ....S DISPPD=$P(DATA,U,6),TDISPPD=TDISPPD+$$CLIP^ABSPOSU9(DISPPD)
 ....S TOTPD=$P(DATA,U,7),TTOTPD=TTOTPD+$$CLIP^ABSPOSU9(TOTPD)
 ....S PATPAY=$P(DATA,U,8),TPATPAY=TPATPAY+$$CLIP^ABSPOSU9(PATPAY)
 ....S REMDED=$P(DATA,U,9),TREMDED=TREMDED+$$CLIP^ABSPOSU9(REMDED)
 ....I ($Y+2)>IOSL,'(IO=$P) D HEADER1,HEADER2
 ....I ($Y+2)>IOSL,(IO=$P) D
 .....S ANS=$$ENDPAGE^ABSPOSU5(0,DTIME)
 .....S:ANS=-1!(ANS="^") FLAG=1
 .....I 'FLAG D HEADER1,HEADER2
 ....D:'FLAG WDATA^ABSPOSU9(0,2,"TRANSON:8,CLAIMID:17,PCN:12,PATNAME:20,NDC:13,INGRPD:7,DISPPD:7,TOTPD:9,PATPAY:9,REMDED:11")
 .;PRINT Totals
 .I ($Y+3)>IOSL,'(IO=$P) D HEADER1,HEADER2
 .I ($Y+3)>IOSL,(IO=$P) D
 ..S ANS=$$ENDPAGE^ABSPOSU5(0,DTIME)
 ..S:ANS=-1!(ANS="^") FLAG=1
 ..I 'FLAG D HEADER1,HEADER2
 .Q:FLAG
 .W ?79,"-------  -------  ---------  -----------  -----------",!
 .W ?78,$J(TINGRPD,8,2)," ",$J(TDISPPD,8,2),"  ",$J(TTOTPD,9,2),"  ",$J(TPATPAY,11,2),"  ",$J(TREMDED,11,2),!
 ;
 Q:FLAG
 D:(IO=$P) PRESSANY^ABSPOSU5(1,DTIME)
 Q
