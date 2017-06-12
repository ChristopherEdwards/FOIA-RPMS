BW2P13IN ;GDIT/HS/ALA-Installation routine ; 19 Mar 2014  11:36 AM
 ;;2.0;WOMEN'S HEALTH;**13**;APR 19, 1996;Build 9
 ;
PRE ;EP
 NEW CMN,BN,BWUP,TEXT
 F TEXT="CONE BIOPSY","CRYOTHERAPY","ECTOCERVICAL BIOPSY","ENDOCERVICAL CURETTAGE","ENDOMETRIAL BIOPSY","NEEDLE BIOPSY" D UPD(TEXT,TEXT)
 D UPD("MASTECTOMY,UNSPECIFIED","MASTECTOMY")
 Q
 ;
UPD(TEXT,TEXT1) ;EP
 S CMN=$O(^BTPW(90621,"B",TEXT,"")) I CMN="" Q
 I $P(^BTPW(90621,CMN,0),U,5)="" D
 . S BN=$O(^BWPN("B",TEXT1,"")) I BN="" Q
 . S BWUP(90621,CMN_",",.05)=BN
 I $D(BWUP) D FILE^DIE("","BWUP","ERROR")
 Q
 ;
POS ;EP
 ;
 NEW BN,OK,TEXT,VALUE,CMN,TN,TAX,CPT
 S BN=$O(^BWPN("B","CLINICAL BREAST EXAM",""))
 I BN'="" D
 . S BWUP(9002086.2,BN_",",.12)="9000010.18",BWUP(9002086.2,BN_",",.16)="@"
 . S VAL=$O(^ICPT("BA","S0613 ",""))
 . I VAL'="" S BWUP(9002086.2,BN_",",.08)=VAL
 S BN=0
 F  S BN=$O(^BWPN(BN)) Q:'BN  D
 . I $P(^BWPN(BN,0),U,12)'="9000010.08" Q
 . S OK=0
 . F I=1:1 S TEXT=$P($T(PR+I),";;",2) Q:TEXT=""  I $P(TEXT,U,1)=$P(^BWPN(BN,0),U,1) S OK=1,VALUE=TEXT
 . I OK D  Q
 .. I $P(VALUE,U,2)="" Q
 .. S BWUP(9002086.2,BN_",",.12)="9000010.18",BWUP(9002086.2,BN_",",.08)=$P(VALUE,U,2),BWUP(9002086.2,BN_",",.14)="@"
 . I 'OK D
 .. S CMN=$O(^BTPW(90621,"AP",BN,"")) I CMN="" Q
 .. S TN=0 F  S TN=$O(^BTPW(90621,CMN,1,TN)) Q:'TN  D
 ... I $P(^BTPW(90621,CMN,1,TN,0),U,3)'=5 Q
 ... S TAX=$P(^BTPW(90621,CMN,1,TN,0),U,1),REF="BWTAX" K @REF
 ... D BLD^BQITUTL(TAX,.REF)
 ... S CPT=$O(BWTAX(CPT)) Q:CPT=""  I $P(^ICPT(CPT,0),U,7)="",$P(^ICPT(CPT,0),U,8)<DT S BWUP(9002086.2,BN_",",.08)=CPT Q
 ... S BWUP(9002086.2,BN_",",.12)="9000010.18",BWUP(9002086.2,BN_",",.14)="@"
 I $D(BWUP) D FILE^DIE("","BWUP","ERROR")
 Q
 ;
PR ;EP Procedures
 ;;COLPOSCOPY IMPRESSION (NO BX)^57452
 ;;COLPOSCOPY W/BIOPSY^57454
 ;;CONE BIOPSY^57520
 ;;CRYOTHERAPY^57061
 ;;ECTOCERVICAL BIOPSY^57500
 ;;ENDOCERVICAL CURRETTAGE^57505
 ;;ENDOMETRIAL BIOPSY^58100
 ;;FINE NEEDLE ASPIRATION^10021
 ;;HYSTERECTOMY^58150
 ;;LASER ABLATION^58353
 ;;LASER CONE^57522
 ;;LEEP^57460
 ;;LUMPECTOMY^19301
 ;;MASTECTOMY^19303
 ;;NEEDLE BIOPSY^19100
 ;;OPEN BIOPSY^19101