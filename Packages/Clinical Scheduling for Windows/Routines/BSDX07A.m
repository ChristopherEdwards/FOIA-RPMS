BSDX07A ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ; 
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
APPOVB(BSDXY,SDCL,NSDT,BSDXRES) ; RPC - BSDX OVERBOOK - CHECK FOR OVERBOOK FOR GIVEN CLINIC, DATE, AND RESOURCE
 ;  .BSDXY   = returned pointer to OVERBOOK data
 ;   SDCL    = clinic code - pointer to Hospital Location file ^SC
 ;   NSDT    = date/time of new appointment
 ;   BSDXRES = resource to check for overbook
 N %DT,AP,BSDXI,OB,OBC,OBCNT,OBMAX,SDCLSL,SDT,X,Y
 ; SDTD  = new schedule Date only in FM format
 ; SDT   = loop value for $o through schedules
 ; SDTE  = end of loop schedule
 ; NSDT  = new appointment schedule Date/Time will be converted to FM format
 D ^XBKVAR S X="ERROR^BSDX07A",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid Hospital location
 I '+SDCL D ERR1("Invalid Clinic ID - Cannot determine if Overbook is allowed.") Q
 I '$D(^SC(SDCL,0)) D ERR1("Invalid Clinic ID - Cannot determine if Overbook is allowed.") Q
 ;check for valid resource ID
 I '+BSDXRES D ERR1("Invalid Resource ID - Cannot determine if Overbook is allowed.") Q
 I '$D(^BSDXRES(BSDXRES,0)) D ERR1("Invalid Resource ID - Cannot determine if Overbook is allowed.") Q
 ;check for valid DATE/TIME
 S %DT="T"
 S X=NSDT
 D ^%DT   ; GET FM FORMAT FOR APPOINTMENT DATE/TIME
 S NSDT=Y
 I NSDT=-1 D ERR1("Invalid Appointment Date.") Q
 S SDTD=$P(NSDT,".")
 ; data header
 ; OVERBOOK  0=not overbooked; 1=overbooked
 S ^BSDXTMP($J,0)="T00020OVERBOOK"_$C(30)
 ;get allowed number of overbookings for clinic
 S SDCLSL=$G(^SC(SDCL,"SL"))
 S OBMAX=$P(SDCLSL,U,7)
 ;loop thru schedule
 ; OBC(<appt time>,<appt end time>)=overlap counter starting at 0
 K OBC  ;overbook counter array
 S SDT=(SDTD-1)_"."_235959
 F  S SDT=$O(^SC(SDCL,"S",SDT)) Q:(SDT'>0)  Q:($P(SDT,".")'=SDTD)  D
 . S AP=0
 . F  S AP=$O(^SC(SDCL,"S",SDT,1,AP)) Q:(AP'>0)  D
 . . S DFN=$P(^SC(SDCL,"S",SDT,1,AP,0),U,1)
 . . S SDCLRES=$$BSDXAP(SDT,DFN)
 . . ;if resource for this appointment is passed in resource
 . . I SDCLRES=BSDXRES D
 . . . ;S SDCLN=^SC(SDCL,"S",SDT,1,AP,1)
 . . . S SDCLN=$G(^SC(SDCL,"S",SDT,1,AP,0))
 . . . ;determine end of appointment
 . . . S SDTE=$$FMADD^XLFDT(SDT,,,$P(SDCLN,U,2))
 . . . D CKOB(SDT,SDTE,.OBC)
 S OBCNT=$$CNTOB(.OBC,BSDXRES)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$S(OBCNT<OBMAX:"YES",1:"NO")
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
 ;find appointment in BSDX APPOINTMENT file
BSDXAP(BSDXSDT,DFN) ;
 N BSDXAPN,BSDXRES,ID
 S BSDXRES=0
 S ID=0
 F  S ID=$O(^BSDXAPPT("B",BSDXSDT,ID)) Q:ID'>0  Q:BSDXRES'=0  D
 . S BSDXAPN=$G(^BSDXAPPT(ID,0))
 . I $P(BSDXAPN,U,5)=DFN S BSDXRES=$P(BSDXAPN,U,7)
 Q BSDXRES
 ;
 ;check if appointment start/stop is in range of an existing appointment
CKOB(START,STOP,OBC) ;called internally
 ;  START   = appointment start date/time in FM format
 ;  STOP    = appointment stop date/time in FM format
 ; .OBC     = Overbook Array as defined above
 N B,E,OB,OBF
 S OBF=0
 S B=""
 F  S B=$O(OBC(B)) Q:B'>0  D
 . S E="" F  S E=$O(OBC(B,E),1,OB) Q:E'>0  D
 . . S OBF=(($P(START,".",2)>=$P(B,".",2))&($P(START,".",2)<=$P(E,".",2)))!(($P(STOP,".",2)>=$P(B,".",2))&($P(STOP,".",2)<=$P(E,".",2)))
 . . I OBF S OBC($S($P(START,".",2)>=$P(B,".",2):B,1:START),$S($P(STOP,".",2)<=$P(E,".",2):E,1:STOP))=(OB+1) Q
 I 'OBF S OBC(START,STOP)=1
 ;
 Q
 ;
 ;count overbookings
CNTOB(OBC,BSDXRES) ;called internally
 N AB,ABF,ABN,CNT,OB,SLOTS,START,STOP
 S CNT=0
 S START="" F  S START=$O(OBC(START)) Q:START=""  D
 . S STOP="" F  S STOP=$O(OBC(START,STOP),1,OB) Q:STOP=""  Q:OB=0  D
 . . S SLOTS=0
 . . ;find access block
 . . S AB="" F  S AB=$O(^BSDXAB("B",BSDXRES,AB)) Q:AB'>0  D
 . . . S ABN=^BSDXAB(AB,0)
 . . . S ABF=((START>=$P(ABN,U,2))&(START<=$P(ABN,U,3)))!((STOP>=$P(ABN,U,2))&(STOP<=$P(ABN,U,3)))
 . . . I ABF D
 . . . . S SLOTS=$P(ABN,U,4)
 . . . . S OB=OB-SLOTS
 . . . . S:OB<0 OB=0
 . . . . S CNT=CNT+OB
 . . . . Q  ;quit find access block loop
 . . I 'ABF D  ;if access block not found, appointments are overbook
 . . . S CNT=CNT+OB
 Q CNT
 ;
ERROR ;
 D ERR1("RPMS Error")
 Q
 ;
ERR1(BSDXERR) ;Error processing
 I +BSDXERR S BSDXERR=ERRNO+134234112 ;vbObjectError
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
