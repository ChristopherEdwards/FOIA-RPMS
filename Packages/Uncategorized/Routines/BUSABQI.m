BUSABQI ;GDIT/HS/BEE-IHS USER SECURITY AUDIT - iCare calls ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
MPAN(BUSAVAR,ACT) ;EP - Add/Remove Patient from panel
 ;
 NEW RES,AR,PIEN
 ;
 S RES="iCare: add/remove a patient from a panel",ACT="E"
 ;
 ;Determine whether an add or a remove
 S AR=$G(@BUSAVAR@(3,"P",2)) D  I AR="" Q RES
 . I AR="A" S RES="iCare: added patient to a panel",ACT="A" Q
 . I AR="R" S RES="iCare: removed patient from panel",ACT="D" Q
 . S AR=""
 ;
 ;Pull panel IEN
 I ACT="D" S PIEN=$G(@BUSAVAR@(3,"P",1)) S:PIEN]"" RES=RES_" ("_PIEN_")"
 ;
 Q RES
