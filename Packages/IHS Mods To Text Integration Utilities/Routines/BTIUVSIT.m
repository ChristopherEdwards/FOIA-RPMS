BTIUVSIT ; IHS/ITSC/LJF - Visit File look-up ;
 ;;1.0;TEXT INTEGRATION UTILITIES;**1001**;NOV 04, 2004
 ; IHS version of TIUVSIT calls
 ;
FINDVST ;EP; -- IHS setup code to find visit for note
 K ^TMP("TIUIHSV",$J)
 ; -- find possible visits for patient and date
 I '$D(^TMP("TIUVN",$J)) D GETAPPT(DFN,$G(TIULOC),$G(TIUOCC),$G(TIULDT),"",.TIULAST,$G(TIUVDT))
 ; -- if none found, set quit variable
 I '$D(^TMP("TIUVNI",$J)) S BTIUQ=1 Q
 ; -- if not interactive mode and >1 found, set quit variable
 I '+TIUMODE,$O(^TMP("TIUVNI",$J,+$O(^TMP("TIUVNI",$J,0))))]"" S BTIUQ=1
 Q
 ;
GETAPPT(DFN,CLINIC,OCCLIM,INDEX,COUNT,LAST,EARLY) ;EP; Get list of visits
 ; -- changed list from list of appts to list of visits
 ;    TIUMODE=1 for interactive user mode; =0 for background
 NEW TIUCNT,TIUI,TIUSREC,TIUJ,TIUEND
 ;
 ; go back 20 visits or 100 if med records user
 S OCCLIM=$S(+$G(OCCLIM):+$G(OCCLIM),$$ISA^USRLM(DUZ,"MEDICAL INFORMATION SECTION"):100,1:20)
 ;
 ; get starting and ending dates
 S:'+$G(DT) DT=+$P($$NOW^TIULC,".")
 S EARLY=9999999.9999999-+$G(EARLY)
 S TIUI=9999999.9999999-$S(+$G(INDEX):+$G(INDEX)+1,1:DT+1)
 S (LAST,TIUCNT)=0,TIUJ=$S(+$G(COUNT):+$G(COUNT),1:0)
 ;
 ; loop through visit file for patient and date
 F  S TIUI=$O(^AUPNVSIT("AA",DFN,TIUI)) S:'TIUI LAST=1 Q:'TIUI!(TIUCNT'<OCCLIM)!(TIUI>EARLY)  D
 . S TIUZV=0 F  S TIUZV=$O(^AUPNVSIT("AA",DFN,TIUI,TIUZV)) Q:'TIUZV  D
 .. NEW X,TIUZ
 .. D ENP^XBDIQ1(9000010,TIUZV,".01;.06:.08;.11;.22","TIUZ(","I")
 .. ;
 .. ; try to match service category, clinic and author
 .. S X=TIUZ(.07,"I")  ;service category
 .. ;
 .. ;IHS/ITSC/LJF 01/05/2005 PATCH 1001 check hosp loc or clinic code 
 .. ;I '$G(CLINIC),X'="H",$G(TIUAUTH)]"" S CLINIC=$$GETCLN
 .. ;I '$G(CLINIC),'TIUMODE,X'="H" Q
 .. ;I +$G(CLINIC),(+TIUZ(.08,"I")'=+CLINIC),X'="H" Q
 .. I $G(CLINIC),(+TIUZ(.22,"I"))'=+CLINIC Q   ;if hosp loc sent, check it
 .. ; else check if clinic code sent or defined for title or provider, check it
 .. I '$G(CLINIC),X'="H",$G(TIUAUTH)]"" NEW STOP S STOP=0 D  Q:STOP
 ... S CLINIC=$$GETCLN
 ... I '$G(CLINIC),'TIUMODE,X'="H" S STOP=1 Q
 ... I +$G(CLINIC),(+TIUZ(.08,"I")'=+CLINIC),X'="H" S STOP=1
 .. ;IHS/ITSC/LJF 01/05/2005 end of PATCH 1001 changes
 .. ;
 .. S TIUCNT=+$G(TIUCNT)+1,TIUJ=+$G(TIUJ)+1
 .. I $G(CLINIC),X'="H",TIUZ(.01,"I")\1=$$IDATE^TIULC(TIUVDT) S TIUCNT=OCCLIM  ;if exact match found with clinic, stop looking
 .. ;
 .. S ^TMP("TIUVNI",$J,TIUJ)=TIUZ(.01,"I")_U_+TIUZ(.22,"I")_U_TIUZ(.07,"I")
 .. S ^TMP("TIUVN",$J,TIUJ)=TIUZ(.01)_U_TIUZ(.22)_U_TIUZ(.07)_U_TIUZ(.08)_U_$$PROV(TIUZV)_U_$$GET1^DIQ(9999999.06,+TIUZ(.06,"I"),.08)
 .. S ^TMP("TIUVDT",$J,TIUZ(.01,"I"))=TIUJ,^TMP("TIUIHSV",$J,TIUJ)=TIUZV
 ;
 I '$D(^TMP("TIUVNI",$J)) D
 . S Y=$$INPT(DFN,EARLY) I +Y D SETINPT($P(Y,U,2)) Q
 . I TIUMODE D
 .. S Y=$$READ^TIUU("Y","No visits for patient.  Okay to add one","YES") Q:'Y
 .. D ADD(DFN,$S($D(TIUHDR):$G(TIUVDT),1:EARLY),$G(TIUCLNC))
 Q
 ;
GETSURG(VISIT,DFN,HRCN,SRGDT,CLINIC) ;EP; Get list of surgeries
 ; -- also called by TIUPUTPN
 N TIUI,TIUX,TIUZ
 S DFN=+$$PATIENT^TIULA($G(TIUSSN)) I 'DFN Q
 S (TIUI,TIUX)=0
 F  S TIUI=$O(^SRF("AIHS4",SRGDT,DFN,TIUI)) Q:'TIUI  D
 . S TIUX=$$GET1^DIQ(130,TIUI,9999999.01,"I")
 . I TIUX S TIUZ(TIUX)="" Q
 S VISIT=$O(TIUZ(0)) I $O(TIUZ(VISIT)) S VISIT=0  ;>1 surgery on date
 I VISIT<1 S VISIT=0
 Q
 ;
HELP(X) ;EP; Offer help
 D MSG("   Indicate the visit with which the document is associated, by",2,0,0)
 D MSG("   choosing the corresponding number.  To VIEW a visit to insure",1,0,0)
 D MSG("   it is the correct one, type ""V"" plus the item # (i.e. V5).",1,0,0)
 D MSG("   To add a NEW visit type ""N"".  For MORE, older visits (beyond",1,0,0)
 D MSG("   the 20 most recent) enter ""M"".",1,2,0)
 Q
 ;
MSG(A,B,C,D) ; -- display line to screen
 D MSG^BTIUU(A,B,C,D)
 Q
 ;
ADD(DFN,ASK,TIUCLNC) ;EP; Add a visit for patient
 N VSIT,VTYPE,TIUY,DA,DIE,DR,X,Y,DEFAULT,QUES,TIUZ
 ;
 ; if visit date in header, TIUHDR array is set
 I $D(TIUHDR) N APCDHL
 ;
 ; set service category; use other routine if event selected
 S APCDCAT=$$READ^TIUU("S^A:AMBULATORY;I:IN-HOSPITAL;T:TELEPHONE CALL;C:CHART REVIEW;E:EVENT","Service Category","C"),APCDCAT=$E(APCDCAT)
 I APCDCAT="" S TIUER=1 Q
 I APCDCAT="E" S APCDVSIT=$$ADDEVNT^BTIUCHLP(DFN) D VSTSET Q
 ;
 ; set location, type & patient for visit
 D VISITSET Q:'APCDLOC
 ;
 ; get visit date
 S DEFAULT="NOW"
 I $D(TIUHDR) D
 . W !!?2,"*Visit Date in Header: ",$G(TIUHDR("TIUVDT"))
 . W "*  Remember to add time",!
 . S DEFAULT=""
 S APCDDATE=+$$READ^TIUU("D^::ERX","Visit Date & Time",DEFAULT)
 I +APCDDATE'>0 S TIUER=1 Q
 ;
 ; ask for clinic name
 S APCDHL=+$$SELLOC^TIUVSIT
 I APCDHL<1 S TIUER=1 Q
 ;
 ; ask clinic code
 S APCDCLN=+$$READ^TIUU("PO^40.7:EMQ","Clinic Code",$$GET1^DIQ(40.7,+$$GET1^DIQ(44,APCDHL,8,"I"),1))
 I APCDCAT="I",APCDCLN<1 K APCDCLN
 ;
 ; create visit
 D EN^APCDALV       ;calling PEP in PCC
 ;
 ; set TIU variables after visit created or selected
VSTSET I '$G(APCDVSIT) S TIUER=1 Q
 D MSG^BTIUU("**Visit Created!**",2,1,1)
 D ENP^XBDIQ1(9000010,APCDVSIT,".01;.06:.08;.11;.22","TIUZ(","I")
 ; set array with internal format for visit data
 S ^TMP("TIUVNI",$J,1)=TIUZ(.01,"I")_U_+TIUZ(.22,"I")_U_TIUZ(.07,"I")
 ; set array with external format for visit date
 S ^TMP("TIUVN",$J,1)=TIUZ(.01)_U_TIUZ(.22)_U_TIUZ(.07)_U_TIUZ(.08)_U_$$PROV(APCDVSIT)_U_$$GET1^DIQ(9999999.06,+TIUZ(.06,"I"),.08)
 ; set array with visit ien
 S ^TMP("TIUVDT",$J,TIUZ(.01,"I"))=1,^TMP("TIUIHSV",$J,1)=APCDVSIT
 ; set string with clinic, date and service category; used by VA rtns
 S VSTR=+TIUZ(.22,"I")_";"_+TIUZ(.01,"I")_";"_TIUZ(.07,"I")
 ; if hosp loc (clinic name) is set, TIUSDC=clinic code^amis stop code
 I +$G(APCDHL),$P($G(^SC(+APCDHL,0)),U,3)'="W" D
 . S TIUSDC=+$P($G(^SC(+APCDHL,0)),U,7)_U_$P($G(^DIC(40.7,+$P($G(^SC(+APCDHL,0)),U,7),0)),U,2)
 ;
 ; made it this far, set a-okay variables
 S TIUER=0,TIUOK=1
 Q
 ;
STUFVST(DFN,VDATE,APCDCLN) ; -- auto-add of visit if not found
 Q
 N VSIT,VTYPE,TIUY,DA,DIE,DR,X,Y,DEFAULT,QUES,TIUZ
 S APCDCAT=$$READ^TIUU("S^A:AMBULATORY;I:IN-HOSPITAL;T:TELEPHONE CALL;C:CHART REVIEW","Service Category","A"),APCDCAT=$E(APCDCAT)
 I APCDCAT="" S TIUER=1 Q
 D VISITSET Q:'APCDLOC   ; set standard visit variables
 W !!?2,"*Visit Date in Header: ",$G(TIUHDR("TIUVDT")),"*  Remember to add time",!
 S APCDDATE=+$$READ^TIUU("D^::ERX","Visit Date & Time")
 I +APCDDATE'>0 S TIUER=1 Q
 S APCDCLN=+$$READ^TIUU("PO^40.7:EMQ","Clinic Code",$G(APCDCLN))
 I APCDCAT="I",APCDCLN<1 K APCDCLN
 ;
 ; -- create visit
 D ^APCDALV I 'APCDVSIT S TIUER=1 Q
 D MSG^BTIUU("**Visit Created!**",2,1,1)
 D ENP^XBDIQ1(9000010,APCDVSIT,".01;.06:.08;.11;.22","TIUZ(","I")
 S ^TMP("TIUVNI",$J,1)=TIUZ(.01,"I")_U_+TIUZ(.22,"I")_U_TIUZ(.07,"I")
 S ^TMP("TIUVN",$J,1)=TIUZ(.01)_U_TIUZ(.22)_U_TIUZ(.07)_U_TIUZ(.08)_U_$$PROV(APCDVSIT)_U_$$GET1^DIQ(9999999.06,+TIUZ(.06,"I"),.08)
 S ^TMP("TIUVDT",$J,TIUZ(.01,"I"))=1,^TMP("TIUIHSV",$J,1)=APCDVSIT
 ;
 I +$G(APCDHL),$P($G(^SC(+APCDHL,0)),U,3)'="W" D
 . S TIUSDC=+$P($G(^SC(+APCDHL,0)),U,7)_U_$P($G(^DIC(40.7,+$P($G(^SC(+APCDHL,0)),U,7),0)),U,2)
 S TIUER=0
 Q
 ;
VISITSET ; -- sets visit variables
 ; -- pre-answer some questions
 S APCDLOC=$G(DUZ(2)) ; location
 I 'APCDLOC!'$D(^APCDSITE(+APCDLOC)) S APCDLOC=$O(^APCCCTRL(0))
 Q:'APCDLOC
 S APCDTYPE=$$GET1^DIQ(9001001.2,APCDLOC,.11,"I") ;type of visit
 S APCDPAT=+DFN ;patient
 Q
 ;
 ;
INPT(DFN,VDATE) ; -- return 1 if patient was inpatient on this date
 NEW LASTA,VISIT,DSCH
 S LASTA=$O(^AUPNVSIT("AAH",DFN,VDATE)) I LASTA="" Q 0      ;no admits
 S VISIT=$O(^AUPNVSIT("AAH",DFN,LASTA,0)) I VISIT="" Q 0    ;bad xref
 I '$D(^AUPNVINP("AD",VISIT)) Q 1_U_VISIT                   ;still inpt
 S DSCH=+$G(^AUPNVINP(+$O(^AUPNVINP("AD",VISIT,0)),0))
 I DSCH<(9999999.9999999-VDATE) Q 0                         ;already dsch
 Q 1_U_VISIT
 ;
SETINPT(VISIT) ; -- set ^tmp for hospitalization
 NEW TIUZ,REVDT
 D ENP^XBDIQ1(9000010,VISIT,".01;.07;.08","TIUZ(","I")
 S REVDT=9999999.9999999-TIUZ(.01,"I")
 S ^TMP("TIUVNI",$J,1)=REVDT_U_+TIUZ(.08,"I")_U_TIUZ(.07,"I")
 S ^TMP("TIUVN",$J,1)=TIUZ(.01)_U_TIUZ(.08)_U_TIUZ(.07)
 S ^TMP("TIUVDT",$J,REVDT)=1,^TMP("TIUIHSV",$J,1)=VISIT
 Q
 ;
PROV(V) ;EP; -- returns primary provider for visit
 NEW X,Y
 S X=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:'X!($D(Y))  D
 . I $P(^AUPNVPRV(X,0),U,4)'="P" Q
 . S Y=$$GET1^DIQ($S($P(^DD(9000010.06,.01,0),U,2)[200:200,1:6),+^AUPNVPRV(X,0),.01)
 Q $E($G(Y),1,15)
 ;
GETCLN() ; -- returns clinic code ien for dictator if defined
 I $G(TIUCLNC) S X=$O(^DIC(40.7,"C",TIUCLNC,0)) I X Q X   ;IHS/ITSC/LJF 01/05/2005 PATCH 1001
 NEW X,Y,DIC,USR,CODE,TIUCLNC
 ; -- does title have clinic code?
 S Y=$O(^TIU(8925.1,+$G(TIUTYPE),"HEAD","E","TIUCLNC",0))
 I Y S CODE=$G(^TIU(8925.1,+TIUTYPE,"HEAD",Y,1))
 I $G(CODE)]"" X CODE
 I $G(TIUCLNC) S X=$O(^DIC(40.7,"C",TIUCLNC,0)) I X Q X
 ;
 ; -- does author have clinic code?
 S X=$$INAME^TIULS(TIUAUTH),DIC=200,DIC(0)="M" D ^DIC I Y<1 Q ""
 S USR=0 F  S USR=$O(^USR(8930.3,"B",+Y,USR)) Q:'USR!($G(CODE))  D
 . S CODE=$$GET1^DIQ(8930.3,USR,9999999.02,"I")
 Q $G(CODE)
