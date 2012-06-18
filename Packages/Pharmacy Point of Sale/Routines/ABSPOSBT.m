ABSPOSBT ; IHS/FCS/DRS - Billing - ANMC ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Billing interface for ANMC
 ;
 ; Called at tag POST from ABSPOSBB
 ; with the variable ABSP57 pointing to 9002313.57, the transaction
 ; You must return a value - that value is stuffed into field .15
 ; of the transaction record
 ; and indexed by ^ABSPTL("AR",value,IEN57)
 ; 
 ; Many useful utilities are available in ABSPOS57
 ; DO LOG^ABSPOSL(text) puts text into the billing log file
 ; DO LOG57^ABSPOS57(text) puts text into the claim's log file
 ;
 ;
POST() ; EP - from ABSPOSBB
 N IEN57 S IEN57=ABSP57 ; now you can $$label^ABSPOS57
 N PREV57 S PREV57=$$PREVIOUS^ABSPOS57 ; if this prescrip prev posted
 N RESULT,RETVAL S RETVAL=""
 S RESULT=$$GET1^DIQ(9002313.57,ABSP57_",","RESULT WITH REVERSAL")
 ;
 ; RESULT can by E PAYABLE, E REJECTED, E CAPTURED, PAPER
 ; or E REVERSAL ACCEPTED or PAPER REVERSAL
 ; or E REVERSAL REJECTED
 ;
 S RETVAL=0
 Q RETVAL
