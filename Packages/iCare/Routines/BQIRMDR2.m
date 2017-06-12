BQIRMDR2 ;GDHS/HCD/ALA-Forecaster Reminders ; 05 Feb 2016  3:28 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
 ;
IFR ; EP - Immunization Forecaster
 D PTLS^BQIRMIZ
 NEW RCAT,RCLIN,IN,IMM,TEXT,CODE,HDR,RIEN
 S RCAT="IZ Forecaster",RCLIN="Immunizations"
 I $G(SOURCE)="" S SOURCE="Reminders"
 S IMN=0
 F  S IMN=$O(^BIPDUE(IMN)) Q:'IMN  D
 . S IMM=$P(^BIPDUE(IMN,0),"^",2)
 . ; if forecast was not updated with active patients logic in PTLS, quit
 . I $P(^BIPDUE(IMN,0),"^",6)<DT Q
 . ; If not enabled for forecaster, quit
 . I $P(^BITN(IMM,0),U,16)=1 Q
 . S TEXT=$P(^BITN(IMM,0),U,2)
 . S CODE="IZ_"_TEXT
 . S HDR="T00050"_CODE
 . S RIEN="",RIEN=$O(^BQI(90506.1,"B",CODE,RIEN))
 . I RIEN'="" D  Q
 .. I $P(^BQI(90506.1,RIEN,0),"^",10)="" Q
 .. D REA^BQIRMDR1
 . D FILE^BQIRMDR
 Q
 ;
IZ(DFN) ;EP
 NEW VALUE,FRN,IMN,RCDUE,OVDUE
 S FRN=""
 F  S FRN=$O(^BIPDUE("B",DFN,FRN)) Q:FRN=""  D
 . S (REMDUE,REMLAST,REMNEXT)=""
 . S IMN=$P($G(^BIPDUE(FRN,0)),"^",2) I IMN="" Q
 . S RCDUE=$P(^BIPDUE(FRN,0),"^",4),OVDUE=$P(^(0),"^",5)
 . S REMDUE=$S(RCDUE'="":RCDUE,1:OVDUE)
 . S REMLAST=$$LIMM^BQIREM(DFN,IMN) I REMLAST'="" S REMLAST=$P(REMLAST,"^",1)
 . S CODE="IZ_"_$P(^BITN(IMN,0),U,2)
 . D FIL^BQIRMDR
 Q
