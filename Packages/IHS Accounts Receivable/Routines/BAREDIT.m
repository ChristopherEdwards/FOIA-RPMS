BAREDIT ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI TRANSPORT FILE (1) ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 08/01/2002 - V1.7 Patch 4
 ;     For HIPAA compliance.  Make 835 v4010 entry in A/R EDI
 ;     TRANSPORT FILE.
 ;
 ; *********************************************************************
 ;
 ; If running this routine for to create new transports, inside the
 ; code please change the initial values of the following variables:
 ;
 ;    BARNAME         Name of EDI transport adding
 ;    BARSEPCD        Line tag|routine containing code to determine
 ;                    seperators
 ;    BARTABLE        Data Type for table elements
 ;    BARPRVST        Provider Beginning segment
 ;    BARPRVEN        Provider Ending segment
 ;    BARTRAIL        Trailer beginning segment
 ;
 ; *********************************************************************
START ; EP
 D INIT                    ; Initialize variables
 I $D(^BAREDI("1T","B","HIPAA 835 v4010")) D  Q
 . W !!,"HIPAA 835 v4010 Transport already exists"
 . D XIT
 ; Create new entry ^BAREDI("1T",
 I '$D(^BAREDI("1T","B","HIPAA 835 v4010")) D ENTRY
 I '+$G(BAREDITR) D  Q     ; Entry creation failed
 . W !!,"EDI TRANSPORT ENTRY NOT CREATED"
 . D XIT
 . Q
 D SEGMENT^BAREDIT2        ; Create Segment Table (and element)
 D VARPROC                 ; Create Variable Processing Table
 D UPDTAB                  ; Update EDI table entries
 D XIT
 Q
 ; *********************************************************************
INIT ;
 ; Initialize variables
 S BARNAME="HIPAA 835 v4010"     ; Name of transport
 S BARSEPCD="SEP|BAREDPA1(IMPDA)"   ; Code identifying seg,etc seperator
 S BARTABLE="ID"           ; Data Type for table elements
 S BARPRVST="LX"           ; Provider Beginning segment
 S BARPRVEN="CLP"          ; Provider Ending segment
 S BARTRAIL="SE"          ; Trailer beginning segment
 S BARDELIM=";;"           ; Delimeter (FM doesn't like "" in DR string)
 Q
 ; *********************************************************************
ENTRY ;
 ; Create entry in A/R EDI TRANSPORT File
 S DIC="^BAREDI(""1T"","
 S DIC(0)="LZ"
 S X=BARNAME
 S DIC("DR")=".02///^S X=BARSEPCD"
 S DIC("DR")=DIC("DR")_";.03///^S X=BARTABLE"
 S DIC("DR")=DIC("DR")_";.04///^S X=BARPRVST"
 S DIC("DR")=DIC("DR")_";.05///^S X=BARPRVEN"
 S DIC("DR")=DIC("DR")_";.06///^S X=BARTRAIL"
 K DD,DO
 D FILE^DICN
 Q:Y<0
 S BAREDITR=+Y
 Q
 ; *********************************************************************
VARPROC ;
 ; Create entries in VARIABLE PROCESSING multiple of A/R EDI TRANSPORT
 S BARVCNT=0
 F  D VARPROC2  Q:BARVP="END"
 Q
 ; *********************************************************************
VARPROC2 ;
 S BARVCNT=BARVCNT+1
 S BARVP=$P($T(@1+BARVCNT),";;",2,3)
 Q:BARVP="END"
 D VARPROC3
 Q
 ; *********************************************************************
VARPROC3 ;
 K DA,DIC,X,Y
 S DA(1)=BAREDITR
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 S DIC(0)="LZ"
 S DIC("P")=$P(^DD(90056.01,70,0),U,2)
 S X=$P(BARVP,BARDELIM)
 S DIC("DR")=".02///^S X=$P(BARVP,BARDELIM,2)"
 K DD,DO
 D FILE^DICN
 Q
 ; *********************************************************************
 ;
UPDTAB ;
 ; Update processing routine in A/R EDI TABLES
 K DIE,DR,DA
 S DIE="^BARETBL("
 S DA=33
 S DR=".03///D CLMADJCD|BAREDP02"
 D ^DIE
 K DA,DR
 S DA=34
 S DR=".03///D RMKCODE|BAREDP02"
 D ^DIE
 K DA,DR,DIE
 Q
 ; ********************************************************************
XIT ;
 D ^BARVKL0
 Q
 ; *********************************************************************
1 ;;VARIABLE;;ROUTINE
 ;;VCLMDATE;;CLMDATE|BAREDPA1
 ;;VADJAMT;;ADJAMT|BAREDPA1
 ;;VBILNUM;;BILNUM|BAREDPA1
 ;;VPRCONBR;;VPRCNTCT|BAREDPA1
 ;;VCHECK;;HIPAACHK|BAREDPA1
 ;;VPAYEE;;PAY|BAREDPA1
 ;;VPATHIC;;PATIENT|BAREDPA1
 ;;END
