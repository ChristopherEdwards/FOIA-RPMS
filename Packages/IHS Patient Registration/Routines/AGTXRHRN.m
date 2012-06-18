AGTXRHRN ; IHS/ASDS/EFG - utility for investigating valid Official Registration FAC:HRN ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;****************************************************************
 ;
 ;This is a utility for investigating Official Registration Fac:HRNs
 ;NEEDS DFN
 ;given AGRSITE it will test/return AGRHRN=0 OR = HRN if it is valid
 ;not given AGRSITE it will return an AGRSITE
 ;and AGRHRN =0 if none or with valid entries
 ;
 ;****************************************************************
 ;
 I $G(AGRSITE) D  G END
 . D HRN
 . S:'$D(^AGFAC("AC",AGRSITE)) AGRHRN=0
 S AGRSITE=0
 F  S AGRSITE=$O(^AGFAC("AC",AGRSITE)) Q:AGRSITE'>0  D HRN I $G(AGRHRN) G END ;--->
 G END
 ;****************************************************************
HRN ;EP -
 ;find valid HRN for AGRSITE,DFN
TSTHRN ;
 ;test HRN validity  uses AGRSITE returns AGRHRN if found and valid
 S AGRHRN=0
 Q:'$D(^AUPNPAT(DFN,41,AGRSITE,0))  ;no data
 S X=$P(^AUPNPAT(DFN,41,AGRSITE,0),U,2)
 S (DA,D1)=AGRSITE
 S (DA(1),D0)=DFN
 X $P(^DD(9000001.41,.02,0),U,5,99)
 K DA,D1,D0
 Q:'$G(X)  ;fails input test
 S AGRHRN=$P(^AUPNPAT(DFN,41,AGRSITE,0),"^",2)
 S AGRHRN("DT")=$P(^AUPNPAT(DFN,41,AGRSITE,0),U,3)
 S AGRHRN("S")=$P(^AUPNPAT(DFN,41,AGRSITE,0),U,5)
 I (AGRHRN'?1.6N)!(AGRHRN("S")="M") S AGRHRN=0 Q  ;fails pattern or merge
 I '$G(AGRHRN("DT")) Q  ;passes, NO DELETES,INACTIVE
 I AGRHRN("S")="I" Q  ;Inactivated records pass
 S AGRHRN=0 ;all deletes fail .. calling routine must handle error
 Q
 ;****************************************************************
END ;
 K AGRHRN("DT"),AGRHRN("S"),X,X1,X2
 Q
