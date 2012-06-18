ACPTENV ; IHS/SD/SDR - Environment checker for ACPT V2.07 ; 5/7/2003 2:03:41 PM [ 02/03/2004  12:28 PM ]
 ;;2.07;CPT FILES;**1,2**;DEC 31,2006
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 NEW ACPTQUIT
 S ACPTQUIT=0
 I '$$VCHK("XU","8",2) S ACPTQUIT=2
 ;
 I '$$VCHK("XT","7.3",2) S ACPTQUIT=2
 ;
 I '$$VCHK("DI","21",2) S ACPTQUIT=2
 ;
 ;I '$$VCHK("ACPT","2.06",2) S ACPTQUIT=2  ;acpt*2*07*1
 I '$$VCHK("ACPT","2.07",2) S ACPTQUIT=2  ;acpt*2*07*1
 ;
 NEW DA,DIC
 S X="ACPT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ACPT")) D  S ACPTQUIT=2
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ACPT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 ;
 I ACPTQUIT D SORRY(ACPTQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ACPTPRE,ACPTVER,ACPTQUIT) ; Check versions needed.
 ;  
 NEW ACPTV
 S ACPTV=$$VERSION^XPDUTL(ACPTPRE)
 W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" v "_ACPTV_" Present",IOM)
 I ACPTV<ACPTVER W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
INSTALLD(ACPTINST) ;EP - Determine if patch ACPTINST was installed, where ACPTINST is
 ; the name of the INSTALL.  E.g "AG*6.0*10".
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ;;(#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 NEW DIC,X,Y
 S X=$P(ACPTINST,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(ACPTINST,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACPTINST,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
