BPXRMIMF ; IHS/CIA/MGH - Handle measurement findings. ;03-Mar-2006 17:48;MGH
 ;;1.5;CLINICAL REMINDERS;**1002,1004**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to check and see if the forecaster has
 ;already run for this patient.  If it has run, the data is current.
 ;If it hasn't run the forecaster is called to update the data
 ;=====================================================================
CHECK(DFN,TEST,DATE,VALUE,TEXT) ;
 ;Check if forecaster already has already run
 N X,Y,TODAY,BIERR
 S X="TODAY" D ^%DT S TODAY=Y
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
