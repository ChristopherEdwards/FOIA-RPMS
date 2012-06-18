ABMPT262 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 2 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**2**;FEB 2, 2010
 ;
 Q
PRE ;EP
 S ABM="^ABMPSTAT(23)"
 K @ABM
 S ABM="^ABMPSTAT(20)"
 K @ABM
 S ABM="^ABMCLCLM(23)"
 K @ABM
 Q
EN ;EP
 D RXBILLST  ;populate Insurer RX BILLING STATUS that are null
 D CONVERT^ABMFECNV  ;move 3P Fee Table data into effective date multiples
 Q
RXBILLST ;
 D BMES^XPDUTL("Auto-populate RX Billing Status with OUTPATIENT DRUGS ONLY...")
 S ABMF=0,ABMCNT=0
 F  S ABMF=$O(^AUTNINS(ABMF)) Q:(+$G(ABMF)=0)  D
 .Q:($P($G(^AUTNINS(ABMF,2)),U,3)'="")
 .K DIC,DIE,DIR,X,Y,DA,DR
 .S DIE="^AUTNINS("
 .S DA=ABMF
 .S DR=".23////O"
 .D ^DIE
 .D MES^XPDUTL($P($G(^AUTNINS(ABMF,0)),U)_" ("_ABMF_")")
 .S ABMCNT=+$G(ABMCNT)+1
 D BMES^XPDUTL(ABMCNT_" Insurers updated")
 Q
