BARADJR2 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/06/03 - V1.7 Patch 4 - routine created
 ;     For HIPAA compliance.  Ceate new entries in A/R EDI STND ADJ
 ;     REASON CODES for new codes added since 6/02.  Also create new
 ;     RPMS reason codes for the standard codes to map to.
 ;
 ; *********************************************************************
EN ; EP
 D RPMSREA                   ; Create RPMS Reasons
 D STND                      ; Create new StanJdard Adj
 D CLAIM                     ; Create new Claim Status Codes
 D ^BARVKL0
 Q
 ; ********************************************************************
 ;
RPMSREA ;
 ; Create new Adjustment Reasons in A/R TABLE ENTRY
 S BARD=";;"
 S BARCNT=0
 F  D RPMSREA2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
 ;
RPMSREA2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,4)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZE"
 S DINUM=$P(BARVALUE,BARD)
 S X=$P(BARVALUE,BARD,2)
 S DIC("DR")="2////^S X=$P(BARVALUE,BARD,3)"
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
CHNGREA ; EP
 ; Change category of these reasons to Non-Payment
 S BARD=";;"
 S BARCNT=0
 F  D CHNGREA2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
 ;
CHNGREA2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,3)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DIE
 S DIE="^BARTBL("
 S DA=BARVALUE
 S DR="2////^S X=4"
 D ^DIE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
STND ;
 ; Create entries in A/R EDI STND CLAIM ADJ REASONS to accomodate
 ; Standard codes added between 6/02 and 9/03.
 S BARD=";;"
 S BARCNT=0
 F  D STND2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
 ;
STND2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@2+BARCNT),BARD,2,6)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ; Stnd Code
 S DIC("DR")=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 S DIC("DR")=DIC("DR")_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 S DIC("DR")=DIC("DR")_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 S DIC("DR")=DIC("DR")_";101///^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
CLAIM ;
 ; Populate A/R EDI CLAIM STATUS CODES to accomodate new codes added
 ; between 6/02 and 9/03. Inactivate necessary codes.
 S BARCNT=0
 F  D CLAIM2 Q:BARVALUE="END"
 S BARCNT=0
 F BARVALUE=8,10,11,13,14,28,69,70 D CLAIM3
 Q
 ; ********************************************************************
 ;
CLAIM2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,4)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ; Status Cd
 S DIC("DR")="11///^S X=$P(BARVALUE,BARD,2)"              ; Description
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
 ;
CLAIM3 ;
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="XZQ"
 S X=BARVALUE
 K DD,DO
 D ^DIC
 Q:+Y<1
 K DA,DIE,DR
 S DA=+Y
 S DIE=DIC
 S DR=".02///Y"
 D ^DIE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
MODIFY ; EP
 ; Change PENDING to NON PAYMENT
 S BARD=";;"
 S BARCNT=0
 F  D MODIFY2 Q:BARVALUE="END"
 Q
 ; *********************************************************************
 ;
MODIFY2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,2)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DR
 S DIC="^BARADJ("
 S DIC(0)="Z"
 S X=$P(BARVALUE,BARD)                                     ; Stnd Code
 K DD,DO
 D ^DIC
 Q:'+Y
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".03////^S X=4"
 D ^DIE
 Q
 ;
 ; *********************************************************************
 ; IEN;;NAME;;TABLE TYPE
 ; *********************************************************************
1 ;;
 ;;745;;Premium Pmt Withholding;;21
 ;;746;;Pmt Den DX Invalid for DOS;;4
 ;;747;;Prv Rate Expired/Not on file;;4
 ;;748;;Clm/Srv Rej Info Incomplete;;21
 ;;749;;Lifetime Ben Max for Srv/Ben;;4
 ;;750;;PayAdj No Info for Lgthof Svc;;4
 ;;751;;PayAdj No Info for Lgth of Svc;;4
 ;;752;;PayAdj No Info for Dosage;;4
 ;;753;;PayAdj No Info for Days Supply;;4
 ;;754;;PayAdj No Info for Lvl of Svc;;4
 ;;755;;Clm DEn Pt Refused Srv/Proc;;4
 ;;756;;Flex Spending Accts Payable;;22
 ;;757;;Pmt Den/Red Result Act of War;;4
 ;;758;;Pmt Den/Red Outside US;;4
 ;;759;;Pmt Den/Red Result of Terrorsm;;4
 ;;760;;Pmt Den/Red Activity Ben Excl;;4
 ;;END
 ;
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;
 ;;145;;Premium payment withholding;;21;;745;;Premium payment withholding
 ;;146;;Payment denied because diagnosis invalid for the date(s) of service reported.;;4;;746;;Payment denied because the diagnosis was invalid for the date(s) of service reported.
 ;;147;;Provider contracted/negotiated rate expired or not on file.;;4;;747;;Provider contracted/negotiated rate expired or not on file.
 ;;148;;Clm/Srvc rejectd at this time-info from another prv not provided/insuff/incmplet;;21;;748;;Claim/service rejected at this time because information from another provider was not provided or was insufficient/incomplete.
 ;;149;;Lifetime benefit maximum has been reached for this service/benefit category.;;4;;749;;Lifetime benefit maximum has been reached for this service/benefit category.
 ;;150;;Pmt adjusted - payer deems the info submitted not support this level of service.;;4;;750;;Payment adjusted because the payer deems the information submitted does not support this level of service.
 ;;151;;Pmt adjusted - payer deems the info submitted not support this many svcs.;;4;;751;;Payment adjusted because the payer deems the information submitted does not support this many svcs.
 ;;152;;Pmt adjusted - payer deems the info submitted not support this lgth of svc.;;4;;752;;Payment adjusted because the payer deems the information submitted does not support this length of service.
 ;;153;;Pmt adjusted - payer deems the info submitted not support this dosage.;;4;;753;;Payment adjusted because the payer deems the information submitted does not support this dosage.
 ;;154;;Pmt adjusted - payer deems the info submitted not support this day's supply.;;4;;754;;Payment adjusted because the payer deems the information submitted does not support this day's supply.
 ;;155;;This claim is denied because the patient refused the service/procedure;;4;;755;;This claim is denied because the patient refused the service/procedure
 ;;156;;Flexible spending account payments.;;22;;756;;Flexible spending account payments.
 ;;157;;Pmt denied/reduced - service/procedure provided as a result of an act of war.;;4;;757;;Payment denied/reduced because service/procedure was provided as a result of an act of war.
 ;;158;;Pmt denied/reduced - service/procedure provided outside the United States.;;4;;758;;Payment denied/reduced because service/procedure was provided outside the United States.
 ;;159;;Pmt denied/reduced - service/procedure provided as a result of terrorism.;;4;;759;;Payment denied/reduced because service/procedure was provided as a result of terrorism.
 ;;160;;Pmt denied/reduce - injury/illness result of activity that's a benefit exclusion;;4;;760;;Payment denied/reduced because injury/illness was the result of an activity that is a benefit exclusion.
 ;;END
 ;
 ; ********************************************************************
 ; CLAIM STATUS CODE ;; DESCRIPTION
 ; ********************************************************************
3 ;;
 ;;489;;Attachment Control Number
 ;;490;;Other Procedure Code for Service(s) Rendered
 ;;491;;Entity not eligible for encounter submission
 ;;492;;Other Procedure Date
 ;;493;;Version/Release/Industry ID code not currently supported by information holder
 ;;494;;Real-time requests not supported by the information holder, resubmit as batch request
 ;;495;;Requests for re-adjudication must reference the newly assigned payer claim control number for this previously adjusted claim.  Correct the payer claim control number and re-submit.
 ;;END
 ;
 ; ********************************************************************
 ; STANDARD CODE ;; RPMS REASON
 ; ********************************************************************
4 ;;
 ;;4;;604
 ;;5;;605
 ;;6;;606
 ;;7;;607
 ;;8;;608
 ;;9;;609
 ;;10;;610
 ;;11;;611
 ;;12;;612
 ;;13;;613
 ;;14;;614
 ;;15;;615
 ;;16;;616
 ;;17;;617
 ;;19;;619
 ;;20;;620
 ;;21;;621
 ;;22;;622
 ;;47;;647
 ;;55;;655
 ;;56;;656
 ;;57;;657
 ;;58;;658
 ;;61;;661
 ;;63;;663
 ;;65;;665
 ;;107;;707
 ;;110;;710
 ;;125;;725
 ;;140;;740
 ;;148;;748
 ;;B12;;862
 ;;B13;;863
 ;;B16;;866
 ;;B18;;868
 ;;B22;;872
 ;;B23;;873
 ;;D1;;901
 ;;D2;;902
 ;;D3;;903
 ;;D4;;904
 ;;D5;;905
 ;;D6;;906
 ;;D7;;907
 ;;D8;;908
 ;;D9;;909
 ;;D10;;910
 ;;D11;;911
 ;;D12;;912
 ;;D13;;913
 ;;D14;;914
 ;;END;;END
