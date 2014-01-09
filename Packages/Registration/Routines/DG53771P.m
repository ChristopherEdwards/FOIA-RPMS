DG53771P ;ALB/ERC - Patch DG53771P Post Install ;10/30/07
 ;;5.3;PIMS;**1016**;JUN 30, 2012;Build 20
 ;
 Q
EN ; This routine will update the USE FOR Z07 CHECK field #6
 ; in the INCONSISTENT DATA ELEMENTS file #38.6 for CC 
 ; 75, 76, 78, 306, 307 and 409
 N RULE,DA,DIE,DR
 F RULE=75,76,78,306,307,409 D
 .D BMES^XPDUTL("Modifying entry #"_RULE_" in 38.6 file.")
 .S DIE=38.6,DA=$$FIND1^DIC(DIE,"","X",RULE)
 .I 'DA D  Q
 ..D MES^XPDUTL("    *** Entry not found! Nothing Updated!! ***") Q
 .S DR="6////0" D ^DIE
 .D MES^XPDUTL("    *** Update Complete ***")
 D BMES^XPDUTL("")
 Q
