BAREDP0A ; IHS/SD/SDR - AR ERA Posting check; 01/30/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**20**;OCT 26,2005
 ;
 Q
POSTCHK(IMPDA) ;EP
 ;BARFLG=1 when a claim has been posted from the ERA
 S CLMDA=0,BARFLG=1
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:'CLMDA  D  Q:'BARFLG
 .S IENS=CLMDA_","_IMPDA_","
 .I $$GET1^DIQ(90056.0205,IENS,".02","I")="P" S BARFLG=0
 Q BARFLG
 ;
SELCK ;select check in file
 K BARCKIEN
 S I=0
 W !!?2,"There are multiple checks in this ERA file:"
 W !?8,"CHECK#",?40,"CK AMT",?52,"PAYER",!?12,"Collection Batch - Item"
 F  S I=$O(^BAREDI("I",DUZ(2),IMPDA,5,I)) Q:'I  D
 .S IENS=I_","_IMPDA_","
 .W !,?3,I,?8,$P($G(^BAREDI("I",DUZ(2),IMPDA,5,I,0)),U),?40,$P($G(^BAREDI("I",DUZ(2),IMPDA,5,I,0)),U,3),?52,$E($P($G(^BAREDI("I",DUZ(2),IMPDA,5,I,0)),U,6),1,28)
 .W:($$GET1^DIQ(90056.02011,IENS,.07)'="") !?12,$$GET1^DIQ(90056.02011,IENS,.07)_" - "_$$GET1^DIQ(90056.02011,IENS,.08)
 .W:($$GET1^DIQ(90056.02011,IENS,.07)="") !?12,"No batch found for ERA check"
 .S:($G(BARLST)'="") BARLST=BARLST_";"_I_":"_$P($G(^BAREDI("I",DUZ(2),IMPDA,5,I,0)),U)
 .S:($G(BARLST)="") BARLST=I_":"_$P($G(^BAREDI("I",DUZ(2),IMPDA,5,I,0)),U)
 W !
 D ^XBFMK
 S DIR(0)="SO^"_BARLST
 S DIR("A")="Select CHECK/EFT TRACE # to Review"
 D ^DIR
 I Y>0 S BARCKIEN=+Y,IENS=BARCKIEN_","_IMPDA_",",BARCHK=$$GET1^DIQ(90056.02011,IENS,.01)
 Q
