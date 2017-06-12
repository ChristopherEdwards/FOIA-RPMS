BTIUSTSC ; IHS/MSC/JS - V STROKE SCALE OBJECT ;17-Nov-2014 15:54;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1012,1013**;MAR 20, 2013;Build 33
 ;
 Q
 ;
STSCALE(DFN,TARGET,VIEN,STCNT) ; EHR p12
 ; -- get patient visit --
 NEW VST
 S STCNT=$G(STCNT)
 I $G(VIEN)'="" G SCALE
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 I VST<1 Q " "
 S VIEN=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 ;S VIEN=$P(VST,";",4)
 I $G(VIEN)="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;
SCALE ; -- check V STROKE file #9000010.63 for NIH records and not EIE --
 NEW STRIEN,CNT,FNUM,VSTRARR,VSTRERR
 S STRIEN=""
 S CNT=0
 F  S STRIEN=$O(^AUPNVSTR("AD",VIEN,STRIEN)) Q:STRIEN=""  D
 .I '$D(^AUPNVSTR(STRIEN)) Q  ; broken record
 .I '$D(^AUPNVSTR(STRIEN,15)) Q  ; NIH not filed
 .I $P($G(^AUPNVSTR(STRIEN,5)),U,1) Q  ; EIE
 .D GETS
 Q "~@"_$NA(@TARGET)
 ;
GETS ; -- check/retrieve file entry --
 S FNUM=$$FNUM
 I FNUM=0 S @TARGET@(1,0)="Server error: "_$G(FILERR("DIERR",1))_U_$G(FILERR("DIERR",1,"TEXT",1)) K FILERR Q "~@"_$NA(@TARGET)
 ;K @TARGET  <<<<<<<<<<<<<<<<<<<<  10/11/13
 K VSTRARR,VSTRERR
 D GETS^DIQ(FNUM,STRIEN_",","**","IE","VSTRARR","VSTRERR") ;  retrieve file entry data
 I $D(VSTRERR) D   Q "~@"_$NA(@TARGET)
 .S @TARGET@(1,0)="Server error: "_$G(VSTRERR("DIERR",1))_U_$G(VSTRERR("DIERR",1,"TEXT",1))
 ;
 NEW WT
 D WEIGHT(VIEN)
 ;
 D PRINT(STRIEN,.STCNT)
 I CNT=0 S @TARGET@(1,0)="No V STROKE entry for patient visit"
 Q
 ; -- print the V Stroke entry data --
PRINT(STRIEN,STCNT) ;
 NEW SPACE,ARRIVED,PATNAME,HANDED,FIBINIT,VCNT,FIBNOT
 S $P(SPACE," ",1)=""
 S ARRIVED=$G(VSTRARR(FNUM,STRIEN_",",".01","E")) ;.01       ARRIVAL DATE/TIME (RD), [0;1]
 S PATNAME=$G(VSTRARR(FNUM,STRIEN_",",".02","E")) ;.02       PATIENT NAME (RP9000001'I), [0;2]
 S HANDED=$G(VSTRARR(FNUM,STRIEN_",",".04","E")) ; .04       HANDEDNESS (F), [0;4]
 S FIBINIT=$G(VSTRARR(FNUM,STRIEN_",",".11","E")) ;.11       FIBRINOLYTIC THERAPY INITIATED (D), [0;11]
 S FIBNOT=$G(VSTRARR(FNUM,STRIEN_",",".14","E"))  ;.14       FIBRINOLYTIC THERAPY NOT INITIATED
 S CNT=CNT+1
 S @TARGET@(CNT,0)="--- NIH Stroke Score(s) ---"
 S CNT=CNT+1
 I FIBINIT'="" S @TARGET@(CNT,0)="Fibrinolytic therapy started at: "_$G(FIBINIT)
 I FIBNOT'="" S @TARGET@(CNT,0)="Fibrinolytic therapy not intiated at: "_$G(FIBNOT)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Handedness: "_$G(HANDED)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Weight:     "_$G(WT)
 S CNT=CNT+1
 S @TARGET@(CNT,0)=SPACE
 D NIH
 Q
 ;
 ;NIH STROKE SCALE #9000010.6315 -- NIH STROKE SCALE SUB-FILE FIELD #1500
NIH ;
 NEW STRING,NODE,STIME,SSTIME,SPACE,QUIT,BY
 S QUIT=0
 S STRING="",NODE=""
 S $P(SPACE," ",1)=""
 F  S NODE=$O(VSTRARR(9000010.6315,NODE)) Q:'+NODE!(QUIT=1)  D
 . I STCNT'="" S STCNT=STCNT-1 I STCNT=0 S QUIT=1
 . S STIME=$G(VSTRARR(9000010.6315,NODE,".02","E")) ;  >>>  .02  EVENT DATE/TIME (D), [0;2]
 . S BY=$G(VSTRARR(9000010.6315,NODE,".03","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)=""
 . S @TARGET@(CNT,0)="NIH Stroke Score at: "_STIME_" by "_BY
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".04","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="     Level of Consciousness: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".05","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="              LOC Questions: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".06","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="               LOC Commands: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".07","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                2 Best Gaze: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".08","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                     Visual: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".09","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="               Facial Palsy: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".1","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="             Motor Arm Left: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".11","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="            Motor Arm Right: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".12","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="             Motor Left Leg: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".13","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="            Motor Right Leg: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".14","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                Limb Ataxia: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".15","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                    Sensory: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".16","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="              Best Language: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".17","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                 Dysarthria: "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".18","E"))
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="   Extinction & Inattention: "_$G(STRING)
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)="                            _______"
 . S CNT=CNT+1
 . S STRING=$G(VSTRARR(9000010.6315,NODE,".19","E")) ;          .19  TOTAL STROKE SCORE (NJ2,0), [0;19]
 . S @TARGET@(CNT,0)="              * TOTAL SCORE: "_$G(STRING)
 . S CNT=CNT_1
 . S @TARGET@(CNT,0)=SPACE
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"1.01","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Motor arm left comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"1.02","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Motor arm right comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"2.01","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Motor leg left comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"2.02","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Motor leg right comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"3.01","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Limb ataxia comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S STRING=$G(VSTRARR(9000010.6315,NODE,"3.02","E"))
 . I $G(STRING)]"" D
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="Dysarthia comment: "
 .. S CNT=CNT+1
 .. S @TARGET@(CNT,0)="  "_$G(STRING)
 . S CNT=CNT+1
 . S @TARGET@(CNT,0)=SPACE
 Q
 ;
 ; -- find patient weight from visit or default to last filed weight in V Measurement file --
WEIGHT(VIEN) ; -- from routine BTIULO4 --
 NEW MIEN,QUALIF
 S WT=0
 S MIEN=0 F  S MIEN=$O(^AUPNVMSR("AD",VIEN,MIEN)) Q:'MIEN  D
 . K TIU D ENP^XBDIQ1(9000010.01,MIEN,".01;.04;2;1201","TIU(","I")
 . I TIU(.01)="WT" I TIU(2,"I")'=1     ;SKIP ENTERED IN ERROR VITALS
 . S QUALIF=$$QUAL^BTIULO7A(MIEN)
 . I TIU(.01)="WT" D
 . . S TIU(.04)=$J(TIU(.04),5,2)_" ("_$J((TIU(.04)*.454),5,2)_" kg)"
 . . I QUALIF="" S WT=$$NAME(TIU(.01,"I"))_": "_TIU(.04)_$$LSTDATE^BTIUPCC1(VIEN,TIU(1201,"I"),1)
 . . I QUALIF'="" S WT=$$NAME(TIU(.01,"I"))_": "_TIU(.04)_$$LSTDATE^BTIUPCC1(VIEN,TIU(1201,"I"),1)_" Qualifiers: "_QUALIF
 . . Q
 . Q
 K TIU
 S:WT=0 WT=$$LASTMSR^BTIUPCC1(+$G(DFN),"WT",1,1)
 Q
 ;
NAME(X) ;return full name for measurement
 Q $$GET1^DIQ(9999999.07,X,.02)
 ;
 ; -- V STROKE file number --
FNUM() ; returns 0/invalid file ref number, 9000010.63/valid file ref number
 NEW FILEN,ATTRIB,TAROOT,MSGROOT,FILEINFO
 S FILEN=9000010.63,ATTRIB="NAME;GLOBAL NAME",TAROOT="FILEINFO",MSGROOT="FILERR"
 D FILE^DID(FILEN,,ATTRIB,TAROOT,MSGROOT)
 I $D(FILERR) Q 0
 Q 9000010.63
