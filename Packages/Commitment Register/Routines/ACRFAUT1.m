ACRFAUT1 ;IHS/OIRM/DSD/THL,AEF - AUTO CREATION OF REQUEST - CON'T;  [ 07/23/2002  5:43 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**3**;NOV 05, 2001
 ;;ROUTINE CONTROLS AUTOMATIC CREATION OF REQUEST/PURCHASE ORDER
SS ;EP;DUPLICATE SS ENTRIES
 S X=ACRJ
 S DIC="^ACRSS("
 S DIC(0)="L"
 D FILE^ACRFDIC
 S (DA,ACRSS2)=+Y
 S %X="^ACRSS("_ACRDA_","
 S %Y="^ACRSS("_(ACRSS2)_","
 D %XY^%RCR
 K %X,%Y
 S DIK="^ACRSS("
 D IX1^ACRFDIC
 S DA=ACRSS2
 S DIE="^ACRSS("
 S DR=".02////"_ACROBL2              ; Pointer to Request file ;ACR*2.1*3.13
 S DR=DR_";.03////"_ACROBL2          ; Pointer to FMS Document file ;ACR*2.1*3.13
 S DR=DR_";.2////"_ACROBL2           ; PO node:Purchase Order pointer ;ACR*2.1*3.13
 I $D(ACRNOT),$D(ACRTDDA) D          ; Duplicate a document ;ACR*2.1*3.13
 .S DR=DR_";.05////"_$P($G(^ACRLOCB(ACRTDDA,"DT")),U,9)  ; CAN ;ACR*2.1*3.13
 .S DR=DR_";.06////"_ACRTDDA         ; DEPARTMENT ACCOUNT pointer ;ACR*2.1*3.13
 .S DR=DR_";14///0"                  ; QUANTITY RECEIVED ;ACR*2.1*3.13
 .S DR=DR_";14.1///0"                ; QUANTITY DUE IN ;ACR*2.1*3.13
 .S DR=DR_";15///0"                  ; QUANTITY ACCEPTED ;ACR*2.1*3.13
 .S DR=DR_";15.2///@"                ; RECEIVING OFFICIAL ;ACR*2.1*3.13
 .S DR=DR_";15.3///@"                ; DATE SIGNED ;ACR*2.1*3.13
 .S DR=DR_";16///@"                  ; TOTAL TO BE PAID ;ACR*2.1*3.13
 .S DR=DR_";16.1///@"                ; TOTAL PAID ;ACR*2.1*3.13
 .S DR=DR_";17///@"                  ; QUANTITY INVOICED ;ACR*2.1*3.13
 .S DR=DR_";18///@"                  ; ITEM OBLIGATED AMOUNT ;ACR*2.1*3.13
 .S DR=DR_";32///@"                  ; INVOICE UNIT COST ;ACR*2.1*3.13
 .S DR=DR_";33///@"                  ; EXPIRATION DATE ;ACR*2.1*3.13
 D DIE^ACRFDIC
 I '$D(ACRAMEND),'$D(ACRNOT) D
 .S DA=ACRDA
 .S DIE="^ACRSS("
 .S DR="13///0;16///0;16.1///0;18///0"
 .K ^ACRSS("C",ACRDOCDA,ACRDA),^ACRSS("J",ACRDOCDA,ACRDA),^ACRSS("E",ACRDOCDA,+$G(^ACRSS(ACRDA,0)),ACRDA)
 .W !,"Item No. ",+^ACRSS(ACRDA,0)," has been transferred to the new requisition."
 Q
DAYS ;EP;
 N ACRTV2
 S ACRDA=0
 F ACRJ=1:1 S ACRDA=$O(^ACRTV("D",ACRDOCDA,ACRDA)) Q:'ACRDA  D
 .S X=ACRJ
 .S DIC="^ACRTV("
 .S DIC(0)="L"
 .D FILE^ACRFDIC
 .S (DA,ACRTV2)=+Y
 .S %X="^ACRTV("_ACRDA_","
 .S %Y="^ACRTV("_(ACRTV2)_","
 .D %XY^%RCR
 .K %X,%Y
 .S DIK="^ACRTV("
 .D IX1^ACRFDIC
 .S DA=ACRTV2
 .S DIE="^ACRTV("
 .S DR=".02////"_(ACROBL2)_";.03////"_(ACROBL2)_";.07////"_ACROBL2
 .D DIE^ACRFDIC
 Q
