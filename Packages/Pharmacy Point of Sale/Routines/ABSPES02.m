ABSPES02 ; IHS/FCS/DRS - JWS 03:28 PM 6 Mar 1996 ;   [ 09/12/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Claim Response List by Response Code
 ;
 ;Parameters:
 ;   SDATE      - Start DATE (Internal FM Fmat)
 ;   EDATE      - End DATE (Internal FM Fmat)
 ;   RSPCODE    - Claim Response rejection type (R,P,C,D)
 ;   MAX        - MAXimum number of items returned in list
 ;   GROOT      - Global root of resulting list (eg: "^LIST2($J")
 ;
 ;Returns:
 ;
 ;----------------------------------------------------------------------
 Q
EN1(SDATE,EDATE,RSPCODE,MAX,GROOT) ;EP - from ABSPECZ3
 I $E(GROOT,$L(GROOT))="," S GROOT=$E(GROOT,1,$L(GROOT)-1) ; 03/12/2001
 ;Manage local variables
 N DA,DA2,COUNT,DATA,CLAIMID,SENTON,VCPTIEN,VMEDIEN,DRUGIEN,QTY
 N DRUGNAME,RS,TDATE,DATE1,DATE2,NDATE,RDA
 ;
 ;Make sure input variables are defined
 Q:$G(SDATE)=""
 Q:$G(EDATE)=""
 Q:$G(RSPCODE)=""
 Q:$G(MAX)=""
 Q:$G(GROOT)=""
 ;
 S DATE1=$$CDTFM^ABSPOSU1(SDATE,-1)_".245959"
 S DATE2=EDATE_".245959"
 K @(GROOT_")")
 S COUNT=0,NDATE=DATE1
 F  D  Q:NDATE=""!(NDATE>DATE2)!(COUNT=MAX)
 .S NDATE=$O(^ABSPC("AE",NDATE))
 .Q:NDATE=""
 .Q:NDATE>DATE2
 .S DA=0
 .F  D  Q:'+DA!(COUNT=MAX)
 ..S DA=$O(^ABSPC("AE",NDATE,DA))
 ..Q:'+DA
 ..S RDA=0
 ..F  S RDA=$O(^ABSPR("B",DA,RDA)) Q:'RDA  D
 ...Q:'$D(^ABSPR("AC",RSPCODE,RDA))
 ...S DATA=$G(^ABSPC(DA,0))
 ...S CLAIMID=$$LJBF^ABSPOSU9($P(DATA,U,1),16)
 ...S SENTON=$$FM2EXT^ABSPOSU1($P($P(DATA,U,5),".",1))
 ...S SENTON=$$LJBF^ABSPOSU9($S(SENTON="":"<Not Sent>",1:SENTON),11)
 ...S DA2=0
 ...F  D  Q:'+DA2
 ....S DA2=$O(^ABSPR("AC",RSPCODE,RDA,DA2))
 ....Q:'+DA2
 ....S RS=$S(RDA="":"",1:$P($G(^ABSPR(RDA,1000,DA2,500)),U,1))
 ....S RS=$$RJBF^ABSPOSU9(RS,2)
 ....S VCPTIEN=$P($G(^ABSPC(DA,400,DA2,0)),U,2)
 ....S VMEDIEN=$S(VCPTIEN="":"",1:$P($G(^ABSVCPT(9002301,VCPTIEN,"SPEC")),U,2))
 ....S DRUGIEN=$S(VMEDIEN="":"",1:$P($G(^AUPNVMED(VMEDIEN,0)),U,1))
 ....S QTY=$S(VMEDIEN="":"",1:$P($G(^AUPNVMED(VMEDIEN,0)),U,6))
 ....S QTY=$$RJBF^ABSPOSU9(QTY,4)
 ....S DRUGNAME=$S(DRUGIEN="":"Undefined",1:$P($G(^PSDRUG(DRUGIEN,0)),U,1))
 ....S DRUGNAME=$$LJBF^ABSPOSU9(DRUGNAME,29)
 ....S COUNT=COUNT+1
 ....S @(GROOT_",COUNT,""I"")")=DA_U_DA2_U_RDA
 ....S @(GROOT_",COUNT,""E"")")=CLAIMID_"  "_SENTON_"  "_RS_"  "_DRUGNAME_"  "_QTY
 S @(GROOT_",""Column Headers"")")="2|Claim ID:16,DATE Sent:11,RS:2,MEDication NAME:29,QTY:4"
 S @(GROOT_",0)")=COUNT
 Q
