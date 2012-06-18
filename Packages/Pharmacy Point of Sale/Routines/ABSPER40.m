ABSPER40 ; IHS/FCS/DRS - JWS 03:58 PM 16 Jul 1996 ;   [ 09/12/2002  10:02 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Transmission STATUS Report (Billing Item Summary)
 ;----------------------------------------------------------------------
EN ; option ABSP TRANS STATUS BITEM
 N SCRNTXT,SDATE,EDATE,ANS,XBRP,J,XBNS,RPTNAME
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S RPTNAME="RX BItem STATUS RPT"
 S SCRNTXT="Transmission STATUS Report (Billing Item Summary)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 ;
 ;Start Date Prompt
 S (SDATE,EDATE)=""
LP1 S ANS=$$DATE^ABSPOSU1("Visit Date - Start Date:  ",SDATE,1,"","DT","E",DTIME)
 G:ANS=-1!(ANS="^")!(ANS="^^")!(ANS="") EXIT
 S SDATE=ANS
 ;
 ;End Date Prompt
LP2 S ANS=$$DATE^ABSPOSU1("Visit Date - End Date:    ",EDATE,1,SDATE,"DT","E",DTIME)
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP1
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S EDATE=ANS
 ;
 S XBRP="RPT^ABSPER40"
 F J="SDATE","EDATE","SCRNTXT","RPTNAME" S XBNS(J)=""
 D ^XBDBQUE
EXIT Q
 ;----------------------------------------------------------------------
RPT N PAGE
 U IO
 K ^TMP($J,RPTNAME)
 D SORT
 D PRINT^ABSPER4A
 D ^%ZISC
 K ^TMP($J,RPTNAME)
 Q
 ;----------------------------------------------------------------------
SORT N DATE1,DATE2,TDATE,RESPIEN,MEDIEN,CLAIMIEN,DATA,CLAIMID,INSIEN
 N INSNAME,BITEMIEN,PCN,PATNAME,FDATA,RX,NDC,TRANSON,STATUS,VDATE
 N FDATE,PSIEN S PSIEN=1
 ;
 S DATE1=$$DTF1^ABSPECFM($$CDTFM^ABSPOSU1(SDATE,-1))
 S DATE2=$$DTF1^ABSPECFM(EDATE)
 K ^TMP($J,RPTNAME)
 Q:IOM<132
 ;
 ;Loop through "AF" x-ref and gather claims within date range
 S VDATE=DATE1
 F  D  Q:VDATE=""!(VDATE>DATE2)
 .S VDATE=$O(^ABSPC("AF",VDATE))
 .Q:VDATE=""!(VDATE>DATE2)
 .S CLAIMIEN=0
 .F  D  Q:'+CLAIMIEN
 ..S CLAIMIEN=$O(^ABSPC("AF",VDATE,CLAIMIEN))
 ..Q:'+CLAIMIEN
 ..;Get needed data from 9002313.02 file
 ..S DATA=$G(^ABSPC(CLAIMIEN,0))
 ..S CLAIMID=$P(DATA,U,1)
 ..S INSIEN=$P(DATA,U,2)
 ..Q:'+INSIEN
 ..S INSNAME=$P($G(^AUTNINS(INSIEN,0)),U,1)
 ..Q:INSNAME=""
 ..S BITEMIEN=$P(DATA,U,3)
 ..S PCN=$S(BITEMIEN="":"",$P($G(^ABSP(9002313.99,+$G(PSIEN),2)),U,1)="VCN":$P($G(^ABSBITMS(9002302,BITEMIEN,"VCN")),U,1),1:$P($G(^ABSBITMS(9002302,BITEMIEN,0)),U,1)) ;either PCN or VCN displays
 ..S PATNAME=$P($G(^ABSPC(CLAIMIEN,1)),U,1)
 ..S DATA=$P($G(^ABSPC(CLAIMIEN,401)),U,1)
 ..S FDATE=$E(DATA,5,6)_"/"_$E(DATA,7,8)_"/"_$E(DATA,3,4)
 ..S MEDIEN=0
 ..F  D  Q:'MEDIEN
 ...S MEDIEN=$O(^ABSPC(CLAIMIEN,400,MEDIEN))
 ...Q:'+MEDIEN
 ...S DATA=$G(^ABSPC(CLAIMIEN,400,MEDIEN,400))
 ...S RX=$P(DATA,U,2)
 ...S NDC=$P(DATA,U,7)
 ...;
 ...I $D(^ABSPR("B",CLAIMIEN))=0 D  Q
 ....S ^TMP($J,RPTNAME,INSNAME,PCN,CLAIMIEN,0,MEDIEN)=CLAIMID_U_PATNAME_U_FDATE_U_NDC_U_RX_U_"Not Sent"_U_""
 ...I $D(^ABSPR("B",CLAIMIEN))'=0 D  Q
 ....S RESPIEN=0
 ....F  D  Q:'+RESPIEN
 .....S RESPIEN=$O(^ABSPR("B",CLAIMIEN,RESPIEN))
 .....Q:'+RESPIEN
 .....S TRANSON=$P($G(^ABSPR(RESPIEN,0)),U,2)
 .....S TRANSON=$$FM2MDY^ABSPOSU1(TRANSON)
 .....S DATA=$G(^ABSPR(RESPIEN,1000,MEDIEN,500))
 .....S STATUS=$P(DATA,U,1)
 .....S STATUS=$S(STATUS="D":"Duplicate",STATUS="P":"Payable",STATUS="R":"Rejected",STATUS="C":"Captured",1:"Undefined")
 .....S ^TMP($J,RPTNAME,INSNAME,PCN,CLAIMIEN,RESPIEN,MEDIEN)=CLAIMID_U_PATNAME_U_FDATE_U_NDC_U_RX_U_TRANSON_U_STATUS
 Q
