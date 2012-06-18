ABSPER10 ; IHS/FCS/DRS - JWS 03:58 PM 16 Jul 1996 ;   [ 09/12/2002  10:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Pharmacy Claim Rejection Report (by Tran Date, SORTed by Insurer)
 ;----------------------------------------------------------------------
EN ; option ABSP REJECTION REPORT
 N SCRNTXT,SDATE,EDATE,ANS,XBRP,J,XBNS,RPTNAME,PREFIXES,POP
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S RPTNAME="RX RJCT RPT"
 S SCRNTXT="Pharmacy Claim Rejection Report (by Transmission Date)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 ;
 ; Prefixes
 S PREFIXES=$$PREFIXES Q:"^"[PREFIXES
 ;
 ;Start Date Prompt
 S (SDATE,EDATE)="; no, let it go through ; "
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
 D ^%ZIS Q:$G(POP)  G RPT ; queueing stuff fails at Sitka ; 04/13/2000
 S XBRP="RPT^ABSPER10"
 F J="SDATE","EDATE","SCRNTXT","RPTNAME","PREFIXES" S XBNS(J)=""
 D ^XBDBQUE
EXIT Q
 ;----------------------------------------------------------------------
RPT N PAGE
 U IO
 K ^TMP($J,RPTNAME)
 D SORT
 D PRINT^ABSPER1A
 D ^%ZISC
 K ^TMP($J,RPTNAME)
 Q
 ;----------------------------------------------------------------------
SORT N DATE1,DATE2,TDATE,RESPIEN,MEDIEN,CLAIMIEN,DATA,CLAIMID,INSIEN
 N INSNAME,INSHELP,BITEMIEN,PCN,PATNAME,CARDID,NDC
 N RJCTNEXT,RJCTCNT,RJCTIEN,RJCTTEXT,RJCTCODE,DIALOUT S DIALOUT=1
 ;
 S DATE1=$$CDTFM^ABSPOSU1(SDATE,-1)_".245959"
 S DATE2=EDATE_".245959"
 K ^TMP($J,RPTNAME)
 ; no, let it go through ; Q:IOM<132
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
 ..;Determine if response has rejections
 ..Q:'$DATA(^ABSPR("AC","R",RESPIEN))
 ..;Loop through rejection index and get medication records
 ..S MEDIEN=0
 ..F  D  Q:'MEDIEN
 ...S MEDIEN=$O(^ABSPR("AC","R",RESPIEN,MEDIEN))
 ...Q:'+MEDIEN
 ...;Get needed data from 9002313.02 file
 ...S CLAIMIEN=$P($G(^ABSPR(RESPIEN,0)),U,1)
 ...Q:CLAIMIEN=""
 ...Q:'$DATA(^ABSPC(CLAIMIEN,0))
 ...S DATA=$G(^ABSPC(CLAIMIEN,0))
 ...S CLAIMID=$P(DATA,U,1)
 ...I PREFIXES]"",PREFIXES'[$E(CLAIMID) Q  ; is it one of our claims?
 ...S INSIEN=$P(DATA,U,2)
 ...Q:'+INSIEN
 ...S INSNAME=$P($G(^AUTNINS(INSIEN,0)),U,1)
 ...Q:INSNAME=""
 ...S INSHELP=$$INSHELP(INSIEN)
 ...S BITEMIEN=$P(DATA,U,3)
 ...S PCN=$S(BITEMIEN="":"",$P($G(^ABSP(9002313.99,+$G(DIALOUT),2)),U,1)="VCN":$P($G(^ABSBITMS(9002302,BITEMIEN,"VCN")),U,1),1:$P($G(^ABSBITMS(9002302,BITEMIEN,0)),U,1)) ;either PCN or VCN displays
 ...I PCN="" S PCN="RX# "_$$RXNUM^ABSPER20 ;"RX# `"_+$P($G(^ABSPC(CLAIMIEN,400,MEDIEN,400)),U,2)
 ...S PATNAME=$P($G(^ABSPC(CLAIMIEN,1)),U,1)
 ...S DATA=$G(^ABSPC(CLAIMIEN,300))
 ...S CARDID=$P(DATA,U,2)
 ...S DATA=$G(^ABSPC(CLAIMIEN,400,MEDIEN,400))
 ...S NDC=$$FORMTNDC^ABSPOS9($P(DATA,U,7)) ; DRS; 04/13/2000
 ...;Get Rejection Reasons from 9002313.03 for Medication record
 ...S (RJCTNEXT,RJCTCNT)=0
 ...F  D  Q:'+RJCTNEXT
 ....S RJCTNEXT=$O(^ABSPR(RESPIEN,1000,MEDIEN,511,RJCTNEXT))
 ....Q:'+RJCTNEXT
 ....S RJCTIEN=+$G(^ABSPR(RESPIEN,1000,MEDIEN,511,RJCTNEXT,0))
 ....Q:RJCTIEN<1
 ....S RJCTTEXT=$P($G(^ABSPF(9002313.93,RJCTIEN,0)),U,2)
 ....S RJCTCODE=$P($G(^ABSPF(9002313.93,RJCTIEN,0)),U)
 ....Q:RJCTTEXT=""
 ....S RJCTCNT=RJCTCNT+1
 ....S ^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN,RJCTCNT)=RJCTCODE_":"_RJCTTEXT
 ...D
 ....N X S X=$G(^ABSPR(RESPIEN,1000,MEDIEN,504))
 ....N Y S Y=$G(^ABSPR(RESPIEN,1000,MEDIEN,526))
 ....I X]""!(Y]"") S RJCTCNT=RJCTCNT+1,^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN,RJCTCNT)=X_Y
 ...S ^TMP($J,RPTNAME,INSNAME,TDATE,RESPIEN,MEDIEN)=CLAIMID_U_PCN_U_PATNAME_U_CARDID_U_NDC_U_RJCTCNT
 ...S ^TMP($J,RPTNAME,INSNAME)=INSHELP
 Q
PREFIXES()         ;EP - from ABSPER20 and ABSPER10
 N DIR,DTOUT,DUOUT,X,Y S DIR(0)="FAO^1:10"
 S DIR("A")="Which claim ID prefixes to report? ",DIR("B")=$$PREFLIST
 I $L(DIR("B"))<2 Q DIR("B") ; don't bug 'em if it's obvious
 D ^DIR
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q X
INSHELP(IEN)       ;EP - from ABSPER20 and ABSPER10
 N % S %=$P($G(^ABSPEI(IEN,100)),U,5)
 I %]"" Q %
 N FMT S FMT=$P($G(^ABSPEI(IEN,100)),U)
 I FMT Q $P($G(^ABSPF(9002313.92,1)),U,5)
 Q ""
PREFLIST()         ; return a list of the prefixes in use
 N X,LIST S X="A",LIST=""
 F  D  Q:X=""
 . S X=$O(^ABSPC("B",X)) Q:X=""
 . S LIST=LIST_$E(X)
 . S X=$E(X)_"ZZZZZZZZZZZ"
 Q LIST
