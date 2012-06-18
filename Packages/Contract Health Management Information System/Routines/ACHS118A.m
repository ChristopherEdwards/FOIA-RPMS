ACHS118A ;IHS/OIT/FCJ - ACHS 3.1 PATCH 18 2 of 2 ;7/30/10  08:48
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUNE 11,2001
 ;ACHS*3.1*18 New routine
 ;;ACHS*3.1*18; IHS/OIT/ABK Added new tags SETBLR and LTSETS
 ;
 ;
P16OPT ;EP - FR KIDS
 ;ADD NEW OPTIONS - P16, DENIAL REPORT, 2-SSC REPORTS
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DEN REPORTS","ACHS DEN REP-CARE NOT MED PRI","CARE") D MES^XPDUTL($J("",5)_"Added to Denial Reports - Care not within Medical Priority")
 I $$ADD^XPDMENU("ACHS MENU SCC REPORTS","ACHSRPTOBJPAY","PAY") D MES^XPDUTL($J("",5)_"Added to SSC Reports - Payment Report by Object Classification")
 I $$ADD^XPDMENU("ACHS MENU SCC REPORTS","ACHSRPTOBJPAYSUM","SUM") D MES^XPDUTL($J("",5)_"Added to SSC Reports - Payment Summary Report by Object Classification")
 D MES^XPDUTL("END updating options.")
 Q
P18OPT ;EP - FR KIDS
 ;ADD NEW OPTIONS - P18, Denial GAO file, GPRA REPORT
 D BMES^XPDUTL("Begin adding new options.")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEFDEN GAO","GAO",7) D MES^XPDUTL($J("",5)_"Added to Denial-Umet Need Menu - Create File for GAO")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHSRPT GPRA","GPRA") D MES^XPDUTL($J("",5)_"Added to Reports - GPRA Report for DOS vs Issue date")
 I $$ADD^XPDMENU("ACHSMGR","ACHS CHSDA","SDA",7) D MES^XPDUTL($J("",5)_"Added to Facility Management Menu - Enter/Edit Tribal CHSDA")
 I $$ADD^XPDMENU("ACHSREPORTS","ACHSRPT ELG","ELG") D MES^XPDUTL($J("",5)_"Added to Reports - CHS Eligible patients by CHSDA")
 ;
 ;{ABK,6/30/10} Additional options
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEFDEN MENU DENIAL","DEN",2) D MES^XPDUTL($J("",5)_"Added to ACHS Denial/Unmet Needs - Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEFDEN MENU UNMET NEED","UMN",3) D MES^XPDUTL($J("",5)_"Added to ACHS Denial/Unmet Needs - Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU","ACHS DEFDEN MENU PARM","PAR",1) D MES^XPDUTL($J("",5)_"Added to ACHS Denial/Unmet Needs - Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU PARM","ACHS DEFDEN MENU LFP","LFP") D MES^XPDUTL($J("",5)_"Added to Denial Parameters - Letter Format Parameters")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU PARM","ACHS DEFDEN MENU BENC","BC") D MES^XPDUTL($J("",5)_"Added to Denial Parameters - Benefit Coordinator Parameters")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU PARM","ACHS DEN ALT RES TYPE","ALTY") D MES^XPDUTL($J("",5)_"Added to Denial Parameters - Alternate Resource Type")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU LFP","ACHS DEFDEN MENU PARM OFF","LM") D MES^XPDUTL($J("",5)_"Added to Letter Format Parameters - Set Left Margin")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU LFP","ACHS DEFDEN MENU PARM L15","TM") D MES^XPDUTL($J("",5)_"Added to Letter Format Parameters - Set Top Margin")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU BENC","ACHS DEFDEN MENU BCN","NM") D MES^XPDUTL($J("",5)_"Added to Benefit Coordinator Parameters - Set Benefit Coordinator Name")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU BENC","ACHS DEFDEN MENU BCP","PH") D MES^XPDUTL($J("",5)_"Added to Benefit Coordinator Parameters - Set Benefit Coordinator Phone")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEFDEN MENU DEN REPORTS","REP") D MES^XPDUTL($J("",5)_"Add Denial Reports option to Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEN ADD","ADD") D MES^XPDUTL($J("",5)_"Add option to Add a Denial to the Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEFDEN MENU DEN LTRS","DENL") D MES^XPDUTL($J("",5)_"Add Denial Letter Menu to Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEN CANCEL","CAN") D MES^XPDUTL($J("",5)_"Add Cancel option to Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEFDEN MENU DEN SUPP","SUP") D MES^XPDUTL($J("",5)_"Add Denial Supplement option to ACHS Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU DENIAL","ACHS DEN APPEAL MENU","APP") D MES^XPDUTL($J("",5)_"Added Appeal option to Denial Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU UNMET NEED","ACHS DEF ADD","ADD") D MES^XPDUTL($J("",5)_"Added Add Unmet need option to Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU UNMET NEED","ACHS DEF CANCEL","CAN") D MES^XPDUTL($J("",5)_"Added Cancel option to Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU UNMET NEED","ACHS DEF LETTER","PRT") D MES^XPDUTL($J("",5)_"Added Print Letter option to Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU UNMET NEED","ACHS DEFDEN MENU DEF SUPP","SUP") D MES^XPDUTL($J("",5)_"Added Supplemental option to Unmet Need Menu")
 I $$ADD^XPDMENU("ACHS DEFDEN MENU UNMET NEED","ACHS DEFDEN MENU DEF RPT","REP") D MES^XPDUTL($J("",5)_"Added Report option to Unmet Need Menu")
 D MES^XPDUTL("END updating options.")
 ;
SDA ;
 D ADD^ACHSSDA
 D MES^XPDUTL("Completed updating CHS Service Delivery file, for items that could not be added see ACHSTMP global")
 ;
SETBLR ;ACHS*3.1*18 IHS/OIT/ABK Set CHS Denial Facility Parms for denial Letter Boilerplate
 N ACHSDA
 ;
 ;DENIAL LETTER BOILERPLATE
 S MTEXT="We have been requested to authorize payment for medical services received from the above provider(s).  Please understand that after careful"
 S MTEXT2=" review of the Contract Health Service rules and regulations, we must advise you the ACHSFAC will not authorize payment for the following reason(s):"
 S BTEXT="RECONSIDERATION AND APPEAL [Per 42 CFR 136.25]. You may appeal the denial in writing.  Please submit a statement supporting the reason for the appeal.  NOTE: "
 S BTEXT1="If you fail to submit a written appeal within (30) days of receipt of this letter, payment will be denied through the CHS program. "
 S BTEXT2="If you have additional information that may affect our decision, please submit it in writing within 30 days of receipt of this letter to: "
 S CTEXT="If you do not have additional information, you may appeal in writing, within 30 days of receipt of this letter:"
 ;
 ;SET Letter Text
 S ACHSDA=0 F  S ACHSDA=$O(^ACHSDENR(ACHSDA)) Q:ACHSDA'?1N.N  D LTSETS
 D DENUP
 Q
 ;
LTSETS ; Set lettter boilerplate into facilities - quit if 638 facility
 ;New variables and If unit not defined properly, quit
 N ACHSX,ACHSFAC,FTIDX,EMSG
 S ACHSX=$G(^ACHSF(ACHSDA,0))=""
 Q:ACHSX=""
 ;If Tribal quit
 Q:$P(ACHSX,U,8)="Y"
 ;
 ;{ABK, 6/25/10}Add logic to print facility name in middle text
 S ACHSFAC=$P(^DIC(4,ACHSDA,0),U,1)
 ;
 ;
 S DIE="^ACHSDENR(",DA=ACHSDA
 S DR="2///"_MTEXT_MTEXT2
 S EMSG="CHS Denial Facility Parameters for Facility "_ACHSFAC_" Denial Letter Middle Text"
 D ^DIE
 D BMES^XPDUTL("Updated - "_EMSG)
 ;
 S DR="3///"_BTEXT_BTEXT1_BTEXT2
 S EMSG="CHS Denial Facility Parameters for Facility "_ACHSFAC_" Denial Letter Bottom Text"
 D ^DIE
 D BMES^XPDUTL("Updated - "_EMSG)
 ;
 S DR="8///"_CTEXT
 S EMSG="CHS Denial Facility Parameters for Facility "_ACHSFAC_" Denial Letter Closing Text"
 D ^DIE
 D BMES^XPDUTL("Updated - "_EMSG)
 D ^XBFMK
 Q
 ;
DENUP ;DENIAL REASON UPDATE FOR ALT REC
 NEW ACHSDA
 S X="Alternate Resource Available"
 S DA=0
 S DA=$O(^ACHSDENS("B",X,DA)) Q:DA'?1N.N
 S DIE="^ACHSDENS("
 S DA=DA,DR="1///"_""
 D ^DIE
 D ^XBFMK
 Q
ERRM ;Handle insert error messages
 ;
 D BMES^XPDUTL("Unable to update - "_EMSG)
 D BMES^XPDUTL("You will need to manually update this text thru fileman")
 D BMES^XPDUTL(X)
 Q
