BARCLE ; IHS/SD/LSL - Collection Entry for EOBs ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; IHS/ASDS/LSL -06/15/01 - V1.5 Patch 1 - NOIS HQW-0201-100027
 ;     FM 22 issue.  Modified to include E in DIC(0)
 ;
 ; *********************************************************************
 ;
EOB ;EP for EOB entries
 K DR
 S DIE=BARDIC_BARCLDA_",1,"
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DR="11;"
 S:+BARSPAR(2,"I") DR=DR_"12;"
 S DR=DR_"S DIE(""NO^"")=""BACK"";101;7;8;"
 S:+BARSPAR(3,"I") DR=DR_"10;"
 S DR=DR_"201//^S X=$G(BARBL(3));301;16//^S X=BARCLID(3)"
 W:(BARCLID(2,"I")="E") !,"Up Arrow at check number to exit loop & KILL the New Entry"
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE("NO^")
 I $D(Y) S BARQUIT=1 Q  ; user up arrowed out
 ; -------------------------------
 ;
EOBSUB ;EP
 ; Enter data for sub EOB locations and amounts
 ;
LOOP ;EP
 ; loop subs for entries and amounts
 K DIC,DR,DA,DIE
 S DA(2)=BARCLDA
 S DA(1)=BARITDA
 S DIC="^BARCOL(DUZ(2),"_BARCLDA_",1,"_BARITDA_",6,"
 S DIC(0)="EAQMLZ"
 S DIC("P")=$P(^DD(90051.1101,601,0),U,2)
 F  S DIC(0)="AEQMLZ",DIC("W")="W ?35,$J($P(^(0),U,2),8,2)" D ^DIC Q:+Y'>0  S DIE=DIC,DA=+Y,DR="2;S BARAMT=X" S DIDEL=90050 D ^DIE K DIDEL D:'BARAMT KILLSUB K DIC("P")
 D BARCLIT^BARCLU
 I +BARCLIT(202.5)'=0 W !,"BALANCE OFF BY ",BARCLIT(202.5) G LOOP
 ;
ENDEOB ;
 Q
 ; *********************************************************************
 ;
KILLSUB ; EP
 ; kill eob sub when the entry is 0
 D ^XBNEW("KSUB^BARCLE:DA*;DIE")
 Q
 ; *********************************************************************
 ;
KSUB ;EP
 ; kill eob sub
 S DIK=DIE
 D ^DIK
 Q
 ; *********************************************************************
 ;
INSERT ;
CHECK ;EP
 ; for checks
 S DR="11;"
 S:+BARSPAR(2,"I") DR=DR_"12;"
 S DR=DR_"101;Q;6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;6;5;7;8;Q;"
 S:+BARSPAR(3,"I") DR=DR_"10;"
 S DR=DR_"201//^S X=$G(BARBL(3));301;16//^S X=BARCLID(3)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
CC ;EP credit card
