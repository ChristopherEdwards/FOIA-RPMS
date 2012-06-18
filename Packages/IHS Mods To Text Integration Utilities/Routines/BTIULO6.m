BTIULO6 ; IHS/ITSC/LJF - INPT DATA OBJECT CALLS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ; PAT=IEN of patient
 ; ADM=admission ien, also called corresponding admission (CA)
 ;
ADMN(PAT,VST) ;EP; returns admission IEN for H visit sent
 I $$GET1^DIQ(9000010,VST,.07,"I")'="H" Q 0
 Q $O(^DGPM("AVISIT",VST,0))
 ;
INPT1(PAT,DATE) ;EP; returns admit date (external format) if inpt on DATE sent
 NEW ADM,DSCH
 S ADM=$O(^DGPM("ATID1",PAT,9999999-DATE)) I 'ADM Q ""
 S DSCH=$O(^DGPM("APTT3",PAT,9999999-ADM))
 I DSCH]""&(DSCH<DATE) Q ""
 S ADM=9999999.99999999-ADM
 Q $$NUMDATE^BTIUU(ADM,1)
 ;
ADMTXN(VST,PAT) ;EP; -- returns treating specialty node ien for H visit
 NEW DATE,ADM
 S ADM=$$ADMN(PAT,VST) I 'ADM Q 0
 S DATE=+$G(^DGPM(ADM,0)) I 'DATE Q 0
 Q +$O(^DGPM("APTT6",PAT,DATE,0))
 ;
ADMPRV(VST,PAT,TYPE,MODE) ;EP; -- returns provider for admission based on type
 ; TYPE="ADM" for admitting, "ATT" for attending, "REF" for referring
 ; MODE="" for external format or ="I" for internal format
 NEW IEN,FIELD
 I ('VST)!('PAT)!(TYPE="") Q ""
 S ADM=$$ADMN(PAT,VST) I 'ADM Q ""
 S IEN=$$ADMTXN(ADM,PAT) I 'IEN Q ""
 S FIELD=$S(TYPE="ADM":9999999.02,TYPE="REF":9999999.03,1:.19)
 Q $$GET1^DIQ(405,IEN,FIELD,$G(MODE))
 ;
ADMPRVS(VST,PAT,TYPE,MODE) ;EP; -- returns provider's service based on type
 ; TYPE="ADM" for admitting, "ATT" for attending
 ; MODE="" for external format or ="I" for internal format
 Q $$GET1^DIQ(200,+$$ADMPRV(VST,PAT,TYPE,"I"),29,$G(MODE))
 ;
ADMSRV(VST,PAT) ;EP; -- returns admitting service name
 NEW IEN
 I ('VST)!('PAT) Q ""
 S ADM=$$ADMN(PAT,VST) I 'ADM Q ""
 S IEN=$$ADMTXN(ADM,PAT) I 'IEN Q ""
 Q $$GET1^DIQ(405,IEN,.09)
 ;
CURWRD(PAT) ;EP; returns abbreviation of patient's current ward
 I $G(^DPT(PAT,.1))="" Q ""
 NEW X S X=^DPT(PAT,.1),X=$O(^DIC(42,"B",X,0)) I 'X Q ""
 Q $$GET1^DIQ(9009016.5,X,.02)
 ;
CURWRDRM(PAT) ;EP; returns patient's current ward/room-bed
 NEW ANS
 S ANS=$$GET1^DIQ(2,PAT,.101) I ANS="" Q ""
 Q $$CURWRD(PAT)_"("_ANS_")"
 ;
CURPRV(PAT,TYPE) ;EP; returns current attending provider for patient
 ; TYPE="ATT" for attending, "ADM" for admitting and "REF" for referring provider
 I TYPE="ATT" Q $$GET1^DIQ(2,PAT,.1041)
 NEW CA S CA=$G(^DPT(PAT,.105)) I 'CA Q "??"
 Q $$GET1^DIQ(405,CA,$S(TYPE="ADM":9999999.02,1:9999999.03))
 ;
CURSRV(PAT,LENGTH) ;EP; returns current treating specialty for patient
 ; LENGTH=amount of room to fit name, optional
 NEW Y S Y=$$GET1^DIQ(2,PAT,.103)
 I '$G(LENGTH) S LENGTH=20
 Q $E(Y,1,LENGTH)
 ;
CURDX(PAT) ;EP; returns admitting dx for current inpatient
 NEW CA
 S CA=$G(^DPT(PAT,.105)) I 'CA Q "??"
 Q $$GET1^DIQ(405,CA,.1)
 ;
CURLOS(PAT,MODE) ;EP; returns length of stay for current inpatient
 ; MODE=1 means return observation in hours
 NEW CA,SRV
 S CA=$G(^DPT(PAT,.105)) I 'CA Q "??"
 S SRV=$$GET1^DIQ(2,PAT,.103)
 I $G(MODE),SRV["OBSERVATION" Q $$LOSHRS(CA,$$NOW^XLFDT,PAT)_" hrs"
 Q $$GET1^DIQ(405,CA,201)_" days"
 ;
LASTTXN(VST,PAT) ;EP; returns last treating specialty ien for admission
 ; also returns last service as second U piece
 NEW DSC,DATE,SRV,IEN
 I ('VST)!('PAT) Q 0
 S ADM=$$ADMN(PAT,VST) I 'ADM Q 0
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
LASTSRVN(VST,PAT) ;EP; returns last service name
 I ('VST)!('PAT) Q ""
 NEW X
 S X=$P($$LASTTXN(VST,PAT),U,2) I 'X Q ""
 Q $$GET1^DIQ(45.7,X,.01)
 ;
LASTSRVC(VST,PAT) ;EP; returns last service abbreviation and its code
 I ('VST)!('PAT) Q ""
 NEW X
 S X=$P($$LASTTXN(VST,PAT),U,2) I 'X Q ""
 Q $$GET1^DIQ(45.7,X,99)_" "_$$GET1^DIQ(45.7,X,9999999.01)
 ;
LASTPRV(VST,PAT,MODE) ;EP; returns last attending provider based on type
 ; MODE="" for external format or ="I" for internal format
 NEW LAST
 S LAST=$$LASTTXN(VST,PAT) I 'LAST Q "??"
 Q $$GET1^DIQ(405,+LAST,.19,$G(MODE))
 ;
LASTPRVC(VST,PAT) ;EP; returns IHS ADC code for last attending provider by type
 Q $$GET1^DIQ(200,+$$LASTPRV(VST,PAT,"I"),9999999.09)
 ;
LASTPRVS(VST,PAT,MODE) ;EP; returns last attending provider's service
 ; MODE="" for external format or ="I" for internal format
 Q $$GET1^DIQ(200,+$$LASTPRV(VST,PAT,"I"),29,$G(MODE))
 ;
PRIORTXN(DATE,CA,PAT) ;EP; returns treating specialty ien prior to date sent
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
 I 'FOUND Q $$ADMTXN(CA,PAT)             ;return admit service
 Q +$O(^DGPM("APTT6",PAT,FOUND,0))
 ;
PRIORMVT(DATE,CA,PAT) ;EP; returns last physical movement before DATE
 NEW LAST
 I ('DATE)!('CA)!('PAT) Q 0
 S LAST=$O(^DGPM("APCA",PAT,CA,DATE),-1) I 'LAST Q CA
 Q +$O(^DGPM("APCA",PAT,CA,LAST,0))
 ;
LOSHRS(VST,DATE,PAT) ;EP; returns length of stay in hours
 NEW ADM
 S ADM=$$ADMN(PAT,VST) I 'ADM Q ""
 Q $J($$FMDIFF^XLFDT(DATE,+$G(^DGPM(ADM,0)),2)/3600,0,0)
 ;
LASTADM(PAT) ; Returns ien for patient's most recent admission
 NEW Y
 S Y=$O(^DGPM("ATID1",PAT,0)) I 'Y Q 0
 Q +$O(^DGPM("ATID1",PAT,Y,0))
 ;
