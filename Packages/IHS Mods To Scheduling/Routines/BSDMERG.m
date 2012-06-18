BSDMERG ; IHS/ANMC/LJF - SCHED PATIENT MERGE ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;  ^SC(clinic,"S",appointment date/time,1,index,0)="patient^..." 
 ;  ^SC(clinic,"C",chart request date,1,index,0)="patient"
 ;  ^DPT(patient,"S",appointment date/time,0)="clinic^..."
 ;
 ;            dfn=patient, c=clinic, i=index
 ;          v=appointment date/time FM internal
 ;
 ;
 I '$G(XDRMRG("FR")),'$G(XDRMRG("TO")) Q
 ;
 ; -- update patient pointer in 44 
 NEW DFN,DATE,CLN,I,NODE
 S DFN=XDRMRG("FR"),DATE=0
 F  S DATE=$O(^DPT(DFN,"S",DATE)) Q:'DATE  D    ;find from pat's appts
 . S CLN=+$G(^DPT(DFN,"S",DATE,0)) Q:'CLN       ;get clinic
 . S I=0
 . F  S I=$O(^SC(CLN,"S",DATE,1,I)) Q:'I  D     ;find appt under clinic
 .. S NODE=$G(^SC(CLN,"S",DATE,1,I,0)) Q:'NODE
 .. Q:+NODE'=DFN                                  ;quit if not this pat
 .. S $P(^SC(CLN,"S",DATE,1,I,0),U)=XDRMRG("TO")  ;reset to "to" pat
 ;
 ; -- check all chart request nodes for from patient
 S CLN=0
 F  S CLN=$O(^SC(CLN)) Q:'CLN  D
 . S DATE=0 F  S DATE=$O(^SC(CLN,"C",DATE)) Q:'DATE  D
 .. S I=0 F  S I=$O(^SC(CLN,"C",DATE,1,I)) Q:'I  D
 ... I +$G(^SC(CLN,"C",DATE,1,I,0))=DFN S ^SC(CLN,"C",DATE,1,I,0)=XDRMRG("TO")
 ;
 Q
 ;
