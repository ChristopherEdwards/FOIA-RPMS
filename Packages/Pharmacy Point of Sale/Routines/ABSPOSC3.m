ABSPOSC3 ; IHS/FCS/DRS - development - certification testing ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
RUNTEST(DIALOUT,FROM,THRU)    ;EP - from ABSPOSC2,ABSPOSC4
 I '$D(THRU) S THRU=FROM
 K ^ABSPECX("POS",DIALOUT)
 N I F I=FROM:1:THRU D
 . N J S J=$P(^ABSPC(I,"M",0),U,3)
 . S ^ABSPECX("POS",DIALOUT,"C",I,0)=J
 . N K F K=1:1:J D
 . . S ^ABSPECX("POS",DIALOUT,"C",I,K)=^ABSPC(I,"M",K,0)
 D TASK^ABSPOSQ2 ; which should start up COMMS^ABSPOSQ3
 Q
LASTCOMM ; print the last comms log - look backwards for the last .1 suffix
 S X=9999999999
 F  S X=$O(^ABSPECP("LOG",X),-1) Q:'X  Q:X#1=.1
 W "Comms log ",X,! H 1
 D PRINTLOG^ABSPOSL(X)
 Q
RESTOR02 ; by sending ASCII file A:\ABSPEC02.GSA
 N I,X,Y
 K ^TMP($J) N DONE
 W "SEND file A:\ABSPEC02.GSA in ASCII mode, you have 20 seconds:",!
 F I=1:1 R ^TMP($J,I):20 Q:'$T
 D CLR0203("YES")
 ;K ^ABSPC(*)
 W !,"Now setting the data values...",!
 F I=3:2 D  Q:$G(DONE)
 . S X=^TMP($J,I),Y=^TMP($J,I+1)
 . I X="*",Y="*" S DONE=1 Q
 . S @X=Y
 W "We processed up through line number ",I-1,!
 Q
CLR0203(X) ; erase all entries in 9002313.02 and .03 claims & responses
 I X'="YES" D  Q  ; must pass this parameter to say you're really sure
 . D IMPOSS^ABSPOSUE("P","TI","parameter X="_X,,"CLR0203",$T(+0))
 N IEN,DA,DR,DIE,FILE
 F FILE=9002313.02,9002313.03 DO CLR0203A(FILE)
 Q
CLR0203A(FILE) I X'="YES" D  Q
 . D IMPOSS^ABSPOSUE("P","TI","parameter X="_X,,"CLR0203A",$T(+0))
 N X,IEN,DIE,DA,DR
 W "Erasing all entries in file ",FILE,"..."
 S IEN=0 F  S IEN=$O(^ABSP(FILE,IEN)) Q:'IEN  D
 . S DIE=FILE
 . I DIE'=9002313.02,DIE'=9002313.03 D  Q  ; safety!
 . . D IMPOSS^ABSPOSUE("P","TI","DIE="_DIE,,"CLR0203A",$T(+0))
 . S DA=IEN,DR=".01///@"
 . D ^DIE
 . W:$X>70 !?5 W "."
 W !
 D ZWRITE^ABSPOS("IEN")
 Q
