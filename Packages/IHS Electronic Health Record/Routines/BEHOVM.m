BEHOVM ;MSC/IND/DKM - Cover Sheet: Vital Measurements ;05-Oct-2010 16:06;PLS
 ;;1.1;BEH COMPONENTS;**001003,001004,001005,001006**;Sep 18, 2007
 ;=================================================================
 ; RPC: Return patient's most recent vital measurements
 ;     vfile ien^vital name^vital abbr^date/time taken^value+units (US & metric)^Pt status (in,out)
LIST(DATA,DFN,START,END,VITS,VSTR,METRIC,PTST,FSDATA) ;EP
 N RMAX
 S RMAX=1
 D QUERY("LISTX")
 Q
 ; Format data for list view
LISTX N X
 S X=RESULT(VUNT)_" "_$P(VUNT(VUNT),U)_U
 S:VUNT(0)'=VUNT(1) X=X_RESULT('VUNT)_" "_$P(VUNT('VUNT),U)
 D ADD(VIEN_U_VNAM_U_VABR_U_DATE_U_X_U_QUALIF)
 Q
 ; RPC: Return last vital for a specific date range
LASTVIT(DATA,DFN,START,END,VITS,METRIC,FSDATA) ;EP
 N VSTR,RMAX
 S RMAX=1
 D QUERY("LASTVITX")
 Q
 ; Format data for list view
LASTVITX N X
 S X=RESULT(VUNT)_" "_$P(VUNT(VUNT),U)_U
 S:VUNT(0)'=VUNT(1) X=X_"("_RESULT('VUNT)_" "_$P(VUNT('VUNT),U)_")"
 D ADD(VIEN_U_VABR_U_RESULT(VUNT)_U_DATE_U_X_U_QUALIF)
 Q
 ; Return last vital for specified type
 ; Return format is: DT TAKEN^DFN^VTYP^VCTL^LOC^ENTERED BY^^RATE
LAST(DFN,VITS,METRIC,START,END) ;EP
 N VSTR,RMAX,DATA,LAST
 S RMAX=1
 D QUERY("LASTX")
 Q $G(LAST)
LASTX S LAST=DATE_U_DFN_U_VTYP_U_VCTL_U_LOC_U_ENTERBY_U_U_RESULT(METRIC)_U_QUALIF
 Q
 ; RPC: Return data for grid view
GRID(DATA,DFN,START,END,RMAX,VITS,VSTR,METRIC,SD,FSDATA,PTST) ;EP
 N CNT
 D QUERY("GRIDX",.CNT,.SD)
 M @DATA@(0)=VITS
 S @DATA@(0)=CNT(1)_U_CNT(2)_U_CNT(3)
 Q
 ; Format for grid view
GRIDX I '$D(DATE(DATE(0))) D
 .S CNT(2)=CNT(2)+1,DATE(DATE(0))=CNT(2)
 .D ADD(CNT(2)_U_DATE(0),,DATE(0))
 D ADD(DATE(DATE(0))_U_CNT(1)_U_RESULT(METRIC)_U_$$FLAG_U_VIEN_U_QUALIF,,"R")
 I $G(COMMENT)'="" D ADD(DATE(DATE(0))_U_CNT(1)_U_VIEN_U_COMMENT,,"C")
 S CNT(3)=CNT(3)+1
 Q
 ; RPC: Return data for vital entry template
TEMPLATE(DATA,DFN,VSTR,METRIC) ;EP
 N VITS
 S:'$P(VSTR,";",4) $P(VSTR,";",4)=-1
 D VLIST(.VITS,"BEHOVM TEMPLATE",+VSTR)
 ;IHS/MSC/MGH Called now to truncate to 2 decimal places
 D GRID(.DATA,DFN,,,,.VITS,VSTR,.METRIC,2)
 Q
 ; Return flag for abnormal
FLAG() N LO,HI,VAL
 S LO=$P(VUNT(VUNT),U,2,3),HI=$P(LO,U,2),LO=$P(LO,U),VAL=RESULT(VUNT)
 Q $S(VAL'=+VAL:"",$L(LO)&(VAL<LO):"L",$L(HI)&(VAL>HI):"H",1:"")
 ; RPC: Return data for detail view
DETAIL(DATA,DFN,START,END,RMAX,VITS,VSTR,METRIC) ;EP
 D QUERY("DETAILX")
 Q
 ; Format for detail view
DETAILX I '$D(DATE(DATE(0),LOC,ENTERBY)) D
 .S CNT(2)=CNT(2)+1,DATE(DATE(0),LOC,ENTERBY)=CNT(2)
 .D ADD("",,CNT(2))
 .D ADD($$ENTRY^CIAUDT(DATE)_"      Location: "_$P($G(^SC(LOC,0)),U)_"  Entered by: "_$P($G(^VA(200,ENTERBY,0)),U),,CNT(2))
 .D ADD($$REPEAT^XLFSTR("-",80),,CNT(2))
 D ADD(RESULT(METRIC)_" "_$P(VUNT(METRIC),U),"  "_VNAM,DATE(DATE(0),LOC,ENTERBY))
 Q
 ; Query logic for vitals
QUERY(RTN,CNT,SD) ;
 N SEQ,VIEN,IDT,DATE,LOC,VTYP,VNAM,VCTL,VABR,RCNT,RESULT,ENTERBY,VMSR,VUNT,VSIT,QRY,DEFUNT,X,Y,Z
 N QUALS,QUALIF,QUALN,COMMENT
 S DATA=$$TMPGBL^CIAVMRPC,START=+$G(START),END=+$G(END),RMAX=+$G(RMAX),VSTR=$G(VSTR),VSIT=+$P(VSTR,";",4),PTST=$G(PTST)
 S (CNT,CNT(1),CNT(2),CNT(3),SEQ)=0
 Q:'DFN
 S:'START START=DT+1
 S:START<END X=START,START=END,END=X
 S START=9999999-$S(START#1:START,1:START+.9),END=9999999-END
 S:'RMAX RMAX=99999999
 I $D(VITS)=1,$L(VITS) S VITS(1)=VITS
 D:$D(VITS)'>1 VLIST(.VITS,"BEHOVM VITAL LIST",+VSTR)
 S VMSR=$$VMSR,METRIC=$G(METRIC,-1),METRIC=$S(METRIC<0:-1,METRIC>0:1,1:0),DEFUNT=METRIC<0
 F  S SEQ=$O(VITS(SEQ)) Q:'SEQ  D
 .S VCTL=+VITS(SEQ)
 .D TYPEINFO(.VCTL,.VNAM,.VABR,.VUNT,VMSR,.VTYP)
 .;I VCTL'>0!(VTYP'>0) K VITS(SEQ) Q
 .S:DEFUNT METRIC=$$DEFUNIT(VCTL,VUNT)
 .S VITS(SEQ)=VCTL_U_VTYP_U_VNAM_U_VABR_U_VUNT(METRIC)_U_$S($O(^BEHOVM(90460.01,VCTL,3,0)):"BEHOVM PCTILE",1:"")
 .S IDT=START,RCNT=0,CNT(1)=CNT(1)+1,QRY=$G(^BEHOVM(90460.01,VCTL,10))
 .I $L(QRY) X QRY Q
 .D QRYGMR:'VMSR,QRYMSR:VMSR
 Q
 ; Query logic for Vitals package
QRYGMR F  Q:'IDT!(IDT>END)!(RCNT=RMAX)  D
 .S VIEN=$C(1)
 .S XREF="AA"
 .F  S VIEN=$O(^GMR(120.5,XREF,DFN,VTYP,IDT,VIEN),-1) Q:'VIEN  D  Q:RCNT=RMAX
 ..;IHS/MSC/MGH Quit if this vital was entered in error
 ..Q:$P($G(^GMR(120.5,VIEN,2)),U)  S X=$G(^(0))
 ..Q:$P(X,U,2)'=DFN
 ..Q:$P(X,U,3)'=VTYP
 ..I VSIT,+$G(^GMR(120.5,VIEN,9000010))'=VSIT Q
 ..S RESULT(VUNT)=$$TRIM^XLFSTR($P(X,U,8)),DATE=+X,LOC=+$P(X,U,5),ENTERBY=+$P(X,U,6),RCNT=RCNT+1
 ..S DATE(0)=DATE*10000\1/10000
 ..;IHS/MSC/MGH Get qualifier informaton for GMR file patch 5
 ..S QUALIF="",COMMENT=""
 ..S QUALS=0 F  S QUALS=$O(^GMR(120.5,VIEN,5,QUALS)) Q:QUALS=""  D
 ...S QUALN=$P($G(^GMR(120.5,VIEN,5,QUALS,0)),U,1)
 ...I +QUALN S QUALN=$P($G(^GMRD(120.52,QUALN,0)),U,1)
 ...I QUALIF="" S QUALIF=QUALN
 ...E  S QUALIF=QUALIF_"~"_QUALN
 ..D CALLBCK
 .S IDT=$O(^GMR(120.5,"AA",DFN,VTYP,IDT))
 Q
 ; Query logic for V file
QRYMSR D BLDXRF(VTYP)
 F  Q:'IDT!(RCNT=RMAX)  D
 .S VIEN=$C(1)
 .F  S VIEN=$O(^TMP("BEHOVM",$J,VTYP,IDT,VIEN),-1) Q:'VIEN  D  Q:RCNT=RMAX
 ..D GETMSR(VIEN,.X,.DATE,.LOC,.ENTERBY)
 ..S RESULT(VUNT)=X,RCNT=RCNT+1
 ..D CALLBCK
 .S IDT=$O(^TMP("BEHOVM",$J,VTYP,IDT))
 K ^TMP("BEHOVM",$J)
 Q
 ; Query logic for BMI
 ; Redone to use same logic as health summary
QRYBMI(PCTILE) ;
 D QRYBMI^BEHOVM2(PCTILE)
 Q
 ; Get measurement data
GETMSR(VIEN,RESULT,DATE,LOC,ENTERBY) ;
 N X,X12,DATEE
 S X=$G(^AUPNVMSR(VIEN,0)),X12=$G(^(12))
 S DATEE=$P(X,U,7)
 S DATE=+X12,ENTERBY=+$P(X12,U,4)
 S RESULT=$$TRIM^XLFSTR($P(X,U,4)),X=+$P(X,U,3)
 S X=$G(^AUPNVSIT(X,0))
 S:'DATE DATE=+X
 S LOC=+$P(X,U,22),DATE(0)=DATE*10000\1/10000
 ;IHS/MSC/MGH Get qualifier information patch 5
 S QUALIF="" S COMMENT=""
 I $D(^AUPNVMSR(VIEN,5))>0 D
 .S QUALS=0 F  S QUALS=$O(^AUPNVMSR(VIEN,5,QUALS)) Q:QUALS=""  D
 ..S QUALN=$P($G(^AUPNVMSR(VIEN,5,QUALS,0)),U,1)
 ..I QUALN S QUALN=$P($G(^GMRD(120.52,QUALN,0)),U,1)
 ..I QUALIF="" S QUALIF=QUALN
 ..E  S QUALIF=QUALIF_"~"_QUALN
 I +$G(FSDATA)>0 D
 .S COMMENT=$P($G(^AUPNVMSR(VIEN,811)),U,1)
 Q
 ; Build temp xref for measurement type
BLDXRF(VTYP) ;
 N X,Y,Z,TT,CVISIT,CTYPE,XREF,MDATE,EIE
 S X=0
 K ^TMP("BEHOVM",$J,VTYP)
 ;IHS/MSC/MGH Use different cross-reference if flowsheets
 I +$G(FSDATA)>0 S XREF="AE"
 E  S XREF="AA"
 F  S X=$O(^AUPNVMSR(XREF,DFN,VTYP,X)),VIEN=0 Q:'X  D
 .F  S VIEN=$O(^AUPNVMSR(XREF,DFN,VTYP,X,VIEN)) Q:'VIEN  D
 ..S Z=$G(^AUPNVMSR(VIEN,0)),Y=+$G(^(12)),Y=$S(Y:9999999-Y,1:X)
 ..S Y=$S(XREF="AA":Y,1:X)
 ..Q:+Z'=VTYP
 ..Q:$P(Z,U,2)'=DFN
 ..I VSIT,$P(Z,U,3)'=VSIT Q
 ..S MDATE=$S(XREF="AA":Y,1:X)
 ..Q:MDATE<START
 ..Q:MDATE>END
 ..;IHS/MSC/MGH  Quit if entered in error
 ..S EIE=$$GET1^DIQ(9000010.01,VIEN,2,"I")
 ..Q:EIE=1
 ..;IHS/MSC/MGH Check for inpt or outpt status
 ..I PTST="I"!(PTST="O") D
 ...S CVISIT=$P($G(^AUPNVMSR(VIEN,0)),U,3)
 ...I CVISIT'="" S CTYPE=$P($G(^AUPNVSIT(CVISIT,0)),U,7)
 ...I PTST="H"&(CTYPE="H") S ^TMP("BEHOVM",$J,VTYP,MDATE,VIEN)=""
 ...I PTST="O"&(CTYPE'="H") S ^TMP("BEHOVM",$J,VTYP,MDATE,VIEN)=""
 ..I PTST="" S ^TMP("BEHOVM",$J,VTYP,MDATE,VIEN)=""
 Q
 ; Perform query callback
CALLBCK S RESULT('VUNT)=$$CONVERT(RESULT(VUNT),VUNT,.SD)
 S RESULT(VUNT)=$$ROUND(RESULT(VUNT),.SD)
 D @RTN
 Q
 ; Return info for vital type
TYPEINFO(VCTL,VNAM,VABR,VUNT,VMSR,VTYP) ;EP
 N X
 S VCTL=$$VCTL(VCTL)
 S X=$G(^BEHOVM(90460.01,VCTL,0))
 I '$L(X) S (VNAM,VABR,VUNT,VCTL)="" Q
 S VNAM=$P(X,U),VABR=$P(X,U,7)
 S:'$D(VMSR) VMSR=$$VMSR
 F X=VABR,VNAM D  Q:VTYP
 .S VTYP=$$VTYPE(X,VMSR)
 ;I 'VTYP S (VNAM,VABR,VUNT,VCTL)="" Q
 D UNITS(.VUNT)
 Q
 ; Returns IEN of vital control ien
VCTL(X) Q $S(X=+X:X,1:+$O(^BEHOVM(90460.01,"B",X,0)))
 ; Returns vital control IEN given measure type IEN
TYP2CTL(VTYP,VMSR) ;
 N FNUM,X
 S:'$D(VMSR) VMSR=$$VMSR
 S FNUM=$S(VMSR:9999999.07,1:120.51)
 S X=$$GET1^DIQ(FNUM,VTYP,.01)
 S:$L(X) X=$$VCTL(X)
 Q:X X
 S X=$$GET1^DIQ(FNUM,VTYP,$S(VMSR:.02,1:7))
 Q $S($L(X):$$VCTL(X),1:"")
 ; Gets vital type based on name or abbreviation
VTYPE(X,VMSR) ;
 N FNUM
 S:'$D(VMSR) VMSR=$$VMSR
 S FNUM=$S(VMSR:9999999.07,1:120.51)
 Q +$$FIND1^DIC(FNUM,"","X",$$UP^XLFSTR(X),"B^"_$S(VMSR:"D",1:"APCE^C"))
 ; Returns true if V file is used for vital measurements
VMSR() Q ''$$GET^XPAR("ALL","BEHOVM USE VMSR")
 ; Get default units
DEFUNIT(VCTL,VUNT) ;
 N UNIT
 D GETPAR^CIAVMRPC(.UNIT,"BEHOVM DEFAULT UNITS",,"`"_VCTL)
 ;S UNIT=$$GET^XPAR("ALL","BEHOVM DEFAULT UNITS","`"_VCTL)
 I UNIT="" D
 .D:$G(VUNT)="" TYPEINFO(VCTL,,,.VUNT)
 .S UNIT=VUNT
 Q UNIT
 ; Get vital list
 ;   PRM = Name of parameter containing vital list
 ;   LOC = Optional hosp location IEN
VLIST(DATA,PRM,LOC) ;
 N ENT
 S ENT=$$ENT^CIAVMRPC(PRM)
 ;S ENT=$S($G(LOC)>0:"ALL^LOC.`"_LOC,1:"ALL")
 D GETLST^XPAR(.DATA,ENT,PRM,"I")
 Q
 ; Return units+normal range
 ;  .VUNT = Returned unit values as:
 ;     VUNT    = Default system (0=US, 1=Metric)
 ;     VUNT(0) = US unit^LO^HI
 ;     VUNT(1) = Metric unit^LO^HI
 ;  Return value = US unit^LO^HI^Metric unit^LO^HI
UNITS(VUNT) ;
 N LO,HI,X
 I 'VCTL S VUNT=0,(VUNT(0),VUNT(1))="^^"
 E  D
 .S X=^BEHOVM(90460.01,VCTL,0),VUNT=+$P(X,U,2),LO=$P(X,U,5),HI=$P(X,U,6)
 .S VUNT(VUNT)=$P(X,U,3+VUNT)_U_LO_U_HI
 .S VUNT('VUNT)=$P(X,U,4-VUNT)
 .I '$L(VUNT('VUNT)) S VUNT('VUNT)=VUNT(VUNT)
 .E  S VUNT('VUNT)=VUNT('VUNT)_U_$$CONVERT(LO,VUNT)_U_$$CONVERT(HI,VUNT)
 Q:$Q VUNT(0)_U_VUNT(1)
 Q
 ; RPC: Return help text for vital type
HELP(DATA,VCTL) ;EP
 M DATA=^BEHOVM(90460.01,VCTL,99)
 K DATA(0)
 S:$D(DATA)'>1 DATA(1)="No help is available for this item."
 Q
 ; RPC: Return percentile values
PCTILE(DATA,VCTL,DFN,START,END,METRIC) ;EP
 N I,X,DOB,SEX,AGE,L,M,S,P,D,Z,ID,V,C
 S METRIC=+$G(METRIC),X=$G(^DPT(+DFN,0)),SEX=$P(X,U,2),DOB=$P(X,U,3)
 Q:'$L(SEX)!'DOB
 S:METRIC<0 METRIC=$$DEFUNIT(VCTL)
 S START=$$FMDIFF^XLFDT(START,DOB)/30-1
 S END=$$FMDIFF^XLFDT(END,DOB)/30+1
 S (I,C)=0
 F  S I=$O(^BEHOVM(90460.01,VCTL,3,I)) Q:'I  S X=^(I,0) D
 .S AGE=+$P(X,";",2)
 .Q:AGE<START!(AGE>END)!($P(X,";")'=SEX)
 .S L=$P(X,";",3),M=$P(X,";",4),S=$P(X,";",5),D=$$FMADD^XLFDT(DOB,AGE*30)
 .F P=2:1:8 D
 ..S ID=$P("3^5^10^25^50^75^90^95^97",U,P)
 ..S Z=$P("-1.881^-1.645^-1.282^-0.674^0^0.674^1.036^1.282^1.645^1.881",U,P)
 ..I L S V=L*S*Z+1**(1/L)*M
 ..E  S V=2.71828183**(S*Z)*M
 ..S C=C+1,@DATA@(C)=ID_U_D_U_$S(METRIC:V,1:$$CONVERT(V,1,0))
 Q
 ; Round value to specified # fractional digits
ROUND(VAL,SD) ;
 Q:VAL'=+VAL!($G(SD)=0) VAL
 Q +$J(VAL,0,$S($D(SD):SD,VAL<1:2,VAL<10:2,1:2))
 ; Convert between metric and US
CONVERT(X,TOUS,SD) ;
 Q:'VCTL!'$L(X) ""
 X $G(^BEHOVM(90460.01,VCTL,$S(TOUS:2,1:1)))
 S X=$$ROUND(X,.SD)
 Q X
 ; Convert ff'ii" to inches
CVTFTIN(X) ;
 N F,I
 I X'["'",X'["""" Q X
 S X=$TR(X," ")
 I X["'" S F=$P(X,"'"),I=$P(X,"'",2,99) Q:F'=+F X
 E  S F=0,I=X
 I $L(I) Q:$E(I,$L(I))'="""" X S I=$E(I,1,$L(I)-1) Q:I'=+I X
 Q F*12+I_"IN"
 ; Valid blood pressure
VALIDBP(VAL,SLO,SHI,DLO,DHI) ;EP
 N SBP,DBP
 I VAL'?1.N1"/"1.N S VAL="-1^Format must be <systolic>/<diastolic>." Q
 S SBP=+$P(VAL,"/"),DBP=+$P(VAL,"/",2)
 D VALIDNUM(.SBP,SLO,SHI)
 I SBP[U S VAL="-1^Systolic pressure "_$P(SBP," ",2,999) Q
 D VALIDNUM(.DBP,DLO,DHI)
 I DBP[U S VAL="-1^Diastolic pressure "_$P(DBP," ",2,999) Q
 I SBP'>DBP S VAL="-1^Systolic BP<Diastolic BP" Q
 S VAL=SBP_"/"_DBP
 Q
 ; Validate integer value
VALIDINT(VAL,LO,HI,INC) ;EP
 I VAL\1'=VAL S VAL="-1^Input must be an integer value." Q
 D VALIDNUM(.VAL,LO,HI)
 I $G(INC),VAL'[U,VAL#INC S VAL="-1^Input must be in increments of "_INC_"."
 Q
 ; Validate numeric value
VALIDNUM(VAL,LO,HI) ;EP
 I VAL'=+VAL S VAL="-1^Input must be a numeric value."
 E  I VAL<LO!(VAL>HI) D
 .N UNT
 .I VUNT'=METRIC S LO=$$CONVERT(LO,VUNT),HI=$$CONVERT(HI,VUNT),UNT=VUNT('VUNT)
 .E  S UNT=VUNT(VUNT)
 .S VAL="-1^Input must be between "_LO_" and "_HI_" "_$P(UNT,U)_"."
 Q
 ; Validate tonometric value
VALIDTON(VAL) ;EP
 N LV,RV
 S VAL=$$UP^XLFSTR(VAL)
 I $L(VAL,"/")>2 S VAL=-1
 E  D
 .S RV=$P(VAL,"/"),LV=$P(VAL,"/",2),VAL=""
 .I $E(RV)="L" D  Q:VAL
 ..I LV="" S LV=RV,RV=""
 ..E  S VAL=-1
 .D VT1(.RV,"R"),VT1(.LV,"L")
 I VAL S:VAL'[U $P(VAL,U,2)="Invalid input format."
 E  S VAL=RV_$S($L(LV):"/",1:"")_LV
 Q
VT1(TON,PFX) ;
 S:$E(TON)=PFX TON=$E(TON,2,999)
 Q:'$L(TON)
 I $TR(TON,"0123456789")'="" S VAL=-1
 E  D
 .S TON=+TON
 .I TON>80 S VAL="-1^Value must be between 0 and 80, inclusive."
 .E  S TON=PFX_TON
 Q
 ; RPC: Validate value X for measurement type VCTL
 ; Returns normalized value in DATA if valid, or -1^error if not
VALIDATE(DATA,VCTL,METRIC,X) ;EP
 N VABR,VUNT,VMSR,LP,UNIT
 D TYPEINFO(.VCTL,,,.VUNT)
 S X=$$UP^XLFSTR($$TRIM^XLFSTR(X)),METRIC=$G(METRIC,-1),METRIC=$S(METRIC<0:$$DEFUNIT(VCTL,VUNT),METRIC>0:1,1:0),UNIT=-1
 S X=$$CVTFTIN(X)
 F LP=VUNT,1-VUNT D  Q:UNIT>-1
 .N Y,Z
 .S Y=$$UP^XLFSTR($P(VUNT(LP),U))
 .F Z=1:1:$L(Y) D  Q:UNIT>-1
 ..S:$E(X,$L(X)-Z+1,99)=$E(Y,1,Z) UNIT=LP,X=$$TRIM^XLFSTR($E(X,1,$L(X)-Z))
 S:UNIT<0 UNIT=METRIC
 S:UNIT'=VUNT X=$$CONVERT(X,UNIT,0),UNIT=VUNT
 X $G(^BEHOVM(90460.01,VCTL,4))
 S:$G(X)="" X="-1^Invalid entry.  Try again."
 I X'[U,UNIT'=METRIC S X=$$CONVERT(X,UNIT,2)
 S DATA=X
 Q
 ; Normalize value for storage
NORM(VTYP,VAL,UNT,VMSR) ;EP
 N VCTL,VUNT
 S:'$D(VMSR) VMSR=$$VMSR
 S VCTL=$S(VTYP=+VTYP:$$TYP2CTL(VTYP,VMSR),1:VTYP)
 D TYPEINFO(.VCTL,,,.VUNT,VMSR,.VTYP)
 Q:'VCTL!'VTYP "-1^Unrecognized measurement type."
 Q:VAL=" " 0
 D VALIDATE(.VAL,VCTL,VUNT,VAL_UNT)
 Q:VAL[U VAL
 S UNT=$P(VUNT(VUNT),U)
 Q 0
 ; RPC: Store vitals data
SAVE(DATA,DFN,VITS) ;EP
 N VMSR,LP,VCNT
 S VMSR=$$VMSR,LP="",VCNT=0
 F  S LP=$O(VITS(LP)) Q:'LP  D
 .N VTYP,VAL,UNT,DEL,X
 .S VITS=VITS(LP)
 .Q:$E(VITS,1,3)'="VIT"
 .S DEL=$P(VITS,U)["-",VTYP=$P(VITS,U,2)
 .S VAL=$S(DEL:" ",1:$P(VITS,U,5)),UNT=$S(DEL:"",1:$P(VITS,U,7))
 .I $$NORM(.VTYP,.VAL,.UNT,VMSR) S VCNT=VCNT+1
 .E  S $P(VITS,U,2)=VTYP,$P(VITS,U,5)=VAL,$P(VITS,U,7)=UNT,VITS(LP)=VITS
 I VCNT S DATA="-1^"_$$SNGPLR^CIAU(VCNT," entry"," entries")_" failed validation.  No results stored."
 E  D SAVE^BEHOENPC(.DATA,.VITS)
 Q
 ; Add to output global
ADD(TXT,LBL,SUB) ;
 S CNT=CNT+1,@DATA@($G(SUB,0),CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_$G(TXT),LBL=""
 Q
