ABSPES01 ; IHS/FCS/DRS - JWS 03:55 PM 28 Sep 1995 ;  [ 09/12/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Claim Submission Record List
 ;
 ;Parameters:
 ;   BITEMIEN  - Billing Item IEN (# 9002313.02)
 ;   GROOT     - Global root of resulting list (eg: "^LIST2($J")
 ;
 ;Returns:
 ;
 ;----------------------------------------------------------------------
 Q
EN1(BITEMIEN,GROOT) ;EP - from ABSPECZ2
 ;Manage local variables
 N DA,DA2,COUNT,DATA,CLAIMID,SENTON,VCPTIEN,VMEDIEN,DRUGIEN,QTY
 N DRUGNAME,RS,RDA,RXIEN,RXRFIEN,N57
 ;
 ;Make sure input variables are defined
 Q:$G(BITEMIEN)=""
 Q:$G(GROOT)=""
 ;
 K @(GROOT_")")
 S (COUNT,DA)=0
 F  D  Q:'+DA
 .S DA=$O(^ABSPC("AC",BITEMIEN,DA))
 .Q:'+DA
 .S DATA=$G(^ABSPC(DA,0))
 .S CLAIMID=$$LJBF^ABSPOSU9($P(DATA,U,1),16)
 .S SENTON=$$FM2EXT^ABSPOSU1($P($P(DATA,U,5),".",1))
 .S SENTON=$$LJBF^ABSPOSU9($S(SENTON="":"<Not Sent>",1:SENTON),11)
 .S DA2=0
 .F  D  Q:'+DA2
 ..S DA2=$O(^ABSPC(DA,400,DA2))
 ..Q:'+DA2
 ..S RDA=$O(^ABSPR("B",DA,""))
 ..S RS=$S(RDA="":"",1:$P($G(^ABSPR(RDA,1000,DA2,500)),U,1))
 ..S RS=$$RJBF^ABSPOSU9(RS,2)
 ..S VCPTIEN=$P($G(^ABSPC(DA,400,DA2,0)),U,2)
 ..S VMEDIEN=$S(VCPTIEN="":"",1:$P($G(^ABSVCPT(9002301,VCPTIEN,"SPEC")),U,2))
 ..I VCPTIEN="" S (RXIEN,RXRFIEN,N57)=""
 ..E  D
 ...N X S X=$G(^ABSVCPT(9002301,VCPTIEN,"SPEC"))
 ...S RXIEN=$P(X,U),RXRFIEN=$P(X,U,3),N57=$P(X,U,4)
 ..S DRUGIEN=$S(VMEDIEN="":"",1:$P($G(^AUPNVMED(VMEDIEN,0)),U,1))
 ..I DRUGIEN="",RXIEN]"" S DRUGIEN=$P($G(^PSRX(RXIEN,0)),U,6)
 ..S QTY=$S(VMEDIEN="":"",1:$P($G(^AUPNVMED(VMEDIEN,0)),U,6))
 ..I QTY="",RXIEN]"" D
 ...I RXRFIEN S QTY=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,4)
 ...E  S QTY=$P($G(^PSRX(RXIEN,0)),U,7)
 ..S QTY=$$RJBF^ABSPOSU9(QTY,4)
 ..S DRUGNAME=$S(DRUGIEN="":"Undefined",1:$P($G(^PSDRUG(DRUGIEN,0)),U,1))
 ..S DRUGNAME=$$LJBF^ABSPOSU9(DRUGNAME,29)
 ..S COUNT=COUNT+1
 ..S @(GROOT_",COUNT,""I"")")=DA_U_DA2_U_RDA
 ..S @(GROOT_",COUNT,""E"")")=CLAIMID_"  "_SENTON_"  "_RS_"  "_DRUGNAME_"  "_QTY
 S @(GROOT_",""Column Headers"")")="2|Claim ID:16,Date Sent:11,RS:2,Medication NAME:29,QTY:4"
 S @(GROOT_",0)")=COUNT
 Q
