BOPECP01 ;IHS/CIA/PLS - Installation Utilities;16-May-2006 09:28;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
ENV Q
 ;
PRE ;
 D DELDD
 Q
POST ;
 ; Remove data stored for DEFAULT PROVIDER field.
 S $P(BOP(90355,1,"SITE"),U,7)=""
 ; Register Hook Protocol
 D REGPROT("GMRA VERIFY DATA","BOP GMRA UPDATE",25)
 Q
 ; EP: Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
REGPROT(P,C,S,ERR) ;
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .S:$G(S) FDA(101.01,"?+2,"_IENARY(1)_",",3)=S
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q
 ;
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
DELDD ; Delete DDs
 N DIU
 F DIU=90355,90355.44 D
 .S DIU(0)=""
 .D EN^DIU2
 S DIU=90355.4,DIU(0)="D" D EN^DIU2
 Q
