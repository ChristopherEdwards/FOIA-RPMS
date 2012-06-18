ABSPOS2D ; IHS/FCS/DRS - Poke the queues ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
POKE ;EP - from ABSPOS2A ; protocol ABSPOS P2 POKE
 ; If things seem to be stalled, here's a kludgey way to start up
 ; more background jobs to give 'em a poke.
 W !,"Poking the pharmacy POS processing queues:",!
 I '$$LOCKPOS^ABSPOSUD Q
 W "."
 N A,B,ABSBRXI F A=40,50 D
 .S B="" F  S B=$O(^ABSPT("AD",A,B)) Q:'B  D
 ..W "."
 ..S ABSBRXI=B D SETSTAT^ABSPOSU(0) ; restart all of these
 ..D LOG59^ABSPOSL("POKE set this claim back to restart processing",B)
 D  ; kill all outbound claims, lest we send claims twice
 . N DIALOUT S DIALOUT=0
 . F  S DIALOUT=$O(^ABSPECX("POS",DIALOUT)) Q:'DIALOUT  D
 . . N LOCKED S LOCKED=$$LLIST^ABSPOSAP
 . . K ^ABSPECX("POS",DIALOUT,"C") ; kill outbound claims, locked or not
 . . I LOCKED D ULLIST^ABSPOSAP
 D ULOCKPOS^ABSPOSUD
 D TASK^ABSPOSIZ W "." H 1
 D TASK^ABSPOSQ1 W "." H 1
 N DIALOUT
 S DIALOUT=$$ANY2SEND^ABSPOSQJ
 I DIALOUT D TASK^ABSPOSQ2 W "." H 1
 S DIALOUT=$$ANYRESPS^ABSPOSQ4
 I DIALOUT D TASK^ABSPOSQ3() W "." H 1
 W "OK, they've been POKEd.",!
PZ Q
