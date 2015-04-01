BARADJR0  ;IHS/SD/POT - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE**24**;;OCT 26, 2005;Build 69
 ; IHS/SD/POTT HEAT147789 - v1.8 p24 - updated SARs part3
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
 .S DR=".02///^S X=$P(BARVALUE,BARD,2)"        ; Short Desc
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
 ;;END
 ;
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;DIC="^BARADJ("
 ;;P21;;Payment den based on med payments coverage or personal injury protection bnfts.;;4;;421;;Pymnt den based on Med Pymnts Coverage or Personal Inj Protection Ben jurisdictional regulations or payment policies, use only if no other code applicable. Used for Property & Casualty Auto only.
 ;;P22;;Payment adjusted based on medical pymts cov or pers injury protection bnfts.;;4;;422;;Pymnt adjust based on Medical Pymnts Cov or Personal Injury Protection Ben jurisdictional regulations or pymnt policies, use only if no other code is app. Used for Property and Casualty Auto only.
 ;;P23;;Med Payments Coverage or Pers Injury Protection Benefits fee sched adjustment.;;4;;423;;Medical Payments Coverage (MPC) or Personal Injury Protection (PIP) Benefits jurisdictional fee schedule adjustment. To be used for Property and Casualty Auto only.
 ;;P3;;Worker's Comp case settled. Pt is responsible.;;4;;403;;Workers' Compensation case settled. Patient is responsible for amount of this claim/service through WC 'Medicare set aside arrangement' or other agreement. To be used for Workers' Compensation only.
 ;;P4;;Woker's Comp case adjudicated as non-compensable. Payer not liable for clm/svc.;;4;;404;;Workers' Compensation claim adjudicated as non-compensable. This Payer not liable for claim or service/treatment. To be used for Workers' Compensation only.
 ;;P5;;Based on payer reasonable/customary fees. No max allow defined by fee arrgmt.;;4;;405;;Based on payer reasonable and customary fees. No maximum allowable defined by legislated fee arrangement. To be used for Property and Casualty only.
 ;;P6;;Based on entitlement to benefits;;4;;406;;Based on entitlement to benefits. To be used for Property and Casualty only.
 ;;P7;;The applicable fee sched/fee db does not contain billd code. Resub crrctd bill.;;22;;407;;The applicable fee schedule/database doesn't contain the billed code. Resubmit bill with appropriate fee schedule/database code(s) that best describe service(s) provided and supporting documents if re
 ;;P8;;Claim is under investigation.;;22;;408;;Claim is under investigation. To be used for Property and Casualty only.
 ;;P9;;No available/correlating CPT/HCPCS to describe this service;;4;;409;;No available or correlating CPT/HCPCS code to describe this service. To be used for Property and Casualty only.
 ;;W3;;Benefit for this svc included in pymt for another svc performed on the same day.;;4;;823;;The Benefit for this Service is included in the payment/allowance for another service/procedure that has been performed on the same day. For use by Property and Casualty only.
 ;;W4;;WC Medical Treatment Guideline Adjustment;;4;;824;;Workers' Compensation Medical Treatment Guideline Adjustment.
 ;;W5;;Medical provider not auth'd/certified to provide trtmt to injured workers.;;4;;825;;Medical provider not authorized/certified to provide treatment to injured workers in this jurisdiction. (Use with Group Code CO or OA)
 ;;W6;;Referral not auth'd by attending physician.;;15;;826;;Referral not authorized by attending physician per regulatory requirement.
 ;;W7;;Proc not listed in the jurisdiction fee schedule. Allowance made for comp svc.;;22;;827;;Procedure is not listed in the jurisdiction fee schedule. An allowance has been made for a comparable service.
 ;;W8;;Proc has a relative value of zero in the jurisdictional fee sched, no pymt due.;;22;;828;;Procedure has a relative value of zero in the jurisdiction fee schedule, therefore no payment is due.
 ;;W9;;Svc not pd under outpatient facility fee schedule.;;4;;829;;Service not paid under jurisdiction allowed outpatient facility fee schedule.
 ;;Y1;;Payment den based on med payments coverage or personal injury protection bnfts.;;4;;841;;Payment denied based on Medical Payments Coverage (MPC) or Personal Injury Protection (PIP) Benefits jurisdictional regulations or payment policies, use only if no other code is applicable. 
 ;;Y2;;Payment adjusted based on medical pymts cov or pers injury protection bnfts.;;4;;842;;Payment adjusted based on Medical Payments Coverage (MPC) or Personal Injury Protection (PIP) Benefits jurisdictional regulations or payment policies, use only if no other code is applicable. 
 ;;Y3;;Med Payments Coverage or Pers Injury Protection Benefits fee sched adjustment.;;22;;843;;Medical Payments Coverage (MPC) or Personal Injury Protection (PIP) Benefits jurisdictional fee schedule adjustment.
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
