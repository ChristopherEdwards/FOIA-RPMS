ACGSTMPI ;IHS-OHPRD/THL,AEF - UTILITY TO UPDATE SORT CRITERION; [ 03/10/2000  3:09 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;UTILITY TO CHANGE DFN'S FOR ASSOCIATED PRINT TEMPLATES FOR THE
 ;;ACGSRT SORTING UTILITY WHEN SORT TEMPLATES TRANSFERRED TO NEW SYSTEM
EN I '$D(U) S U="^"
 D WAIT^DICD
 S ACGY(1)=""
 F  S ACGY(1)=$O(^ACGSRT("B",ACGY(1))) Q:ACGY(1)=""  D SET
EXIT ;
 K ^ACGSRT("B")
 S DIK="^ACGSRT(" D IXALL^DIK
 K ACGTMP,ACGTMPN,ACGY
 W *7,*7,!!?5,"ASSOCIATED PRINT TEMPLATE POINTERS IN THE ACG SORT FILE HAVE BEEN RESET."
 Q
SET S ACGY(2)=0
 F  S ACGY(2)=$O(^ACGSRT("B",ACGY(1),ACGY(2))) Q:'ACGY(2)  K ^ACGSRT(ACGY(2),2,"B") S ACGY(3)=0 F  S ACGY(3)=$O(^ACGSRT(ACGY(2),2,ACGY(3))) Q:'ACGY(3)  S ACGTMP=$P(^ACGSRT(ACGY(2),2,ACGY(3),0),U,2) I ACGTMP'="" D
 .S ACGTMPN=0
 .F  S ACGTMPN=$O(^DIPT("B",ACGTMP,ACGTMPN)) Q:'ACGTMPN  S $P(^ACGSRT(ACGY(2),2,ACGY(3),0),U)=ACGTMPN
 Q