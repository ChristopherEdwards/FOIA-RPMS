BARDMAN4 ; IHS/SD/LSL - A/R Debt Collection Process (4) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/16/2004 - V1.8
 ;      Routine created.  Moved (modified) from BBMDC2
 ;      All entry points called from BARDMAN2.  Updates log from
 ;      each of the four temp globals if send was successful.
 ;
 ; ********************************************************************
 Q
 ;
LOGSSELF ; EP
 ; Log self pay stops
 S BARBL=0
 F  S BARBL=$O(^BARSSELF($J,BARBL)) Q:'+BARBL  D
 . D INACT                        ; first, inactivate previous record
 . S BARBAL=$E(^BARSSELF($J,BARBL),19,26)
 . S BARBAL=$E(BARBAL,1,($L(BARBAL)-2))_"."_$E(BARBAL,($L(BARBAL)-1),$L(BARBAL))
 . K DIC,DR,X,Y,DA
 . S DIC="^BARDEBT("
 . S DIC(0)="ZL"
 . S X=DT
 . S DIC("DR")=".02///^S X=BARBL"
 . S DIC("DR")=DIC("DR")_";.03///^S X=BARBAL"
 . S DIC("DR")=DIC("DR")_";.04////^S X=$E(^BARSSELF($J,BARBL),27)"
 . S DIC("DR")=DIC("DR")_";.05////^S X=1"
 . S DIC("DR")=DIC("DR")_";.06////^S X=""S"""
 . S DIC("DR")=DIC("DR")_";.07///^S X=""SELF PAY"""
 . S DIC("DR")=DIC("DR")_";.08///^S X=DUZ(2)"
 . S DIC("DR")=DIC("DR")_";.09///^S X=BARSSFN"
 . S DLAYGO=90050
 . K DD,DO
 . D FILE^DICN
 K DIE,DIC,DR,DA,X,Y
 S DIE="^BAR(90052.06,DUZ(2),"
 S DA=DUZ(2)
 S DR="1105////^S X=BARSTART"
 S DR=DR_";1106////^S X=BAREND"
 D ^DIE
 Q
 ; ********************************************************************
 ;
LOGSTOP ; EP
 ; Log insurer stops
 S BARBL=0
 F  S BARBL=$O(^BARSTOPS($J,BARBL)) Q:'+BARBL  D
 . D INACT                        ; first, inactivate previous record
 . S BARBAL=$E(^BARSTOPS($J,BARBL),27,34)
 . S BARBAL=$E(BARBAL,1,($L(BARBAL)-2))_"."_$E(BARBAL,($L(BARBAL)-1),$L(BARBAL))
 . K DIC,DR,X,Y,DA
 . S DIC="^BARDEBT("
 . S DIC(0)="ZL"
 . S X=DT
 . S DIC("DR")=".02///^S X=BARBL"
 . S DIC("DR")=DIC("DR")_";.03///^S X=BARBAL"
 . S DIC("DR")=DIC("DR")_";.04////^S X=$E(^BARSTOPS($J,BARBL),26)"
 . S DIC("DR")=DIC("DR")_";.05////^S X=1"
 . S DIC("DR")=DIC("DR")_";.06////^S X=""I"""
 . S DIC("DR")=DIC("DR")_";.07///^S X=$$GET1^DIQ(90050.01,BARBL,3)"
 . S DIC("DR")=DIC("DR")_";.08///^S X=DUZ(2)"
 . S DIC("DR")=DIC("DR")_";.09///^S X=BARSIFN"
 . S DLAYGO=90050
 . K DD,DO
 . D FILE^DICN
 K DIE,DIC,DR,DA,X,Y
 S DIE="^BAR(90052.06,DUZ(2),"
 S DA=DUZ(2)
 S DR="1105////^S X=BARSTART"
 S DR=DR_";1106////^S X=BAREND"
 D ^DIE
 Q
 ; ********************************************************************
 ;
INACT ;
 ; Inactivate last entry for this bill
 S BARLIEN=$O(^BARDEBT("C",BARBL,"A"),-1)
 Q:'+BARLIEN
 S DIE="^BARDEBT("
 S DA=BARLIEN
 S DR=".05////^S X=0"
 D ^DIE
 Q
 ; ********************************************************************
 ;
LOGTSELF ; EP
 ; Log Self Pay Starts
 S BARBL=0
 F  S BARBL=$O(^BARTSELF($J,BARBL)) Q:'+BARBL  D
 . K DIC,DR,X,Y,DA
 . S DIC="^BARDEBT("
 . S DIC(0)="ZL"
 . S X=DT
 . S DIC("DR")=".02///^S X=BARBL"
 . S DIC("DR")=DIC("DR")_";.03///^S X=$$GET1^DIQ(90050.01,BARBL,15)"
 . S DIC("DR")=DIC("DR")_";.04////^S X=0"
 . S DIC("DR")=DIC("DR")_";.05////^S X=1"
 . S DIC("DR")=DIC("DR")_";.06////^S X=""S"""
 . S DIC("DR")=DIC("DR")_";.07///^S X=""SELF PAY"""
 . S DIC("DR")=DIC("DR")_";.08///^S X=DUZ(2)"
 . S DIC("DR")=DIC("DR")_";.09///^S X=BARTSFN"
 . S DLAYGO=90050
 . K DD,DO
 . D FILE^DICN
 . D MSGTX(BARBL)
 ; Update current count and last start and stop in parameters
 K DIE,DIC,DR,DA,X,Y
 S DIE="^BAR(90052.06,DUZ(2),"
 S DA=DUZ(2)
 S DR="1006///^S X=BARSCUR"
 S DR=DR_";1105////^S X=BARSTART"
 S DR=DR_";1106////^S X=BAREND"
 D ^DIE
 Q
 ; ********************************************************************
 ;
LOGSTART ; EP
 ; Log Insurer Starts
 S BARBL=0
 F  S BARBL=$O(^BARSTART($J,BARBL)) Q:'+BARBL  D
 . K DIC,DR,X,Y,DA
 . S DIC="^BARDEBT("
 . S DIC(0)="ZL"
 . S X=DT
 . S DIC("DR")=".02///^S X=BARBL"
 . S DIC("DR")=DIC("DR")_";.03///^S X=$$GET1^DIQ(90050.01,BARBL,15)"
 . S DIC("DR")=DIC("DR")_";.04////^S X=0"
 . S DIC("DR")=DIC("DR")_";.05////^S X=1"
 . S DIC("DR")=DIC("DR")_";.06////^S X=""I"""
 . S DIC("DR")=DIC("DR")_";.07///^S X=$$GET1^DIQ(90050.01,BARBL,3)"
 . S DIC("DR")=DIC("DR")_";.08///^S X=DUZ(2)"
 . S DIC("DR")=DIC("DR")_";.09///^S X=BARTIFN"
 . S DLAYGO=90050
 . K DD,DO
 . D FILE^DICN
 . D MSGTX(BARBL)
 ; Update current count and last start and stop in parameters
 K DIE,DIC,DR,DA,X,Y
 S DIE="^BAR(90052.06,DUZ(2),"
 S DA=DUZ(2)
 S DR="1003///^S X=BARICUR"
 S DR=DR_";1105////^S X=BARSTART"
 S DR=DR_";1106////^S X=BAREND"
 D ^DIE
 Q
 ; ********************************************************************
MSGTX(BARBL) ;
 ; Create message transaction on bills sent to Transworld w/ start code
 Q:'+BARBL
 S BARTR=$$NEW^BARTR
 Q:BARTR<1
 S BARTRDT=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 S BARMSG="TRANSMITTED TO TRANSWORLD "_BARTRDT
 S DA=BARTR
 S DIE="^BARTR(DUZ(2),"
 S DR="12////^S X=DT"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";7////^S X=1"
 S DR=DR_";4////^S X=BARBL"
 S DR=DR_";10////^S X=$$GET1^DIQ(200,DUZ,29,""I"")"
 S DR=DR_";16////^S X=""P"""
 S DR=DR_";1001///^S X=BARMSG"
 D ^DIE
 Q
