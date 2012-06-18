BAR18DSP ; IHS/SD/LSL - Convert BBMD Files to AR Files ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - Convert Debt Collection to AR
 ;
 ; ********************************************************************
 Q
START ; EP
 Q:'$D(^BBMDC(90119.7))                ; Debt Collection not installed
 D PARAM                     ; convert Site Parameters
 D PAYER                     ; convert Restricted Payers
 D LOG                       ; convert Log file
 Q
 ; ********************************************************************
 ;
PARAM ;
 Q:$D(^BARTMP("1.8","SITE PARAM","STOP"))
 W !!,"Converting Debt Collection Site Parameters to AR Site Parameters...",!!
 S ^BARTMP("1.8","SITE PARAM","START")=$H
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BBMDC(90119.7,DUZ(2))) Q:'+DUZ(2)  D CONVERT
 S DUZ(2)=BARHOLD
 W !!,"DONE"
 S ^BARTMP("1.8","SITE PARAM","STOP")=$H
 Q
 ; ********************************************************************
 ;
CONVERT ;
 Q:'$D(^BBMDC(90119.7,DUZ(2),0))       ; Just habit
 S DIC="^BAR(90052.06,DUZ(2),"
 S X=$$GET1^DIQ(90119.7,DUZ(2),.01)
 S DIC(0)="EM"
 K DD,DO
 D ^DIC
 I Y<1 D  Q
 . W !,"A/R Site Parameter not defined for ",$$GET1^DIQ(90119.7,DUZ(2),.01)
 . W !,"Cannot convert Debt Collection Site Parameters."
 S BARD0=$G(^BBMDC(90119.7,DUZ(2),0))
 S BARD1=$G(^BBMDC(90119.7,DUZ(2),1))
 S DIE=DIC
 S DA=+Y
 S DIDEL=90052
 ;
 S DR=""
 I $P(BARD0,U,2)]"" S DR=DR_";1001///^S X=$P(BARD0,U,2)"     ;TSI ins #
 I +$P(BARD0,U,10) S DR=DR_";1002///^S X=$P(BARD0,U,10)"     ;max ins
 I +$P(BARD1,U,3) S DR=DR_";1003///^S X=$P(BARD1,U,3)"       ;ins tx's
 I $P(BARD0,U,6)]"" S DR=DR_";1004///^S X=$P(BARD0,U,6)"      ;TSI sp #
 I +$P(BARD0,U,11) S DR=DR_";1005///^S X=$P(BARD0,U,11)"     ;max sp
 I +$P(BARD1,U,4) S DR=DR_";1006///^S X=$P(BARD1,U,4)"       ;sp tx's
 I $P(BARD0,U,3)]"" S DR=DR_";1007///^S X=$P(BARD0,U,3)"     ;extr dir
 I $P(BARD0,U,5)]"" S DR=DR_";1008///^S X=$P(BARD0,U,5)"     ;Rpt dir
 I $E(DR)=";" S DR=$E(DR,2,999)
 D ^DIE
 ;
 S DR=""
 I +$P(BARD0,U,4) S DR=DR_";1101///^S X=$P(BARD0,U,4)"       ;Min prnc
 I +$P(BARD0,U,9) S DR=DR_";1102///^S X=$P(BARD0,U,9)"       ;min age
 I +$P(BARD0,U,7) S DR=DR_";1103///^S X=$P(BARD0,U,7)"       ;early dos
 I +$P(BARD0,U,8) S DR=DR_";1104///^S X=$P(BARD0,U,8)"       ;erly srch
 I +$P(BARD1,U) S DR=DR_";1105///^S X=$P(BARD1,U)"         ;last frm
 I +$P(BARD1,U,2) S DR=DR_";1106///^S X=$P(BARD1,U,2)"       ;last to
 I $E(DR)=";" S DR=$E(DR,2,999)
 D ^DIE
 ;
 ;OLD INFORMATION NOT NEEDED FOR NEW SYSTEM
 ;S DR="1201///^S X=+$P(BARD0,U,13)"                          ;Auto?
 ;I +$P(BARD0,U,14) S DR=DR_";1202///^S X=$P(BARD0,U,14)"     ;sch freq
 ;I +$P(BARD0,U,15) S DR=DR_";1203///^S X=$P(BARD0,U,15)"     ;auto date
 ;I +$P(BARD1,U,5) S DR=DR_";1204///^S X=$P(BARD1,U,5)"       ;cur task
 ;D ^DIE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PAYER ;
 ; Convert payers for each Debt collection site defined.
 Q:$D(^BARTMP("1.8","PAYER","STOP"))
 W !!,"Converting Debt Collection Restricted Payers to AR Site Parameters...",!!
 S ^BARTMP("1.8","PAYER","START")=$H
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BBMDC(90119.7,DUZ(2))) Q:'+DUZ(2)  D PAYER2
 S DUZ(2)=BARHOLD
 W !!,"DONE"
 S ^BARTMP("1.8","PAYER","STOP")=$H
 Q
 ; ********************************************************************
 ;
PAYER2 ;
 W !
 K DIC,DR,DA,DIE,X,Y
 S X=$$GET1^DIQ(90119.7,DUZ(2),.01)
 S DIC="^BAR(90052.06,DUZ(2),"
 S DIC(0)="EM"
 K DD,DO
 D ^DIC
 I Y<1 D  Q
 . W !,"A/R Site Parameter not defined for ",$$GET1^DIQ(90119.7,DUZ(2),.01)
 . W !,"Cannot convert Debt Collection Restricted Payers."
 S BARINS=0
 F  S BARINS=$O(^BBMDC(90119.9,BARINS)) Q:'+BARINS  D PAYER3
 Q
 ; ********************************************************************
 ;
PAYER3 ;
 ; This finds the insurer.
 I '$D(^BARAC(DUZ(2),"B",BARINS_";AUTNINS(")) D  Q
 . W !!,"Insurer ",$$GET1^DIQ(9999999.18,BARINS,.01)," not found in A/R Account File.  Cannot convert."
 S BARAC=$O(^BARAC(DUZ(2),"B",BARINS_";AUTNINS(",0))
 ;S X=$$GET1^DIQ(90050.02,BARAC,.01)
 ;S X=+$$GET1^DIQ(90050.02,BARAC,.01,"I")
 S X=BARAC
 K DIC,DIE,DR,Y
 S DA(1)=DUZ(2)
 S DIC="^BAR(90052.06,DUZ(2),"_DA(1)_",13,"
 S DLAYGO=90052
 S DIC(0)="MQLZ"
 S DIC("P")=$P(^DD(90052.06,1300,0),U,2)
 S DIC("DR")=".02////^S X=$P(^BBMDC(90119.9,BARINS,0),U,2)"
 K DD,DO
 D FILE^DICN
 I $P(Y,U,3)=1 Q                 ; If new entry quit
 S DIE=DIC
 S DR=".02////^S X=$P(^BBMDC(90119.9,BARINS,0),U,2)"
 D ^DIE
 Q
 ; ********************************************************************
 ;
LOG ;
 ; Convert Debt Collection Log File to A/R Debt Collection Log file
 Q:$D(^BARTMP("1.8","LOG","STOP"))
 W !!,"Converting Debt Collection Log File to AR Debt Collection Log file..."
 S ^BARTMP("1.8","LOG","START")=$H
 M ^BARDEBT=^BBMDC(90119.8)
 S ^BARDEBT(0)="A/R DEBT COLLECTION LOG^90050.05D^"
 S BARLOC=$O(^BBMDC(90119.7,0))
 Q:'+BARLOC
 S BARLIEN=0
 S BARCNT=0
 F  S BARLIEN=$O(^BARDEBT(BARLIEN)) Q:'+BARLIEN  D
 . S BARCNT=BARCNT+1
 . K X,Y,DR,DIE,DIC,DA
 . S DIE="^BARDEBT("
 . S DR=".08////^S X=BARLOC"
 . S DA=BARLIEN
 . D ^DIE
 S $P(^BARDEBT(0),U,3)=DA
 S $P(^BARDEBT(0),U,4)=BARCNT
 W !!,"DONE"
 S ^BARTMP("1.8","LOG","STOP")=$H
 Q
