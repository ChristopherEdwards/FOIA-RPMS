INHSYS06 ;JPD; 26 Oct 95 14:49;gis sys con data installation utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
PASS3 ;Pass 3 Update with old selected existing fields
 N %FLNM,%FLDNM,%IEN,%ROOT,%NBFR,%PIECE,%DD,%NODE,%UTBFR,INSV,INROOT
 N %SAV
 S %PASS=3
 D SAVE^INHSYSUT(.%SAV)
 S %NBFR="^UTILITY(""INHSYSUT"","_$J_","
 S %FLNM="" F  S %FLNM=$O(%SAV(%FLNM)) Q:%FLNM=""  D
 .S %ROOT=^DIC($$UP^INHSYSUT(%FLNM),0,"GL")
 .S %FLDNM="" F  S %FLDNM=$O(%SAV(%FLNM,%FLDNM)) Q:%FLDNM=""  D
 ..S %IEN=""
 ..F  S %IEN=$O(^UTILITY("INHSYSUT",$J,%FLNM,%IEN)) Q:%IEN=""  D
 ...I '$D(@(%ROOT_%IEN_",0)")) W !,"error, file entry"_%ROOT_%IEN_" and data does not exist!" Q
 ...I '$D(^DD(%FLNM,%FLDNM)) W !,"Note.. field not in Data Dictionary. File "_%FLNM_" Field "_%FLDNM,!," Entry ",$P(@(%ROOT_%IEN_",0)"),U)_" may be missing data." Q
 ...S %DD=^DD(%FLNM,%FLDNM,0),%NODE=$P($P(%DD,U,4),";")
 ...;If word proc field
 ...I $$WP^INHSYSUT(%FLNM,%FLDNM) D WORD^INHSYS05(%NBFR,%ROOT,%IEN,%NODE,0) Q
 ...;If multiple
 ...I $P($P(^DD(%FLNM,%FLDNM,0),U,4),";",2)=0 D MULT(%ROOT,%IEN,%FLNM,%FLDNM,%NBFR,.INSV) Q
 ...;all other fields
 ...S %PIECE=$P($P(%DD,U,4),";",2)
 ...S %UTBFR=%NBFR_%FLNM_","_%IEN_","_%NODE_","
 ...D DATA^INHSYSUT($$RUT^INHSYSUT(%UTBFR),%PIECE,.%DATA)
 ...I %DATA'="" D FILE^INHSYSUT(%IEN,%DATA,%FLDNM,%ROOT,0) S INSV(%ROOT,%IEN)=""
 I $D(INSV) W !,"Re-Indexing files"
 S INROOT="",DA=""
 F  S INROOT=$O(INSV(INROOT)) Q:INROOT=""  F  S DA=$O(INSV(INROOT,DA)) Q:DA=""  D
 .S DIK=INROOT D IX^DIK
 W !,"Pass 3 Done!"
 Q
MULT(%ROOT,DA,%FLNM,%FLDNM,%NBFR,INSV) ;
 ; Input:
 ;  %ROOT - Root node of global to stuff
 ;  DA - ien
 ;  %FLNM - Fileman File number
 ;  %FLDNM - Fileman Field number
 ;  %NBFR - Utility global
 ;  INSV - list of files and iens that get updated
 N %NODE,%X,%Y
 S %NODE=$P($P(^DD(%FLNM,%FLDNM,0),U,4),";")
 ;S %X=%NBFR_%FLNM_","_DA_","_%NODE_","
 ;S %Y=%ROOT_DA_","_%NODE_","
 ;D %XY^%RCR
 S %X=%NBFR_%FLNM_","_DA_","_%NODE_")",%Y=%ROOT_DA_","_%NODE_")"
 M @%Y=@%X
 S INSV(%ROOT,DA)=""
 Q
WORD ;
 Q
DUPCK ;Duplicate cross "B" Cross reference checker"
 N INA,INB,INFOUND,INFST
 F %ROOT="^INRHT(","^INRHD(","^INRHS(","^INTHPC(","^INTHL7M(","^INTHL7S(","^INTHL7F(","^INVD(","^INTHL7FT(" D
 .S INA=""
 .F  S INA=$O(@(%ROOT_"""B"","""_INA_""")")) Q:INA=""  D
 ..S INFOUND=0,INFST=""
 ..S INB="" F  S INB=$O(@(%ROOT_"""B"","""_INA_""","""_INB_""")")) Q:INB=""  D
 ...I INFOUND D
 ....W !!,"Duplicate ""B"" CROSS REFERENCE    "_%ROOT_"""B"""_","_""""_INA_""""_","_""""_INFST_""""_")"
 ....W !,"Duplicate ""B"" CROSS REFERENCE    "_%ROOT_"""B"""_","_""""_INA_""""_","_""""_INB_""""_")"
 ...S INFST=INB,INFOUND=1
 Q
PASS4 ;Recompile entries from interface script file
 N INIEN,SCR,INX
 S %PASS=4
 W !,"Recompiling Scripts - Pass 4"
 S INIEN=0 F  S INIEN=$O(^UTILITY("INHSYS",$J,4006,INIEN)) Q:'INIEN  D
 .S INX=$P(^UTILITY("INHSYS",$J,4006,INIEN,0),U) Q:INX=""
 .S SCR=$O(^INRHS("B",INX,"")) Q:SCR=""
 .D EN^INHSZ
 W !,"Pass 4 complete!"
 Q
