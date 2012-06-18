BDGICF2 ; IHS/ANMC/LJF - INCOMPLETE CHART VIEW ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
PAT ; ask user for patient
 ; This entry point sets BDGIC=1 to view all entries, all deficiencies
 ;  If entry is made via PATSET then only active entries with unresolved
 ;         deficiencies will be displayed
 NEW DFN,BDGIC D KILL^AUPNPAT
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") Q:DFN<1
 S BDGIC=1
 ;
PATSET ;EP; entry where patient already known
 ; find all entries in IC file for patient
 ;  put into array sorted by date (max of 10)
 ; Called by Patient Inquiry Expand action
 NEW BDGN,COUNT,BDGA,BDGA1,X,CNT,TYPE
 ;
 ; find all entries for patient and sort by reverse date
 S BDGN=0
 F  S BDGN=$O(^BDGIC("B",DFN,BDGN)) Q:'BDGN  D
 . Q:$$GET1^DIQ(9009016.1,BDGN,.17)]""   ;quit if deleted - error
 . I '$G(BDGIC),$$GET1^DIQ(9009016.1,BDGN,.14)]"" Q   ;completed
 . S X=$$GET1^DIQ(9009016.1,BDGN,.03,"I") Q:'X  ;visit ptr
 . S BDGA1(9999999-$$GET1^DIQ(9000010,X,.01,"I"))=BDGN
 ;
 ; create numbered array linked to sorted array
 S X=0 F  S X=$O(BDGA1(X)) Q:'X  D
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=BDGA1(X)
 ;
 W !!,"Incomplete Chart Entries for "_$$GET1^DIQ(2,DFN,.01)_":"
 F CNT=1:1 Q:'$D(BDGA(CNT))  Q:CNT=10  D
 . S TYPE=$$GET1^DIQ(9009016.1,BDGA(CNT),.0392)          ;visit type
 . W !,$J(CNT,3)
 . W ?6,$$GET1^DIQ(9009016.1,BDGA(CNT),$S(TYPE["DAY":.05,1:.02))
 . W ?25,TYPE
 . S X=$$GET1^DIQ(9009016.1,BDGA(CNT),.14)             ;date completed
 . W ?45,$S(X]"":"Completed",1:"Active IC Chart")
 W !
 ;
 I '$G(COUNT) W !!,"No entries to view" Q
 ;
 S Y=$$READ^BDGF("NO^1:"_$G(COUNT),"Select Chart by Number") Q:Y<1
 S BDGN=BDGA(+Y)
 ;
 I $$BROWSE^BDGF="B" D EN^BDGICF21 Q
 D ZIS^BDGF("PQ","EN^BDGICF21","INCOMPLETE CHART VIEW","BDGN;BDGIC")
 Q
