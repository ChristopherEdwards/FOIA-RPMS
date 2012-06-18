ZVCKILL  ;THIS ROUTINE WILL KILL HL7 GLOBALS
         ;THIS ROUTINE SHOULD BE DELETED ONCE IT IS RUN
         ;
         Q
	;       
PROD1	;AUTTIMM
         N Z
         S DIK="^AUTTIMM("
         S DIK(1)=.11
         D ENALL2^DIK
         S X=0
         F I=1:1 S X=$O(^AUTTIMM(X)) Q:+X=0  D
         .Q:$G(^AUTTIMM(X,0))=""
         .S $P(^AUTTIMM(X,0),"^",11)=""
         ;
         ;
         ;BITMP
         N Z
         S X=0
         F I=1:1 S X=$O(^BITMP(X)) Q:X=""  D
         .S TMP(X)=""
         S X=0
         F I=1:1 S X=$O(TMP(X)) Q:X=""  D
         .K ^BITMP(X)
         K TMP
         ;
         ;BITN
         N Z
         S DIK="^BITN("
         S DA=0
         F Z=1:1 S DA=$O(^BITN(DA)) Q:+DA=0  D
         . D ^DIK
         ;
         ;DGEN(27.17
         N Z
         S DIK="^DGEN(27.17,"
         S DA=0
         F Z=1:1 S DA=$O(^DGEN(27.17,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;GMR(
         ;This is not a FileMan type file
         S X=""
         F I=1:1 S X=$O(^GMR(X)) Q:X=""  D
         .S TMP(X)=""
         S X=""
         F I=1:1 S X=$O(TMP(X)) Q:X=""  D
         .K ^GMR(X)
         ; 
         ;HL(771
         N Z
         S DA=0
         S DIK="^HL(771,"
         F Z=1:1 S DA=$O(^HL(771,DA)) Q:+DA=0  D
         . D ^DIK
         ;
         ;HL(772
         N Z
         S DA=0
         S DIK="^HL(772,"
         F Z=1:1 S DA=$O(^HL(772,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLCS(870
         N Z
         S DA=0
         S DIK="^HLCS(870,"
         F Z=1:1 S DA=$O(^HLCS(870,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLEV(776
         N Z
         S DA=0
         S DIK="^HLEV(776,"
         F Z=1:1 S DA=$O(^HLEV(776,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLEV(776.1
         N Z
         S DA=0
         S DIK="^HLEV(776.1,"
         F Z=1:1 S DA=$O(^HLEV(776.1,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLEV(776.2
         N Z
         S DA=0
         S DIK="^HLEV(776.2,"
         F Z=1:1 S DA=$O(^HLEV(776.2,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLEV(776.3
         N Z
         S DA=0
         S DIK="^HLEV(776.3,"
         F Z=1:1 S DA=$O(^HLEV(776.3,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLEV(776.4
         N Z
         S DA=0
         S DIK="^HLEV(776.4,"
         F Z=1:1 S DA=$O(^HLEV(776.4,DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;HLMA
         N Z
         S DA=0
         S DIK="^HLMA("
         F Z=1:1 S DA=$O(^HLMA(DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;INRHD
         N Z
         S DA=0
         S DIK="^INRHD("
         F Z=1:1 S DA=$O(^INRHD(DA)) Q:+DA=0  D
         .D ^DIK
         ;
         ;INXPORT - NOT AN FILEMAN FILE
         N Z
         S X=""
         F Z=1:1 S X=$O(^INXPORT(X)) Q:X=""  D
         .S K(X)=""
         S X=""
         F Z=1:1 S X=$O(K(X)) Q:X=""  D
         .K ^INXPORT(X)
         ;
         ;LAHM(62.49
         N Z
         S DA=0
         S DIK="^LAHM(62.49,"
         F Z=1:1 S DA=$O(^LAHM(62.49,DA)) Q:+DA=0  D
         .D ^DIK
