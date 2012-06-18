BMXADO2 ; IHS/CIHA/GIS - BMX ADO RECORDSET UTILS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
GEN(BMXY,BMXF) ;EP - Generate an ADO Schema string from a list of fields
 ;BMXY Is an out-parameter called by reference.
 ;On return, BMXY will be a zero-based one-dimensional array each node of which will
 ;contain the schema corresponding to the fields info in BMXF
 ;
 ;BMXF is an in-parameter called by reference.
 ;On input, BMXF will contain the field info on which to build the schema string.
 ;
 ;Field info in BMXF is arranged in a zero-based one-dimensional array.
 ;Node 0 of BMXF contains the KEYFIELDNAME^FILENUMBER^READONLY
 ;where KEYFIELDNAME is the name of the unique key field in the database and
 ;FILENUMBER is the FileMan file number and
 ;READONLY denotes whether the entire recordset is updateable.
 ;
 ;Each subsequent node of the BMXF arrray contains field info in the form
 ;1FILE#^2FIELD#^3LENGTH^4DATATYPE^5ALIAS^6READONLY^7KEYFIELD^8NULLOK
 ;If FILE# AND FIELD# are defined, the LENGTH and DATATYPE will be taken from the FileMan data dictionary
 ;If ALIAS is defined, the schema string will use ALIAS as the column name
 ;READONLY, KEYFIELD and NULLOK are binary fields.  Note that there should be only one field
 ;in the recordset having KEYFIELD=TRUE
 ;
 ;New column info format is @@@meta@@@KEYFIELD|FILE#
 ;   For each field: ^1FILE#|2FIELD#|3DATATYPE|4LENGTH|5FIELDNAME|6READONLY|7KEYFIELD|8NULL ALLOWED
 ;example:
 ;BMXY(0)="@@@meta@@@BMXIEN|2160010^"
 ;BMXY(1)="2160010|.001|I|10|BMXIEN|TRUE|TRUE|FALSE^"
 ;
 S BMXY(0)="@@@meta@@@"_$G(BMXF(0))
 N BMXI,BMXS,BMXFM,BMXDD,BMXTYP,BMXLEN,BMXLEN2,BMXNAM,BMXKEY,BMXREAD,BMXNULL
 S BMXI=0
 F  S BMXI=$O(BMXF(BMXI)) Q:'+BMXI  D
 . N BMXFM,BMXDD,BMXTYP,BMXLEN,BMXLEN2,BMXNAM,BMXKEY,BMXREAD,BMXNULL
 . S (BMXDD,BMXTYP,BMXLEN,BMXLEN2,BMXNAM,BMXKEY,BMXREAD,BMXNULL)=""
 . S BMXFM=0 ;Flag indicating whether BMXF(BMXI) is a FileMan field
 . S BMXY(BMXI)=""
 . I BMXF(BMXI) S BMXY(BMXI)=$P(BMXF(BMXI),U,1,2) S BMXFM=1
 . I BMXFM D  ;Look in ^DD for attributes
 . . S BMXDD=$G(^DD($P(BMXF(BMXI),U),$P(BMXF(BMXI),U,2),0))
 . . ;column name
 . . S BMXNAM=$P(BMXDD,U)
 . . S BMXNAM=$TR(BMXNAM," ","_")
 . . ;Data type
 . . I $P(BMXDD,U,2)["P" S BMXDD=$$PTYPE(BMXDD)
 . . S BMXTYP=$P(BMXDD,U,2)
 . . S BMXTYP=$S(BMXTYP["F":"T",BMXTYP["S":"T",BMXTYP["D":"D")
 . . I BMXTYP["N" S BMXTYP=$S($P(BMXTYP,",",2)>0:"N",1:"I")
 . . ;default columnn lengths based on type
 . . I BMXTYP="N"!(BMXTYP="I") S BMXLEN=$P(BMXDD,U,2),BMXLEN=$P(BMXLEN,","),BMXLEN=$E(BMXLEN,3,$L(BMXLEN))
 . . I BMXTYP="I" S BMXLEN2=$P(BMXDD,U,2),BMXLEN2=$P(BMXLEN,",",2),BMXLEN=BMXLEN+BMXLEN2+1
 . . I BMXTYP="T" S BMXLEN=0
 . . I BMXTYP="D" S BMXLEN=30
 . . S BMXNULL="TRUE" S:$P(BMXDD,U,2)["R" BMXNULL="FALSE"
 . ;Look in BMXF for user-specified attributes
 . S:$P(BMXF(BMXI),U,5)]"" BMXNAM=$P(BMXF(BMXI),U,5) ;Alias
 . ;Set KEY, NULL and READONLY
 . S BMXNULL="TRUE",BMXREAD="TRUE",BMXKEY="FALSE"
 . I $P(BMXF(BMXI),U,7)="TRUE" S BMXKEY="TRUE",BMXNULL="FALSE",BMXREAD="TRUE"
 . E  S:$P(BMXF(BMXI),U,8)]"" BMXNULL=$P(BMXF(BMXI),U,8) S:$P(BMXF(BMXI),U,6)]"" BMXREAD=$P(BMXF(BMXI),U,6)
 . ;Set BMXY node
 . S $P(BMXY(BMXI),"|",3)=BMXTYP
 . S $P(BMXY(BMXI),"|",4)=BMXLEN
 . S $P(BMXY(BMXI),"|",5)=BMXNAM
 . S $P(BMXY(BMXI),"|",6)=BMXREAD
 . S $P(BMXY(BMXI),"|",7)=BMXKEY
 . S $P(BMXY(BMXI),"|",8)=BMXNULL
 ;
 Q
PTYPE(BMXDD) ;
 ;Traverse pointer chain to retrieve data type of pointed-to field
 N BMXFILE
 I $P(BMXDD,U,2)'["P" Q BMXDD
 S BMXFILE=$P(BMXDD,U,2)
 S BMXFILE=+$P(BMXFILE,"P",2)
 S BMXDD=$G(^DD(BMXFILE,".01",0))
 S BMXDD=$$PTYPE(BMXDD)
 Q BMXDD
