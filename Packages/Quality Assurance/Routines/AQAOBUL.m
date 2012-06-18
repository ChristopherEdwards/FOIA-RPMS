AQAOBUL ; IHS/ORDC/LJF - BULLETIN ON PERSONAL REFERRAL ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains 4 entry points called by MUMPS xrefs to send
 ;bulletins to persons to whom an occurrence case has been referred.
 ;Called by the 4 referred to fields.
 ;
INITIAL ;ENTRY POINT for initial review
 Q:X=""  Q:X'["AQAO(9"  ;not referred to a person
 S XMB(4)=$P(^AQAOC(DA,1),U,4)
 S XMB(4)=U_$P(XMB(4),";",2)_+XMB(4)_",0)"
 S XMB(4)=$P(@XMB(4),U) ;referred by - variable pointer
 S AQAODA=DA D VAR,^XMB Q
 ;
 ;
ADDREV ;ENTRY POINT for additional referrals on initial review
 Q:X=""  Q:X'["AQAO(9"  ;not referred to a person
 S XMB(4)=$P(^AQAOC(DA(1),1),U,4)
 S XMB(4)=U_$P(XMB(4),";",2)_+XMB(4)_",0)"
 S XMB(4)=$P(@XMB(4),U) ;referred by - variable pointer
 S AQAODA=DA(1) D VAR,^XMB Q
 ;
 ;
REVIEW ;ENTRY POINT for reviews
 Q:X=""  Q:X'["AQAO(9"  ;not referred to a person
 S XMB(4)=$P(^AQAOC(DA(1),"REV",DA,0),U,2)
 S XMB(4)=U_$P(XMB(4),";",2)_+XMB(4)_",0)"
 S XMB(4)=$P(@XMB(4),U) ;referred by
 S AQAODA=DA(1) D VAR,^XMB Q
 ;
 ;
REVADD ;ENTRY POINT for additional referrals on reviews
 Q:X=""  Q:X'["AQAO(9"  ;not referred to a person
 S XMB(4)=$P(^AQAOC(DA(2),"REV",DA(1),0),U,2)
 S XMB(4)=U_$P(XMB(4),";",2)_+XMB(4)_",0)"
 S XMB(4)=$P(@XMB(4),U) ;referred by
 S AQAODA=DA(2) D VAR,^XMB Q
 ;
 ;
VAR ; >> gather common variables
 S XMY(+X)="" ;referred to
 S XMB(1)=$P(^AQAOC(AQAODA,0),U) ;case id
 S XMB(2)=$P(^AQAOC(AQAODA,0),U,4)
 S XMB(2)=$E(XMB(2),4,5)_"/"_$E(XMB(2),6,7)_"/"_$E(XMB(2),2,3) ;occ date
 S XMB(3)=$P(^AQAOC(AQAODA,0),U,8)
 S XMB(3)=$P(^AQAO(2,XMB(3),0),U)_"  "_$P(^(0),U,2) ;indicator # & name
 S XMB(5)=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3) ;today's date
 S XMB="AQAO OCC REFERRAL",XMBDUZ="QAI_MGT_SYSTEM"
 Q
