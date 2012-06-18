BDMGRPC ; cmi/anch/maw - BDM Diabetes RPC calls ;
 ;;2.0;BDM DIABETES MANAGEMENT SYSTEM;**1**;JAN 17, 2008
 ;
 ;
DEBUG(BDMRET,BDMSTR) ;--run debug mode
 D DEBUG^%Serenji("CMP^BDMGE(.BDMRET,.BDMSTR)")
 Q
 ;
