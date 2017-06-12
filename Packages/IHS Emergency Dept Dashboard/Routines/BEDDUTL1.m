BEDDUTL1 ;GDIT/HS/BEE-BEDD Utility Routine 3 - Cache Calls ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 ;This routine is included in the BEDD XML 1.0 install and is not in the KIDS
 ; 
 Q
 ;
DECADM(OBJID,OLDDEC) ;Retrieve new Decision to Admit Date
 ;
 ;Input:
 ; OBJID - Pointer to BEDD.EDVISIT
 ; OLDDEC - The original field value
 ;
 NEW VIEN,BEDD,EXEC,CURDEC,DECADM
 ;
 S (CURDEC,VIEN)=""
 S EXEC="S BEDD=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)" X EXEC
 S EXEC="S VIEN=BEDD.VIEN" X EXEC
 ;
 ;Get the current Dec to Admit Date from PCC
 I VIEN]"" S CURDEC=$$GET1^DIQ(9000010,VIEN_",",1116,"I")
 ;
 S DECADM=$S(CURDEC]"":CURDEC,1:OLDDEC)
 S:DECADM]"" DECADM=$TR($$FMTE^XLFDT($$DATE^BEDDUTIL(DECADM),"5Y"),"@"," ")
 ;
 Q DECADM
