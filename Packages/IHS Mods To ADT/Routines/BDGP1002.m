BDGP1002 ;NEW PROGRAM [ 04/06/2005  2:49 PM ]
 ;;5.3;PIMS;**1002**;MAR 24, 2005
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 W !,"** CHECKING ENVIRONMENT **",!!
 NEW BDGREC,VER,X
 S VER=$$VERSION^XPDUTL("PIMS")
 ;
 I VER'=5.3 D                  ;Not v5.3 or 'v' is 5.3t something
 . W !,"You must first install PIMS v5.3"
 .;
 . I VER["t"!(VER["T") D
 ..W !!,"Your site has a 't' version of PIMS loaded -> ",VER
 ..W !,"Please load v5.3 at your earliest convience."
 .;
 . W !!,"And, PIMS v5.3 patch 1 before this patch can be installed",!
 . S XPDQUIT=2
 ;
 ; now check for patch 1001
 S PATCH="PIMS*5.3*1001"
 I '$$PATCH(PATCH) D
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
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
 Q
