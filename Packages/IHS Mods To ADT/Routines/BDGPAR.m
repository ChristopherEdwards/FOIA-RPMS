BDGPAR ; IHS/ANMC/LJF - CALLS FOR ADT PARAMETERS ;  [ 06/16/2003  2:41 PM ]
 ;;5.3;PIMS;**1011,1012**;APR 26, 2002
 ;
DIV(SITE) ;EP; set ADT division based on DUZ(2)
 NEW X,Y
 S (X,Y)=0 F  S X=$O(^BDGPAR(X)) Q:'X  Q:Y  D
 . ;I $D(^DG(40.8,"C",DUZ(2),X)) S Y=X  ;cmi/maw 9/1/09 orig line PATCH 1011
 . I $D(^DG(40.8,"AD",DUZ(2),X)) S Y=X  ;cmi/maw 9/1/09 mod line PATCH 1011
 Q Y
 ;
LOCKED(DIV,DATE) ;EP; return 1 if movement is locked (too old for edit)
 NEW X
 S X=$$GET1^DIQ(9009020.1,DIV,.02)   ;census lockout # of days
 I $$FMADD^XLFDT(DT,-X)>DATE Q 1
 Q 0
 ;
OUTPT(SITE) ;EP; returns 1 if site is outpatient only
 ; SITE=DUZ(2)
 Q +$$GET1^DIQ(40.8,$$DIV(SITE),3,"I")
 ;
ACTWD(W) ;EP; returns 1 if ward is active
 NEW X S X=$$GET1^DIQ(9009016.5,W,.03,"I")
 Q $S(X="I":0,1:1)
 ;
ICU(IEN) ;EP; returns 1 if movement IEN was to an ICU ward
 NEW X
 S X=$$GET1^DIQ(405,IEN,.06,"I")           ;ward ien
 Q $S($$GET1^DIQ(9009016.5,+X,101)="YES":1,1:0)
 ;
ACTSRV(S,DATE) ;EP; returns 1 if service is active on date sent
 NEW LAST,IEN
 I $$GET1^DIQ(45.7,S,9999999.03)'="YES" Q 0
 S LAST=$O(^DIC(45.7,S,"E","B",DATE+1),-1) I 'LAST Q 0
 S IEN=$O(^DIC(45.7,S,"E","B",LAST,0)) I 'IEN Q 0
 Q $S($P($G(^DIC(45.7,S,"E",IEN,0)),U,2)=1:1,1:0)
 ;
ADULT() ;EP; returns minimum age for adult patients
 Q $$GET1^DIQ(9009020.1,+$$DIV(DUZ(2)),.05)
 ;
ACTHS(N) ;EP; returns 1 if hospital service active and clinical today
 I $$GET1^DIQ(49,N,1.7)'="PATIENT CARE" Q 0    ;not clinical
 NEW X S X=$O(^DIC(49,N,3,""),-1) I 'X Q 1     ;never closed
 I $P($G(^DIC(49,N,3,X,0)),U,2)="" Q 0         ;never reopened
 I $P($G(^DIC(49,N,3,X,0)),U,2)>DT Q 0         ;reopen in future
 Q 1                                           ;reopened
