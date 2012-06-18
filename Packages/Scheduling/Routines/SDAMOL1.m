SDAMOL1 ;ALB/CAW - Retroactive Appointment List (con't);4/15/92
 ;;5.3;Scheduling;**132**;Aug 13, 1993
 ;
 ;
MAIN ; main sort, by division
 N SDTMP,SDX
 K ^TMP("SDRL",$J),^TMP("SDRAL",$J)
 ;
 ; -- get list of database close out dates
 S SDTMP=SDBEG
 F  D  S SDTMP=$$NEXTDT(SDTMP) Q:SDTMP>SDEND
 . S SDX=$P($$CLOSEOUT^SCDXFU04(SDTMP),U,SDNPDB)
 . IF SDX'=-1 S ^TMP("SDRL",$J,SDTMP)=SDX
 ;
 D SCAN
 D BLD^SDAMOLP
 ;
MAINQ ; -- exit logic
 K SDDV,SDSC,SDCLK,SDCLNM,SDCN,SDCNT,SDAD,SDATA,SDDFN,SDCLIN
 K SDCLINIC,SDCLC,SDASH,SDCSC,SDDIV,SDDATE,SDAPPT,SDFLEN,SDFLG
 K SDPAT,SDPAGE,SDSLEN,SDFST,SDROU,SDSEC,SDSTOP,SDSTPC,SDSTPCDE
 K SDTYPE,SDVISIT,SDWHEN,SDVDT,SDVST,SDVSTDT,SDY,SDTRANS,SDTMP
 K VA,VAERR,X,^TMP("SDRAL",$J)
 Q
 ;
SCAN ; -- api to invoke scan
 ;
 ; -- send message to task manager and check for stop request
 IF $$S^%ZTLOAD("Searching for Retroactive Encounters...") S ZTSTOP=1 G SCANQ
 N SDCB,SDQID
 S SDCB="D CB^SDAMOL1(.Y,.Y0,.SDSTOP)"
 D OPEN^SDQ(.SDQID)
 D ACTIVE^SDQ(.SDQID,"FALSE","SET")
 D INDEX^SDQ(.SDQID,"DATE/TIME","SET")
 D DATE^SDQ(.SDQID,SDBEG,SDEND,"SET")
 D SCANCB^SDQ(.SDQID,SDCB,"SET")
 D ACTIVE^SDQ(.SDQID,"TRUE","SET")
 D SCAN^SDQ(.SDQID,"FORWARD")
 D CLOSE^SDQ(.SDQID)
SCANQ Q
 ;
 ;
CB(SDOE,SDOE0,SDSTOP) ; -- main callback
 N SDVISIT,SDVSTDT,SDPAT,SDSC,SDCL,SDOEP,SDORG,SDEXT,SDDIV,SDOEU
 N SDCLK,SDWHEN,SDCLNM,SDSTPCDE,SDTYPE,SDVSIT,SDCODT,SDSTATUS
 ;
 ; -- has user asked to stop job ; if yes, kill data & quit
 IF $$S^%ZTLOAD() D  G CBQ
 . S (SDSTOP,ZTSTOP)=1
 . K ^TMP("SDRAL",$J)
 ;
 ; -- set up variables for data fields
 S SDVISIT=SDOE
 S SDVSTDT=+SDOE0
 S SDPAT=+$P(SDOE0,U,2)
 S SDSC=+$P(SDOE0,U,3)
 S SDCL=+$P(SDOE0,U,4)
 S SDVSIT=+$P(SDOE0,U,5)
 S SDOEP=+$P(SDOE0,U,6)
 S SDCODT=+$P(SDOE0,U,7)
 S SDORG=+$P(SDOE0,U,8)
 S SDEXT=+$P(SDOE0,U,9)
 S SDDIV=+$P(SDOE0,U,11)
 S SDSTATUS=+$P(SDOE0,U,12)
 S SDOEU=$G(^SCE(SDOE,"USER"))
 S SDCLK=+SDOEU
 S SDWHEN=+$P(SDOEU,U,4)
 ;
 ; -- drived data
 IF 'SDWHEN,SDORG=1 S SDWHEN=+$P($G(^SC(SDCL,"S",SDVSTDT,1,SDEXT,0)),U,7)
 IF 'SDWHEN S SDWHEN=+$P($G(^AUPNVSIT(SDVSIT,0)),U,2)
 S SDCLNM=$P($G(^SC(SDCL,0),0),U)
 S SDSTPCDE=+$P($G(^DIC(40.7,SDSC,0)),U,2)
 S SDTYPE=$S(SDORG=1:"APPOINTMENT",SDORG=2:"STANDALONE",SDORG=3:"DISPOSITION",1:"UNKNOWN")
 ;
 ; -- quit if encounter has parent
 IF SDOEP G CBQ
 ;
 ; -- quit if no 'created' date found
 IF 'SDWHEN G CBQ
 ;
 ; -- quit if 'created' before close out date
 IF '$$TMP(+SDOE0,SDWHEN) G CBQ
 ;
 ; -- quit if no checked out completion date/time
 IF 'SDCODT G CBQ
 ;
 ; -- quit if not status is not 'checked out'
 IF SDSTATUS'=2 G CBQ
 ;
 ; -- quit if division or clinic or stop code not valid for report
 IF '$$DIV() G CBQ
 IF '$$CLINIC() G CBQ
 IF '$$STOP() G CBQ
 ;
 D SET
CBQ Q
 ;
 ;
NEXTDT(X1) ; -- get next date
 N X2
 S X2=1 D C^%DTC
 Q X
 ;
SET ;^TMP("SDRAL",$J,Division,Stop Code,Visit Date,Patient)
 ;
 S ^TMP("SDRAL",$J,SDDIV,SDSTPCDE,SDVSTDT,SDPAT)=SDVISIT_U_SDWHEN_U_SDCLK_U_SDTYPE_U_^TMP("SDRL",$J,$P(SDVSTDT,"."))_U_SDCLNM
SETQ Q
 ;
TMP(SDENCDT,SDMADE) ; -- Check to see if ^TMP("SDRL",$J,Encounter Date/Time)
 ;                    exists
 ;  input - SDENCDT := encounter date/time
 ;          SDMADE  := date encounter made
 ;
 ; output - 1 or 0
 ;
 IF '$D(^TMP("SDRL",$J,$P(SDENCDT,"."))) Q 0
 Q ^TMP("SDRL",$J,$P(SDENCDT,"."))<(SDMADE_.9)
 ;
DIV() ; -- valid division for report ?
 Q $S(VAUTD=1:1,1:$D(VAUTD(SDDIV)))
 ;
CLINIC() ; -- valid clinic for report ?
 Q $S('$D(VAUTC):1,VAUTC=1:1,1:$D(VAUTC(SDCL)))
 ;
STOP() ; -- valid stop code for report ?
 Q $S('$D(VAUTS):1,VAUTS=1:1,1:$D(VAUTS(SDSC)))
 ;
