BSDCCR3 ; IHS/ANMC/LJF - CLINIC CAPACITY REPORT CONT. ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;COPY OF SCRPW73 BEFORE PATCH #223
 ;IHS/ANMC/LJF 10/06/2000 changed credit pair to clinic code-name
 ;                        added changes to make report narrower
 ;                        use IHS footer for future & past dates
 ;                         and only at end of report
 ;              8/24/2001 fixed parameter passing, used user's choice
 ;                        shortened display of clinic name
 ;
PRT(SDXM) ;Print report
 ;Input: SDXM='1' for output to mail message text, '0' otherwise
 ;
 N SDX,SDY,SDI,SDP,SDPCT,SDMD,SCNA,SDFOOT,SDT
 S SDOUT=0 D HINI^BSDCCR2,FOOT^BSDCCR5(.SDFOOT)
 S SDMD=$O(^TMP("SD",$J,"")),SDMD=$O(^TMP("SD",$J,SDMD)),SDMD=$L(SDMD)
 I '$D(^TMP("SD",$J)) D  Q
 .D HDR^BSDCCR2(0) S SDX="No data found within the report parameters selected."
 .W !!?(SDIOM-$L(SDX)\2),SDX Q
 S SDIV=9999999 F  S SDIV=$O(^TMP("SD",$J,SDIV)) Q:SDIV=""!SDOUT  D
 .I SDFMT="D" D
 ..S SDCP="" F  S SDCP=$O(^TMP("SD",$J,SDIV,SDCP)) Q:SDCP=""!SDOUT  D
 ...S SCNA="" F  S SCNA=$O(^TMP("SDS",$J,SDCP,SCNA)) Q:SCNA=""!SDOUT  D
 ....S SC=0 F  S SC=$O(^TMP("SDS",$J,SDCP,SCNA,SC)) Q:'SC!SDOUT  D
 .....Q:'$D(^TMP("SD",$J,SDIV,SDCP,SC))
 .....D HDR^BSDCCR2(1,SDIV,SDCP,SC) Q:SDOUT  S SDX=^TMP("SD",$J,SDIV,SDCP,SC)
 .....I $P(SDX,U)+$P(SDX,U,2)+$P(SDX,U,3)'>0 D  Q
 ......S SDY="No availability found"_$S($L($P(SDX,U,4)):": "_$P(SDX,U,4)_".",1:".")
 ......W !!?(SDIOM-$L(SDY)\2),SDY Q
 .....S SDI="" F  S SDI=$O(^TMP("SD",$J,SDIV,SDCP,SC,SDI)) Q:SDI=""!SDOUT  D
 ......S SDX=^TMP("SD",$J,SDIV,SDCP,SC,SDI)
 ......F SDP=1:1 S SDY=$P(SDX,U,SDP) Q:'$L(SDY)!SDOUT  D
 .......S SDY=$TR(SDY,"~","^"),SDT=$$DAY(SDI,SDP,SDBDT)
 .......S SDY=$$TRX(SDY,SDIV,SDCP,SC,$P(SDT,U,2))
 .......;I 'SDXM,$Y>(IOSL-$S(SDPAST:12,1:5)) D  ;IHS/ANMC/LJF 10/6/2000
 .......I 'SDXM,$Y>(IOSL-$S(SDPAST:5,1:5)) D  ;IHS/ANMC/LJF 10/6/2000
 ........;D:SDPAST FOOTER D HDR^BSDCCR2(1,SDIV,SDCP,SC)  ;IHS/ANMC/LJF 10/6/2000
 ........D HDR^BSDCCR2(1,SDIV,SDCP,SC)  ;IHS/ANMC/LJF 10/6/2000
 ........Q
 .......Q:SDOUT
 .......D OUTPUT($P(SDT,U),SDY,SDCOL,4,0,SDPAST,.SDXM)
 .......Q
 ......Q
 .....Q:SDOUT
 .....S SDX=^TMP("SD",$J,SDIV,SDCP,SC),SDX=$$TRX(SDX,SDIV,SDCP,SC)
 .....D OUTPUT("    Clinic Total:",SDX,SDCOL,0,1,SDPAST,.SDXM)
 .....;D:SDPAST FOOTER  ;IHS/ANMC/LJF 10/6/2000
 .....Q
 ....Q
 ...Q
 ..Q
 .Q:SDOUT  D SUM(SDIV) Q
 Q:SDOUT
 ;
 I SDMD D SUM(0)
 Q
 ;
TRX(SDX,SDIV,SDCP,SC,SDT) ;Transform string for output
 ;Input: SDX=output numbers to transform
 ;Input: SDIV=medical center division
 ;Input: SDCP=credit pair (optional)
 ;Input: SC=clinic ien (optional)
 ;Input: SDT=date for detail by day (optional)
 ;Output: (prospective report)=clinic_capacity^available_slots^%_slots_
 ;        available
 ;        (retrospective report)=clinic_capacity^available_slots^
 ;        %_slots_available^clinic_encounters^next_ava._flag_'0'_appts.
 ;        ^next_ava._flag_'0'_ave._wait_time^next_ava._flag_'1'_appts.
 ;        ^next_ava._flag_'1'_ave._wait_time^next_ava._flag_'2'_appts.
 ;        ^next_ava._flag_'2'_ave._wait_time^next_ava._flag_'3'_appts.
 ;        ^next_ava._flag_'3'_ave._wait_time
 ;
 N SDY
 S SDY=$P(SDX,U,2)_U_$P(SDX,U)_U
 S SDY=SDY_$S(+$P(SDX,U,2)=0:0,1:$P(SDX,U)*100\$P(SDX,U,2))
 S SDY=SDY_U_$P(SDX,U,3)
 I '$G(SDCP) S SDY=SDY_U_$G(^TMP("SDNAVA",$J,SDIV)) Q SDY
 I '$G(SC) S SDY=SDY_U_$G(^TMP("SDNAVA",$J,SDIV,SDCP)) Q SDY
 I '$G(SDT) S SDY=SDY_U_$G(^TMP("SDNAVA",$J,SDIV,SDCP,SC)) Q SDY
 S SDY=SDY_U_$G(^TMP("SDNAVA",$J,SDIV,SDCP,SC,SDT))
 Q SDY
 ;
DAY(SDI,SDP,SDBDT) ;Produce date/day value
 ;Input: SDI=array subscript incrementor
 ;Input: SDP=$PIECE of string containing related date data
 ;Input: SDBDT=report start date
 N X1,X2,X,%H,Y,SDT,SDAY
 S X1=SDBDT,X2=-1 D C^%DTC
 S X1=X,X2=SDI*12+SDP D C^%DTC S SDT=X
 D DW^%DTC S SDAY=X,Y=SDT X ^DD("DD")
 Q Y_" "_$S($E(SDT,6)=0:"-",1:"")_"- "_SDAY_U_SDT
 ;
SUM(SDIV) ;Print division/facility summary
 ;Input: SDDIV=division name^number (or '0' for facility total)
 ;
 N SDY,SCNA,SDI
 S SDCP="",SDHD=$S(SDIV=0:3,1:2) D HDR^BSDCCR2(SDHD,SDIV)
 F  S SDCP=$O(^TMP("SD",$J,SDIV,SDCP)) Q:SDCP=""!SDOUT  D
 .S SDX=^TMP("SD",$J,SDIV,SDCP),SDY=$G(^TMP("SD",$J,SDIV))
 .F SDI=1:1:3 S $P(SDY,U,SDI)=$P(SDY,U,SDI)+$P(SDX,U,SDI)
 .S ^TMP("SD",$J,SDIV)=SDY
 .I SDFMT="S" Q:$P(SDX,U)+$P(SDX,U,2)+$P(SDX,U,3)'>0
 .I SDMD S SDY=$G(^TMP("SD",$J,0,SDCP)) D
 ..F SDI=1:1:3 S $P(SDY,U,SDI)=$P(SDY,U,SDI)+$P(SDX,U,SDI)
 ..S ^TMP("SD",$J,0,SDCP)=SDY
 .S SDY=$$OTX("CP"),SDX=$$TRX(SDX,SDIV,SDCP)
 .D OUTPUT(SDY,SDX,SDCOL,0,1,SDPAST,.SDXM)
 .S SCNA="" F  S SCNA=$O(^TMP("SDS",$J,SDCP,SCNA)) Q:SCNA=""!SDOUT  D
 ..S SC=0 F  S SC=$O(^TMP("SDS",$J,SDCP,SCNA,SC)) Q:'SC!SDOUT  D
 ...S SDX=$G(^TMP("SD",$J,SDIV,SDCP,SC))
 ...I SDFMT="S" Q:$P(SDX,U)+$P(SDX,U,2)+$P(SDX,U,3)'>0
 ...;I 'SDXM,$Y>(IOSL-$S(SDPAST:12,1:5)) D      ;IHS/ANMC/LJF 10/6/2000
 ...I 'SDXM,$Y>(IOSL-$S(SDPAST:5,1:5)) D        ;IHS/ANMC/LJF 10/6/2000
 ....;D:SDPAST FOOTER D HDR^BSDCCR2(SDHD,SDIV)  ;IHS/ANMC/LJF 10/6/2000
 ....D HDR^BSDCCR2(SDHD,SDIV)                   ;IHS/ANMC/LJF 10/6/2000
 ....Q
 ...Q:SDOUT
 ...I SDMD S SDY=$G(^TMP("SD",$J,0,SDCP,SC)) D
 ....F SDI=1:1:3 S $P(SDY,U,SDI)=$P(SDY,U,SDI)+$P(SDX,U,SDI)
 ....S ^TMP("SD",$J,0,SDCP,SC)=SDY
 ....Q
 ...;IHS/ANMC/LJF 10/6/2000 modified lines below
 ...;S SDY=$$OTX("CL"),SDX=$$TRX(SDX,SDIV,SDCP,SC)
 ...;D OUTPUT(SDY,SDX,SDCOL,4,0,SDPAST,.SDXM)
 ...S SDY="  "_$$OTX("CL"),SDX=$$TRX(SDX,SDIV,SDCP,SC)
 ...D OUTPUT(SDY,SDX,SDCOL,0,0,SDPAST,.SDXM)
 ...;IHS/ANMC/LJF 10/6/2000 end of code changes
 ...Q
 ..Q
 .Q
 Q:SDOUT  S SDX=$G(^TMP("SD",$J,SDIV)),SDX=$$TRX(SDX,SDIV)
 S SDY=$S(SDIV=0:"Facility",1:"Division")_" total:" D OUTPUT(SDY,SDX,SDCOL,0,1,SDPAST,.SDXM)
 ;D:SDPAST FOOTER  ;IHS/ANMC/LJF 10/6/2000
 I $Y>(IOSL-$S(SDPAST:9,1:5)) D HDR^BSDCCR2(SDHD,SDIV)  ;IHS/ANMC/LJF 10/6/2000
 D FOOTER          ;IHS/ANMC/LJF 10/6/2000
 Q
 ;
FOOTER ;Print footer
 N SDI
 I SDXM D  Q
 .D XMTX(" ") F SDI=1:1:7 D XMTX(SDFOOT(SDI))
 .Q
 ;F SDI=1:1:80 Q:$Y>(IOSL-10)  W !            ;IHS/ANMC/LJF 10/6/2000
 ;F SDI=1:1:7 W !,SDFOOT(SDI)                 ;IHS/ANMC/LJF 10/6/2000
 F SDI=1:1:$S(SDPAST:9,1:5) W !,SDFOOT(SDI)   ;IHS/ANMC/LJF 10/6/2000
 Q
 ;
OUTPUT(SDTX,SDX,SDCOL,SDC,SDL,SDPAST,SDXM) ;Write output or load summary message
 ;Input: SDTX=category text value
 ;Input: SDX=output count values
 ;Input: SDCOL=margin adjusted column control
 ;Input: SDC=column to start line
 ;Input: SDL=number of additional linefeeds
 ;Input: SDPAST='0' if dates > TODAY, '1' otherwise
 ;Input: SDXM=mail message line number message text (optional)
 ;
 N SDI,SDPCT
 G:$G(SDXM) OUTXM F SDI=1:1:SDL W !
 ;
 ;IHS/ANMC/LJF 10/6/2000; 8/24/2001
 ;W !?(SDCOL+SDC),SDTX
 ;F SDI=1:1:$S(SDPAST:12,1:3) D
 W !?(SDCOL+SDC),$E(SDTX,1,27)
 F SDI=1:1:$S(SDPAST:6,1:3) D
 .W ?(SDCOL+34+(SDI-1*8)),$J(+$P(SDX,U,SDI),$S(SDI=3:7,1:8),$$OPD())_$S(SDI=3:"%",1:"")
 .Q
 ;IHS/ANMC/LJF 10/6/2000, 8/24/2001 end of mods
 Q
 ;
OPD() ;Output decimal places
 Q $S(SDI<6:0,SDI#2:0,1:1)
 ;
OUTXM ;Load bulletin message text
 ;Output: ^TMP("SDXM",$J,SDXM)=mail message text line
 N SDZ S:SDC<1 SDC=1
 F SDI=1:1:SDL D XMTX("")
 S SDZ="",$E(SDZ,SDC)=SDTX
 F SDI=1:1:$S(SDPAST:12,1:3) D
 .S $E(SDZ,(34+(SDI-1*8)))=$J(+$P(SDX,U,SDI),$S(SDI=3:7,1:8),$$OPD())_$S(SDI=3:"%",1:"")
 D XMTX(SDZ)
 Q
 ;
XMTX(SDX) ;Set mail message text line
 ;Input: SDX=text value
 S ^TMP("SDXM",$J,SDXM)=SDX,SDXM=SDXM+1 Q
 ;
OTX(SDSORT)    ;Produce output text for clinic or credit pair
 ;Input: SDSORT='CL' for clinic name, 'CP' for credit pair
 N SDZ,SDSC1,SDSC2
 I SDSORT="CL" S SDZ=$P($G(^SC(+SC,0)),U) S:'$L(SDZ) SDZ="UNKNOWN" Q SDZ
 S SDSC1=$O(^DIC(40.7,"C",$E(SDCP,1,3),""))
 Q SDCP_"-"_$E($$GET1^DIQ(40.7,SDSC1,.01),1,20)   ;IHS/ANMC/LJF 10/6/2000
 ;
 S SDSC1=$P($G(^DIC(40.7,+SDSC1,0)),U),SDSC1=$TR(SDSC1,"/","-")
 S:'$L(SDSC1) SDSC1="UNKNOWN"
 I $E(SDCP,4,6)="000" S SDSC2="(NONE)" G CPO1
 S SDSC2=$O(^DIC(40.7,"C",$E(SDCP,4,6),""))
 S SDSC2=$P($G(^DIC(40.7,+SDSC2,0)),U),SDSC2=$TR(SDSC2,"/","-")
 S:'$L(SDSC2) SDSC2="UNKNOWN"
CPO1 I $L(SDSC1)<13 S SDZ=SDSC1_"/"_$E(SDSC2,1,(13+(13-$L(SDSC1)))) G CPOTQ
 I $L(SDSC2)<13 S SDZ=$E(SDSC1,1,(13+(13-$L(SDSC2))))_"/"_SDSC2 G CPOTQ
 S SDZ=$E(SDSC1,1,13)_"/"_$E(SDSC2,1,13)
CPOTQ Q SDCP_" "_SDZ
 ;
HDRXM ;Create header in mail message
 ;
 N SDX,SDI,SDZ
 I SDPAGE>1 F SDI=1:1:5 D XMTX("")
 D XMTX($E(SDLINE,1,$S(SDPAST:130,1:79)))
 S SDZ="",$E(SDZ,($S(SDPAST:130,1:79)-$L(SDTITL)\2))=SDTITL D XMTX(SDZ)
 D HDRX^BSDCCR2(SDTY) S SDI=0
 F  S SDI=$O(SDTIT(SDI)) Q:'SDI  S SDZ="" D
 .S $E(SDZ,($S(SDPAST:130,1:79)-$L(SDTIT(SDI))\2))=SDTIT(SDI) D XMTX(SDZ)
 .Q
 D XMTX($E(SDLINE,1,$S(SDPAST:130,1:79))),XMTX("For clinic availability dates "_SDPBDT_" through "_SDPEDT)
 S SDZ="Date extracted: "_SDPNOW D XMTX(SDZ),XMTX($E(SDLINE,1,$S(SDPAST:130,1:79)))
 S SDPAGE=SDPAGE+1 D:SDTY SUBTXM(SDTY) Q
 ;
SUBTXM(SDTY) ;Create message header subtitles
 N SDI
 S SDZ="",$E(SDZ,44)="Avail.",$E(SDZ,54)="Pct."
 I SDPAST F SDI=0:1:3 D
 .S $E(SDZ,(SDCOL+68+(16*SDI)))="---Type '"_SDI_"'---"
 .Q
 D XMTX(SDZ)
 S SDZ="" I SDTY>1 S SDZ="Credit Pair"
 S $E(SDZ,36)="Clinic",$E(SDZ,45)="Appt.",$E(SDZ,53)="Slots"
 I SDPAST D
 .S $E(SDZ,60)="Clinic"
 .F SDI=0:1:3 S $E(SDZ,(SDCOL+68+(16*SDI)))="Sched.    Wait"
 .Q
 D XMTX(SDZ)
 S SDZ="",$E(SDZ,4)=$S(SDTY=1:"Availability Date",1:"Clinic Name")
 S $E(SDZ,34)="Capacity",$E(SDZ,45)="Slots",$E(SDZ,52)="Avail."
 I SDPAST D
 .S $E(SDZ,62)="Enc."
 .F SDI=0:1:3 S $E(SDZ,(SDCOL+68+(16*SDI)))="Appts.    Time"
 .Q
 D XMTX(SDZ)
 S SDZ="",$E(SDZ,$S(SDTY>1:1,1:4))=$E(SDLINE,1,$S(SDPAST:130-$S(SDTY=1:4,1:0),1:58))
 D XMTX(SDZ)
 Q
