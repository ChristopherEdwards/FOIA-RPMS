BLRRLMV ; cmi/anch/maw - BLR View/Refile Raw Reference Lab Messages ;
 ;;5.2;LR;**1021,1030**;Jul 27, 2006;Build 9
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;
 ;this routine will allow the user to verify reference lab results
 ;before passing them on to PCC
 ;
MAIN ;EP - this is the main routine driver
 S BLRMF=$$ASK
 I $G(BLRMF)="F" D  Q
 . S BLRRF=$$ASKF
 . I $G(BLRRF)]"" D LOOP
 . D EOJ
 I $G(BLRMF)="M" D
 . S BLRMSG=$$ASKM
 . I $G(BLRMSG) D SM(BLRMSG)
 D EOJ
 Q
 ;
ASK() ;-- ask to look by message number or file
 S DIR(0)="S^M:Message Number;F:File",DIR("A")="Select by Message Number or File Name "
 D ^DIR
 K DIR
 Q $G(Y)
 ;
ASKF() ;-- ask file
 S DIR(0)="P^9009026.1",DIR("A")="Which Reference Lab Import File Do You Want To View "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ASKM() ;-- ask message number
 S DIR(0)="N",DIR("A")="Which Message Would You Like to View/Refile"
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
LEDI  ;EP - main LEDI driver
 N BLRAN,BLRIN,BLRYN
 S BLRAN=$$ASKA
 I $G(BLRAN) S BLRIN=$$ACCLOOK(BLRAN)
 I '$G(BLRIN) D EOJ Q
 S BLRYN=$$RFL
 I $G(BLRYN) D REPROC^HLUTIL(BLRIN,"D ORU^LA7VHL")
 D EOJ
 Q
 ;
RFL() ;-- ask if they want to refile
 S DIR(0)="Y",DIR("A")="Is this the entry you want to refile",DIR("B")="Y"
 D ^DIR
 Q +$G(Y)
 ;
ASKA() ;-- ask the accession number
 S DIR(0)="N",DIR("A")="Which Accession/Order # Would You Like to View/Refile "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ACCLOOK(ACC)  ;lets look up the accession number in HL(772
 N BLRDA,BLRIEN,BLRMT,BLRD,BLRI,BLRM
 S BLRMT=0
 S BLRDA=0 F  S BLRDA=$O(^HL(772,BLRDA)) Q:'BLRDA!($G(BLRMT))  D
 . S BLRIEN=0 F  S BLRIEN=$O(^HL(772,BLRDA,"IN",BLRIEN)) Q:'BLRIEN!($G(BLRMT))  D
 .. I $G(^HL(772,BLRDA,"IN",BLRIEN,0))[ACC,$$CHKMSG(BLRDA) D
 ... S BLRD=BLRDA,BLRI=BLRIEN,BLRMT=1
 I '$G(BLRD) W !,"Could not find an entry to refile" Q ""
 D WRT(BLRD)
 S BLRM=$O(^HLMA("B",BLRD,0))
 Q $G(BLRM)
 ;
CHKMSG(M) ;-- check to see if this is an ORU R01 message
 N MI
 S MI=$O(^HLMA("B",M,0))
 I 'MI Q 0
 I $$GET1^DIQ(779.001,$P($G(^HLMA(MI,0)),U,14),.01)="R01" Q 1
 Q 0
WRT(RD) ;-- lets call DIQ to display the entry
 N BLRI
 S BLRI=0 F  S BLRI=$O(^HL(772,RD,"IN",BLRI)) Q:'BLRI  D
 . W !,$G(^HL(772,RD,"IN",BLRI,0))
 Q
 ;
LOOP ;-- loop the xref and call VER
 I $O(^BLRRLG("B",0))="" D  Q
 . W !,"No Files to View"
 S DIC="^INTHU("
 S BLRVDA=0 F  S BLRVDA=$O(^BLRRLG(BLRRF,1,BLRVDA)) Q:'BLRVDA!$G(BLRVQ)  D
 . Q:$G(BLRVQ)
 . W @IOF
 . S (DA,BLRUIF)=$G(^BLRRLG(BLRRF,1,BLRVDA,0))
 . I '$G(^INTHU(BLRUIF,0)) D  Q
 .. W !!,"GIS HL7 Message "_BLRUIF_" has already been purged, cannot display"
 . D DIQ^BLRLMR(DIC,DA)
 W !!,"No More Messages in Batch, Exiting"
 H 2
 Q
 ;
SM(BLRUIF) ;-- view the message
 I '$D(^INTHU(BLRUIF)) D  Q
 . W !!,"GIS HL7 Message "_BLRUIF_" has already been purged, cannot display"
 S DIC="^INTHU("
 Q:$G(BLRVQ)
 W @IOF
 S (DA,BLRUIF)=BLRUIF
 D DIQ^BLRLMR(DIC,DA)
 Q
 ;
REF(UIF) ;-- mark entry as verified
 S ^INLHSCH(0,$H,UIF)=""
 Q
 ;cmi/flag/maw 4/8/2004 the following is not used anymore
 S BLRRL=$P($G(^BLRSITE(DUZ(2),"RL")),U)
 Q:'$G(BLRRL)
 S BLRRLE=$P($G(^BLRRL(BLRRL,0)),U)
 S BLRSCR=$O(^INRHS("B","Generated: HL IHS LAB R01 "_BLRRLE_" IN-I",0))
 Q:'$G(BLRSCR)
 S BLRRUN="S BLRRFL=$$^IS"_$$ZERO(BLRSCR)_BLRSCR_"("_UIF_")"
 X BLRRUN
 Q
 ;
EOJ ;-- kill variables
 D JOB^BLRPARAM
 D EN^XBVK("BLR")
 Q
 ;
ZERO(SCR)          ;-- find out how many zeros need to be installed
 I $L(BLRSCR)=1 Q "0000"
 I $L(BLRSCR)=2 Q "000"
 I $L(BLRSCR)=3 Q "00"
 I $L(BLRSCR)=4 Q "0"
 Q "0"
 ;
