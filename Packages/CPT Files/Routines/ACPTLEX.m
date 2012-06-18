ACPTLEX ; IHS/ITSC/LJF,SDR - Move ICPT multiple to other systems  [ 07/22/2003  2:04 PM ]
 ;;2.03;CPT FILES;**2**;DEC 04, 2002 
 ; New routine - 05/2003
 ; Routine supplied by Linda Fels.  Minor mods have been made to
 ; account for CPT files that may not be correct to get the most
 ; hits and to account for a temp file specifically for errors.
 ;
 Q
 ;
BUILD ;EP; build temp global for transport
 K ^ACPTMP("ICPT")
 NEW X
 S X=0 F  S X=$O(^ICPT(X)) Q:'X  M ^ACPTMP("ICPT",X,0)=^ICPT(X,0) M ^ACPTMP("ICPT",X,60)=^ICPT(X,60)
 Q
 ;
PRE ;EP; remove old field 405.3 which uses 81.02 subfile number
 NEW DIU,DIK
 S DIU=81.02,DIU(0)="S" D EN^DIU2
 S DIK="^DD(81,",DA=409.3,DA(1)=81 D ^DIK
 Q
 ;
POST ;EP; build effective date multiple for ^ICPT global
 ;I '$D(^ACPTMP("ICPT")) W !!,"NO DATA GLOBAL FOUND!" Q
 ;K ^ACPTMP("ICPTE")     ;error global
 K ^ACPTEMP("ICPTE")     ;error global  
 NEW IEN,XCOD,INACTIVE,DELDT,ADDDT
 S IEN=0
 F  S IEN=$O(^ICPT(IEN)) Q:IEN'=+IEN  D
 . S ACPTCD=$P($G(^ICPT(IEN,0)),"^")  ;actual CPT code
 . I ACPTCD="" S ^ACPTEMP("ICPTE",IEN,0)="NO CPT CODE" Q
 . S ACPTIEN=$O(^ACPTMP("B",ACPTCD,0))  ;what IEN into tmp file is
 . I ACPTIEN="" S ^ACPTEMP("ICPTE",IEN,0)="NO CODE IN OUR FILE" Q
 . ;
 . ; check if already has effective date multiple
 . Q:$O(^ICPT(IEN,60,0))
 . ;
 . ; do data checks
 . S XCOD=$P($G(^ACPTMP(ACPTIEN,0)),U)
 . I XCOD'=$P(^ICPT(IEN,0),U) S ^ACPTEMP("ICPTE",IEN,0)=XCOD Q   ;codes are different
 . ;
 . S INACTIVE=$$GET1^DIQ(81,IEN,5,"I")
 . I INACTIVE,$$GET1^DIQ(81,IEN,8)="" S ^ACPTEMP("ICPTE",IEN,0)="NO DATE DELETED" Q
 . I 'INACTIVE I $$GET1^DIQ(81,IEN,7,"I")<$$GET1^DIQ(81,IEN,8,"I") S ^ACPTEMP("ICPTE",IEN,0)="EARLIER ADD DATE" Q
 . ;
 . ; add effective date data
 . ;M ^ICPT(IEN,60)=^ACPTMP(ACPTIEN,60)  ;IHS/SD/SDR 8/21/03
 . ;IHS/SD/SDR 8/21/03
 . S ACPTCNT=0
 . F  S ACPTCNT=$O(^ACPTMP(ACPTIEN,60,ACPTCNT)) Q:ACPTCNT=""  D
 .. S ACPTEDT=$P($G(^ACPTMP(ACPTIEN,60,ACPTCNT,0)),"^")
 .. S ACPTSTA=$P($G(^ACPTMP(ACPTIEN,60,ACPTCNT,0)),"^",2)
 .. S X=ACPTEDT
 .. S DA(1)=ACPTIEN
 .. S DIC="^ICPT("_ACPTIEN_",60,"
 .. S DIC(0)="LMX"
 .. S DIC("P")=$P(^DD(81,60,0),"^",2)
 .. S DIC("DR")=".02///"_ACPTSTA
 .. D ^DIC
 . ;IHS/SD/SDR 8/21/03 
 . ;
 . ; now fill in if no effective date added
 . Q:$O(^ICPT(IEN,60,0))
 . I INACTIVE S DELDT=$$GET1^DIQ(81,IEN,8,"I") Q:'DELDT  D ADD(IEN,DELDT,0) Q
 . I 'INACTIVE S ADDDT=$$GET1^DIQ(81,IEN,7,"I") Q:'ADDDT  D ADD(IEN,ADDDT,1)
 ;
 ; now remove temp file and data
 NEW DIU,DIK
 S DIU=90335,DIU(0)="DT"
 D EN^DIU2
 ;
 ; add/edit/delete codes effective 7/1/2003
 D START^ACPT23P2
 Q
 ;
ADD(IEN,DATE,STATUS) ; stuff effective date multiple
 ; IEN=CPT internal entry number
 ; DATE=effective date
 ; STATUS=1 for active, 0 for inactive
 NEW DD,DO,DIC,X,DA,DLAYGO
 S DIC(0)="L",DLAYGO=81.02,DIC("P")=$P(^DD(81,60,0),U,2)
 S DIC="^ICPT("_IEN_",60,"
 S DA(1)=IEN
 S X=DATE
 S DIC("DR")=".02///"_STATUS
 D FILE^DICN
 Q
 ;
RESET ;EP; delete 60 multiple to start over
 NEW IEN
 S IEN=0 F  S IEN=$O(^ICPT(IEN)) Q:'IEN  K ^ICPT(IEN,60)
 Q
