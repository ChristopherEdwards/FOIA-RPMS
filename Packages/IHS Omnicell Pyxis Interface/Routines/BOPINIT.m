BOPINIT ;IHS/CIA/PLS - Installation Utilities;06-Apr-2005 13:41;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;;Jul 26, 2005
ENV Q
 ;
POST ;
 ; Register Hook Protocol
 I $$VERSION^XPDUTL("DG")<5.3 D
 .D MES("Contact OIT for the MAS 5.0 patch that hooks the ADT interface.")
 E  D
 .D REGPROT("BSDAM APPOINTMENT EVENTS","BOP SDAM")
 .D REGPROT("BDGPM MOVEMENT EVENTS","BOP DG ADT")
 Q
 ; EP: Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
REGPROT(P,C,ERR) ;
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q
 ;
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
