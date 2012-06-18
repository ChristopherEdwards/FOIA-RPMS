INHRPC ;cmi/anch/maw - INH RPC Utilities  4/11/2006 12:24:38 PM
 ;;3.01;BHL IHS Interfaces with GIS;**14,15**;JUL 01, 2001
 ;
 ;
 ;
 ;this routine will contain utilities needed to talk with the Visual GIS Monitor
 Q
 ;
DEBUG(INHRET,INHSTR) ;-- run the serenji debugger
 ;D DEBUG^%Serenji("TAG^ROUTINE(INHRET,.INHSTR)")
 Q
 ;
BACK(INHRET) ;-- get the background processes
 S X="MERR^INHRPC",@^%ZOSF("TRAP") ; m error trap
 N INHDA,INHI
 S INHI=0
 K ^INHTMP($J)
 S INHRET="^INHTMP("_$J_")"
 S ^INHTMP($J,INHI)="T00007BMXIEN^T00057Background Process^T00001Status^T00006Job^T00030Last Started^T00080StatusText"_$C(30)
 S INHDA=0 F  S INHDA=$O(^INTHPC("ACT",INHDA)) Q:'INHDA  D
 . N INHIEN
 . S INHIEN=0 F  S INHIEN=$O(^INTHPC("ACT",INHDA,INHIEN)) Q:'INHIEN  D
 .. S INHI=INHI+1
 .. N INHSTAT,INHTXTI,INHJOB,INHSTRT,INHNM
 .. S INHNM=$P($G(^INTHPC(INHIEN,0)),U)
 .. S INHSTAT=0
 .. S INHJOB=$P($G(^INTHPC(INHIEN,0)),U,4)
 .. S INHSTRT=$P($G(^INTHPC(INHIEN,0)),U,5)
 .. I INHSTRT S INHSTRT=$$FMTE^XLFDT(INHSTRT)
 .. I INHJOB,$D(^$JOB(INHJOB)),$D(^INRHB("RUN",INHIEN)) S INHSTAT=1
 .. I INHJOB,'$D(^$JOB(INHJOB)) S INHSTAT=0,INHJOB=""
 .. I '$D(^INRHB("RUN",INHIEN)) S INHSTAT=0,INHJOB=""
 .. S INHTXT=$P($G(^INRHB("RUN",INHIEN)),U,2)
 .. I INHTXT="" S INHTXT="Not Running"
 .. S ^INHTMP($J,INHI)=INHIEN_U_INHIEN_"-"_INHNM_U_INHSTAT_U_INHJOB_U_INHSTRT_U_INHTXT_$C(30)
 S ^INHTMP($J,INHI+1)=$C(31)
 Q
 ;
STRT(INHRET,INHSTR) ;-- start the background process
 S X="MERR^INHRPC",@^%ZOSF("TRAP") ; m error trap
 N P,INDA,INHI
 S P="|"
 K ^INHTMP($J)
 S INHRET="^INHTMP("_$J_")"
 S INHI=0
 S ^INHTMP($J,INHI)="T00080Error"_$C(30)
 S INDA=$P(INHSTR,P)
 I $$VER(INDA) D  Q
 . S INHI=INHI+1
 . S ^INHTMP($J,INHI)="Process is Already Running, Shutdown First"_$C(30)
 . S ^INHTMP($J,INHI+1)=$C(31)
 N INERR
 S INERR=$$OKTR(INDA)
 I 'INERR D  Q
 . S INHI=INHI+1
 . S ^INHTMP($J,INHI)=$G(INERR)_$C(30)
 . S ^INHTMP($J,INHI+1)=$C(31)
 N INHYN
 S INHYN=$$A(INDA)
 I 'INHYN D  Q
 . S INHI=INHI+1
 . S ^INHTMP($J,INHI)="Process did not Start"_$C(30)
 . S ^INHTMP($J,INHI+1)=$C(31)
 S INHI=INHI+1
 S ^INHTMP($J,INHI)=0_$C(30)
 S ^INHTMP($J,INHI+1)=$C(31)
 Q
 ;
STOP(INHRET,INHSTR) ;-- stop the background process
 S X="MERR^INHRPC",@^%ZOSF("TRAP") ; m error trap
 N P,INDA,INHI
 S P="|"
 K ^INHTMP($J)
 S INHRET="^INHTMP("_$J_")"
 S INHI=0
 S ^INHTMP($J,INHI)="T00080Error"_$C(30)
 S INDA=$P(INHSTR,P)
 S INSRVR=+$P(^INTHPC(INDA,0),U,8) ; opened as client=0 or server=1
 N INHX
 F INHXX=1:1:100 K ^INRHB("RUN",INDA)
 S:$$VER(INDA)&INSRVR INHX=$$SRVRHNG^INHB(INDA) ; shut down "hung" active server
 H 2
 S INHI=INHI+1
 S ^INHTMP($J,INHI)=0_$C(30)
 S ^INHTMP($J,INHI+1)=$C(31)
 Q
 ;
REF(INHRET,INHSTR) ;-- refresh the background process
 S X="MERR^INHRPC",@^%ZOSF("TRAP") ; m error trap
 N P,INDA,INHI
 S P="|"
 K ^INHTMP($J)
 S INHRET="^INHTMP("_$J_")"
 S INHI=0
 S INDA=$P(INHSTR,P)
 S ^INHTMP($J,INHI)="T00001Status^T00006Job^T00030Last Started^T00080Status Text^I00007Job Queue"_$C(30)
 S INHI=INHI+1
 N INHSTAT,INHTXTI,INHJOB,INHSTRT,INHNM,INHJQ
 S INHNM=$P($G(^INTHPC(INDA,0)),U)
 S INHSTAT=0
 S INHJOB=$P($G(^INTHPC(INDA,0)),U,4)
 S INHSTRT=$P($G(^INTHPC(INDA,0)),U,5)
 I INHSTRT S INHSTRT=$$FMTE^XLFDT(INHSTRT)
 I INHJOB,$D(^$JOB(INHJOB)),$D(^INRHB("RUN",INDA)) S INHSTAT=1
 I INHJOB,'$D(^$JOB(INHJOB)) S INHSTAT=0,INHJOB=""
 I '$D(^INRHB("RUN",INDA)) S INHSTAT=0,INHJOB=""
 S INHTXT=$P($G(^INRHB("RUN",INDA)),U,2)
 I INHTXT="" S INHTXT="Not Running"
 S INHJQ=0
 I INDA>2 S INHJQ=$$JOBCNT(INDA)
 S ^INHTMP($J,INHI)=INHSTAT_U_INHJOB_U_INHSTRT_U_INHTXT_U_INHJQ_$C(30)
 S ^INHTMP($J,INHI+1)=$C(31)
 Q
 ;
JOBCNT(INHINDA) ;-- return the number of records
 N INHDST
 S INHDST=$P($G(^INTHPC(INHINDA,0)),U,7)
 I 'INHDST Q 0
 I '$D(^INLHDEST(INHDST)) Q 0
 N CNT,INHDA
 S CNT=0
 S INHDA="" F  S INHDA=$O(^INLHDEST(INHDST,INHDA)) Q:INHDA=""  D
 . N INHP
 . S INHP=0 F  S INHP=$O(^INLHDEST(INHDST,INHDA,INHP)) Q:INHP=""  D
 .. N INHH
 .. S INHH=0 F  S INHH=$O(^INLHDEST(INHDST,INHDA,INHP,INHH)) Q:INHH=""  D
 ... S CNT=CNT+1
 Q CNT
 ;
MERR ; MUMPS ERROR TRAP
 N INHX
 X ("S INHX=$"_"ZE")
 S INHX="MUMPS error: """_INHX_""""
 D ERR(INHX)
 Q
 ;
ERR(ERR) ; BMX ADO SCHEMA ERROR PROCESSOR
 N INHXX
 S INHXX="ERROR|"_ERR_$C(30)
 S @INHRET@(1)=INHXX
 S @INHRET@(2)=$C(31)
 Q
 ;
A(DA) ;Startup a process
 ;DA = entry # in file 4004
 ;Returns 1 if started, 0 otherwise
 ;
 N INERR
 S INERR=$$OKTR(DA) I 'INERR Q INERR
 N JOB S JOB=$$REPLACE^UTIL(^INTHOS(1,1),"*","^INHB1("_DA_")")
 K ^INRHB("RUN",DA) X JOB F I=1:1:15 L +^INRHB("RUN",DA):0,-^INRHB("RUN",DA) Q:$D(^INRHB("RUN",DA))
 H 1 Q ''$D(^INRHB("RUN",DA))
 ;
OKTR(X) ;See if OK to run process #X
 ;Returns 1 if OK, 0 otherwise
 Q:'$G(^INRHSITE(1,"ACT")) "Interface system not active - NO ACTION TAKEN."
 Q:'$P($G(^INTHPC(X,0)),"^",2) "Process not active - NO ACTION TAKEN."
 Q:+$G(^INTHPC(X,7)) "Process cannot be started manually - NO ACTION TAKEN."
 Q 1
 ;
VER(DA) ;Verify entry DA is running
 ;Return 1 if running, 0 if not running, -1 if running but signaled to quit
 G:$G(^INTHOS(1,4))]"" VER1
 L +^INRHB("RUN",DA):1 I  L -^INRHB("RUN",DA) Q 0
 Q:'$D(^INRHB("RUN",DA)) -1
 Q 1
 ;
VER1 ;Come here when OS file has code to do the checking
 N X S X=$P(^INTHPC(DA,0),"^",4) Q:'X 0
 X "N DA "_^INTHOS(1,4) Q:'X 0
 Q:'$D(^INRHB("RUN",DA)) -1
 Q 1
 ;
