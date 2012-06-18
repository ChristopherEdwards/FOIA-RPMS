BSDP12PS ;cmi/anch/maw - PIMS Patch 1012 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1012**;FEB 27,2007;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D ADDPRT
 Q
 ;
ENV ;--environment check
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BJPC*2.0*4") D SORRY(2) Q
 I '$$INSTALLD("PIMS*5.3*1011") D SORRY(2) Q
 Q
 ;
ADDPRT ;-- add an entry to the protocol file
 N PROT,PROTA
 S PROT=$O(^ORD(101,"B","BSDAM MENU",0))
 S PROTA=$O(^ORD(101,"B","BSDAM FOLLOW UP APPT",0))
 Q:'PROT
 Q:'PROTA
 N FDA,FIENS,FERR
 S FIENS="?+2,"_PROT_","
 S FDA(101.01,FIENS,.01)=PROTA
 S FDA(101.01,FIENS,2)="FU"
 S FDA(101.01,FIENS,3)=37
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding BSD FOLLOW UP APPT to the Item Multiple of Protocol BSDAM MENU"
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
