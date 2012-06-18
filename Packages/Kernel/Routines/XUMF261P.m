XUMF261P ;OIFO-OAK/RAM - XUMF *261 post init;04/15/02
 ;;8.0;KERNEL;**261**;Jul 10, 1995
 ;
 Q
 ;
POST ; -- post init
 ;
 N DIK,DA,STA,IEN,IENS,FDA,FTYP,XUMF
 ;
 ; delete existing traditional x-ref on IDENTIFIER .02
 D DELIX^DDMOD(4.9999,.02,1)
 D DELIX^DDMOD(4.9999,.02,2)
 ;
 K ^DIC(4,"A XUMF ID")
 K ^DIC(4,"A XUMF IEN")
 ;
 S XUMF=1
 ;
 ; populate VA station number in IDENTIFIER
 S STA=""
 F  S STA=$O(^DIC(4,"D",STA)) Q:STA=""  D
 .S IEN=$O(^DIC(4,"D",STA,0))
 .S IENS="?+1,"_IEN_","
 .K FDA
 .S FDA(4.9999,IENS,.01)="VASTANUM"
 .S FDA(4.9999,IENS,.02)=STA
 .D
 ..N IEN,STA
 ..D UPDATE^DIE("E","FDA")
 ;
 ; re-index IDENTIFIER .02 (XUMFID and XUMFIDX)
 S IEN=0
 F  S IEN=$O(^DIC(4,IEN)) Q:'IEN  D
 .S DIK="^DIC(4,"_IEN_",9999,"
 .S DA(1)=IEN,DIK(1)=".02"
 .D ENALL^DIK
 ;
 K ^DIC(4,"XUMFID","DMIS")
 K ^DIC(4,"XUMFID","VASTANUM")
 ;
 ; task job to load DMIS IDs
 D BG^XUMF218
 ;
 Q
 ;
