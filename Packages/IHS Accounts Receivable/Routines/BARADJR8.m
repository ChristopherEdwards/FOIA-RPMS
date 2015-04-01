BARADJR8 ; IHS/SD/POT - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE**24**;;OCT 26, 2005;Build 69
 ; IHS/SD/POTT HEAT147789 - v1.8 p24 - updated SARs part1
 ; IHS/SD/POTT HEAT146880 1 v1.8 p24
 ; IHS/SD/POTT 3/26/2014 FIXED TYPE IN SAR code 247: Adj code should be 13 instead of 1.
 ; code cloned from BARADJR7
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
 D BMES^XPDUTL("Adding New Adjustment Reasons to A/R Table Entry file...")
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
 D MES^XPDUTL($P(BARVALUE,BARD)_"  "_$P(BARVALUE,BARD,2))
 D FILE^DICN
 Q
 ; ********************************************************************
CHNGREA ; EP
 ; Change category of these reasons to Non-Payment
 S BARD=";;"
 S BARCNT=0
 F  D CHNGREA2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
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
STND ;
 ; Create entries in A/R EDI STND CLAIM ADJ REASONS to accomodate
 ; Standard codes added between 6/02 and 9/03.
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Updating Standard Adjustment Reasons in A/R EDI STND CLAIM ADJ REASONS file...")
 F  D STND2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
STND2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@2+BARCNT),BARD,2,6)
 Q:BARVALUE="END"
STND3 ;
 ;look for existing entry
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="M"
 S X=$P(BARVALUE,BARD)
 D ^DIC
 I +Y>0 D  Q  ;if existing entry found - edit it
 .D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 .K DIC,DIE
 .S DIE="^BARADJ("
 .S DA=+Y
 .S DR=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 .S DR=DR_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 .S DR=DR_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 .S DR=DR_";101///^S X=$P(BARVALUE,BARD,5)"    ; Long Desc 
 .D ^DIE
 ;create new entry if none found
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ; Stnd Code
 S DIC("DR")=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 S DIC("DR")=DIC("DR")_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 S DIC("DR")=DIC("DR")_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 S DIC("DR")=DIC("DR")_";101///^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 D FILE^DICN
 Q
 ; ********************************************************************
CLAIM ;
 ; Populate A/R EDI CLAIM STATUS CODES to accomodate new codes added
 ; between 6/02 and 9/03. Inactivate necessary codes.
 S BARCNT=0
 F  D CLAIM2 Q:BARVALUE="END"
 S BARCNT=0
 F BARVALUE=8,10,11,13,14,28,69,70 D CLAIM3
 Q
 ; ********************************************************************
CLAIM2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,4)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                        ;Status Cd
 S DIC("DR")="11///^S X=$P(BARVALUE,BARD,2)"  ;Description
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
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
MODIFY ; EP
 ; Change PENDING to NON PAYMENT
 S BARD=";;"
 S BARCNT=0
 F  D MODIFY2 Q:BARVALUE="END"
 Q
 ; *********************************************************************
MODIFY2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,2)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DR
 S DIC="^BARADJ("
 S DIC(0)="Z"
 S X=$P(BARVALUE,BARD)  ;Stnd Code
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
1 ;; A/R Table Entry file - Adds (S DIC="^BARTBL(")
 ;;300;;Doc rcvd inconsist w/exp cntnt;;4
 ;;301;;Doc rcvd not contain req cntnt;;4
 ;;302;;Doc reqd to adjudicate clm/svc;;4
 ;;303;;Sequestration-red in fed pymt;;15
 ;;304;;Submit svcs to pt's med plan;;4
 ;;305;;Clm pending due to litigation;;21
 ;;306;;Not payable per mngd care cont;;4
 ;;307;;Clm pndng during prem grace pd;;21
 ;;308;;Clm not cvrd - pt incarcerated;;4
 ;;400;;Cancelled/Expired Appropriation;;22
 ;;401;;ST-mandated rqrmt for property;;22
 ;;402;;Not work related inj/illness;;4
 ;;403;;WC case settled, pt resp;;4
 ;;404;;WC case adjudicated as non-WC;;4
 ;;405;;Based on payer reas & cust fee;;4
 ;;406;;Based on entitlement to bnfts;;4
 ;;407;;Resub w/correct proc code;;22
 ;;408;;Clm is under investigation;;22
 ;;409;;No CPT/HCPCS to describe svc;;4
 ;;410;;Zero pmt due to litigation;;4
 ;;411;;Clm pending due to litigation;;21
 ;;412;;WC fee schedule adjustment;;4
 ;;413;;Pmt reduced due to WC policies;;4
 ;;414;;Pmt incl w/pmt for other svc;;4
 ;;415;;WC Med Trtmt Guideline adjstmt;;4
 ;;416;;Med prov not auth'd for WC;;4
 ;;417;;Referral not auth'd by attndng;;15
 ;;418;;Proc not listed/comp svc allwd;;4
 ;;419;;No pymt due,proc fee is zero;;4
 ;;420;;Svc not pd under oupt fee schd;;4
 ;;421;;TPL Payment denied-MPC/PIP;;4
 ;;422;;TPL Payment adjusted-MPC/PIP;;4
 ;;423;;TPL Fee Sch Adjust-MPC/PIP;;4
 ;;762;;Property & Casualty Require;;4
 ;;823;;Pmt incl w/pmt for other svc;;4
 ;;824;;WC Med Trtmt Guideline adjstmt;;4
 ;;825;;Med prov not auth'd for WC;;4
 ;;826;;Referral not auth'd by attndng;;15
 ;;827;;Proc not listed/comp svc allwd;;22
 ;;828;;No pymt due,proc fee is zero;;22
 ;;829;;Svc not pd under oupt fee schd;;4
 ;;841;;Payment denied;;4
 ;;842;;Payment adjusted;;4
 ;;843;;Fee schedule adjustment;;22
 ;;980;;Dx inconsist w pt's birth wt;;4
 ;;981;;Low Income Subsidy copay amt;;14
 ;;982;;Svcs not provided by netwk/pcp;;4
 ;;983;;Svcs not auth'd by network/pcp;;4
 ;;984;;Pmt reduced to zero due to lit;;21
 ;;985;;Prov performance prog withhold;;15
 ;;986;;Non-payable code for req'd rep;;4
 ;;987;;Ded-Prof svc rendered in Inst;;1
 ;;988;;Coins-Prof svc rendrd in Inst;;14
 ;;989;;Clm identified as readmission;;4
 ;;END
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;DIC="^BARADJ("
 ;;133;;The disposition of this claim/service is pending further review;;21;;733;;The disposition of the claim/service is pending further review. (Use only with Group Code OA)
 ;;240;;Dx inconsistent with pt's birth weight.;;4;;980;;The diagnosis is inconsistent with the patient's birth weight. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;241;;Low Income Subsidy (LIS) co-pay amount;;14;;981;;Low Income Subsidy (LIS) Co-payment Amount
 ;;242;;Svcs not provided by network/primary care providers;;4;;982;;Services not provided by network/primary care providers.
 ;;243;;Svcs not authorized by network/primary care providers;;4;;983;;Services not authorized by network/primary care providers.
 ;;244;;Pymt red to zero due to lit. Addt'l info will be sent following concl of lit.;;21;;984;;Payment reduced to zero due to litigation. Additional information will be sent following the conclusion of litigation. To be used for Property & Casualty only.
 ;;245;;Prov performance program withhold.;;15;;985;;Provider performance program withhold.
 ;;246;;This non-payable code is for req'd reporting only.;;4;;986;;This non-payable code is for required reporting only.
 ;;247;;Ded for Prof svc rendered in Institutional setting and billed on Inst clm.;;13;;987;;Deductible for Professional service rendered in an Institutional setting and billed on an Institutional claim.
 ;;248;;Coins for Prof svc rendered in Institutional setting and billed on Inst clm.;;14;;988;;Coinsurance for Professional service rendered in an Institutional setting and billed on an Institutional claim.
 ;;249;;Clm identified as a readmission.;;4;;989;;This claim has been identified as a readmission. (Use only with Group Code CO).
 ;;250;;Documentation recv'd is inconsistent w/expected content.;;4;;300;;The attachment/other documentation content received is inconsistent with the expected content.
 ;;251;;Documentation recv'd did not contain content required to process clm/svc.;;4;;301;;The attachment/other documentation content received did not contain the content required to process this claim or service.
 ;;252;;Doc required to adjudicate clm/svc. At least one Remark Code must be provided.;;4;;302;;An attachment/other documentation is required to adjudicate this claim/service. At least one Remark Code must be provided.
 ;;253;;Sequestration - reduction in federal pymt.;;15;;303;;Sequestration - reduction in federal payment
 ;;254;;Clm rcvd by dental plan but bnfts not avail. Submit to pt's medical plan.;;4;;304;;Claim received by the dental plan, but benefits not available under this plan. Submit these services to the patient's medical plan for further consideration.
 ;;255;;Clm pending due to litigation.;;21;;305;;The disposition of the related Property & Casualty claim (injury or illness) is pending due to litigation. (Use only with Group Code OA)
 ;;256;;Svc not payable per managed care contract.;;4;;306;;Service not payable per managed care contract.
 ;;257;;Clm pending during the prem grace period, per Health Ins Exchange requirements.;;21;;307;;The disposition of the claim/service is pending during the premium payment grace period, per Health Insurance Exchange requirements. (Use only with Group Code OA)
 ;;258;;Clm/svc not cvrd when pt in cust/incarcerated. Fed,state,local auth may cover.;;4;;308;;Claim/service not covered when patient is in custody/incarcerated. Applicable federal, state or local authority may cover the claim/service.
 ;;END
 ;
 ; ********************************************************************
 ; CLAIM STATUS CODE ;; DESCRIPTION
 ; ********************************************************************
3 ;; - A/R EDI Claim Status Codes file - Adds DIC="^BARECSC("
 ;;END
 ;
 ; ********************************************************************
 ; STANDARD CODE ;; RPMS REASON
 ; ********************************************************************
4 ;;A/R Table Entry file - Edits DIE="^BARTBL("
 ;;END;;END
