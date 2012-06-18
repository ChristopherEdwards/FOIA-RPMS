BAREDIT3 ; IHS/SD/LSL - CREATE AN ENTRY IN A/R EDI TRANSPORT FILE (3) ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 08/01/2002 - V1.7 Patch 4
 ;     For HIPAA compliance.  Make 835 v4010 entry in A/R EDI
 ;     TRANSPORT FILE.  This routine defines the Elements.
 ;
 ; ********************************************************************
 Q
 ; ********************************************************************
ELEMENT ; EP
 ; Create Element Multiple w/in Segment Multiple in A/R EDI TRANSPORT
 S BARELCNT=0
 F  D ELEMENT2  Q:BARELEM="END"
 Q
 ; ********************************************************************
ELEMENT2 ;
 ; Loop Elements
 S BARELCNT=BARELCNT+1
 S BARELEM=$P($T(@BARSEGID+BARELCNT),BARDELIM,2,9)
 Q:BARELEM="END"
 D ELEMENT3
 Q:'+BARELDA
 D:$P($P(BARELEM,BARDELIM,2)," ")="Composite" SUBELM^BAREDIT4
 Q
 ; ********************************************************************
ELEMENT3 ;
 ; Create Segment multiple entry in A/R EDI TRANSPORT File
 K DA,DIC,X,Y
 S DA(2)=BAREDITR
 S DA(1)=BARSEGDA
 S DIC="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S DIC(0)="LZ"
 S DIC("P")=$P(^DD(90056.0101,10,0),U,2)
 S X=$P(BARELEM,BARDELIM)
 S BARELID=X
 S BARPSTEL=$P(BARELEM,BARDELIM,8)
 I $P(BARSEG,BARDELIM)="2-060.B-REF",BARELID="REF02" S BARPSTEL="VVERMOD"
 I $P(BARSEG,BARDELIM)="3-040.B-REF",BARELID="REF02" S BARPSTEL="VPATHRN"
 I $P(BARSEG,BARDELIM)="2-080.A-N1",BARELID="N102" S BARPSTEL="VPAYER"
 I $P(BARSEG,BARDELIM)="2-100.A-N3" D
 . I BARELID="N301" S BARPSTEL="VPRADR"
 . I BARELID="N302" S BARPSTEL="VPRADR2"
 I $P(BARSEG,BARDELIM)="2-110.A-N4" D
 . I BARELID="N401" S BARPSTEL="VPRCITY"
 . I BARELID="N402" S BARPSTEL="VPRSTATE"
 . I BARELID="N403" S BARPSTEL="VPRZIP"
 I $P(BARSEG,BARDELIM)="2-080.B-N1",BARELID="N102" S BARPSTEL="VPAYEE"
 S DIC("DR")=".02///^S X=$P(BARELEM,BARDELIM,2)"
 S DIC("DR")=DIC("DR")_";.03///^S X=$P(BARELEM,BARDELIM,3)"
 S:$P(BARELEM,BARDELIM,4)]"" DIC("DR")=DIC("DR")_";.04///^S X=$P(BARELEM,BARDELIM,4)"
 S:$P(BARELEM,BARDELIM,5)]"" DIC("DR")=DIC("DR")_";.05///^S X=$P(BARELEM,BARDELIM,5)"
 S:$P(BARELEM,BARDELIM,6)]"" DIC("DR")=DIC("DR")_";.06///^S X=$P(BARELEM,BARDELIM,6)"
 S:$P(BARELEM,BARDELIM,7)]"" DIC("DR")=DIC("DR")_";.09///^S X=$P(BARELEM,BARDELIM,7)"
 S:BARPSTEL]"" DIC("DR")=DIC("DR")_";.08///^S X=BARPSTEL"
 K DD,DO
 D FILE^DICN
 Q:+Y<0
 S BARELDA=+Y
 Q
 ; ********************************************************************
 ; The following is a table of elements per Segment as the segments are
 ; ordered in 1^BAREDIT2
 ; ********************************************************************
 ;;ELEM;;DESC;;SEQ;;DATA TYPE;;MIN;;MAX;;EDI TBL PTR;;PST EL
 ; ********************************************************************
ISA ;;
 ;;ISA01;;Authorization Info Qualifier;;1;;ID;;2;;2;;1
 ;;ISA02;;Authorization Information;;2;;AN;;10;;10
 ;;ISA03;;Security Information Qualifier;;3;;ID;;2;;2;;2
 ;;ISA04;;Security Information;;4;;AN;;10;;10
 ;;ISA05;;Interchange ID Qualifier;;5;;ID;;2;;2;;3
 ;;ISA06;;Interchange Sender ID;;6;;AN;;15;;15
 ;;ISA07;;Interchange ID Qualifier;;7;;ID;;2;;2;;3
 ;;ISA08;;Interchange Receiver ID;;8;;AN;;15;;15
 ;;ISA09;;Interchange Date;;9;;DT;;6;;6
 ;;ISA10;;Interchange Time;;10;;TM;;4;;4
 ;;ISA11;;Control Standards Identifier;;11;;ID;;1;;1;;4
 ;;ISA12;;Control Version Number;;12;;ID;;5;;5;;5;;VVERNUM
 ;;ISA13;;Interchange Control Number;;13;;NO;;9;;9;;;;VCTRLNUM
 ;;ISA14;;Acknowlegment Requested;;14;;ID;;1;;1;;6;;VTEST
 ;;ISA15;;Usage Indicator;;15;;ID;;1;;1;;7
 ;;ISA16;;Component Element Seperator;;16;;AN;;1;;1
 ;;END
GS ;;
 ;;GS01;;Functional Identifier Code;;1;;ID;;2;;2;;8
 ;;GS02;;Application Sender's Code;;2;;AN;;2;;15
 ;;GS03;;Application Receiver's Code;;3;;AN;;2;;15
 ;;GS04;;Functional Group Creation Date;;4;;DT;;8;;8
 ;;GS05;;Functional Group Creation Time;;5;;TM;;4;;8
 ;;GS06;;Group Control Number;;6;;NO;;1;;9
 ;;GS07;;Responsible Agency Code;;7;;ID;;1;;2;;9
 ;;GS08;;Vers/Release/Industry ID Code;;8;;AN;;1;;12;;;;VVERSION
 ;;END
ST ;;
 ;;ST01;;Transaction Set Identify Code;;1;;ID;;3;;3;;10
 ;;ST02;;Transaction Set Control Number;;2;;AN;;4;;9
 ;;END
BPR ;;
 ;;BPR01;;Transaction Handling Code;;1;;ID;;1;;2;;11
 ;;BPR02;;Total Provider Payment;;2;;R;;1;;18
 ;;BPR03;;Credit/Debit Flag Code;;3;;ID;;1;;1;;12
 ;;BPR04;;Payment Method Code;;4;;ID;;3;;3;;13
 ;;BPR05;;Payment Format Code;;5;;ID;;1;;10;;14
 ;;BPR06;;DFI ID # Qualifier (sender);;6;;ID;;2;;2;;15
 ;;BPR07;;DFI ID # (sender);;7;;AN;;3;;12
 ;;BPR08;;Account # Qualifier (sender);;8;;ID;;1;;3;;16
 ;;BPR09;;Bank Account Number (sender);;9;;AN;;1;;35
 ;;BPR10;;Payer Identifier;;10;;AN;;10;;10
 ;;BPR11;;Payer Co. Supplimental Code;;11;;9;;9
 ;;BPR12;;DFI ID # Qualifier (receiver);;12;;ID;;2;;2;;15
 ;;BPR13;;DFI ID # (receiver);;13;;AN;;3;;12
 ;;BPR14;;Account # Qualifier (receiver);;14;;ID;;1;;3;;16
 ;;BPR15;;Bank Account Number (receiver);;15;;AN;;1;;35
 ;;BPR16;;Check Issue/EFT Effective Date;;16;;DT;;8;;8
 ;;END
TRN ;;
 ;;TRN01;;Trace Type Code;;1;;ID;;1;;2;;17
 ;;TRN02;;Check or EFT Trace NUmber;;2;;AN;;1;;30;;;;VCHECK
 ;;TRN03;;Payer Identifier;;3;;AN;;10;;10
 ;;TRN04;;Payer Supplimental Code;;4;;AN;;1;;30
 ;;END
CUR ;;
 ;;CUR01;;Entity Identifier Code;;1;;ID;;2;;3;;18
 ;;CUR02;;Currency Code;;2;;AN;;3;;3
 ;;CUR03;;Exchange Rate;;3;;R;;4;;10
 ;;END
REF ;;
 ;;REF01;;Reference ID Qualifier;;1;;ID;;2;;3;;19
 ;;REF02;;Reference Identification;;2;;AN;;1;;30;;;;VREFID
 ;;END
DTM ;;
 ;;DTM01;;Date/Time Qualifier;;1;;ID;;3;;3;;20
 ;;DTM02;;Date;;2;;DT;;8;;8;;;;VCLMDATE
 ;;END
N1 ;;
 ;;N101;;Entity Identifier Code;;1;;ID;;2;;3;;18
 ;;N102;;Payer/Payee Name;;2;;AN;;1;;60;;;;VPAYNAME
 ;;N103;;Identification Code Qualifier;;3;;ID;;1;;2;;21
 ;;N104;;Identification Code;;4;;AN;;2;;80
 ;;END
N3 ;;
 ;;N301;;Payer/Payee Address;;1;;AN;;1;;55
 ;;N302;;Payer/Payee Address;;2;;AN;;1;;55
 ;;END
N4 ;;
 ;;N401;;Payer/Payee City;;1;;AN;;2;;30
 ;;N402;;Payer/Payee State or Province;;2;;AN;;2;;2
 ;;N403;;Payer/Payee Postal Code;;3;;Nn;;3;;15
 ;;N404;;Payee Country Code;;4;;Nn;;2;;3
 ;;END
PER ;;
 ;;PER01;;Contact Function Code;;1;;ID;;2;;2;;22
 ;;PER02;;Contact Name;;2;;AN;;1;;60;;;;VPRCONAM
 ;;PER03;;Communication Number Qualifier;;3;;ID;;2;;2;;23;;VPRCONCD
 ;;PER04;;Contact Communication #;;4;;AN;;1;;80;;;;VPRCONBR
 ;;PER05;;Communication Number Qualifier;;5;;ID;;2;;2;;23;;VPRCONCD
 ;;PER06;;Contact Communication #;;6;;AN;;1;;80;;;;VPRCONBR
 ;;PER07;;Communication Number Qualifier;;5;;ID;;2;;2;;23;;VPRCONCD
 ;;PER08;;Contact Communication #;;6;;AN;;1;;80;;;;VPRCONBR
 ;;END
 ;;
LX ;;
 ;;LX01;;Assigned Loop Number;;1;;NO;;1;;6
 ;;END
TS3 ;;
 ;;TS301;;Provider Identifier;;1;;AN;;1;;30;;;;VNEWPRV
 ;;TS302;;Facility Type Code;;2;;AN;;1;;2
 ;;TS303;;Fiscal Period Date;;3;;DT;;8;;8
 ;;TS304;;Total Claim Count;;4;;R;;1;;15
 ;;TS305;;Total Submitted Charges ($);;5;;R;;1;;18
 ;;TS306;;Total Covered Charges ($);;6;;R;;1;;18
 ;;TS307;;Total Non-Covered Charges ($);;7;;R;;1;;18
 ;;TS308;;Total Denied Charges ($);;8;;R;;1;;18
 ;;TS309;;Total Provider Payment ($);;9;;R;;1;;18
 ;;TS310;;Total Interest ($);;10;;R;;1;;18
 ;;TS311;;Total Contractual Adjust ($);;11;;R;;1;;18
 ;;TS312;;Total Gramm-Rudman Reduct ($);;12;;R;;1;;18
 ;;TS313;;Total MSP Payer Amount ($);;13;;R;;1;;18
 ;;TS314;;Total Blood Deductable ($);;14;;R;;1;;18
 ;;TS315;;Total Non-Lab Charge ($);;15;;R;;1;;18
 ;;TS316;;Total Coinsurance Amount ($);;16;;R;;1;;18
 ;;TS317;;Total HCPCS Submitted Charges;;17;;R;;1;;18
 ;;TS318;;Total HCPCS Payable Amount ($);;18;;R;;1;;18
 ;;TS319;;Total Deductible Amount ($);;19;;R;;1;;18
 ;;TS320;;Total Prof Comp Amount ($);;20;;R;;1;;18
 ;;TS321;;Total MSP Pat Liability Met($);;21;;R;;1;;18
 ;;TS322;;Total Pat Reimbursement ($);;22;;R;;1;;18
 ;;TS323;;Total PIP Claim Count;;23;;R;;1;;18
 ;;TS324;;Total PIP Adjustment ($);;24;;R;;1;;18
 ;;END
TS2 ;;
 ;;TS201;;Total DRG Amount;;1;;R;;1;;18
 ;;TS202;;Total Federal Specific Amount;;2;;R;;1;;18
 ;;TS203;;Total Hospital Specific Amount;;3;;R;;1;;18
 ;;TS204;;Total Disproportionate Share;;4;;R;;1;;18
 ;;TS205;;Total Capital Amount;;5;;R;;1;;18
 ;;TS206;;Total Indirect Medical Edu Amt;;6;;R;;1;;18
 ;;TS207;;Total Outlier Day Count;;7;;R;;1;;15
 ;;TS208;;Total Day Outlier Amount;;8;;R;;1;;18
 ;;TS209;;Total Cost Outlier Amount;;9;;R;;1;;18
 ;;TS210;;Average DRG Length of Stay;;10;;R;;1;;15
 ;;TS211;;Total Discharge Count;;11;;R;;1;;15
 ;;TS212;;Total Cost Report Day Count;;12;;R;;1;;15
 ;;TS213;;Total Covered Day Count;;13;;R;;1;;15
 ;;TS214;;Total Non-Covered Day Count;;14;;R;;1;;15
 ;;TS215;;Total MSP Pass-Through Amt;;15;;R;;1;;18
 ;;TS216;;Average DRG Weight;;16;;R;;1;;15
 ;;TS217;;Total PPS Capital FSP DRG Amt;;17;;R;;1;;18
 ;;TS218;;Total PPS Capital HSP DRG Amt;;18;;R;;1;;18
 ;;TS219;;Total PPS DSH DRG Amount;;19;;R;;1;;18
 ;;END
CLP ;;
 ;;CLP01;;Patient Control Number;;1;;AN;;1;;38;;;;VNEWBILL
 ;;CLP02;;Claim Status Code;;2;;ID;;1;;2;;24
 ;;CLP03;;Total Submitted Charges ($);;3;;R;;1;;18;;;;VCLMCHG
 ;;CLP04;;Claim Payment Amount ($);;4;;R;;1;;18;;;;VCLMPAY
 ;;CLP05;;Patient Responsibility Amt ($);;5;;R;;1;;18
 ;;CLP06;;Claim Filing Indicator Code;;6;;ID;;1;;2;;25
 ;;CLP07;;Payer Claim Control Number;;7;;AN;;1;;30;;;;VBILNUM
 ;;CLP08;;Facility Type Code;;8;;AN;;1;;2
 ;;CLP09;;Claim Frequency Code;;9;;AN;;1;;1
 ;;CLP10;;Patient Status Cod (blank);;10;;AN;;1;;2
 ;;CLP11;;DRG Code;;11;;AN;;1;;4
 ;;CLP12;;DRG Weight;;12;;R;;1;;15
 ;;CLP13;;Discharge Fraction (%);;13;;R;;1;;10
 ;;END
CAS ;;
 ;;CAS01;;Claim Adjustment Group Code;;1;;ID;;1;;2;;26
 ;;CAS02;;Adjustment Reason Code;;2;;ID;;1;;5;;33;;VADJREA
 ;;CAS03;;Adjustment Amount;;3;;R;;1;;18;;;;VADJAMT
 ;;CAS04;;Adjustment Quantity;;4;;R;;1;;15
 ;;CAS05;;Adjustment Reason Code;;5;;ID;;1;;5;;33;;VADJREA
 ;;CAS06;;Adjustment Amount;;6;;R;;1;;18;;;;VADJAMT
 ;;CAS07;;Adjustment Quantity;;7;;R;;1;;15
 ;;CAS08;;Adjustment Reason Code;;8;;ID;;1;;5;;33;;VADJREA
 ;;CAS09;;Adjustment Amount;;9;;R;;1;;18;;;;VADJAMT
 ;;CAS10;;Adjustment Quantity;;10;;R;;1;;15
 ;;CAS11;;Adjustment Reason Code;;11;;ID;;1;;5;;33;;VADJREA
 ;;CAS12;;Adjustment Amount;;12;;R;;1;;18;;;;VADJAMT
 ;;CAS13;;Adjustment Quantity;;13;;R;;1;;15
 ;;CAS14;;Adjustment Reason Code;;14;;ID;;1;;5;;33;;VADJREA
 ;;CAS15;;Adjustment Amount;;15;;R;;1;;18;;;;VADJAMT
 ;;CAS16;;Adjustment Quantity;;16;;R;;1;;15
 ;;CAS17;;Adjustment Reason Code;;17;;ID;;1;;5;;33;;VADJREA
 ;;CAS18;;Adjustment Amount;;18;;R;;1;;18;;;;VADJAMT
 ;;CAS19;;Adjustment Quantity;;19;;R;;1;;15
 ;;END
NM1 ;;
 ;;NM101;;Entity Identifier Code;;1;;ID;;2;;3;;18
 ;;NM102;;Entity Type Qualifier;;2;;ID;;1;;1;;27
 ;;NM103;;Last / Organization Name;;3;;AN;;1;;35;;;;VPATLN
 ;;NM104;;First Name;;4;;AN;;1;;23;;;;VPATFN
 ;;NM105;;Middle Name;;5;;AN;;1;;25;;;;VPATMID
 ;;NM106;;Name Prefix (blank);;6;;AN;;1;;10
 ;;NM107;;Name Suffix;;7;;AN;;1;;10
 ;;NM108;;Identification Code Qualifier;;8;;ID;;1;;2;;21
 ;;NM109;;Identification Code;;9;;AN;;2;;80;;;;VPATHIC
 ;;END
MIA ;;
 ;;MIA01;;Covered Days;;1;;R;;1;;15
 ;;MIA02;;PPS Operating Outlier Amt;;2;;R;;1;;15
 ;;MIA03;;Lifetime Psychiatric Days;;3;;R;;1;;15
 ;;MIA04;;Claim DRG Amount ($);;4;;R;;1;;18
 ;;MIA05;;Remark Code;;5;;ID;;1;;30;;34
 ;;MIA06;;Disproportionate Share Amt;;6;;R;;1;;18
 ;;MIA07;;MSP Pass-through Amt ($);;7;;R;;1;;18
 ;;MIA08;;PPS-Capital Amount ($);;8;;R;;1;;18
 ;;MIA09;;PPS-Capital FSP DRG Amt ($);;9;;R;;1;;18
 ;;MIA10;;PPS-Capital HSP DRG Amt ($);;10;;R;;1;;18
 ;;MIA11;;PPS-Capital DSH DRG Amt ($);;11;;R;;1;;18
 ;;MIA12;;Old Capital Amount ($);;12;;R;;1;;18
 ;;MIA13;;PPS-Capital IME Amt ($);;13;;R;;1;;18
 ;;MIA14;;PPS/Hosp Specific DRG Amt ($);;14;;R;;1;;18
 ;;MIA15;;Cost Report Day Count;;15;;R;;1;;15
 ;;MIA16;;PPS/Operating Fed Spec DRG Amt;;16;;R;;1;;18
 ;;MIA17;;PPS-Capital Outlier Amt ($);;17;;R;;1;;18
 ;;MIA18;;Indirect Teaching Amount ($);;18;;R;;1;;18
 ;;MIA19;;Nonpayable Prof Comp Amt ($);;19;;R;;1;;18
 ;;MIA20;;Remark Code;;20;;ID;;1;;30;;34
 ;;MIA21;;Remark Code;;21;;ID;;1;;30;;34
 ;;MIA22;;Remark Code;;22;;ID;;1;;30;;34
 ;;MIA23;;Remark Code;;23;;ID;;1;;30;;34
 ;;MIA24;;PPS-Capital Exception Amt ($);;24;;R;;1;;18
 ;;END
MOA ;;
 ;;MOA01;;Reimbursement Rate (%);;1;;R;;1;;10
 ;;MOA02;;Claim HCPCS Payable Amt ($);;2;;R;;1;;18
 ;;MOA03;;Remark Code;;3;;ID;;1;;30;;34
 ;;MOA04;;Remark Code;;4;;ID;;1;;30;;34
 ;;MOA05;;Remark Code;;5;;ID;;1;;30;;34
 ;;MOA06;;Remark Code;;6;;ID;;1;;30;;34
 ;;MOA07;;Remark Code;;7;;ID;;1;;30;;34
 ;;MOA08;;Claim ESRD Payment Amt ($);;8;;R;;1;;18
 ;;MOA09;;Nonpayable Prof Comp Amt ($);;9;;R;;1;;18
 ;;END
AMT ;;
 ;;AMT01;;Amount Qualifier Code;;1;;ID;;1;;3;;28
 ;;AMT02;;Amount;;2;;R;;1;;18
 ;;END
QTY ;;
 ;;QTY01;;Quantity Qualifier;;1;;ID;;2;;2;;29
 ;;QTY02;;Quantity;;2;;R;;1;;15
 ;;END
SVC ;;
 ;;SVC01;;Composite Medical Procedure Id;;1;;AN;;2;;100
 ;;SVC02;;Line Item Charge Amt ($);;2;;R;;1;;18
 ;;SVC03;;Line Item Prov Paid Amt ($);;3;;R;;1;;18
 ;;SVC04;;Revenue Code;;4;;AN;;1;;48
 ;;SVC05;;Units of Service Paid (cnt);;5;;R;;1;;15
 ;;SVC06;;Composite Medical Procedure Id;;6;;AN;;2;;100
 ;;SVC07;;Orig Units of Service (cnt);;7;;R;;1;;15
 ;;END
LQ ;;
 ;;LQ01;;Remark Code List Qualifier;;1;;ID;;1;;3;;30
 ;;LQ02;;Remark Code (Line Level);;2;;AN;;1;;30
 ;;END
PLB ;;
 ;;PLB01;;Provider Identifier;;1;;AN;;1;;30;;;;VPRVNUM
 ;;PLB02;;Fiscal Period Date;;2;;DT;;8;;8
 ;;PLB03;;Composite Adjustment Id;;3;;AN;;2;;33
 ;;PLB04;;Provider Adjustment Amt;;4;;R;;1;;18
 ;;PLB05;;Composite Adjustment Id;;5;;AN;;2;;33
 ;;PLB06;;Provider Adjustment Amt;;6;;R;;1;;18
 ;;PLB07;;Composite Adjustment Id;;7;;AN;;2;;33
 ;;PLB08;;Provider Adjustment Amt;;8;;R;;1;;18
 ;;PLB09;;Composite Adjustment Id;;9;;AN;;2;;33
 ;;PLB10;;Provider Adjustment Amt;;10;;R;;1;;18
 ;;PLB11;;Composite Adjustment Id;;11;;AN;;2;;33
 ;;PLB12;;Provider Adjustment Amt;;12;;R;;1;;18
 ;;PLB13;;Composite Adjustment Id;;13;;AN;2;33
 ;;PLB14;;Provider Adjustment Amt;;14;;R;;1;;18
 ;;END
SE ;;
 ;;SE01;;Transaction Segment Count;;1;;NO;;1;;10
 ;;SE02;;Transaction Set Control Number;;2;;AN;;4;;9
 ;;END
GE ;;
 ;;GE01;;Functional Group Set Count;;1;;NO;;1;;6
 ;;GE02;;Group Control Number;;2;;NO;;1;;9
 ;;END
IEA ;;
 ;;IEA01;;Interchange Group Count;;1;;NO;;1;;5
 ;;IEA02;;Interchange Control Number;;2;;NO;;9;;9
 ;;END
