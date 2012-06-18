BAR277IQ ; IHS/SD/LSL - BAR Inquire to Status Response ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; Original routine created by cmi/flag/maw - V1.6 Patch 3
 ;
 ; ********************************************************************
 ;this routine will allow the user to verify reference lab results
 ;before passing them on to PCC
 ;
MAIN ;EP - this is the main routine driver
 D GIS^BARACSI                  ; Check for GIS patches 2 and 6
 I '+BARGIS D EOJ Q             ; GIS patches not installed
 S BARYN=$$ASKV
 I '$G(BARYN) D  Q
 . S BARENT=$$ENT
 . I '$G(BARENT) D EOJ Q
 . D INQ(BARENT)
 . D EOJ
 D LOOP
 D EOJ
 Q
 ;
ASKV() ;-- ask to mark all as verified
 S DIR(0)="Y",DIR("A")="Do you wish to look at all responses:"
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ENT() ;-- get an entry
 K DIC
 S DIC="^BARECLST(",DIC(0)="AEMQZ"
 S DIC("A")="Lookup which Entry: "
 D ^DIC
 Q +$G(Y)
 ;
INQ(ENT) ;-- inquire an entry
 S DIC="^BARECLST(",DA=ENT
 D DIQ^BAR277LM(DIC,DA)
 Q
 ;
LOOP ;-- loop the xref and call VER
 S DIC="^BARECLST("
 S BARVDA=0 F  S BARVDA=$O(^BARECLST(BARVDA)) Q:'BARVDA!$G(BARVQ)  D
 . Q:$G(BARVQ)
 . W @IOF
 . S DA=BARVDA
 . D DIQ^BAR277LM(DIC,DA)
 Q
 ;
DEL(DA) ;-- delete entry
 S DIK="^BARECLST("
 D ^DIK
 Q
 ;
EOJ ;-- kill variables
 D EN^XBVK("BAR")
 Q
 ;
