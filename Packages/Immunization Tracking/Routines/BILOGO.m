BILOGO ;IHS/CMI/MWR - DISPLAY LOGO WHRN ENTERING PKG; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**7**;JAN 15,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  DISPLAYS LOGO.  GETS VERSION FROM LINE 2 OF THIS ROUTINE.
 ;
 D SETVARS^BIUTL5
 ;---> Set Imm Package Version Number.
 S BIVER=$$VER
 ;
 W @IOF
 W !?13,"     .. --- ..         *     *         .. --- .."
 W !?13,"   *          ~ *.      \   /      .* ~          *"
 W !?13," *                *      \ /      *                *"
 W !?13,"(         RPMS      *    (|)    *     Version       )"
 W !?13," *    IMMUNIZATION    *  ***  *         "
 W $$PAD^BIUTL5($$VER,11),"*"
 W !?13,"   *.                   *   *                   .*"
 W !?13,"      *                *     *                *"
 W !?13,"        >              *     *              <"
 W !?13,"       *                *   *                *"
 W !?13,"     *               * *     * *               *"
 W !?13,"    *     @        *   *     *   *        @     *"
 W !?13,"   (             *      *   *      *             )"
 W !?13,"    *.        *          ***          *        .*"
 W !?13,"      / /-- ~             ~             ~ --\ \"
 N X S X="MAIN MENU at "_$P(^DIC(4,DUZ(2),0),U)
 D CENTERT^BIUTL5(.X)
 W !!,X
 Q
 ;
 ;
 ;----------
CHECK ;EP
 ;---> Check User's DUZ(2), BI SITE PARAMETER File for this site,
 ;---> and Standard Vaccine Table (IMMUNIZATION File).
 ;---> Called by ENTRY ACTION of Option BIMENU.
 ;
 ;---> Set Imm Package Version Number.
 S BIVER=$$VER
 ;
 ;---> User's DUZ(2) undefined.
 I '$G(DUZ(2)) D  Q
 .D WARN
 .W !?5,"Your DUZ(2) variable is not defined.",!
 .D TEXT1
 .D DIRZ^BIUTL3()
 ;
 ;
 ;---> BI SITE PARAMETER File not set up for this Site (DUZ(2)).
 I '$D(^BISITE(DUZ(2),0)) D  Q
 .D WARN
 .W !?5,"Immunization Site Parameters have NOT been set for the site"
 .W !?5,"you are logged on as: ",$P(^DIC(4,DUZ(2),0),U),!
 .D TEXT1
 .D:$$MAYMANAG^BIUTL11() TEXT2
 .D DIRZ^BIUTL3()
 ;
 ;
 ;---> Check for valid Immserve Forecasting Rules choice.
 ;---> If not a current, valid choice "IHS_1m18" will be used at RULES+6^BIUTL2.
 D:'$$VALIDRUL^BIUTL2(DUZ(2))
 .D WARN
 .W !?5,"The ImmServe Forecasting site parameter is not currently set to"
 .W !?5,"a valid choice for the site you are logged on to: "
 .W !?5,$P(^DIC(4,DUZ(2),0),U),!
 .I $$MAYMANAG^BIUTL11() D TEXT4,DIRZ^BIUTL3() Q
 .D TEXT5,DIRZ^BIUTL3()
 ;
 ;
 ;---> Vaccine Table (^AUTTIMM global) not standard.
 D CHKSTAND^BIRESTD(.BIERROR)
 Q:$G(BIERROR)=""
 D WARN W !!?5,BIERROR,!
 D TEXT1
 D:$D(^XUSEC("BIZ MANAGER",$G(DUZ))) TEXT3
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
WARN ;EP
 W:$D(IOF) @IOF
 W " "_$$LMVER,!!?35,"WARNING",!?34,"---------",!!
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;At this point you should back out of the Immunization Package
 ;;and contact your site manager or the person in charge of the
 ;;Immunization Software.
 ;;
 D PRINTX("TEXT1",5)
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;Or, if you wish to set up Site Parameters for this site,
 ;;you may proceed to the Edit Site Parameters option and enter
 ;;parameters for this site.  (Menu Synonyms: MGR-->ESP)
 ;;
 D PRINTX("TEXT2",5)
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;Or, you may fix this by Restandardizing the Immunization File.
 ;;To do so, proceed to the Manager Menu and select Restandardize.
 ;;(Menu Synonyms: MGR-->RES)
 ;;
 D PRINTX("TEXT3",5)
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;To correct this problem, go to the Manager Menu, select the
 ;;option "ESP  Site Parameters Edit" and choose parameter 9,
 ;;"Immserve Forecasting Option," then select the Immserve option
 ;;that is most appropriate for your site.
 ;;(Menu Path: IMM-->MGR-->ESP-->9)
 ;;
 ;;Until that parameter is set correctly, forecasting will default
 ;;to Immserve Option #1.
 ;;
 D PRINTX("TEXT4",5)
 Q
 ;
 ;
 ;----------
TEXT5 ;EP
 ;;To correct this problem, notify your immunization coordinator or
 ;;site manager that this site parameter needs attention.
 ;;
 ;;Until that parameter is set correctly, forecasting will default
 ;;to Immserve Option #1.
 ;;
 D PRINTX("TEXT5",5)
 Q
 ;
 ;
 ;----------
VER() ;PEP - Return Version# and Patch Level (if any).
 ;
 N X,Y,Z
 S X=$P($T(BILOGO+1),";;",2)
 S Y=$P(X,";")
 S Z=$P(X,";",3)
 ;---> If no patch level, return version# and quit.
 Q:Z="" Y
 S Z=$TR(Z,"*","")
 Q Y_"*"_$P(Z,",",$L(Z,","))
 ;
 ;
 ;----------
LMVER() ;EP
 ;---> Return "Immunization"_version# for Listman screens,
 ;---> displayed in top left corner.
 ;
 Q " Immunization v"_$$VER
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
