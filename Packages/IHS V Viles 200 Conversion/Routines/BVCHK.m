BVCHK ; IHS/ITSC/JDH - check field values in files 3,6,16 & 200 
 ;;2.0;IHS V FILES 200 CONVERSION;;MAR 29, 2002
 ;
 W !!,"This routine can not be called from the top",!!
 Q
 ;
EN ;EP non setting, checks file status only;
 I $D(^BVCONV(1,"RUNNING")) W !,"The conversion is in progress, Please do not run this routine."
 I $G(DUZ(0))'["@" W !!,"You must have fileman programmer access to run this routine.",!! Q
 Q:$$DEV
EN1 N BVC3,BVC6,BVC16,BVCDA,BVCDAFH,BVCDAFR,BVCDAH,BVCDATA,BVCERH,BVCERMS,BVCERNM,BVCFDFR,BVCFDH,BVCFDNM,BVCFDTO,BVCFLFR,BVCFLH,BVCFREX,BVCORD
 N BVCFRIN,BVCFROM,BVCGLB,BVCGLBH,BVCGLFR,BVCHK,BVCNDFR,BVCNDTO,BVCNMMT,BVCNODE,BVCOK,BVCPCFR,BVCPCTO,BVCPRPT,BVCROOT,BVCSFTD,BVCTO,BVCTOEX,BVCTONM
 D INIT
 D AVAPCHK
 D COMPILE
 D:'POP RPT
 I BVCHK,'$$CONV S ^BVCHK(1,"OK")="" W !!,"The PCC Conversion may now be run."
 I +$$VERSION^XPDUTL("BVC")=2,$L($T(^BVCONV1)) W !,"D EN^BVCONV when you are ready",!!
 K ^XTMP("BVCHK")
 Q
 ;
CONV() ; conversion already done message
 N BVCFLG S BVCFLG=0
 I $P(^DD(9000001,.14,0),U,3)="VA(200,0" W !!,"The conversion appears to already be complete." S BVCFLG=1
 Q BVCFLG
 ;
AVAPCHK ; run ^AVAPCHK
 D EN^AVAPCHK
 Q
 ;
COMPILE ; check files
 U IO W !,"PRE-CONVERSION STATUS REPORT",!
 F BVCROOT="BVC3(","BVC6(","BVC16(" Q:POP  D
 .S BVCDA=0
 .S BVCFLFR=+$E(BVCROOT,4,5)
 .Q:'$D(@("BVC"_BVCFLFR))
 .S BVCGLFR="^DIC("_BVCFLFR_","
 .; loop through ^DIC(
 .S BVCDAFR=0
 .F  S BVCDAFR=$O(@(BVCGLFR_BVCDAFR_")")) Q:'BVCDAFR!POP  D  ; get from file IEN
 ..W "." S BVCDATO=+$S(BVCFLFR>3:$G(^DIC(16,BVCDAFR,"A3")),BVCFLFR=3:BVCDAFR,1:0) ; get ^VA 200 pointer through crosswalk . to file IEN
 ..S BVCORD=0,BVCFDTO=0,BVCFDNM=""
 ..I 'BVCDATO,BVCFLFR>3 D  Q
 ...S BVCERMS="NO PERSON FILE ""A3"" NODE"
 ...W !!,"Comparing file "_BVCFLFR_" entry: "_BVCDAFR_" to file 200 entry  "_BVCDATO W !!,BVCERMS
 ...S BVCDATO=BVCDAFR D BLD(1,"","") S BVCOK=0
 ..S BVCPRPT=$P($G(^VA(200,BVCDATO,0)),U,16) ;get backpointer for comparison
 ..I BVCPRPT,BVCPRPT'=BVCDAFR S BVCERMS="PERSON FILE PTR ERROR" D BLD(8,BVCPRPT,BVCDATO)
 ..; get field correspondences and verify match
 ..S BVCNODE=0
 ..F  S BVCNODE=$O(@(BVCROOT_BVCNODE_")")) Q:'BVCNODE!POP  D
 ...I IOSL-4<$Y D HDR0 Q:POP
 ...S BVCDATA=@(BVCROOT_BVCNODE_")")
 ...S BVCFDFR=$P(BVCDATA,U,2)
 ...S BVCFDTO=$P(BVCDATA,U,3)
 ...S BVCFDNM=$P(BVCDATA,U)
 ...S BVCORD=$P(BVCDATA,U,4)
 ...;W !?3,"Checking the "_BVCFDNM_" field"
 ...; get node and piece
 ...S BVCFROM=$P(^DD(BVCFLFR,BVCFDFR,0),U,4)
 ...S BVCTO=$P(^DD(200,BVCFDTO,0),U,4)
 ...S BVCNDFR=$P(BVCFROM,";"),BVCPCFR=$P(BVCFROM,";",2)
 ...S BVCNDTO=$P(BVCTO,";"),BVCPCTO=$P(BVCTO,";",2)
 ...; get field values
 ...S BVCFRIN=$P($G(@(BVCGLFR_BVCDAFR_","_BVCNDFR_")")),U,BVCPCFR) ;from file field data 
 ...S BVCFREX=$$VAL^XBDIQ1(BVCGLFR,BVCDAFR,BVCFDFR)
 ...S BVCTOEX=$$VAL^XBDIQ1(200,BVCDATO,BVCFDTO)
 ...I BVCFDFR=.01 D
 ....S BVCTONM=BVCTOEX
 ....I $L($G(BVCTOEX)) N I,J S I=0 F J=0:1 S I=$O(^VA(200,"B",BVCTOEX,I)) Q:I=""  I J,I S BVCERMS="DUPLICATE NAMES" D BLD(7,BVCFREX,BVCTOEX) Q
 ...I BVCFDNM="PROVIDER CLASS",$L($G(BVCTONM)),'$D(^VA(200,"AK.PROVIDER",BVCTONM,BVCDATO)) D AKPROV
 ...; compare values
 ...I BVCFREX'=BVCTOEX,$L(BVCFREX) D
 ....W:BVCDAFR'=$G(BVCDAFH) !!,"Comparing file "_BVCFLFR_" entry: "_BVCDAFR_" to file 200 entry  "_BVCDATO S BVCDAFH=BVCDAFR
 ....I BVCFDFR=.01 S BVCNMMT=1,BVCERMS="NAME MISMATCH" D BLD(2,BVCFREX,BVCTOEX)
 ....W !?3,"The "_BVCFDNM_" field does not match to file 200"
 ....W !?5,"From value: "_BVCFREX,?40,"To value: "_BVCTOEX
 ....I '$L(BVCTOEX),BVCFDNM'="PROVIDER CLASS",'BVCNMMT Q:$$STUFF
 ....I BVCFDFR'=.01 D
 .....I BVCNMMT D BLD1 Q
 .....S BVCERMS="DATA MISMATCH" D BLD(4,BVCFREX,BVCTOEX)
 ..S BVCNMMT=0
 Q
 ;
STUFF() ; put file 6 data in correspoding empty file 200 field
 N DIE,DR,DA,X
 W !?7,"Stuffing the field in file 200 with the value of "_BVCFREX
 I BVCFDNM="DEA#" D
 .N DIE,DR,DA ; delete to avoid a duplicate
 .S DIE=6,DA=BVCDAFR,DR=BVCFDFR_"///@" D ^DIE
 S DIE=200,DA=BVCDATO,DR=BVCFDTO_"///"_BVCFREX D ^DIE
 S BVCSFTD=$P(^VA(200,BVCDATO,BVCNDTO),U,BVCPCTO)=BVCFRIN
 W !?9,"The value has "_$S(BVCSFTD:"",1:"not ")_"been stuffed"
 I BVCSFTD S BVCERMS="FILE 200 VALUE CHANGE" D BLD(5,BVCFREX,BVCFREX)
 Q BVCSFTD
 ;
INIT F I="BVC3","BVC6","BVC16" K @I D
 .F J=1:1 S X=$P($T(@I+J),";;",2) Q:X="END"  S @I@(J)=X
 K ^XTMP("BVCHK"),^BVCHK(1,"OK")
 S ^XTMP("BVCHK",0)=$$HTFM^XLFDT($H+1)_U_DT_U_"PRE-CONVERSION COMPILE"
 S BVCNMMT=0,BVCHK=1
 S POP=0
 Q
 ;
BLD(BVCERNM,BVCFROM,BVCTO) ; build error global
 ;
 S BVCDAH=BVCDAFR
 S:BVCERNM=8 X=$P($G(^XTMP("BVCHK",BVCFLFR,BVCERNM,BVCDATO,BVCORD)),U,2),BVCDAFR=X_$E(",",$L(X)>0)_BVCDAFR
 S ^XTMP("BVCHK",BVCFLFR,BVCERNM,BVCDATO,BVCORD)=BVCERMS_U_BVCDAFR_U_BVCFDNM_U_BVCFROM_U_BVCTO
 S:BVCERNM<5 BVCHK=0
 S BVCDAFR=BVCDAH
 Q
 ;
BLD1 ; keep mismatch fields with mismatch names
 S ^XTMP("BVCHK",BVCFLFR,2,BVCDATO,.01,1,BVCORD)=BVCERMS_U_BVCDAFR_U_BVCFDNM_U_BVCFREX_U_BVCTOEX
 Q
 ;
DEV() ; get ouput device
 N POP,%ZIS S %ZIS="QM"
 D ^%ZIS
 I 'POP,$D(IO("Q")) D  S:'POP X=$$DEV
 .I IO=IO(0) W !!,"You can not queue a job to the home device or a slave printer..Try again",!!,*7 Q
 .S ZTDTH=$H,ZTRTN="EN1^BVCHK",ZTDESC="PRE-PCC CONVERSION CHECK" D ^%ZTLOAD I $G(ZTSK) S POP=1 W !,"The pre-PCC Conversion is task "_ZTSK
 Q POP
 ;
RPT ; print out report
 D HDR
 U IO S (BVCFLFR,BVCERNM,BVCDATO,BVCFDTO,POP)=""
 S (BVCFLH,BVCERH,BVCDAH,BVCFDH)=""
 S BVCGLB="^XTMP(""BVCHK"",0)",BVCGLBH=$E(BVCGLB,1,13)
 F  S BVCGLB=$Q(@BVCGLB) Q:$E(BVCGLB,1,$L(BVCGLBH))'=BVCGLBH!POP  D
 .S X=@BVCGLB
 .S BVCERMS=$P(X,U),BVCDAFR=$P(X,U,2),BVCFDNM=$P(X,U,3),BVCFROM=$P(X,U,4),BVCTO=$P(X,U,5)
 .S BVCERNM=$P($P(BVCGLB,",",3),","),BVCDATO=$P($P(BVCGLB,",",4),",")
 .I BVCERNM'=BVCERH  D SUBHDR S BVCERH=BVCERNM
 .W:BVCFDNM="NAME" !
 .I IOSL-4<$Y D HDR,SUBHDR Q:POP
 .S X=0 I BVCERNM=2,BVCFDNM'="NAME" S X=1
 .W !,BVCDATO,?8,BVCDAFR,?14+X,$E(BVCFDNM,1,15-X),?30,$E(BVCFROM,1,18),?50,$E(BVCTO,1,18)
 D ^%ZISC
 Q
 ;
RTN() ; press return to continue
 N POP,DIR S POP=0
 I $E(IOST,1,2)="C-",ION'="HFS" S DIR(0)="E" D ^DIR S POP=$D(DIRUT)
 Q POP
 ;
HDR ; report header
 S POP=$$RTN Q:POP
 W @IOF
 W !!,"Field comparisons between file "_BVCFLFR_" and 200 - Categorized Listing",!!
 Q
 ;
SUBHDR ; print subhdrs
 W !!,"Category: "_BVCERMS,!!
 W "200 DA",?8,"6 DA",?14,"FIELD NAME"
 I BVCERNM>1 W ?30,"FILE 6 VALUE",?50,"FILE 200 VALUE"
 W !
 Q
HDR0 ; report header
 S POP=$$RTN Q:POP
 W @IOF
 W !!,"Field comparisons between file "_BVCFLFR_" and 200 - Sequential Detail Listing",!!
 Q
 ;
AKPROV ; set AK.PROVIDER xref
 N BVCFLG,X S BVCFLG=0
 S BVCPRKY=$O(^DIC(19.1,"B","PROVIDER",0))
 S BVC51=$G(^VA(200,BVCDATO,51,BVCPRKY,0))
 I BVC51 D  ;no AK.PROVIDER but provider key assigned
 .N DA,DIK S DA=+BVC51,DA(1)=BVCDATO
 .S DIK="^VA(200,"_DA(1)_",51,",DIK(1)=".01^AC^AB^AK" D EN^DIK
 I 'BVC51,$L(BVCTOEX) D  ; no provider key but provider class so create the node
 .N BVCFDA S BVCFDA($J,200.051,"?+2,"_BVCDATO_",",.01)="`"_BVCPRKY
 .D UPDATE^DIE("E","BVCFDA($J)","BVCFDA(""ERR"")")
 I $D(^VA(200,"AK.PROVIDER",BVCTONM,BVCDATO)) D
 .S BVCERMS="AK.PROVIDER XREF CREATED" D BLD(6,BVCFREX,BVCTOEX)
 E  D
 .S BVCERMS="Does not hold the Provider Key" D BLD(3,BVCFREX,BVCTOEX)
 Q
 ;
BVC3 ; file 3 to file 200 mapping
 ;;END
 ;;NAME^0;1^0;1
 ;;SSN^0;2^0;2
 ;;END
 ;
BVC6 ; file 6 to file 200 mapping
 ;;NAME^.01^.01^0
 ;;INACTIVATION DATE^100^53.4^1
 ;;INITIALS^1^1^2
 ;;STREET ADDRESS 1^.111^.111^3
 ;;STREET ADDRESS 2^.112^.112^4
 ;;STREET ADDRESS 3^.113^.113^5
 ;;CITY^.114^.114^6
 ;;STATE^.115^.115^7
 ;;ZIP CODE^.116^.116^8
 ;;PROVIDER CLASS^2^53.5^9
 ;;AFFILIATION^9999999.01^9999999.01^10
 ;;CODE^9999999.02^9999999.02^11
 ;;IHS LOCAL CODE^9999999.05^9999999.05^11.5
 ;;MEDICARE PROVIDER NUMBER^9999999.06^9999999.06^12
 ;;MEDICAID PROVIDER NUMBER^9999999.07^9999999.07^13
 ;;UPIN NUMBER^9999999.08^9999999.08^14
 ;;DEA#^5^53.2^15
 ;;PROVIDER TYPE^3^53.6^16
 ;;VA#^6^53.3^99
 ;;END
 ;;IHS ADC INDEX^9999999.09^9999999.09
BVC16 ; file 16 to file 200 mapping
 ;;END
 ;
PRECMP ;EP precompile check
 I '$D(DUZ) W !!,"You must have the variable DUZ defined" Q
 I $$CONV W !,"But running this routine may identify places where correctIve action is needed."
 I '$D(^BVCHK(1,"OK")) W !!,"The pre-conversion routine (EN^BVCHK) may clear up many of the exceptions you may get.",!,"Please run the pre-conversion routine before this call."
 I $D(^BVCONV(0,"RUNNING")) W !!,"The conversion has already begun, so this compile is now prohibited." Q
 I '$L($T(^BVCONV1)) W !,"The conversion has completed already." Q
 K ^BVCONV1(1)
 N BVCPRCP,BVCRUN
 S BVCPRCP=1,BVCRUN=1
 D PR^BVCONV
 K ^BVCONV(1,"RUNNING")
 Q
 ;
CNT ; CONVERSION FILDS AND RECORD COUNTS
 N X,BVCSUB,BVCZERO,BVCGL,BVCREC,BVCCT S BVCCT=0
 W !,"FILE #",?15,"ROOT",?30,"RECORD COUNT"
 F BVCSUB=9000000:.01:9000099 S BVCGL=$G(^DIC(BVCSUB,0,"GL")) D:$L(BVCGL)
 .S BVCZERO=@(BVCGL_0_")"),X=""
 .S BVCREC=$P(BVCZERO,"^",3),X=$$PTR(BVCSUB,"DIC(6,") S:X BVCCT=BVCCT+BVCREC
 .W !,BVCSUB,?15,BVCGL,?30,BVCREC,?40,X
 W !!,"Total number of records to convert "_$FN(BVCCT,",")
 ;
 Q
 ;
PTR(SUB,STR)    ; find ptr fields
 N S,RTN S RTN="",S=0
 F  S S=$O(^DD(SUB,S)) Q:'S  D:$P($G(^DD(SUB,S,0)),"^",3)=STR
 .S RTN=RTN_$E(";",RTN>0)_S
 Q RTN
