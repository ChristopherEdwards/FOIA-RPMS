XBPKDEL1 ; IHS/ADC/GTH - DELETE RETIRED AND REPLACED PACKAGES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**8,9**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH - 12-07-00 - New routine with patch 8.
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Use $GLOBAL.
 ;
 ; DECERT subroutine processes a list of retired/replaced
 ; packages, and gives the user the opportunity to delete all
 ; the package components, the routines, and globals, in the
 ; namspace of the package.
 ;
Q Q
 ; -------------------------------------------------------------
DECERT ;EP - Delete de-certified packages.
 I '$D(^DIC(0)) W !,*7,"Filemanager does not exist in this UCI!" Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 ;
 W @IOF,!!,"You'll be given the opportunity to delete the following packages,",!,"Routines, and Globals in the indicated namespace, in 3 steps."
L1 ;
 W !,"NAMESPACE--DESCRIPTION----------------------------RTNS-----GBLS------"
 ;
 NEW C,G,L,R
 ;
 F C=1:1 S L=$T(KILLEM+C),L=$P(L,";",3) Q:L="###"  D
 . W !,$P(L,"^",1),?11,$P(L,"^",2),?50,$J($$RSEL^ZIBRSEL($P(L,"^",1)_"*"),4),?59,$J($$CG($P(L,"^",1)),4)
 . I $Y>(IOSL-3),$$DIR^XBDIR("E","Press RETURN for the rest of the list") W @IOF
 .Q
 ;
 Q:$G(XBLIST)
 ;
 I '$$DIR^XBDIR("Y","Are you sure you want to continue","NO",$G(DTIME,300)) Q
 ;
 W !!,"There will be 3 steps:"
 W !?10,"1)  Delete package via call to XBPKDEL;"
 W !?10,"2)  Delete Routines (not asked if 0 routines);"
 W !?10,"3)  Delete Globals (not asked if 0 globals)."
 W !,"Of course, your wisdom will be questioned if you do this w/o a full b/u...",!
 ;
 Q:'$$DIR^XBDIR("E")
 ;
 F C=1:1 S L=$T(KILLEM+C),L=$P(L,";",3) Q:L="###"  D  Q:$G(XBPKSTP)
 . W !!,$P(L,"^",1),?11,$P(L,"^",2)
 . S XBPKEY=1,XBPKNSP=$P(L,"^",1)
 . D DEL(XBPKNSP)
 . Q:$G(XBPKSTP)
 . D RTNS(XBPKNSP)
 . Q:$G(XBPKSTP)
 . D GBLS(XBPKNSP)
 . Q:$G(XBPKSTP)
 .Q
 ;
 D EOJ^XBPKDEL
 Q
 ;
 ; -------------------------------------------------------------
DEL(XBPKNSP) ;
 W !,"Deleting the ",XBPKNSP," package components via call to XBPKDEL"
 NEW C,G,L,R
 S XBPKRUN=""
 D ^XBPKDEL
 Q
 ; -------------------------------------------------------------
RTNS(XBPKNSP) ;
 NEW C,G,L,R,XB
 S XB=$$RSEL^ZIBRSEL(XBPKNSP_"*")
 Q:'XB
 I '$$DIR^XBDIR("Y","Delete "_XB_" routines in the "_XBPKNSP_" namespace","NO","","If you answer 'YES', the routines will be deleted") S:X=U XBPKSTP=1 Q
 W !,"Deleting ",XB," ",XBPKNSP," routines",!
 S X=""
 F  S X=$O(^TMP("ZIBRSEL",$J,X)) Q:X=""  W X,$J("",10-$L(X)) X ^%ZOSF("DEL")
 KILL ^TMP("ZIBRSEL",$J)
 Q
 ; -------------------------------------------------------------
GBLS(XBPKNSP) ;
 NEW C,G,L,R,XB
 S XB=$$CG(XBPKNSP)
 Q:'XB
 I '$$DIR^XBDIR("Y","Delete "_XB_" globals in the "_XBPKNSP_" namespace","NO","","If you answer 'YES', the globals will be deleted") S:X=U XBPKSTP=1 Q
 W !,"Kill'ing ",$$CG(XBPKNSP)," ",XBPKNSP," globals",!
 S G="^"_XBPKNSP,L=$L(XBPKNSP)
 ;I '$$KILLOK^ZIBGCHAR(G) KILL @G ;IHS/SET/GTH XB*3*9 10/29/2002
 I '$$KILLOK^ZIBGCHAR(XBPKNSP) KILL @G ;IHS/SET/GTH XB*3*9 10/29/2002
 ;F  S G=$O(@G) Q:'($E(G,1,L)=XBPKNSP)  S G="^"_G W G,$J("",10-$L(G)) D ;IHS/SET/GTH XB*3*9 10/29/2002
 F  S G=$O(^$G(G)) Q:'($E(G,2,L+1)=XBPKNSP)  W G,$J("",10-$L(G)) D  ;IHS/SET/GTH XB*3*9 10/29/2002
 . I '$$KILLOK^ZIBGCHAR($E(G,2,$L(G))) KILL @G Q
 . W !,"<KILL UNSUCCESSFUL>: ",$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($E(G,2,$L(G))))
 .Q
 Q
 ; -------------------------------------------------------------
CG(N) ; Count the globals in the N namespace.    
 NEW C,G,L,R
 S C=0,G="^"_N,L=$L(N)
 I $D(@G) S C=1
 ;F  S G=$O(@G) Q:'($E(G,1,L)=N)  S G="^"_G,C=C+1 ;IHS/SET/GTH XB*3*9 10/29/2002
 F  S G=$O(^$G(G)) Q:'($E(G,2,L+1)=N)  S C=C+1 ;IHS/SET/GTH XB*3*9 10/29/2002
 Q C
 ; -------------------------------------------------------------
LIST ;EP - List retired/replaced packages.
 NEW XBLIST
 S XBLIST=1
 W @IOF
 D L1
 Q
 ; -------------------------------------------------------------
KILLEM ; Add the packages to be deleted, below: Namespace^Description
 ;;AAPC^Ambulatory Patient Care Data Entry
 ;;ACI^Injury Report
 ;;ACHA^Community Health Nursing
 ;;ADB^Diabetic Tracking System
 ;;AMAL^Malpractice Claims
 ;;APCM^PCC Table Maintenance
 ;;AMCP^Women's Health/Pap Smear
 ;;AMR^Management Status
 ;;AMS^Management Referral
 ;;APCQ^PCC Quality Assurance
 ;;APCG^Family Genetic Linkage
 ;;APCR^PCC Register
 ;;APCS^PCC Surveillance
 ;;APCT^PCC Clinic Training
 ;;APHR^Physician Tracking
 ;;ATA^Original Time and Attendance
 ;;ALP^Mainframe to RPMS data insertion
 ;;BRB^Institutional Review Board
 ;;###
 ;
