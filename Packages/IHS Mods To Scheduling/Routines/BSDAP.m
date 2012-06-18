BSDAP ; IHS/ANMC/LJF - APPT PROFILE MENU ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; Displays menu of choices for appt profile question
 NEW BSDP,BSD,X,Y
 S BSDP=+$G(XQORNOD) Q:'BSDP    ;menu protocol
 D FULL^VALM1 W !
 S BSD=0 F  S BSD=$O(^ORD(101,BSDP,10,BSD)) Q:'BSD  D
 . S X=$G(^ORD(101,BSDP,10,BSD,0)) Q:'X
 . S Y=$$GET1^DIQ(101,+X,1)             ;menu item text
 . W !,$P(X,U,2),?10,Y                  ;display mnuemonic & text
 Q
