BWMDEX1 ;IHS/CIA/DKM - Convert MDE data to export format;21-Oct-2003 10:03;PLS
 ;;2.0;WOMEN'S HEALTH;**9**;MAY 16, 1996
EXPORT(BWFMT,BWIEN,BWGBL,BWNEW) ; EP
 N BWDATA,BWLN,BWSEQ,BWDFN,BWFAC,BWPT,BWDT,BWPAP,BWMAM,BWX,X,Y,Z,P
 K:$G(BWNEW) @BWGBL
 ; Load formatting information into BWFMT if not already done.
 I $D(BWFMT)<10 D
 .S X=0,BWFMT("LN")=+$P(^BWFMT(BWFMT,0),U,2)
 .F  S X=$O(^BWFMT(BWFMT,1,X)) Q:'X  S Y=^(X,0) D
 ..S BWSEQ=$P(Y,U,7)*1000000+X
 ..F Z=2:1:9 S BWFMT(BWSEQ,Z)=$P(Y,U,Z)
 ..S:'$L(BWFMT(BWSEQ,8)) BWFMT(BWSEQ,8)=" "
 ..S BWFMT(BWSEQ,"PX")=$G(^BWFMT(BWFMT,1,X,1)),BWFMT(BWSEQ,"SX")=$G(^(2)),BWFMT(BWSEQ,"TX")=$G(^(3)),BWFMT(BWSEQ,"SC")=$G(^(4))
 ..M BWFMT(BWSEQ,"PR")=^BWFMT(BWFMT,1,X,20,"B")
 ..K:BWFMT(BWSEQ,9)!'$L(BWFMT(BWSEQ,"TX")) BWFMT(BWSEQ)
 ; Now loop through formatting data
 D LOADDATA^BWMDEX(BWIEN)
 S BWLN=+$O(@BWGBL@(""),-1),(BWSEQ,BWX)="",$E(BWX,BWFMT("LN"))=" "
 F  S BWSEQ=$O(BWFMT(BWSEQ)) Q:BWSEQ'=+BWSEQ  D
 .I $D(BWFMT(BWSEQ,"PR"))>1,'$D(BWFMT(BWSEQ,"PR",BWPT)) Q
 .I $L(BWFMT(BWSEQ,"SC")) X BWFMT(BWSEQ,"SC") Q:'$T
 .K X
 .X BWFMT(BWSEQ,"TX")
 .S Z=$L($G(X))
 .Q:'Z
 .S:$L(BWFMT(BWSEQ,2)) BWDATA(BWFMT(BWSEQ,2))=X
 .S Y=BWFMT(BWSEQ,4)
 .I Y,Y'=Z D
 ..I Z>Y S X=$E(X,1,Y)
 ..E  S Z=BWFMT(BWSEQ,6),P=BWFMT(BWSEQ,8),X=$S(Z=1:$$RJ^XLFSTR(X,Y,P),Z=2:$$LJ^XLFSTR(X,Y,P),Z=3:$$CJ^XLFSTR(X,Y,P),1:X)
 .S:$L(X) X=BWFMT(BWSEQ,"PX")_X_BWFMT(BWSEQ,"SX")
 .S Y=BWFMT(BWSEQ,3)
 .I Y S $E(BWX,Y,Y+$L(X)-1)=X
 .E  S BWX=BWX_X
 .D:BWFMT(BWSEQ,5) OUTLN
OUTLN S:$L(BWX) BWLN=BWLN+1,@BWGBL@(BWLN)=BWX
 S BWX="",$E(BWX,BWFMT("LN"))=" "
 Q
 ; Return data from specified node and piece
PC(BWN,BWP,BWT) ;
 Q $$PC^BWMDEX(.BWN,.BWP,.BWT)
 ; Open HFS device
 ; .BWFILE = Name of host file (use default if not specified)
 ; .BWPATH = Returned as the path to the host file
 ;  BWTST  = If nonzero, close host file after successful open.
HFSOPEN(BWFILE,BWPATH,BWTST) ; EP
 D GETFILE(.BWPATH,.BWFILE)
 I 'BWPOP D
 .S BWPOP=$$OPEN^%ZISH(BWPATH,BWFILE,"W")
 .I 'BWPOP,$G(BWTST) D ^%ZISC
 .I BWPOP,'$D(BWSILENT) D
 ..W !!?5,"* Save to Host File Server FAILED. Contact your site manager."
 ..D DIRZ^BWUTLP
 ;IHS exemption approved on 10/20/2003
 Q:$Q BWPOP
 Q
 ; Return output filename and path
GETFILE(BWPATH,BWFILE) ;
 N X
 S X=$G(^BWSITE(DUZ(2),0)),BWPATH=$P(X,U,14)
 I '$L(BWPATH) D
 .S BWPOP=1
 .W:'$D(BWSILENT) !!?5,"* No path defined in site file.  Contact your site manager."
 I '$D(BWFILE) D
 .S BWFILE=$P(X,U,13)_$E(DT,4,5)_$E(DT,2,3)_$S('$G(BWADHOC):$$CDCVER^BWMDEX2,1:"LC")
 .S:'$D(BWSILENT) BWFILE=$$DIR^BWUTLP("F","Name of output file",BWFILE,"Name of file to receive output.",.BWPOP)
 Q
 ; Send extract results to output device
OUTPUT(BWGBL,BWADHOC,BWFILE) ; EP
 N BWCOUNT,BWHFS,BWPATH,X
 I '$D(@BWGBL) D:'$D(BWSILENT)  Q
 .W !!?5,"No records to be exported."
 .D DIRZ^BWUTLP
 ;
 ; If this is an adhoc query then offer to write file out to alternate device.
 I '$D(BWSILENT),BWADHOC D  Q:BWPOP
 .W !!,"Do you wish to save your results to a file or send them to"
 .W !,"an alternate device?"
 .S BWHFS=$$DIR^BWUTLP("SA^0:OTHER;1:FILE","Select FILE or OTHER: ","FILE",1,.BWPOP)
 E  S BWHFS=1
 I BWHFS D
 .D HFSOPEN(.BWFILE,.BWPATH)
 E  D
 .D ^%ZIS
 .S BWPOP=POP
 Q:BWPOP
 U IO
 S (X,BWCOUNT)=0
 F BWCOUNT=0:1 S X=$O(@BWGBL@(X)) Q:'X  W @BWGBL@(X),!
 D ^%ZISC
 D:BWHFS SHOWDLG^BWUTLP(12_U_BWFILE_U_BWPATH)
 ; Offer to log if not an ad hoc extract
 I 'BWADHOC D
 .I '$D(BWSILENT),'$$DIRYN^BWUTLP(6,"YES",7) Q
 .D FILE^BWFMAN(9002086.92,".02////"_BWCOUNT_";.03////"_BWPATH_BWFILE,"ML",DT,9002086,.X)
 .D:X<0 SHOWDLG^BWUTLP(-5)
 Q
