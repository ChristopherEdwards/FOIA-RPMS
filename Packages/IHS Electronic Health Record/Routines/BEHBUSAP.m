BEHBUSAP ;MSC/JS - BUSA Audit Post-installation program ;07-Oct-2013 09:34;PLS
 ;;1.1;BEH COMPONENTS;**054001**;Mar 20, 2007;Build 23
 ;
 ;-- KIDS Post-Install Update - Queued update to set inactive all MSC non-patient BUSA RPCS except CIAVMCFG GETTEMPL
 ;                              file #9002319.03 -- BUSA AUDIT RPC DEFINITIONS FILE
 ;
UPALL ;
 N EHRBUSA
 S EHRBUSA(1)=""
 S EHRBUSA(2)="Queuing update to set all non patient-related BUSA RPCs to 'inactive' status..."
 S EHRBUSA(3)=""
 D MES^XPDUTL(.EHRBUSA) K EHRBUSA
 ;
 ;-- schedule TM job to run 'NOW' --
 S ZTIO=""
 S ZTDTH=$H
 S ZTRTN="DQ^BEHBUSAP"
 S ZTDESC="Tasked Update file #9002319.03 -- BUSA AUDIT RPC DEFINITIONS FILE from KIDs build "_$G(XPDNM)
 I $G(XPDNM)]"" S ZTSAVE("XPDNM")=""
 D ^%ZTLOAD K IO("Q")
 ;
 D HOME^%ZIS
 N EHRBUSA
 S EHRBUSA(1)=""
 S EHRBUSA(2)="The update for BUSA AUDIT RPC DEFINITIONS FILE"_$S($G(ZTSK)]"":" is tasked #"_ZTSK,1:" has NOT been tasked")
 S EHRBUSA(3)=""
 D MES^XPDUTL(.EHRBUSA) K EHRBUSA
 K ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
 ; Turn off MSC RPCs that have category other than 'Patient Related', excepting RPC 'CIAVMCFG GETTEMPL'
 ; Checks RPC namespaces:
 ;   BEH
 ;   BGO
 ;   BLR
 ;   CIA
 ;
DQ ; -- tasked update from KIDs Post-Install job starts here
 S U="^"
 N IEN S IEN=""
 S A=0
 F  S IEN=$O(^BUSA(9002319.03,IEN)) Q:IEN=""  D
 .S NOD0=$G(^BUSA(9002319.03,IEN,0))
 .Q:NOD0=""
 .S P1=$P(NOD0,U,1),P2=$P(NOD0,U,2)
 .S NSP=$E(P1,1,3)
 .I NSP["BEH"!(NSP["BGO")!(NSP["BLR")!(NSP["CIA") D  ;  -- screen for only MSC namespaced RPCs to inactivate
 ..Q:P1="CIAVMCFG GETTEMPL"  ; Skip this one, returns user HL7 Info Button access info
 ..Q:P2="P"  ; Category = 'Patient Related'
 ..S $P(^BUSA(9002319.03,IEN,0),U,7)=1 ; set Inactive fld #.07
 K A,IEN,NOD0,NSP,P1,P2
 Q
