SCRPEC ;ALB/CMM - Detail List of Pts & Enroll Clinics ; 29 Jun 99  04:11PM [ 11/02/2000  7:14 AM ]
 ;;5.3;Scheduling;**41,140,174,177**;AUG 13, 1993
 ;IHS/ANMC/LJF 10/26/2000 changed 132 column message
 ;                        added call to list template
 ;                        changed patient ID to HRCN
 ;             11/01/2000 used IHS code for get next/last appts
 ;                        used all clinics within a team
 ;
 ;Detailed Listing of Patients and Their Enrolled Clinics Report
 ;
PROMPTS ;
 ;Prompt for Institution, Team, Clinic, Assigned or Unassigned to Primary
 ;Care, and Print device
 ;
 N VAUTD,VAUTT,VAUTC,VAUTA,QTIME,PRNT
 K VAUTD,VAUTT,VAUTC,VAUTA,VAUTCA,SCUP
 S QTIME=""
 W ! D INST^SCRPU1 I Y=-1 G ERR
 W ! K Y D PRMTT^SCRPU1 I '$D(VAUTT) G ERR
 ;S VAUTCA="" ;allows for selection of any clinic in one of the selected divisions
 ;W ! K Y D CLINIC^SCRPU1 I '$D(VAUTC) G ERR  ;IHS/ANMC/LJF 11/1/2000
 S VAUTC=1  ;IHS/ANMC/LJF 11/1/2000 use all clinics within team
 W ! K Y D ASSUN^SCRPU2 I '$D(VAUTA) G ERR
 ;W !!,"This report requires 132 column output!"  ;IHS/ANMC/LJF 10/26/2000
 W !!,"This report, when printed on paper, requires wide paper or condensed print!"  ;IHS/ANMC/LJF 10/26/2000
 D QUE(.VAUTD,.VAUTT,.VAUTC,.VAUTA) Q
 ;
QUE(INST,TEAM,CLINIC,ASSUN) ;queue report
 ;Input Parameters: 
 ;INST - institutions selected (variable and array) 
 ;TEAM - teams selected (variable and array) 
 ;CLINIC - clinics selected (variable and array) 
 ;ASSUN - Assigned or Unassigned to PC
 N ZTSAVE,II
 F II="INST","TEAM","CLINIC","ASSUN","INST(","TEAM(","CLINIC(" S ZTSAVE(II)=""
 W ! D EN^XUTMDEVQ("QENTRY^SCRPEC","Detailed Patient Enrollments",.ZTSAVE)
 Q
 ;
ENTRY2(INST,TEAM,CLINIC,ASSUN,IOP,ZTDTH) ;
 ;Second entry point for GUI to use
 ;Input Parameters:
 ;INST - institutions selected (variable and array)
 ;TEAM - teams selected (variable and array)
 ;CLINIC - clinics selected (variable and array)
 ;ASSUN - Assigned or Unassigned to PC
 ;IOP - print device
 ;ZTDTH - queue time (optional)
 ;
 ;validate parameters
 I '$D(INST)!'$D(TEAM)!'$D(CLINIC)!'$D(ASSUN)!'$D(IOP)!(IOP="") Q
 ;
 N NUMBER
 S IOST=$P(IOP,"^",2),IOP=$P(IOP,"^")
 I IOP?1"Q;".E S IOP=$P(IOP,"Q;",2)
 I IOST?1"C-".E D QENTRY G RET
 I ZTDTH="" S ZTDTH=$H
 S ZTRTN="QENTRY^SCRPEC"
 S ZTDESC="Detailed Patient List & Enrolled Clinics",ZTIO=IOP
 N II
 F II="INST","TEAM","CLINIC","ASSUN","INST(","TEAM(","CLINIC(","IOP" S ZTSAVE(II)=""
 D ^%ZTLOAD
RET S NUMBER=0
 I $D(ZTSK) S NUMBER=ZTSK
 D EXIT1
 Q NUMBER
 ;
QENTRY ;
 ;driver entry point
 I $E(IOST,1,2)="C-" D EN^BSDSCEC Q  ;IHS/ANMC/LJF 10/26/2000
IHS ;EP; entry point for list template  ;IHS/ANMC/LJF 10/26/2000
 S VAUTTN=""
 S TITL="Detailed Patient Assignments - "_$S(ASSUN=1:"Assigned PC",1:"Not Assigned PC")
 S STORE="^TMP("_$J_",""SCRPEC"")"
 K @STORE
 S @STORE=0
 D FIND^SCRPEC3
 I $O(@STORE@(0))="" S NODATA=$$NODATA^SCRPU3(TITL)
 I '$D(NODATA) D HEADER^SCRPEC2,PRINTIT^SCRPEC3(STORE,TITL)
 D EXIT2
 Q
 ;
ERR ;
EXIT1 ;
 K ZTSAVE,ZTSK,ZTIO,ZTDTH,ZTRTN,ZTDESC,VAUTCA,SCUP
 Q
EXIT2 ;
 K @STORE
 K STORE,VAUTTN,PAGE,TITL,IOP,TITL,NODATA,CLINIC,ASSUN,INST,TEAM,STOP
 Q
 ;
PDATA(DFN,CLNEN,FLAG) ;
 ;Collect and format data for report
 ;
 N NODE,NAME,PID,PELIG,MT,PSTAT,STATD,DATA,LAST,NEXT,CEN,CNAME
 S DATA=""
 S NODE=$G(^DPT(DFN,0))
 S NAME=$P(NODE,"^") ;patient name
 S PID=$P($G(^DPT(DFN,.36)),"^",3),PID=$TR(PID,"-","") ;PID without '-'s
 S PID=$$HRCN^BDGF2(DFN,+$G(DUZ(2)))  ;IHS/ANMC/LJF 10/26/2000
 D MNTEST^SCUTBK10(.MT,DFN) S MT=$P(MT,"^",4) ;means test category
 S PELIG=$$ELIG^SCRPU3(DFN) ;primary eligibility
 ;
 S CNAME=$P($G(^SC(CLNEN,0)),"^")
 S CEN=+$O(^DPT(DFN,"DE","B",CLNEN,""))
 S NODE=$G(^DPT(DFN,"DE",CEN,1,1,0))
 S PSTAT=$P(NODE,"^",2) S PSTAT=PSTAT_$S(PSTAT="A":"C",PSTAT="O":"PT",1:"") ;opt or ac status
 I $P(NODE,"^")="" S STATD=""
 I $P(NODE,"^")'="" S STATD=$TR($$FMTE^XLFDT($P(NODE,"^"),"5DF")," ","0") ;enrollment date
 ;S LAST=$$GETLAST^SCRPU3(DFN,CLNEN) ;last clinic appointment
 ;S NEXT=$$GETNEXT^SCRPU3(DFN,CLNEN) ;next clinic appointment
 S LAST=$$GETAPPT^BSDSCEC(DFN,TIEN,"LAST")  ;IHS/ANMC/LJF 11/1/2000
 S NEXT=$$GETAPPT^BSDSCEC(DFN,TIEN,"NEXT")  ;IHS/ANMC/LJF 11/1/2000
 I '$D(FLAG) S DATA=$$FORMAT^SCRPEC2(NAME,PID,MT,PELIG,PSTAT,STATD,LAST,NEXT,CNAME),DATA=$E(NAME,1,20)_"^"_DATA
 I $D(FLAG) S DATA=$E(NAME,1,20)_"^"_PID_"^"_MT_"^"_PELIG_"^"_PSTAT_"^"_STATD_"^"_LAST_"^"_NEXT
 Q DATA
 ;
