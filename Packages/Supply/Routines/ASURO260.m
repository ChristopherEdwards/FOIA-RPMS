ASURO260 ; IHS/ITSC/LMH -S.A.M.S. REPORT 26 SORT ;   
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine sorts report 26 extracts into proper sequence so that the
 ;report can be formatted and printed.
 ;WAR 4/20/2000 - Made several changes. See original code in DEV or ask
 ;                Lucy Harmon or myself for hard copy.
 S ASUNW(4)=ASUV("RP26")
 S X=$O(ASUU("SST","")) Q:X']""
 S (ASUMK("E#","STA"),ASUX("STA"))=ASUL(2,"STA","E#")  ;WAR  4/20/2000
 S (ASUXSST,ASUX("SST"))=0
 I X="*ALL*" D  ;WAR 4/19/2000 Note:this is SUBstations not Stations.
 .F  S ASUXSST=$O(^ASUMK(ASUX("STA"),1,ASUXSST)) Q:ASUXSST=""  D
 ..S ASUX("SST")=$E(ASUXSST,1,5)
 ..D USER
 E  D
 .F  S ASUX("SST")=$O(ASUU("SST",ASUX("SST"))) Q:ASUX("SST")=""  D
 ..D USER
 K ASUMK,ASUMX,ASUMS,ASUC,ASUU,ASUC,ASUX
 Q
USER ;
 S ASUX("USR")=ASUX("SST")_"0000"
 S X=$O(ASUU("USR","")) Q:X']""
 I X="*ALL*" D
 .;WAR 4/19/2000 added IF statement to D ASURO261 
 .F  S ASUX("USR")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUX("USR"))) Q:ASUX("USR")'?1N.N  D
 ..I $E(ASUX("USR"),1,5)=$E(ASUX("SST"),1,5)  D ASURO261
 E  D
 .;WAR 4/21/2000 added next line - data entry person choose 'SELECTED
 .;            USERS', but did not succeed in entering a valid USER code
 .I $D(ASUU("USR",ASUX("SST"))) D
 ..F  S ASUX("USR")=$O(ASUU("USR",ASUX("SST"),ASUX("USR"))) Q:ASUX("USR")=""  D
 ...D ASURO261
 Q
ASURO261 ;
 S ASUMK("E#","REQ")=ASUX("USR")
 S ASUMK("E#","IDX")=0
 ;LMH changed next line 4/2000
 F ASUC("IDX")=1:1 S ASUMK("E#","IDX")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"))) Q:((ASUMK("E#","IDX")'?1N.N)!(ASUMK("E#","IDX")[999999)!(ASUMK("E#","REQ")'=ASUX("USR")))  D
 .Q:$G(^ASUMX(ASUMK("E#","IDX"),0))=""         ;LMH 4/2000
 .Q:$P(^ASUMX(ASUMK("E#","IDX"),0),U)[999999
 .W:ASUC("IDX")#20=0 "."
 .S ASUMS("E#","STA")=$G(ASUL(1,"AR","STA1"))
 .S:ASUMS("E#","STA")']"" ASUMS("E#","STA")=ASUMK("E#","STA")
 .D DIS^ASUMDIRM(ASUMS("E#","STA")) I Y<0 D
 ..S ASUMS("E#","STA")=$O(^ASUMS("C",ASUMK("E#","IDX"),""))
 .I '$D(^ASUMS("C",ASUMK("E#","IDX"),ASUMS("E#","STA"))) D
 ..S ASUMS("E#","STA")=$O(^ASUMS("C",ASUMK("E#","IDX"),""))
 .I ASUMS("E#","STA")']"" D  Q
 ..;W *7,!,"*** ERROR *** -Unable to find Station for Index # ",$E(ASUMK("E#","IDX"),3,8)," for to Sub Station ",$E(ASUMK("E#","STA"),3,5) LMH 4/24/2000
 .S ASUMS(2)=^ASUMS(ASUMS("E#","STA"),1,ASUMK("E#","IDX"),2)
 .S ASUMX(0)=^ASUMX(ASUMK("E#","IDX"),0)
 .S ASUMS("EOQ","TP")=$P(ASUMS(2),U,5)
 .S ASUMS("SLC")=$P(ASUMS(2),U)
 .S ASUMX("ACC")=$P(ASUMX(0),U,6)
 .S ASUMX("CAT")=$P(ASUMX(0),U,8)
 .S ASUMX("DESC")=$P(ASUMX(0),U,2)
 .I ASUMS("EOQ","TP")="Y" Q
 .I ASUMX("ACC")=1,ASUMX("CAT")="R" Q
 .I ASUMX("ACC")=1,ASUMX("CAT")="N" Q
 .S ASUX("ACCG")=$S(ASUMX("ACC")=1:1,ASUMX("ACC")=3:3,1:4)
 .I ASUMS("SLC")="H" D
 ..S ASUX("SLC")="H*"
 .E  D
 ..I ASUMS("SLC")="R" D
 ...S ASUX("SLC")="R*"
 ..E  D
 ...S ASUX("SLC")="Z*"
 .I +ASUV("RP26")=2 S ASUX("SLC")=ASUX("SLC")_ASUMX("CAT")
 .S ASUX("IDX")=$S(+ASUV("RP26")=3:ASUMK("E#","IDX"),1:ASUMX("DESC")_$E(ASUMK("E#","IDX"),3,8))
 .;S ^XTMP("ASUR","R26",ASUX("SST"),ASUX("USR"),ASUX("ACCG"),ASUX("SLC"),ASUX("IDX"))=ASUMK("E#","IDX")_U_ASUMS("E#","STA")     ;LMH 
 .S ^XTMP("ASUR","R26",ASUMS("E#","STA"),ASUX("USR"),ASUX("ACCG"),ASUX("SLC"),ASUX("IDX"))=ASUMK("E#","IDX")_U_ASUMK("E#","STA")
 .K X
 Q
