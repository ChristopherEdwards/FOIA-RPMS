SDCO5 ;ALB/RMO - Make Clinic Appt - Check Out;08 DEC 1992 4:05 pm [ 08/20/2004  4:07 PM ]
 ;;5.3;Scheduling;**27,1001,1012**;08/13/93
 ;
 ;cmi/flag/maw 06/08/2010 PATCH 1012 RQMT147 added follow up indicator
 ;
MC(SDOE,SDASKF,SDCOMKF,SDCOQUIT) ;Entry point for SDCO CLINIC APPT protocol
 ; Input  -- SDOE     Outpatient Encounter file IEN
 ;           SDASKF   Ask if user wishes to make an appt
 ; Output -- SDCOMKF  User Makes an Appointment
 ;                    1=Yes
 ;           SDCOQUIT User entered '^' or timeout
 N DFN,DIRUT,SDAMERR,SDCL,SDCLN,SDDA,SDFN,SDOE0,SDSC,SDT
 S VALMBCK=""
 I '$G(^SCE(+SDOE,0)) G MCQ   ;IHS/ITSC/LJF 5/20/2004 in case OP Encounter never created:PATCH #1001
 ;
 I $G(SDASKF),'$$ASK S:$D(DIRUT) SDCOQUIT="" G MCQ
 I $G(SDASKF) S BSDSRFU=1  ;cmi/maw 6/8/2010 PATCH 1012 follow up indicator
 S SDOE0=$G(^SCE(+SDOE,0)),SDFN=+$P(SDOE0,"^",2)
 I $P(SDOE0,U,4),$P(SDOE0,U,8)'=3 S SDCLN=+$P(SDOE0,"^",4)
 ;
 K SDCLN      ;IHS/ITSC/LJF 5/20/2004 make s/w ask for clinic; PATCH #1001
 ;
 D FULL^VALM1
 D ^SDM
 I $D(SDAMERR) D PAUSE^VALM1
 I '$D(SDAMERR) S SDCOMKF=1
 D SDM^SDKILL S VALMBCK="R"
MCQ Q
 ;
ASK() ;Ask if user wishes to make an appt
 N DIR,DTOUT,DUOUT,Y
 S DIR("A")="Do you wish to make a follow-up appointment"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR
 Q +$G(Y)
