ABMUPOSC ; IHS/SD/SDR - Close POS cashiering sessions ;
 ;;2.5;IHS Third Party Billing System;**15**;AUG 22, 2008
 ;
 Q
 ;
EN ;PEP - Finds all open POS cashiering sessions and closes them
 ;
 K ABMO
 D FINDAOPN^ABMUCUTL  ;find all open sessions
 S ABMSDT=0
 F  S ABMSDT=$O(ABMO(ABMSDT)) Q:+ABMSDT=0  D
 .S ABMUSER=""
 .F  S ABMUSER=$O(ABMO(ABMSDT,ABMUSER)) Q:ABMUSER=""  D
 ..Q:(ABMUSER'="POS")  ;only want POS sessions
 ..D CLOSESES^ABMUCUTL(ABMLOC,ABMUSER,ABMSDT)
 ..;W !?2,ABMLOC,?20,ABMUSER,?40,ABMSDT  used for testing to see what was closing without actually closing
 Q
