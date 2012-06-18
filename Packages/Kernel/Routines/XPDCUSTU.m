XPDCUSTU ;SLC/STAFF-SITE TRACKING UPDATE ALL VERSIONS, UTILITY ;7/20/94  15:38 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;7.1;Kernel;**22,35**;Oct 25, 1993
 ;
VERSION ; from XPDCUSTP
 ; return version and date of package
 N IFN
 ;
 S IFN=+$O(^DIC(9.4,"B",PACKAGE,0))
 S VERSION=$G(^DIC(9.4,IFN,"VERSION"))
 S DATE=$$DATE(IFN,VERSION)
 S ROUTINES=$P(^TMP("XPDCUP",$J,PACKAGE),U,4) I '$L(ROUTINES) Q
 S ROUTINE="" F CNT=1:1 S ROUTINE=$P(ROUTINES,",",CNT) Q:ROUTINE=""  D
 .S VERSION=$$MAX(VERSION,$$VER(ROUTINE))
 ; if package installed but no 'CURRENT VERSION' in Package file
 I VERSION,'DATE S DATE=$$DATE(IFN,VERSION)
 I 'DATE,VERSION,VERSION'[".",VERSION=+VERSION S VERSION=VERSION_".0",DATE=$$DATE(IFN,VERSION)
 Q
 ;
DATE(IFN,VERSION) ; $$(package ifn,version) -> date of install
 N IFN1
 ;
 I 'VERSION Q ""
 S IFN1=+$O(^DIC(9.4,IFN,22,"B",VERSION,0))
 Q $P($G(^DIC(9.4,IFN,22,IFN1,0)),U,3)
 ;
VER(ROUTINE) ; $$(routine) -> version #
 N STRIP,VER
 ;
 ; get version # from 2nd line of routine
 I '$L(ROUTINE) Q ""
 S VER=$P($T(@ROUTINE+1^@ROUTINE),";",3) I '$L(VER) Q ""
 ;
 ; strip spaces and text from version #
 F  Q:$E(VER)'=" "  S VER=$E(VER,2,245)
 F STRIP="VERSION","Version","version","V","v" I $E(VER,1,$L(STRIP))=STRIP S VER=$E(VER,$L(STRIP)+1,$L(VER)) Q
 F  Q:$E(VER)'=" "  S VER=$E(VER,2,245)
 Q $P(VER," ")
 ;
MAX(V1,V2) ; $$(version1,version2) -> highest version #
 I V1=V2 Q V1
 I +V1>+V2 Q V1
 I +V2>+V1 Q V2
 I V1'?.NP,V1?.ANP,V2?.NP Q V2 ;version1 is test, version2 is verified
 I V2'?.NP,V2?.ANP,V1?.NP Q V1 ;version2 is test, version1 is verified
 I V1?.NP,V2?.NP Q $S($L(V1)>$L(V2):V1,1:V2) ;ex. 4.0 vs 4
 I V1["T",V2["V" Q V2 ;test vs verify
 I V1["V",V2["T" Q V1 ;" "
 I V1["T",V2["T" Q $S(+$P(V1,"T",2)>+$P(V2,"T",2):V1,1:V2) ;highest test
 I V1["V",V2["V" Q $S(+$P(V1,"V",2)>+$P(V2,"V",2):V1,1:V2) ;highest verify
 Q V1 ;give up
