BTIUU1 ; IHS/ITSC/LJF - MORE IHS UTILITY CALLS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
VST(DA) ;EP -- returns visit date for document 
 Q $$GET1^DIQ(8925,DA,.03)
 ;
IVST(DA) ;EP; -- returns ien for visit for document
 Q $$GET1^DIQ(8925,DA,.03,"I")
 ;
CAT(DA) ;EP -- returns visit ser cat for document
 NEW X S X=$$IVST(DA) I X="" Q ""
 Q $$GET1^DIQ(9000010,X,.07,"I")
 ;
PAT(DA) ;EP -- returns patient name for document
 Q $$GET1^DIQ(8925,DA,.02)
 ;
IPAT(DA) ;EP; -- returns ien for patient for document
 Q $$GET1^DIQ(8925,DA,.02,"I")
 ;
PMV(VST,DFN) ;EP; -- returns pat move ien for visit
 NEW X,Y,Z
 S X=+$G(^AUPNVSIT(VST,0)) I X=0 Q ""
 S Y=$O(^DGPM("APTT1",DFN,(X-.0001))) I Y="" Q ""
 S Z=$O(^DGPM("APTT1",DFN,Y,0)) I Z="" Q ""
 I VST=$$GET1^DIQ(405,Z,.27,"I") Q Z
 Q ""
 ;
VNOTFIX(TIUDA) ;EP; -- updates visit pointer in v note if changed
 NEW X,Y,Z,DA,DR,DIE
 S X=$O(^AUPNVNOT("B",+TIUDA,0)) Q:X=""
 S Y=$P($G(^AUPNVNOT(X,0)),U,3) Q:Y=""
 S Z=$P($G(^TIU(8925,+TIUDA,0)),U,3) Q:Z=""  Q:Y=Z
 S DIE="^AUPNVNOT(",DA=X,DR=".03////"_Z D ^DIE
 Q
 ;
VA ;EP -- called to view a user's alerts
 NEW TIUSER,BTIU,DIR
 S TIUSER=$$READ^TIUU("PO^200:EMZQ") Q:+TIUSER<1
 K BTIU D USER^XQALERT("BTIU",+TIUSER)
 I $G(BTIU)=0 D  G VA
 . D MSG^BTIUU("No alerts found for "_$P(TIUSER,U,2),3,0,0)
 . D PAUSE^BTIUU
 D MSG^BTIUU(BTIU_" alerts found for "_$P(TIUSER,U,2)_":",3,0,0)
 S X=0 F  S X=$O(BTIU(X)) Q:'X  D
 . D MSG^BTIUU($J(X,3)_$E($P(BTIU(X),U),1,75),1,0,0)
 . I X#21=0 D PAUSE^BTIUU
 D PAUSE^BTIUU G VA
 Q
 ;
 ; -- archive copies of PAD and SP subrtns
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
