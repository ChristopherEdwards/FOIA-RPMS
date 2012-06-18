ABSPER20 ; IHS/FCS/DRS - Payable claims report ;  [ 09/12/2002  10:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Pharmacy Claim Payable Report (by Tran Date, Sorted by Insurer)
 ;----------------------------------------------------------------------
EN ; option ABSP PAYABLE REPORT
 N SCRNTXT,SDATE,EDATE,ANS,XBRP,J,XBNS,RPTNAME,PREFIXES
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S RPTNAME="RX Payable RPT"
 S SCRNTXT="Pharmacy Claim Payable Report (by Transmission Date)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 ;
 S PREFIXES=$$PREFIXES^ABSPER10 Q:"^"[PREFIXES  ; report which claims?
 ;
 ;Start Date Prompt
 S (SDATE,EDATE)=""
LP1 S ANS=$$DATE^ABSPOSU1("Transmission - Start Date:  ",SDATE,1,"","DT","E",DTIME)
 G:ANS=-1!(ANS="^")!(ANS="^^")!(ANS="") EXIT
 S SDATE=ANS
 ;
 ;End Date Prompt
LP2 S ANS=$$DATE^ABSPOSU1("Transmission - End Date:    ",EDATE,1,SDATE,"DT","E",DTIME)
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP1
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S EDATE=ANS
 ;
 S XBRP="RPT^ABSPER20"
 F J="SDATE","EDATE","SCRNTXT","RPTNAME","PREFIXES" S XBNS(J)=""
 D ^XBDBQUE
EXIT Q
 ;----------------------------------------------------------------------
RPT N PAGE
 U IO
 K ^TMP($J,RPTNAME)
 D SET
 D PRINT^ABSPER2A
 D ^%ZISC
 K ^TMP($J,RPTNAME)
 Q
 ;----------------------------------------------------------------------
SET N DATE1,DATE2,TDATE,RESPIEN,MEDIEN,CLAIMIEN,DATA,CLAIMID,INSIEN
 N INSNAME,INSHELP,BITEMIEN,PCN,PATNAME,NDC
 N INGRPD,DISPPD,TOTPD,PATPAY,REMDED,PSIEN S PSIEN=1
 ;
 S DATE1=$$CDTFM^ABSPOSU1(SDATE,-1)_".245959"
 S DATE2=EDATE_".245959"
 K ^TMP($J,RPTNAME)
 Q:IOM<132
 ;
 ;Loop through "AE" x-ref and gather responses within date range
 S TDATE=DATE1
 F  D  Q:TDATE=""!(TDATE>DATE2)
 .S TDATE=$O(^ABSPR("AE",TDATE))
 .Q:TDATE=""!(TDATE>DATE2)
 .S RESPIEN=0
 .F  D  Q:'+RESPIEN
 ..S RESPIEN=$O(^ABSPR("AE",TDATE,RESPIEN))
 ..Q:'+RESPIEN
 ..;Determine if response has paid items
 ..Q:'$D(^ABSPR("AC","P",RESPIEN))
 ..;Loop through payable index and get medication records
 ..S MEDIEN=0
 ..F  D  Q:'MEDIEN
 ...S MEDIEN=$O(^ABSPR("AC","P",RESPIEN,MEDIEN))
 ...Q:'+MEDIEN
 ...;Get needed data from 9002313.02 file
 ...S CLAIMIEN=$P($G(^ABSPR(RESPIEN,0)),U,1)
 ...Q:CLAIMIEN=""
 ...Q:'$D(^ABSPC(CLAIMIEN,0))
 ...S DATA=$G(^ABSPC(CLAIMIEN,0))
 ...S CLAIMID=$P(DATA,U,1)
 ...I PREFIXES]"",PREFIXES'[$E(CLAIMID) Q  ; but do we want this claim?
 ...S INSIEN=$P(DATA,U,2)
 ...Q:'+INSIEN
 ...S INSNAME=$P($G(^AUTNINS(INSIEN,0)),U,1)
 ...Q:INSNAME=""
 ...S INSHELP=$$INSHELP^ABSPER10(INSIEN)
 ...S BITEMIEN=$P(DATA,U,3)
 ...S PCN=$S(BITEMIEN="":"",$P($G(^ABSP(9002313.99,+$G(PSIEN),2)),U,1)="VCN":$P($G(^ABSBITMS(9002302,BITEMIEN,"VCN")),U,1),1:$P($G(^ABSBITMS(9002302,BITEMIEN,0)),U,1)) ;either PCN or VCN displays
 ...I PCN="" S PCN="RX# "_$$RXNUM
 ...S PATNAME=$P($G(^ABSPC(CLAIMIEN,1)),U,1)
 ...S DATA=$G(^ABSPC(CLAIMIEN,400,MEDIEN,400))
 ...S NDC=$P(DATA,U,7)
 ...;Get and format fields from 9002313.03 for Medication record
 ...S DATA=$G(^ABSPR(RESPIEN,1000,MEDIEN,500))
 ...; But if the claim has been successfully reversed, rig $ fields
 ...I $$REVERSED(RESPIEN,MEDIEN) D
 ....S (INGRPD,DISPPD,PATPAY,REMDED)=""
 ....S TOTPD="REVERSED"
 ...E  D
 ....S INGRPD=$J($$DFF2EXT^ABSPECFM($P(DATA,U,6)),7,2)
 ....S DISPPD=$J($$DFF2EXT^ABSPECFM($P(DATA,U,7)),7,2)
 ....S TOTPD=$J($$DFF2EXT^ABSPECFM($P(DATA,U,9)),9,2)
 ....S PATPAY=$J($$DFF2EXT^ABSPECFM($P(DATA,U,5)),9,2)
 ....S REMDED=$J($$DFF2EXT^ABSPECFM($P(DATA,U,13)),11,2)
 ...S ^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN)=CLAIMID_U_PCN_U_PATNAME_U_NDC_U_INGRPD_U_DISPPD_U_TOTPD_U_PATPAY_U_REMDED
 ...S ^TMP($J,RPTNAME,INSNAME)=INSHELP
 Q
RXNUM() ;EP - from ABSPER10,ABSPER30
 ; try to return external #; try to append refill # if nonzero
 ; given CLAIMIEN, MEDIEN pointers into ^ABSPC
 N X S X=+$P($G(^ABSPC(CLAIMIEN,400,MEDIEN,400)),U,2)
 I 'X Q ""
 I $D(^PSRX(X)) S X=$P(^PSRX(X,0),U)
 E  S X="`"_X
 N Y S Y=+$P($G(^ABSPC(CLAIMIEN,400,MEDIEN,400)),U,3)
 I Y S X=X_"r"_+Y
 Q X
REVERSED(RESPIEN,MEDIEN)     ; $$ = 1 if yes, = 0 if no
 ; It would be nice to use the numbering scheme - of attaching "R"
 ; to the CLAIMID - but we have a problem - what if you want to
 ; reverse two paid claims in the same CLAIMID.  That will have to
 ; be fixed, to append R and and the MEDIEN.  Separate issue, someday.
 ; F now, go through the POS file - if you find a successful 
 ; reversal with a reversal response higher than RESPIEN, then 
 ; it must have been reversed.
 N REVERSED S REVERSED=0
 N RXI S RXI=0
 N STOP S STOP=0
 F  S RXI=$O(^ABSPT("AF",RESPIEN,RXI)) Q:RXI=""  D  Q:STOP
 . I $P(^ABSPT(RXI,0),U,9)=MEDIEN S STOP=1 Q
 I RXI D  ; this prescription has this RESPIEN and position = MEDIEN
 . I '$G(^ABSPT(RXI,4)) Q  ; no reversal activity
 . ; Make sure the reversal has a response & it's earlier than 
 . ; this paid response:
 . I $P(^ABSPT(RXI,4),U,2)'>RESPIEN Q
 . N X S X=$$RXPAID^ABSPOSNC(RXI) ; convenient routine to query this
 . I $P(X,U,3)="Accepted reversal" S REVERSED=1
 Q REVERSED
