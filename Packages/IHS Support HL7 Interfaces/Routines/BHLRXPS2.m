BHLRXPS2 ; IHS/TUCSON/DCP - HL7 - POST-INIT FOR COTS PHARMACY INSTALLATION - 3 ;
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ; This routine adds entries into the PROTOCOL file. It is a
 ; continuation of BHLRXPST and is not independently callable.
 ;
START ; ENTRY POINT from BHLRXPST
 Q:'$D(^ORD(101))
 ;
LOOKUPS ; do lookups for the various fields
 ;        lookup of HL7 ACCEPT ACK CONDITION file entry ien
 S BHLACACK=$O(^HL(779.003,"B","ER",""))
 ;        lookup of HL7 APPLICATION ACK CONDITION file entry ien
 S BHLAPACK=$O(^HL(779.003,"B","AL",""))
 ;        lookup of HL7 VERSION file entry ien
 S BHLVID=$O(^HL(771.5,"B","2.2",""))
 ;        lookup of MESSAGE TYPE RECEIVED file entry ien (multiple fld)
 S BHLMTR=$O(^HL(771.2,"B","RDS",""))
 ;        lookup of EVENT TYPE file entry ien (multiple fld)
 S BHLEVNT=$O(^HL(779.001,"B","O01",""))
 ;        lookup of MESSAGE TYPE GENERATED file entry ien
 S BHLMTG=$O(^HL(771.2,"B","ACK",""))
 ;
 D SUBSCRIB ; set up subscriber (client) protocol
 D EVENT    ; set up event driver protocol
 ;
RINDEX ;re-index the PROTOCOL file
 S DIK="^ORD(101,"
 W !!,"....Re-indexing the PROTOCOL file."
 D IXALL^DIK
 ;
EOJ ; clean up and leave
 K X,Y,DD,DO,D0,DA,DDH,DI,DIC,DIE,DIK,DR,DLAYGO
 Q
 ;----------------------------------
PROCESS ;
 ;
 I $D(^ORD(101,"B",BHLNAME)) W !,"....exists:  ",BHLNAME Q
 S BHLPTR=$O(^HL(771,"B",BHLNAME,""))
 Q:BHLPTR=""
 ;
 K DD,DO
 S (BHLDIC,DIC)="^ORD(101,",DIC(0)="L",DLAYGO=101
 S DIC("DR")=BHLDR_";770."_$S(BHLTYPE="S":2,1:1)_"////"_BHLPTR
 ;
 S X=BHLNAME
 K DD,DO D FILE^DICN ;                    add entry
 I +Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 S BHLIEN=+Y
 S:BHLTYPE="S" ^ORD(101,BHLIEN,771)="D ^BHLBPS"
 W !,"....adding:  ",X
 K X,Y
 I BHLTYPE="E" D  ;                      add multiple entry
 . S BHLISEQC=1 ;                         SEQUENCE multiple field (ITEM)
 . S DIC=BHLDIC_BHLIEN_",10,"
 . S DIC(0)="L"
 . S DIC("P")=$P(^DD(101,10,0),U,2)
 . S DA(1)=BHLIEN
 . S DIC("DR")="3////1"
 . S X=BHLITEM
 . K DD,DO D FILE^DICN
 . I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 . K X,Y
 . Q
 Q
 ;
SUBSCRIB ; install subscriber protocol
 S BHLNAME="BHLBPS",BHLTEXT="Pharmacy Client Protocol",BHLTYPE="S"
 S BHLDR="1////"_BHLTEXT_";4////"_BHLTYPE_";12////"_BHLPKG_";770.3////"_BHLMTR_";770.4////"_BHLEVNT_";770.5////i;770.6////P;770.95////"_BHLVID_";770.11////"_BHLMTG_";773.1////0;773.2////0;773.3////0;773.4////0"
 D PROCESS
 S BHLITEM=$O(^ORD(101,"B",BHLNAME,"")) ; get ITEM entry IEN for the event driver protocol entry
 Q
 ;
EVENT ; install event driver protocol
 S BHLNAME="VIKRX",BHLTEXT="Viking Server Protocol",BHLTYPE="E"
 S BHLDR="1////"_BHLTEXT_";4////"_BHLTYPE_";12////"_BHLPKG_";770.3////"_BHLMTR_";770.4////"_BHLEVNT_";770.5////i;770.6////P;770.8////"_BHLACACK_";770.9////"_BHLAPACK_";770.95////"_BHLVID_";773.1////0;773.2////0;773.3////0;773.4////0"
 D PROCESS
 Q
