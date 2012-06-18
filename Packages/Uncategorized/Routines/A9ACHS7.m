A9ACHS7 ; IHS/ADC/GTH - CHS V 2.0 PATCH 7 R.P.I. ; [ 07/25/95  10:26 AM ]
 ;;2.0;CONTRACT HEALTH MGMT SYSTEM;**7**;NOV 01, 1994
 ;
 D START^ACHSP7
 ;
 Q:'$L($G(^%ZOSF("DEL")))
 NEW X
 F %=1:1 S X=$P($T(DEL+%),";",3) Q:X=""  X ^%ZOSF("DEL")
 Q
 ;
 ;;ACHSP7B - Don't delete, it's got the 3-node check in it.
DEL ;
 ;;ACHSP3
 ;;ACHSP4
 ;;ACHSP4A
 ;;ACHSP5
 ;;ACHSP5A
 ;;A9ACHS3
 ;;A9ACHS4
 ;;A9ACHS5
 ;;ACHSP6
 ;;ACHSP6A
 ;;ACHSP6B
 ;;ACHSP7
 ;;ACHSP7A
