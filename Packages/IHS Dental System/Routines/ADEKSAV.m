ADEKSAV ; IHS/HQT/MJL - PRINT COMPILED REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;THIS IS A SAVED VERSION OF ADEKRP FHL 9/9/98
 ;
 N ADEYQ,ADEROPT,ADEU,ADEIOP
 K DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;Get report period, options (SINGLE, COMBINED, QUARTERLY, ANN)
ASKYQ S ADEYQ=$$ASKYQ^ADEKRP3()
 I 'ADEYQ D  G END
 . Q:ADEYQ'="NO DATA"
 . W !,"There are no compiled dental statistics stored on this machine."
 . W !,"If the compiled statistics routines were installed within the"
 . W !,"past few hours, then the compiler routines are probably running"
 . W !,"now and haven't finished compiling yet."
 . W !,"Otherwise, you can start the compiling process manually by"
 . W !,"Executing the ECMP option (Compile Dental Quarterly Statistics)"
 . W !,"in the DEO submenu of the DENTAL SUPERVISOR's menu."
 S ADEROPT=$$ROPT^ADEKRP3()
 G:ADEROPT="" ASKYQ
 ;
 ;GET AND LOCK UNIQUE SUBSCRIPT FOR THE REPORT GLOBAL
 S ADEU=$$ADEU^ADEPSUB()
 K ^TMP("ADEP",ADEU) ;^TMP is a transient report global
 S ^TMP("ADEP",ADEU)="RUNNING"
 ;
 D ASKDEV^ADEKRP2("ZTM^ADEKRP","DENTAL OBJECTIVES REPORT PROCESSING")
 I POP K ^TMP("ADEP",ADEU) G END
 ;FHL 9/9/98 I $D(ZTSK) G END
 I $D(ZTQUEUED) G END
 ;
ZTM ;EP - TASKMAN PROCESSING PHASE
 I $D(ZTQUEUED) L +^TMP("ADEP",ADEU):1 I '$T S ZTREQ="@" G END
 N ADEREP,ADEDDS,ADEDATE,ADESER,ADEDNAM,ADEWK1,ADEWK2,ADEWK3,ADEH,DIR,ADEASD,ADEDEN,ADEMED,ADEYQT
 ;
 ;IENs in ^ADEKOB for Medical, Dental and Assessed objectives:
 S ADEMED=".3.",ADEDEN=".6.",ADEASD=".8."
 ;
 ;OLD: ADEPER=Quarterly (1) or Annual (0)
 ;ADEPER="SQ","CQ","SA" OR "CA"
 ;for Single or Combined, Quarterly or Annual
 I ADEROPT["SINGLE-QUARTER" D SINGLE^ADEKRP6("SQ",ADEYQ)
 ;Decrement ADEYQ by quarter, check for ADEKNT for that period
 ;if so, do single
 I ADEROPT["COMBINE-QUARTER" D SINGLE^ADEKRP6("CQ",ADEYQ) D
 . S ADEYQT=ADEYQ
 . S ADEH=2
 . F  S ADEYQT=$$BACK(ADEYQT) Q:'$D(^ADEKNT("AD",ADEYQT_".3"))  Q:ADEH>5  D SINGLE^ADEKRP6("CQ",ADEYQT) S ADEH=ADEH+1
 I ADEROPT["SINGLE-YEAR" D SINGLE^ADEKRP6("SA",ADEYQ)
 I ADEROPT["COMBINE-YEAR" D SINGLE^ADEKRP6("CA",ADEYQ)
 I ADEROPT["ANNUAL DENTAL BASIC MEASURES" D CF^ADEKRP5("ANNUAL",ADEYQ) D
 . S ADEYQT=ADEYQ
 . F  S ADEYQT=ADEYQT-1 Q:'$D(^ADEKNT("AD",ADEYQT_".3"))  D CF^ADEKRP5("ANNUAL",ADEYQT)
 I ADEROPT["QUARTERLY DENTAL BASIC MEASURES" D CF^ADEKRP5("QUARTERLY",ADEYQ) D
 . S ADEYQT=ADEYQ
 . S ADEH=2
 . F  S ADEYQT=$$BACK(ADEYQT) Q:'$D(^ADEKNT("AD",ADEYQT_".3"))  Q:ADEH>5  D CF^ADEKRP5("QUARTERLY",ADEYQT) S ADEH=ADEH+1
 ;
 ;
 ;Q  ;***Quit here to examine ^TMP array
 G:$O(^TMP("ADEP",ADEU,0))="" END
 ;Call DIP to print array
 I $D(ZTQUEUED) D  G END
 . I $D(IOT),IOT'="HFS" D  Q
 . . S ZTREQ=$H_U_ADEIOP_U_"DENTAL OBJECTIVES REPORT PRINTING"_U_"PRINT^ADEKRP1"
 . D PRINT^ADEKRP1 Q
 I '$D(ZTQUEUED) D PRINT^ADEKRP1
 ;
END K DUOUT,DTOUT,DIROUT,DIRUT
 D END^ADEKRP2
 Q
 ;
 ;
GETCNT(ADEYQ,ADEIEN,ADEAGEG) ;EP
 ;
 ;Returns "Quarter^Year^3-year" counts for
 ;Year.Quarter ADEYQ (YR.Q)
 ;objective entry ADEIEN (.N.)
 ;and age group ADEAGEG (YR:YR)
 ;Returns 0 if no entry for ADEYQ_ADEIEN
 ;
 ;If a specific entry in ADEKNT exists for the objective/age
 ;Returns values from that entry.
 ;Otherwise, starts with lower age and adds values
 ;of entries from ADEKNT thru upper range
 ;
AA N ADENOD,ADE01,ADELAG,ADEUAG,ADECNT,J
 S ADE01=ADEYQ_ADEIEN_ADEAGEG
 I $D(^ADEKNT("B",ADE01)) D  Q ADE01
 . S ADE01=$O(^ADEKNT("B",ADE01,0))
 . S ADE01=^ADEKNT(ADE01,0)
 . S ADE01=$P(ADE01,U,2,4)
 S ADE01=$P(ADE01,".",1,3)
 I '$D(^ADEKNT("AD",ADE01)) Q 0
 S ADECNT="0^0^0"
 S ADELAG=$P(ADEAGEG,":")-1
 F  S ADELAG=$O(^ADEKNT("AD",ADE01,ADELAG)) Q:ADELAG=""  S ADENOD=$O(^ADEKNT("AD",ADE01,ADELAG,0)),ADEUAG=$P(^ADEKNT(ADENOD,0),U,9) Q:ADEUAG>$P(ADEAGEG,":",2)  D
 . S ADENOD=$P(^ADEKNT(ADENOD,0),U,2,4)
 . F J=1:1:3 S $P(ADECNT,U,J)=$P(ADECNT,U,J)+$P(ADENOD,U,J)
ZZ Q ADECNT
 ;
BACK(ADEYQ)        ;EP
 ;Returns YYYY.Q 1 quarter prior to ADEYQ
 ;
 N ADEY,ADEQ
 S ADEY=$P(ADEYQ,".")
 ;beginning Y2K fix
 Q:$L(ADEY)<4 0  ;Y2000
 ;S:'ADEY ADEY=100
 S ADEQ=+$P(ADEYQ,".",2)
 S ADEQ=ADEQ-1
 S:ADEQ=0 ADEQ=4,ADEY=ADEY-1 ;Y2000
 ;end Y2K fix block
 Q ADEY_"."_ADEQ
