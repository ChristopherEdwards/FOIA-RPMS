ACMFIX ;Fix Dt of Onset - Pat Lundgren - IHS Diabetes Register [ 03/16/01  2:47 PM ]
 ;This routine $O thru ACM(41 CMS REGISTER finds only IHS Diabetes
 ;Entries - Sets the HXDT to field 20 Date of Onset & stuffs this
 ;date in the ACM(44 CMS Diagnosis for the Client, if missing
 ;the Date of onset
 ;
START ;$O ^ACM(41,"B",3 - IHS DIABETES REGISTER ONLY
 S REG="" F  S REG=$O(^ACM(41,"B",REG)) Q:REG'=+REG  D
 . Q:REG'=3879
 . S REGIEN="" F  S REGIEN=$O(^ACM(41,"B",REG,REGIEN)) Q:REGIEN'=+REGIEN  D
 .. S HXDT=$P($G(^ACM(41,REGIEN,"CH")),U,1)
 .. S HXPT=$P($G(^ACM(41,REGIEN,0)),U,2)
 .. Q:HXPT=""
 .. Q:HXDT=""
 .. ;Q:$P(^ACM(44,DXIEN,0)U,1)'=3  D
 .. S DXIEN=$O(^ACM(44,"C",+HXPT,0)) I 'DXIEN Q
 .. S DXDT=$P($G(^ACM(44,DXIEN,"SV")),U,2)
 .. I DXDT="" S DIE="^ACM(44,",DA=DXIEN,DR="2////"_HXDT D ^DIE K DIE,DR,DA
 ;
 ;
