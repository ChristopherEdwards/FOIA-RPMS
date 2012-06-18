BDGF1 ; IHS/ANMC/LJF - INPT DATA FUNCTION CALLS ;  [ 09/23/2004  5:04 PM ]
 ;;5.3;PIMS;**1001,1004,1006**;MAY 28, 2004
 ;IHS/ITSC/WAR 09/23/2004 PATCH 1001 use attending provider in PCC if there
 ;IHS/OIT/LJF  07/15/2005 PATCH 1004 fixed inverse date code
 ;             09/09/2005 PATCH 1004 added SRVCHK subroutine
 ;             08/31/2006 PATCH 1006 added DESC subroutine
 ;
 ; PAT=PAT of patient
 ; ADM=admission ien, also called corresponding admission (CA)
 ;
VISIT(PAT,DATE) ;PEP; return H or O visit ien for patient and admit date
 NEW RVDT,V,X,FOUND
 S RVDT=9999999-$P(DATE,".")_"."_$P(DATE,".",2)
 S FOUND=0
 S V=0 F  S V=$O(^AUPNVSIT("AA",PAT,RVDT,V)) Q:'V  Q:FOUND  D
 . S X=$$GET1^DIQ(9000010,V,.07,"I") I (X="H")!(X="O") S FOUND=V
 Q $G(FOUND)
 ;
INPT1(PAT,DATE) ;PEP; returns admit date (external format) if inpt on DATE sent
 NEW ADM,DSCH
 S ADM=$O(^DGPM("ATID1",PAT,9999999-DATE)) I ADM="" Q ""
 ;S DSCH=$O(^DGPM("APTT3",PAT,9999999-ADM))
 S DSCH=$O(^DGPM("APTT3",PAT,9999999.9999999-ADM))   ;IHS/OIT/LJF 7/15/2005 PATCH 1004
 I DSCH]""&(DSCH<DATE) Q ""
 S ADM=9999999.99999999-ADM
 Q $$NUMDATE^BDGF(ADM,1)
 ;
ADMTXN(ADM,PAT) ;PEP; -- returns treating specialty node ien for admission
 ;called by ADT ITEMS file
 NEW DATE
 S DATE=+$G(^DGPM(ADM,0)) I 'DATE Q 0
 Q +$O(^DGPM("APTT6",PAT,DATE,0))
 ;
ADMPRV(ADM,PAT,TYPE,MODE) ;PEP; -- returns provider for admission based on type
 ; TYPE="ADM" for admitting, "PRM" for primary, "ATT" for attending
 ; MODE="" for external format or ="I" for internal format
 ;called by ADT ITEMS file
 NEW IEN,FIELD
 I ('ADM)!('PAT) Q ""
 S IEN=$$ADMTXN(ADM,PAT) I 'IEN Q ""
 S FIELD=$S(TYPE="ADM":9999999.02,TYPE="ATT":.19,1:.08)
 Q $$GET1^DIQ(405,IEN,FIELD,$G(MODE))
 ;
ADMPRVS(ADM,PAT,TYPE,MODE) ;PEP; -- returns provider's service based on type
 ; TYPE="ADM" for admitting, "PRM" for primary, "ATT" for attending
 ; MODE="" for external format or ="I" for internal format
 Q $$GET1^DIQ(200,+$$ADMPRV(ADM,PAT,TYPE,"I"),29,$G(MODE))
 ;
ADMSRV(ADM,PAT) ;PEP; -- returns admitting service name
 NEW IEN
 I ('ADM)!('PAT) Q ""
 S IEN=$$ADMTXN(ADM,PAT) I 'IEN Q ""
 Q $$GET1^DIQ(405,IEN,.09)
 ;
ADMSRVN(ADM,PAT) ;PEP; -- returns admitting service ien
 NEW IEN
 I ('ADM)!('PAT) Q ""
 S IEN=$$ADMTXN(ADM,PAT) I 'IEN Q ""
 Q $$GET1^DIQ(405,IEN,.09,"I")
 ;
ADMSRVC(ADM,PAT) ;PEP; returns admitting service abbrev & code
 ;called by ADT ITEMS file
 NEW IEN,X
 I ('ADM)!('PAT) Q ""
 S IEN=$$ADMSRVN(ADM,PAT) I 'IEN Q ""
 S X=$$GET1^DIQ(45.7,IEN,99) S:X="" X="??"
 Q X_" "_$$GET1^DIQ(45.7,IEN,9999999.01)
 ;
ADMTYP(ADM) ;PEP; returns IHS admit type and code
 ;called by ADT ITEMS file
 NEW X
 I '$G(ADM) Q "??"
 S X=$$GET1^DIQ(405,ADM,.04,"I") I 'X Q "??"   ;internal
 S X=$$GET1^DIQ(405.1,X,9999999.1)
 Q X_" "_$$GET1^DIQ(405,ADM,.04)
 ;
WRDABRV(PAT) ;PEP; returns abbreviation of current ward
 I $G(^DPT(PAT,.1))="" Q ""
 NEW X S X=^DPT(PAT,.1),X=$O(^DIC(42,"B",X,0)) I 'X Q ""
 Q $$GET1^DIQ(9009016.5,X,.02)
 ;
WRDABRV2(N) ;PEP; returns abbreviation of ward for movement N
 NEW X
 S X=$$GET1^DIQ(405,N,.06,"I") I 'X Q ""
 Q $$GET1^DIQ(9009016.5,X,.02)
 ;
CURPRV(PAT,LENGTH) ;PEP; returns current attending provider for patient
 ; LENGTH=amount of room to fit name, optional
 NEW Y S Y=$$GET1^DIQ(2,PAT,.1041)
 I '$G(LENGTH) S LENGTH=20
 Q $E(Y,1,LENGTH)
 ;
CURDX(PAT) ;PEP; returns admitting dx for current inpatient
 NEW CA
 S CA=$G(^DPT(PAT,.105)) I 'CA Q "??"
 Q $$GET1^DIQ(405,CA,.1)
 ;
CURLOS(PAT,MODE) ;PEP; returns length of stay for current inpatient
 ; MODE=1 means return observation in hours
 NEW CA,SRV
 S CA=$G(^DPT(PAT,.105)) I 'CA Q "??"
 S SRV=$$GET1^DIQ(2,PAT,.103)
 I $G(MODE),SRV["OBSERVATION" Q $$LOSHRS(CA,$$NOW^XLFDT,PAT)_" hrs"
 Q $$GET1^DIQ(405,CA,201)_" days"
 ;
LASTTXN(ADM,PAT) ;PEP; returns last treating specialty ien for admission
 ; also returns last service as second U piece
 NEW DSC,DATE,SRV,IEN
 I ('ADM)!('PAT) Q 0
 S DSC=$$GET1^DIQ(405,ADM,.17,"I")           ;find discharge if there
 ; start at discharge date or beginning if still inpt
 S DATE=$S(DSC="":0,1:9999999.9999999-$G(^DGPM(DSC,0)))
 ; find date of last treating specialty change
 S DATE=$O(^DGPM("ATS",PAT,ADM,DATE)) I 'DATE Q 0
 ; find treating specialty ien
 S SRV=$O(^DGPM("ATS",PAT,ADM,DATE,0)) I 'SRV Q 0
 ; find treating specialty change ien
 S IEN=$O(^DGPM("ATS",PAT,ADM,DATE,SRV,0)) I 'IEN Q 0
 Q IEN_U_SRV
 ;
LASTSRVN(ADM,PAT) ;PEP; returns last service name
 I ('ADM)!('PAT) Q ""
 NEW X
 S X=$P($$LASTTXN(ADM,PAT),U,2) I 'X Q ""
 Q $$GET1^DIQ(45.7,X,.01)
 ;
LASTSRVC(ADM,PAT) ;PEP; returns last service abbreviation and its code
 ;called by ADT ITEMS file
 I ('ADM)!('PAT) Q ""
 NEW X
 S X=$P($$LASTTXN(ADM,PAT),U,2) I 'X Q ""
 Q $$GET1^DIQ(45.7,X,99)_" "_$$GET1^DIQ(45.7,X,9999999.01)
 ;
LASTPRV(ADM,PAT,MODE) ;PEP; returns last attending provider based on type
 ; MODE="" for external format or ="I" for internal format
 ;called by ADT ITEMS file
 NEW LAST
 S LAST=$$LASTTXN(ADM,PAT) I 'LAST Q "??"
 ;
 ;IHS/ITSC/WAR 9/23/04 PATCH #1001 Added next 2 lines per LJF
 NEW VST,PCC S VST=$$GET1^DIQ(405,+ADM,.27,"I")
 I VST S PCC=$$PRIMPROV^APCLV(VST,$S($G(MODE)="":"N",1:MODE)) I PCC]"" Q PCC
 ;IHS/ITSC/WAR end of 9/23/04 mod
 ;
 Q $$GET1^DIQ(405,+LAST,.19,$G(MODE))
 ;
LASTPRVC(ADM,PAT) ;PEP; returns IHS ADC code for last attending provider by type
 ;called by ADT ITEMS file
 Q $$GET1^DIQ(200,+$$LASTPRV(ADM,PAT,"I"),9999999.09)
 ;
LASTPRVS(ADM,PAT,MODE) ;PEP; returns last attending provider's service
 ; MODE="" for external format or ="I" for internal format
 Q $$GET1^DIQ(200,+$$LASTPRV(ADM,PAT,"I"),29,$G(MODE))
 ;
PRIORTXN(DATE,CA,PAT) ;PEP; returns treating specialty ien prior to date sent
 ; assumes date includes time
 NEW LAST,FOUND
 I ('DATE)!('PAT) Q 0
 ;
 ; if date=admit date, use admit service ien
 I DATE=+$G(^DGPM(CA,0)) Q +$O(^DGPM("APTT6",PAT,DATE,0))
 ;
 ; find last service change (not provider change only)
 S LAST=DATE,FOUND=0
 F  S LAST=$O(^DGPM("APTT6",PAT,LAST),-1) Q:'LAST  Q:FOUND  D
 . S N=$O(^DGPM("APTT6",PAT,LAST,0)) Q:'N
 . I $P($G(^DGPM(N,0)),U,9)]"" S FOUND=LAST   ;has service
 ;
 I 'FOUND Q $$ADMTXN(CA,PAT)                  ;return admit service
 Q +$O(^DGPM("APTT6",PAT,FOUND,0))
 ;
PRIORMVT(DATE,CA,PAT) ;PEP; returns last physical movement before DATE
 NEW LAST
 I ('DATE)!('CA)!('PAT) Q 0
 S LAST=$O(^DGPM("APCA",PAT,CA,DATE),-1) I 'LAST Q CA
 Q +$O(^DGPM("APCA",PAT,CA,LAST,0))
 ;
LOSHRS(CA,DATE,PAT) ;PEP; returns length of stay in hours
 Q $J($$FMDIFF^XLFDT(DATE,+$G(^DGPM(CA,0)),2)/3600,0,0)
 ;
READM(ADM,PAT,LIMIT) ;PEP; returns 1 if patient readmitted within parameter limit
 ; LIMIT is optional, if not sent will use site parameter
 ; returns LAST discharge date if within limits
 NEW ADMDT,LAST,DIFF
 S ADMDT=$$GET1^DIQ(405,ADM,.01,"I")                 ;new admit date
 I 'ADMDT Q 0                                        ;bad entry
 S LAST=$O(^DGPM("APTT3",PAT,ADMDT),-1)              ;last discharge
 I 'LAST Q 0                                         ;1st admission
 S DIFF=$$FMDIFF^XLFDT(ADMDT,LAST)                   ;# of days diff
 ;
 ; if limit was sent
 I $G(LIMIT)'="",DIFF>LIMIT Q 0
 ;
 ; if using site parameter
 I $G(LIMIT)="",DIFF>$$GET1^DIQ(9009020.1,+$$DIV^BDGPAR(DUZ(2)),105) Q 0
 ;
 Q 1_U_LAST
 ;
DSADM(ADM,PAT) ;PEP; returns 1 if patient admitted after day surgery w/in limit
 NEW ADMDT,LAST,DIFF
 S ADMDT=$$GET1^DIQ(405,ADM,.01,"I")                 ;new admit date
 S LAST=$$LASTDS^BDGDSA(ADMDT,PAT)                   ;last day surgery
 I 'LAST Q 0                                         ;1st admission
 S DIFF=$$FMDIFF^XLFDT(ADMDT,LAST)                   ;# of days diff
 I DIFF>$$GET1^DIQ(9009020.1,+$$DIV^BDGPAR(DUZ(2)),107) Q 0
 Q 1_U_LAST
 ;
LASTADM(PAT) ; Returns ien for patient's most recent admission
 NEW Y
 S Y=$O(^DGPM("ATID1",PAT,0)) I 'Y Q 0
 Q +$O(^DGPM("ATID1",PAT,Y,0))
 ;
OPTOUT(PAT) ;EP; returns 1 if patient asked to opt-out of directory for current admission
 NEW X
 S X=$$GET1^DIQ(2,PAT,.105,"I") I 'X Q 0   ;get admission ien
 Q +$$GET1^DIQ(405,X,41,"I")               ;directory exclusion field
 ;
 ;IHS/OIT/LJF 09/09/2005 PATCH 1004 added new subroutine
SRVCHK(SRV,IEN) ;EP; called by 405 DD on field .09
 ; Make sure no mixing of observation & inpatient services in one encounter
 ; SRV=treating specialty pointer being assessed; IEN=DA - entry in file 405
 NEW ADM,PAT,SERVICE
 S ADM=$$GET1^DIQ(405,IEN,.14,"I")                           ;admission IEN
 S PAT=$$GET1^DIQ(405,IEN,.03,"I")                           ;patient IEN
 I $$ADMTXN(ADM,PAT)=IEN,$P($$LASTTXN(ADM,PAT),U)=IEN Q 1    ;okay if this is admission service entry and no other exists
 I $$ADMTXN(ADM,PAT)=IEN,$P($$LASTTXN(ADM,PAT),U)=0 Q 1      ;okay if this is admission service entry and no other exists
 ;
 ; find service with which to compare
 I $$ADMTXN(ADM,PAT)=IEN S SERVICE=$$LASTSRVN(ADM,PAT)       ;if admission, check most recent transfer service
 E  S SERVICE=$$ADMSRV(ADM,PAT)                              ;else, use name of admission service
 ;
 I (SERVICE["OBSERVATION"),($$GET1^DIQ(45.7,SRV,.01)'["OBSERVATION") Q 0
 I (SERVICE'["OBSERVATION"),($$GET1^DIQ(45.7,SRV,.01)["OBSERVATION") Q 0
 Q 1
 ;
 ;IHS/OIT/LJF 08/31/2006 PATCH 1006 added new subroutine
DESC ;EP; called by executable help on Admission Source field in file 405
 NEW BDGC,BDGN,BDGD,BDGL,BDGSTOP
 S (BDGC,BDGL,BDGSTOP)=0
 F  S BDGC=$O(^AUTTASRC("C",BDGC)) Q:BDGC=""  Q:BDGSTOP  D
 . S BDGN=0 F  S BDGN=$O(^AUTTASRC("C",BDGC,BDGN)) Q:'BDGN  Q:BDGSTOP  D
 . . W !!,BDGC,?4,$P(^AUTTASRC(BDGN,0),U) S BDGL=BDGL+1
 . . S BDGD=0 F  S BDGD=$O(^AUTTASRC(BDGN,1,BDGD)) Q:'BDGD  Q:BDGSTOP  D
 . . . W !,?6,^AUTTASRC(BDGN,1,BDGD,0) S BDGL=BDGL+1
 . . I BDGL>12 S BDGL=0 I '$$READ^BDGF("E") S BDGSTOP=1 Q
 Q
