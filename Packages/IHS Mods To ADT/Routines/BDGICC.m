BDGICC ; IHS/ANMC/LJF - INCOMPLETE CHART COMPUTED FIELDS ;
 ;;5.3;PIMS;**1001,1005**;MAY 28, 2004
 ;IHS/ITSC/WAR 07/19/2004 PATCH 1001 added CODER subroutine
 ;IHS/OIT/LJF  04/06/2006 PATCH 1005 added DELQDT subroutine
 ;
INSUR(IEN) ;EP; called by computed code for Insurance Coverage
 ; IEN = internal entry in file
 ;
 NEW PAT,VST,DATE
 S PAT=$$GET1^DIQ(9009016.1,IEN,.01,"I") I 'PAT Q "??"
 S VST=$$GET1^DIQ(9009016.1,IEN,.03,"I") I 'VST Q "??"
 S DATE=$$GET1^DIQ(9000010,VST,.01,"I") I 'DATE Q "??"
 Q $$INSUR^BDGF2(PAT,DATE)
 ;
ICSTAT(IEN,PVN) ;EP; called by computed code for Resolution Status
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 I $$GET1^DIQ(9009016.11,PVN_","_IEN,.03)]"" Q "Resolved"
 I $$GET1^DIQ(9009016.11,PVN_","_IEN,.04)]"" Q "Deleted"
 Q "Pending"
 ;
ICTIME(IEN,PVN) ;EP; called by computed code for Completion Time
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 NEW DONE,DSCH
 S DONE=$$GET1^DIQ(9009016.11,PVN_","_IEN,.03,"I")   ;date resolved
 I 'DONE Q ""
 S DSCH=$$GET1^DIQ(9009016.1,IEN,.02,"I")            ;discharge date
 I 'DSCH S DSCH=$$GET1^DIQ(9009016.1,IEN,.05,"I")    ;surgery date
 I 'DSCH Q "??"
 Q $$FMDIFF^XLFDT(DONE,DSCH)
 ;
 ;
OIEN(IEN) ;EP; called by computed code for Orignial IEN
 ; returns ien in original package file plus file #
 ; If inpatient, returns "405;"_ien
 ; If day surgery using VA Surgery file, returns "130;"_ien
 ; If day surgery using ADT, returns 0 because does not point to Visit
 ;
 NEW TYPE
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392) I TYPE="" Q 0
 S VISIT=$$GET1^DIQ(9009016.1,IEN,.03,"I") I 'VISIT Q 0
 I TYPE["HOS" S X=$O(^DGPM("AVISIT",VISIT,0)) Q $S('X:0,1:"405;"_X)
 S X=$O(^SRF("ADS",VISIT,0)) I X Q "130;"_X
 Q 0
 ;
DSWRD(IEN) ;EP; called by computed code for Discharge Ward
 ;
 NEW ADM S ADM=$$OIEN(IEN) I 'ADM Q ""
 I $E(ADM,1,4)="130;" Q ""  ;quit if day surgery
 S X=$P($G(^DGPM($P(ADM,";",2),0)),U,17) I 'X Q ""
 Q $$GET1^DIQ(405,X,200)
 ;
 ;IHS/ITSC/WAR 7/19/2004 Added per Linda PATCH #1001
CODER(ADM) ;EP; called by ADT ITEM "admitting clerk/coder";PATCH #1001
 I 'ADM Q "??"
 NEW VSIT,IC,CLERK,CODER
 S VSIT=$$GET1^DIQ(405,ADM,.27,"I") I 'VSIT Q "??"   ;visit ien
 S IC=$O(^BDGIC("AV",VSIT,0))                        ;incomplete chart n
 S CLERK=$$GET1^DIQ(200,+$$GET1^DIQ(405,+$G(ADM),100,"I"),1)        ;adk
 I IC S CODER=$$GET1^DIQ(200,+$$GET1^DIQ(9009016.1,IC,.22,"I"),1)   ;cor
 Q CLERK_$S($G(CODER)]"":" / "_CODER,1:"")
 ;
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 new subroutine
DELQDT(IEN,PVN) ;EP called by computed code for DATE DELINQUENT
 ; IEN = internal entry in file
 ; PVN = internal entry for provider multiple
 I ('$G(IEN))!('$G(PVN)) Q "??"
 NEW DSCH,DAYS
 S DSCH=$$GET1^DIQ(9009016.1,IEN,.02,"I")               ;discharge date
 I 'DSCH S DSCH=$$GET1^DIQ(9009016.1,IEN,.05,"I")       ;OR surgery date
 I 'DSCH Q "??"
 S DAYS=$$GET1^DIQ(9009020.1,$$DIV^BDGPAR(DUZ(2)),.12)  ;Days to delinquency
 Q $$FMADD^XLFDT(DSCH,DAYS)
 ;
