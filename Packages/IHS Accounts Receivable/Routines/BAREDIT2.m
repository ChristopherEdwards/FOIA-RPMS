BAREDIT2 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI TRANSPORT FILE (2) ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 08/01/2002 - V1.7 Patch 4
 ;     For HIPAA compliance.  Make 835 v4010 entry in A/R EDI
 ;     TRANSPORT FILE.  This routine defines the Segments.
 ;
 ; ********************************************************************
 Q
 ; ********************************************************************
SEGMENT ; EP
 ; Create Segment Multiple in A/R EDI TRANSPORT File
 S BARSGCNT=0
 F  D SEGMENT2  Q:BARSEG="END"
 Q
 ; ********************************************************************
SEGMENT2 ;
 ; Loop Segments
 S BARSGCNT=BARSGCNT+1
 S BARSEG=$P($T(@1+BARSGCNT),BARDELIM,2,8)
 Q:BARSEG="END"
 D SEGMENT3
 Q:'+BARSEGDA
 D ELEMENT^BAREDIT3
 Q
 ; ********************************************************************
SEGMENT3 ;
 ; Create Segment multiple entry in A/R EDI TRANSPORT File
 K DA,DIC,X,Y
 S DA(1)=BAREDITR
 S DIC="^BAREDI(""1T"","_DA(1)_",10,"
 S DIC(0)="LZ"
 S DIC("P")=$P(^DD(90056.01,10,0),U,2)
 S X=$P(BARSEG,BARDELIM)
 S BARSEGID=$P(BARSEG,BARDELIM,2)
 S DIC("DR")=".02///^S X=BARSEGID"
 S DIC("DR")=DIC("DR")_";.03///^S X=$P(BARSEG,BARDELIM,3)"
 S DIC("DR")=DIC("DR")_";.04///^S X=$P(BARSEG,BARDELIM,4)"
 S:$P(BARSEG,BARDELIM,5)]"" DIC("DR")=DIC("DR")_";.05///^S X=$P(BARSEG,BARDELIM,5)"
 S:$P(BARSEG,BARDELIM,6)]"" DIC("DR")=DIC("DR")_";.06///^S X=$P(BARSEG,BARDELIM,6)"
 K DD,DO
 D FILE^DICN
 Q:+Y<0
 S BARSEGDA=+Y
 Q
 ; ********************************************************************
 ; Level Mark = a flag signifying loop on that Segment
 ; Max Use    = the number of times segment repeats if >1
 ;              in accordance with the implementation guide.
 ;              If the guide said >1, I used 99, otherwise # in guide
 ; pst flag   = This segment has posting elements
 ; ********************************************************************
1 ;;Seg name;;Seg ID;;Seg Desc;;Position;;Level Mark;;Max use;;pst flag
 ;;0-010-ISA;;ISA;;Interchange Control Header;;0-010;;;;;;1
 ;;1-010-GS;;GS;;Functional Group Header;;1-010;;1;;;;1
 ;;2-010-ST;;ST;;Transaction Set Header;;2-010;;1
 ;;2-020-BPR;;BPR;;Beginning Seg for Payment/RA;;2-020
 ;;2-040-TRN;;TRN;;Reassociation Trace Number;;2-040;;;;;;1
 ;;2-050-CUR;;CUR;;Foreign Currency Information;;2-050
 ;;2-060.A-REF;;REF;;Receiver Identification;;2-060.A
 ;;2-060.B-REF;;REF;;Version Identification;;2-060.B;;;;;;1
 ;;2-070-DTM;;DTM;;Production Date;;2-070
 ;;2-080.A-N1;;N1;;Payer Name;;2-080.A;;1;;;;1
 ;;2-100.A-N3;;N3;;Payer Address;;2-100.A
 ;;2-110.A-N4;;N4;;Payer City, State, Zip;;2-110.A
 ;;2-120.A-REF;;REF;;Additional Payer Id;;2-120.A;;;;4
 ;;2-130-PER;;PER;;Payer Contact Information;;2-130
 ;;2-080.B-N1;;N1;;Payee Name;;2-080.B;;1;;;;1
 ;;2-100.B-N3;;N3;;Payee Address;;2-100.B
 ;;2-110.B-N4;;N4;;Payee City, State, Zip;;2-110.B
 ;;2-120.B-REF;;REF;;Additional Payee Id;;2-120.B;;;;99
 ;;3-003-LX;;LX;;Loop Indicator;;3-003;;1
 ;;3-005-TS3;;TS3;;Provider Summary Information;;3-005;;;;;;1
 ;;3-007-TS2;;TS2;;Provider Supplimental Summary;;3-007
 ;;3-010-CLP;;CLP;;Claim Level Payments;;3-010;;1;;;;1
 ;;3-020-CAS;;CAS;;Claim Level Adjustments;;3-020;;;;99;;1
 ;;3-030.A-NM1;;NM1;;Patient Name;;3-030.A;;;;;;1
 ;;3-030.B-NM1;;NM1;;Insured Name;;3-030.B
 ;;3-030.C-NM1;;NM1;;Corrected Patient/Insured;;3-030.C
 ;;3-030.D-NM1;;NM1;;Service Provider Name;;3-030.D
 ;;3-030.E-NM1;;NM1;;Crossover Carrier Name;;3-030.E
 ;;3-030.F-NM1;;NM1;;Corrected Priority Payer Name;;3-030.F;;;;2
 ;;3-033-MIA;;MIA;;MCR Inpatient Adjudication;;3-033
 ;;3-035-MOA;;MOA;;MCR Outpatient Adjudication;;3-035
 ;;3-040.A-REF;;REF;;Other Claim Related Id;;3-040.A;;;;5;;1
 ;;3-040.B-REF;;REF;;Rendering Provider Id;;3-040.B;;;;10
 ;;3-050-DTM;;DTM;;Claim Date;;3-050;;;;4;;1
 ;;3-060-PER;;PER;;Claim Contact Info;;3-060;;;;3
 ;;3-062-AMT;;AMT;;Claim Suppl Info ($$);;3-062;;;;14
 ;;3-064-QTY;;QTY;;Claim Suppl Info (Quantity);;3-064;;;;15
 ;;3-070-SVC;;SVC;;Service Information;;3-070;;1
 ;;3-080-DTM;;DTM;;Service Date;;3-080;;;;3;;1
 ;;3-090-CAS;;CAS;;Line Level Adjustments;;3-090;;;;99;;1
 ;;3-100.A-REF;;REF;;Service Identification;;3-100.A;;;;7
 ;;3-100.B-REF;;REF;;Rendering Provider Id;;3-100.B;;;;10
 ;;3-110-AMT;;AMT;;Service Suppl Amt ($);;3-110;;;;12
 ;;3-120-QTY;;QTY;;Service Suppl Quantity;;3-120;;;;6
 ;;3-130-LQ;;LQ;;Line Level Remark Codes;;3-130;;;;99
 ;;4-010-PLB;;PLB;;Provider Level Adjustments;;4-010;;;;99;;1
 ;;4-020-SE;;SE;;Transaction Set Trailer;;4-020
 ;;5-010-GE;;GE;;Functional Group Trailer;;5-010
 ;;6-010-IEA;;IEA;;Interchange Control Trailer;;6-010
 ;;END
