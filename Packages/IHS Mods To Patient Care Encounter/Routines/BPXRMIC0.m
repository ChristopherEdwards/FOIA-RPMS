BPXRMIC0 ; SLC/PKR - Return an ICD9 zero node. ;07-May-2009 12:44;MGH
 ;;1.5;CLINICAL REMINDERS;**1004,1006**;Jun 19, 2000
 ;IHS/CIA/MGH Routine to return ICD0 code
 ;
GET0(IEN) ;EP Return the ICD0 0 node for this IEN.
 ;This read is covered by DBIA 10082.
 Q $G(^ICD0(IEN,0))
 ;
