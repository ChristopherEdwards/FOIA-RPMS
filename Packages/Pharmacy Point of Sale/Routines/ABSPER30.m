ABSPER30 ; IHS/FCS/DRS - JWS 10:33 AM 17 Jul 1996 ;    [ 09/12/2002  10:02 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Transmission STATUS Report (Claim Summary)
 ;----------------------------------------------------------------------
EN ;EP - option ABSP TRANS STATUS BY CLAIM
 N SCRNTXT,SDATE,EDATE,ANS,XBRP,J,XBNS,RPTNAME
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S RPTNAME="RX Claim STATUS RPT"
 S SCRNTXT="Transmission STATUS Report (Claim Summary)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
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
 S XBRP="RPT^ABSPER30"
 F J="SDATE","EDATE","SCRNTXT","RPTNAME" S XBNS(J)=""
 D ^XBDBQUE
EXIT Q
 ;----------------------------------------------------------------------
RPT N PAGE
 U IO
 K ^TMP($J,RPTNAME)
 D SORT
 D PRINT^ABSPER3A
 D ^%ZISC
 K ^TMP($J,RPTNAME)
 Q
 ;----------------------------------------------------------------------
SORT N DATE1,DATE2,TDATE,RESPIEN,MEDIEN,CLAIMIEN,DATA,CLAIMID,INSIEN
 N INSNAME,BITEMIEN,PCN,PATNAME,NDC,RX,FDATE,STATUS
 N DIALOUT S DIALOUT=1
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
 ..S MEDIEN=0
 ..F  D  Q:'MEDIEN
 ...S MEDIEN=$O(^ABSPR(RESPIEN,1000,MEDIEN))
 ...Q:'+MEDIEN
 ...;Get needed data from 9002313.02 file
 ...S CLAIMIEN=$P($G(^ABSPR(RESPIEN,0)),U,1)
 ...Q:CLAIMIEN=""
 ...Q:'$D(^ABSPC(CLAIMIEN,0))
 ...S DATA=$G(^ABSPC(CLAIMIEN,0))
 ...S CLAIMID=$P(DATA,U,1)
 ...S INSIEN=$P(DATA,U,2)
 ...Q:'+INSIEN
 ...S INSNAME=$P($G(^AUTNINS(INSIEN,0)),U,1)
 ...Q:INSNAME=""
 ...S BITEMIEN=$P(DATA,U,3)
 ...S PCN=$S(BITEMIEN="":"",$P($G(^ABSP(9002313.99,DIALOUT,2)),U,2)="VCN":$P($G(^ABSBITMS(9002302,BITEMIEN,"VCN")),U,1),1:$P($G(^ABSBITMS(9002302,BITEMIEN,0)),U,1)) ;either PCN or VCN displays
 ...I PCN="" S PCN="RX# "_$$RXNUM^ABSPER20
 ...S PATNAME=$P($G(^ABSPC(CLAIMIEN,1)),U,1)
 ...S DATA=$G(^ABSPC(CLAIMIEN,400,MEDIEN,400))
 ...S RX=$P(DATA,U,2)
 ...S NDC=$P(DATA,U,7)
 ...S DATA=$P($G(^ABSPC(CLAIMIEN,401)),U,1)
 ...S FDATE=$E(DATA,5,6)_"/"_$E(DATA,7,8)_"/"_$E(DATA,3,4)
 ...;G and format fields from 9002313.03 for Medication record
 ...S DATA=$G(^ABSPR(RESPIEN,1000,MEDIEN,500))
 ...I $P($G(^ABSPR(RESPIEN,100)),U,3)=11 D
 .... S STATUS=$P($G(^ABSPR(RESPIEN,500)),U)_" R" ; "A R" or "R R"
 ...E  S STATUS=$P(DATA,U,1) ; not reversal
 ...S STATUS=$S(STATUS="D":"Duplicate",STATUS="P":"Payable",STATUS="R":"Rejected",STATUS="C":"Captured",STATUS="A R":"Reversal",STATUS="R R":"RejectRev",1:"Undefined")
 ...S ^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN)=CLAIMID_U_PCN_U_PATNAME_U_FDATE_U_NDC_U_RX_U_STATUS
 Q
