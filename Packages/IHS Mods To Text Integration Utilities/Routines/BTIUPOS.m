BTIUPOS ; IHS/ITSC/LJF - IHS post initialization actions ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 Q
 ;
CLEAN ;EP; clean up item lists in TIU files
 ; TIU Document Definition file
 ; remove those items listed under a class or document class that
 ; were not included in the distribution
 ;
 D BMES^XPDUTL("Remove bad pointers under class and document class groupings . . .")
 NEW DOC,IEN,X,DIK,DA
 S DOC=0 F  S DOC=$O(^TIU(8925.1,DOC)) Q:'DOC  D
 . S IEN=0 F  S IEN=$O(^TIU(8925.1,DOC,10,IEN)) Q:'IEN  D
 . . S X=$P(^TIU(8925.1,DOC,10,IEN,0),U)    ;item pointer
 . . I $D(^TIU(8925.1,X,0)) Q               ;skip if pointer is good
 . . ;
 . . S DIK="^TIU(8925.1,"_DOC_",10,",DA(1)=DOC,DA=IEN
 . . D ^DIK         ;remove bad pointer
 ;
 ; reindex AAU xref on TIU Document Definition file
 D BMES^XPDUTL("Reindiexing AAU xref in TIU Document Definition file . . .")
 K ^TIU(8925,"AAU")
 S DIK="^TIU(8925,",DIK(1)="1202^AAU" D ENALL^DIK
 ;
 ; TIU Template file
 ; --- remove items under each entry where pointer is set to -1
 D BMES^XPDUTL("Cleaning up bad pointer in TIU Template file . . .")
 NEW IEN,IEN2,DIK,DA,X
 S IEN=0 F  S IEN=$O(^TIU(8927,IEN)) Q:'IEN  D
 . S IEN2=0 F  S IEN2=$O(^TIU(8927,IEN,10,IEN2)) Q:'IEN2  D
 . . S X=$P(^TIU(8927,IEN,10,IEN2,0),U,2)
 . . Q:$D(^TIU(8927,X,0))                ;skip if good pointer
 . . ;
 . . S DIK="^TIU(8927,"_IEN_",10,",DA(1)=IEN,DA=IEN2
 . . D ^DIK               ;remove bad pointer
 ;
 ; --- make sure patient/visit objects set up okay
 D OBJ
 ;
 D BMES^XPDUTL("Updating Object Methods . . .")
 ; remove write access to Object Method if still set
 I ^DD(8925.1,9,9)="@" S ^DD(8925.1,9,9)=""
 ;
 ; modify Object Method for 3 inpt objects
 NEW OBJ,DIE,DR,DA,X,Y
 S DIE="^TIU(8925.1,"
 S DA=$O(^TIU(8925.1,"B","ADMITTING PROVIDER",0))
 I $$GET1^DIQ(8925.1,+DA,.04)="OBJECT" D
 . S DR="9///S X=$$CURPRV^BTIULO6(DFN,""ADM"")" D ^DIE
 ;
 S DA=$O(^TIU(8925.1,"B","REFERRING PROVIDER",0))
 I $$GET1^DIQ(8925.1,+DA,.04)="OBJECT" D
 . S DR="9///S X=$$CURPRV^BTIULO6(DFN,""REF"")" D ^DIE
 ;
 S DA=$O(^TIU(8925.1,"B","CURRENT ATTENDING",0))
 I $$GET1^DIQ(8925.1,+DA,.04)="OBJECT" D
 . S DR="9///S X=$$CURPRV^BTIULO6(DFN,""ATT"")" D ^DIE
 ;
 ; clean up Object Description file if items not installed correctly
 ;   KIDS does not resolve pointers so .01 field must be checked
 D OBJCHK^BTIUPOS3
 Q
 ;
DDMFIX ;EP; update upload error filing code for progress notes and consults
 ; KIDS install won't update this if document definition already there
 ; change was released in VA patch 131 seq 127
 D BMES^XPDUTL("Updating error filing code; VA patch 131 seq 127 . . .")
 NEW DIE,DA,DR,CONS
 S DIE=8925.1,DA=3,DR="4.8///D PNFIX^TIUPNFIX" D ^DIE    ;fix progress notes
 ;
 S CONS=0 F  S CONS=$O(^TIU(8925.1,"B","CONSULTS",CONS)) Q:'CONS  D
 . Q:$$GET1^DIQ(8925.1,CONS,4.8)=""   ;if nothing there, don't update
 . S DIE=8925.1,DA=CONS,DR="4.8///D CNFIX^TIUCNFIX" D ^DIE  ;fix consults
 Q
 ;
PCCLNK ;EP -- add TIU to PCC Visit Merge Utility
 D BMES^XPDUTL("Adding TIU to PCC Visit Merge Utility . . .")
 Q:$D(^APCDLINK("B","TEXT INTEGRATION UTILITY"))  ;already exists
 NEW DD,DO,DIC,DLAYGO,X,Y
 S DIC="^APCDLINK(",DIC(0)="LE",DLAYGO=9001002
 S DIC("DR")="1///I $L($T(MRG^BTIULINK)) D MRG^BTIULINK"
 S DIC("DR")=DIC("DR")_";.02///TIU"
 S X="TEXT INTEGRATION UTILITY" D FILE^DICN
 Q
 ;
VSTLINK ;EP -- add TIU to Visit Tracking file so TIU can create visits in EHR
 D BMES^XPDUTL("Adding TIU to VISIT TRACKING file . . .")
 NEW PKG,DD,DO,DIC,X,DLAYGO
 S PKG=$O(^DIC(9.4,"C","TIU",0)) Q:'PKG
 Q:$D(^DIC(150.9,1,3,"B",PKG))   ;already exists
 S DIC="^DIC(150.9,1,3,",DIC(0)="L",DLAYGO=150.93,DA(1)=1
 S DIC("P")=$P(^DD(150.9,3,0),U,2)
 S X="TEXT INTEGRATION UTILITIES",DIC("DR")="4///1"
 D ^DIC
 Q
 ;
OBJ ; add new objects in TIU Template file to class containers
 ; either add to Patient Data Objects or Patient Inpt Objects
 ;
 D BMES^XPDUTL("Resequencing patient objects . . .")
 ; first make sure Patient Inpt Objects listed under Shared Templates
 NEW X,PIO,ST,Y,DIC
 S PIO=$$PTR("Patient Inpatient Objects") Q:PIO<1
 S ST=$$PTR("Shared Templates") Q:ST<1
 I '$D(^TIU(8927,"AD",PIO,ST)) D
 . S DIC="^TIU(8927,"_ST_",10,",DA(1)=ST,DIC(0)="L"
 . S DIC("P")=$P(^DD(8927,10,0),U,2),DIC("DR")=".02///"_PIO
 . S X=$O(^TIU(8927,ST,10,"B",9999),-1),X=X+1
 . D ^DIC
 ;
 ; re-sequence items under Object containers; add any that are missing
 NEW BTIUN
 F BTIUN="Patient Data Objects^NEWOBJ","Patient Inpatient Objects^NEWINPT" D
 . NEW PDO,IEN,NAME,BTIUX,LINE,NUM,DIC,DA,X,Y,SEQ,DIE,DR,BTIUP,BTIUQ
 . S PDO=$$PTR($P(BTIUN,U)) Q:PDO<1
 . ; put all objects under class container, in temporary alphabetical array
 . S IEN=0 F  S IEN=$O(^TIU(8927,PDO,10,IEN)) Q:'IEN  D
 .. S NAME=$$GET1^DIQ(8927.03,IEN_","_PDO,.02) Q:NAME=""
 .. S BTIUX(NAME)=IEN
 . ;
 . ; find all new objects not under container
 . S BTIUQ=+$O(^TIU(8927,PDO,10,"B",9999),-1)     ;find highest sequence already entered for container
 . S LINE=$P(BTIUN,U,2)                           ;name of line label
 . F NUM=1:1 S NAME=$P($T(@LINE+NUM),";;",2) Q:NAME=""  I '$D(BTIUX(NAME)) D
 .. S BTIUP=$$PTR(NAME) Q:BTIUP<1                 ;not in file
 .. S DIC="^TIU(8927,"_PDO_",10,",DA(1)=PDO,DIC(0)="L"
 .. S DIC("P")=$P(^DD(8927,10,0),U,2)
 .. S X=BTIUQ+1,DIC("DR")=".02///"_NAME
 .. D ^DIC
 .. I Y>0 S BTIUQ=BTIUQ+1,BTIUX(NAME)=+Y
 . ;
 . ; now put full list in alpha order in file
 . S (SEQ,NAME)=0 F  S NAME=$O(BTIUX(NAME)) Q:NAME=""  D
 .. S SEQ=SEQ+1
 .. S DIE="^TIU(8927,"_PDO_",10,",DA(1)=PDO,DA=+BTIUX(NAME)
 .. S DR=".01///"_SEQ
 .. D ^DIE
 ;
 ;inactivate obsolete object (INSERT_USERS_ORDERS
 S DA=$O(^TIU(8925.1,"B","INSERT_USERS_ORDERS",0))
 I DA S DIE=8925.1,DR=".07////INACTIVE" D ^DIE
 ;
 ; fix HL7 codes for Flu shot objects
 S DA=$O(^TIU(8925.1,"B","LAST FLU SHOT",0))
 I DA S ^TIU(8925.1,DA,9)="S X=$$LASTIMM^BTIULO2(+$G(DFN),""15^16^88^111;FLU SHOT"",1)"
 ;
 S DA=$O(^TIU(8925.1,"B","LAST FLU SHOT DATE",0))
 I DA S ^TIU(8925.1,DA,9)="S X=$$LASTIMM^BTIULO2(+$G(DFN),""15^16^88^111;FLU SHOT"",0)"
 ;
 Q
 ;
PTR(X) ; returns IEN in TIU Template file for name in X
 NEW DIC,Y
 S DIC=8927,DIC(0)="X" D ^DIC
 Q +Y
 ;
NEWOBJ ;;
 ;;Address-One Line;;
 ;;Emergency Contact;;
 ;;Immunizations Due;;
 ;;Visit Chief Complaint;;
 ;;Visit CPT Codes;;
 ;;Visit Immunizations;;
 ;;Visit Labs;;
 ;;Visit Orders;;
 ;;Visit Pat Education;;
 ;;Visit Pat Education Multi-Line;;
 ;;visit POV;;
 ;;Visit POV Multi-Line;;
 ;;Visit Procedures;;
 ;;Visit Procedures Multi-Line;;
 ;;Visit Skin Tests;;
 ;;Visit Vitals - Brief;;
 ;;Visit Vitals - Detailed;;
 ;;BMI;;
 ;;Community;;
 ;;Eligibility;;
 ;;Future Appointments;;
 ;;Last Flu Shot;;
 ;;Last Mammogram;;
 ;;Last Pap;;
 ;;Last Pneumovax;;
 ;;MH Meds Manager;;
 ;;MH Provider;;
 ;;Patient Address;;
 ;;Patient Age - Detailed;;
 ;;Patient Phone;;
 ;;Primary Care Provider;;
 ;;Religion;;
 ;;Problems-Active;;
 ;;Problems-Inactive;;
 ;;Problems-Updated;;
 ;;
NEWINPT ;;
 ;;Admitting Dx;;
 ;;Admitting Provider;;
 ;;Current Admission;;
 ;;Current Attending;;
 ;;Current Diet;;
 ;;Current Inpt Service;;
 ;;Current Ward;;
 ;;Current Ward-Room;;
 ;;Referring Provider;;
