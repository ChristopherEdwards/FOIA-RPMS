BARADJR7 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE**22**;;OCT 26, 2005;Build 38
 ; IHS/SD/SDR - v1.8 p22 - updated SARs
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
1 ;; A/R Table Entry file - Adds
 ;;966;;Proc/mod not comp, othr, NCCI;;4
 ;;975;;Legislative/Regulatory Penalty;;15
 ;;967;;Clm spans elig/inelg cov-PT;;4
 ;;968;;Clm spans elig/inelg cov-OTH;;4
 ;;969;;Clm spans elig/inelg cov-rebi;;4
 ;;END
 ;
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;
 ;;236;;Proc/proc+mod comb not compat w/oth proc/proc+mod, same day per NCCI;;4;;966;;Proc/mod not comp, othr, NCCI 
 ;;237;;Legislated/Regulatory Penalty. Check Remark Codes;;15;;975;;Legislated/Regulatory Penalty. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;238;;Clm spans eligible, inelig periods of coverage, may be the patient's resp;;4;;967;;Claim spans eligible and ineligible periods of coverage, this is the reduction for the ineligible period (use Group Code PR).
 ;;239;;Clm spans eligible, inelig periods of coverage.  Rebill separate clms;;4;;969;;Claim spans eligible and ineligible periods of coverage. Rebill separate claims.
 ;;END
 ;
 ; ********************************************************************
 ; CLAIM STATUS CODE ;; DESCRIPTION
 ; ********************************************************************
3 ;; - A/R EDI Claim Status Codes file - Adds
 ;;END
 ;
 ; ********************************************************************
 ; STANDARD CODE ;; RPMS REASON
 ; ********************************************************************
4 ;;A/R Table Entry file - Edits
 ;;END;;END
