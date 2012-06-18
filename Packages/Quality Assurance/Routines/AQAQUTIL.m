AQAQUTIL ;IHS/ANMC/LJF - CREDENTIALS UTILITY RTN; [ 05/27/92  11:21 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
REVIEW ;EP;***> help text for review med staff functions field
 ;
 W !?10,"This review process includes the following:",!
 W !?15,"Drug Usage Review",?45,"Blood Utilitzation Review"
 W !?15,"Infection Control Review",?45,"Morbidity/Mortality Review"
 W !?15,"Medical Records Review",?45,"Tissue Review"
 W !?15,"Utilization Review",?45,"Peer Review"
 W !?15,"Liability Claims Tracking",?45,"Risk Management Review",!
 Q
 ;
 ;
EMER ;EP;>>> help text for emergency certification prompt
 ;
 W !,"Is this provider CURRENTLY certified in the required"
 W " emergency procedures?"
 W !?15,"For example:",?30,"BLS (Basic Life Support)"
 W !?30,"PALS (Pediatric Advanced Life Support)"
 W !?30,"ACLS (Advanced Cardiac Life Support)"
 W !?30,"ATLS (Advanced Trauma Life Support)"
 W !
 Q
 ;
 ;
KILL ;EP;***> kill statement for options
 ;
 ;***> kill fileman variables
 K C,D,D0,DA,DIC,DIDEL,DIE,DIK,DIQ,DIPGM,DIR,DLAYGO,DR,X,Y
 ;
 ;***> kill non-namespaced variables
 K DFN
 ;
 ;***> kill ztsk variables
 I $D(ZTQUEUED) S ZTREQ="@" Q
 ;
 ;***> kill AQAQ-namespaced variables
 K AQALOOK,AQAQ,AQAQA,AQAQADD
 K AQAQBDT
 K AQAQCAT,AQAQCD,AQAQCDX,AQAQCLS,AQAQCNT
 K AQAQDA,AQAQDEL,AQAQDFN,AQAQDIR,AQAQDR,AQAQDS,AQAQDSD
 K AQAQDT,AQAQDTOT,AQAQDUE,AQAQDUZ,AQAQDX
 K AQAQEDT,AQAQEND,AQAQEX
 K AQAQF,AQAQFAC,AQAQFILE,AQAQFL,AQAQFLD,AQAQFLG
 K AQAQG,AQAQGCT,AQAQGN,AQAQGRP
 K AQAQI,AQAQICD,AQAQICDF,AQAQICDN,AQAQICNT,AQAQICU
 K AQAQH,AQAQHDFN,AQAQJ
 K AQAQLAST,AQAQLIN,AQAQLIN2,AQAQLINE,AQAQLST
 K AQAQMFL,AQAQMS,AQAQMSG
 K AQAQNM,AQAQNOD,AQAQNUM
 K AQAQO,AQAQOPTN,AQAQOPTT
 K AQAQP,AQAQPAGE,AQAQPC,AQAQPCT,AQAQPDFN,AQAQPG
 K AQAQPM,AQAQPN,AQAQPRVC,AQAQPROV,AQAQPRV,AQAQPRVN,AQAQPT,AQAQPTL
 K AQAQR,AQAQRDFN,AQAQRE,AQAQRG,AQAQRNG
 K AQAQS,AQAQSCNT,AQAQSEN,AQAQSF,AQAQSFD,AQAQSFL,AQAQSITE,AQAQSR,AQAQSRT
 K AQAQSRV,AQAQST,AQAQSTOP,AQAQSTR,AQAQSTR1,AQAQSUB,AQAQSV,AQAQS0
 K AQAQTCNT,AQAQTCT,AQAQTICT,AQAQTM,AQAQTMN,AQAQTMP,AQAQTWCT
 K AQAQTOT,AQAQTY,AQAQTYP
 K AQAQV,AQAQVDFN,AQAQVDT,AQAQW,AQAQWCNT
 K AQAQX,AQAQX1,AQAQY,AQAQZ
 ;
 Q
