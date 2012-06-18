BTIUPOS3 ; IHS/ITSC/LJF - Continuation of post install process ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 Q
 ;
OBJCHK ;EP; clean up object description file .01 pointers
 NEW IEN,DIE,PNAME,SNAME,PTR,DR,DA
 S DIE="^BTIUOD("
 S IEN=0 F  S IEN=$O(^BTIUOD(IEN)) Q:'IEN  D
 . S PNAME=$$GET1^DIQ(9003130.1,IEN,.01)     ;name based on pointer
 . S SNAME=$$GET1^DIQ(9003130.1,IEN,.02)     ;name as stored in .02 field
 . I PNAME=SNAME Q                           ;skip if names match - installed ok
 . ;
 . S PTR=$O(^TIU(8925.1,"B",SNAME,0)) I PTR D   ;find correct pointer
 . . I $$GET1^DIQ(8925.1,PTR,.04)'="OBJECT" Q   ;make sure it is an object
 . . S DR=".01///`"_PTR,DA=IEN
 . . D ^DIE                                     ;then fix it
 Q
