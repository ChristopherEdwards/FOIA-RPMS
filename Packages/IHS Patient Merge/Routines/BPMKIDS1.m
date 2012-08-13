BPMKIDS1 ;IHS/OIT/ENM - BPM PATCH 1 PRE INSTALL & ENVIRON CHECK
 ;;1.0;IHS PATIENT MERGE;**1**;JUL 12, 2011
 ;
CKENV ; environment check code
 N X
 S X="BPMXDRV" X ^%ZOSF("TEST")
 I '$T W !,"Patient Merge v1.0 MUST be installed!" S XPDQUIT=1
 ;
 ;IHS/DIT/ENM - Check if EDR loaded
 ;S X="BADEMRG" X ^%ZOSF("TEST")
 ;I '$T W !,"Electronic Dental Record MUST be installed!" S XPDQUIT=1
 D ENV ;DUZ VARIABLE CHECK
 Q
ENV ;Environment check
 ;I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"YOUR DUZ VARIABLE IS UNDEFINED!! Please login with your Access & Verify." S XPDQUIT=1 Q
 ;
 I '$L($G(DUZ(0))) W !,"Your DUZ(0) VARIABLE IS UNDEFINED OR NULL." S XPDQUIT=1 Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"YOUR DUZ(0) VARIABLE DOES NOT CONTAIN AN '@'." S XPDQUIT=1
 Q
