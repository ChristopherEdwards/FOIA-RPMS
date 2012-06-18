AMHGUVF ; IHS/CMI/MAW - AMH GUI Visit Form Utilities (frmVisitDataEntry) 2/13/2009 8:51:56 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
 Q
 ;
FNDPOV(IEN,R) ;-- find POV based on ien of pov and amhrec ptr
 N DA,POV
 S POV=0
 S DA=0 F  S DA=$O(^AMHRPRO("AD",R,DA)) Q:'DA!($G(POV))  D
 . N AMHPOV
 . S AMHPOV=$P($G(^AMHRPRO(DA,0)),U)
 . I AMHPOV=IEN S POV=DA Q
 Q $G(POV)
 ;
