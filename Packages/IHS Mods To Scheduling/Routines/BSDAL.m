BSDAL ; IHS/ANMC/LJF - IHS APPOINTMENT LIST ; 
 ;;5.3;PIMS;**1007,1011**;FEB 27, 2007
 ;IHS version of SDAL
 ;
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added code in EN for item 1007.02
 ;cmi/flag/maw 10/05/2009 PATCH 1011 added code in EN for item 1011.73
 ;
EN NEW SDCONC,VAUTC,VAUTD,BSDD,BSDWI,BSDCR,BSDAMB,BSDPH,BSDPCMM,BSDCOPY
 N BSDCC  ;cmi/anch/maw 11/3/2006 added for current community item 1007.02 patch 1007
 S SDCONC="B" D CLINIC^BSDU(1) I $D(BSDQ) Q
 ;
 ;S BSDD=$$READ^BDGF("D^::EX","For Date","TODAY") I BSDD<1 Q  cmi/maw 10/5/2009 PATCH 1011 orig line
 N BSDTODAY,BSDDIR
 S BSDTODAY="TODAY",BSDDIR="D^::EX"
 F I=1:1 D  Q:BSDD<1
 . I I>1 S BSDTODAY="",BSDDIR="DO^::EX"
 . S BSDD=$$READ^BDGF(BSDDIR,"For Date",BSDTODAY) I BSDD<1 Q
 . S BSDD(BSDD)=BSDD
 I BSDD=U Q
 ;cmi/maw 10/5/2009 PATCH 1011 RQMT73 add additional dates
 ;
 S BSDWI=$$READ^BDGF("Y","Include Walk-Ins","YES","If you answer YES, walk-ins will print.")
 I (BSDWI=U)!(BSDWI="") Q
 ;
 S BSDAMB=0 I '$$RESVIEW!$D(^XUSEC("SDZSUP",DUZ)) D
 . S BSDAMB=$$READ^BDGF("Y","Include Who Made Appt","NO")
 I (BSDAMB=U)!(BSDAMB="") Q
 ;
 S BSDPH=$$READ^BDGF("Y","Include Patient's Phone #","NO")
 I (BSDPH=U)!(BSDPH="") Q
 ;
 S BSDPCMM=$$READ^BDGF("Y","Include Primary Care Information","NO","If you answer YES, the patient's primary care provider and team affiliations will be displayed.")
 I (BSDPCMM=U)!(BSDPCMM="") Q
 ;
 ;cmi/anch/maw 11/3/2006 added option for current community item 1007.02 patch 1007
 S BSDCC=$$READ^BDGF("Y","Include Current Community","NO")
 I (BSDCC=U)!(BSDCC="") Q
 ;cmi/anch/maw end of item 1007.02 patch 1007
 ;
 S BSDCR=$$READ^BDGF("Y","Include Chart Requests","NO","If you answer YES, chart requests will be listed at the end of the report.")
 I (BSDCR=U)!(BSDCR="") Q
 ;
 S Y=$$BROWSE^BDGF I (Y=U)!(Y="") Q
 I Y="B" D EN^BSDALL Q
 ;
 S BSDCOPY=$$READ^BDGF("N^1:10","Number of Copies",1)
 I (BSDCOPY=U)!(BSDCOPY="") Q
 ;
 S X="VAUTD*"_";"_"VAUTC*"_";"_"BSD*"
 D ZIS^BDGF("QP","EN^BSDALL","Appointment List",X)
 D HOME^%ZIS
 Q
 ;
 ;
RESVIEW() ; -- returns 1 if restrict viewing of who made appt turned on
 Q +$$GET1^DIQ(9009020.2,$$DIV^BSDU,.12,"I")
