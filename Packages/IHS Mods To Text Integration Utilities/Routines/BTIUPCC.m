BTIUPCC ; IHS/ITSC/LJF - IHS PCC LINKS WITH TIU ;09-Mar-2007 15:58;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1001,1003,1004,1005*;NOV 04, 2004
 ;IHS/ITSC/LJF 01/26/2005 PATCH 1001 added code to return brief lab result
 ;IHS/CIA/MGH 09/20/2005 PATCH 1003
 ;IHS/CIA/MGH 04/03/2006 PATCH 1004 fixed a bug with changes in 1003
 ;IHS/MSC/MGH PATCH 1005 added lookup by date only
GETV(TIUVSIT,DFN,VLOC,VDATE,CATEGORY) ;EP
 ; returns visit ien for patient, date, srv cat
 NEW TIUX,TIUD,TIUEND,TIUV
 S (TIUD,TIUEND)=9999999-(VDATE\1),TIUVSIT=0
 F  S TIUD=$O(^AUPNVSIT("AA",DFN,TIUD)) Q:TIUD=""!($P(TIUD,".")'=TIUEND)!($G(TIUVSIT))  D
 . S TIUV=0
 . F  S TIUV=$O(^AUPNVSIT("AA",DFN,TIUD,TIUV)) Q:TIUV=""!($G(TIUVSIT))  D
 .. Q:$$GET1^DIQ(9000010,TIUV,.07,"I")'=CATEGORY
 .. S TIUVSIT=TIUV
 Q
 ;
 ;IHS/ITSC/LJF 01/26/2005 PATCH 1001 added code to handle brief result; see lines wiht "PATCH 1001"
SLAB(DFN,TIUTST,TIULAST,BRIEF) ;EP; -- returns most current lab result for single test  ;PATCH 1001
 ; BRIEF=1 means brief result, BRIEF=2 no caption or date; optional                       ;PATCH 1001
 ; BRIEF=3 means date only
 NEW LAB,VDT,IEN,X,TIU,LINE,ARR,DATE,BTIUQ
 S LAB=$O(^LAB(60,"B",TIUTST,0)) I LAB="" Q ""
 S VDT=0
 F  S VDT=$O(^AUPNVLAB("AA",DFN,LAB,VDT)) Q:'VDT!($G(LINE)]"")  D
 .S IEN=0
 .;IHS/CIA/MGH
 .;F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN!($G(LINE)]"")  D
 .F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN  D
 ..K TIU D ENP^XBDIQ1(9000010.09,IEN,".03:.05;1109;1201","TIU(")
 ..S DATE=$S(TIU(1201)]"":TIU(1201),1:TIU(.03))
 ..I TIU(.04)="" D  Q
 ...;I '$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) S LINE=$$PAD(TIU(1109),25)_DATE         ;PATCH 1001
 ...I '$O(^AUPNVLAB("AA",DFN,LAB,VDT)) S:'$G(BRIEF) LINE=$$PAD(TIU(1109),25)_DATE   ;PATCH 1001
 ..I $G(BRIEF)=1 S LINE=TIU(.04)                                          ;PATCH 1001
 ..I $G(BRIEF)=3 S LINE=DATE
 ..E  S LINE=$$PAD($J(TIU(.04),8)_"  "_TIU(.05),10)_DATE
 ..;Added for multiple of the same test on the same day IHS/CIA/MGH
 ..S ARR(DATE,IEN)=LINE  ; PATCH 1003
 ;
 I '$D(ARR) Q $S($G(BRIEF):" - Not Done -",1:$$PAD(TIUTST,20)_" -Not Done-")             ;PATCH 1003
 S DATE=$O(ARR(""),-1)       ;PATCH 1003
 S IEN=$O(ARR(DATE,""),-1)   ;PATCH 1003
 S LINE=ARR(DATE,IEN)        ;PATCH 1003
 ;End fix  IHS/CIA/MGH
 S X=$S($G(TIULAST)]"":TIULAST,1:"Last ")_$$PAD(TIUTST,20)  ;PATCH 1003
 I $G(BRIEF) S BTIUQ=$G(LINE)  ;PATCH 1004
 E  S BTIUQ=X_" "_$G(LINE)     ;PATCH 1004
 Q BTIUQ
 ;Q $S($G(BRIEF):$G(LINE),1:X_" "_$S($G(LINE)]"":LINE)   ;PATCH 1001
 ;
LABPANL(DFN,TIUPANL,TIUCNT) ;EP; -- mult line answer for results under panel
 NEW LAB,TEST,TIUTST,X
 K ^TMP("BTIULO",$J)
 S LAB=$O(^LAB(60,"B",TIUPANL,0)) I LAB="" Q ""
 S TIUCNT=$G(TIUCNT)+1,X=$S(TIUCNT>1:"  ",1:"")
 S ^TMP("BTIULO",$J,TIUCNT,0)=X_"Last "_TIUPANL_":"
 S TEST=0 F  S TEST=$O(^LAB(60,LAB,2,TEST)) Q:'TEST  D
 . S TIUTST=+^LAB(60,LAB,2,TEST,0)
 . I $P(^LAB(60,TIUTST,0),U,3)="N" Q  ;type=neither
 . I $O(^LAB(60,TIUTST,2,0)) S X=$$LABPANL(DFN,$P(^LAB(60,TIUTST,0),U),.TIUCNT) Q
 . S X=$$SLAB(DFN,$P(^LAB(60,TIUTST,0),U),$$SP(5)) Q:X=""
 . S TIUCNT=$G(TIUCNT)+1,^TMP("BTIULO",$J,TIUCNT,0)=" "_X
 Q "~@^TMP(""BTIULO"",$J)"
 ;
SMEAS(V,TYPE) ;EP; -- returns a single measurement taken during visit
 NEW APCLV,E,X,Y
 S X="APCLV" X ^%ZOSF("TEST") I '$T Q ""
 S E=$$PCCVF^APCLV(V,"MEASUREMENT","7;8") I E Q ""
 S Y="",X=0 F  S X=$O(APCLV(X)) Q:'X  D
 . Q:$P(APCLV(X),U)'=TYPE
 . S Y=Y_$P(APCLV(X),U,2)_";"
 Q $S(Y="":Y,1:$E(Y,1,$L(Y)-1))
 ;
MMEAS(V) ;EP; -- returns all measurements for a visit
 NEW APCLV,E,X,Y,TIUZ
 S X="APCLV" X ^%ZOSF("TEST") I '$T Q ""
 S E=$$PCCVF^APCLV(V,"MEASUREMENT","7;8") I E Q ""
 S X=0 F  S X=$O(APCLV(X)) Q:'X  D
 . S TIUZ($P(APCLV(X),U))=$G(TIU($P(APCLV(X),U)))_$P(APCLV(X),U,2)_";"
 S Y="",X=0 F  S X=$O(TIUZ(X)) Q:X=""  S Y=Y_X_":"_TIUZ(X)_" "
 Q Y
 ;
MIMM(V) ;EP; -- returns all immunizations for a visit
 NEW X,BTIUN,E,BTIUY
 S X="APCLV" X ^%ZOSF("TEST") I '$T Q ""
 I 'V Q ""
 F BTIUN=1:1 S E=$$IMM^APCLV(V,"E",BTIUN) Q:E=""  D
 . S BTIUY=$G(BTIUY)_"; "_E
 Q $P($G(BTIUY),";",2,99)
 ;
VV(N) ;EP; -- displays visit
 ; -- called by TIUVSIT
 NEW DFN,APCDVSIT
 I $L(N)=1 W !,*7,"You MUST type ""V"" plus the item # (i.e. V3).",!! Q
 S APCDVSIT=$G(^TMP("TIUIHSV",$J,$E(N,2,99))) Q:'APCDVSIT
 D EN^APCDVD     ;calling PEP in PCC
 Q
 ;
VNOTE(NOTE,VISIT,DFN,MODE) ;EP; -- create v note entry
 ; -- called by TIUEDIT
 I $$GET1^DIQ(8925,NOTE,.03,"I")'=+VISIT D ERRMSG(1) Q
 I $$GET1^DIQ(9000010,+VISIT,.05,"I")'=DFN D ERRMSG(2) Q
 NEW APCDALVR,APCDADFN,APCDAFLG,APCDLOOK
 I MODE="ADD",$O(^AUPNVNOT("B",NOTE,0)) S MODE="MOD",APCDALVR("APCDLOOK")="`"_$O(^AUPNVNOT("B",NOTE,0))
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.28 ("_MODE_")]"
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=+VISIT
 S APCDALVR("APCDTDOC")="`"_NOTE
 S APCDALVR("APCDTCDT")=$$GET1^DIQ(8925,NOTE,1201,"I")
 I $G(BTIURX) S X=$$ORDPRV(+VISIT) I X]"" S APCDALVR("APCDTEPR")="`"_X
 S X=$$GET1^DIQ(8925,NOTE,1202,"I") I X]"" S APCDALVR("APCDTPRV")="`"_X
 D EN^APCDALVR        ;calling PEP in PCC
 I $G(APCDAFLG) D ERRMSG(2) Q
 Q
 ;
ORDPRV(V) ; -- returns ien for ordering provider on 1st v med entry for visit
 ; called when v note entered as part of pharmacy process
 NEW X S X=$O(^AUPNVMED("AD",V,0)) I X="" Q ""
 Q $$GET1^DIQ(9000010.14,X,1202,"I")
 ;
 ;
ERRMSG(N) ; -- store error if v note add bombs
 I $D(ZTQUEUED) S ^TIUZZ("ERROR",+$G(N))=$G(VISIT) Q
 I N=1 W !!,*7,"VISIT=",VISIT,!! Q
 W !!,*7,$G(APCDAFLG),!!
 Q
 ;
 ;
DEMOG(NOTE) ;EP; -- sets up line of demographic data
 ; NOTE=document ien
 NEW PT,TIUZZ
 S PT=$$GET1^DIQ(8925,NOTE,.02,"I") I PT="" Q ""
 D ENP^XBDIQ1(9000001,PT,"1101.2;1102.2;1102.98","TIUZZ(")
 S LINE=TIUZZ(1101.2)_"  DOB: "_$$FMTE^XLFDT(TIUZZ(1102.2),"5D")
 S LINE=LINE_" ("_TIUZZ(1102.98)_")" ;age
 Q LINE
 ;
VLINE(NOTE) ;EP; -- sets up visit display lines for ^tmp(tiur,$j arrays
 ; NOTE=document ien
 NEW TIUZZ,VST,PAT
 S VST=+$$GET1^DIQ(8925,NOTE,.03,"I") I VST=0 Q "*** NO VISIT ATTACHED ***"
 S PAT=+$$GET1^DIQ(8925,NOTE,.02,"I")
 D ENP^XBDIQ1(9000010,VST,".01;.05:.08;.22","TIUZZ(","I")
 I TIUZZ(.05,"I")'=PAT Q "**** BAD VISIT LINK ****"
 I TIUZZ(.07,"I")="H" Q $$HOSLINE(VST)
 I TIUZZ(.07,"I")="E" Q $$EVTLINE(VST)
 Q $$AMBLINE(VST)
 ;
AMBLINE(VST) ; -- returns line of readable ambulatory data
 NEW LINE
 S LINE=" Visit: "_$$FMTE^XLFDT(TIUZZ(.01,"I"),1) ;visit date
 S LINE=$$PAD(LINE,28)_TIUZZ(.07)_"-"  ;ser cat
 S LINE=LINE_$$PAD($$CLINIC,6) ;clinic type & name
 S LINE=LINE_" Dx: "_$$POV(VST,1)  ;prim dx
 Q LINE
 ;
EVTLINE(VST) ; -- returns line of readable historical event data
 NEW LINE
 S LINE=" Visit: "_$$FMTE^XLFDT(TIUZZ(.01,"I"),1) ;visit date
 S LINE=$$PAD(LINE,28)_TIUZZ(.07)_" at "          ;service category
 ; location of encounter and chart # at that location
 S LINE=LINE_$$PAD($$GET1^DIQ(9999999.06,TIUZZ(.06,"I"),.02),13)
 S LINE=LINE_"- Chart #"_$$HRCN(TIUZZ(.05,"I"),TIUZZ(.06,"I"))
 Q LINE
 ;
HOSLINE(VST) ; -- returns line of readable hospitalization data
 NEW LINE
 S LINE="Inpt: "_$$VD^APCLV(VST,"S")_"-"_$$DSCH(VST)
 S LINE=$$PAD(LINE,25)_"admt by "_$$PAD($$PROV(NOTE),18)  ;admt prov
 S LINE=LINE_$$PAD($$SRV,5) ;service
 S LINE=LINE_" Dx: "_$$POV(VST,"P")  ;prim dx
 Q LINE
 ;
DSCH(VISIT) ;EP; -- returns discharge date for visit
 NEW X
 S X=$$DSCHDATE^APCLV(VISIT,"S")
 Q $S(X]"":X,1:"??")
 ;
CLINIC() ; -- returns clinic stop abbrev
 Q $$GET1^DIQ(40.7,+TIUZZ(.08,"I"),999999901) ;abbrev
 ;
SRV() ; -- returns service
 NEW HOS,ASRV,DSRV
 S HOS=$O(^AUPNVINP("AD",VST,0)) I HOS="" Q ""
 S ASRV=$$GET1^DIQ(45.7,+$$GET1^DIQ(9000010.02,HOS,.04,"I"),99)
 S DSRV=$$GET1^DIQ(45.7,+$$GET1^DIQ(9000010.02,HOS,.05,"I"),99)
 Q ASRV_$S(ASRV'=DSRV:"/"_DSRV,1:"")
 ;
POV(VISIT,SCREEN) ; -- returns a diagnosis
 ; SCREEN=1 for ambulatory visits, =P for hospitalizations
 NEW DX,IEN
 I SCREEN=1 D  Q DX
 . S IEN=$O(^AUPNVPOV("AD",VISIT,0)) I 'IEN S DX="" Q
 . S DX=$$GET1^DIQ(9000010.07,IEN,.04)
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPOV("AD",VISIT,IEN)) Q:'IEN!($D(DX))  D
 . I $$GET1^DIQ(9000010.07,IEN,.12,"I")'="P" Q
 . S DX=$$GET1^DIQ(9000010.07,IEN,.04)
 Q $G(DX)
 ;
POVALL(VISIT) ; -- returns all diagnoses for a visit
 NEW DX,IEN
 S IEN=0,DX=""
 F  S IEN=$O(^AUPNVPOV("AD",VISIT,IEN)) Q:'IEN  D
 . S DX=DX_"; "_$$GET1^DIQ(9000010.07,IEN,.04)
 Q "  POV:"_$P(DX,";",2,9999)
 ;
PRCALL(VISIT) ; -- returns all procedures for a visit
 NEW PRC,IEN
 S IEN=0,PRC=""
 F  S IEN=$O(^AUPNVPRC("AD",VISIT,IEN)) Q:'IEN  D
 . S PRC=PRC_"; "_$$GET1^DIQ(9000010.08,IEN,.04)
 S PRC=$P(PRC,";",2,999)
 Q $S(PRC="":"",1:"  Procedure(s):"_PRC)
 ;
PRVALL(VISIT) ; -- returns all providers for a visit
 NEW PRV,IEN
 S IEN=0,PRV=""
 F  S IEN=$O(^AUPNVPRV("AD",VISIT,IEN)) Q:'IEN  D
 . S PRV=PRV_"; "_$$GET1^DIQ(9000010.06,IEN,.01)
 Q "  Provider(s):"_$P(PRV,";",2,999)
 ;
DISCH(VISIT) ;EP; -- returns discharge date for visit
 NEW VH
 S VH=$O(^AUPNVINP("AD",VISIT,0)) I VH="" Q ""
 Q $$FMTE^XLFDT(+^AUPNVINP(VH,0),5)
 ;
PROV(NOTE) ; -- returns admitg prov for movement
 NEW X,Y
 S X=$$GET1^DIQ(8925,NOTE,1401,"I") I X="" Q ""       ;admit ien for note
 S X=$$GET1^DIQ(405,X,.01,"I") I X="" Q ""            ;date/time of admit
 S Y=$$GET1^DIQ(8925,NOTE,.02,"I") I Y="" Q ""        ;patient ien
 S X=$O(^DGPM("AMV6",X,Y,0)) I X="" Q ""              ;1st service for admit
 ;
 I $L($T(^BDGF1)) Q $E($$GET1^DIQ(405,+X,9999999.02),1,15)  ;admitg provider PIMS v5.3
 Q $E($$GET1^DIQ(405,+X,.08),1,15)                           ;admitg provider MAS v5.0
 ;
HRCN(PAT,FAC) ;EP; -- returns chart # for patient at facility sent
 Q $P($G(^AUPNPAT(PAT,41,FAC,0)),U,2)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
