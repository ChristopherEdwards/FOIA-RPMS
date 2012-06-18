BARBADX ; IHS/SD/LSL - MESSAGES CROSS REFERENCE INDICES ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;** mumps cross reference routine to set message indices
 ;
SAM4 ;EP - ** set index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 S ^BARTR(DUZ(2),"AM4",X,DA)=""
 Q
 ; *********************************************************************
 ;
KAM4 ;EP  - kill index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 K ^BARTR(DUZ(2),"AM4",X,DA)
 Q
 ; *********************************************************************
 ;
SAM5 ;EP -  set index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 S ^BARTR(DUZ(2),"AM5",X,DA)=""
 Q
 ; *********************************************************************
 ;
KAM5 ;EP - kill index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 K ^BARTR(DUZ(2),"AM5",X,DA)
 Q
 ; *********************************************************************
 ;
SAM6 ;EP - set index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 S ^BARTR(DUZ(2),"AM6",X,DA)=""
 Q
 ; *********************************************************************
 ;
KAM6 ;EP - kill index
 Q:'$P(^BARTR(DUZ(2),DA,0),U,7)
 K ^BARTR(DUZ(2),"AM6",X,DA)
 Q
