AUMPRE33 ;IHS/OIT/CLS - AUM 9.1 patch 3 pre-init ;
 ;;9.1;AUM SCB UPDATE;**3**;NOV 11, 2008
 ;
 ; This is the pre-init for AUM*9.1*3. It strips the semicolons
 ; out of the ^AUTTEDT global prior to the install of the patch.
 ;
 ; Based on routine 2008 04 18-20 created by Rick Marshall
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at START by AUMPRE31 as the pre-init
 ; for AUM*9.1*3.
 ;
START ; AUM*9.1*3 PRE-INIT ; Resets .01 nodes of entries with semicolons
 ;
 D CHECK,CLEANUP
 Q
 ;
CHECK ; troubleshooting entry point
 ;
 N AUMCNTC S AUMCNTC=0 ; how many nodes had semicolons
 N AUMDA ; DA equivalent
 ;
 S AUMDA=0
 F  S AUMDA=$O(^AUTTEDT(AUMDA)) Q:'AUMDA  I $P(^AUTTEDT(AUMDA,0),"^")[";" D
 . ;
 . S AUMCNTC=AUMCNTC+1 ; add to our count of instances
 . W "=",AUMDA,"=" ; note presence of semicolon
 . W !,$P(^AUTTEDT(AUMDA,0),"^"),! ; write node
 ;
 W !!,"Number of nodes with semicolons: ",AUMCNTC
 QUIT  ; end of CHECK
 ;
CLEANUP ; replace entries with "CODE-PCC DATA ENTRY EDUC TOPIC"
 ;
 N AUMCNTC S AUMCNTC=0 ; how many nodes with semicolons are processed
 N AUMDA ; DA equivalent
 N AUM2P ; mnemonic from second piece of zero node
 N AUMCD ; ICD or CPT code from second piece
 N AUMMN ; PCC DATA ENTRY EDUC TOPIC mnemonic
 N AUMNN ; IEN, .01, finally new name for EDUCATION TOPIC file entry
 ;
 S AUMDA=0
 F  S AUMDA=$O(^AUTTEDT(AUMDA)) Q:'AUMDA  I $P(^AUTTEDT(AUMDA,0),"^")[";" D
 . ;
 . S AUMCNTC=AUMCNTC+1 ; add to our count of instances
 . S AUM2P=$P(^AUTTEDT(AUMDA,0),"^",2) ; get mnemonic from primary file #9999999.09
 . S AUMCD=$P(AUM2P,"-") ; get ICD/CPT code
 . S AUMMN=$P(AUM2P,"-",2) ; get mnemonic from secondary file #9001002.5
 . S AUMNN=$O(^APCDEDCV("C",AUMMN,0)) ; get ien of entry in secondary file
 . S AUMNN=$P(^APCDEDCV(AUMNN,0),"^") ; get .01 of entry in secondary file
 . S AUMNN=AUMCD_"-"_AUMNN ; create new .01 for primary file
 . S $P(^AUTTEDT(AUMDA,0),"^",1)=AUMNN ; set replacement for .01 in primary file
 . W "=",AUMDA,"=" ; note presence of semicolon - corrected
 . W !,$P(^AUTTEDT(AUMDA,0),"^"),! ; write new node
 ;
 W !!,"Number of nodes with semicolons that were cleaned up: ",AUMCNTC
 QUIT  ; end of CHECK
 ;
 ; end of routine AUMPRE33
