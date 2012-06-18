BSDP13PS ;cmi/anch/maw - PIMS Patch 1013 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1013**;FEB 27,2007;
 ;
 ;
 ;
 ;
ENV ;--environment check
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BJPC*2.0*5") D SORRY(2) Q
 I '$$INSTALLD("PIMS*5.3*1012") D SORRY(2) Q
 Q
 ;
EN ;EP - Post Init Entry Point
 D ADDTS("DAY SURGERY",23,"SURGERY SERVICE","DS")
 D ADDWL("W","WAIT LIST")
 D ADDPRT("BSDAM MENU WAIT LIST","BSDWL PRINT",6,60)
 D ADDMOPT("BSD MENU REPORTS","BSDRM LETTER TRACK BY PATIENT","LETT")
 D RM40971
 D XREFDAM
 Q
 ;
ADDTS(TS,CD,SS,ABB) ;-- add a new treating specialty
 Q:$O(^DIC(45.7,"B",TS,0))
 N FDA,FIENS,FERR,SERV
 S SERV=$O(^DIC(49,"B",SS,0))
 S FIENS="+1,"
 S FDA(45.7,FIENS,.01)=TS
 S FDA(45.7,FIENS,2)=SERV
 S FDA(45.7,FIENS,99)=ABB
 S FDA(45.7,FIENS,9999999.01)=CD
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
ADDWL(CODE,TEXT) ;-- add to waiting list file
 Q:$O(^VA(407.6,"B",CODE,0))
 N FDA,FIENS,FERR
 S FIENS="+1,"
 S FDA(407.6,FIENS,.01)=CODE
 S FDA(407.6,FIENS,1)=TEXT
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
ADDPRT(PROT,PROTA,MN,SQ) ;-- add an entry to the protocol file
 N PROTB,PROTB
 S PROTB=$O(^ORD(101,"B",PROT,0))
 S PROTC=$O(^ORD(101,"B",PROTA,0))
 Q:'PROTB
 Q:'PROTC
 N FDA,FIENS,FERR
 S FIENS="?+2,"_PROTB_","
 S FDA(101.01,FIENS,.01)=PROTC
 S FDA(101.01,FIENS,2)=MN
 S FDA(101.01,FIENS,3)=SQ
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding "_PROTA_" to the Item Multiple of Protocol "_PROT
 Q
 ;
ADDMOPT(MENU,OPT,MNE) ;-- add the menu option to the menu
 N X
 S X=$$ADD^XPDMENU(MENU,OPT,MNE)
 Q
 ;
RM40971 ;-- remove 409.71 from dictionary
 K ^DIC(409.71,0)
 K ^SD(409.71,0)
 Q
 ;
XREFDAM ;-- need to go through each clinic and appt and set date appointment made
 W !,"Now setting AIHSDAM cross reference for Date Appointment Made"
 N BSDC,BSDP,BSDD,BSDAM
 S BSDC=0 F  S BSDC=$O(^SC(BSDC)) Q:'BSDC  D
 . S BSDD=3091231 F  S BSDD=$O(^SC(BSDC,"S",BSDD)) Q:'BSDD  D
 .. S BSDP=0 F  S BSDP=$O(^SC(BSDC,"S",BSDD,1,BSDP)) Q:'BSDP  D
 ... S BSDAM=$P($G(^SC(BSDC,"S",BSDD,1,BSDP,0)),U,7)
 ... Q:'BSDAM
 ... W "."
 ... D XREFC^BSDDAM(BSDC,BSDD,BSDP)
 Q
 ;
INSTALLD(BSDSTAL) ;EP - Determine if patch BJPCSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BSDY,DIC,X,Y
 S X=$P(BSDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BSDSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BSDSTAL,"*",3)
 D ^DIC
 S BSDY=Y
 D IMES
 Q $S(BSDY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BSDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
