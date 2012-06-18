ASDCP ; IHS/ADC/PDW/ENM - CLINIC PROFILE PRINT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
PRT ;EP; called by ^SDCP for IHS version of clinic profile
 S ASDSTOP="" I $Y>(IOSL-12) D NEWPG
 W !,"CLINIC: ",$E(NAME,1,30),?40,"TELEPHONE: ",$$PHONE
 ;
 S SDNO="" I $D(^SC(SC,"I")) D
 . S SDRE=+$P(^SC(SC,"I"),U,2),SDIN=+^("I")
 . I SDRE'=SDIN D:SDIN'>DT&(SDRE=0!(SDRE>DT)) INACT^SDCP
 ;
 W !,"ABBREV: ",ABBR I $D(^SC("AIHSPC",SC)) W " - A PRINCIPAL CLINIC"
 W ?40,"LOCATION: ",LOC
 W !,"FACILITY: ",$$SITE
 I 'SDNO D
 . S Y=STDAT D:STDAT'="UNKNOWN" DTS^SDUTL
 . W ?40,"START DATE: ",$S(STDAT="UNKNOWN":"UNKNOWN",1:Y)
 I $D(^SC("AIHSPC",SC)) D PCLIST Q
 W !,"CLINIC CODE: ",STCD W:PC]"" ?40,"PRINCIPAL CLINIC: ",$E(PC,1,21)
 I 'SDNO D
 . W !,"DAYS CLINIC MEETS: ",DAYS,?40,"HOUR DISPLAY BEGINS: "
 . W $S(HCDB="":"8 AM",HCDB<13:HCDB_" AM",1:HCDB-12_" PM")
 W !,"APPOINTMENT LENGTH: ",LOP,?40,"VARIABLE: ",ALV
 W !,"MAX OVERBOOKS/DAY: ",ODM
 W:$D(SDMX) ?40,"MAX # DAYS FOR FUTURE BOOKING: ",SDMX
 W !,"SCHEDULE ON HOLIDAYS: ",$$HOLIDAY
 W ?40,"NON-COUNT CLINIC: ",$S(SDCNT="Y":"YES",1:"NO")
 W !,"INCLUDE ON FILE ROOM LIST: ",$$FRL,?40,"PRINT HS: ",$$HS
 W !,"PRINT MED PROFILE: ",$$MEDP,?40,"PRINT ADDRESS UPDATE: ",$$AIU
 I $O(^SC(SC,"SI",0)) D SPECIAL
 W !!,"PROHIBIT ACCESS TO CLINIC: ",SDPR
 I SDPR="YES" D PRVUSR
 I 'SDNO,$D(SDIN),SDIN>DT,SDRE'=SDIN D
 . W !,?4,"**** Clinic will be inactive ",$S(SDRE:"from ",1:"as of ")
 . S Y=SDIN D DTS^SDUTL W Y S Y=SDRE D:Y DTS^SDUTL
 . W $S(SDRE:" to "_Y,1:"")," ****" K SDIN,SDRE
 I 'SDSC D
 . W !?4,"** INVALID OR INACTIVE STOP CODE ASSIGNED TO THIS CLINIC **"
 W !!
 Q
 ;
NEWPG ; -- SUBRTN to handle 
 I IOST'["C-" D TOF S ASDSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S ASDSTOP=X
 I ASDSTOP'=U D TOF
 Q
 ;
TOF W @IOF,?22,"CLINIC PROFILES AS OF: ",PDATE,! Q
 ;
PCLIST ; -- SUBRTN to list all clinics grouped under principal clinic
 NEW ASDX
 I $Y>(IOSL-3) D NEWPG Q:ASDSTOP=U
 W !!,"CLINICS GROUPED UNDER THIS PRINCIPAL CLINIC:"
 S ASDX=0 F  S ASDX=$O(^SC("AIHSPC",SC,ASDX)) Q:ASDX=""  Q:ASDSTOP=U  D
 . Q:'$$ACTV^ASDUT(ASDX)
 . I $X>40 D:$Y>(IOSL-3) NEWPG Q:ASDSTOP=U  W !?3,$P(^SC(ASDX,0),U) Q
 . W ?40,$P(^SC(ASDX,0),U)
 W !!
 Q
 ;
SPECIAL ; -- SUBRTN to print out special instructions
 NEW ASDX
 I $Y>(IOSL-3) D NEWPG Q:ASDSTOP=U
 W !!,"SPECIAL INSTRUCTIONS:"
 S ASDX=0 F  S ASDX=$O(^SC(SC,"SI",ASDX)) Q:'ASDX  Q:ASDSTOP=U  D
 . I $Y>(IOSL-3) D NEWPG Q:ASDSTOP=U
 . W !,^SC(SC,"SI",ASDX,0)
 Q
 ;
PRVUSR ; -- SUBRTN to list priv. users
 NEW ASDX
 W " - Access restricted to:"
 S ASDX=0 F  S ASDX=$O(^SC(SC,"SDPRIV",ASDX)) Q:'ASDX  Q:ASDSTOP=U  D
 . I $X>40 D  Q
 .. I $Y>(IOSL-3) D NEWPG Q:ASDSTOP=U
 .. W !?3,$$VAL^XBDIQ1(200,+^SC(SC,"SDPRIV",ASDX,0),.01)
 . W ?40,$$VAL^XBDIQ1(200,+^SC(SC,"SDPRIV",ASDX,0),.01)
 Q
 ;
PHONE() ; -- returns phone #
 Q $S($D(^SC(SC,99)):^SC(SC,99),1:"")
 ;
SITE() ; -- returns institution
 Q $$VAL^XBDIQ1(44,SC,3)
 ;
HOLIDAY() ; -- returns whether clinic meets on holidays
 NEW X S X=$$VAL^XBDIQ1(44,SC,1918.5)
 Q $S(X]"":X,1:"NO")
 ;
FRL() ; -- returns answer to include on file room list
 NEW X S X=$$VAL^XBDIQ1(44,SC,2502.5)
 Q $S(X]"":X,SDCNT="Y":"NO",1:"YES")
 ;
HS() ; -- returns if user wants health summaries printed
 NEW X S X=$$VAL^XBDIQ1(44,SC,9999999.1)
 Q $S(X="NO":X,1:"YES - "_$$VAL^XBDIQ1(44,SC,9999999.2))
 ;
MEDP() ; -- returns whether med profiles should print
 NEW X S X=$$VAL^XBDIQ1(44,SC,9999999.3)
 Q $S(X]"":X,1:"NO")
 ;
AIU() ; -- returns whether address updates should print
 NEW X S X=$$VAL^XBDIQ1(44,SC,9999999.4)
 Q $S(X]"":X,1:"NO")
