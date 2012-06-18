ABSPOSBC ; IHS/FCS/DRS - POS billing - new ;   
 ;;1.0;PHARMACY POINT OF SALE;**38**;JUN 21, 2001
 ;
 Q
 ;
 ;  TRANSACT - transaction complete - called from STATUS99^ABSPOSU,
 ;    to request that this transaction be posted.
 ;
TRANSACT(IEN57) ; EP -
 D SETFLAG(IEN57,1) ; set the flag
 ;;IHS/OIT/RAN - 03162010 Patch 38 -- print pharmacy expense report
 D MAIN^ABSPOSPE(IEN57)
 D SCHEDULE^ABSPOSBD() ; schedule the background job, if needed
 Q
 ;
 ; SETFLAG - set the billing flag for this transaction
 ;   VALUE = 1 for needs billing
 ;   VALUE = 0 for billing done
 ;
SETFLAG(IEN57,VALUE) ;EP -
 D
 . N FDA,MSG ; clear the "needs billing" flag
 . S FDA(9002313.57,IEN57_",",.16)=VALUE
SF1 . D FILE^DIE(,"FDA","MSG")
 . I $D(MSG) D  G SF1:$$IMPOSS^ABSPOSUE("FM","TRI",.FDA,.MSG,"SETFLAG",$T(+0))
 . . D ZWRITE^ABSPOS("FDA","MSG")
 Q
