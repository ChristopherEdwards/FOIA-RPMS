SCRPPAT ;ALB/CMM - Practitioner's Patients ; 8/30/99 3:17pm [ 11/02/2000  3:12 PM ]
 ;;5.3;Scheduling;**41,52,177**;AUG 13, 1993
 ;IHS/ANMC/LJF 11/02/2000 added call to list template
 ;                        added reset of IOP killed by VALM rtns
 ;                        added title to summary if list template
 ;
 ;Listing of Practitioner's Patients
 ;
PROMPTS ;
 ;Prompt for division, team, role, practitioner, summary only and print device
 ;
 N QTIME,PRNT,VAUTP,Y,VAUTD,VAUTT,VAUTR,VAUTS,SORT,NUMBER
 K SCUP
 S QTIME=""
 W ! D INST^SCRPU1 I Y=-1 G ERR
 W ! K Y D PRMTT^SCRPU1 I '$D(VAUTT) G ERR
 W ! K Y D ROLE^SCRPU1 I '$D(VAUTR) G ERR
 W ! D PRACT^SCRPU1 I '$D(VAUTP) G ERR
 W ! S VAUTS=$$SUMM^SCRPU2() I VAUTS<0 G ERR
 W ! S SORT=$$SORT^SCRPU2() I SORT<1 G ERR
 S PRNT=$$PDEVICE^SCRPU3()
 I PRNT=-1 G ERR
 I PRNT["Q;" S QTIME=$$GETTIME^SCRPU3()
 I QTIME=-1 G ERR
 I PRNT'?1"Q;".E S PRNT="Q;"_PRNT
 S NUMBER=$$ENTRY2(.VAUTD,.VAUTT,.VAUTR,.VAUTP,VAUTS,SORT,PRNT,QTIME)
 I NUMBER>0 W !!,"Print queued, task number: ",NUMBER
 Q
 D QUE(.VAUTD,.VAUTT,.VAUTR,.VAUTP,VAUTS,SORT) Q
 ;
QUE(INST,TEAM,ROLE,PRACT,SUMM,SORT) ;queue report
 ;Input Parameters: 
 ;INST - institutions selected (variable and array) 
 ;TEAM - teams selected (variable and array) 
 ;ROLE - roles selected (variable and array) 
 ;PRACT - practitioners selected (variable and array) 
 ;SUMM - summary info? y/n (1-yes/0-no) yes don't print patient data 
 ;SORT - sort criteria (1-d,t,p/2-d,p,t)
 N ZTSAVE,II
 F II="INST","INST(","TEAM","TEAM(","ROLE","ROLE(","PRACT(","PRACT","SUMM","SORT" S ZTSAVE(II)=""
 W ! D EN^XUTMDEVQ("QENTRY^SCRPPAT","Practitioner's Patients",.ZTSAVE)
 Q
 ;
ENTRY2(INST,TEAM,ROLE,PRACT,SUMM,SORT,IOP,ZTDTH) ;
 ;Second entry point for GUI to use
 ;Input Parameters:
 ;INST - institutions selected (variable and array)
 ;TEAM - teams selected (variable and array)
 ;ROLE - roles selected (variable and array)
 ;PRACT - practitioners selected (ien new person file) - (variable and array)
 ;SUMM - summary info? y/n (1-yes/0-no) yes don't print patient data
 ;SORT - sort criteria (1-d,t,p/2-d,p,t)
 ;IOP - print device
 ;ZTDTH - queue time (optional)
 ;
 ;validate parameters
 I '$D(INST)!'$D(TEAM)!'$D(ROLE)!'$D(PRACT)!'$D(SUMM)!'$D(SORT)!'$D(IOP)!(IOP="") Q
 ;
 N NUMBER
 S IOST=$P(IOP,"^",2),IOP=$P(IOP,"^")
 I IOP?1"Q;".E S IOP=$P(IOP,"Q;",2)
 I IOST?1"C-".E D QENTRY G RET
 I ZTDTH="" S ZTDTH=$H
 S ZTRTN="QENTRY^SCRPPAT"
 S ZTDESC="Practitioner's Patients",ZTIO=IOP
 N II
 F II="IOSL","INST","INST(","TEAM","TEAM(","ROLE","ROLE(","PRACT(","PRACT","SUMM","IOP","SORT" S ZTSAVE(II)=""
 D ^%ZTLOAD
RET S NUMBER=0
 I $D(ZTSK) S NUMBER=ZTSK
 D EXIT1
 Q NUMBER
 ;
QENTRY ;
 I $E(IOST,1,2)="C-" D ^BSDSCPAT Q   ;IHS/ANMC/LJF 11/2/2000
IHS ;EP; entry point for list template  ;IHS/ANMC/LJF 11/2/2000
 ;driver entry point
 S TITL="Practitioner's Patients"
 I SUMM S TITL=TITL_" Summary Report"
 S STORE="^TMP("_$J_",""SCRPPAT"")"
 K @STORE
 S @STORE=0
 D DRIVE^SCRPPAT2
 I $O(@STORE@(0))="" S NODATA=$$NODATA^SCRPU3(TITL)
 I '$D(IOP) S IOP=$P($G(^%ZIS(1,+$O(^%ZIS(1,"C",IO,0)),0)),U)  ;IHS/ANMC/LJF 11/2/2000
 I '$D(NODATA) D PRINTIT(STORE,IOP,TITL,SORT)
 D EXIT2
 Q
 ;
ERR ;
EXIT1 ;
 K ZTDTH,ZTRTN,ZTDESC,ZTSK,ZTIO,ZTSAVE,VAUTD,VAUTT,VAUTP,VAUTR
 K SCUP,VAUTS,SORT
 Q
 ;
EXIT2 ;
 K @STORE
 K STORE,TITL,IOP,PRACT,INST,TEAM,ROLE,SORT,SUMM,NODATA,STOP
 Q
 ;
PRINTIT(STORE,IOP,TITL,SORT) ; Print All Data
 ;STORE - global location of data
 ;IOP - device to print to
 ;TITL - title of report
 ;SORT - sort order 1-div,team,pract/2-div,pract,team
 ;
 N PAGE
 S PAGE=1,STOP=0 W:$E(IOST)="C" @IOF
 N SEC1,SEC2,SEC2,SEC3,SEC4,ST1,ST2,ST3,ST4
 I SORT=1 S SEC1="""T""",SEC2="""P""",SEC3="""TN""",SEC4="""PN"""
 I SORT=2 S SEC1="""P""",SEC2="""T""",SEC3="""PN""",SEC4="""TN"""
 N SEC,TRD,INS,INAME,SECN,TRDN,PT,FIRST
 S (INAME,INS)="",FIRST=1
 F  S INAME=$O(@STORE@("I",INAME)) Q:INAME=""!(STOP)  D
 .S INS=$O(@STORE@("I",INAME,""))
 .Q:INS=""!STOP
 .S SECN="",ST1=$E(STORE,1,($L(STORE)-1))_","_SEC1_")"
 .F  S SECN=$O(@ST1@(INS,SECN)) Q:SECN=""!(STOP)  D
 ..S SEC=$O(@ST1@(INS,SECN,"")) ;ien of team or practitioner
 ..Q:SEC=""
 ..S ST3=$E(STORE,1,($L(STORE)-1))_","_SEC3_")"
 ..S TRDN="",ST2=$E(STORE,1,($L(STORE)-1))_","_SEC2_")"
 ..F  S TRDN=$O(@ST2@(INS,TRDN)) Q:TRDN=""!(STOP)  D
 ...S TRD=$O(@ST2@(INS,TRDN,"")) ;ien of team or practitioner
 ...Q:TRD=""
 ...;have first team and first practitioner ien
 ...S ST4=$E(STORE,1,($L(STORE)-1))_","_SEC4_")"
 ...D PRNT(ST4,ST3,SEC3,.PAGE,TITL,INS,SEC,TRD) Q:STOP
 I $E(IOST)="C",'STOP W ! N DIR S DIR(0)="E" D ^DIR S STOP=Y'=1
 I 'STOP,SUMM=0 S (FIRST,SUMM)=1,TITL=TITL_" Summary Report" W @IOF D PRINTIT(STORE,$G(IOP),TITL,SORT)
 Q
 ;
PRNT(ST4,ST3,SEC3,PAGE,TITL,INS,SEC,TRD) ;
 ;
 N POS
 I (SEC3="""PN""")&($D(@ST3@(INS,SEC,TRD))) D
 .;get each position for practitioner
 .S POS=""
 .F  S POS=$O(@ST3@(INS,SEC,TRD,POS)) Q:POS=""!(STOP)  D
 ..I SUMM D  Q
 ...I FIRST D TITLE^SCRPU3(.PAGE,TITL),SHEAD^SCRPPAT3,SSH S FIRST=0
 ...I (IOST'?1"C-".E),$Y>(IOSL-4) D NEWP1^SCRPU3(.PAGE,TITL) Q:STOP  D SSH
 ...I (IOST?1"C-".E),$Y>(IOSL-6) D HOLD^SCRPU3(.PAGE,TITL) Q:STOP  D SSH
 ...W !,@STORE@("SUM0",INS,SEC,TRD,POS)
 ...W ?72,$J(@STORE@("TOTAL",INS,SEC,TRD,POS),8)
 ...Q
 ..I FIRST D TITLE^SCRPU3(.PAGE,TITL),SHEAD^SCRPPAT3
 ..I (IOST'?1"C-".E),'SUMM,'FIRST D NEWP1^SCRPU3(.PAGE,TITL) W:'STOP !,$G(@STORE@(INS))
 ..I (IOST?1"C-".E),'SUMM,'FIRST D HOLD^SCRPU3(.PAGE,TITL) W:'STOP !,$G(@STORE@(INS))
 ..Q:STOP  S FIRST=0
 ..W !,$G(@ST3@(INS,SEC,TRD,POS)) ;write practitioner (sort 1)
 ..I $L($G(@ST3@(INS,SEC,TRD,POS,"PRCP"))) W !,@ST3@(INS,SEC,TRD,POS,"PRCP")
 ..W !,$G(@ST4@(INS,TRD)) ;write team (sort 2)
 ..W !,$G(@STORE@(INS))
 ..;$o through patients for practitioner on team
 ..D PAT^SCRPPAT3(INS,SEC,TRD,SEC3,ST3,ST4,POS) Q:STOP
 ..I (IOST'?1"C-".E),$Y>(IOSL-4) D NEWP1^SCRPU3(.PAGE,TITL) Q:STOP
 ..I (IOST?1"C-".E),$Y>(IOSL-6) D HOLD^SCRPU3(.PAGE,TITL) Q:STOP
 ..D TOTAL1^SCRPPAT3(INS,SEC,TRD,POS) ;print team/practitioner total
 ;
 I (SEC3="""TN""")&($D(@ST4@(INS,TRD,SEC))) D
 .S POS=""
 .F  S POS=$O(@ST4@(INS,TRD,SEC,POS)) Q:POS=""!(STOP)  D
 ..I SUMM D  Q
 ...I FIRST D TITLE^SCRPU3(.PAGE,TITL),SHEAD^SCRPPAT3,SSH S FIRST=0
 ...I (IOST'?1"C-".E),$Y>(IOSL-4) D NEWP1^SCRPU3(.PAGE,TITL) Q:STOP  D SSH
 ...I (IOST?1"C-".E),$Y>(IOSL-6) D HOLD^SCRPU3(.PAGE,TITL) Q:STOP  D SSH
 ...W !,@STORE@("SUM0",INS,TRD,SEC,POS)
 ...W ?72,$J(@STORE@("TOTAL",INS,TRD,SEC,POS),8)
 ...Q
 ..I FIRST D TITLE^SCRPU3(.PAGE,TITL),SHEAD^SCRPPAT3
 ..I (IOST'?1"C-".E),'SUMM,'FIRST D NEWP1^SCRPU3(.PAGE,TITL)
 ..I (IOST?1"C-".E),'SUMM,'FIRST D HOLD^SCRPU3(.PAGE,TITL)
 ..Q:STOP  S FIRST=0
 ..W !,$G(@ST3@(INS,SEC)) ;write team (sort 1)
 ..W !,$G(@STORE@(INS))
 ..W !,$G(@ST4@(INS,TRD,SEC,POS)) ;write practitioner (sort 2)
 ..I $L($G(@ST4@(INS,TRD,SEC,POS,"PRCP"))) W !,@ST4@(INS,TRD,SEC,POS,"PRCP")
 ..W !
 ..;$o through patients for practitioner on team
 ..D PAT^SCRPPAT3(INS,SEC,TRD,SEC3,ST3,ST4,POS) Q:STOP
 ..I (IOST'?1"C-".E),$Y>(IOSL-4) D NEWP1^SCRPU3(.PAGE,TITL) Q:STOP
 ..I (IOST?1"C-".E),$Y>(IOSL-6) D HOLD^SCRPU3(.PAGE,TITL) Q:STOP
 ..D TOTAL1^SCRPPAT3(INS,SEC,TRD,POS) ;print team/practitioner total
 Q
 ;
SSH ;Summary subheader
 I $G(VALM) W !!,"Report Summary"  ;IHS/ANMC/LJF 11/2/2000
 W !?72,"Patients",!,"Practitioner",?24,"Position",?48,"Team"
 W ?72,"Assigned",! N SCI F SCI=1:1:80 W "="
 Q
