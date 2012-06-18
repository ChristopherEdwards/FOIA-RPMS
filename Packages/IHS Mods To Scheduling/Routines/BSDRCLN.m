BSDRCLN ;cmi/flag/maw - BSD Print Restricted Clinic List by Division 10/12/2009 2:40:25 PM
 ;;5.3;PIMS;**1011**;FEB 27,2007;
 ;
 ;
 ;
 ;this report will list restricted clinics by division
 Q
 ;
MAIN ;EP - this is the main routine driver
 S BSDDIV=$$GETDIV()
 I '$G(BSDDIV) W !,"You must select a division" D EOJ Q
 D LOOP(.BSDRC,BSDDIV)
 D PRINT(.BSDRC,BSDDIV)
 D EOJ
 Q
 ;
GETDIV() ;-- get the division the user wants
 S DIC("A")="Select DIVISION:"
 D ASK^SDDIV
 I $G(Y)<0 K DIV
 Q $G(DIV)
 ;
LOOP(BSDRC,DV) ;-- loop through the HOSPITAL LOCATION file, screen on DIV and get Restricted Clinic
 N BSDDA,BSDATA,BSDDV,BSDRS,BSDCLN,BSDTYP,BSDINS,BSDTYPI
 S BSDDA=0 F  S BSDDA=$O(^SC(BSDDA)) Q:'BSDDA  D
 . S BSDATA=$G(^SC(BSDDA,0))
 . S BSDDV=$P(BSDATA,U,15)
 . Q:BSDDV'=DV
 . Q:$P($G(^SC(BSDDA,"SDPROT")),U)'="Y"
 . S BSDCLN=$$GET1^DIQ(44,BSDDA,.01)
 . S BSDTYPI=$$GET1^DIQ(44,BSDDA,8,"I")
 . S BSDTYP=$S(BSDTYPI:$P($G(^DIC(40.7,BSDTYPI,0)),U,2),1:"")
 . S BSDINS=$$GET1^DIQ(44,BSDDA,3)
 . S BSDRC(BSDDA)=BSDCLN_U_BSDTYP_U_BSDINS
 Q
 ;
PRINT(RC,DV) ;-- print the report
 D ^%ZIS
 Q:POP
 U IO
 D XHDR(DV)
 N BSDTDA,BSDTDATA,BSDTCLN,BSDTTYP,BSDTINS
 S BSDTDA=0 F  S BSDTDA=$O(RC(BSDTDA)) Q:BSDTDA=""!($D(DIRUT))  D
 . S BSDTDATA=$G(RC(BSDTDA))
 . S BSDTCLN=$P(BSDTDATA,U)
 . S BSDTTYP=$P(BSDTDATA,U,2)
 . S BSDTINS=$P(BSDTDATA,U,3)
 . D:$Y+2>IOSL HDR(DV) Q:$G(DIRUT)
 . W !,BSDTCLN,?35,BSDTTYP,?55,BSDTINS
 Q
 ;
HDR(ID) ;-- do the charge header
 K DIRUT
 I $E(IOST,1,1)="C" S DIR(0)="E" D ^DIR
 I Y=1 D XHDR(ID) Q
 S DIRUT=1
 Q
 ;
XHDR(ID) ;
 W @IOF
 S ID=$$GET1^DIQ(40.8,ID,.01)
 W "Restricted Clinic List by Division: "_ID,?60,"Date:  "_$$FMTE^XLFDT(DT)
 W !!,"Clinic",?35,"Clinic Code",?55,"Institution"
 W !
 F I=1:1:80 W "-"
 Q
 ;
EOJ ;-- kill variables and quit
 D ^%ZISC
 K BSDDIV,BSDRC
 Q
 ;
