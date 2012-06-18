ABSPOSN4 ; IHS/FCS/DRS - NCPDP Fms F ILC A/R ;  [ 09/12/2002  10:16 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
PFM ;EP
 ;
 N XXX
 S $P(XXX,"X",80)=""
 N I F I=1:1:3 D
 .W !
 .W ?7,$E(XXX,1,15),?31,$E(XXX,1,20),!!
 .W ?6,$E(XXX,1,33),?46,"X",!!!
 .W ?5,$E(XXX,1,23),?29,$E(XXX,1,19),!
 .W ?49,$E(XXX,4,5),?52,$E(XXX,6,7)
 .W ?55,$E(XXX,2,3)
 .W ?58,"X",?60,"X",?63,"X",?66,"X",?69,"X",?72,"X",!
 .W ?5,$E(XXX,1,23),!
 .W ?56,"XXXX.XX",?64,"XXXX.XX",!
 .W ?5,$E(XXX,1,23),!
 .W ?56,"XXXX.XX",?64,"XXXX.XX",!
 .W ?6,$E(XXX,1,13),?20,$E(XXX,4,5)
 .W ?23,$E(XXX,6,7),?26,$E(XXX,2,3),!!
 .W ?6,$E(XXX,1,13),?20,$E(XXX,4,5)
 .W ?23,$E(XXX,6,7),?26,$E(XXX,2,3),!
 .W ?56,"XXXX.XX",?64,"XXXX.XX",!!
 .W ?4,$E(XXX,1,7),?12,$E(XXX,1,1)
 .W ?15,$E(XXX,1,5),?21,$E(XXX,1,4)
 .W ?26,$E(XXX,1,7),?34,$E(XXX,1,6)
 .W ?41,$E(XXX,1,2),?44,$E(XXX,1,9),!!
 .W ?4,$E(XXX,1,7),?12,$E(XXX,1,1)
 .W ?15,$E(XXX,1,5),?21,$E(XXX,1,4)
 .W ?26,$E(XXX,1,7),?34,$E(XXX,1,6)
 .W ?41,$E(XXX,1,2),?44,$E(XXX,1,9)
 .W ?56,"XXXX.XX",?64,"XXXX.XX",!!
 Q
