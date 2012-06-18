PXRMICD9 ; SLC/PKR - Return an ICD9 zero node. ;05/05/1999
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
GET0(IEN) ;Return the ICD9 0 node for this IEN.
 ;This read is covered by DBIA 10082.
 Q $G(^ICD9(IEN,0))
 ;
