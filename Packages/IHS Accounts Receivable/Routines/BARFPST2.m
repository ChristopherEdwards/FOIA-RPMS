BARFPST2 ; IHS/SD/LSL - A/R FLAT RATE POSTING (CONT) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
DOC ;
 ; LSL - 12/31/1999 - Created routine
 ;       Contains code for saving data to A/R FLAT RATE POSTING File
 ;;
 Q
 ; *********************************************************************
BARSAV ; EP
 ; EP - Save data in A/R FLAT RATE POSTING File 
 S BARFRPC=$$VAL^XBDIQ1(200,DUZ,1)  ; Initials of user
 D NOW^%DTC                         ; Current date/time
 S BARDT=%                          ; FM entry date
 ; FRP postable amount
 S BARPAMT=$$VAL^XBDIQ1(90051.1101,"BARCOL,BARITM",19)
 D:'$D(BARIEN) NEWENTRY             ; Create new entry
 Q:$D(BARNONE)                      ; Q if entry to FRP file fails
 D CORDAT                           ; Save data not placed in a mult
 D:$D(BARADJ) ADJDAT                ; Save adjustment data
 D FACDAT                           ; Save facility data
 Q
 ; *********************************************************************
 ;
NEWENTRY ;
 ; Create new entry in A/R FLAT RATE POSTING File
 ; Build BARNAME
 S Y=BARDT X ^DD("DD")              ; Entry date in external format
 S BARNAME=BARFRPC_"-"_Y            ; FRP batch name (init-date)
 ; Create new entry
 K DIC
 S DIC="^BARFRP(DUZ(2),"
 S DIC(0)="L"
 S DIC("P")=$P(^DIC(90054.01,0),U,2)
 S X=BARNAME
 K DD,DO
 D FILE^DICN                        ; Add entry to FRP
 K DIC
 I +Y<1 D  Q
 . W *7
 . W !!,"Entry in A/R FLAT RATE POSTING File was not created."
 . W !,"Contact your supervisor."
 . S BARNONE=1                      ; Flag - entry failed
 S BARIEN=+Y                        ; IEN to A/R FLAT RATE POSTING File
 Q
 ; *********************************************************************
 ;
CORDAT ;
 ; Enter data in A/R FLAT RATE POSTING File that doesn't go in a mult
 K DA,DR,DIE
 S DIE="^BARFRP(DUZ(2),"
 S DA=BARIEN                        ; IEN to A/R FLAT RATE POSTING File
 S DR=".02////"_BARDT               ; Date Entered
 S DR=DR_";.04////"_BARCOL          ; Batch Name
 S DR=DR_";.05////"_BARITM          ; Batch Item Number
 S DR=DR_";.06////"_DUZ             ; FRP Entry Clerk
 S DR=DR_";.08////"_DUZ(2)          ; Parent Facility
 S:$D(BARPAY) DR=DR_";.09///"_BARPAY  ; Payment Amount
 S DR=DR_";.1///"_BARPAMT           ; Item postable amount
 D ^DIE
 Q
 ; *********************************************************************
 ;
ADJDAT ;
 ; Enter data in Adjustments multiple of A/R FLATE RATE POSTING File
 ; Kill current Adjustments multiple in A/R FLAT RATE POSTING File
 S DA(1)=BARIEN                     ; IEN to A/R FLAT RATE POSTING File
 S DIK="^BARFRP(DUZ(2),"_DA(1)_",1,"
 S I=0
 F  S I=$O(^BARFRP(DUZ(2),DA(1),1,I)) Q:'+I  D  ; Loop adjustments
 . S DA=I
 . D ^DIK                           ; Kill Adjustment entry
 S I=0
 F  S I=$O(BARADJ(I)) Q:'+I  D      ; Loop Adjustment array
 . S BARSCAT=$P(BARADJ(I),U,2)      ; IEN to A/R TABLE TYPE /IHS (Cat)
 . S BARSTYP=$P(BARADJ(I),U,4)      ; IEN to A/R TABLE ENTRY /IHS (Type)
 . S BARSAMT=$P(BARADJ(I),U)        ; Adjustment Amount
 . K DIC
 . S DIC="^BARFRP(DUZ(2),"_BARIEN_",1,"
 . S DIC("P")=$P(^DD(90054.01,10,0),U,2)
 . S DIC(0)="L"
 . S DIC("DR")=".02////"_BARSTYP_";.03////"_BARSAMT
 . S X=BARSCAT
 . K DD,DO
 . D FILE^DICN                      ; Create Adjustment entry
 Q
 ; *********************************************************************
 ;
FACDAT ;
 ; Enter facility data
 S BARENTF=$D(^BARFRP(DUZ(2),BARIEN,2,"B",BAREOB))
 ; If this Fac not in A/R FLAT RATE POSTING File, create new entry
 I BARENTF=0!(BARENTF=1) D
 . K DIC
 . S DA(1)=BARIEN                   ; IEN to A/R FLAT RATE POSTING File
 . S DIC="^BARFRP(DUZ(2),"_BARIEN_",2,"
 . S DIC("P")=$P(^DD(90054.01,20,0),U,2)
 . S DIC(0)="L"
 . S X=BAREOB                       ; IEN to VISIT LOC mult of A/R COLL
 . K DD,DO
 . D FILE^DICN                      ; Create VISIT LOC entry in FRP
 . S BARFIEN=+Y                     ; IEN to VISIT LOC mult of FRP
 E  S BARFIEN=$O(^BARFRP(DUZ(2),BARIEN,2,"B",BAREOB,""))
 Q
 ; *********************************************************************
 ;
TOT(X) ; EP
 ; EP - Computed field ITEM BALANCE
 ; X = FRP Batch IEN
 S (I,BARCNT)=0
 F  S I=$O(^BARFRP(DUZ(2),X,2,I)) Q:'+I  D
 . S J=0
 . F  S J=$O(^BARFRP(DUZ(2),X,2,I,3,J)) Q:'+J  D
 . . S BARCNT=BARCNT+1                       ; Number of bills
 S BARPAMNT=$P($G(^BARFRP(DUZ(2),X,0)),U,9)  ; Payment amount
 S BARTOT=BARPAMNT*BARCNT                    ; Total Payments 
 Q BARTOT
 ; *********************************************************************
 ;
FACTOT(X,Y)        ; EP
 ; EP - computed field TOTAL POSTED AMOUNT  (by visit location)
 ; X = FRP batch IEN
 ; Y = FAC IEN
 S BARCNT=0
 N I
 S I=0
 F  S I=$O(^BARFRP(DUZ(2),X,2,Y,3,I)) Q:'+I  D
 . S BARCNT=BARCNT+1                         ; Number of bills this FAC
 S BARPAMNT=$P($G(^BARFRP(DUZ(2),X,0)),U,9)  ; Payment amount
 S BARFTOT=BARPAMNT*BARCNT                   ; Total payments
 Q BARFTOT
