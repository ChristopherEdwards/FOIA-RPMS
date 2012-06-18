BSDP11PS ;cmi/anch/maw - PIMS Patch 1010 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1011**;FEB 27,2007;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D ADDMENU
 D ADDPRT
 Q:$$CHKVS(1011)
 D FIXDS
 Q
 ;
ADDMENU ;-- add menu items
 N X
 S X=$$ADD^XPDMENU("BSD MENU REPORTS","BSDRM RESTRICTED CLINIC BY DIV","RCL","")
 I 'X W !,"Attempt to add BSDRM RESTRICTED CLINIC BY DIV option failed.." H 3
 ;S X=$$ADD^XPDMENU("BDG SECURITY MENU","BDG SECURITY REPORT USER","UAR","")
 ;I 'X W !,"Attempt to add BDG SECURITY REPORT USER option failed.." H 3
 Q
 ;
ADDPRT ;-- add an entry to the protocol file
 N PROT,PROTA
 S PROT=$O(^ORD(101,"B","BSDAM APPOINTMENT EVENTS",0))
 S PROTA=$O(^ORD(101,"B","BSDAM PWH AT CHECKIN",0))
 Q:'PROT
 Q:'PROTA
 N FDA,FIENS,FERR
 S FIENS="?+2,"_PROT_","
 S FDA(101.01,FIENS,.01)=PROTA
 S FDA(101.01,FIENS,3)=17
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding BSD PWH AT CHECKIN to the Item Multiple of Protocol BSDAM APPOINTMENT EVENTS"
 Q
 ;
CHKVS(PATCH) ;-- check to see if the patch has already been installed once
 N PIMS
 S PIMS=$O(^DIC(9.4,"B","PIMS",0))
 I '$G(PIMS) Q 0
 I $O(^DIC(9.4,PIMS,22,1,"PAH","B",PATCH,0)) Q 1
 Q 0
FIXDS ;-- fix day surgery from patch 1010
 D ^ADGFXDS
 Q
 ;
