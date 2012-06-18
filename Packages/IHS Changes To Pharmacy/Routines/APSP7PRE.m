APSP7PRE ;IHS/CIA/PLS - Pre-Init routine for APSP v7.0;30-Apr-2004 11:24;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;;01/28/2003
 ;
PRE ; EP
 N LP
 ; Rename Help Frames that begin with PSOZ
 D RENHLPF("PSOZ","APSP")
 F LP="PSO ARCHIVE","PSOL MANAGER","PSO PROVIDER ADD" D
 .D FIXOMSG(LP)
 D DELDD
 Q
 ;
RENHLPF(FROM,TO) ;
 N HNAM,HIEN,NNAM
 S HNAM=FROM
 F  S HNAM=$O(^DIC(9.2,"B",HNAM)) Q:HNAM=""!($E(HNAM,1,$L(FROM))'=FROM)  D
 .S HIEN=0 F  S HIEN=$O(^DIC(9.2,"B",HNAM,HIEN)) Q:'HIEN  D
 ..S NNAM=TO_$E(HNAM,$L(FROM)+1,$L(HNAM))
 ..D FIXNM(HIEN,NNAM)
 Q
 ;
FIXNM(HIEN,NAM) ; Call FileMan to change name of Help Frame
 N FDA,ERR
 S FDA(9.2,HIEN_",",.01)=NAM
 D FILE^DIE("K","FDA","ERR")
 I '$G(ERR) D
 .D MES("Help Frame: "_NAM_" has been saved.")
 E  D MES("Unable to update the "_NAM_" help frame.")
 Q
 ;
DELDD ; Delete DD
 N DIU
 F DIU=9009033 D
 .S DIU(0)=""
 .D EN^DIU2
 Q
 ; Fix Out of Order Message and lock with APSP Key
FIXOMSG(OPT) ;
 N IEN,VAL,FDA,KEY
 S IEN=$$FIND1^DIC(19,,"X",OPT)
 S KEY=$$FIND1^DIC(19.1,,"X","APSP")
 I IEN D
 .S VAL="Not used by IHS Pharmacies."
 .S FDA(19,IEN_",",2)=VAL
 .S:KEY FDA(19,IEN_",",3)=KEY
 .D FILE^DIE("K","FDA")
 Q
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
