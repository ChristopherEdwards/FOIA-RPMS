XBKIDS ; IHS/ASDST/GTH - KIDS UTILITIES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
 ; --------------------
 ;
VCHK(XBPRE,XBVER,XBQUIT) ;PEP - For environment check routines.
 ; Pass "PREFIX","Version","XPDQUIT_value".
 ; E.g.:  Q:'$$VCHK^XBKIDS("AG",5.4,2)
 ;  
 NEW XBV
 S XBV=$$VERSION^XPDUTL(XBPRE)
 W !,$$CJ^XLFSTR("Need at least "_XBPRE_" v "_XBVER_"....."_XBPRE_" v "_XBV_" Present",IOM)
 I XBV<XBVER KILL DIFQ S XPDQUIT=XBQUIT W *7,!,$$CJ^XLFSTR("Sorry....",IOM) S XBV=$$DIR^XBDIR("E","Press RETURN") Q 0
 Q 1
 ;
 ; --------------------
 ;
P(XBP) ;PEP - Determine if patch XBP was installed.
 ; XBP must be in standard patch naming format.  E.g. "AG*6.0*13"
 ; ^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ; (#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 ;
 NEW D,DIC,X,XB,Y
 S X=$P(XBP,"*",1),DIC="^DIC(9.4,",DIC(0)="F",D="C"
 D IX^DIC
 I Y<1 Q "PREFIX '"_$P(XBP,"*",1)_"' NOT FOUND IN PACKAGE FILE."
 S XB="^DIC(9.4,"_(+Y)_","
 ;
 KILL D
 S DIC=DIC_+Y_",22,",X=$P(XBP,"*",2)
 D ^DIC
 I Y<1 Q "VERSION '"_$P(XBP,"*",2)_"' NOT FOUND IN PACKAGE FILE."
 S XB=XB_"22,"_(+Y)_","
 ;
 S DIC=DIC_+Y_",""PAH"",",X=$P(XBP,"*",3)
 D ^DIC
 Q $S(Y>0:XB_"""PAH"","_(+Y)_",",1:"PATCH NUMBER '"_$P(XBP,"*",3)_"' NOT FOUND IN PACKAGE FILE.")
 ;
 ; --------------------
 ;
 ; OPTSAV() and OPTRES() are provided b/c if an option of type "menu"
 ; is included in a KIDS transport and install, the existing option
 ; is overwritten, thereby destroying any local modifications.
 ;
 ; Further, if an option of type "menu" is included in a KIDS transport
 ; and install, -all- the options on that option of type "menu" -must-
 ; be included in the KIDS transport, whether they are changed, or not.
 ;
 ; The value of XB2SUB is provided by the calling routine, and has no
 ; particular meaning.
 ;
 ; E.g.:  D OPTSAV^XBKIDS("AGMENU","Cochise")
 ;        D OPTRES^XBKIDS("AGMENU","Cochise")
 ;
OPTSAV(XBM,XB2SUB) ;PEP - Save the menu portion of an option.
 I $D(^XTMP("XBKIDS",XB2SUB,"OPTSAV",XBM)) D BMES^XPDUTL("NOT SAVED.  Option '"_XBM_"' has previously been saved.") Q
 I '$D(^XTMP("XBKIDS")) S ^XTMP("XBKIDS",0)=$$FMADD^XLFDT(DT,30)_U_DT_U_"XBKIDS - SAVE OPTION CONFIGURATIONS."
 NEW I,A
 S I=$O(^DIC(19,"B",XBM,0))
 I 'I D BMES^XPDUTL("NOT SAVED.  Option '"_XBM_"' not found in OPTION file.") Q
 S A=0
 F  S A=$O(^DIC(19,I,10,A)) Q:'A  S ^XTMP("XBKIDS",XB2SUB,"OPTSAV",XBM,A)=$P(^DIC(19,+^DIC(19,I,10,A,0),0),U,1)_U_$P(^DIC(19,I,10,A,0),U,2,3)
 Q
 ;
 ; --------------------
 ;
OPTRES(XBM,XB2SUB) ; PEP - Restore the menu portion of an option.
 NEW XB,XBI
 I '$D(^XTMP("XBKIDS",XB2SUB,"OPTSAV",XBM)) D BMES^XPDUTL("FAILED.  Option '"_XBM_"' was not previously saved.") Q
 S XB=0
 F  S XB=$O(^XTMP("XBKIDS",XB2SUB,"OPTSAV",XBM,XB)) Q:'XB  S XBI=^(XB) I '$$ADD^XPDMENU(XBM,$P(XBI,U,1),$P(XBI,U,2),$P(XBI,U,3)) D BMES^XPDUTL("....FAILED to re-atch "_$P(XBI,U,1)_" to "_XBM_".")
 Q
 ;
