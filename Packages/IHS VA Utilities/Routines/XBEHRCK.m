XBEHRCK ;IHS/SET/GTH - EHR ENVIRONMENT CHECK ; [ 05/11/2004 ]
 ;;1.0;IHS ELECTRONIC HEALTH RECORD;;May 12, 2004
 ;
 ; To add to the list of requirements, add the info specific to the
 ; application after the "ENV" label, below in the form:
 ;           Namespace*Version*Patch
 ; E.g., to check for Pt Reg, v 6.1, patch 2:
 ;           AG*6.1*2
 ; If the application has no patches, leave the patch info blank.
 ; 20040512d
 ; 20040603 IHS/SET/HMW Added checks for Pharmacy Data Management
 ; 20040615 Changed ABSP to check for patch 10 instead of 8
 ; 20040708 Removed SD patch   63
 ; 20040719 Removed SD Patches 300 307 314
 ; 			Removed HL Patches 17 18 21 8 9
 ; 			Removed GMTS Patch 45
 ; 			Removed ABSP Patch 10
 ; 			Removed APSE 6.1
 ;
ENV ; Namespace*Version*Patch
 ;;XU*8.0*1010
 ;;XU*8.0*2
 ;;XU*8.0*15
 ;;XU*8.0*16
 ;;XU*8.0*26
 ;;XU*8.0*28
 ;;XU*8.0*32
 ;;XU*8.0*44
 ;;XU*8.0*311
 ;;XU*8.0*288
 ;;XT*7.3*1002
 ;;XT*7.3*73
 ;;DI*22.0*1001
 ;;DI*22.0*70
 ;;HL*1.6*1005
 ;;PSO*6.0*5
 ;;APSA*6.1
 ;;AUPN*99.1*11
 ;;LEX*2*9
 ;;VSIT*2
 ;;PX*1*45
 ;;PX*1*73
 ;;PX*1*74
 ;;PX*1*88
 ;;PX*1*115
 ;;PXRM*1.5*1
 ;;PXRM*1.5*2
 ;;PXRM*1.5*3
 ;;PXRM*1.5*4
 ;;PXRM*1.5*5
 ;;PXRM*1.5*6
 ;;PXRM*1.5*7
 ;;PXRM*1.5*8
 ;;PXRM*1.5*9
 ;;PXRM*1.5*10
 ;;PXRM*1.5*11
 ;;PXRM*1.5*13
 ;;PXRM*1.5*14
 ;;PXRM*1.5*17
 ;;PXRM*1.5*15
 ;;PXRM*1.5*19
 ;;GMTS*2.7*36
 ;;GMTS*2.7*43
 ;;GMTS*2.7*52
 ;;GMTS*2.7*60
 ;;GMTS*2.7*62
 ;;GMTS*2.7*64
 ;;GMTS*2.7*68
 ;;PIMS*5.3T11
 ;;DG*5.3*124
 ;;DG*5.3*57
 ;;DG*5.3*134
 ;;DG*5.3*249
 ;;DG*5.3*265
 ;;DG*5.3*276
 ;;DG*5.3*277
 ;;DG*5.3*389
 ;;DG*5.3*415
 ;;SD*5.3*131 SEQ #127
 ;;SD*5.3*263 SEQ #243
 ;;SD*5.3*254 SEQ #247
 ;;USR*1.0
 ;;TIU*1.0*1 SEQ #4
 ;;TIU*1.0*3 SEQ #5
 ;;TIU*1.0*4 SEQ #8
 ;;TIU*1.0*7 SEQ #9
 ;;TIU*1.0*15 SEQ #10
 ;;TIU*1.0*19 SEQ #19
 ;;TIU*1.0*28 SEQ #22
 ;;TIU*1.0*31 SEQ #34
 ;;TIU*1.0*47 SEQ #60
 ;;TIU*1.0*76 SEQ #70
 ;;TIU*1.0*80 SEQ #82
 ;;TIU*1.0*102 SEQ #86
 ;;TIU*1.0*89 SEQ #90
 ;;TIU*1.0*108 SEQ #99
 ;;TIU*1.0*170
 ;;TIU*1.0*150 SEQ #142
 ;;TIU*1.0*100 SEQ #103
 ;;TIU*1.0*105 SEQ #106
 ;;TIU*1.0*119 SEQ #109
 ;;TIU*1.0*125 SEQ #113
 ;;TIU*1.0*127 SEQ #118
 ;;TIU*1.0*122 SEQ #119
 ;;TIU*1.0*124 SEQ #124
 ;;TIU*1.0*138 SEQ #125
 ;;TIU*1.0*63 SEQ #76
 ;;TIU*1.0*137
 ;;TIU*1.0*134
 ;;TIU*1.0*109 SEQ #123
 ;;LR*5.2*1018
 ;;LR*5.2*128
 ;;LR*5.2*121
 ;;LR*5.2*201
 ;;LR*5.2*191
 ;;LR*5.2*208
 ;;RA*5.0
 ;;PSJ*4.5
 ;;BW*2.0
 ;;BW*2.0*9
 ;;XWB*1.1*6
 ;;XWB*1.1*12
 ;;END;  <-- Leave this alone.  It's the LOOP ender.
 ; -----------------------------------------------------
 ;
 ; begin - FOR TEST ONLY REMOVE FOR DIST.
 ;I '$G(DUZ) D
 ;. KILL
 ;. KILL ^XUTL("XQ",$J)
 ;. D HOME^%ZIS,DT^DICRW,^XBKTMP
 ;. S DUZ=1,DUZ(2)=$P(^AUTTSITE(1,0),U)
 ;.Q
 ; end - FOR TEST ONLY REMOVE FOR DIST.
 ;
 I '$G(DUZ) D RSLT(""),RSLT("Please set your DUZ before running this routine.") Q
 D DT^DICRW,^XBKVAR
 D ASKDEV Q:POP
 Q:$D(ZTQUEUED)
 ;
ZTM ;EP - Taskman entry point
 KILL ^TMP("XBEHRCK",$J)
 NEW XBEH,XBEHNEED,XBEHOK
 N XBEHNS,XBEHNAME,XBEHVER,XBEHPKG,XBEHC
 U IO
 S XBEHOK=1,XBEHC=0
 S XBEHPKG=""
 S X=$P(^VA(200,DUZ,0),U)
 ;
 D RSLT(""),RSLT("Hello, "_$P(X,",",2)_" "_$P(X,","))
 D RSLT(""),RSLT("Environment Checker for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", as of "_$P($T(+2),";",6)_".")
 ;
 F XBEH=1:1 Q:$P($T(ENV+XBEH),";",3)="END"  D
 . S XBEH(0)=$P($T(ENV+XBEH),";",3)
 . S XBEHNS=$P(XBEH(0),"*")
 . Q:XBEHNS=""
 . S XBEHVER=$P(XBEH(0),"*",2)
 . S XBEHNAME=$O(^DIC(9.4,"C",XBEHNS,0))
 . S:XBEHNAME]"" XBEHNAME=$G(^DIC(9.4,XBEHNAME,0))
 . S:XBEHNAME]"" XBEHNAME=$P(XBEHNAME,U)
 . D VCHK(XBEHNS,XBEHVER,XBEHNAME)
 . D RSLT("")
 . Q
 ;
 D RXCK
 D RSLT(""),RSLT("ENVIRONMENT "_$S(XBEHOK:"",1:"-NOT- ")_"OK.")
 I 'XBEHOK D
 . D RSLT("INSTALL THE FOLLOWING PACKAGES AND PATCHES:")
 . S XBEHNEED=""
 . F  S XBEHNEED=$O(XBEHNEED(XBEHNEED)) Q:'$L(XBEHNEED)  D RSLT(XBEHNEED)
 .Q
 ;
 D POST
 ;
 Q
RXCK ;
 ;
 N PS S PS=$P($G(^PS(59.7,1,80)),U,2)
 I 'PS D
 . S XBEHMSG="The Pharmacy Data Management package must be installed, and the Orderable Item Auto Create run to completion."
 . D RSLT(XBEHMSG)
 . S XBEHNEED("Pharmacy Data Management")=""
 I PS=1 D
 . S XBEHMSG="The Orderable Item Auto Create in Pharmacy Data Management package must be run to completion."
 . D RSLT(XBEHMSG)
 . S XBEHNEED("Pharmacy Data Management Orderable Item Auto Create")=""
 I PS=2 D
 . S XBEHMSG="The Manual Matching Process for Orderable Items in Pharmacy Data Management package has not been completed."
 . D RSLT(XBEHMSG)
 . S XBEHNEED("Pharmacy Data Management Manual Matching Process must be completed.")=""
 I $P($G(^PS(59.7,1,80)),"^",3)'=3 D
 . S XBEHMSG="Pharmacy Dosage Conversion is not complete."
 . D RSLT(XBEHMSG)
 . S XBEHNEED("Pharmacy Dosage Conversion must be completed.")=""
 Q
 ;
VCHK(XBEHPRE,XBEHVER,XBEHNAME) ; -----------------------------------------------------
 ; Check versions needed.
 ; Modifies XBEHNEED
 ;  
 NEW XBEHV,XBEHMSG
 I XBEHNAME'=XBEHPKG D
 . D RSLT("")
 . S XBEHPKG=XBEHNAME
 . S XBEHV=$$VERSION^XPDUTL(XBEHPRE)
 . S XBEHMSG=XBEHNAME_$S(XBEHNAME]"":":",1:"")_"  Need at least "_XBEHPRE_" v "_XBEHVER
 . I +XBEHV S XBEHMSG=XBEHMSG_"....."_XBEHPRE_" v "_XBEHV_" is installed."
 . E  S XBEHMSG=XBEHMSG_"....."_XBEHPRE_" is not installed."
 . D RSLT(XBEHMSG)
 . I XBEHV<XBEHVER D  Q
 . . S XBEHOK=0,XBEHMSG=""
 . . S XBEHMSG=$S(+XBEHV:"Upgrade ",1:"Install ")
 . . S XBEHMSG="      "_XBEHMSG_XBEHPRE_" v "_XBEHVER_"."
 . . D RSLT(XBEHMSG)
 . . S XBEHNEED(XBEH(0))=""
 . .Q
 Q:'$P(XBEH(0),"*",3)
 D PCHK(XBEH(0))
 Q
 ;
PCHK(XBEH) ; -----------------------------------------------------
 ; Determine if patch XBEH was installed, where XBEH is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 D RSLT("   Need Patch '"_XBEH)
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(XBEH,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D  Q
 . D RSLT("     Failed lookup for Namespace '"_X_"' in PACKAGE file.")
 . S XBEHOK=0,XBEHNEED(XBEH)=""
 . D DUPCHK(X)
 .Q
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(XBEH,"*",2)
 D ^DIC
 I Y<1 D RSLT("     Failed lookup for version '"_X_"' in PACKAGE file.") S XBEHOK=0,XBEHNEED(XBEH)="" Q
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(XBEH,"*",3)
 D ^DIC
 I Y<1 D RSLT("     Failed lookup for patch '"_X_"' in PACKAGE file.") S XBEHOK=0,XBEHNEED(XBEH)="" Q
 D RSLT("     Patch '"_XBEH_"' IS installed.")
 Q
DUPCHK(X) ; -----------------------------------------------------
 ; Check PACKAGE file for duplicate entries of namespace X.
 ;
 NEW DA,DIC
 S DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 Q:Y>0
 Q:'$D(^DIC(9.4,"C",X))
 D RSLT("     You Have More Than One Entry In The")
 D RSLT("     PACKAGE File with an "_X_" prefix.")
 D RSLT("     One entry needs to be deleted.")
 Q
POST ; -----------------------------------------------------
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""XBEHRCK"",$J,",XMY(1)="",XMY(DUZ)=""
 D SINGLE("XUPROGMODE")
 NEW DIFROM
 D ^XMD
 KILL ^TMP("XBEHRCK",$J)
 D RSLT("")
 D RSLT("The results are in your MailMan 'IN' basket.")
 Q
 ; -----------------------------------------------------
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ; -----------------------------------------------------
RSLT(%) ;S ^(0)=$G(^TMP("XBEHRCK",$J,0))+1,^(^(0))=%
 ;More readable:
 S ^TMP("XBEHRCK",$J,0)=$G(^TMP("XBEHRCK",$J,0))+1
 S ^TMP("XBEHRCK",$J,^TMP("XBEHRCK",$J,0))=%
 W !,%
 Q
 ;
ASKDEV ;EP
 K IOP
 S %ZIS="NQ" D ^%ZIS Q:POP
 S IOP=ION
 S %ZIS("IOPAR")=IOPAR
 I $D(IO("Q")) D QUE I '$D(ZTQUEUED) K IOP G ASKDEV
 I $D(IO("Q")) D HOME^%ZIS W !,"REPORT IS QUEUED!"
 Q
 ;
QUE ;
 S ZTRTN="ZTM^XBEHRCK",ZTDESC="EHR ENVIRONMENT CHECK"
 S ZTSAVE("IOP")=""
 D ^%ZTLOAD
 Q
