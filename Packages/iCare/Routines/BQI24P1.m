BQI24P1 ;GDIT/HSCD/ALA-Version 2.4 Patch 1 ; 23 Oct 2015  10:57 AM
 ;;2.4;ICARE MANAGEMENT SYSTEM;**1**;Apr 01, 2015;Build 2
 ;
 ;
PRE ;EP
 Q
 ;
POS ;EP
 NEW TXN
 S TXN=$O(^ATXAX("B","BQI SUICIDE ATTEMPT DXS",""))
 I TXN'="" D
 . I '$D(^ATXAX(TXN,21,"B",300.9)) Q
 . K ^ATXAX(TXN,21)
 . S ^ATXAX(TXN,21,0)="^9002226.02101A^1^1"
 . S ^ATXAX(TXN,21,1,0)="T14.91 ^T14.91 ^30"
 . S ^ATXAX(TXN,21,"AA","T14.91 ","T14.91 ")=""
 . S ^ATXAX(TXN,21,"B","T14.91 ",3)=""
 ;
 ;Add new Measles Loinc taxonomy
 D ^BQIB
 ;
LTAX ;  Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX,D0,DINUM
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies
 D LDLAB(.LTAX)
 F BJ=1:1 Q:'$D(LTAX(BJ))  S X=LTAX(BJ) D
 . I $D(^ATXLAB("B",X)) Q  ; Skip pre-existing Lab taxonomies
 . D ^DIC S DA=+Y
 . I DA<1 Q
 . S BQTXUP(9002228,DA_",",.02)=$P(X," ",2,999)
 . S BQTXUP(9002228,DA_",",.05)=DUZ
 . S BQTXUP(9002228,DA_",",.06)=DT
 . S BQTXUP(9002228,DA_",",.09)=60
 . D FILE^DIE("I","BQTXUP")
 . S BQTXUP(9002228,DA_",",.08)="B"
 . D FILE^DIE("E","BQTXUP")
 ;
 K DA,BJ,BQTXUP,DIC,DLAYGO,DINUM,D0,DR,X,Y
 Q
 ;
LDLAB(ARRAY) ;EP;Load site-populated Lab tests
 NEW I,TEXT
 F I=1:1 S TEXT=$P($T(LAB+I),";;",2) Q:TEXT=""  S ARRAY(I)=TEXT
 Q
 ;
LAB ;EP;LAB TESTS (SITE-POPULATED)
 ;;BQI MEASLES ALERT TAX
