CIAZALTQ ;CIA/PLS - Query Alert Global for Corrupt Entries;16-Aug-2004 08:43;PLS
 ;;1.0
EN ;
 D CLEANUP
 D:$$CHECK() PROMPT
 D CLEANUP
 Q
CHECK() ;Entry to loop thru the ^XTV(8992 global looking for entries
 ;without a zero node.
 U IO
 W !,"Checking Alert Global..."
 N CIAUSR,CIAADT
 S CIAUSR=0
 F  S CIAUSR=$O(^XTV(8992,CIAUSR)) Q:CIAUSR<.1  D
 . S CIAADT=0 F  S CIAADT=$O(^XTV(8992,CIAUSR,"XQA",CIAADT)) Q:CIAADT<1  D
 . . I '$D(^XTV(8992,CIAUSR,"XQA",CIAADT,0)) D
 . . . S ^TMP($J,"CIAZALTQ",CIAUSR,CIAADT)=""  ;store info for potential deletion
 . . . W !,"Alert: "_CIAADT_" for user: "_CIAUSR_" is missing the zero node."
 W !,"Checking complete.",!!
 Q $D(^TMP($J,"CIAZALTQ"))
 ;
PROMPT ;Prompt user to delete bad nodes
 I $$ASK^CIAU("Would you like to delete the nodes identified above") D
 . N CIAUSR,CIAADT
 . S CIAUSR=0
 . F  S CIAUSR=$O(^TMP($J,"CIAZALTQ",CIAUSR)) Q:CIAUSR<.1  D
 . . S CIAADT=0 F  S CIAADT=$O(^TMP($J,"CIAZALTQ",CIAUSR,CIAADT)) Q:CIAADT<1  D
 . . . K ^XTV(8992,CIAUSR,"XQA",CIAADT)
 . . . W !,"Entry: "_CIAUSR_" :: "_CIAADT_"    deleted..."
 Q
CLEANUP ;
 K ^TMP($J,"CIAZALTQ")
 Q
 ;
FIXXQA ; Fix XQA node in Alert File for user
 N IEN
 S IEN=0 F  S IEN=$O(^XTV(8992,IEN)) Q:'IEN  D
 .I '$P($G(^XTV(8992,IEN,"XQA",0)),U,2) D
 ..W !,"Fixing Corrupted Node..."_IEN
 .S $P(^XTV(8992,IEN,"XQA",0),U,2)="8992.01DA"
 Q
