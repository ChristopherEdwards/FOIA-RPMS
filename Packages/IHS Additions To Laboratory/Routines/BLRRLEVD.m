BLRRLEVD ;cmi/anch/maw - BLR Reference Lab Event; Deleted code ; 03-Dec-2014 11:21 ; MAW
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
 ; The code below was deleted from BLRRLEVT, beginning at line 155.
 ; The code was originally commented out in BLRRLEVT, but BLRRLEVT
 ; became too large for the SAC, so the "commented out" code was moved
 ; here so that it could be preserved.
 ;
 Q
 ;
 ;S BLRRL("LOCI")=$G(LROLLOC)  ;cmi/maw 5/29/2007 added for internal location pointer to file 44
 ;S BLRRL("LOC")=$G(LRLLOC)
 ;S BLRRL("LOC")=$S($G(LROLLOC):$P($G(^SC(LROLLOC,0)),U),1:"")  ;4/3/2008 added for pointer to hosp location file
 ;S BLRRL("BI")=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL",0)),U,18)  ;NEW cmi/maw 2/25/2008 bi or unidirectional
 ;S BLRRL("ACC")=$G(LRACC)  ;accession number
 ;S BLRRL("UID")=$G(LRUID)  ;unique id
 ;S BLRRL("CDT")=$G(LRCDT)  ;collection date
 ;S BLRRL("ACCA")=$P(BLRRL("ACC")," ")  ;get accession abbreviation
 ;I $G(BLRRL("ACCA"))="" W !,"No valid accession area prefix" Q
 ;S BLR("ACCAREA")=$O(^LRO(68,"B",BLRRL("ACCA"),0))  ;get ien of accession area
 ;I BLR("ACCAREA")=""  W !,"Accession Area is not a sendout area"  ;don't proceed if not an SO area
 ;I '$D(^BLRSITE("ACC",BLR("ACCAREA"),DUZ(2),BLRRL("RL"))) D  Q  ;2/25/2008 moved to BLR MASTER CONTROL FILE quit when not a sendout area
 ;. W !,"Accession area is not setup in the BLR MASTER CONTROL file"
 ;S BLRRL("ORDPRV")=$G(LRPRAC)  ;ordering provider
 ;S (BLRTSTDA,BLRRL("TSTDA"))=+$G(LRTS)
 ;K BLRRL(BLRTSTDA)  ;kill off array from previous accession
 ;K BLRRL("ORDPUPIN"),BLRRL("ORDPNM")  ;maw 5/10/06
 ;S (BLRRL("UPINNPI"),BLRRL(BLRTSTDA,"UPINNPI"))="U"  ;upin or NPI
 ;I BLRRL("ORDPRV")]"" D  ;setup provider array
 ;. S BLRRL("ORDPUPIN")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),9999999.08)  ;maw 5/10/06
 ;. S BLRRL("ORDPNPI")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),41.99)  ;cmi/maw 2/26/2008 NPI
 ;. S BLRRL("ORDPNM")=$$VAL^XBDIQ1(200,BLRRL("ORDPRV"),.01)
 ;. S BLRRL("ORDPNM")=$P(BLRRL("ORDPNM"),",")_"^"_$P($P(BLRRL("ORDPNM"),",",2)," ")
 ;. S BLRRL(BLRTSTDA,"ORDP")=BLRRL("ORDPUPIN")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 ;. S $P(BLRRL(BLRTSTDA,"ORDP"),U,8)="U"  ;cmi/maw 3/12/09 labcorp
 ;. S BLRRL("ORDP")=BLRRL("ORDPUPIN")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 ;. S $P(BLRRL("ORDP"),U,8)="U"  ;cmi/maw 3/12/09 labcorp
 ;. I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,19)="N" D
 ;.. S (BLRRL("UPINNPI"),BLRRL(BLRTSTDA,"UPINNPI"))="N"
 ;.. S BLRRL(BLRTSTDA,"ORDP")=BLRRL("ORDPNPI")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 ;.. S $P(BLRRL(BLRTSTDA,"ORDP"),U,8)="N"  ;cmi/maw 3/12/09 labcorp
 ;.. S BLRRL("ORDP")=BLRRL("ORDPNPI")_"^"_BLRRL("ORDPNM")  ;cmi/maw 3/4/09 labcorp
 ;.. S $P(BLRRL("ORDP"),U,8)="N"  ;cmi/maw 3/12/09 labcorp
 ;S BLRTSTI=+$G(LRTS)  ;get test ien
 ;I '$D(^LAB(60,BLRTS,8,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)) D  Q  ;quit if no accession area
 ;. W !,"Institution "_$P($G(^DIC(4,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U)_" is not setup in the Accession Area multiple of file 60"
 ;S BLRAREA=$P($G(^LAB(60,BLRTSTI,8,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U,2)  ;get acc area
 ;I BLRAREA="" W !,"Accession Area field is not setup in file 60 for "_$P($G(^DIC(4,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U) Q  ;quit if accession area field is null
 ;I BLRAREA'=BLR("ACCAREA") W !,"Accession Area in file 60 is not a sendout accession area" Q  ;quit if test acc area is not SO area
 ;S BLRRL(BLRTSTDA,"CDT")=$G(LRCDT)  ;collection date
 ;S BLRRL("TNAME")=$P($G(^LAB(60,BLRTSTI,0)),U)  ;get test name
 ;S BLRRL("ABBR")=$P($G(^LRO(68,BLRAREA,0)),U,11)  ;get area abbr
 ;S BLRRL("TST")=BLRTSTI  ;get test ien
 ;S BLRRL("TCODEE")=$$CODE(BLRRL("RL"),BLRRL("TST"))  ;lookup test code
 ;S BLRRL("TCODE")=$P(BLRRL("TCODEE"),U)  ;test code
 ;S BLRRL("SHIPCOND")=$P(BLRRL("TCODEE"),U,2)  ;shipping condition
 ;I $G(BLRRL("TCODE"))=0 K BLRRL(BLRTSTDA) Q  ;quit if no test code
 ;S BLRRL(BLRTSTDA,"ACC")=$G(LRACC)  ;setup acc array for OBR
 ;S BLRRL(BLRTSTDA,"UID")=$G(LRUID)
 ;S BLRRL("TCNM")=BLRRL("TCODE")_U_BLRRL("TNAME")  ;test arry
 ;S BLRRL(BLRTSTDA,"TCNM")=BLRRL("TCODE")_U_BLRRL("TNAME")  ;test arry
 ;I $G(BLRRL("RLE"))="LABCORP" D
 ;. S BLRRL("TCNM")=BLRRL("TCNM")_"^L"
 ;. S BLRRL(BLRTSTDA,"TCNM")=BLRRL(BLRTSTDA,"TCNM")_"^L"
 ;S BLRRL("URGHL")=$S($G(LRURG):$P($G(^LAB(62.05,LRURG,0)),U,4),1:"")
 ;S BLRRL("URG")=$G(LRURG)
 ;S BLRRL("ODT")=$G(LRODT)
 ;S BLRRL(BLRTSTDA,"SAMP")=$G(LRSAMP)
 ;S BLRRL("SAMP")=$G(LRSAMP)
 ;S BLRRL(BLRTSTDA,"SRC")=$G(LRSPEC)
 ;S BLRRL("SRC")=$G(LRSPEC)
 ;I $G(LRSPEC) S (BLRRL(BLRTSTDA,"SRC"),BLRRL("SRC"))=$P($G(^LAB(61,LRSPEC,0)),U)
 ;S BLRRL("ORD")=$G(LRORD)
 ;S BLRRL(BLRTSTDA,"ORD")=$G(LRORD)
 ;S BLRCM=0 F  S BLRCM=$O(BLRRLC(BLRTSTDA,BLRCM)) Q:'BLRCM  D
 ;. S BLRRL(BLRTSTDA,"COMMENT",BLRCM)=$G(BLRRLC(BLRTSTDA,BLRCM))
 ;. S BLRRL("COMMENT",BLRCM)=$G(BLRRLC(BLRTSTDA,BLRCM))
 Q
