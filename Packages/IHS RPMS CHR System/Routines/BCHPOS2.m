BCHPOS2 ; IHS/TUCSON/LAB - POST INIT - 3 ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;This routine adds the following entries into the
 ;  PROTOCAL:  1 - 99 entries of BCH HL7 SERVER CHRPC##
 ;
 ;
START ;start of routine
 Q:'$D(^ORD(101))
 ;
 D LOOKUPS ;                 do lookups for field variables
 D SETUP ;                   setup initial variables for DIC call
 D PROCESS ;                 populate the file with 99 entries
 D RINDEX ;                  re-index "^ORD(101,"
 ;
EOJ ; end of job
 K DIC,X,Y,DD,DO,D0,DA,DDH,DI,DIC,DIE,DR,DLAYGO
 K BCHCOND,BCHDIC,BCHDR,BCHEVNT,BCHFLG,BCHIEN,BCHISEQC,BCHITEM
 K BCHMTR,BCHNAME,BCHPKG,BCHPTR,BCHRPC,BCHSA,BCHTEXT,BCHVID
 K BCHN,BCHFAC,BCHCODE
 Q
 ;end of routine
 ;
 ;----------------------------------
PROCESS ;populate the file with 99 entries
 ;
 S BCHN=0 F BCHN=1:1:99 S:BCHN<10 BCHN=0_BCHN D  Q:BCHN>99
 .  S BCHRPC="CHRPC"_BCHN
 .  S BCHNAME="BCH HL7 SERVER "_BCHRPC
 .  I $D(^ORD(101,"B",BCHNAME)) W !,"....exists:  ",BCHNAME Q
 .  S BCHPTR=""
 .  S BCHPTR=$O(^HL(771,"B",BCHRPC,BCHPTR))
 .  Q:BCHPTR=""
 .  S DIC("DR")=BCHDR_";770.1////"_BCHPTR
 .  S X=BCHNAME
 .  K DD,DO
 .  S DIC=BCHDIC
 .  D FILE^DICN ;                    add entry
 .  I +Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 .  S BCHIEN=+Y
 .  W !,"....adding:  ",X
 .  K X,Y
 .  D MULTIPL ;                      add multiple entry
 .  Q
 Q
 ;
 ;
MULTIPL ; add multiple entry
 S DIC=BCHDIC_BCHIEN_",10,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(101,10,0),U,2)
 S DA(1)=BCHIEN
 S DIC("DR")="3////1"
 S X=BCHITEM
 K DD,DO
 D FILE^DICN
 I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 K X,Y
 Q
 ;
SETUP ; set up initial variables for DIC call
 S BCHTEXT="CHR Penbased HL7 ORU Message" ; ITEM TEXT field
 S BCHISEQC=1 ;                         SEQUENCE multiple field (ITEM)
 ;
 K DD,DO
 S BCHDIC="^ORD(101,",DIC(0)="L",DLAYGO=101
 ;S BCHDR="1////"_BCHTEXT_";4////E;12////"_BCHPKG_";770.5////i;770.6////P;770.8////"_BCHCOND_";770.9////"_BCHCOND_";770.95////"_BCHVID
 S BCHDR="1////"_BCHTEXT_";4////E;12////"_BCHPKG_";770.3////"_BCHMTR_";770.4////"_BCHEVNT_";770.5////i;770.6////P;770.8////"_BCHCOND_";770.9////"_BCHCOND_";770.95////"_BCHVID
 Q
 ;
LOOKUPS ; do lookups for the various fields
 S BCHFLG=1
 S (BCHPKG,BCHITEM,BCHSA,BCHCOND,BCHVID,BCHEVNT,BCHMTR)=0
 ;        lookup of PACKAGE entry ien
 S BCHPKG=$O(^DIC(9.4,"B","IHS RPMS CHR SYSTEM",BCHPKG))
 S:'BCHPKG BCHFLG=0
 ;        lookup of PROTOCOL file's ITEM entry ien
 S BCHITEM=$O(^ORD(101,"B","BCH HL7 ORU",BCHITEM))
 S:'BCHITEM BCHFLG=0
 ; following temporary "CHRPC15"...change to variable name!!!
 ;        lookup of the HL7 APPLICATION PARAMETER's CHRPC## entry ien
 S BCHSA=$O(^HL(771,"B","CHRPC15",BCHSA))
 S:'BCHSA BCHFLG=0
 ;        lookup of HL7 ACCEPT/APPLICATION ACK CONDITION file entry ien
 S BCHCOND=$O(^HL(779.003,"B","NE",BCHCOND))
 S:'BCHCOND BCHFLG=0
 ;        lookup of HL7 VERSION file entry ien
 S BCHVID=$O(^HL(771.5,"B","2.2",BCHVID))
 S:'BCHVID BCHFLG=0
 ;        lookup of MESSAGE TYPE RECEIVED file entry ien (multiple fld)
 S BCHMTR=$O(^HL(771.2,"B","ORU",BCHMTR))
 S:'BCHMTR BCHFLG=0
 ;        lookup of EVENT TYPE file entry ien (multiple fld)
 S BCHEVNT=$O(^HL(779.001,"B","R01",BCHEVNT))
 S:'BCHEVNT BCHFLG=0
 Q
 ;
RINDEX ;re-index the PROTOCOL file
 S DIK="^ORD(101,"
 W !!,"....Re-indexing the PROTOCOL file."
 D IXALL^DIK
 K DIK
 Q
 ;
