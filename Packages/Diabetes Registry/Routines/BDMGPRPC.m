BDMGPRPC ; cmi/anch/maw - BDMG Populate RPC field of Option file 1/10/2005 1:31:25 PM ; 
 ;;2.0;BDM DIABETES MANAGEMENT SYSTEM;**1**;JAN 17, 2008
 ;
 ;
 ;
 ;
MAIN ;EP - this is the main routine driver
 D POP
 Q
 ;
POP ;-- populate the RPC field of the option file
 N BDMGDA,BDMGIEN
 S BDMGDA=0 F  S BDMGDA=$O(^XWB(8994,"B",BDMGDA)) Q:BDMGDA=""  D
 . Q:$E(BDMGDA,1,4)'="BDMG"
 . S BDMGIEN=0 F  S BDMGIEN=$O(^XWB(8994,"B",BDMGDA,BDMGIEN)) Q:'BDMGIEN  D
 .. K DD,DO
 .. S DA(1)=$O(^DIC(19,"B","BMXRPC",0))
 .. S DIC(0)="L"
 .. S DIC="^DIC(19,"_DA(1)_","_"""RPC"""_","
 .. S X=BDMGIEN
 .. D FILE^DICN
 Q
 ;
