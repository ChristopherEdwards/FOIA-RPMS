BLRP22PC ; IHS/OIT/MKK - IHS Lab Patch 1022 Post Install checksum checker ; 3070215.080303
 ;;5.2;LR;**1022**;September 20, 2007
 ;;
 ;; Cloned from LRNTEG created by Kernel.  The reason this version was created
 ;; is to make sure the site's LRNTEG routine is NOT over-written.
 ;; 
 ;LRNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3070215.080303
 ;;0.0;;**1022**;
 ;;7.3;3070215.080303
EP ; Start here
 S XT4="I 1",X=$T(+9)
 W !!
 W "IHS Lab Patch 1022 Checksum routine"
 W !
 W ?5,"Run Date: ",$TR($$HTE^XLFDT($H,"2MPZ"),"@"," ")
 W !!
 NEW CSSTR                   ; Checksum String
 NEW STR                     ; String used to hold any errors
 NEW ERR                     ; Error Count
 NEW RCNT                    ; Routine Count
 NEW SSTR                    ; String to hold $S results
 S (ERR,RCNT)=0
 S CSSTR="Routine"
 S $E(CSSTR,11)="Checksum"
 S $E(CSSTR,25)="Status"
 D MES^XPDUTL(CSSTR)
 D MES^XPDUTL(" ")
CONT ; 
 F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""!($P(XT2,";",2)="")  D
 . S X=$P(XT2,";",2),XT3=$P(XT2,";",4)
 . X XT4 I '$T Q
 . S RCNT=RCNT+1
 . K CSSTR
 . S CSSTR=X
 . X ^%ZOSF("RSUM")
 . S $E(CSSTR,11)=XT3
 . S SSTR=$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_Y_", off by "_(Y-XT3),1:"ok")
 . S $E(CSSTR,25)=SSTR
 . D MES^XPDUTL(CSSTR)
 . I SSTR="ok" Q
 . ;
 . ; Checksum error detected
 . S ERR=ERR+1
 . S ERR(ERR)=$$LJ^XLFSTR(X,8)_$J("",8)_$J(XT3,8)_$J("",10)_$J(Y,8)_$J("",10)_$J((Y-XT3),8)
 ;
 W !!,"Number of Routines = ",RCNT,!
 I ERR<1 W !,"No Checksum Errors detected",!
 I ERR>0 D RPTERROR
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4
 W !
 Q
 ;
 ; Checksum Errors detected: produce report and send E-mail to LMI Mail Group
RPTERROR ;
 NEW NUMAGREE
 S NUMAGREE=$S(ERR>1:"Errors",1:"Error")
 W !,ERR," Checksum ",NUMAGREE," detected",!!
 ;
 NEW LINECNT,HOWMANY,RTNN
 K STR
 S LINECNT=1
 D ADDLINE($TR($J("",65)," ","*"),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("IHS Lab Patch 1022",65),.STR,.LINECNT)
 S HOWMANY=$S(ERR>1:"Errors",1:"Error")
 S RTNN=$S(ERR>1:"Routines",1:"Routine")
 D ADDLINE($$CJ^XLFSTR("Systems Environment "_HOWMANY_" Detected.",65),.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR(RTNN_" with CHECKSUM "_HOWMANY,65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($J("",3)_$RE($J($RE(RTNN),8))_$J("",8)_"Checksum"_$J("",8)_"Calculated"_$J("",9)_$J("Off by",9),.STR,.LINECNT)
 D ADDLINE($J("",3)_"--------"_$J("",8)_"--------"_$J("",8)_"----------"_$J("",9)_$J("------",9),.STR,.LINECNT)
 S ERR=0
 F  S ERR=$O(ERR(ERR))  Q:ERR=""  D
 . D ADDLINE($J("",3)_$G(ERR(ERR)),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Please print/capture this screen and",65),.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("notify the Support Center at",65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("1-999-999-9999.",65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($G(STR(1)),.STR,.LINECNT)
 D BMES^XPDUTL(.STR)
 ;
 D SENDMAIL("CHECKSUM ERROR DETECTED",.STR)
 Q
 ;
 ; Routine to build STR array for display
ADDLINE(DISPSTR,ARRAY,COUNTER) ;
 S ARRAY(COUNTER)=DISPSTR
 S COUNTER=COUNTER+1
 Q
 ;
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
 ;
SENDMAIL(SUBJECT,MAILMSG) ;
 D KILL^XM                    ; Kill any MAILMAN variables
 N XMSUB,XMTO,XMINSTR,XMZ
 I '$G(DUZ) N DUZ D DUZ^XUP(.5)
 S XMSUB=SUBJECT
 S XMTO="G.LMI"
 S XMINSTR("FROM")=.5         ; POSTMASTER DUZ
 S XMINSTR("ADDR FLAGS")="R"  ; Ignore any restrictions (domain closed or protected by security key)
 S XMZ=""                     ; Initialize variable
 D SENDMSG^XMXAPI(DUZ,XMSUB,"MAILMSG",XMTO,.XMINSTR,.XMZ)
 I $G(XMZ)="" D
 . W !!,"SENDMSG^XMXAPI failed",!!
 ;
 K X,XMDUZ,XMSUB,XMTEXT,Y     ; Cleanup
 Q
 ;
ROU ;;
 ;BLR6249P;;5602469
 ;BLRP22PC;;6684207
 ;BLRALBA;;8668467
 ;BLRBBDDC;;3499457
 ;BLRCHGER;;1218264
 ;BLRCHGPL;;16494994
 ;BLRCHGPW;;6582379
 ;BLRESIGR;;13829242
 ;BLRESRCD;;2761624
 ;BLRESRNS;;2242512
 ;BLREXECU;;2586438
 ;BLRGMENU;;10723299
 ;BLRLABLC;;5552614
 ;BLRLINK2;;7459876
 ;BLRLINK3;;12391185
 ;BLRMERG2;;10638523
 ;BLRMPRL;;1077826
 ;BLRPCCVC;;2552930
 ;BLRPRE22;;16487202
 ;BLRRIIN;;3545940
 ;BLRRIIN1;;10593073
 ;BLRRIIN2;;12408792
 ;BLRSHDRC;;16738784
 ;BLRUTIL2;;10039542
 ;LR287;;5220915
 ;LR302;;7036526
 ;LR302A;;4415522
 ;LR302P;;3800106
 ;LR302PO;;9375744
 ;LR302POA;;2988034
 ;LR305;;5011529
 ;LR307;;2107378
 ;LR313;;4332772
 ;LR7OF1;;13628614
 ;LR7OF3;;9995500
 ;LR7OGM;;8016851
 ;LR7OGMC;;5100828
 ;LR7OGMM;;4440747
 ;LR7OGMU;;1286392
 ;LR7OR1;;12788388
 ;LR7OU0;;5520184
 ;LRCAPDAR;;7335453
 ;LRCE;;14020950
 ;LRDAGE;;1454485
 ;LRDPA;;7960268
 ;LRDPA1;;7381205
 ;LRDPA2;;5207850
 ;LREGFR;;3965285
 ;LRLABEL;;1176923
 ;LRLABLIO;;4962324
 ;LRMIPSU;;6418915
 ;LRNTEG;;4270906
 ;LRNTEG0;;4298995
 ;LRNTEG01;;4241836
 ;LRNTEG02;;4219835
 ;LRNTEG03;;4175643
 ;LRNTEG04;;4208853
 ;LRNTEG05;;4223141
 ;LRNTEG06;;4237104
 ;LRNTEG07;;4244117
 ;LRNTEG08;;4226241
 ;LRNTEG09;;4162042
 ;LRNTEG010;;3637375
 ;LRRP1;;9653615
 ;LRRP2;;17514598
 ;LRTOCOST;;25358415
 ;LRUPAC;;5916352
 ;LRUPACA;;12631718
 ;LRVR4;;9099233
 ;LRWRKIN1;;13404466
 ;LRWRKINC;;22516225
 ;;;
