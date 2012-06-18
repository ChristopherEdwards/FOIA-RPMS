BHSP5 ; IHS/MSC/MGH - PRE-INSTALL ROUTINE FOR BHS PATCH 5 ;11-Nov-2010 12:11;DU
 ;;1.0;HEALTH SUMMARY COMPONENTS;**5**;March 17, 2006;Build 9
 ;
ENV ;EP; environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released version added
 NEW IEN,PKG S PKG="HEALTH SUMMARY COMPONENTS 1.0",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"." S XPDQUIT=2 Q
 ;
 ;
 ;Check for the installation of other patches
 S PATCH="BHS*1.0*4"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="GMRA*4.0*1002"
 I '$$PATCH(PATCH) D Q
 .W !,"You must first inatll "_PATCH_"." S XPDQUIT=2
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
