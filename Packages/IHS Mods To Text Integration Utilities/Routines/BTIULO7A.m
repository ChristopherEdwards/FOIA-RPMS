BTIULO7A ;IHS/ITSC/LJF - IHS OBJECTS ADDED IN PATCHES;22-Apr-2015 17:07;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1012,1013**;NOV 04, 2004;Build 33
OLD(DFN,TARGET,MODE) ;Old objects
 S X=$$GET1^DIQ(9000017,+$G(DFN),1)
 I X]"" D
 .S GRAV=$P(X,"P",1),OTHER=$P(X,"P",2)
 .S PARA=$P(OTHER,"LC",1),OTHER=$P(OTHER,"LC",2)
 .S LC=$P(OTHER,"SA",1),OTHER=$P(OTHER,"SA",2)
 .S SA=$P(OTHER,"TA",1),OTHER=$P(OTHER,"TA",2)
 .S TA=OTHER
 .S X=GRAV_" P"_PARA_" LC"_LC_" SA"_SA_" TA"_TA
 I (MODE="B")!(X="") Q "R HX: "_$S(X="":"None Recorded",1:X)
 S @TARGET@(1,0)="R HX: "_X_" (recorded on "_$$GET1^DIQ(9000017,+$G(DFN),1.1)_")"
 Q "~@"_$NA(@TARGET)
 ;
FPM(DFN,TARGET,MODE) ;EP; CONTRACEPTION-BRIEF object
 ;MODE="B" or "E"
 NEW X,FPBEGIN,FPDATE,BHX,TYP,START,END,CNT,LINE,LIN1,BHC
 K @TARGET
 S CNT=0
 I $P(^DPT(DFN,0),U,2)="M" Q "Patient is male"
 S BHX=0 F  S BHX=$O(^AUPNREP(DFN,2101,BHX)) Q:BHX'=+BHX  D
 .Q:$D(^AUPNREP(DFN,2101,BHX,1))>0
 .S BHC=$P(^AUPNREP(DFN,2101,BHX,0),U,1) I BHC D
 ..S TYP=$P(^AUTTCM(BHC,0),U)
 ..S START=$P(^AUPNREP(DFN,2101,BHX,0),U,2) I START]"" S START=$$FIXDT^BHSFAM1(START)
 ..S END=$P(^AUPNREP(DFN,2101,BHX,0),U,3) I END]"" S END=$$FIXDT^BHSFAM1(END)
 ..I CNT=0 D
 ...S CNT=CNT+1 S @TARGET@(CNT,0)=""
 ...S CNT=CNT+1 S @TARGET@(CNT,0)="FP METHOD: "
 ..S LINE=$S(TYP="":"None Recorded",1:TYP)
 ..I MODE="B"&(END="") D
 ...S CNT=CNT+1
 ...S LINE="   "_LINE_" Start Dt: "_START
 ...S @TARGET@(CNT,0)=LINE
 ..I MODE="E" D
 ...S CNT=CNT+1
 ...S LINE="   "_LINE_" Start Dt: "_START
 ...S @TARGET@(CNT,0)=LINE
 ...I END'="" D
 ....S CNT=CNT+1
 ....S LIN1=""
 ....I $P(^AUPNREP(DFN,2101,BHX,0),U,5)]"" S LIN1=" Reason Discontinued: "_$P(^AUPNREP(DFN,2101,BHX,0),U,5)
 ....S @TARGET@(CNT,0)="             End Dt: "_END_LIN1
 Q "~@"_$NA(@TARGET)
 ;
TODAYVIT(PAT) ;EP; returns all vitals taken today
 NEW MEAS,VST,VDT,END,APCLV,ERR,TYPE,VALUE,VDATE
 ;
 ; for each visit patient had today, find all measurements taken
 S VDT=9999999-DT,END=VDT_".2359"
 F  S VDT=$O(^AUPNVSIT("AA",PAT,VDT)) Q:'VDT!(VDT>END)  D
 . S VST=$O(^AUPNVSIT("AA",PAT,VDT,0)) Q:'VST
 . S ERR=$$PCCVF^APCLV(VST,"MEASUREMENT","7;8") I ERR Q
 . S X=0 F  S X=$O(APCLV(X)) Q:'X  D
 . . S MEAS($P(APCLV(X),U),VDT)=$P(APCLV(X),U,2)
 ;
 ; loop through all measurements found for patient and date; pick most recent ones
 S RESULT=""
 S TYPE=0 F  S TYPE=$O(MEAS(TYPE)) Q:TYPE=""  D
 . S VDATE=$O(MEAS(TYPE,""),-1)                      ;get latest date/time
 . S VALUE=MEAS(TYPE,VDATE)                          ;get value for this measurement & date/time
 . I TYPE="WT" S VALUE=$J(VALUE,5,2)_" ("_$J((VALUE*.454),5,2)_" kg)"
 . I ((TYPE="HT")!(TYPE="HC")!(TYPE="WC")!(TYPE="AG")) S VALUE=$J(VALUE,5,2)_" ("_$J((VALUE*2.54),5,2)_" cm)"
 . I TYPE="TMP" S VALUE=VALUE_" ("_(((10*((VALUE-32)/1.8))\1)/10)_" C)"
 . I TYPE="BMI" D
 . .S VALUE=$J(VALUE,5,2)
 . .I $$PNM^APCLSIL1(DFN,DT)="Y" S VALUE=VALUE_"*"
 . S RESULT=RESULT_TYPE_":"_VALUE_", "
 S RESULT=$E(RESULT,1,$L(RESULT)-2)   ;remove last comma
 Q RESULT
 ;
TODAYLAB(PAT) ;EP; returns all labs taken today;PATCH 1002 new code
 NEW VDT,END,VISIT,COUNT,TIUX,LINE,TIUA
 K ^TMP("BTIULO",$J)
 ;
 ; for each visit patient had today, find all labs
 S VDT=9999999-DT,END=VDT_".2359"
 F  S VDT=$O(^AUPNVSIT("AA",PAT,VDT)) Q:'VDT  Q:VDT>END  D
 . S VISIT=0 F  S VISIT=$O(^AUPNVSIT("AA",PAT,VDT,VISIT)) Q:'VISIT  D
 . . S TIUX=0,LINE="" F  S TIUX=$O(^AUPNVLAB("AD",VISIT,TIUX)) Q:'TIUX  D
 . . . K TIUA D ENP^XBDIQ1(9000010.09,TIUX,".01;.04;.05;1109","TIUA(")
 . . . I TIUA(.04)="",TIUA(1109)="RESULTED" Q
 . . . S LINE="  "_$$PAD^BTIULO7(TIUA(.01),25)_"  "       ;lab test
 . . . S LINE=LINE_$$PAD^BTIULO7(TIUA(.04),10)_TIUA(.05)  ;result
 . . . I TIUA(.04)="" S LINE=LINE_TIUA(1109)
 . . . S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ;
 I '$D(^TMP("BTIULO",$J)) Q "No Labs Found for Today"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
TODAYMED(PAT,SIG) ;EP; returns all meds dispensed today;PATCH 1002 new code
 ; If SIG=1 include sig
 NEW VDT,END,VISIT,COUNT,RESULT,I
 K ^TMP("BTIULO",$J)
 ;
 ; for each visit patient had today, find all meds
 S VDT=9999999-DT,END=VDT_".2359"
 F  S VDT=$O(^AUPNVSIT("AA",PAT,VDT)) Q:'VDT  Q:VDT>END  D
 . S VISIT=0 F  S VISIT=$O(^AUPNVSIT("AA",PAT,VDT,VISIT)) Q:'VISIT  D
 . . K RESULT
 . . I $G(SIG) D GETSIG^BTIULO5(.RESULT,VISIT) I 1
 . . E  D GETMED^BTIULO5(.RESULT,VISIT)
 . . ;
 . . S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 . . . S COUNT=$G(COUNT)+1
 . . . S ^TMP("BTIULO",$J,COUNT,0)=RESULT(I)
 ;
 I '$D(^TMP("BTIULO",$J)) Q "No Medications Found for Today"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
QUAL(MEAS) ; Get qualifiers for a measurement
 N QUALS,QUALN,QUALIF,TYPE,TNAME,O2
 S (QUALIF,O2)=""
 S TYPE=$P($G(^AUPNVMSR(MEAS,0)),U,1)
 S TNAME=$P($G(^AUTTMSR(TYPE,0)),U,1)
 S QUALS=0 F  S QUALS=$O(^AUPNVMSR(MEAS,5,QUALS)) Q:QUALS=""  D
 .S QUALN=$P($G(^AUPNVMSR(MEAS,5,QUALS,0)),U,1)
 .I +QUALN S QUALN=$P($G(^GMRD(120.52,QUALN,0)),U,1)
 .I QUALIF="" S QUALIF=QUALN
 .E  I QUALN'="" S QUALIF=QUALIF_","_QUALN
 I TNAME="O2" D
 .S O2=$P($G(^AUPNVMSR(MEAS,0)),U,10)
 .S QUALIF=QUALIF_" "_O2
 Q QUALIF
