BDGP1006 ;IHS/OIT/LJF - PRE & POST INSTALL, ENVIRON CHECK FOR PATCH 1006
 ;;5.3;PIMS;**1006**;MAY 28, 2004
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ; now check for patch 1004
 NEW PATCH S PATCH="PIMS*5.3*1005"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;
 ; check for test version of patch 1004
 I $$TEST(PATCH) D  Q
 . W !,"You have a TEST version of "_PATCH_" installed.  Please install the released patch. . ."
 . S XPDQUIT=2
 ;
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
TEST(X) ; return 1 if site is running an iteration version of patch
 NEW IEN
 S IEN=$O(^XPD(9.6,"B",X,0)) I 'IEN Q 1   ;not test version but bad xref
 I $G(^XPD(9.6,IEN,1,1,0))["ITERATION" Q 1
 Q 0
 ;
PRE ;EP;
 Q
 ;
POST ;EP; post install code
 Q
