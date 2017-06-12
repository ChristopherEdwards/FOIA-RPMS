BPXRMIMF ; IHS/MSC/MGH - Handle immunization forecaster. ;18-Apr-2014 15:21;DU
 ;;2.0;CLINICAL REMINDERS;**1001,1002**;Feb 04, 2005;Build 15
 ;=================================================================
 ;This routine is designed to check and see if the forecaster has
 ;already run for this patient.  If it has run, the data is current.
 ;If it hasn't run the forecaster is called to update the data
 ;=====================================================================
CHECK(DFN,TEST,DATE,VALUE,TEXT) ;
 ;Check if forecaster already has already run
 N X,Y,TODAY,BIERR
 S TODAY=$$DT^XLFDT()
 I $D(^XTMP("BIPDUE",DFN)) D
 .I $G(^XTMP("BIPDUR",DFN))'=TODAY D RUN
 I '$D(^XTMP("BIPDUE",DFN)) D RUN
 Q
RUN ;Run the forecaster
 I '$$FORECAS^BIUTL2(DUZ(2)) S TEST=1,VALUE="Forecasting not enabled",DATE=TODAY Q
 D UPDATE^BIPATUP(DFN,DT,.BIERR,1)
 I BIERR'="" S TEST=1,VALUE="Error on running forecaster",DATE=TODAY
 E  S TEST=1,DATE=TODAY,VALUE="Immunization due"
 Q
