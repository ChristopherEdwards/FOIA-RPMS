GMRAZDSF ;IHS/MSC/PLS - Patch support;01-May-2012 09:07;DU
 ;;4.0;Adverse Reaction Tracking;**1004**;Mar 29, 1996;Build 20
 ;
EN ;EP -
 N AIEN,REACT,GMRAAR,GMRAPA,ING,CLS
 S AIEN=0 F  S AIEN=$O(^GMR(120.8,AIEN)) Q:'+AIEN  D
 .S REACT=$P($G(^GMR(120.8,AIEN,0)),U,2)
 .I REACT'="" D
 ..S (ING,CLS)=""
 ..S ING=$O(^GMR(120.8,AIEN,2,0))
 ..S CLS=$O(^GMR(120.8,AIEN,3,0))
 ..I +CLS=0&(+ING=0) D
 ...S GMRAAR=$P($G(^GMR(120.8,AIEN,0)),U,3)
 ...S GMRAPA=AIEN
 ...D EN1^GMRAOR9
 Q
