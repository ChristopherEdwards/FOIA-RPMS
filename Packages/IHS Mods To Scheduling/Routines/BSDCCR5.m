BSDCCR5 ; IHS/ANMC/LJF - CLINIC CAPACITY REPORT CONT. ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;COPY OF SCRPW75 BEFORE PATCH #223
 ;IHS/ANMC/LJF 10/05/2000 removed time from date appt made in ^TMP
 ;             10/06/2000 added call to IHS footer code
 ;              6/15/2001 added code for Cache (Set $P of undef global)
 ;              3/13/2002 only process for selected clinics
 ;
NAVA(SDBDT,SDEDT,SDEX) ;Gather next available appointment wait time information
 ;Input: SDBDT=beginning date
 ;Input: SDEDT=ending date
 ;Input: SDEX='0' for user report, '1' for Austin extract
 ;Output: ^TMP("SDNAVA",$J) array in the format:
 ;        ^TMP("SDNAVA",$J,division)='x'
 ;        ^TMP("SDNAVA",$J,division,credit_pair)='x'
 ;        ^TMP("SDNAVA",$J,division,credit_pair,clinic_ifn)='x'
 ;        ^TMP("SDNAVA",$J,division;credit_pair,clinic_ifn,date_scheduled)='x'
 ;         where 'x' = flag '0' appts.^ave. flag '0' wait time^flag
 ;                     '1' appts.^ave. flag '1' wait time^flag '2'
 ;                     appts.^ave. flag '2' wait time^flag '3' appts.
 ;                     ^ave. flag '3' wait time         
 ;
 N SDT,SDCT,DFN,SDADT,SDAP,SDAP0,SDWAIT,SDCL,SDFLAG,SDX,SDI,SC0,SDCP
 S SDT=SDBDT-1,(SDOUT,SDCT)=0
 K ^TMP("SDXNAVA",$J),^TMP("SDNAVA",$J)
 ;
 ;IHS/ANMC/LJF 3/13/2002 use IHS xref so only selected clinics used
 ; original VA code
 ;F  S SDT=$O(^DPT("ASADM",SDT)) Q:SDOUT!'SDT!(SDT>SDEDT)  S DFN=0 D
 ;.F  S DFN=$O(^DPT("ASADM",SDT,DFN)) Q:SDOUT!'DFN  S SDADT=0 D
 ;..F  S SDADT=$O(^DPT("ASADM",SDT,DFN,SDADT)) Q:SDOUT!'SDADT  D
 ;...S SDCT=SDCT+1 I SDCT#1000=0 D STOP Q:SDOUT
 ;...S SDAP0=$G(^DPT(DFN,"S",SDADT,0)) Q:$P(SDAP0,U,19)'=SDT
 ;...S SDCL=+SDAP0 Q:SDCL<1  S SDFLAG=+$P(SDAP0,U,26)
 ;...S SDWAIT=$S(SDADT<SDT:0,1:$$FMDIFF^XLFDT(SDADT,SDT,1))
 ;...S $P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+1))=$P($G(^TMP("SDXNAVA",$J,SDCL)),U,((SDFLAG*2)+1))+1
 ;...S $P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+2))=$P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+2))+SDWAIT
 ;...Q:SDEX=1!(SDFMT'="D")
 ;...Q
 ;..Q
 ;.Q
 ;
 ;IHS code using AIHSDAM xref on file 44 instead of ASADM on file 2
 NEW BSDCL,X,BSDN
 S X=0 F  S X=$O(SDSORT(X)) Q:X=""  S BSDCL(SDSORT(X))=X
 S SDCL=0 F  S SDCL=$O(BSDCL(SDCL)) Q:'SDCL  D
 . S SDT=SDBDT-1
 . F  S SDT=$O(^SC("AIHSDAM",SDCL,SDT)) Q:'SDT!(SDT>SDEDT)  D
 .. S SDADT=0 F  S SDADT=$O(^SC("AIHSDAM",SDCL,SDT,SDADT)) Q:'SDADT  D
 ... S BSDN=0
 ... F  S BSDN=$O(^SC("AIHSDAM",SDCL,SDT,SDADT,BSDN)) Q:'BSDN  D
 .... S SDCT=SDCT+1 I SDCT#1000=0 D STOP Q:SDOUT
 .... S SDWAIT=$S(SDADT<SDT:0,1:$$FMDIFF^XLFDT(SDADT,SDT,1))
 ....;
 ....S SDFLAG=0   ;IHS/ANMC/LJF 10/5/2000
 ....;
 ....;IHS/ANMC/LJF 6/15/2001
 ....I '$D(^TMP("SDXNAVA",$J,SDCL)) S ^TMP("SDXNAVA",$J,SDCL)=""
 ....I '$D(^TMP("SDXNAVA",$J,SDCL,(SDT\1))) S ^TMP("SDXNAVA",$J,SDCL,(SDT\1))=""
 ....;IHS/ANMC/LJF 6/15/2001 end of mods
 ....;
 ....S $P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+1))=$P($G(^TMP("SDXNAVA",$J,SDCL)),U,((SDFLAG*2)+1))+1
 ....S $P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+2))=$P(^TMP("SDXNAVA",$J,SDCL),U,((SDFLAG*2)+2))+SDWAIT
 ....Q:SDEX=1!(SDFMT'="D")
 ....;
 ....;IHS/ANMC/LJF 10/5/2000
 ....;S $P(^TMP("SDXNAVA",$J,SDCL,SDT),U,((SDFLAG*2)+1))=$P($G(^TMP("SDXNAVA",$J,SDCL,SDT)),U,((SDFLAG*2)+1))+1
 ....;S $P(^TMP("SDXNAVA",$J,SDCL,SDT),U,((SDFLAG*2)+2))=$P(^TMP("SDXNAVA",$J,SDCL,SDT),U,((SDFLAG*2)+2))+SDWAIT
 ....S $P(^TMP("SDXNAVA",$J,SDCL,(SDT\1)),U,((SDFLAG*2)+1))=$P($G(^TMP("SDXNAVA",$J,SDCL,(SDT\1))),U,((SDFLAG*2)+1))+1
 ....S $P(^TMP("SDXNAVA",$J,SDCL,(SDT\1)),U,((SDFLAG*2)+2))=$P(^TMP("SDXNAVA",$J,SDCL,(SDT\1)),U,((SDFLAG*2)+2))+SDWAIT
 ;IHS/ANMC/LJF 10/5/2000 end of mods
 ;IHS/ANMC/LJF 3/13/2002 end of mods
 ;
 ;
 Q:SDOUT  S SDCL=0
 F  S SDCL=$O(^TMP("SDXNAVA",$J,SDCL)) Q:'SDCL  D
 .S SC0=$G(^SC(SDCL,0)) Q:'$L(SC0)  Q:'$$CPAIR^BSDCCR1(SC0,.SDCP)
 .S SDIV=$$DIV^BSDCCR1(SC0) Q:'$L(SDIV)
 .Q:'$D(^TMP("SD",$J,SDIV,SDCP,SDCL))
 .S:'$D(^TMP("SDNAVA",$J,SDIV,SDCP)) ^TMP("SDNAVA",$J,SDIV,SDCP)=""
 .I SDMD S:'$D(^TMP("SDNAVA",$J,0,SDCP)) ^TMP("SDNAVA",$J,0,SDCP)=""
 .S SDX=^TMP("SDXNAVA",$J,SDCL),^TMP("SDNAVA",$J,SDIV,SDCP,SDCL)=$$AVE(SDX)
 .I SDMD S ^TMP("SDNAVA",$J,0,SDCP,SDCL)=$$AVE(SDX)
 .;
 .;IHS/ANMC/LJF 6/15/2001 add line for Cache
 .I SDMD,'$D(^TMP("SDNAVA",$J,0)) S ^TMP("SDNAVA",$J,0)=""
 .I '$D(^TMP("SDNAVA",$J,SDIV)) S ^TMP("SDNAVA",$J,SDIV)=""
 .I SDMD,'$D(^TMP("SDNAVA",$J,0,SDCP)) S ^TMP("SDNAVA",$J,0,SDCP)=""
 .I '$D(^TMP("SDNAVA",$J,SDIV,SDCP)) S ^TMP("SDNAVA",$J,SDIV,SDCP)=""
 .;IHS/ANMC/LJF end of new code
 .;
 .F SDI=1:1:8 S $P(^TMP("SDNAVA",$J,SDIV),U,SDI)=$P($G(^TMP("SDNAVA",$J,SDIV)),U,SDI)+$P(SDX,U,SDI)
 .I SDMD F SDI=1:1:8 S $P(^TMP("SDNAVA",$J,0),U,SDI)=$P($G(^TMP("SDNAVA",$J,0)),U,SDI)+$P(SDX,U,SDI)
 .F SDI=1:1:8 S $P(^TMP("SDNAVA",$J,SDIV,SDCP),U,SDI)=$P(^TMP("SDNAVA",$J,SDIV,SDCP),U,SDI)+$P(SDX,U,SDI)
 .I SDMD F SDI=1:1:8 S $P(^TMP("SDNAVA",$J,0,SDCP),U,SDI)=$P(^TMP("SDNAVA",$J,0,SDCP),U,SDI)+$P(SDX,U,SDI)
 .S SDT=0 F  S SDT=$O(^TMP("SDXNAVA",$J,SDCL,SDT)) Q:SDOUT!'SDT  D
 ..S SDX=^TMP("SDXNAVA",$J,SDCL,SDT),^TMP("SDNAVA",$J,SDIV,SDCP,SDCL,SDT)=$$AVE(SDX)
 ..Q
 .Q
 S SDIV="" F  S SDIV=$O(^TMP("SDNAVA",$J,SDIV)) Q:'$L(SDIV)  D
 .S SDCP=0 F  S SDCP=$O(^TMP("SDNAVA",$J,SDIV,SDCP)) Q:'SDCP  D
 ..S SDX=^TMP("SDNAVA",$J,SDIV,SDCP),^TMP("SDNAVA",$J,SDIV,SDCP)=$$AVE(SDX)
 ..Q
 .Q
 S SDIV="" F  S SDIV=$O(^TMP("SDNAVA",$J,SDIV)) Q:SDIV=""  D
 .S SDX=^TMP("SDNAVA",$J,SDIV),^TMP("SDNAVA",$J,SDIV)=$$AVE(SDX)
 .Q
 K ^TMP("SDXNAVA",$J)
 Q
 ;
AVE(SDX) ;Calculate averages
 ;Input: SDX=string of appointment totals and total waiting time
 ;Output: string of appointment totals and average waiting time
 N SDI,SDY
 F SDI=2,4,6,8 D
 .S SDY=+$P(SDX,U,(SDI-1)),$P(SDX,U,(SDI-1))=SDY
 .S $P(SDX,U,SDI)=$FN($S(SDY=0:0,1:$P(SDX,U,SDI)/SDY),"",1)
 .Q
 Q SDX
 ;
STOP ;Check for stop task request
 S:$D(ZTQUEUED) (SDOUT,ZTSTOP)=$S($$S^%ZTLOAD:1,1:0) Q
 ;
FOOT(SDTX) ;Report footer for retrospective report
 ;Input: SDTX=array to return text
 D FOOT^BSDCCRL(.SDTX) Q  ;IHS/ANMC/LJF 10/6/2000
 S SDTX(1)=SDLINE
 S SDTX(2)="NOTE:  TYPE '0' activity represents appointments scheduled during the report time frame that were not indicated by the user or by"
 S SDTX(3)="calculation to be ""next available"" appointments.  TYPE '1' activity represents appointments defined by the user as being ""next"
 S SDTX(4)="available"" appointments.  TYPE '2' activity represents appointments calculated to be ""next available"" appointments.  TYPE '3'"
 S SDTX(5)="activity represents appointments indicated both by the user and by calculation to be ""next available"" appointments.  WAIT TIME is"
 S SDTX(6)="the average number of days from the date an appointment was scheduled to the date it is to be performed."
 S SDTX(7)=SDLINE
 Q
